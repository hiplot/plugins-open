#######################################################
# Scatter2.                                   #
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
  group <- unlist(conf$dataArg[[1]][[3]]$value)
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
  p <- plot_xy_CatGroup_hiplot(data,
                xcol = x,
                ycol = y,
                CatGroup = group,
                s_alpha = conf$general$alpha,
                symthick = conf$extra$point_thick,
                symsize = conf$extra$point_size,
                symsize_col = size,
                shape = ifelse(conf$extra$type, group, 21)) +
     xlab(x) + ylab(y) +
     guides(fill = guide_legend(title = group),
       color = guide_legend(title = group)) +
     ggtitle(conf$general$title)
  if (size != "") {
    p <- p + guides(size = guide_legend(title = size))
  }
  if (conf$extra$type) {
    p <- p + guides(fill = FALSE, shape = guide_legend(title = group))
  } else {
    p <- p + guides(color = FALSE)
  }
  if (facet != "") {
    p <- p + facet_wrap(facet)
  }
  
  ## add color palette
  p <- p + return_hiplot_palette_color(conf$general$palette,
    conf$general$paletteCustom) +
    return_hiplot_palette(conf$general$palette,
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

