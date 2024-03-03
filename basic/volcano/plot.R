#######################################################
# Volcano plot.                                       #
#-----------------------------------------------------#
# Author: < Mingjie Wang > from < Ke Yan Mao >        #
# Affiliation: Shanghai Hiplot Team                   #
# Email: customer_service1501@tengyunbio.com          #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2019-12-15                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2020 by Hiplot Team                   #
# All rights reserved.                                #
#######################################################

pkgs <- c("ggpubr")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  gene <- conf$dataArg[[1]][[1]]$value
  pvalue <- conf$dataArg[[1]][[2]]$value
  logfc <- conf$dataArg[[1]][[3]]$value

  conf$extra$fc_cutoff <- as.numeric(conf$extra$fc_cutoff)
  conf$extra$p_cutoff <- as.numeric(conf$extra$p_cutoff)
  # 对差异p(adj.P.Val一列)进行log10转换
  data[, "logP"] <- -log10(as.numeric(data[, pvalue]))
  data[, "logFC"] <- as.numeric(data[, logfc])

  # 新加一列Group
  data[, "Group"] <- "not-significant"

  # Up and down
  data$Group[which((data[, pvalue] < conf$extra$p_cutoff) &
    (data$logFC >= conf$extra$fc_cutoff))] <- "Up-regulated"
  data$Group[which((data[, pvalue] < conf$extra$p_cutoff) &
    (data$logFC <= conf$extra$fc_cutoff * -1))] <- "Down-regulated"

  # 新加一列Label
  data[["Label"]] <- ""

  # 对差异表达基因的p值进行从小到大排序
  data <- data[order(data[, pvalue]), ]

  # 高表达的基因中，选择adj.P.Val最小的10个
  if (length(conf$extra$selected_genes) == 0) {
    up_genes <- head(data[, gene][which(data$Group == "Up-regulated")],
      conf$extra$show_genes_num)
    down_genes <- head(data[, gene][which(data$Group == "Down-regulated")],
    conf$extra$show_genes_num)
    not_sig_genes <- NA
  } else {
    tmp <- data[data[, gene] %in% conf$extra$selected_genes, ]
    up_genes <- tmp[, gene][which(tmp$Group == "Up-regulated")]
    not_sig_genes <- tmp[, gene][which(tmp$Group == "not-significant")]
    down_genes <- tmp[, gene][which(tmp$Group == "Down-regulated")]
  }
  # 将up_genes和down_genes合并，并加入到Label中
  deg_top_genes <- c(as.character(up_genes), as.character(not_sig_genes),
  as.character(down_genes))
  deg_top_genes <- deg_top_genes[!is.na(deg_top_genes)]
  data$Label[match(deg_top_genes, data[, gene])] <- deg_top_genes

  if (conf$general$palette != "default") {
    colors <- get_hiplot_color(conf$general$palette, 2, conf$general$paletteCustom)
    ref_palette <- c(colors[1], "#BBBBBB", colors[2])
  } else {
    ref_palette <- c("#2f5688", "#BBBBBB", "#CC0000")
  }

  lev <- c("Down-regulated", "not-significant", "Up-regulated")
  palette <- ref_palette[lev %in% unique(data$Group)]
  keep_vars <- c(keep_vars, palette)
  x <- unique(data$Label)
  x <- x[x != ""]
  cat(paste0(x, collapse = '", "'), sep = "\n")
}

############# Section 2 #############
#           plot section
#####################################
{
  # 改变火山图点的颜色和坐标轴标注，使图片更美观
  if (conf$extra$show_top) {
    options(ggrepel.max.overlaps = 100)
    p <- ggscatter(data,
      x = "logFC", y = "logP",
      color = "Group",
      palette = palette,
      size = 1,
      alpha = conf$general$alpha,
      font.label = 8,
      repel = TRUE,
      label=data$Label,
      #xlab = expression(log[2]("Fold Change")),
      #ylab = expression(-log[10]("P Value")),
      show.legend.text = FALSE
    ) +
      ggtitle(conf$general$title) +
      geom_hline(
        yintercept = -log(conf$extra$p_cutoff, 10),
        linetype = "dashed"
      ) +
      geom_vline(xintercept = c(
        conf$extra$fc_cutoff,
        -conf$extra$fc_cutoff
      ), linetype = "dashed")
  } else {
    p <- ggscatter(data,
      x = "logFC", y = "logP",
      color = "Group",
      palette = palette,
      alpha = conf$general$alpha,
      size = 1,
      repel = FALSE,
      #xlab = expression(log[2]("Fold Change")),
      #ylab = expression(-log[10]("P Value")),
      show.legend.text = FALSE
    ) +
      ggtitle(conf$general$title) +
      geom_hline(
        yintercept = -log(conf$extra$p_cutoff, 10),
        linetype = "dashed"
      ) +
      geom_vline(xintercept = c(
        conf$extra$fc_cutoff,
        -conf$extra$fc_cutoff
      ), linetype = "dashed")
  }

  ## set theme
  theme <- conf$general$theme
  p <- choose_ggplot_theme(p, theme)
  p <- set_complex_general_theme(p)
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}

