#######################################################
# Bivariate.                                          #
#-----------------------------------------------------#
# Author: Jianfeng Li                                 #
# Email: lee_jianfeng@hiplot.org                      #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2021-11-05                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2022 by "National Center for          #
# Translational Medicine·Shanghai                     #
# All rights reserved.                                #
#######################################################

pkgs <- c("GGally")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  explanatory <- conf$dataArg[[1]][[1]]$value
  outcome <- conf$dataArg[[1]][[2]]$value
}

############# Section 2 #############
#           plot section
#####################################
{
  p <- ggbivariate(data, outcome = outcome, explanatory = explanatory) +
    ggtitle(conf$general$title)

  ## add color palette
  p <- p + return_hiplot_palette_color(conf$general$palette,
      conf$general$paletteCustom) +
    return_hiplot_palette(conf$general$palette,
      conf$general$paletteCustom)

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

