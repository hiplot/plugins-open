#######################################################
# Area plot.                                          #
#-----------------------------------------------------#
# Author: < Mingjie Wang > from < Ke Yan Mao >        #
# Affiliation: Shanghai Hiplot Team                   #
# Email: customer_service1501@tengyunbio.com          #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2019-11-15                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2020 by Hiplot Team                   #
# All rights reserved.                                #
#######################################################

pkgs <- c("ggplot2")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  # rename colnames
  usr_xlab <- colnames(data)[2]
  usr_ylab <- colnames(data)[3]
  colnames(data) <- c("Group", "xvalue", "yvalue")
  if (!is.numeric(data[, 1])) {
    data[, 1] <- factor(data[, 1], levels = unique(data[, 1]))
  }
  x_brk <- NULL
  if (!is.numeric(data[, 2])) {
    x_label <- unique(data[, 2])
    data[, 2] <- as.numeric(factor(data[, 2], levels = unique(data[, 2])))
    x_brk <- unique(data[, 2])
  }
}

############# Section 2 #############
#           plot section
#####################################
{
  p <- ggplot(data, aes(x = xvalue, y = yvalue, fill = Group)) +
    geom_area(alpha = conf$general$alpha) +
    ylab(usr_ylab) +
    xlab(usr_xlab) +
    ggtitle(conf$general$title)

  ## add color palette
  p <- p + return_hiplot_palette_color(conf$general$palette,
      conf$general$paletteCustom) +
    return_hiplot_palette(conf$general$palette,
      conf$general$paletteCustom)
  if (!is.null(x_brk)) {
    p <- p + scale_x_continuous(breaks = x_brk, labels = x_label)
  }

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

