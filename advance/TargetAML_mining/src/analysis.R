# 加载必要的R包
library(DESeq2)
library(ggplot2)
library(pheatmap)
library(EnhancedVolcano)
library(survival)
library(survminer)
library(forestmodel)
library(clusterProfiler)
library(org.Hs.eg.db)
library(enrichplot)
library(DOSE)
library(dplyr)
library(stringr)

###############################
# 1. 数据加载与预处理优化
###############################

# 安全加载数据，检查文件是否存在
if (!file.exists("data/output/data_prepare.Rdata")) {
  stop("数据文件不存在，请先运行数据准备脚本")
}

# 加载数据
load("data/output/data_prepare.Rdata")

# 检查必要的数据结构是否存在
required_objects <- c("final_counts", "analysis_data")
missing_objects <- setdiff(required_objects, ls())
if (length(missing_objects) > 0) {
  stop(paste("缺少必要的数据对象:", paste(missing_objects, collapse = ", ")))
}

cat("数据加载成功！\n")
cat("表达矩阵维度:", dim(final_counts), "\n")
cat("临床数据样本数:", nrow(analysis_data), "\n")

###############################
# 2. 样本匹配与数据清洗优化
###############################

# 样本匹配函数
match_samples <- function(expr_matrix, clinical_data, patient_id_col = "Patient_ID") {
  clinical_samples <- clinical_data[[patient_id_col]]
  expr_samples <- colnames(expr_matrix)
  
  common_samples <- intersect(clinical_samples, expr_samples)
  
  if (length(common_samples) == 0) {
    stop("没有匹配的样本，请检查样本命名一致性")
  }
  
  cat("匹配样本数:", length(common_samples), "\n")
  cat("临床数据中未匹配样本:", setdiff(clinical_samples, common_samples), "\n")
  cat("表达数据中未匹配样本:", setdiff(expr_samples, common_samples), "\n")
  
  # 筛选共同样本
  filtered_expr <- expr_matrix[, common_samples, drop = FALSE]
  filtered_clinical <- clinical_data[clinical_data[[patient_id_col]] %in% common_samples, ]
  
  # 确保样本顺序一致
  filtered_clinical <- filtered_clinical[match(common_samples, filtered_clinical[[patient_id_col]]), ]
  
  return(list(expr = filtered_expr, clinical = filtered_clinical))
}

# 执行样本匹配
matched_data <- match_samples(final_counts, analysis_data)
filtered_counts <- matched_data$expr
filtered_clinical <- matched_data$clinical

# 数据质量检查函数
check_data_quality <- function(expr_matrix, clinical_data) {
  # 检查表达矩阵
  zero_count_genes <- rowSums(expr_matrix == 0) / ncol(expr_matrix)
  cat("完全零表达基因比例:", mean(zero_count_genes == 1), "\n")
  
  # 检查临床数据完整性
  clinical_completeness <- colSums(!is.na(clinical_data)) / nrow(clinical_data)
  cat("临床变量完整性:\n")
  print(clinical_completeness)
}

check_data_quality(filtered_counts, filtered_clinical)

###############################
# 3. 差异表达分析优化
###############################

# 创建安全的DESeq2分析函数
safe_deseq_analysis <- function(count_matrix, clinical_data, design_formula, 
                                contrast_vec, min_samples_per_group = 3) {
  
  # 检查分组样本数
  group_var <- all.vars(design_formula)[1]
  group_counts <- table(clinical_data[[group_var]])
  
  if (any(group_counts < min_samples_per_group)) {
    stop(paste("分组样本数不足，最小需要", min_samples_per_group, "个样本"))
  }
  
  # 创建样本信息
  sample_info <- data.frame(
    row.names = clinical_data$Patient_ID,
    Group = factor(clinical_data[[group_var]]),
    Gender = factor(clinical_data$Gender),
    Age = as.numeric(clinical_data$Age)
  )
  
  # 确保样本顺序一致
  sample_info <- sample_info[colnames(count_matrix), , drop = FALSE]
  
  # 创建DESeqDataSet
  dds <- DESeqDataSetFromMatrix(
    countData = count_matrix,
    colData = sample_info,
    design = design_formula
  )
  
  # 预过滤低表达基因
  keep <- rowSums(counts(dds) >= 10) >= min_samples_per_group
  dds <- dds[keep, ]
  cat("过滤后基因数:", nrow(dds), "\n")
  
  # 差异表达分析
  dds <- DESeq(dds)
  
  # 获取结果
  res <- results(dds, contrast = contrast_vec, alpha = 0.05)
  
  return(list(dds = dds, results = res, sample_info = sample_info))
}

