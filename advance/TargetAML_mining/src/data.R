# 加载必要的R包
# TCGAbiolinks: 用于从TCGA数据库下载和预处理数据[3,4](@ref)
# SummarizedExperiment: 用于处理基因组学数据对象[5,9](@ref)
# dplyr/stringr/readr: 数据清理和字符串处理
library(TCGAbiolinks)
library(SummarizedExperiment)
library(dplyr)
library(readr)
library(stringr)

###############################
# 1. RNA-seq数据下载与预处理
###############################

# 构建查询：确认workflow.type的可用性
query_rna <- GDCquery(
  project = "TARGET-AML",
  data.category = "Transcriptome Profiling", 
  data.type = "Gene Expression Quantification", 
  workflow.type = "STAR - Counts"  # 改用更通用的类型
)

# 下载数据
GDCdownload(query_rna, directory = "data/rnaseq/") 

# 准备数据
raw_counts <- GDCprepare(query_rna, summarizedExperiment = FALSE, directory = "data/rnaseq")

# 数据清理：修正样本名清洗逻辑以适配TARGET条形码
# 假设原始列名格式为："unstranded_TARGET-20-PARUDZ-01A-01R"
raw_counts1 <- raw_counts %>%
  select(gene_id, gene_name, gene_type, contains("unstranded")) %>%
  select(!contains(c("tpm", "fpkm"))) %>%
  # 提取患者ID：例如将"unstranded_TARGET-20-PARUDZ-01A"清洗为"TARGET-20-PARUDZ"
  rename_with(~ str_remove_all(., "^unstranded_")) %>%  # 移除开头的"unstranded_"
  rename_with(~ str_remove(., "-.*$")) %>%  # 移除第一个"-"后的所有字符（如样本部分）
  mutate(gene_id = str_replace(gene_id, "\\..*", "")) %>%  # 清理基因ID版本号
  filter(!gene_id %in% c("N_ambiguous", "N_multimapping", "N_noFeature", "N_unmapped"))

# 提取计数矩阵：前3列为基因信息，后续列为样本计数
counts_matrix <- as.matrix(raw_counts1[, -c(1:3)])
rownames(counts_matrix) <- raw_counts1$gene_name  # 将基因名设为行名

# 基因过滤：保留在至少50%样本中计数大于1的基因（减少低表达基因噪声）[2](@ref)
keep <- rowSums(counts_matrix > 1) >= (ncol(counts_matrix) * 0.5)
filtered_counts <- counts_matrix[keep, ]

# 进一步筛选蛋白编码基因（可根据需求调整如lncRNA）[5](@ref)
filtered_gene_info <- raw_counts1[keep, c("gene_id", "gene_name", "gene_type")]
protein_coding_genes <- filtered_gene_info$gene_type == "protein_coding"
final_counts <- filtered_counts[protein_coding_genes, ]
final_gene_info <- filtered_gene_info[protein_coding_genes, ]




###############################
# 2. 临床数据下载与整合
###############################

query_cli <- GDCquery(
  project = "TARGET-AML",
  data.category = "Clinical",
  data.type = "Clinical Supplement",
  data.format = "BCR Biotab"
)

GDCdownload(query_cli, directory = "data/clinical_data/")
clinical.BCRtab.all <- GDCprepare(query_cli, directory = "data/clinical_data/")

# 关键步骤：检查并选择正确的临床数据表名
print(names(clinical.BCRtab.all)) # 查看所有表的名称
# 根据输出结果选择正确的表，例如可能是'clinical_patient_aml'
cli_info_raw <- clinical.BCRtab.all$clinical_patient_aml  # 注意表名可能不同
cli_info <- cli_info_raw[cli_info_raw$bcr_patient_barcode %in% colnames(final_counts), ]

# 创建生存变量：
# - 生存时间(os)：死亡患者使用死亡时间，存活患者使用末次随访时间
# - 生存状态(os_status)：死亡=1，存活=0
cli_info$os <- ifelse(cli_info$vital_status == "Dead", 
                      cli_info$death_days_to, 
                      cli_info$last_contact_days_to)
cli_info$os_status <- ifelse(cli_info$vital_status == "Dead", 1, 0)



save.image("data/output/data_prepare.Rdata")
