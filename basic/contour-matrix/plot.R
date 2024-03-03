#######################################################
# Contour plot (Matrix).                              #
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
  data <- as.matrix(data)
  colnames(data) <- NULL

  # plot
  data3d <- reshape2::melt(data)
  names(data3d) <- c("x", "y", "z")

  theme <- conf$general$theme
}

############# Section 2 #############
#           plot section
#####################################
{
  p1 <- ggplot(data3d, aes(x, y, z = z)) +
    geom_isobands(
      alpha = conf$general$alpha,
      aes(color = stat(zmin)), fill = NA
    ) +
    scale_color_viridis_c() +
    coord_cartesian(expand = FALSE)
  p1 <- choose_ggplot_theme(p1, theme)
  p1 <- set_complex_general_theme(p1)
  p2 <- ggplot(data3d, aes(x, y, z = z)) +
    geom_isobands(
      alpha = conf$general$alpha,
      aes(fill = stat(zmin)), color = NA
    ) +
    scale_fill_viridis_c(guide = "legend") +
    coord_cartesian(expand = FALSE)
  p2 <- choose_ggplot_theme(p2, theme)
  p2 <- set_complex_general_theme(p2)
  p3 <- plot_grid(p1, p2, labels = c("A", "B"), label_size = 12)
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p3)
}
