#######################################################
# Corrplot Big Data.                                  #
#-----------------------------------------------------#
# Author: Jianfeng Li                                 #
# Email: lee_jianfeng@hiplot.org                      #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2022-05-07                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2022 by "National Center for          #
# Translational Medicine·Shanghai                     #
# All rights reserved.                                #
#######################################################

pkgs <- c("corrplot", "ggplotify", "ggplot2", "ggcorrplot",
          "ComplexHeatmap", "pheatmap", "openxlsx", "gplots",
          "stringr")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  data <- data[!is.na(data[, 1]), ]
  idx <- duplicated(data[, 1])
  data[idx, 1] <- paste0(data[idx, 1], "--dup-", cumsum(idx)[idx])
  rownames(data) <- data[, 1]
  data <- data[, -1]
  str2num_df <- function(x) {
    x[] <- lapply(x, function(l) as.numeric(l))
    x
  }
  cor_method <- conf$extra$cor_method
  # calculate correlations and p values
  if (str_detect(toupper(conf$extra$correlation), "^R")) {
    tmp <- t(str2num_df(data))
    corr <- round(cor(tmp, use = "na.or.complete", method = cor_method), 3)
    p_mat <- round(cor_pmat(tmp, method = cor_method), 3)
  } else {
    corr <- round(cor(data, use = "na.or.complete", method = cor_method), 3)
    p_mat <- round(cor_pmat(data, method = cor_method), 3)
  }

  if (is.null(conf$extra$color_low)) {
    conf$extra$color_low <- "#0000FF"
    conf$extra$color_mid <- "#FFFFFF"
    conf$extra$color_high <- "#FF0000"
  }
}

############# Section 2 #############
#           plot section
#####################################
{
  color_key <- c(conf$extra$color_low, conf$extra$color_mid,
    conf$extra$color_high)
  col <- colorRampPalette(color_key)(50)
  p <- as.ggplot(function(){
    conf$extra$heat_eng <- str_remove_all(conf$extra$heat_eng, ";")
    fun <- eval(parse(text = paste0(conf$extra$heat_eng)))
    if (conf$extra$heat_eng %in% 
      c("ComplexHeatmap::pheatmap", "pheatmap::pheatmap")) {
      x <- do.call(fun, list(
        corr, color = col,
        clustering_distance_rows = conf$extra$hc_distance_rows,
        clustering_distance_cols = conf$extra$hc_distance_cols,
        treeheight_row = -1,
        treeheight_col = -1,
        fontsize = min(c(conf$general$fontsizeRow, conf$general$fontsizeCol)),
        fontsize_row = conf$general$fontsizeRow,
        fontsize_col = conf$general$fontsizeCol,
        clustering_method = conf$extra$hc_method,
        display_numbers = conf$extra$display_numbers
      ))
    } else if (conf$extra$heat_eng == "ComplexHeatmap::Heatmap") {
      params <- list(corr,
          col = col,
          clustering_distance_rows = conf$extra$hc_distance_rows,
          clustering_method_rows = conf$extra$hc_method,
          clustering_distance_columns = conf$extra$hc_distance_cols,
          clustering_method_columns = conf$extra$hc_method,
          show_column_dend = FALSE,
          show_row_dend = FALSE,
          column_names_gp = gpar(fontsize = conf$general$fontsizeCol),
          row_names_gp = gpar(fontsize = conf$general$fontsizeRow)
        )
      if (conf$extra$display_numbers) {
        params$cell_fun <- function(j, i, x, y, width, height, fill) {
          grid.text(sprintf("%.2f", corr[i, j]), x, y, 
            gp = gpar(fontsize = 0.8 * conf$general$fontsizeRow))
        }
      }
      x <- do.call(fun, params)
    } else if (conf$extra$heat_eng == "gplots::heatmap.2") {
      myclust <- function(x){
        hclust(x, method = conf$extra$hc_method)
      }
      distfun <- function(x) {
        dist(x, method = conf$extra$hc_distance_rows)
      }
      params <- list(corr,
        hclustfun = myclust,
        distfun = distfun,
        dendrogram='none', Rowv=TRUE, Colv=TRUE, trace='none',
        scale = 'none', col = col,
        cexRow = conf$general$fontsizeRow / 10,
        cexCol = conf$general$fontsizeCol / 10,
        keysize=1,
        sepwidth=c(0,0)
      )
      if (conf$extra$display_numbers) {
        params$cellnote <- corr
        params$notecol <- "black"
        params$notecex <- conf$general$fontsizeRow / 10 * 0.8
      }
      x <- do.call(fun, params)
    }
    print(x)
  })
}

############# Section 3 #############
#          output section
#####################################
{
  if (conf$extra$out_cor_table) {
    wb <- createWorkbook()
    addWorksheet(wb, "corr")
    addWorksheet(wb, "p.mat")
    writeData(wb, "corr", corr, rowNames = TRUE)
    writeData(wb, "p.mat", p_mat, rowNames = TRUE)
    saveWorkbook(wb, paste0(opt$outputFilePrefix, ".xlsx"))
  }
  export_single(p)
}
