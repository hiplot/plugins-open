#######################################################
# PCA                                                 #
#-----------------------------------------------------#
# Author: Jianfeng Li                                 #
# Email: lee_jianfeng@hiplot.org                      #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2025-03-28                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2025 by "National Center for          #
# Translational Medicine·Shanghai                     #
# All rights reserved.                                #
#######################################################

pkgs <- c("FactoMineR", "factoextra")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  # get working directory and source general R library
  sample_info <- data2
  row.names(sample_info) <- sample_info[,1] 
  sample_info <- sample_info[colnames(data)[-1],]
  ## tsne
  rownames(data) <- data[, 1]
  data <- as.matrix(data[, -1])
  pca_data <- PCA(t(as.matrix(data)), scale.unit = TRUE, ncp = 5, graph = FALSE)
  params <- list(pca_data,
    geom.ind = "point",
    pointsize = 6,
    addEllipses = TRUE,
    mean.point = F)

  axis <- sapply(conf$dataArg[[1]], function(x) x$value)
}

############# Section 2 #############
#           plot section
#####################################
{ 
  if (!is.null(axis[1]) && axis[1] != "") {
    params$col.ind = sample_info[,axis[1]]
  }
  p <- do.call(fviz_pca_ind, params) +
    ggtitle(conf$general$title)

  ## add color palette
  p <- p + return_hiplot_palette_color(conf$general$palette,
      conf$general$paletteCustom) +
    return_hiplot_palette(conf$general$palette,
      conf$general$paletteCustom)

  ## set theme
  p <- set_complex_general_theme(set_palette_theme(p, conf))
}

############# Section 3 #############
#          output section
#####################################
{
  keep_vars <- c(keep_vars, "pca_data")
  export_single(p)
}
