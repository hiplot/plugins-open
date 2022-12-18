#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2022 by "National Center for          #
# Translational Medicine·Shanghai                     #
# All rights reserved.                                #
#######################################################

pkgs <- c("ggplotify", "likert")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  levs <- unique(unlist(data))
  for (i in 1:ncol(data)) {
    data[,i] <- factor(data[, i], levels = levs)
  }
}

############# Section 2 #############
#           plot section
#####################################
{
  pobj <- likert(data)
  colrs <- get_hiplot_color(conf$general$palette, -1, conf$general$paletteCustom)
  if (conf$extra$type == "density") {
    p <- as.ggplot(plot(pobj, type = "density", facet = conf$extra$facet,
      low.color = colrs[1], high.color = colrs[2]))
  } else {
    p <- as.ggplot(plot(pobj, type = conf$extra$type, low.color = colrs[1], high.color = colrs[2], wrap = 50))
  }
  theme <- conf$general$theme
  p <- choose_ggplot_theme(p, theme)
  p <- p + return_hiplot_palette_color(conf$general$palette,
    conf$general$paletteCustom) +
  return_hiplot_palette(conf$general$palette,
    conf$general$paletteCustom)
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(ggdraw(p))
}

