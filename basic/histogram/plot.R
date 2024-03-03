#######################################################
# Histogram.                                          #
#-----------------------------------------------------#
# Author: < Mingjie Wang > from < Ke Yan Mao >        #
# Affiliation: Shanghai Hiplot Team                   #
# Email: customer_service1501@tengyunbio.com          #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2020-04-15                                    #
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
  # check arguments
  if (is.integer(conf$extra$bins)) {
    if (conf$extra$bins <= 3) {
      print("Error,number of bins is too small.")
    }
  } else {
    print("Error, number of bins should be an integer.")
  }

  # check data columns
  if (ncol(data) %in% c(1, 2)) {
    # nothing
  } else {
    print("Error: Input data should be 1 or 2 columns!")
  }
}

############# Section 2 #############
#           plot section
#####################################
{
  if (ncol(data) == 1) {
    data$group_add_by_code <- "g1"
    p <- ggplot(data, aes_(as.name(colnames(data[1])))) +
      geom_histogram(
        alpha = conf$general$alpha,
        bins = conf$extra$bins,
        aes(fill = group_add_by_code),
        col = "white"
      ) +
      guides(fill = F) +
      ggtitle(conf$general$title)
  } else {
    if (!is.numeric(data[, 2])) {
      data[, 2] <- factor(data[, 2], levels = unique(data[, 2]))
    }
    p <- ggplot(data, aes_(as.name(colnames(data[1])))) +
      geom_histogram(
        alpha = conf$general$alpha,
        bins = conf$extra$bins,
        col = "white",
        aes_(fill = as.name(colnames(data[2])))
      ) +
      ggtitle(conf$general$title)
  }

  ## add color palette
  p <- p + return_hiplot_palette(conf$general$palette,
  conf$general$paletteCustom)

  ## add theme
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

