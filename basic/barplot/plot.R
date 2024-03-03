#######################################################
# Bar plot.                                           #
#-----------------------------------------------------#
# Author: < Mingjie Wang > from < Ke Yan Mao >        #
# Affiliation: Shanghai Hiplot Team                   #
# Email: customer_service1501@tengyunbio.com          #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2020-04-25                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2020 by Hiplot Team                   #
# All rights reserved.                                #
#######################################################

pkgs <- c("ggplot2")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  # check data
  # check data columns
  if (!ncol(data) %in% c(2, 3)) {
    print("Error: Input data should be 2 or 3 columns!")
  }

  # check conf arguments
  # check alpha
  alpha_usr <- conf$general$alpha
  if (is.numeric(alpha_usr) & alpha_usr >= 0 & alpha_usr <= 1) {
    # nothing
  } else {
    print("Error, alpha should be a decimal between 0-1")
  }

  # check horizon
  horizon <- conf$extra$horizon
  # check whether stacked bar plot
  type <- "dodge"
  if (str_detect(toupper(conf$extra$type), "STACK")) {
    type <- "stack"
  } else if (str_detect(toupper(conf$extra$type), "FILL")) {
    type <- "fill"
  } else {
    type <- "dodge"
  }
  # check whether stacked bar plot
  label <- conf$extra$label
}

############# Section 2 #############
#           plot section
#####################################
{
  if (ncol(data) == 2) {
    data[, 2] <- factor(data[, 2], levels = unique(data[, 2]))
  } else {
    data[, 3] <- factor(data[, 3], levels = unique(data[, 3]))
  }
  if (ncol(data) == 2) {
    if (type == "dodge") {
      p <- ggplot(data, aes_(
        x = as.name(colnames(data[2])),
        y = as.name(colnames(data[1])), fill = as.name(colnames(data[2]))
      )) +
        geom_bar(position = type, stat = "identity") +
        ggtitle(conf$general$title) +
        scale_fill_manual(values = add_alpha(get_hiplot_color(
          conf$general$palette,
          length(unique(data[, 2])),
          conf$general$paletteCustom
        ), conf$general$alpha))
    } else {
      data[["Group"]] <- "Group"
      p <- ggplot(data, aes_(
        x = as.name(colnames(data[3])),
        y = as.name(colnames(data[1])), fill = as.name(colnames(data[2]))
      )) +
        geom_bar(position = type, stat = "identity") +
        ggtitle(conf$general$title) +
        xlab(colnames(data)[2]) +
        scale_fill_manual(values = add_alpha(get_hiplot_color(
          conf$general$palette,
          length(unique(data[, 2])),
          conf$general$paletteCustom
        ), conf$general$alpha))
    }
  } else {
    p <- ggplot(data, aes_(
      x = as.name(colnames(data[3])),
      y = as.name(colnames(data[1])), fill = as.name(colnames(data[2]))
    )) +
      geom_bar(position = type, stat = "identity") +
      ggtitle(conf$general$title) +
      scale_fill_manual(values = add_alpha(get_hiplot_color(
        conf$general$palette,
        length(unique(data[, 2])),
        conf$general$paletteCustom
      ), conf$general$alpha))
  }

  # horizon
  if (horizon) {
    p <- p + coord_flip()
  }

  # label
  if (label) {
    p <- p + geom_text(aes(label = data[, 1]),
      position = position_type(type),
      vjust = 1.6, color = "white", size = 3.5
    )
  }

  # theme
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

