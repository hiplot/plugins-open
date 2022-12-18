#######################################################
# Waffle Plot.                                        #
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

# load required packages
pkgs <- c("waffle")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  parts <- data[,2]
  names(parts) <- data[,1]
}

############# Section 2 #############
#           plot section
#####################################
{
  p <- waffle(
      parts, rows = conf$extra$rows,
      size = conf$extra$size,
      legend_pos = conf$extra$legendPos
  )

  p <- p + ggtitle(conf$general$title)

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
