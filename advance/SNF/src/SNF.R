library(SNFtool)
library(data.table)
library(pheatmap)
library(NMF)

#' SNF分析工具主函数
#'
#' @param expr_file 表达量数据文件路径
#' @param beta_file 甲基化beta值文件路径
#' @param output_dir 结果输出目录
#' @param K 邻居数量，默认50
#' @param alpha 相似性矩阵参数，默认0.6
#' @param T 迭代次数，默认50
#' @param n_clust 聚类数目范围，默认2:5
#' @return 返回包含SNF结果和聚类信息的列表
snf_analysis <- function(expr_file, beta_file, output_dir = "result", 
                         K = 50, alpha = 0.6, T = 50, n_clust = 2:5) {
  
  # 设置环境参数
  setup_environment()
  
  # 创建输出目录
  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)
  }
  
  # 读取和预处理数据
  multi_omics_data <- load_and_preprocess_data(expr_file, beta_file)
  
  # 执行SNF分析
  snf_result <- run_snf_analysis(multi_omics_data, K, alpha, T)
  
  # 聚类和可视化
  clustering_results <- perform_clustering_and_heatmap(snf_result$W, n_clust, output_dir)
  
  # 返回完整结果
  return(list(
    multi_omics_data = multi_omics_data,
    similarity_matrices = snf_result$W_list,
    fused_matrix = snf_result$W,
    clustering_results = clustering_results,
    parameters = list(K = K, alpha = alpha, T = T, n_clust = n_clust)
  ))
}

#' 设置分析环境
setup_environment <- function() {
  # 显示英文报错信息
  Sys.setenv(LANGUAGE = "en")
  # 禁止chr转成factor
  options(stringsAsFactors = FALSE)
}

#' 读取和预处理多组学数据
load_and_preprocess_data <- function(expr_file, beta_file) {
  # 读取表达量数据
  expr <- fread(expr_file, sep = "\t", check.names = FALSE, 
                stringsAsFactors = FALSE, header = TRUE, data.table = FALSE)
  rownames(expr) <- expr[, 1]
  expr <- expr[, -1]
  expr <- expr[rowSums(expr) > 0, ]
  expr <- as.data.frame(t(scale(t(log2(expr + 1)))))
  
  # 读取甲基化数据并转换为M值
  beta <- fread(beta_file, sep = "\t", check.names = FALSE, 
                stringsAsFactors = FALSE, header = TRUE, data.table = FALSE)
  rownames(beta) <- beta[, 1]
  beta <- beta[, -1]
  beta <- as.data.frame(na.omit(beta))
  mvalue <- as.data.frame(wateRmelon::Beta2M(beta))
  
  # 获取共同样本
  comsam <- intersect(colnames(expr), colnames(mvalue))
  
  # 返回多组学数据列表
  return(list(
    mrna = as.matrix(expr[, comsam]),
    meth = as.matrix(mvalue[, comsam]),
    common_samples = comsam
  ))
}

#' 运行SNF分析
run_snf_analysis <- function(multi_omics_data, K, alpha, T) {
  # 提取组学数据（排除common_samples元素）
  omics_types <- names(multi_omics_data)
  omics_types <- omics_types[omics_types != "common_samples"]
  moic.list <- multi_omics_data[omics_types]
  
  # 计算相似性矩阵
  W.list <- list()
  for (m in 1:length(moic.list)) {
    message("-- Processing ", names(moic.list)[m], " data...")
    W.list[[m]] <- affinityMatrix(
      as.matrix(dist(t(moic.list[[m]]))), 
      K = K, 
      sigma = alpha
    )
  }
  
  # 融合相似性矩阵
  W <- SNF(W.list, K = K, t = T)
  
  return(list(W_list = W.list, W = W))
}

#' 执行聚类和热图绘制
perform_clustering_and_heatmap <- function(W, n_clust, output_dir) {
  # 自定义归一化函数
  normalize <- function(X) X / rowSums(X)
  
  clustering_results <- list()
  
  for (n in n_clust) {
    message("-- Generating heatmap with cluster number of ", n, "...")
    
    # 谱聚类
    clust <- spectralClustering(W, K = n)
    
    # 排序索引
    ind <- sort(as.vector(clust), index.return = TRUE)$ix
    
    # 准备热图数据
    diag(W) <- median(as.vector(W))
    indata <- normalize(W)
    indata <- indata + t(indata)
    
    # 绘制热图
    heatmap_file <- file.path(output_dir, paste0("snf_heatmap_cluster_", n, ".pdf"))
    hm <- pheatmap(indata[ind, ind],
                   color = NMF:::ccRamp(c("white", "red"), 64),
                   border_color = NA,
                   cluster_cols = FALSE,
                   cluster_rows = FALSE,
                   show_rownames = FALSE,
                   show_colnames = FALSE,
                   main = paste("SNF Heatmap -", n, "Clusters"),
                   filename = heatmap_file)
    
    # 保存聚类结果
    clustering_results[[as.character(n)]] <- list(
      cluster_number = n,
      cluster_assignments = clust,
      heatmap_file = heatmap_file
    )
  }
  
  return(clustering_results)
}

#' 示例使用函数
example_usage <- function() {
  # 设置文件路径
  expr_file <- "data/input_expr.txt"
  beta_file <- "data/input_beta.txt"
  output_dir <- "result"
  
  # 运行SNF分析
  result <- snf_analysis(
    expr_file = expr_file,
    beta_file = beta_file,
    output_dir = output_dir,
    K = 50,
    alpha = 0.6,
    T = 50,
    n_clust = 2:5
  )
  
  # 打印摘要信息
  cat("SNF分析完成！\n")
  cat("共同样本数量:", length(result$multi_omics_data$common_samples), "\n")
  cat("组学数据类型:", names(result$multi_omics_data)[1:2], "\n")
  cat("生成的聚类数目:", names(result$clustering_results), "\n")
  
  return(result)
}

# 如果直接运行此脚本，则执行示例
if (sys.nframe() == 0) {
  # 检查必要的数据文件是否存在
  if (file.exists("data/input_expr.txt") && file.exists("data/input_beta.txt")) {
    result <- example_usage()
  } else {
    cat("请确保数据文件存在于指定路径: data/input_expr.txt 和 data/input_beta.txt\n")
    cat("函数已加载，您可以通过 snf_analysis() 函数使用此工具。\n")
  }
}
