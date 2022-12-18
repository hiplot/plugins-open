#######################################################
# Scatter-gradient.                                   #
#-----------------------------------------------------#
# Author: Jianfeng Li                                 #
# Email: lee_jianfeng@openbiox.org                    #
#                                                     #
# Date: 2022-04-02                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2022 by "National Center for          #
# Translational Medicine·Shanghai                     #
# All rights reserved.                                #
#######################################################

pkgs <- c("grafify", "ggplot2")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  x <- unlist(conf$dataArg[[1]][[1]]$value)
  data[,x] <- transform_val(conf$general$transformX, data[,x])
  y <- unlist(conf$dataArg[[1]][[2]]$value)
  data[,y] <- transform_val(conf$general$transformY, data[,y])
  z <- unlist(conf$dataArg[[1]][[3]]$value)
  data[,z] <- transform_val(conf$general$transformG, data[,z])
  size <- unlist(conf$dataArg[[1]][[4]]$value)
  if (size != "") {
    data[,size] <- transform_val(conf$general$transformS, data[,size])
  }
  facet <- unlist(conf$dataArg[[1]][[5]]$value)
}

############# Section 2 #############
#           plot section
#####################################
{
  p <- plot_xy_NumGroup_hiplot(data,
                xcol = x,
                ycol = y,
                NumGroup = z,
                s_alpha = conf$general$alpha,
                symthick = conf$extra$point_thick,
                symsize_col = size,
                symsize = conf$extra$point_size,
                shape = conf$extra$type) +
  scale_fill_gradient(low = conf$extra$low_color,
    high = conf$extra$high_color) +
  scale_color_gradient(low = conf$extra$low_color,
    high = conf$extra$high_color)
  p <- p + xlab(x) + ylab(y) +
     guides(fill = guide_legend(title = z),
       size = guide_legend(title = size)) +
     ggtitle(conf$general$title)
  if (facet != "") {
    p <- p + facet_wrap(facet)
  }
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

