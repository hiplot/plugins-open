#这个代码文件是用于全部共病分析所用

library(readxl)
library(ppcor)
library(igraph)
library(export)
library(tidyverse)
library(tidyr)
library(dplyr)


#Step0:数据读入和处理-------------------------------------------
# 定义添加特征列的函数
add_features_to_matrix <- function(base_mat, new_info, fill_value = 0, verbose = TRUE) {
  # 参数校验
  required <- c("data", "id_col", "feature_col")
  if (!all(required %in% names(new_info))) {
    stop("new_info必须包含: 'data', 'id_col', 'feature_col'")
  }
  
  # 提取参数
  new_df <- new_info$data
  id_col <- new_info$id_col
  feature_col <- new_info$feature_col
  value_col <- new_info$value_col %||% "value"  # 默认值列名
  
  # 初始维度报告
  if (verbose) {
    cat("初始基础矩阵维度:", dim(base_mat), "\n")
    cat("新特征数据行数:", nrow(new_df), "\n")
    cat("新特征类别数:", length(unique(new_df[[feature_col]])), "\n")
  }
  
  # 创建新特征矩阵
  if (!value_col %in% names(new_df)) {
    new_df[[value_col]] <- 1  # 默认所有值为1
  }
  
  # 转换为宽格式
  new_matrix <- pivot_wider(
    new_df,
    id_cols = all_of(id_col),
    names_from = all_of(feature_col),
    values_from = all_of(value_col),
    values_fill = fill_value
  ) %>% 
    column_to_rownames(var = id_col) %>%
    as.matrix()
  
  # 新特征矩阵报告
  if (verbose) {
    cat("\n新特征矩阵维度:", dim(new_matrix), "\n")
    cat("新特征列名:", paste(colnames(new_matrix), collapse = ", "), "\n")
  }
  
  # 确保行名一致
  base_samples <- rownames(base_mat)
  new_samples <- rownames(new_matrix)
  all_samples <- union(base_samples, new_samples)
  
  # 扩展基础矩阵
  expanded_base <- matrix(
    fill_value,
    nrow = length(all_samples),
    ncol = ncol(base_mat),
    dimnames = list(all_samples, colnames(base_mat))
  )
  expanded_base[base_samples, ] <- base_mat[base_samples, ]
  
  # 扩展新特征矩阵
  expanded_new <- matrix(
    fill_value,
    nrow = length(all_samples),
    ncol = ncol(new_matrix),
    dimnames = list(all_samples, colnames(new_matrix))
  )
  expanded_new[new_samples, ] <- new_matrix[new_samples, ]
  
  # 合并矩阵
  combined_mat <- cbind(expanded_base, expanded_new)
  
  # 最终报告
  if (verbose) {
    cat("\n===== 合并结果 =====\n")
    cat("最终矩阵维度:", dim(combined_mat), "\n")
    cat("新增特征列数:", ncol(expanded_new), "\n")
    cat("新增列名:", paste(colnames(expanded_new), collapse = ", "), "\n")
    cat("样本数量变化:", 
        paste0(length(base_samples), " → ", length(all_samples)), "\n")
    cat("特征数量变化:", 
        paste0(ncol(base_mat), " → ", ncol(combined_mat)), "\n")
  }
  
  return(combined_mat)
}


# ============== 主处理流程 ============== #

# 读取原始数据
ukb_disease_mat <- readr::read_csv("data/250819_disease_matrix_305.csv") %>%
  tibble::column_to_rownames("Participant ID")

# 分离矩阵和元数据
meta <- ukb_disease_mat[, (ncol(ukb_disease_mat)-5):ncol(ukb_disease_mat)]
mat <- as.matrix(ukb_disease_mat[, -c((ncol(ukb_disease_mat)-5):ncol(ukb_disease_mat))])

# 移除常数列
mat <- mat[, apply(mat, 2, function(x) length(unique(x)) > 1)]
mat_ori <- mat


# 读取白血病亚型信息
leu_info <- read.csv("data/3097_leukemia_precise_diag.csv")[-1]

# # 使用函数添加亚型特征列
# mat_subtype <- add_features_to_matrix(
#   base_mat = mat,
#   new_info = list(
#     data = leu_info,
#     id_col = "Participant_ID",
#     feature_col = "subtype"
#   )
# )
# mat <- mat_subtype[, -which(colnames(mat) == "Leukaemia")]


