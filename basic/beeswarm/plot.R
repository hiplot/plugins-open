#######################################################
# Beeswarm plot.                                      #
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

pkgs <- "ggbeeswarm"
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  # get axis labels
  usr_xlab <- colnames(data)[1]
  usr_ylab <- colnames(data)[2]
  if (!is.numeric(data[, 1])) {
    data[, 1] <- factor(data[, 1], levels = unique(data[, 1]))
  }
  colnames(data) <- c("Group", "y")
}

############# Section 2 #############
#           plot section
#####################################
{
  p <- ggplot(data, aes(Group, y, color = Group)) +
    geom_beeswarm(alpha = conf$general$alpha, size = 0.8) +
    labs(x = NULL, y = usr_ylab) +
    ggtitle(conf$general$title)

  ## add color palette
  p <- p + return_hiplot_palette_color(conf$general$palette,
      conf$general$paletteCustom) +
    return_hiplot_palette(conf$general$palette,
      conf$general$paletteCustom)

  # output plots
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

