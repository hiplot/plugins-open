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

# 构建查询：指定TCGA-LAML项目的转录组定量数据[4,7](@ref)
query_rna <- GDCquery(
  project = "TCGA-LAML",           # 癌症类型（急性髓系白血病）
  data.category = "Transcriptome Profiling", 
  data.type = "Gene Expression Quantification", 
  workflow.type = "STAR - Counts"   # 使用STAR流程生成的原始计数数据
)

# 下载数据到指定目录[3](@ref)
#GDCdownload(query_rna, directory = "data/rnaseq/") 

# 提取数据并转换为数据框（非SummarizedExperiment对象以便于操作）
raw_counts <- GDCprepare(query_rna, summarizedExperiment = FALSE, directory = "data/rnaseq")

# 数据清理：
# a. 选择基因信息列和计数列（包含"unstranded"的列代表原始计数）
# b. 排除TPM/FPKM标准化数据列
# c. 简化样本名（例如将"unstranded_TCGA-AB-1234-01A"简化为"TCGA-AB-1234"）
# d. 清理基因ID版本号（如ENSG000001234.5 -> ENSG000001234）
# e. 过滤掉质量控制基因（如多映射基因）[2](@ref)
raw_counts1 <- raw_counts %>%
  select(gene_id, gene_name, gene_type, contains("unstranded")) %>%
  select(!contains(c("tpm", "fpkm"))) %>%
  rename_with(~ str_replace_all(., c("unstranded_TCGA-AB-" = "", "-.*" = ""))) %>%
  rename_with(~ paste0("TCGA-AB-", .x), !c(gene_id, gene_name, gene_type)) %>%
  mutate(gene_id = str_replace_all(gene_id, "\\..*", "")) %>%
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

# 查询临床补充数据[6](@ref)
query_cli <- GDCquery(
  project = "TCGA-LAML",
  data.category = "Clinical",
  data.type = "Clinical Supplement",
  data.format = "BCR Biotab"
)

# 下载并加载临床数据
#GDCdownload(query_cli, directory = "data/clinical_data/")
clinical.BCRtab.all <- GDCprepare(query_cli, directory = "data/clinical_data/")

# 提取LAML特定临床表并匹配RNA-seq样本[6](@ref)
cli_info_raw <- clinical.BCRtab.all$clinical_patient_laml
cli_info <- cli_info_raw[cli_info_raw$bcr_patient_barcode %in% colnames(final_counts), ]

# 创建生存变量：
# - 生存时间(os)：死亡患者使用死亡时间，存活患者使用末次随访时间
# - 生存状态(os_status)：死亡=1，存活=0
cli_info$os <- ifelse(cli_info$vital_status == "Dead", 
                      cli_info$death_days_to, 
                      cli_info$last_contact_days_to)
cli_info$os_status <- ifelse(cli_info$vital_status == "Dead", 1, 0)

# 分类变量格式化（示例：性别转为因子便于统计建模）
cli_info$gender <- factor(cli_info$gender)

# 整合分析数据集：关键临床变量与生存数据[4](@ref)
analysis_data <- data.frame(
  Patient_ID = cli_info$bcr_patient_barcode,
  Gender = cli_info$gender,
  Age = cli_info$age_at_diagnosis,
  Race = cli_info$race,
  FAB_Subtype = cli_info$fab_category,  # 白血病形态学分类
  Risk_Group = cli_info$cyto_risk_group, # 细胞遗传学风险分组
  Blast_Percentage = cli_info$percent_blasts_peripheral_blood, # 外周血原始细胞比例
  WBC = cli_info$wbc_24hr_of_banking,    # 白细胞计数
  os = cli_info$os,                      # 总生存时间
  os_status = cli_info$os_status,        # 生存状态
  Karnofsky = cli_info$karnofsky_score   # 生活质量评分
)

# 输出说明：
# - final_counts: 过滤后的基因计数矩阵（行=基因，列=样本）
# - analysis_data: 整合后的临床数据集，可用于生存分析或差异表达分析

write.csv(final_counts,"data/output/counts.csv")
save.image("data/output/data_prepare.Rdata")