#Step1:基础统计信息----------------------------------------------
analyze_disease_matrix <- function(mat, min_prevalence = 0.001, verbose = TRUE, plot = TRUE) {
  # 输入验证
  if (!is.matrix(mat)) stop("输入必须是矩阵")
  if (!all(mat %in% c(0, 1))) warning("矩阵包含非0/1值，结果可能不准确")
  
  # 初始化结果列表
  results <- list()
  
  # 1. 基本维度信息
  results$dimensions <- dim(mat)
  results$n_patients <- nrow(mat)
  results$n_diseases <- ncol(mat)
  
  if (verbose) {
    cat("===== 矩阵基本信息 =====\n")
    cat("样本数量:", results$n_patients, "\n")
    cat("疾病数量:", results$n_diseases, "\n")
    cat("稀疏度:", round(mean(mat == 0), 3), "\n")
  }
  
  # 2. 总体患病率统计
  prevalence <- colMeans(mat, na.rm = TRUE)
  results$overall_prevalence <- data.frame(
    Disease = colnames(mat),
    Prevalence = prevalence,
    Patients = colSums(mat),
    Prevalence_Percent = round(prevalence * 100, 2)
  ) %>% arrange(desc(Prevalence))
  
  if (verbose) {
    cat("\n===== 患病率统计 =====\n")
    cat("最高患病率疾病:", results$overall_prevalence$Disease[1], 
        "(", round(results$overall_prevalence$Prevalence[1]*100, 1), "%)\n")
    cat("最低患病率疾病:", tail(results$overall_prevalence$Disease, 1), 
        "(", round(tail(results$overall_prevalence$Prevalence, 1)*100, 3), "%)\n")
    cat("中位患病率:", round(median(prevalence)*100, 2), "%\n")
  }
  
  # 3. 患病率分布
  prevalence_bins <- cut(prevalence, 
                         breaks = c(0, 0.0001, 0.001, 0.01, 0.05, 0.1, 0.2, 0.5, 1),
                         labels = c("<0.01%", "0.01-0.1%", "0.1-1%", "1-5%", "5-10%", "10-20%", "20-50%", ">50%"),
                         include.lowest = TRUE)
  
  prevalence_dist_df <- as.data.frame(table(prevalence_bins)) %>%
    rename(Prevalence_Range = prevalence_bins, Count = Freq) %>%
    mutate(Percentage = round(Count/sum(Count)*100, 1))
  
  results$prevalence_distribution <- prevalence_dist_df
  
  if (verbose) {
    cat("\n患病率分布:\n")
    print(prevalence_dist_df)
  }
  
  # 患病率分布图
  if (plot) {
    results$plots$prevalence_distribution <- ggplot(prevalence_dist_df, 
                                                    aes(x = Prevalence_Range, y = Count, fill = Prevalence_Range)) +
      geom_bar(stat = "identity") +
      geom_text(aes(label = paste0(Count, "\n(", Percentage, "%)")), 
                vjust = -0.5, size = 3) +
      labs(title = "疾病患病率分布",
           x = "患病率范围", y = "疾病数量",
           subtitle = paste0("总疾病数: ", ncol(mat))) +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1),
            legend.position = "none")
    
    if (verbose) cat("\n已生成患病率分布图\n")
  }
  
  # 4. 共病分析
  if (results$n_diseases > 1) {
    if (verbose) cat("\n计算疾病共现率...\n")
    
    # 筛选患病率高于阈值的疾病
    common_diseases <- which(prevalence >= min_prevalence)
    common_mat <- mat[, common_diseases]
    
    # 计算共现矩阵
    cooccurrence <- crossprod(common_mat)
    diag(cooccurrence) <- 0  # 忽略自身共现
    
    # 转换为长格式
    cooccurrence_df <- as.data.frame(as.table(cooccurrence)) %>%
      rename(Disease1 = Var1, Disease2 = Var2, Cooccurrence = Freq) %>%
      filter(Disease1 != Disease2) %>%
      mutate(
        Prevalence1 = prevalence[Disease1],
        Prevalence2 = prevalence[Disease2],
        Expected = Prevalence1 * Prevalence2 * nrow(mat),
        Observed_Expected_Ratio = Cooccurrence / Expected
      ) %>%
      arrange(desc(Cooccurrence))
    
    results$cooccurrence <- cooccurrence_df
    
    if (verbose) {
      top_pair <- head(cooccurrence_df, 1)
      cat("\n最高共现疾病对:", 
          top_pair$Disease1, "&", top_pair$Disease2, 
          "(共现:", top_pair$Cooccurrence, ")\n")
    }
    
    # 共现分析图
    if (plot && nrow(cooccurrence_df) > 0) {
      top_cooccurrence <- head(cooccurrence_df, 15) %>%
        mutate(Pair = paste(Disease1, Disease2, sep = " & "))
      
      results$plots$cooccurrence <- ggplot(top_cooccurrence, 
                                           aes(x = reorder(Pair, Cooccurrence), y = Cooccurrence)) +
        geom_bar(stat = "identity", fill = "steelblue") +
        geom_text(aes(label = Cooccurrence), hjust = -0.1, size = 3) +
        coord_flip() +
        labs(title = "最高共现疾病对",
             x = "疾病对", y = "共现次数",
             subtitle = paste0("共现次数最高的前", nrow(top_cooccurrence), "对疾病")) +
        theme_minimal()
      
      if (verbose) cat("已生成共现分析图\n")
    }
  } else {
    results$cooccurrence <- NULL
    if (verbose) cat("\n疾病数量不足，跳过共现分析\n")
  }
  
  # 5. 样本患病数量分布
  disease_count <- rowSums(mat)
  results$disease_per_patient <- data.frame(
    Diseases = disease_count,
    Patient_ID = rownames(mat)
  )
  
  disease_count_dist <- as.data.frame(table(disease_count)) %>%
    rename(Number_of_Diseases = disease_count, Count = Freq) %>%
    mutate(Percentage = round(Count/sum(Count)*100, 1))
  
  results$disease_count_distribution <- disease_count_dist
  
  if (verbose) {
    cat("\n===== 患者患病数量分布 =====\n")
    cat("中位患病数量:", median(disease_count), "\n")
    cat("最大患病数量:", max(disease_count), "\n")
    cat("无疾病患者:", sum(disease_count == 0), "\n")
    print(head(disease_count_dist, 10))
  }
  
  # 患者患病数量分布图
  if (plot) {
    # 限制显示数量，避免太多条形
    max_display <- min(20, nrow(disease_count_dist))
    display_data <- head(disease_count_dist, max_display)
    
    results$plots$disease_count_distribution <- ggplot(display_data, 
                                                       aes(x = Number_of_Diseases, y = Count)) +
      geom_bar(stat = "identity", fill = "darkgreen") +
      geom_text(aes(label = paste0(Count, "\n(", Percentage, "%)")), 
                vjust = -0.5, size = 3) +
      labs(title = "患者患病数量分布",
           x = "患病数量", y = "患者数量",
           subtitle = paste0("中位患病数量: ", median(disease_count),
                             " | 无疾病患者: ", sum(disease_count == 0))) +
      theme_minimal()
    
    if (verbose) cat("已生成患者患病数量分布图\n")
  }
  
  # 6. 罕见疾病识别
  rare_diseases <- results$overall_prevalence %>%
    filter(Prevalence < min_prevalence) %>%
    arrange(Prevalence)
  
  results$rare_diseases <- rare_diseases
  
  if (verbose) {
    cat("\n===== 罕见疾病 =====\n")
    cat("罕见疾病阈值: <", min_prevalence*100, "%\n")
    cat("罕见疾病数量:", nrow(rare_diseases), "\n")
    if (nrow(rare_diseases) > 0) {
      cat("Top 5罕见疾病:\n")
      print(head(rare_diseases, 5))
    }
  }
  
  # 罕见疾病图
  if (plot && nrow(rare_diseases) > 0) {
    # 限制显示数量
    max_display <- min(15, nrow(rare_diseases))
    top_rare <- head(rare_diseases, max_display)
    
    results$plots$rare_diseases <- ggplot(top_rare, 
                                          aes(x = reorder(Disease, Prevalence), 
                                              y = Prevalence_Percent)) +
      geom_bar(stat = "identity", fill = "firebrick") +
      geom_text(aes(label = paste0(Patients, "人")), hjust = -0.1, size = 3) +
      coord_flip() +
      labs(title = "罕见疾病分布",
           x = "疾病", y = "患病率(%)",
           subtitle = paste0("患病率 < ", min_prevalence*100, "% (共", nrow(rare_diseases), "种)")) +
      theme_minimal()
    
    if (verbose) cat("已生成罕见疾病分布图\n")
  }
  
  # 7. 总体患病率分布图
  if (plot) {
    results$plots$overall_prevalence <- ggplot(results$overall_prevalence, 
                                               aes(x = Prevalence)) +
      geom_histogram(bins = 50, fill = "steelblue", alpha = 0.7) +
      scale_x_log10(labels = scales::percent) +
      labs(title = "疾病患病率分布",
           x = "患病率(log10尺度)", y = "疾病数量",
           subtitle = paste0("最高患病率: ", 
                             round(max(prevalence)*100, 1), "% | ",
                             "最低患病率: ", 
                             round(min(prevalence)*100, 3), "%")) +
      theme_minimal()
    
    if (verbose) cat("已生成总体患病率分布图\n")
  }
  
  # 返回所有结果
  return(results)
}
disease_stats <- analyze_disease_matrix(mat)
prevalence_df <- disease_stats$overall_prevalence

