#######################################################
# Rose chart.                                         #
#-----------------------------------------------------#
# Author: < Songqi Duan >                             #
# Affiliation: Shanghai Hiplot Team                   #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2021-03-10                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2021 by Hiplot Team                   #
# All rights reserved.                                #
#######################################################

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  pkgs <- c("ggplot2")
  pacman::p_load(pkgs, character.only = TRUE)

  x_lab <- colnames(data)[1]
  colnames(data)[1] <- "x"
  # rename colnames
  if (!is.numeric(data[, 1])) {
    data[, 2] <- factor(data[, 2], levels = unique(data[, 2]))
  }
}

############# Section 2 #############
#           plot section
#####################################
{
  p <- ggplot(data, aes(x = x)) +
    geom_line(aes(y = data[, 2]), size = conf$extra$line_size,
      color = conf$extra$line1_color) +
    geom_line(aes(y = data[, 3] / as.numeric(conf$extra$coeff)),
      size = conf$extra$line_size,
      color = conf$extra$line2_color) +
    scale_y_continuous(
      # Features of the first axis
      name = colnames(data)[2],
      # Add a second axis and specify its features
      sec.axis = sec_axis(~ . * as.numeric(conf$extra$coeff),
      name = colnames(data)[3])
    ) +
    ggtitle(conf$general$title) + xlab(x_lab)

  p <- set_complex_general_theme(set_palette_theme(p, conf))
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}
