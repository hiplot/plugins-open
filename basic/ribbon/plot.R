#######################################################
# Ribbon plot.                                        #
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

pkgs <- c("ggplot2")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  # get axis labels
  usr_xlab <- colnames(data)[2]
  usr_ylab1 <- colnames(data)[3]
  usr_ylab2 <- colnames(data)[4]
  usr_ylab <- paste(strsplit(usr_ylab1, "")[[1]][
    list_same_string_position(usr_ylab1, usr_ylab2)
  ], sep = "", collapse = "")

  # rename colnames
  colnames(data) <- c("group", "xvalue", "yvalue1", "yvalue2")
  data$xvalue <- transform_val(conf$general$transformX, data$xvalue)
  data$yvalue1 <- transform_val(conf$general$transformY, data$yvalue1)
  data$yvalue2 <- transform_val(conf$general$transformY, data$yvalue2)

  # generate the mean of yvalue1 and yvalue2
  data$yvalue <- (data$yvalue1 + data$yvalue2) / 2
}

############# Section 2 #############
#           plot section
#####################################
{
  p <- ggplot(data, aes(xvalue, yvalue, fill = group)) +
    geom_ribbon(
      alpha = conf$general$alpha,
      aes(ymin = yvalue1, ymax = yvalue2)
    ) +
    geom_line(aes(y = yvalue, color = group), lwd = 1) +
    geom_line(aes(y = yvalue1, color = group), linetype = "dotted") +
    geom_line(aes(y = yvalue2, color = group), linetype = "dotted") +
    ylab(usr_ylab) +
    xlab(usr_xlab) +
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

