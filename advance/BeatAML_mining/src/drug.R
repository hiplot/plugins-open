library(openxlsx)
library(data.table)
library(ComplexHeatmap)
beat_samples <- read.xlsx("data/beat.overlap.xlsx")

drug <- fread("data/beataml_probit_curve_fits_v4_dbgap.txt", data.table = FALSE)

drug <- drug[drug$dbgap_rnaseq_sample %in% beat_samples$sample_id,]

drug2 <- merge(beat_samples[,c(1,2, 17, 18)], drug, all.y = TRUE, by.x = 1, by.y = 3)

drug2$age_group <- agmin::ag_cut(drug2$ageAtDiagnosis, interval = 5)
drug2$age_group[as.numeric(drug2$age_group) < 6] <- "40-44"
drug2$age_group[as.numeric(drug2$age_group) %in%c(7,8,9)] <- "55-59"
drug2$age_group[as.numeric(drug2$age_group) > 9] <- "60-64"
drug2$age_group <- as.character(drug2$age_group)

drug2$age_group[drug2$age_group %in% "40-44"] <- "<45"
drug2$age_group[drug2$age_group %in% "55-59"] <- "45-59"
drug2$age_group[drug2$age_group %in% "60-64"] <- ">=60"

saveRDS(drug2, "BeatAML.drug.df.RDS")

#drug2 <- drug2[!is.na(drug2$Subgroups),]
drug2 <- drug2[!is.na(drug2$age_group),]
drug2 <- drug2[!is.na(drug2$consensusAMLFusions),]

auc_median_mat <- matrix(ncol = 155, nrow = 8)
colnames(auc_median_mat) <- unique(drug2$inhibitor)
row.names(auc_median_mat) <- paste0("G", 1:8)
auc_median_mat <- as.data.frame(auc_median_mat)
for (i in unique(drug2$inhibitor)) {
  for (j in paste0("G", 1:8)) {
    tmp <- drug2[drug2$inhibitor == i & drug2$Subgroups == j,]
    if (nrow(tmp) == 0) next
    auc_median_mat[j, i] <- median(tmp$auc, na.rm = TRUE)
  }
}

x <- apply(auc_median_mat, 2, scale)
row.names(x) <- row.names(auc_median_mat)
x[is.na(x)] <- 0
library(circlize)
col1 = colorRamp2(c(quantile(x, 0.02), median(x), quantile(x, 0.98)), c("navy", "white","firebrick3"))

ha = HeatmapAnnotation(cn = anno_text(colnames(x), just = "top", offset = unit(1, "npc")))
                       
p <- ComplexHeatmap::Heatmap(x, col=col1, row_names_gp = gpar(fontsize = 10),
                             column_names_gp = gpar(fontsize = 3),
                             clustering_distance_rows = function(x) as.dist((1-cor(t(x)))/2),
                             clustering_distance_columns = function(x) as.dist((1-cor(t(x)))/2),
                             clustering_method_rows = "ward.D",
                             cluster_rows = FALSE,
                             clustering_method_columns = "ward.D",
                             bottom_annotation = ha,
                             show_column_names = FALSE)

pdf("drug_auc.pdf", width = 24, height = 5)
p
dev.off()

## age group
auc_median_mat <- matrix(ncol = 155, nrow = 3)
colnames(auc_median_mat) <- unique(drug2$inhibitor)
row.names(auc_median_mat) <- c("<45", "45-59", ">=60")
auc_median_mat <- as.data.frame(auc_median_mat)
for (i in unique(drug2$inhibitor)) {
  for (j in c("<45", "45-59", ">=60")) {
    tmp <- drug2[drug2$inhibitor == i & drug2$age_group == j,]
    if (nrow(tmp) == 0) next
    auc_median_mat[j, i] <- median(tmp$auc, na.rm = TRUE)
  }
}

x <- apply(auc_median_mat, 2, scale)
row.names(x) <- row.names(auc_median_mat)
x[is.na(x)] <- 0
library(circlize)
col1 = colorRamp2(c(quantile(x, 0.02), median(x), quantile(x, 0.98)), c("navy", "white","firebrick3"))

