# === 1. 包和依赖加载与环境设置 ===
# 需要预先安装的包：SNFtool, data.table, pheatmap, wateRmelon
required_packages <- c("SNFtool", "data.table", "pheatmap", "wateRmelon")
missing_packages <- required_packages[!sapply(required_packages, requireNamespace, quietly = TRUE)]

if(length(missing_packages) > 0) {
  install.packages(missing_packages)
}

# 加载必要的库
library(SNFtool)
library(data.table)
library(pheatmap)
library(wateRmelon) # 加载用于Beta2M转换的包

# 自定义函数
normalize <- function(X) {
  row_sums <- rowSums(X)
  # 避免除以零
  row_sums[row_sums == 0] <- 1
  return(X / row_sums)
}

# 设置语言环境和字符串处理选项
Sys.setenv(LANGUAGE = "en")
options(stringsAsFactors = FALSE)

# === 2. 数据输入与验证 ===
# 定义输入文件路径
expr_file_path <- "data/easy_input_expr.txt"
beta_file_path <- "data/easy_input_beta.txt"

# 检查文件是否存在
if (!file.exists(expr_file_path)) {
  stop("Expression file not found: ", expr_file_path)
}
if (!file.exists(beta_file_path)) {
  stop("Beta file not found: ", beta_file_path)
}

# 加载表达谱数据
message("Loading expression data...")
expr <- fread(expr_file_path, sep = "\t", check.names = FALSE, stringsAsFactors = FALSE, header = TRUE, data.table = FALSE)
if (ncol(expr) < 2) stop("Expression data must have at least one sample column.")
rownames(expr) <- expr[,1]
expr <- expr[,-1, drop=FALSE] # 保留数据框结构
# 过滤掉所有表达量为0的基因
expr <- expr[rowSums(expr) > 0,, drop=FALSE]
# 对表达量进行对数转换和标准化 log2(x+1)，然后按基因标准化 (scale by row)
# 检查是否有负值（虽然不太可能）
if (any(expr < 0, na.rm = TRUE)) {
  warning("Expression data contains negative values. Consider checking the data.")
}
expr <- as.data.frame(t(scale(t(log2(expr + 1)))))

# 加载甲基化数据
message("Loading methylation data...")
beta <- fread(beta_file_path, sep = "\t", check.names = FALSE, stringsAsFactors = FALSE, header = TRUE, data.table = FALSE)
if (ncol(beta) < 2) stop("Methylation data must have at least one sample column.")
rownames(beta) <- beta[,1]
beta <- beta[,-1, drop=FALSE] # 保留数据框结构
# 检查beta值范围
if (any(beta < 0 | beta > 1, na.rm = TRUE)) {
  warning("Methylation beta values are outside the [0,1] range. Consider checking the data.")
}
beta <- as.data.frame(na.omit(beta)) # 移除包含NA的行
message("Methylation data dimensions after removing NAs: ", nrow(beta), " x ", ncol(beta))

# === 3. 数据预处理 ===
# 将甲基化beta值转换为M值 (logit transformation)
# M值 = log2(beta / (1 - beta))，更适合统计分析
message("Converting beta values to M values...")
mvalue <- as.data.frame(Beta2M(beta))


# 获取在两种数据中都存在的共同样本
comsam <- intersect(colnames(expr), colnames(mvalue))
if (length(comsam) == 0) {
  stop("No common samples found between expression and methylation data.")
} else if (length(comsam) < 2) {
  stop("Less than 2 common samples found between expression and methylation data. Cannot proceed with clustering.")
}
message("Found ", length(comsam), " common samples.")

# 构建多组学数据列表，确保样本顺序一致
moic.list <- list(
  mrna = as.matrix(expr[,comsam, drop=FALSE]),   # 表达谱数据
  meth = as.matrix(mvalue[,comsam, drop=FALSE])  # 甲基化M值数据
)

# === 4. SNF算法参数设置 ===
para.K <- 50      # 邻居数量，用于构建相似性网络
para.alpha <- 0.6 # 扩散参数，控制相似性传播
para.T <- 50      # 迭代次数，用于网络融合

message("SNF parameters: K=", para.K, ", alpha=", para.alpha, ", T=", para.T)