# 执行差异表达分析
tryCatch({
  dea_results <- safe_deseq_analysis(
    count_matrix = filtered_counts,
    clinical_data = filtered_clinical,
    design_formula = ~ Group,
    contrast_vec = c("Group", "High", "Low")  # 根据实际分组调整
  )
  
  dds <- dea_results$dds
  res <- dea_results$results
  sample_info <- dea_results$sample_info
  
}, error = function(e) {
  cat("差异表达分析错误:", e$message, "\n")
  # 尝试使用更简单的设计
  dea_results <- safe_deseq_analysis(
    count_matrix = filtered_counts,
    clinical_data = filtered_clinical,
    design_formula = ~ 1,  # 仅截距项
    contrast_vec = NULL
  )
  dds <- dea_results$dds
  res <- dea_results$results
  sample_info <- dea_results$sample_info
})

# 处理结果
res_df <- as.data.frame(res)
res_df$gene_symbol <- rownames(res_df)

# 筛选显著差异表达基因（使用更严格的标准）
significant_genes <- res_df %>%
  filter(!is.na(padj)) %>%
  filter(padj < 0.01 & abs(log2FoldChange) > 1.5) %>%  # 更严格的标准
  arrange(padj, desc(abs(log2FoldChange)))

cat("显著差异表达基因数:", nrow(significant_genes), "\n")

# 保存结果
write.csv(res_df, "data/output/differential_expression_results.csv", row.names = FALSE)
write.csv(significant_genes, "data/output/significant_DEGs.csv", row.names = FALSE)

###############################
# 4. 高级可视化优化
###############################

# 创建输出目录
dir.create("data/output/plots", recursive = TRUE, showWarnings = FALSE)

# 增强的火山图函数
create_enhanced_volcano <- function(res_df, title_suffix = "") {
  p <- EnhancedVolcano(res_df,
                       lab = res_df$gene_symbol,
                       x = 'log2FoldChange',
                       y = 'padj',
                       pCutoff = 0.01,
                       FCcutoff = 1.5,
                       pointSize = 2.0,
                       labSize = 3.0,
                       title = paste('差异表达基因火山图', title_suffix),
                       subtitle = paste('显著基因数:', sum(!is.na(res_df$padj) & 
                                                        res_df$padj < 0.01 & 
                                                        abs(res_df$log2FoldChange) > 1.5)),
                       caption = paste('总基因数:', nrow(res_df)),
                       legendLabels = c('不显著', 'Log2FC', 'p-value', 'p-value和Log2FC')
  )
  return(p)
}

# 生成火山图
volcano_plot <- create_enhanced_volcano(res_df, "(高风险 vs 低风险)")
ggsave("data/output/plots/volcano_plot.pdf", volcano_plot, width = 10, height = 8)
ggsave("data/output/plots/volcano_plot.png", volcano_plot, width = 10, height = 8, dpi = 300)

# 智能热图函数
create_intelligent_heatmap <- function(dds, significant_genes, top_n = 30) {
  # 选择顶部基因
  if (nrow(significant_genes) == 0) {
    warning("没有显著差异表达基因，无法生成热图")
    return(NULL)
  }
  
  top_genes <- significant_genes$gene_symbol[1:min(top_n, nrow(significant_genes))]
  
  # 方差稳定变换
  vsd <- vst(dds, blind = FALSE)
  expr_matrix <- assay(vsd)
  
  # 过滤表达矩阵
  heatmap_data <- expr_matrix[rownames(expr_matrix) %in% top_genes, ]
  
  # 创建注释
  annotation_df <- as.data.frame(colData(dds)[, "Group", drop = FALSE])
  
  # 生成热图
  pheatmap(heatmap_data,
           scale = "row",
           show_rownames = TRUE,
           show_colnames = FALSE,
           cluster_cols = TRUE,
           cluster_rows = TRUE,
           annotation_col = annotation_df,
           main = paste("Top", nrow(heatmap_data), "差异表达基因热图"),
           fontsize_row = 8,
           fontsize_col = 8,
           filename = "data/output/plots/heatmap.pdf",
           width = 12,
           height = 10
  )
}