ha = HeatmapAnnotation(cn = anno_text(colnames(x), just = "top", offset = unit(0.5, "npc")))

p <- ComplexHeatmap::Heatmap(x, col=col1, row_names_gp = gpar(fontsize = 10),
                             column_names_gp = gpar(fontsize = 3),
                             clustering_distance_rows = function(x) as.dist((1-cor(t(x)))/2),
                             clustering_distance_columns = function(x) as.dist((1-cor(t(x)))/2),
                             clustering_method_rows = "ward.D",
                             cluster_rows = FALSE,
                             clustering_method_columns = "ward.D",
                             bottom_annotation = ha,
                             show_column_names = FALSE)

pdf("drug_auc_agegroup_gf_positive.pdf", width = 24, height = 5)
p
dev.off()

a0 <- t(data.frame(a=paste0("G", 1:8)))
a <- combn(paste0("G", 1:8), 2)
b <- combn(paste0("G", 1:8), 3)
c <- combn(paste0("G", 1:8), 4)

call_auc <- function (cmat) {
  cmat <- as.data.frame(cmat)
  final <- NULL
  for (i in 1:ncol(cmat)) {
    drug2_tmp <- drug2
    drug2_tmp$Subgroups_raw <- drug2_tmp$Subgroups
    drug2_tmp$Subgroups[drug2$Subgroups %in% cmat[,i]] <- "case"
    drug2_tmp$Subgroups[drug2_tmp$Subgroups != "case"] <- "other"
    for (j in unique(drug2_tmp$inhibitor)) {
      a <- drug2_tmp[drug2_tmp$Subgroups == "case",]
      b <- drug2_tmp[drug2_tmp$Subgroups == "other",]
      x <- table(a$Subgroups_raw)
      if (any(x == 0)) next
      if (!j %in% a$inhibitor | !j %in% b$inhibitor) next
      a <- a[a$inhibitor == j,]
      b <- b[b$inhibitor == j,]
      x <- wilcox.test(a$auc, b$auc)
      p.val <- x$p.value
      case.median <- median(a$auc)
      ctr.median <- median(b$auc)
      caseN <- length(a$auc)
      ctrN <- length(b$auc)
      log2fc <- log2(case.median / ctr.median)
      tmp <- cbind(case.median, ctr.median, caseN, ctrN, log2fc, paste0(cmat[,i], collapse = ","), j, p.val)
      final <- rbind(final, tmp)
    }
  }
  final <- as.data.frame(final)
  final$p.val <- as.numeric(final$p.val)
  for (i in 1:5) {
    final[,i] <- as.numeric(final[,i])
  }
  final <- final[!is.na(final$p.val),]
  final$log2p <- -log2(final$p.val)
  return(final)
}

final <- NULL
res_0 <- call_auc(a0)
res_1 <- call_auc(a)
res_2 <- call_auc(b)
res_3 <- call_auc(c)
final <- rbind(res_0, res_1, res_2, res_3)
final <- as.data.frame(final)
final$p.adjust <- p.adjust(final$p.val, method = "BH")
final <- final[order(final$p.adjust, decreasing = F),]
final <- final[final$p.val < 0.5,]

write.xlsx(final, "drug.G1-8.xlsx")

library(ggplot2)
library(ggrepel)
col <-  c("#FB8072", "#8DD3C7", "#80B1D3","#998199","#8C564B","#9467BD", "#e78ac3", "#e5c494")
pdf("../report/drug.bubble.pdf", width = 24, height = 14)
ggplot(final, aes(x=log2fc,y=-log2(p.val)))+
  geom_point(aes(size=log2p, color=i),alpha=0.6)+
  scale_size(range=c(1,12))+
  theme_bw()+
  theme(
    #legend.position = c("none")
  )+
  scale_fill_manual(values = col) +
  scale_color_manual(values = col) +
geom_text_repel(
    data = final[-log2(final$p.val)>10,],
    aes(label = j),
    size = 3,
    max.overlaps = 100,
    segment.color = "black", show.legend = FALSE )
dev.off()
