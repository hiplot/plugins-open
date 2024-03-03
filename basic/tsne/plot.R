#######################################################
# tSNE                                                #
#-----------------------------------------------------#
# Author: < Mingjie Wang > from < Ke Yan Mao >        #
# Affiliation: Shanghai Hiplot Team                   #
# Email: customer_service1501@tengyunbio.com          #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2019-11-28                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2020 by Hiplot Team                   #
# All rights reserved.                                #
#######################################################
pkgs <- c("Rtsne", "ggpubr", "openxlsx")
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
  print(conf$extra$perplexity)
  print(conf$extra$theta)
  tsne_info <- Rtsne(t(data),
    perplexity = conf$extra$perplexity,
    theta = conf$extra$theta,
    check_duplicates = FALSE
  )
  colnames(tsne_info$Y) <- c("tSNE_1", "tSNE_2")

  # handle data
  tsne_data <- data.frame(
    sample = colnames(data),
    tsne_info$Y
  )
  axis <- sapply(conf$dataArg[[1]], function(x) x$value)
  if (is.null(axis[1]) ||
    axis[1] == "") {
    colorBy <- rep('ALL', nrow(sample.info))
  } else {
    colorBy <- sample.info[match(colnames(data), sample.info[, 1]), axis[1]]
    colorBy <- factor(colorBy,
    level = colorBy[!duplicated(colorBy)])
    tsne_data$colorBy = colorBy
  }
  if (is.null(axis[2]) ||
    axis[2] == "") {
    shapeBy <- NULL
  } else {
    shapeBy <- sample.info[match(colnames(data), sample.info[, 1]), axis[2]]
    shapeBy <- factor(shapeBy, level = shapeBy[!duplicated(shapeBy)])
    tsne_data$shapeBy = shapeBy
  }

}

############# Section 2 #############
#           plot section
#####################################
{
  params <- list(data = tsne_data, x = "tSNE_1", y = "tSNE_2",
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
  keep_vars <- c(keep_vars, "tsne_data")
  write.xlsx(tsne_data, paste0(opt$outputFilePrefix, ".xlsx"))
  export_single(p)
}

