#######################################################
# Contour plot (XY).                                  #
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

pkgs <- c("ggisoband", "ggplot2")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  # rename colnames
  usr_xlab <- colnames(data)[1]
  usr_ylab <- colnames(data)[2]
  colnames(data) <- c("xvalue", "yvalue")
}

############# Section 2 #############
#           plot section
#####################################
{
  p <- ggplot(data, aes(xvalue, yvalue)) +
    geom_density_bands(
      alpha = conf$general$alpha,
      aes(fill = stat(density)), color = "gray40", size = 0.2
    ) +
    geom_point(alpha = conf$general$alpha, shape = 21, fill = "white") +
    scale_fill_viridis_c(guide = "legend") +
    ylab(usr_ylab) +
    xlab(usr_xlab) +
    ggtitle(conf$general$title)

  # output plots
  p <- set_complex_general_theme(set_palette_theme(p, conf))
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}

