#######################################################
# Heatmap.                                            #
#-----------------------------------------------------#
# Author: < Mingjie Wang > from < Ke Yan Mao >        #
# Affiliation: Shanghai Hiplot Team                   #
# Email: customer_service1501@tengyunbio.com          #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2019-11-19                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2020 by Hiplot Team                   #
# All rights reserved.                                #
#######################################################

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  pkgs <- c("ComplexHeatmap", "RColorBrewer")
  pacman::p_load(pkgs, character.only = TRUE)

  data <- data[!is.na(data[, 1]), ]
  idx <- duplicated(data[, 1])
  data[idx, 1] <- paste0(data[idx, 1], "--dup-", cumsum(idx)[idx])
  for (i in 2:ncol(data)) {
    data[, i] <- as.numeric(data[, i])
  }
  data1 <- as.matrix(data[, -1])
  rownames(data1) <- data[, 1]
  data <- data1
  rm(data1)

  # 更改热图颜色
  if (toupper(conf$extra$color) == "METHYLATION") {
    col <- colorpanel(100, "#23256b", "#fbfc34")
  } else if (toupper(conf$extra$color) == "GREENRED") {
    col <- greenred(100)
  } else if (toupper(conf$extra$color) == "REDGREEN") {
    col <- redgreen(100)
  } else if (toupper(conf$extra$color) == "BLUERED") {
    col <- bluered(100)
  } else if (toupper(conf$extra$color) == "REDBLUE") {
    col <- redblue(100)
  } else if (toupper(conf$extra$color) == "HEAT") {
    col <- heat.colors(100)
  } else if (toupper(conf$extra$color) == "BLUERED2") {
    col <- colorRampPalette(c("#00BFFF", "white", "#b22222"))(50)
  }  else if (toupper(conf$extra$color) == "CUSTOM") {
    color_key <- c(conf$extra$color_low, conf$extra$color_mid, conf$extra$color_high)
    col <- colorRampPalette(color_key)(50)
  } else {
    color_key <- c("#3300CC", "#3399FF", "white", "#FF3333", "#CC0000")
    col <- colorRampPalette(color_key)(50)
  }

  # 给样本添加标注信息
  sample_info_reorder <- NULL

  tryCatch({
    sample.info <- data2[-1]
    row.names(sample.info) <- data2[, 1]
    sample_info_reorder <- as.data.frame(sample.info[match(
      colnames(data),
      rownames(sample.info)
    ), ])
    colnames(sample_info_reorder) <- colnames(sample.info)
    rownames(sample_info_reorder) <- colnames(data)
  }, error = function(e) {

  })

  gene_info_reorder <- NULL
  # 给基因添加标注信息
  tryCatch({
    gene_info <- data3[-1]
    rownames(gene_info) <- data3[, 1]
    gene_info_reorder <- as.data.frame(gene_info[match(
      rownames(data),
      rownames(gene_info)
    ), ])
    colnames(gene_info_reorder) <- colnames(gene_info)
    rownames(gene_info_reorder) <- rownames(data)
  }, error = function(e) {

  })
}

############# Section 2 #############
#           plot section
#####################################
{
  # 设置annotation_col和annotation_row，分别对样本和基因添加附注
  if (!is.null(conf$extra$top_var)) {
    top_var_genes <- rownames(data)[head(
      order(
        genefilter::rowVars(data),
        decreasing = TRUE
      ),
      nrow(data) * conf$extra$top_var / 100
    )]
  } else {
    top_var_genes <- row.names(data)
  }

  if (!is.null(conf$extra$hc_distance)) {
    conf$extra$hc_distance_cols <- conf$extra$hc_distance
    conf$extra$hc_distance_rows <- conf$extra$hc_distance
  }
  if (is.null(conf$extra$display_numbers)) {
    conf$extra$display_numbers <- FALSE
  }
  params <- list(data[row.names(data) %in% top_var_genes,],
    color = col, border_color = NA,
    fontsize_row = conf$general$fontsizeRow,
    fontsize_col = conf$general$fontsizeCol,
    main = conf$general$title,
    cluster_rows = conf$extra$cluster_rows,
    cluster_cols = conf$extra$cluster_cols,
    scale = conf$extra$scale,
    clustering_method = conf$extra$hc_method,
    clustering_distance_cols = conf$extra$hc_distance_cols,
    clustering_distance_rows = conf$extra$hc_distance_rows,
    fontfamily = conf$general$font,
    display_numbers = conf$extra$display_numbers,
    number_color = conf$extra$number_color
  )
  annotation_colors <- list()
  if (is.null(conf$general$palette) || !is.character(conf$general$palette)) {
    conf$general$palette <- "d3"
  }
  if (is.null(conf$general$palette2) || !is.character(conf$general$palette2)) {
    conf$general$palette2 <- "ucscgb"
  }
  if (!is.null(sample_info_reorder)) {
    params$annotation_col <- sample_info_reorder
    print(sample_info_reorder)
    for(i in colnames(sample_info_reorder)) {
      if (is.numeric(sample_info_reorder[,i])) {
        annotation_colors[[i]] <- col
      } else {
        ref <- get_hiplot_color(conf$general$palette,
          length(unique(sample_info_reorder[,i])),
          conf$general$paletteCustom)
        annotation_colors[[i]] <- ref
        names(annotation_colors[[i]]) <- unique(sample_info_reorder[,i])
      }
    }
  }
  if (!is.null(gene_info_reorder)) {
    params$annotation_row <- gene_info_reorder
    for(i in colnames(gene_info_reorder)) {
      if (is.numeric(gene_info_reorder[,i])) {
        annotation_colors[[i]] <- col
      } else {
        ref <- get_hiplot_color(conf$general$palette2,
          length(unique(gene_info_reorder[,i])),
          conf$general$paletteCustom2)
        annotation_colors[[i]] <- ref
        names(annotation_colors[[i]]) <- unique(gene_info_reorder[,i])
      }
    }
  }
  print(annotation_colors)
  params$annotation_colors <- annotation_colors
  p <- as.ggplot(function(){print(do.call(ComplexHeatmap::pheatmap, params))})
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}
