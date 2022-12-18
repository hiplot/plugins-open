#######################################################
# Visdat Plot.                                        #
#-----------------------------------------------------#
# Author: Jianfeng Li                                 #
# Email: lee_jianfeng@hiplot.org                      #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2021-02-20                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2022 by "National Center for          #
# Translational Medicine·Shanghai                     #
# All rights reserved.                                #
#######################################################

# load required packages
pkgs <- c("visdat", "ggplot2", "dplyr")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  add_palette <- function (p) {
    ## add color palette
    p <- p + return_hiplot_palette_color(conf$general$palette,
      conf$general$paletteCustom) +
      return_hiplot_palette(conf$general$palette,
      conf$general$paletteCustom)
  }
}

############# Section 2 #############
#           plot section
#####################################
{
  colors <- get_hiplot_color(conf$general$paletteCont, -1,
    conf$general$paletteCustom)
  pobj <- list()
  if ("vis_dat" %in% conf$extra$mode)
    pobj[["p1"]] <- add_palette(vis_dat(data)) + ggtitle(':vis_dat')
  if ("vis_guess" %in% conf$extra$mode)
    pobj[["p2"]] <- add_palette(vis_guess(data)) + ggtitle(':vis_guess')
  if ("vis_miss" %in% conf$extra$mode)
    pobj[["p3"]] <- vis_miss(data, cluster = conf$extra$missingClust,
    sort_miss = conf$extra$missingSort) + ggtitle(':vis_miss')
  if ("vis_expect" %in% conf$extra$mode)
    pobj[["p4"]] <- add_palette(eval(parse(text = 
      sprintf("vis_expect(data, ~.x %s)", conf$extra$expect)))) + 
      ggtitle(':vis_expect')
  if ("vis_cor" %in% conf$extra$mode)
    pobj[["p5"]] <- vis_cor(data) + 
      scale_fill_gradientn(colours = colors) + ggtitle(':vis_cor')
  if ("vis_value" %in% conf$extra$mode)
    pobj[["p6"]] <- data %>%
      select_if(is.numeric) %>%
      vis_value() + ggtitle(':vis_value')

  pobj[["p6"]] <- pobj[["p6"]] + scale_fill_gradientn(colours = colors)

  if (length(pobj) == 1) {
    p <- pobj[[1]]
  } else {
    pstr <- paste0(sprintf("pobj[[%s]]", 1:length(pobj)), collapse = " + ")
    p <- eval(parse(text = 
      sprintf("%s + plot_layout(ncol = conf$extra$ncol) +
    plot_annotation(tag_levels = 'A')", pstr)))
  }
  p <- p & choose_ggplot_theme2(conf$general$theme)
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}