# 生成热图
heatmap_result <- create_intelligent_heatmap(dds, significant_genes)

###############################
# 5. 生存分析优化
###############################

# 安全的生存分析函数
safe_survival_analysis <- function(clinical_data, expr_matrix, target_genes = c("TP53", "FLT3", "NPM1")) {
  
  results <- list()
  
  for (target_gene in target_genes) {
    if (!target_gene %in% rownames(expr_matrix)) {
      warning(paste("基因", target_gene, "不在表达矩阵中"))
      next
    }
    
    # 获取基因表达量
    gene_expression <- as.numeric(expr_matrix[target_gene, ])
    
    # 使用最佳截断值（可选：使用survminer的surv_cutpoint）
    if (requireNamespace("survminer", quietly = TRUE)) {
      tryCatch({
        cutoff <- surv_cutpoint(data.frame(expr = gene_expression, 
                                           time = clinical_data$os, 
                                           status = clinical_data$os_status),
                                time = "time", event = "status", variables = "expr")
        expression_cutoff <- cutoff$cutpoint$cutpoint
      }, error = function(e) {
        expression_cutoff <- median(gene_expression, na.rm = TRUE)
      })
    } else {
      expression_cutoff <- median(gene_expression, na.rm = TRUE)
    }
    
    clinical_data$expression_group <- ifelse(gene_expression > expression_cutoff, "High", "Low")
    clinical_data$expression_group <- factor(clinical_data$expression_group, levels = c("Low", "High"))
    
    # 创建生存对象
    surv_obj <- Surv(time = as.numeric(clinical_data$os), 
                     event = as.numeric(clinical_data$os_status))
    
    # 生存分析
    surv_fit <- survfit(surv_obj ~ expression_group, data = clinical_data)
    
    # Log-rank检验
    surv_diff <- survdiff(surv_obj ~ expression_group, data = clinical_data)
    p_value <- 1 - pchisq(surv_diff$chisq, length(surv_diff$n) - 1)
    
    # 绘制生存曲线
    km_plot <- ggsurvplot(surv_fit,
                          data = clinical_data,
                          pval = TRUE,
                          pval.method = TRUE,
                          conf.int = TRUE,
                          risk.table = TRUE,
                          legend.labs = c("低表达", "高表达"),
                          title = paste("生存曲线 -", target_gene),
                          xlab = "时间 (天)",
                          ylab = "生存概率",
                          palette = c("#E7B800", "#2E9FDF"))
    
    # 保存图片
    ggsave(paste0("data/output/plots/km_plot_", target_gene, ".pdf"), 
           km_plot$plot, width = 10, height = 8)
    ggsave(paste0("data/output/plots/km_plot_", target_gene, ".png"), 
           km_plot$plot, width = 10, height = 8, dpi = 300)
    
    results[[target_gene]] <- list(
      plot = km_plot,
      p_value = p_value,
      cutoff = expression_cutoff
    )
  }
  
  return(results)
}

# 执行生存分析
survival_results <- safe_survival_analysis(filtered_clinical, filtered_counts)

###############################
# 6. 功能富集分析优化
###############################

