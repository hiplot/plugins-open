#######################################################
# Pyramid chart.                                      #
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
pkgs <- c("ggcharts")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  group_color <- c(conf$extra$groupcolor1, conf$extra$groupcolor2)
}

############# Section 2 #############
#           plot section
#####################################
{
  cmd <- sprintf(
    paste0(
      "p <- pyramid_chart(data = data, x = %s, ",
      "y = %s, group = %s, title = conf$general$title,",
      " sort = conf$extra$sort, bar_colors = group_color)"
    ),
    colnames(data)[1], colnames(data)[3], colnames(data)[2]
  )
  eval(parse(text = cmd))

  p <- p + xlab(colnames(data)[1]) + ylab(colnames(data)[3])

  p <- set_complex_general_theme(set_palette_theme(p, conf))
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}

