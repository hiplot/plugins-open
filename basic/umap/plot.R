#######################################################
# UMAP.                                               #
#-----------------------------------------------------#
# Author: Jianfeng Li                                 #
# Email: lee_jianfeng@hiplot.org                      #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2021-01-28                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2020 by Hiplot Team                   #
# All rights reserved.                                #
#######################################################
pkgs <- c("umap", "ggpubr", "openxlsx")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  sample.info <- data2
  rownames(data) <- data[, 1]
  data <- as.matrix(data[, -1])
  ## tsne
  set.seed(123)
  umap_info <- umap(t(data))
  colnames(umap_info$layout) <- c("UMAP_1", "UMAP_2")

  # handle data
  umap_data <- data.frame(
    sample = colnames(data),
    umap_info$layout
  )
  axis <- sapply(conf$dataArg[[1]], function(x) x$value)
  if (is.null(axis[1]) ||
    axis[1] == "") {
    colorBy <- rep('ALL', nrow(sample.info))
  } else {
    colorBy <- sample.info[match(colnames(data), sample.info[, 1]), axis[1]]
    colorBy <- factor(colorBy,
    level = colorBy[!duplicated(colorBy)])
    umap_data$colorBy = colorBy
  }
  if (is.null(axis[2]) ||
    axis[2] == "") {
    shapeBy <- NULL
  } else {
    shapeBy <- sample.info[match(colnames(data), sample.info[, 1]), axis[2]]
    shapeBy <- factor(shapeBy, level = shapeBy[!duplicated(shapeBy)])
    umap_data$shapeBy = shapeBy
  }

}

############# Section 2 #############
#           plot section
#####################################
{
  params <- list(data = umap_data, x = "UMAP_1", y = "UMAP_2",
    size = 2, palette = "lancet")

  if (!is.null(axis[1]) && axis[1] != "") {
    params$color = "colorBy"
  }
  if (!is.null(axis[2]) && axis[2] != "") {
    params$shape = "shapeBy"
  }
  p <- do.call(ggscatter, params) +
    labs(color = axis[1], shape = axis[2]) +
    ggtitle(conf$general$title)

  ## add color palette
  p <- p + return_hiplot_palette_color(conf$general$palette,
      conf$general$paletteCustom) +
    return_hiplot_palette(conf$general$palette,
      conf$general$paletteCustom)

  ## set theme
  theme <- conf$general$theme
  p <- choose_ggplot_theme(p, theme)
  p <- set_complex_general_theme(p)
}

############# Section 3 #############
#          output section
#####################################
{
  keep_vars <- c(keep_vars, "umap_data")
  write.xlsx(umap_data, paste0(opt$outputFilePrefix, ".xlsx"))
  export_single(p)
}

