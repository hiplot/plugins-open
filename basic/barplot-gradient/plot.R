#######################################################
# Barplot Gradient.                                   #
#-----------------------------------------------------#
# Author: Jianfeng Li                                 #
# Email: lee_jianfeng@hiplot.org                      #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2020-10-29                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2022 by "National Center for          #
# Translational Medicine·Shanghai                     #
# All rights reserved.                                #
#######################################################

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  pkgs <- c("stringr", "ggplot2")
  pacman::p_load(pkgs, character.only = TRUE)

  # check data
  # check data columns
  if (ncol(data) != 3) {
    stop("Error: Input data should be 3 columns!")
  }

  # check horizon
  horizon <- conf$extra$horizon
  data[, 1] <- capitalize(str_remove(data[, 1], pattern = "\\w+:\\d+\\W"))
  if (is.character(conf$extra$transform) && conf$extra$transform != "") {
    ylab <- sprintf("%s (%s)", conf$extra$transform,
        colnames(data)[2])
  } else {
    ylab <- colnames(data)[2]
  }
  if (is.character(conf$extra$transform2) && conf$extra$transform2 != "") {
    cleg <- sprintf("%s (%s)", conf$extra$transform2,
        colnames(data)[3])
  } else {
    cleg <- colnames(data)[3]
  }
  if (is.character(conf$extra$transform) && conf$extra$transform != "") {
    data[, 2] <- eval(parse(text = sprintf("%s(data[, 2])", conf$extra$transform)))
  }
  if (is.character(conf$extra$transform2) && conf$extra$transform2 != "") {
    data[, 3] <- eval(parse(text = sprintf("%s(data[, 3])", conf$extra$transform2)))
  }
  # check whether stacked bar plot
}

############# Section 2 #############
#           plot section
#####################################
{
  #data <- data[data[, 3] < 0.05, ]
  if (conf$extra$order_by_input) {
    data <- data[1:conf$extra$topnum, ]
    data[, 1] <- factor(data[, 1], level = rev(unique(data[, 1])))
  } else {
    data <- data[order(data[1:conf$extra$topnum, 3]), ]
    data[, 1] <- factor(data[, 1], level = unique(data[, 1]))
  }
  p <- ggplot(data, aes_(
    x = as.name(colnames(data[1])),
    y = as.name(colnames(data[2])),
    fill = as.name(colnames(data[3]))
  )) +
    geom_bar(stat = "identity") +
    ggtitle(conf$general$title) +
    scale_fill_continuous(
      low = conf$extra$low_color,
      high = conf$extra$high_color
    ) +
    scale_x_discrete(
      labels =
        function(x) {
          str_wrap(x, width = 65)
        }
    ) +
    labs(fill = cleg, y = ylab)

  # horizon
  if (horizon) {
    p <- p + coord_flip()
  } else {
    p <- p + theme(axis.text.x = element_text(angle = 90, hjust = 1))
  }
  # theme
  p <- set_complex_general_theme(set_palette_theme(p, conf))
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}
