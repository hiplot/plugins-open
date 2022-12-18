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
  y <- unlist(conf$dataArg[[1]][[1]]$value)
  group <- unlist(conf$dataArg[[1]][[2]]$value)
  facet <- unlist(conf$dataArg[[1]][[3]]$value)
  # check data columns
  if (group != "") {
    data[, group] <- factor(data[, group], levels = unique(data[, group]))
  }
  if (facet != "") {
    data[, facet] <- factor(data[, facet], levels = unique(data[, facet]))
  }
  data[,y] <- transform_val(conf$general$transformY, data[,y])
}

############# Section 2 #############
#           plot section
#####################################
{
  cmd <- sprintf("plot_qqline(data = data, ycol = get(y),%s
  symsize = conf$extra$point_size,
  symthick = conf$extra$point_thick,
  s_alpha = conf$general$alpha)",
    ifelse(group != "", "group = get(group),", ""))
  
  p <- eval(parse(text = cmd))
  p <- p + ggtitle(conf$general$title)
  if (facet != "") {
    p <- p + facet_wrap(facet)
  }
  p <- p + xlab("theoretical") + ylab("sample") + 
    guides(fill = guide_legend(title = group))
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

