#######################################################
# Parliament diagrams.                                #
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

pkgs <- c("ggpol", "ggplot2")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  usr_group <- colnames(data)[1]
  colnames(data) <- c("group", "value")
}

############# Section 2 #############
#           plot section
#####################################
{
  # plot
  p <- ggplot(data) +
    geom_parliament(
      alpha = conf$general$alpha,
      aes(seats = value, fill = group), color = "black"
    ) +
    coord_fixed() +
    theme_void() +
    scale_fill_discrete(
      name = usr_group,
      labels = unique(data$group)
    ) +
    theme(legend.position = "bottom") +
    ggtitle(conf$general$title) +
    theme(plot.title = element_text(hjust = 0.5))

  ## add color palette
  p <- p + return_hiplot_palette_color(conf$general$palette,
      conf$general$paletteCustom) +
    return_hiplot_palette(conf$general$palette,
      conf$general$paletteCustom)

  theme <- conf$general$theme
  p <- choose_ggplot_theme(p, theme)
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}

