#######################################################
# Diverging-scale plot.                               #
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
  axis <- sapply(conf$dataArg[[1]], function(x) x$value)

  if (conf$extra$scale) {
    cmd <- sprintf(
      "data <- dplyr::transmute(.data = data, x = %s, y = scale(%s))",
      axis[2], axis[1]
    )
  } else {
    cmd <- sprintf(
      "data <- dplyr::transmute(.data = data, x = %s, y = %s)",
      axis[2], axis[1]
    )
  }
  eval(parse(text = cmd))

  fill_colors <- c(conf$extra$groupcolor1, conf$extra$groupcolor2)
  fill_colors <- fill_colors[c(any(data[, "y"] > 0), any(data[, "y"] < 0))]
  single <- FALSE
  if (all(data[, "y"] >= 0) || all(data[, "y"] <= 0)) {
    single <- TRUE
  }
}

############# Section 2 #############
#           plot section
#####################################
{
  if (single && conf$extra$type == "bar") {
    cmd <- sprintf(
      "p <- bar_chart(data = data, %s)",
      "x = x, y = y, bar_colors = fill_colors"
    )
  } else if (single && conf$extra$type != "bar") {
    cmd <- sprintf(
      "p <- lollipop_chart(data = data, %s, %s%s)",
      "x = x, y = y, line_color = fill_colors, ",
      "line_size = conf$extra$lineSize, ",
      "point_size = conf$extra$pointSize"
    )
  } else if (conf$extra$type == "bar") {
    cmd <- sprintf(
      "p <- diverging_bar_chart(data = data, %s)",
      "x = x, y = y, bar_colors = fill_colors, text_color = '#000000'"
    )
  } else {
    cmd <- sprintf(
      "p <- diverging_lollipop_chart(data = data, %s, %s%s)",
      "x = x, y = y, lollipop_colors = fill_colors, ",
      "line_size = conf$extra$lineSize, ",
      "point_size = conf$extra$pointSize, text_color = '#000000'"
    )
  }

  eval(parse(text = cmd))
  if (single) {
    p <- p + theme(axis.text.y = element_text(color = "#000000"))
  }
  p <- p + theme(axis.text.x = element_text(color = "#000000"))
  if (conf$extra$scale) {
    p <- p + labs(
      x = axis[2], y = sprintf("scale(%s)", axis[1]),
      title = conf$general$title
    )
  } else {
    p <- p + labs(
      x = axis[2], y = axis[1],
      title = conf$general$title
    )
  }
  p <- p + theme(
    axis.title.x = element_text(colour = "#000000"),
    axis.title.y = element_text(colour = "#000000")
  )

  p <- p + theme(plot.background = element_blank())
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
