#######################################################
# Line color dot.                                     #
#-----------------------------------------------------#
# Author: Jianfeng Li                                 #
# Email: lee_jianfeng@openbiox.org                    #
#                                                     #
# Date: 2022-04-01                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2022 by "National Center for          #
# Translational Medicine·Shanghai                     #
# All rights reserved.                                #
#######################################################

pkgs <- c("grafify")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  x <- unlist(conf$dataArg[[1]][[1]]$value)
  y <- unlist(conf$dataArg[[1]][[2]]$value)
  group <- unlist(conf$dataArg[[1]][[3]]$value)
  facet <- unlist(conf$dataArg[[1]][[4]]$value)
  # check data columns
  data[, x] <- factor(data[, x], levels = unique(data[, x]))
  data[, group] <- factor(data[, group], levels = unique(data[, group]))
  print(facet)
  if (facet != "") {
    data[, facet] <- factor(data[, facet], levels = unique(data[, facet]))
  }
  data[,y] <- transform_val(conf$general$transformY, data[,y])
}

############# Section 2 #############
#           plot section
#####################################
{
  p <- plot_befafter_colours(data = data,
                      xcol = get(x),
                      ycol = get(y),
                      match = get(group),
                      symsize = conf$extra$point_size,
                      symthick = conf$extra$point_thick,
                      s_alpha = conf$general$alpha) +
  ggtitle(conf$general$title)
  if (facet != "") {
    p <- p + facet_wrap(facet)
  }
  p <- p + xlab(x) + ylab(y) +
    guides(fill = guide_legend(title = group))
  ## add color palette
  p <- p + return_hiplot_palette_color(conf$general$palette,
      conf$general$paletteCustom) +
    return_hiplot_palette(conf$general$palette,
      conf$general$paletteCustom)

  ## set theme
  p <- set_complex_general_theme(set_palette_theme(p, conf))
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}