print(disease_stats$plots$prevalence_distribution)
graph2pdf(file = "result/prevalence_distribution.pdf", width = 8, height = 8)
print(disease_stats$plots$cooccurrence)
graph2pdf(file = "result/cooccurrence.pdf", width = 12, height = 10)
print(disease_stats$plots$disease_count_distribution)
graph2pdf(file = "result/disease_count_distribution.pdf", width = 12, height = 10)
print(disease_stats$plots$rare_diseases)
graph2pdf(file = "result/rare_diseases.pdf", width = 12, height = 10)
print(disease_stats$plots$overall_prevalence)
graph2pdf(file = "result/overall_prevalence.pdf", width = 12, height = 10)


#Step2:偏相关系数----------------------------------------------
visualize_partial_correlation <- function(mat, method = "pearson", alpha = 0.05,
                                          bonferroni_correction = TRUE,
                                          show_significance = TRUE,
                                          cluster_variables = TRUE,
                                          color_scheme = "redblue") {
  
  # 检查必要包是否安装
  required_packages <- c("ppcor", "ggplot2", "reshape2", "dplyr", "corrplot")
  for (pkg in required_packages) {
    if (!require(pkg, character.only = TRUE)) {
      stop("请先安装", pkg, "包: install.packages('", pkg, "')")
    }
  }
  
  # 检查输入数据
  if (!is.matrix(mat) && !is.data.frame(mat)) {
    stop("输入必须是矩阵或数据框")
  }
  
  if (ncol(mat) < 2) {
    stop("矩阵至少需要2列变量")
  }
  
  # 计算偏相关系数和p值[2,4](@ref)
  pcor_result <- ppcor::pcor(mat, method = method)
  pcor_matrix <- pcor_result$estimate
  pval_matrix <- pcor_result$p.value
  
  # 设置行列名
  diseases <- colnames(mat)
  rownames(pcor_matrix) <- diseases
  colnames(pcor_matrix) <- diseases
  rownames(pval_matrix) <- diseases
  colnames(pval_matrix) <- diseases
  
  # 计算多重检验校正[1](@ref)
  n_diseases <- ncol(mat)
  n_pairs <- n_diseases * (n_diseases - 1) / 2
  
  if (bonferroni_correction) {
    alpha_corrected <- alpha / n_pairs
  } else {
    alpha_corrected <- alpha
  }
  
  # 创建可视化数据框[7](@ref)
  melt_correlation <- function(matrix, value_name) {
    melted <- reshape2::melt(matrix)
    colnames(melted) <- c("Var1", "Var2", value_name)
    return(melted)
  }
  
  cor_melted <- melt_correlation(pcor_matrix, "correlation")
  pval_melted <- melt_correlation(pval_matrix, "pvalue")
  
  # 合并数据
  plot_data <- cor_melted %>%
    left_join(pval_melted, by = c("Var1", "Var2")) %>%
    filter(Var1 != Var2)  # 移除对角线
  
  # 添加显著性标记
  if (show_significance) {
    plot_data <- plot_data %>%
      mutate(
        significance = case_when(
          pvalue < alpha_corrected & pvalue >= alpha_corrected/10 ~ "*",
          pvalue < alpha_corrected/10 & pvalue >= alpha_corrected/100 ~ "**",
          pvalue < alpha_corrected/100 ~ "***",
          TRUE ~ ""
        )
      )
  }
  
  # 变量聚类排序（可选）[7](@ref)
  if (cluster_variables && n_diseases > 2) {
    # 使用层次聚类对变量排序
    dist_matrix <- as.dist(1 - abs(pcor_matrix))
    hc <- hclust(dist_matrix)
    ordered_vars <- hc$order
    var_levels <- diseases[ordered_vars]
    
    plot_data$Var1 <- factor(plot_data$Var1, levels = var_levels)
    plot_data$Var2 <- factor(plot_data$Var2, levels = var_levels)
  } else {
    plot_data$Var1 <- factor(plot_data$Var1, levels = diseases)
    plot_data$Var2 <- factor(plot_data$Var2, levels = diseases)
  }
  
  # 设置颜色方案[7](@ref)
  set_color_scheme <- function(scheme) {
    switch(scheme,
           "redblue" = scale_fill_gradient2(
             low = "blue", high = "red", mid = "white",
             midpoint = 0, limit = c(-1, 1), 
             name = "偏相关系数"
           ),
           "heat" = scale_fill_gradientn(
             colors = c("blue", "white", "red"),
             limits = c(-1, 1),
             name = "偏相关系数"
           ),
           "custom" = scale_fill_gradientn(
             colors = c('#4987D3', "#FBF7C7", '#DB562D'),
             limits = c(-1, 1),
             name = "偏相关系数"
           )
    )
  }
  
  # 创建热图[3,7](@ref)
  p <- ggplot(plot_data, aes(x = Var1, y = Var2, fill = correlation)) +
    geom_tile(color = "white", linewidth = 0.5) +
    set_color_scheme(color_scheme) +
    theme_minimal() +
    theme(
      axis.text.x = element_text(angle = 45, hjust = 1, size = 10),
      axis.text.y = element_text(size = 10),
      axis.title = element_blank(),
      panel.grid = element_blank(),
      legend.position = "right",
      plot.title = element_text(hjust = 0.5, face = "bold")
    ) +
    labs(
      title = paste("偏相关矩阵可视化"),
      subtitle = paste("方法:", method, "| 显著性水平:", 
                       ifelse(bonferroni_correction, 
                              paste("Bonferroni校正 (α =", format(alpha_corrected, scientific = TRUE), ")"), 
                              paste("未校正 (α =", alpha, ")"))),
      caption = paste("变量数:", n_diseases, "| 疾病对数:", n_pairs)
    ) +
    coord_fixed()  # 确保单元格为正方形
  
  # 添加显著性标记[3](@ref)
  if (show_significance) {
    p <- p + geom_text(aes(label = significance), 
                       color = "black", size = 3, fontface = "bold")
  }
  
  # 添加相关系数值（可选）
  if (n_diseases <= 10) {  # 只在变量较少时显示数值
    p <- p + geom_text(aes(label = round(correlation, 2)), 
                       color = "black", size = 2.5, 
                       nudge_y = -0.1)
  }
  
  return(p)
}

