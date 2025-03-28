#######################################################
# Dot chart.                                          #
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

pkgs <- c("ggpubr")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  # rename colnames
  usr_xlab <- colnames(data)[1]
  usr_ylab <- colnames(data)[2]
  group_lab <- colnames(data)[3]
}

############# Section 2 #############
#           plot section
#####################################
{
  p <- ggdotchart(data,
    x = usr_xlab, y = usr_ylab, group = group_lab, color = group_lab,
    rotate = T, sorting = "descending",
    y.text.col = F, add = "segments", dot.size = 2
  ) +
    xlab(usr_xlab) +
    ylab(usr_ylab) +
    ggtitle(conf$general$title)

  ## add color palette
  p <- p + return_hiplot_palette_color(conf$general$palette,
      conf$general$paletteCustom) +
    return_hiplot_palette(conf$general$palette,
      conf$general$paletteCustom)

  p <- set_complex_general_theme(set_palette_theme(p, conf))
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}