# === 5. 相似性网络构建 ===
message("Building similarity networks...")
W.list <- list()
for (m in 1:length(moic.list)) {
  message("-- Processing omics data: ", names(moic.list)[m])
  # 计算样本间的欧氏距离矩阵，然后转换为亲和度矩阵
  dist_matrix <- as.matrix(dist(t(moic.list[[m]])))
  # 检查距离矩阵是否包含Inf或NaN
  if (any(is.infinite(dist_matrix)) | any(is.nan(dist_matrix))) {
    warning("Distance matrix for ", names(moic.list)[m], " contains infinite or NaN values.")
  }
  W.list[[m]] <- affinityMatrix(dist_matrix, K = para.K, sigma = para.alpha)
}

# === 6. 网络融合 ===
message("Fusing similarity networks...")
W <- SNF(W.list, K = para.K, t = para.T)
message("Fusion complete. Similarity matrix dimensions: ", nrow(W), " x ", ncol(W))

# === 7. 谱聚类分析与热图生成 ===
# 对融合后的相似性矩阵进行谱聚类，尝试不同的聚类数k
n.clust <- 2:5 # 尝试k=2,3,4,5个亚型
all_clust_results <- list() # 存储所有聚类结果

for (n in n.clust) {
  message("-- Generating results for cluster number ", n, "...")
  clust <- spectralClustering(W, K = n) # 执行谱聚类
  all_clust_results[[as.character(n)]] <- clust
  
  # 获取按聚类排序后的样本索引
  ind <- sort(as.vector(clust), index.return = TRUE)$ix
  
  # 预处理相似性矩阵用于热图可视化
  W_diag_backup <- diag(W) # 备份对角线
  diag(W) <- median(as.vector(W), na.rm = TRUE) # 设置对角线为中位数
  indata <- normalize(W) # 标准化
  indata <- indata + t(indata) # 对称化
  # 恢复原始对角线值
  diag(W) <- W_diag_backup
  
  # 绘制并保存热图
  output_filename <- paste0("snf_heatmap_with_cluster_number_of_", n, ".pdf")
  message("Saving heatmap to ", output_filename)
  tryCatch({
    pheatmap(indata[ind, ind],
             color = colorRampPalette(c("white", "red"))(64), # 使用更标准的调色板函数
             border_color = NA,
             cluster_cols = FALSE,
             cluster_rows = FALSE,
             show_rownames = FALSE,
             show_colnames = FALSE,
             name = "SNF",
             filename = output_filename,
             width = 8, height = 8) # 添加图片尺寸
  }, error = function(e) {
    warning("Error saving heatmap for k=", n, ": ", e$message)
  })
}

# === 8. 最终聚类结果 (假设选择k=4) ===
# 在实际应用中，应根据热图清晰度或其他指标选择最优k
final_k <- 4 # 可以根据需要修改
if (!as.character(final_k) %in% names(all_clust_results)) {
  stop("Final k (", final_k, ") not found in clustering results. Available: ", paste(names(all_clust_results), collapse = ", "))
}

message("Selecting final clustering result with k=", final_k)
clust_final <- all_clust_results[[as.character(final_k)]]
names(clust_final) <- colnames(moic.list) # 将样本名赋给聚类标签

# 获取按聚类排序后的样本顺序
ind_final <- sort(as.vector(clust_final), index.return = TRUE)$ix
diag(W) <- median(as.vector(W), na.rm = TRUE) # 再次设置对角线，因为W可能被修改
indata_final <- normalize(W)
indata_final <- indata_final + t(indata_final)
# 获取按聚类排序后的样本顺序
sam_order <- rownames(indata_final)[ind_final]

# === 9. 输出结果汇总 ===
message("\n=== SNF Analysis Complete ===")
message("Number of samples processed: ", nrow(W))
message("Final number of clusters (k): ", final_k)
message("Cluster distribution: ", paste(table(clust_final), collapse = ", "))
message("Sample order (first 10): ", paste(head(sam_order, 10), collapse = ", ..."))

# 创建结果列表
snf_results <- list(
  fusion_matrix = W,
  final_clustering = clust_final,
  sorted_sample_order = sam_order,
  intermediate_results = all_clust_results,
  sample_overlap = comsam,
  moic_data_used = moic.list
)

# 保存结果到R对象文件（可选）
save(snf_results, file = "snf_analysis_results.RData")
message("Results saved to snf_analysis_results.RData")

# 显示聚类结果摘要
print(table(clust_final))

# sessionInfo() # 显示R会话信息