partial_correlation_analysis <- function(mat, method = "pearson", alpha = 0.05) {
  
  # 计算疾病对数量用于多重检验校正[1](@ref)
  n_diseases <- ncol(mat)
  n_pairs <- n_diseases * (n_diseases - 1) / 2
  alpha_corrected <- alpha / n_pairs
  
  # 计算偏相关系数和p值[2,4](@ref)
  pcor_result <- ppcor::pcor(mat, method = method)
  pcor_matrix <- pcor_result$estimate
  pval_matrix <- pcor_result$p.value
  
  # 设置行列名
  diseases <- colnames(mat)
  rownames(pcor_matrix) <- diseases
  colnames(pcor_matrix) <- diseases
  rownames(pval_matrix) <- diseases
  colnames(pval_matrix) <- diseases
  
  # 提取显著正相关对（您的原有逻辑）
  extract_significant <- function(r_matrix, p_matrix, alpha_corrected) {
    upper_idx <- upper.tri(r_matrix, diag = FALSE)
    
    significant_pairs <- data.frame(
      condition1 = rownames(r_matrix)[row(r_matrix)[upper_idx]],
      condition2 = colnames(r_matrix)[col(r_matrix)[upper_idx]],
      partial_cor = r_matrix[upper_idx],
      p_value = p_matrix[upper_idx]
    ) %>% 
      filter(p_value < alpha_corrected & partial_cor >= 0) %>%
      arrange(desc(partial_cor))
    
    return(significant_pairs)
  }
  
  par_cor <- extract_significant(pcor_matrix, pval_matrix, alpha_corrected)
  return(par_cor)
}

