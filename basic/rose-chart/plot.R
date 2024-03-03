#######################################################
# Rose chart.                                         #
#-----------------------------------------------------#
# Author: < Songqi Duan >                             #
# Affiliation: Shanghai Hiplot Team                   #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2021-03-05                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2021 by Hiplot Team                   #
# All rights reserved.                                #
#######################################################

pkgs <- c("ggplot2")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  # rename colnames
  colnames(data) <- c("Sample", "Group", "Freq")
  if (!is.numeric(data[, 1])) {
    data[, 2] <- factor(data[, 2], levels = unique(data[, 2]))
  }
}

############# Section 2 #############
#           plot section
#####################################
{
  p <- ggplot(data, aes(x = Sample, y = Freq)) +
    geom_col(aes(fill = Group),
      width = 0.9, size = 0, 
      alpha = conf$general$alpha
    ) +
    coord_polar() +
    ggtitle(conf$general$title)

  ## add color palette
  p <- p + return_hiplot_palette_color(
    conf$general$palette,
    conf$general$paletteCustom
  ) +
    return_hiplot_palette(
      conf$general$palette,
      conf$general$paletteCustom
    )

  theme <- conf$general$theme
  p <- choose_ggplot_theme(p, theme) + theme(
    aspect.ratio = 1,
    axis.title = element_blank(),
    axis.text.x = element_text(colour = "black"),
    axis.text.y = element_text(colour = "black"),
    legend.title = element_blank(),
    legend.position = "bottom",
    plot.title = element_text(hjust = 0.5)
  )
  p <- set_complex_general_theme(p)
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}
