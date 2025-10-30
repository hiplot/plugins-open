# mofa2_cll_pipeline_no_prediction.R
# Author: Developer
# Purpose: Modular MOFA+ pipeline for CLL-like multi-omics data (without imputation/prediction)

# ----------------------------
# 0. 初始化：创建 result 目录
# ----------------------------
setup_output_dir <- function(output_dir = "result") {
  if (!dir.exists(output_dir)) {
    dir.create(file.path(output_dir, "model"), recursive = TRUE)
    dir.create(file.path(output_dir, "plots"))
    dir.create(file.path(output_dir, "tables"))
    # Removed imputed_data dir as it's no longer needed
  }
  return(output_dir)
}

# ----------------------------
# 1. 加载数据
# ----------------------------
load_cll_data <- function(use_example = TRUE, data_path = NULL, meta_path = NULL) {
  library(MOFA2)
  library(MOFAdata)
  if (use_example) {
    utils::data("CLL_data")
    CLL_data <- CLL_data
    # Note: This download might be slow or fail; consider local caching
    tryCatch({
      CLL_metadata <- data.table::fread("ftp://ftp.ebi.ac.uk/pub/databases/mofa/cll_vignette/sample_metadata.txt")
    }, error = function(e) {
      stop("Failed to download metadata. Please ensure internet connection and FTP access. Error: ", e$message)
    })
  } else {
    # User can extend: load from local paths
    stop("Custom data loading not implemented yet.")
  }
  return(list(data = CLL_data, metadata = CLL_metadata))
}

# ----------------------------
# 2. 构建并训练 MOFA+ 模型
# ----------------------------
build_mofa_model <- function(data_list, output_dir = "result", K = 15, seed = 42) {
  library(MOFA2)
  
  # Create object
  mofa_obj <- create_mofa(data_list)
  
  # Set options
  data_opts <- get_default_data_options(mofa_obj)
  model_opts <- get_default_model_options(mofa_obj)
  model_opts$num_factors <- K
  train_opts <- get_default_training_options(mofa_obj)
  train_opts$convergence_mode <- "slow"
  train_opts$seed <- seed
  
  # Prepare and train (using pre-trained model as in tutorial)
  mofa_obj <- prepare_mofa(mofa_obj, data_opts, model_opts, train_opts)
  
  # Load pre-trained model to save time (as per tutorial)
  mofa_obj <- readRDS(url("http://ftp.ebi.ac.uk/pub/databases/mofa/cll_vignette/MOFA2_CLL.rds"))
  
  # Save model
  saveRDS(mofa_obj, file.path(output_dir, "model", "MOFA2_model.rds"))
  return(mofa_obj)
}

# ----------------------------
# 3. 添加元数据 & 模型概览
# ----------------------------
explore_model <- function(mofa_obj, metadata, output_dir = "result") {
  # Add metadata
  samples_metadata(mofa_obj) <- metadata
  
  # Data overview plot
  p1 <- plot_data_overview(mofa_obj)
  ggsave(file.path(output_dir, "plots", "data_overview.png"), p1, width = 8, height = 6)
  
  # Factor correlation
  cor_mat <- plot_factor_cor(mofa_obj, return_data = TRUE)
  write.csv(cor_mat, file.path(output_dir, "tables", "factor_correlation.csv"))
  
  # Variance explained (by factor)
  p2 <- plot_variance_explained(mofa_obj, max_r2 = 15)
  ggsave(file.path(output_dir, "plots", "variance_by_factor.png"), p2, width = 10, height = 6)
  
  # Total variance
  total_var <- plot_variance_explained(mofa_obj, plot_total = TRUE)
  if (length(total_var) >= 2) {
    var_df <- total_var$data
    write.csv(var_df, file.path(output_dir, "tables", "variance_total.csv"))
  }
  
  return(mofa_obj)
}

# ----------------------------
# 4. 因子解析（以 Factor 1 和 3 为例）
# ----------------------------
characterize_factors <- function(mofa_obj, output_dir = "result") {
  # Factor 1: IGHV
  p_f1_val <- plot_factor(mofa_obj, factors = 1, color_by = "IGHV", add_violin = TRUE)
  ggsave(file.path(output_dir, "plots", "factor1_values.png"), p_f1_val, width = 6, height = 5)
  
  p_f1_mut <- plot_top_weights(mofa_obj, view = "Mutations", factor = 1, nfeatures = 10)
  ggsave(file.path(output_dir, "plots", "factor1_mut_weights.png"), p_f1_mut, width = 8, height = 5)
  
  w_f1 <- get_weights(mofa_obj, views = "Mutations", factors = 1, as.data.frame = TRUE)
  write.csv(w_f1, file.path(output_dir, "tables", "top_weights_factor1.csv"), row.names = FALSE)
  
  # Factor 3: trisomy12
  p_f3_val <- plot_factor(mofa_obj, factors = 3, color_by = "trisomy12", add_violin = TRUE)
  ggsave(file.path(output_dir, "plots", "factor3_values.png"), p_f3_val, width = 6, height = 5)
  
  # Dual factor plot
  p_f1f3 <- plot_factors(mofa_obj, factors = c(1,3), color_by = "IGHV", shape_by = "trisomy12")
  ggsave(file.path(output_dir, "plots", "factor1_vs_factor3.png"), p_f1f3, width = 7, height = 6)
  
  return(invisible(NULL))
}

# ----------------------------
# 5. GSEA
# ----------------------------
run_gsea_analysis <- function(mofa_obj, output_dir = "result") {
  library(MOFAdata)
  utils::data("reactomeGS")
  
  res_pos <- run_enrichment(mofa_obj, feature.sets = reactomeGS, view = "mRNA", sign = "positive")
  res_neg <- run_enrichment(mofa_obj, feature.sets = reactomeGS, view = "mRNA", sign = "negative")
  
  # Save results
  write.csv(res_pos$pval.adj, file.path(output_dir, "tables", "gsea_pval_adj_positive.csv"))
  write.csv(res_neg$pval.adj, file.path(output_dir, "tables", "gsea_pval_adj_negative.csv"))
  
  # Plot Factor 5 (if exists)
  if (5 %in% colnames(res_pos$set.statistics)) {
    p_gsea <- plot_enrichment(res_pos, factor = 5, max.pathways = 15)
    ggsave(file.path(output_dir, "plots", "gsea_factor5.png"), p_gsea, width = 10, height = 6)
  }
  
  return(invisible(NULL))
}

# ----------------------------
# 6. 主流程 (移除了 imputation_and_prediction)
# ----------------------------
run_mofa2_cll_pipeline <- function(output_dir = "result") {
  cat("🚀 Starting MOFA+ CLL Pipeline (No Prediction)...\n")
  
  output_dir <- setup_output_dir(output_dir)
  
  cat("1. Loading data...\n")
  data_list <- load_cll_data()
  
  cat("2. Building MOFA+ model...\n")
  mofa_obj <- build_mofa_model(data_list$data, output_dir = output_dir)
  
  cat("3. Exploring model...\n")
  mofa_obj <- explore_model(mofa_obj, data_list$metadata, output_dir = output_dir)
  
  cat("4. Characterizing key factors...\n")
  characterize_factors(mofa_obj, output_dir = output_dir)
  
  cat("5. Running GSEA...\n")
  run_gsea_analysis(mofa_obj, output_dir = output_dir)
  
  cat("✅ Pipeline completed! Results saved to './", output_dir, "'\n", sep = "")
}

# ----------------------------
# 执行（取消注释即可运行）
# ----------------------------
run_mofa2_cll_pipeline()