par_cor <- partial_correlation_analysis(mat)
# pcor_plot <- visualize_partial_correlation(
#   mat = mat,
#   method = "pearson",
#   alpha = 0.05,
#   bonferroni_correction = TRUE,
#   show_significance = TRUE,
#   cluster_variables = TRUE,
#   color_scheme = "redblue"
# )
# print(pcor_plot)
# ggsave("result/partial_correlation_plot.pdf", pcor_plot, width = 20, height = 20, dpi = 300)
write_csv(par_cor,"output/parcor_all.csv")


#Step3.计算MMC 总结表格信息----------------------------------------
generate_mmc_summary <- function(par_cor, 
                                 category_file = "data/phenotype_map_305_category.xlsx",
                                 top_n = 50,
                                 output_file = "result/circle_barplot.pdf",
                                 plot_width = 20,
                                 plot_height = 20,
                                 empty_bar = 2) {
  
  # 检查必要包是否已加载
  required_packages <- c("dplyr", "ggplot2", "readxl")
  missing_packages <- required_packages[!required_packages %in% installed.packages()]
  if (length(missing_packages) > 0) {
    stop("请先安装以下包: ", paste(missing_packages, collapse = ", "))
  }
  
  library(dplyr)
  library(ggplot2)
  library(readxl)
  
  # Step 1: 计算MMC总结表格信息
  summary_df <- par_cor %>%
    # 将疾病对拆分为两个方向
    pivot_longer(
      cols = c(condition1, condition2),
      names_to = "role",
      values_to = "disease"
    ) %>%
    # 按疾病分组
    group_by(disease) %>%
    summarise(
      con_num = n(),  # 关联疾病数量
      Average_parcor = mean(partial_cor),  # 平均偏相关系数
      MMC = sum(partial_cor)  # 多发病关联强度
    ) %>%
    arrange(desc(MMC))  # 按MMC降序排列
  
  
  # Step 2: 加入疾病类型
  if (file.exists(category_file)) {
    category <- read_xlsx(category_file)
    summary_df <- summary_df %>%
      left_join(category %>% dplyr::select(Disease, Category), 
                by = c("disease" = "Disease")) %>%
      mutate(Category = replace_na(Category, "Leukemia(subtypes)\n"))
  } else {
    warning("类别文件不存在，跳过类别合并步骤")
    summary_df$Category <- "Unknown"
  }
  
  # Step 3: 创建绘图数据
  plot_data <- summary_df %>% 
    slice(1:min(top_n, nrow(summary_df))) 
  plot_data$Category <- as.factor(plot_data$Category)
  
  # 添加空条形以分隔类别
  to_add <- data.frame(matrix(NA, empty_bar * nlevels(plot_data$Category), ncol(plot_data)))
  colnames(to_add) <- colnames(plot_data)
  to_add$Category <- rep(levels(plot_data$Category), each = empty_bar)
  plot_data <- rbind(plot_data, to_add)
  plot_data <- plot_data %>% arrange(Category)
  plot_data$id <- seq(1, nrow(plot_data))
  
  # Step 4: 准备标签数据
  label_plot_data <- plot_data
  number_of_bar <- nrow(label_plot_data)
  angle <- 90 - 360 * (label_plot_data$id - 0.5) / number_of_bar
  label_plot_data$hjust <- ifelse(angle < -90, 1, 0)
  label_plot_data$angle <- ifelse(angle < -90, angle + 180, angle)
  
  # Step 5: 准备基线和网格数据
  base_plot_data <- plot_data %>% 
    group_by(Category) %>% 
    summarize(start = min(id), end = max(id) - empty_bar) %>% 
    rowwise() %>% 
    mutate(title = mean(c(start, end)))
  
  grid_plot_data <- base_plot_data
  grid_plot_data$end <- grid_plot_data$end[c(nrow(grid_plot_data), 1:nrow(grid_plot_data)-1)] + 1
  grid_plot_data$start <- grid_plot_data$start - 1
  grid_plot_data <- grid_plot_data[-1,]
  
  # Step 6: 创建图形
  p <- ggplot(plot_data, aes(x = as.factor(id), y = MMC, fill = Category)) +
    geom_bar(stat = "identity", alpha = 0.5, show.legend = TRUE) +
    
    # 添加网格线
    geom_segment(data = grid_plot_data, 
                 aes(x = end, y = 3, xend = start, yend = 3), 
                 colour = "grey", alpha = 1, size = 0.3) +
    geom_segment(data = grid_plot_data, 
                 aes(x = end, y = 2, xend = start, yend = 2), 
                 colour = "grey", alpha = 1, size = 0.3) +
    geom_segment(data = grid_plot_data, 
                 aes(x = end, y = 1, xend = start, yend = 1), 
                 colour = "grey", alpha = 1, size = 0.3) +
    
    # 添加刻度标签
    annotate("text", x = rep(max(plot_data$id), 3), y = c(1, 2, 3), 
             label = c("1", "2", "3"), color = "grey", size = 3, 
             angle = 0, fontface = "bold", hjust = 1) +
    
    # 添加条形图（第二次绘制以覆盖网格线）
    geom_bar(stat = "identity", alpha = 0.5) +
    ylim(-2, 4.1) +
    theme_minimal() +
    theme(
      legend.position = "right",
      axis.text = element_blank(),
      axis.title = element_blank(),
      panel.grid = element_blank(),
      plot.margin = unit(rep(-1, 4), "cm")
    ) +
    coord_polar() +
    
    # 添加条件标签
    geom_text(data = label_plot_data, 
              aes(x = id, y = MMC + 0.2, label = disease, hjust = hjust), 
              color = "black", fontface = "bold", alpha = 0.6, size = 3, 
              angle = label_plot_data$angle, inherit.aes = FALSE) +
    
    # 添加类别基线
    geom_segment(data = base_plot_data, 
                 aes(x = start, y = -0.1, xend = end, yend = -0.1), 
                 colour = "black", alpha = 0.8, size = 0.6, inherit.aes = FALSE)
  
  # Step 7: 保存图形
  if (!dir.exists(dirname(output_file))) {
    dir.create(dirname(output_file), recursive = TRUE)
  }
  
  # 使用ggsave保存PDF
  ggsave(output_file, p, width = plot_width, height = plot_height)
  
  # 返回结果
  return(list(summary_df = summary_df, plot = p))
}

