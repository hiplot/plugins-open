#######################################################
# Wordcloud plot.                                     #
#-----------------------------------------------------#
# Author: Jianfeng Li                                 #
# Email: lee_jianfeng@hiplot.org                      #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2020-08-16                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2022 by "National Center for          #
# Translational Medicine·Shanghai                     #
# All rights reserved.                                #
#######################################################

pkgs <- c("d3wordcloud")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  row.names(data) <- data[, 1]
  if (ncol(data) == 1 || (ncol(data) > 1 && all(is.na(data[, 2])))) {
    data <- as.data.frame(table(data[, 1]))
  }
}

############# Section 2 #############
#           plot section
#####################################
params <- list(data[, 1], data[, 2],
  padding = conf$extra$padding,
  rotate.min = conf$extra$rotateMin,
  rotate.max = conf$extra$rotateMax,
  size.scale = conf$extra$sizeScale,
  color.scale = conf$extra$colorScale,
  spiral = conf$extra$spiral,
  font = conf$general$font,
  rangesizefont = conf$extra$rangesizefont
)

if (conf$general$palette != "default") {
  params$colors <- get_hiplot_color(conf$general$palette, -1,
    conf$general$paletteCustom)
  params$colors <- str_replace(params$colors, "FF$", "")
}

p <- do.call(d3wordcloud, params)

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}
