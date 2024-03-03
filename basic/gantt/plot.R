#######################################################
# Gantt chart.                                        #
#-----------------------------------------------------#
# Author: < Mingjie Wang > from < Ke Yan Mao >        #
# Affiliation: Shanghai Hiplot Team                   #
# Email: customer_service1501@tengyunbio.com          #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2019-11-19                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2020 by Hiplot Team                   #
# All rights reserved.                                #
#######################################################

pkgs <- c("ggplot2", "tidyverse")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  # get axis labels
  usr_ylab <- colnames(data)[1]
  if (!is.numeric(data[, 2])) {
    data[, 2] <- factor(data[, 2], levels = unique(data[, 2]))
  }
  # transform data
  data_gather <- gather(data, "state", "date", 3:4)
  sample <- levels(data_gather$sample)
  data_gather$sample <- factor(data_gather$sample,
    levels = rev(unique(data_gather$sample))
  )
  print(data_gather)
}

############# Section 2 #############
#           plot section
#####################################
{
  p <- ggplot(
    data_gather,
    aes(date, sample, color = item)
  ) +
    geom_line(size = 10, alpha = conf$general$alpha) +
    labs(x = "Time", y = NULL, title = conf$general$title) +
    theme(axis.ticks = element_blank()) +
    ylab(usr_ylab)

  ## add color palette
  p <- p + return_hiplot_palette_color(conf$general$palette,
      conf$general$paletteCustom) +
    return_hiplot_palette(conf$general$palette,
      conf$general$paletteCustom)

  ## set theme
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

