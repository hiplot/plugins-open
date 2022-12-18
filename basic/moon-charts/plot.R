#######################################################
# Moon charts.                                        #
#-----------------------------------------------------#
# Author: Jianfeng Li                                 #
# Email: lee_jianfeng@hiplot.org                      #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2020-08-13                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2022 by "National Center for          #
# Translational Medicine·Shanghai                     #
# All rights reserved.                                #
#######################################################

pkgs <- c("gggibbous", "ggplot2")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  if (!is.numeric(data[, 1])) {
    data[, 1] <- factor(data[, 1], levels = unique(data[, 1]))
  }
  rest_cols <- colnames(data)[-1]
  tidyrest <- reshape(
    data,
    varying = rest_cols,
    v.names = "Score",
    timevar = "Category",
    times = factor(rest_cols, levels = rest_cols),
    idvar = colnames(data)[1],
    direction = "long"
  )
}
############# Section 2 #############
#           plot section
#####################################
{
  p <- ggplot(tidyrest, aes(0, 0)) +
    geom_moon(aes(ratio = (Score - 1) / 4), fill = "black") +
    geom_moon(aes(ratio = 1 - (Score - 1) / 4), right = FALSE) +
    facet_grid(Category ~ Restaurant, switch = "y") +
    theme_minimal() +
    theme(
      panel.grid = element_blank(),
      axis.text = element_blank(),
      axis.title = element_blank()
    )

  theme <- conf$general$theme
  p <- choose_ggplot_theme(p, theme)
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}

