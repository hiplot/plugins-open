#######################################################
# Eulerr charts.                                      #
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

pkgs <- c("eulerr", "ggplotify")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
}

############# Section 2 #############
#           plot section
#####################################
{
  genes <- as.numeric(data[, 2])
  names(genes) <- as.character(data[, 1])
  euler_set <- euler(genes)
  fill <- get_hiplot_color(conf$general$palette, length(genes),
    conf$general$paletteCustom)
  p <- as.ggplot(
    plot(euler_set,
      labels = list(col = rep("white", length(genes))),
      fills = list(fill = fill),
      quantities = list(type = c("percent", "counts"),
      col = rep("white", length(genes))),
      main = conf$general$title
    )
  )
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}

