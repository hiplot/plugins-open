# Purpose:
# Retrieve raw counts

library(TCGAbiolinks)
library(dplyr)
library(readr)
library(stringr)

rnaseq <- GDCquery(
  project = "TCGA-LAML",
  data.category = "Transcriptome Profiling",
  data.type = "Gene Expression Quantification",
  workflow.type = "STAR - Counts",
  experimental.strategy = "RNA-Seq"
)

GDCdownload(rnaseq,
            directory = "/home/zjy/workspace/OSPP/6.public_database_mining/6-1_TCGA_LAML/data/rnaseq/", 
            method = "api",
            files.per.chunk = 1
)

raw_counts <- GDCprepare(rnaseq, summarizedExperiment = FALSE, directory = "/home/zjy/workspace/OSPP/6.public_database_mining/6-1_TCGA_LAML/data/rnaseq")

raw_counts <- raw_counts %>%
  select(
    gene_id,
    gene_name,
    gene_type,
    contains("unstranded")
  ) %>%
  select(!contains(c("tpm", "fpkm"))) %>%
  rename_with(~ str_replace_all(., c("unstranded_TCGA-AB-" = "", "-.*" = ""))) %>%
  rename_with(~ paste0("TCGA-AB-", .x, recycle0 = TRUE), !c(gene_id, gene_name, gene_type)) %>%
  mutate(gene_id = str_replace_all(gene_id, "\\..*", "")) %>%
  filter(
    !gene_id %in% c("N_ambiguous", "N_multimapping", "N_noFeature", "N_unmapped")
  )

write_csv(raw_counts, snakemake@output[["raw_counts"]])
