# MCIA分析完整流程脚本
# 功能：从数据加载到基因筛选的全流程自动化分析
# 目录结构要求：
# ./MCIA/
#   ├── data/       # 存放输入数据
#   └── result/     # 存放输出结果

# 1. 环境设置与依赖包加载
library(omicade4)
library(ade4)
library(made4)

# 设置工作目录
dir.create("data", showWarnings = FALSE)
dir.create("result", showWarnings = FALSE)

# 2. 数据加载与验证
## 2.1 加载数据（支持内置测试数据和用户自有数据）
data_path <- "data/NCI60_4arrays.RData"
if (!file.exists(data_path)) {
  message("使用内置NCI60数据集作为示例数据...")
  data(NCI60_4arrays)
  save(NCI60_4arrays, file = data_path)
} else {
  message("加载用户数据...")
  load(data_path)
}

## 2.2 数据格式验证
if (!is.list(NCI60_4arrays) || length(NCI60_4arrays) < 2) {
  stop("数据格式错误：需为包含至少2个数据集的列表")
}
message(paste("成功加载", length(NCI60_4arrays), "个数据集"))

# 3. 数据预处理
## 3.1 维度检查
data_dims <- sapply(NCI60_4arrays, dim)
cat("数据集维度信息：\n")
print(data_dims)

## 3.2 样本一致性验证
sample_names <- sapply(NCI60_4arrays, colnames)
if (!all(apply(sample_names[, -1, drop = FALSE], 2, function(x) identical(x, sample_names[, 1])))) {
  stop("样本顺序不一致，请统一所有数据集的样本顺序")
}
message("样本顺序验证通过")

## 3.3 生成层次聚类图
pdf("result/hierarchical_clustering.pdf", width = 12, height = 8)
  layout(matrix(1:length(NCI60_4arrays), nrow = 1))
  for (i in names(NCI60_4arrays)) {
    dist_matrix <- dist(t(NCI60_4arrays[[i]]))
    plot(hclust(dist_matrix), main = i, cex = 0.6)
  }
dev.off()
message("层次聚类图已保存至result目录")

# 4. 多重共惯性分析(MCIA)
mcia_result <- mcia(NCI60_4arrays, cia.nf = 10)
saveRDS(mcia_result, "result/mcia_result.rds")
message("MCIA分析完成，结果已保存")

# 5. 结果可视化
## 5.1 提取癌症类型信息
cancer_types <- sapply(strsplit(colnames(NCI60_4arrays[[1]]), "\\."), "[", 1)

## 5.2 生成主要特征向量组合的可视化结果
for (axes in list(c(1,2), c(1,3), c(2,3))) {
  pdf(paste0("result/mcia_plot_axes", axes[1], "_", axes[2], ".pdf"), width = 10, height = 8)
    plot(mcia_result, 
         axes = axes, 
         phenovec = cancer_types, 
         sample.lab = FALSE,
         main = paste("MCIA 轴", axes[1], "vs", axes[2]))
  dev.off()
}
message("MCIA可视化结果已保存至result目录")

# 6. 基因筛选与可视化
## 6.1 筛选黑色素瘤相关基因（轴1坐标≥2）
melanoma_genes <- selectVar(mcia_result, a1.lim = c(2, Inf), a2.lim = c(-Inf, Inf))
write.csv(melanoma_genes, "result/melanoma_related_genes.csv", row.names = FALSE)

## 6.2 关键基因可视化
pdf("result/key_genes_visualization.pdf", width = 8, height = 6)
  plotVar(mcia_result, var = c("S100A1", "S100B"), var.lab = TRUE, main = "关键基因投影")
dev.off()

message("基因筛选完成，结果已保存至result目录")
message("全流程分析结束！")
