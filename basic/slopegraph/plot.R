#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2022 by "National Center for          #
# Translational Medicine·Shanghai                     #
# All rights reserved.                                #
#######################################################

pkgs <- c("CGPfunctions", "ggplot2")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 2 #############
#           plot section
#####################################
{
  time <- conf$dataArg[[1]][[1]]$value
  measure <- unlist(conf$dataArg[[1]][[2]]$value)
  group <- conf$dataArg[[1]][[3]]$value
  data[, group] <- factor(data[ ,group], levels = unique(data[ ,group]))
  data[, time] <- factor(data[ ,time], levels = unique(data[ ,time]))

  p <- eval(parse(text = sprintf("newggslopegraph(data, %s, %s, %s)",
    time, measure, group))) +
  labs(
    subtitle = "",
    title = conf$general$title,
    x = conf$general$xlab,
    y = colnames(data)[1],
    caption = ""
  )

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