result <- generate_mmc_summary(
  par_cor = par_cor,
  category_file = "data/phenotype_map_305_category.xlsx",
  top_n = 100,
  output_file = "result/circle_barplot_all.pdf",
  plot_width = 15,
  plot_height = 15
)

summary_df <- result$summary_df
write.csv(summary_df,"output/mmc.csv")
plot_obj <- result$plot
print(plot_obj)


#Step4:构建共病网络-------------------------------------
category<-read_xlsx("data/phenotype_map_305_category.xlsx")
nodes<-prevalence_df

nodes <- nodes %>%
  left_join(category %>% dplyr::select(Disease, Category), 
            by = c("Disease")) %>%  # 根据疾病名称合并类别
  mutate(
    node_size = scales::rescale(Prevalence, to = c(5, 30)), # 标准化节点大小
    Category = replace_na(Category, "Leukemia(subtypes)\n")
  )
plot_global_network <- function(nodes, par_cor, 
                                cor_threshold = 0.1, 
                                p_threshold = 0.05,
                                highlight_diseases = NULL,  # 改为高亮特定疾病
                                highlight_color = "red",
                                layout_algorithm = "fr",
                                output_file = NULL,
                                output_width = 15,
                                output_height = 15) {
  
  # 检查必要包
  required_packages <- c("igraph", "dplyr", "scales", "RColorBrewer")
  for (pkg in required_packages) {
    if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
      stop("请先安装", pkg, "包: install.packages('", pkg, "')")
    }
  }
  
  # 验证输入数据
  if (!all(c("Disease", "Prevalence", "Category") %in% colnames(nodes))) {
    stop("nodes数据框必须包含Disease、Prevalence和Category列")
  }
  
  if (!all(c("condition1", "condition2", "partial_cor", "p_value") %in% colnames(par_cor))) {
    stop("par_cor数据框必须包含condition1、condition2、partial_cor和p_value列")
  }
  
  # 筛选显著相关对
  par_cor_filtered <- par_cor %>%
    filter(partial_cor > cor_threshold & p_value < p_threshold)
  
  if (nrow(par_cor_filtered) == 0) {
    stop("没有找到满足阈值条件的显著相关对")
  }
  
  # 准备节点数据
  nodes_prepared <- nodes %>%
    mutate(
      node_size = scales::rescale(Prevalence, to = c(5, 30)),
      Category = replace_na(Category, "Unknown")
    )
  
  # 生成类别颜色
  all_categories <- unique(na.omit(nodes_prepared$Category))
  
  if (length(all_categories) <= 8) {
    category_colors <- RColorBrewer::brewer.pal(max(3, length(all_categories)), "Set2")
    category_colors <- category_colors[1:length(all_categories)]
  } else {
    category_colors <- rainbow(length(all_categories))
  }
  
  names(category_colors) <- all_categories
  nodes_prepared$category_color <- category_colors[nodes_prepared$Category]
  
  # 特别高亮指定疾病（而不是类别）
  if (!is.null(highlight_diseases)) {
    highlight_diseases <- highlight_diseases[highlight_diseases %in% nodes_prepared$Disease]
    if (length(highlight_diseases) > 0) {
      nodes_prepared$category_color[nodes_prepared$Disease %in% highlight_diseases] <- highlight_color
    }
  }
  
  nodes_prepared$category_color <- category_colors[nodes_prepared$Category]
  
  # 创建网络
  g <- graph_from_data_frame(
    d = par_cor_filtered,
    vertices = nodes_prepared,
    directed = FALSE
  )
  
  # 删除孤立节点
  g <- delete_vertices(g, degree(g) == 0)
  
  # 设置边的宽度和颜色
  if (length(E(g)) > 0) {
    E(g)$width <- scales::rescale(E(g)$partial_cor, to = c(0.5, 5))
    E(g)$color <- "gray70"
  }
  
  # 按类别设置节点颜色
  V(g)$color <- V(g)$category_color
  
  # 设置布局算法
  layout_func <- switch(layout_algorithm,
                        "fr" = layout_with_fr,
                        "kk" = layout_with_kk,
                        "drl" = layout_with_drl,
                        "lgl" = layout_with_lgl,
                        "circle" = layout_in_circle,
                        layout_with_fr)
  
  # 创建图例数据
  legend_data <- data.frame(
    Category = all_categories,
    Color = category_colors
  )
  
  # 绘制网络图
  par(mar = c(0, 0, 2, 0))
  
  plot(g,
       layout = layout_func(g),
       vertex.size = V(g)$node_size,
       vertex.color = V(g)$color,
       vertex.frame.color = "white",
       vertex.label = V(g)$name,
       vertex.label.cex = 0.8,
       vertex.label.color = "black",
       vertex.label.dist = 0.5,
       edge.color = E(g)$color,
       edge.curved = 0.2,
       main = paste0("疾病共病网络 (相关系数 > ", cor_threshold, ")"),
       sub = paste0("节点数: ", vcount(g), " | 边数: ", ecount(g), " | 类别数: ", length(all_categories)))
  
  # 添加图例
  if (length(all_categories) <= 15) {
    legend("bottomleft", 
           legend = legend_data$Category,
           fill = legend_data$Color,
           title = "疾病类别",
           cex = 0.7,
           bty = "n")
  }
  
  # 添加高亮说明（如果指定了高亮疾病）
  if (!is.null(highlight_diseases) && length(highlight_diseases) > 0) {
    legend("bottomright",
           legend = paste("高亮疾病:", paste(highlight_diseases, collapse = ", ")),
           fill = highlight_color,
           title = "特别关注",
           cex = 0.7,
           bty = "n")
  }
  
  # 保存文件（如果需要）
  if (!is.null(output_file)) {
    if (tools::file_ext(output_file) == "pdf") {
      pdf(output_file, width = output_width, height = output_height)
      # 重绘图形
      plot(g, layout = layout_func(g),
           vertex.size = V(g)$node_size,
           vertex.color = V(g)$color,
           vertex.frame.color = "white",
           vertex.label = V(g)$name,
           vertex.label.cex = 0.8,
           vertex.label.color = "black",
           edge.color = E(g)$color,
           main = paste0("疾病共病网络 (相关系数 > ", cor_threshold, ")"),
           sub = paste0("节点数: ", vcount(g), " | 边数: ", ecount(g), " | 类别数: ", length(all_categories)))
      
      # 添加图例
      if (length(all_categories) <= 15) {
        legend("bottomleft", 
               legend = legend_data$Category,
               fill = legend_data$Color,
               title = "疾病类别",
               cex = 0.7,
               bty = "n")
      }
      dev.off()
      message(paste("网络图已保存至:", output_file))
    }
  }
  
  # 返回结果
  result <- list(
    graph = g,
    category_colors = category_colors,
    summary = list(
      nodes = vcount(g),
      edges = ecount(g),
      categories = length(all_categories)
    )
  )
  
  return(invisible(result))
}


