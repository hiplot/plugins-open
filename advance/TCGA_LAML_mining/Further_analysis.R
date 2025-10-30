# 加载必要的R包
library(TCGAbiolinks)
library(SummarizedExperiment)
library(dplyr)
library(stringr)
library(survival)
library(survminer)
library(glmnet)
library(timeROC)
library(clusterProfiler)
library(org.Hs.eg.db)
library(ggplot2)
library(pheatmap)

###############################
# 1. 数据标准化
###############################

# 对原始计数进行标准化：CPM转换 + log2转换
normalize_expression <- function(count_matrix) {
  # 计算CPM (Counts Per Million)
  cpm_matrix <- apply(count_matrix, 2, function(x) {
    (x / sum(x)) * 1e6
  })
  
  # log2转换 (加1避免对0取对数)
  log2_cpm_matrix <- log2(cpm_matrix + 1)
  
  return(log2_cpm_matrix)
}

# 执行标准化
normalized_counts <- normalize_expression(final_counts)

###############################
# 2. 多基因预后特征构建
###############################

# 准备生存分析数据
prepare_survival_data <- function(expr_matrix, clinical_data) {
  # 确保样本顺序一致
  common_samples <- intersect(colnames(expr_matrix), clinical_data$Patient_ID)
  expr_filtered <- expr_matrix[, common_samples]
  clinical_filtered <- clinical_data[clinical_data$Patient_ID %in% common_samples, ]
  
  # 创建生存对象
  survival_data <- data.frame(
    Patient_ID = clinical_filtered$Patient_ID,
    time = as.numeric(clinical_filtered$os),
    status = as.numeric(clinical_filtered$os_status)
  )
  
  # 移除生存时间缺失或为负值的样本
  valid_samples <- !is.na(survival_data$time) & survival_data$time >= 0
  survival_data <- survival_data[valid_samples, ]
  expr_filtered <- expr_filtered[, valid_samples]
  
  return(list(expr = expr_filtered, survival = survival_data))
}

# 单因素Cox回归筛选基因
univariate_cox_analysis <- function(expr_matrix, survival_data, pval_cutoff = 0.05) {
  cox_results <- data.frame(
    gene = character(),
    coef = numeric(),
    hr = numeric(),
    pvalue = numeric(),
    stringsAsFactors = FALSE
  )
  
  for (i in 1:nrow(expr_matrix)) {
    gene_name <- rownames(expr_matrix)[i]
    gene_expr <- as.numeric(expr_matrix[i, ])
    
    # 构建Cox模型
    cox_model <- tryCatch({
      coxph(Surv(time, status) ~ gene_expr, data = survival_data)
    }, error = function(e) NULL)
    
    if (!is.null(cox_model)) {
      cox_summary <- summary(cox_model)
      cox_results <- rbind(cox_results, data.frame(
        gene = gene_name,
        coef = cox_summary$coefficients[1, 1],
        hr = cox_summary$coefficients[1, 2],
        pvalue = cox_summary$coefficients[1, 5]
      ))
    }
  }
  
  # 多重检验校正
  cox_results$fdr <- p.adjust(cox_results$pvalue, method = "fdr")
  significant_genes <- cox_results[cox_results$pvalue < pval_cutoff, ]
  
  return(list(all_results = cox_results, significant = significant_genes))
}

# LASSO-Cox回归构建风险评分
lasso_cox_model <- function(expr_matrix, survival_data, seed = 123) {
  set.seed(seed)
  
  # 准备数据
  X <- t(expr_matrix)  # 样本×基因
  Y <- Surv(survival_data$time, survival_data$status)
  
  # 交叉验证确定lambda
  cv_fit <- cv.glmnet(X, Y, family = "cox", alpha = 1, nfolds = 10)
  
  # 获取系数
  coef_matrix <- as.matrix(coef(cv_fit, s = "lambda.min"))
  selected_genes <- rownames(coef_matrix)[coef_matrix != 0]
  
  if (length(selected_genes) == 0) {
    # 如果lambda.min没有选择基因，使用lambda.1se
    coef_matrix <- as.matrix(coef(cv_fit, s = "lambda.1se"))
    selected_genes <- rownames(coef_matrix)[coef_matrix != 0]
  }
  
  if (length(selected_genes) > 0) {
    # 计算风险评分
    risk_scores <- X[, selected_genes, drop = FALSE] %*% coef_matrix[selected_genes, 1]
    
    return(list(
      selected_genes = selected_genes,
      coefficients = coef_matrix[selected_genes, 1],
      risk_scores = as.numeric(risk_scores),
      cv_fit = cv_fit,
      model = cv_fit
    ))
  } else {
    return(NULL)
  }
}

# 评估风险评分模型
evaluate_risk_model <- function(risk_scores, survival_data, cutoff = "median") {
  if (cutoff == "median") {
    risk_group <- ifelse(risk_scores > median(risk_scores), "High", "Low")
  } else {
    risk_group <- ifelse(risk_scores > cutoff, "High", "Low")
  }
  
  # KM生存分析
  surv_fit <- survfit(Surv(time, status) ~ risk_group, data = survival_data)
  surv_diff <- survdiff(Surv(time, status) ~ risk_group, data = survival_data)
  p_value <- 1 - pchisq(surv_diff$chisq, length(surv_diff$n) - 1)
  
  # 时间依赖性ROC曲线
  roc_data <- timeROC(
    T = survival_data$time,
    delta = survival_data$status,
    marker = risk_scores,
    cause = 1,
    times = c(365, 1095, 1825),  # 1年、3年、5年
    ROC = TRUE
  )
  
  return(list(
    risk_group = risk_group,
    surv_fit = surv_fit,
    p_value = p_value,
    roc_data = roc_data
  ))
}

