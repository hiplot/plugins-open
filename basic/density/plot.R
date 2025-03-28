#######################################################
# Density plot.                                       #
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
  stacked <- conf$extra$stack

  # check alpha
  alpha_usr <- conf$general$alpha
  if (is.double(alpha_usr) & alpha_usr >= 0 & alpha_usr <= 1) {
    # nothing
  } else {
    print("Error, alpha should be a decimal between 0-1")
  }
  # check data columns
  if (ncol(data) %in% c(1, 2)) {
    # nothing
  } else {
    stop("Input data should be 1 or 2 columns!")
  }
  data[,2] <- factor(data[,2], levels = unique(data[,2]))
}

############# Section 2 #############
#           plot section
#####################################
{
  if (ncol(data) == 1) {
    if (stacked) {
      print("Error, stacked density plot can only be used when groups >= 2.")
    }

    data["group_add_by_code"] <- "g1"
    p <- ggplot(data, aes_(as.name(colnames(data[1])))) +
      geom_density(aes(fill = group_add_by_code),
        col = "white", alpha = alpha_usr
      ) +
      guides(fill = F) +
      ggtitle(conf$general$title)
  } else {
    if (!is.numeric(data[, 2])) {
      data[, 2] <- factor(data[, 2], levels = unique(data[, 2]))
    }
    if (stacked) {
      p <- ggplot(data, aes_(as.name(colnames(data[1])))) +
        geom_density(
          col = "white", alpha = alpha_usr, position = "fill",
          aes_(fill = as.name(colnames(data[2])))
        ) +
        ggtitle(conf$general$title)
    } else {
      p <- ggplot(data, aes_(as.name(colnames(data[1])))) +
        geom_density(
          col = "white", alpha = alpha_usr,
          aes_(fill = as.name(colnames(data[2])))
        ) +
        ggtitle(conf$general$title)
    }
  }

  ## add color palette
  p <- p + return_hiplot_palette(conf$general$palette,
  conf$general$paletteCustom)

  ## add theme
  p <- set_complex_general_theme(set_palette_theme(p, conf))
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}