# 子网络提取与可视化函数
# 新的按疾病提取子网络函数
plot_subnetwork_by_disease <- function(global_network, disease_name, 
                                       output_file = NULL,
                                       output_width = 10,
                                       output_height = 10) {
  
  # 检查必要包
  if (!require(igraph, quietly = TRUE)) {
    stop("请先安装igraph包: install.packages('igraph')")
  }
  
  # 从全局网络中提取节点和图对象
  g <- global_network$graph
  
  # 找到目标疾病节点
  disease_node <- V(g)[name == disease_name]
  
  if (length(disease_node) == 0) {
    stop(paste("未找到名称为", disease_name, "的疾病节点"))
  }
  
  # 获取邻居节点
  neighbor_nodes <- neighbors(g, disease_node)
  
  # 合并所有节点
  all_subnet_nodes <- unique(c(disease_node, neighbor_nodes))
  
  # 提取子网络
  subnet <- induced_subgraph(g, all_subnet_nodes)
  
  # 设置节点颜色
  V(subnet)$color <- ifelse(V(subnet)$name == disease_name, 
                            "red", 
                            V(subnet)$category_color)
  
  # 设置布局
  layout_subnet <- layout_with_fr(subnet)
  
  # 绘制子网络
  par(mar = c(0, 0, 2, 0))
  plot(subnet,
       layout = layout_subnet,
       vertex.size = V(subnet)$node_size,
       vertex.color = V(subnet)$color,
       vertex.frame.color = "white",
       vertex.label = V(subnet)$name,
       vertex.label.cex = 0.9,
       vertex.label.color = "black",
       vertex.label.dist = 0.5,
       edge.color = "gray70",
       edge.curved = 0.2,
       main = paste0("子网络: ", disease_name, "及相关疾病"),
       sub = paste0("节点数: ", vcount(subnet), " | 边数: ", ecount(subnet)))
  
  # 添加图例
  legend("bottomright",
         legend = c(disease_name, "关联疾病"),
         fill = c("red", "gray"),
         title = "节点类型",
         cex = 0.7,
         bty = "n")
  
  # 保存文件（如果需要）
  if (!is.null(output_file)) {
    if (tools::file_ext(output_file) == "pdf") {
      pdf(output_file, width = output_width, height = output_height)
      plot(subnet,
           layout = layout_subnet,
           vertex.size = V(subnet)$node_size,
           vertex.color = V(subnet)$color,
           vertex.frame.color = "white",
           vertex.label = V(subnet)$name,
           vertex.label.cex = 0.9,
           vertex.label.color = "black",
           edge.color = "gray70",
           main = paste0("子网络: ", disease_name, "及相关疾病"),
           sub = paste0("节点数: ", vcount(subnet), " | 边数: ", ecount(subnet)))
      dev.off()
      message(paste("子网络图已保存至:", output_file))
    }
  }
  
  # 返回子网络信息
  result <- list(
    subnet = subnet,
    disease_node = disease_node$name,
    neighbor_nodes = V(subnet)[V(subnet)$name != disease_name]$name,
    summary = list(
      total_nodes = vcount(subnet),
      disease_node = disease_name,
      neighbor_node_count = length(neighbor_nodes),
      edges = ecount(subnet)
    )
  )
  
  return(invisible(result))
}



global_result <- plot_global_network(
  nodes = nodes,
  par_cor = par_cor,
  highlight_diseases = "Leukaemia",  # 指定要标注的疾病名称
  highlight_color = "red",
  cor_threshold = 0.0,
  output_file = "result/global_network_0.0.pdf",
  output_width = 20,
  output_height = 20
)

# 使用新的疾病子网络函数
leukemia_subnet <- plot_subnetwork_by_disease(
  global_network = global_result,
  disease_name = "Leukaemia",  # 指定白血病疾病名称
  output_file = "result/leukemia_subnetwork.pdf",
  output_width = 15,
  output_height = 15
)
























