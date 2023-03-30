#######################################################
# GGPIE.                                              #
#-----------------------------------------------------#
# Author: Jianfeng Li                                 #
# Email: lee_jianfeng@hiplot.org                      #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2023-03-30                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2023 by "National Center for          #
# Translational Medicine·Shanghai                     #
# All rights reserved.                                #
#######################################################

pkgs <- c("ggpie", "dplyr")
pacman::p_load(pkgs, character.only = TRUE)

axis <- sapply(conf$dataArg[[1]], function(x) x$value)
data[, axis[1]] <- set_factors(data[, axis[1]])
if (is.character(axis[2]) && axis[2] != "") {
  data[, axis[2]] <- set_factors(data[, axis[2]])
}


if (is.character(axis[2]) && axis[2] != "") {
  p <- NULL
  for (j in unique(data[, axis[2]])) {
    ptmp <- ggpie(
      data = data[data[, axis[2]] == j,],
      group_key = axis[1], count_type = "full",
      label_type = "horizon", label_size = 8,
      label_info = c("count", "ratio"),
      label_pos = "out") + ggtitle(j)
    if (is.null(p)) {p <- ptmp} else {p <- p + ptmp}
  }
} else {
  p <- ggpie(
    data = data,
    group_key = axis[1], count_type = "full",
    label_type = "horizon", label_size = 8,
    label_info = c("count", "ratio"),
    label_pos = "out")
}

p <- p + return_hiplot_palette_color(
  conf$general$palette,
  conf$general$paletteCustom
) +
  return_hiplot_palette(
    conf$general$palette,
    conf$general$paletteCustom
  )

export_single(p)
