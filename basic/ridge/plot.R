#######################################################
# Ridge plot.                                         #
#-----------------------------------------------------#
# Author: < Mingjie Wang > from < Ke Yan Mao >        #
# Affiliation: Shanghai Hiplot Team                   #
# Email: customer_service1501@tengyunbio.com          #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2019-12-8                                     #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2020 by Hiplot Team                   #
# All rights reserved.                                #
#######################################################

pkgs <- c("ggridges", "ggplot2")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  # get axis labels
  usr_ylab <- colnames(data)[2]
  usr_xlab <- colnames(data)[1]

  colnames(data) <- c("value", "group")
  data$group <- factor(data$group,
    levels = unique(data$group)[length(unique(data$group)):1])
}

############# Section 2 #############
#           plot section
#####################################
{
  p <- ggplot(
    data,
    aes(
      x = value,
      y = group,
      fill = group,
      col = group
    )
  ) +
    geom_density_ridges(
      scale = 5,
      alpha = conf$general$alpha
    ) +
    theme_ridges() +
    labs(x = usr_xlab, y = usr_ylab) +
    theme(plot.title = element_text(hjust = 0.5)) +
    theme(legend.position = "none") +
    ggtitle(conf$general$title) +
    guides(color = guide_legend(reverse = TRUE),
      fill = guide_legend(reverse = TRUE))

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

