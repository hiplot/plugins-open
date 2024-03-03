#######################################################
# PCA.                                                #
#-----------------------------------------------------#
# Author: < Mingjie Wang > from < Ke Yan Mao >        #
# Affiliation: Shanghai Hiplot Team                   #
# Email: customer_service1501@tengyunbio.com          #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2020-04-10                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2020 by Hiplot Team                   #
# All rights reserved.                                #
#######################################################

pkgs <- c("gmodels", "ggpubr", "openxlsx")
pacman::p_load(pkgs, character.only = TRUE)

export_pptx <- function(x, outfn, width, height) {
  step3 <- function(e) {
    warning("Not support PPTX export yet.")
  }
  step2 <- function(e) {
    tryCatch(
      graph2ppt(ggdraw(x),
        file = outfn,
        width = width, height = height,
        append = TRUE
      ),
      error = step3
    )
  }
    graph2ppt(x,
      file = outfn, width = width,
      height = height, append = TRUE
    )
}

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  # get working directory and source general R library
  sample.info <- data2

  ## tsne
  rownames(data) <- data[, 1]
  data <- as.matrix(data[, -1])
  pca_info <- fast.prcomp(data)

  axis <- sapply(conf$dataArg[[1]], function(x) x$value)
  if (is.null(axis[1]) ||
    axis[1] == "") {
    colorBy <- rep('ALL', nrow(sample.info))
  } else {
    colorBy <- sample.info[match(colnames(data), sample.info[, 1]), axis[1]]
    colorBy <- factor(colorBy,
    level = colorBy[!duplicated(colorBy)])
  }
  pca_data <- data.frame(
    sample = rownames(pca_info$rotation),
    colorBy = colorBy,
    pca_info$rotation
  )
  if (is.null(axis[2]) ||
    axis[2] == "") {
    shapeBy <- NULL
  } else {
    shapeBy <- sample.info[match(colnames(data), sample.info[, 1]), axis[2]]
    shapeBy <- factor(shapeBy, level = shapeBy[!duplicated(shapeBy)])
    pca_data$shapeBy = shapeBy
  }
}

############# Section 2 #############
#           plot section
#####################################
{
  params <- list(data = pca_data, x = "PC1", y = "PC2",
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
  keep_vars <- c(keep_vars, "pca_data")
  write.xlsx(pca_data, paste0(opt$outputFilePrefix, ".xlsx"))
  export_single(p)
}

