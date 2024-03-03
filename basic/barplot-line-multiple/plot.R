#######################################################
# Violin plot.                                        #
#-----------------------------------------------------#
# Author: benben-miao                                 #
#                                                     #
# Email: benben.miao@outlook.com                      #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2020-08-17                                    #
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
  ## check conf
  # check alpha
  alpha_usr <- conf$general$alpha
  if (is.numeric(alpha_usr) & alpha_usr >= 0 & alpha_usr <= 1) {
    # nothing
  } else {
    stop("Error, alpha should be a decimal between 0-1")
  }
  data[,1] <- transform_val(conf$general$transformX, data[,1])
  for (i in 2:ncol(data)) {
    data[,i] <- transform_val(conf$general$transformY, data[,i])
  }
}

############# Section 2 #############
#           plot section
#####################################
{
  keep_vars <- c(keep_vars, "data_melt")
  data_melt <- melt(data, id.vars = colnames(data)[1])
  if (!is.numeric(data_melt[, 1])) {
    data_melt[, 1] <- factor(data_melt[, 1],
      level = unique(data_melt[, 1]))
  }
  if (conf$extra$plot_type == "line") {
    p <- ggplot(
      data = data_melt,
      aes(
        x = data_melt[, 1],
        y = value,
        group = variable,
        colour = variable
      )
    ) +
      geom_line(
        alpha = conf$general$alpha,
        size = conf$extra$line_size
      ) +
      geom_point(
        aes(shape = variable),
        alpha = conf$general$alpha,
        size = conf$extra$point_size
      )
  } else if (conf$extra$plot_type == "barplot") {
    p <- ggplot(
      data = data_melt,
      aes(
        x = data_melt[, 1],
        y = value,
        fill = variable
      )
    ) +
      geom_bar(
        stat = "identity",
        position = position_dodge(),
        colour = conf$extra$bar_colour,
        alpha = conf$general$alpha
      )
  }
  p <- p + labs(
             title = conf$general$title,
             x = conf$general$xlab,
             y = conf$general$ylab
           )
  p <- choose_ggplot_theme(p, conf$general$theme)
  p <- p + return_hiplot_palette_color(conf$general$palette,
      conf$general$paletteCustom) +
    return_hiplot_palette(conf$general$palette,
      conf$general$paletteCustom)
  
  p <- set_complex_general_theme(p)

  if (!is.null(conf$extra$legend_title) && conf$extra$legend_title != "") {
    l <- guide_legend(title = conf$extra$legend_title)
    p <- p + guides(colour = l, shape = l, fill = l)
  }
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}
