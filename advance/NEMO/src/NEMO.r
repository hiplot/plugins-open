# 简化版NEMO多组学聚类分析流程
# 前提：data目录下已存在sample_omic1.txt和sample_omic2.txt

# 1. 安装并加载必要的包
if (!require("devtools", quietly = TRUE)) install.packages("devtools")
if (!require("NEMO", quietly = TRUE)) devtools::install_github('Shamir-Lab/NEMO/NEMO')
if (!require("SNFtool", quietly = TRUE)) install.packages("SNFtool")
if (!require("pheatmap", quietly = TRUE)) install.packages("pheatmap")
if (!require("ggplot2", quietly = TRUE)) install.packages("ggplot2")

library(NEMO)
library(SNFtool)
library(pheatmap)
library(ggplot2)

# 2. 设置目录路径（适配 NEMO/data, NEMO/result, NEMO/src 结构）
dirs <- list(
  data = "data",
  result = "result",
  plots = "result/plots"
)

# 3. 加载并预处理数据
load_data <- function() {
  # 读取数据（确保文件名为 sample_omic1.txt 和 sample_omic2.txt）
  omic1 <- read.table(file.path(dirs$data, "sample_omic1.txt"), 
                      header = TRUE, row.names = 1)
  omic2 <- read.table(file.path(dirs$data, "sample_omic2.txt"), 
                      header = TRUE, row.names = 1)
  
  # 筛选两组数据的共同样本，确保样本顺序一致
  common_samples <- intersect(colnames(omic1), colnames(omic2))
  list(omic1[, common_samples], omic2[, common_samples])
}

omics_list <- load_data()
message("Data loaded successfully: ", length(omics_list), " omics datasets, ", 
        ncol(omics_list[[1]]), " samples in total")

# 4. 执行NEMO聚类（核心步骤）
nemo_result <- nemo.clustering(omics_list)  # 自动确定聚类数和邻域数
affinity_graph <- nemo.affinity.graph(omics_list, k = 50)  # 构建亲和图

# 5. 保存结果（CSV表格：样本-聚类对应关系；RDS：亲和图）
write.csv(
  x = data.frame(
    Sample = names(nemo_result),
    Cluster = as.integer(nemo_result),
    row.names = NULL
  ),
  file = file.path(dirs$result, "clustering_results.csv"),
  row.names = FALSE
)
saveRDS(affinity_graph, file = file.path(dirs$result, "affinity_graph.rds"))

# 6. 生成可视化结果
# 6.1 亲和图热图
pheatmap(
  mat = affinity_graph,
  main = "NEMO Affinity Graph",  
  filename = file.path(dirs$plots, "affinity_heatmap.pdf"),
  show_rownames = FALSE,  
  show_colnames = FALSE
)

# 6.2 聚类分布柱状图
ggplot(
  data = data.frame(Cluster = as.factor(nemo_result)),
  aes(x = Cluster)
) +
  geom_bar(fill = "steelblue", alpha = 0.8) +
  labs(
    title = "Cluster Distribution",  # 英文标题
    x = "Cluster ID",  # 英文X轴标签
    y = "Number of Samples"  # 英文Y轴标签
  ) +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5))  # 标题居中

ggsave(
  filename = file.path(dirs$plots, "cluster_distribution.pdf"),
  width = 8, height = 6, device = "pdf"
)

# 运行完成提示
message("Analysis completed! Results saved to: ", dirs$result)