###############################
# 3. 独立预后因素分析
###############################

independent_prognostic_analysis <- function(risk_scores, clinical_data, survival_data) {
  # 合并风险评分和临床数据
  analysis_df <- data.frame(
    risk_score = risk_scores,
    time = survival_data$time,
    status = survival_data$status
  )
  
  # 添加临床变量（示例，根据实际数据调整）
  clinical_vars <- clinical_data[, c("Age", "Gender"), drop = FALSE]
  analysis_df <- cbind(analysis_df, clinical_vars)
  
  # 多因素Cox回归
  multi_cox <- coxph(Surv(time, status) ~ ., data = analysis_df)
  multi_summary <- summary(multi_cox)
  
  return(list(
    model = multi_cox,
    summary = multi_summary
  ))
}

###############################
# 4. 功能富集分析
###############################

perform_enrichment_analysis <- function(gene_list, pval_cutoff = 0.05, qval_cutoff = 0.2) {
  # 基因ID转换（假设基因名为symbol）
  gene_entrez <- bitr(gene_list, fromType = "SYMBOL", 
                     toType = "ENTREZID", OrgDb = "org.Hs.eg.db")
  
  entrez_ids <- gene_entrez$ENTREZID
  
  # GO富集分析
  go_enrich <- enrichGO(
    gene = entrez_ids,
    OrgDb = org.Hs.eg.db,
    keyType = "ENTREZID",
    ont = "ALL",
    pAdjustMethod = "BH",
    pvalueCutoff = pval_cutoff,
    qvalueCutoff = qval_cutoff,
    readable = TRUE
  )
  
  # KEGG通路富集分析
  kegg_enrich <- enrichKEGG(
    gene = entrez_ids,
    organism = "hsa",
    pAdjustMethod = "BH",
    pvalueCutoff = pval_cutoff,
    qvalueCutoff = qval_cutoff
  )
  
  return(list(
    go = go_enrich,
    kegg = kegg_enrich,
    entrez_ids = entrez_ids
  ))
}

###############################
# 主分析流程
###############################

# 1. 数据标准化
cat("正在进行数据标准化...\n")
normalized_counts <- normalize_expression(final_counts)

# 2. 准备生存分析数据
prepared_data <- prepare_survival_data(normalized_counts, analysis_data)
expr_matrix <- prepared_data$expr
survival_data <- prepared_data$survival

# 3. 单因素Cox回归
cat("进行单因素Cox回归分析...\n")
uni_cox_results <- univariate_cox_analysis(expr_matrix, survival_data)
significant_genes <- uni_cox_results$significant

cat(paste("发现", nrow(significant_genes), "个与生存显著相关的基因(P < 0.05)\n"))

# 4. LASSO-Cox回归构建风险评分
if (nrow(significant_genes) > 0) {
  cat("进行LASSO-Cox回归分析...\n")
  significant_expr <- expr_matrix[significant_genes$gene, ]
  risk_model <- lasso_cox_model(significant_expr, survival_data)
  
  if (!is.null(risk_model)) {
    cat("风险评分模型构建成功！\n")
    cat("选择的基因:", risk_model$selected_genes, "\n")
    
    # 5. 模型评估
    evaluation <- evaluate_risk_model(risk_model$risk_scores, survival_data)
    
    # 绘制KM生存曲线
    km_plot <- ggsurvplot(
      evaluation$surv_fit,
      data = survival_data,
      pval = TRUE,
      risk.table = TRUE,
      title = "风险评分生存分析",
      xlab = "生存时间(天)",
      ylab = "生存概率"
    )
    print(km_plot)
    
    # 绘制ROC曲线
    plot(evaluation$roc_data, time = 365, title = "1年ROC曲线")
    plot(evaluation$roc_data, time = 1095, title = "3年ROC曲线")
    plot(evaluation$roc_data, time = 1825, title = "5年ROC曲线")
    
    cat("1年AUC:", evaluation$roc_data$AUC[1], "\n")
    cat("3年AUC:", evaluation$roc_data$AUC[2], "\n")
    cat("5年AUC:", evaluation$roc_data$AUC[3], "\n")
    
    # 6. 独立预后分析
    independent_analysis <- independent_prognostic_analysis(
      risk_model$risk_scores, 
      analysis_data, 
      survival_data
    )
    
    cat("多因素Cox回归结果:\n")
    print(independent_analysis$summary$coefficients)
    
    # 7. 功能富集分析
    if (length(risk_model$selected_genes) > 0) {
      cat("进行GO和KEGG富集分析...\n")
      enrichment_results <- perform_enrichment_analysis(risk_model$selected_genes)
      
      # 绘制富集分析结果
      if (!is.null(enrichment_results$go) && nrow(enrichment_results$go) > 0) {
        dotplot(enrichment_results$go, showCategory = 15, title = "GO富集分析")
      }
      
      if (!is.null(enrichment_results$kegg) && nrow(enrichment_results$kegg) > 0) {
        dotplot(enrichment_results$kegg, showCategory = 15, title = "KEGG通路富集分析")
      }
    }
    
  } else {
    cat("LASSO-Cox回归未能选择任何基因，无法构建风险评分模型。\n")
  }
} else {
  cat("未发现与生存显著相关的基因，无法进行后续分析。\n")
}

# 保存关键结果
output_results <- list(
  normalized_counts = normalized_counts,
  univariate_results = uni_cox_results,
  risk_model = if(exists("risk_model")) risk_model else NULL,
  model_evaluation = if(exists("evaluation")) evaluation else NULL,
  independent_analysis = if(exists("independent_analysis")) independent_analysis else NULL,
  enrichment_results = if(exists("enrichment_results")) enrichment_results else NULL
)

cat("分析完成！所有结果已保存到output_results变量中。\n")