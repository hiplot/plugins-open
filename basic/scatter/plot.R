#######################################################
# Scatter plot.                                       #
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
  # stacked plot or not
  point_type <- conf$extra$type

  # check alpha
  alpha_usr <- conf$general$alpha
  if (is.numeric(alpha_usr) & alpha_usr >= 0 & alpha_usr <= 1) {
    # nothing
  } else {
    print("Error, alpha should be a decimal between 0-1")
  }

  # check data columns
  if (ncol(data) %in% c(2, 3)) {
    # nothing
  } else {
    print("Error: Input data should be 2 or 3 columns!")
  }
}

############# Section 2 #############
#           plot section
#####################################
{
  if (ncol(data) == 2) {
    if (point_type) {
      print("Error, line type can ONLY be changed when group of values >= 2.")
    }

    data$group_add_by_code <- "g1"
    p <- ggplot(
      data,
      aes_(x = as.name(colnames(data[1])), y = as.name(colnames(data[2])))
    ) +
      geom_point(size = conf$extra$point_size,
      alpha = alpha_usr, aes(group = group_add_by_code)) +
      guides(fill = F) +
      ggtitle(conf$general$title)
  } else {
    if (point_type) {
      p <- ggplot(
        data,
        aes_(x = as.name(colnames(data[1])), y = as.name(colnames(data[2])))
      ) +
        geom_point(
          size = conf$extra$point_size,
          alpha = alpha_usr,
          aes_(
            color = as.name(colnames(data[3])),
            shape = as.name(colnames(data[3]))
          )
        ) +
        ggtitle(conf$general$title)

      if (length(unique(data[[3]])) > 6) {
        p <- p + scale_shape_manual(values=0:25)
      }

    } else {
      p <- ggplot(
        data,
        aes_(x = as.name(colnames(data[1])), y = as.name(colnames(data[2])))
      ) +
        geom_point(
          size = conf$extra$point_size,
          alpha = alpha_usr,
          aes_(color = as.name(colnames(data[3])))
        ) +
        ggtitle(conf$general$title)
    }
  }
  ## add color palette
  p <- p + return_hiplot_palette_color(conf$general$palette,
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

