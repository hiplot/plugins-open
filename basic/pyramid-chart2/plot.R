#######################################################
# Pyramid chart2.                                      #
#-----------------------------------------------------#
# Author: Jianfeng Li                                 #
# Email: lee_jianfeng@hiplot.org                      #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2021-11-04                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2022 by "National Center for          #
# Translational Medicine·Shanghai                     #
# All rights reserved.                                #
#######################################################
pkgs <- c("apyramid")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  autocut <- function(x) {
    cut(x, breaks = pretty(x), right = TRUE, include.lowest = TRUE)
  }
  age <- conf$dataArg[[1]][[1]]$value
  color_col <- conf$dataArg[[1]][[2]]$value
  stack_col <- conf$dataArg[[1]][[3]]$value

  if (is.null(conf$extra$age_breaks) | length(conf$extra$age_breaks) == 0) {
    data$age_group <- autocut(as.integer(data[,age]))
  } else {
    age_breaks <- as.numeric(conf$extra$age_breaks)
    data$age_group <- cut(as.integer(data[,age]), breaks = age_breaks,
      right = TRUE, include.lowest = TRUE)
  }
}

############# Section 2 #############
#           plot section
#####################################
{
  params <- list(data, "age_group", split_by = color_col)
  if (!is.null(stack_col) && stack_col != "") params$stack_by <- stack_col
  p <- do.call(age_pyramid, params)
  p <- p + xlab("Age group") + ylab(colnames(data[color_col]))

  ## add color palette
  p <- p + return_hiplot_palette_color(conf$general$palette,
      conf$general$paletteCustom) +
    return_hiplot_palette(conf$general$palette,
      conf$general$paletteCustom)

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