# 安全的功能富集分析
safe_enrichment_analysis <- function(significant_genes, background_genes = NULL) {
  
  if (nrow(significant_genes) < 10) {
    warning("显著基因数太少，可能无法获得有意义的富集结果")
    return(NULL)
  }
  
  de_genes <- significant_genes$gene_symbol
  
  # 转换为Entrez ID
  gene_entrez <- tryCatch({
    bitr(de_genes, fromType = "SYMBOL", 
         toType = "ENTREZID", 
         OrgDb = org.Hs.eg.db)
  }, error = function(e) {
    warning("基因ID转换失败:", e$message)
    return(NULL)
  })
  
  if (is.null(gene_entrez) return(NULL)
      
      # GO富集分析
      go_results <- list()
      for (ontology in c("BP", "MF", "CC")) {
        go_enrich <- enrichGO(gene = gene_entrez$ENTREZID,
                              OrgDb = org.Hs.eg.db,
                              keyType = "ENTREZID",
                              ont = ontology,
                              pAdjustMethod = "BH",
                              qvalueCutoff = 0.05,
                              readable = TRUE)
        
        if (nrow(go_enrich) > 0) {
          # 保存结果
          write.csv(as.data.frame(go_enrich), 
                    paste0("data/output/GO_", ontology, "_results.csv"))
          
          # 可视化
          tryCatch({
            dot_plot <- dotplot(go_enrich, showCategory = 10, title = paste("GO", ontology, "富集分析"))
            ggsave(paste0("data/output/plots/GO_", ontology, "_dotplot.pdf"), dot_plot, width = 10, height = 8)
          }, error = function(e) {
            warning(paste("GO", ontology, "可视化失败:", e$message))
          })
        }
        
        go_results[[ontology]] <- go_enrich
      }
      
      # KEGG富集分析
      kegg_enrich <- tryCatch({
        enrichKEGG(gene = gene_entrez$ENTREZID,
                   organism = 'hsa',
                   pAdjustMethod = "BH",
                   qvalueCutoff = 0.05)
      }, error = function(e) {
        warning("KEGG富集分析失败:", e$message)
        return(NULL)
      })
      
      if (!is.null(kegg_enrich) && nrow(kegg_enrich) > 0) {
        write.csv(as.data.frame(kegg_enrich), "data/output/KEGG_enrichment_results.csv")
        
        tryCatch({
          kegg_dot <- dotplot(kegg_enrich, showCategory = 15, title = "KEGG通路富集分析")
          ggsave("data/output/plots/KEGG_enrichment.pdf", kegg_dot, width = 12, height = 8)
        }, error = function(e) {
          warning("KEGG可视化失败:", e$message)
        })
      }
      
      return(list(GO = go_results, KEGG = kegg_enrich))
}

# 执行功能富集分析
if (nrow(significant_genes) >= 10) {
  enrichment_results <- safe_enrichment_analysis(significant_genes)
} else {
  cat("显著基因数不足，跳过功能富集分析\n")
}

###############################
# 7. 结果汇总报告
###############################

# 生成分析报告
generate_analysis_report <- function() {
  report <- list(
    analysis_date = Sys.Date(),
    total_samples = ncol(filtered_counts),
    total_genes = nrow(filtered_counts),
    significant_deg = nrow(significant_genes),
    upregulated = sum(significant_genes$log2FoldChange > 0, na.rm = TRUE),
    downregulated = sum(significant_genes$log2FoldChange < 0, na.rm = TRUE),
    survival_genes_analyzed = ifelse(exists("survival_results"), 
                                     length(survival_results), 0)
  )
  
  # 保存报告
  capture.output(print(report), file = "data/output/analysis_report.txt")
  
  # 生成Markdown格式报告
  md_report <- c(
    "# TARGET-AML分析报告",
    paste("生成时间:", report$analysis_date),
    "",
    "## 分析摘要",
    paste("- 总样本数:", report$total_samples),
    paste("- 总基因数:", report$total_genes),
    paste("- 显著差异表达基因:", report$significant_deg),
    paste("  - 上调基因:", report$upregulated),
    paste("  - 下调基因:", report$downregulated),
    paste("- 生存分析基因数:", report$survival_genes_analyzed)
  )
  
  writeLines(md_report, "data/output/analysis_report.md")
  
  return(report)
}

# 生成报告
analysis_report <- generate_analysis_report()

cat("分析完成！详细结果请查看 data/output/ 目录\n")
cat("主要输出:\n")
cat("- 差异表达结果: differential_expression_results.csv\n")
cat("- 显著差异基因: significant_DEGs.csv\n")
cat("- 可视化图表: plots/ 目录\n")
cat("- 分析报告: analysis_report.md\n")
