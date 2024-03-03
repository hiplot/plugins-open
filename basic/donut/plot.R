#######################################################
# Donut plot.                                         #
#-----------------------------------------------------#
# Author: < Mingjie Wang > from < Ke Yan Mao >        #
# Affiliation: Shanghai Hiplot Team                   #
# Email: customer_service1501@tengyunbio.com          #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2020-04-30                                    #
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
  if (ncol(data) != 2) {
    print("Error: Input data should be 2 columns!")
  }

  # check conf
  lab.show <- conf$extra$label

  # check alpha
  alpha_usr <- conf$general$alpha
  if (is.numeric(alpha_usr) & alpha_usr >= 0 & alpha_usr <= 1) {
    # nothing
  } else {
    print("Error, alpha should be a decimal between 0-1")
  }

  # circle width
  circ.width <- 0
  conf.width <- conf$extra$width
  if (is.integer(conf.width)) {
    if (conf.width >= 1 & conf.width <= 5) {
      if (conf.width == 1) {
        circ.width <- -10
      } else if (conf.width == 2) {
        circ.width <- -5
      } else if (conf.width == 3) {
        circ.width <- 0
      } else if (conf.width == 4) {
        circ.width <- 1
      } else if (conf.width == 5) {
        circ.width <- 2
      } else {
        print("Error, circle width is wrong number.")
      }
    }
  }
}
############# Section 2 #############
#           plot section
#####################################
{
  # Compute percentages
  data$fraction <- data[, 2] / sum(data[, 2])

  # Compute the cumulative percentages (top of each rectangle)
  data$ymax <- cumsum(data$fraction)

  # Compute the bottom of each rectangle
  data$ymin <- c(0, head(data$ymax, n = -1))

  # Compute label position
  data$labelPosition <- (data$ymax + data$ymin) / 2

  # Compute a good label
  data$label <- paste0(data[, 1], "\n",
    "(", data[, 2], ", ", sprintf("%2.2f%%", 100 * data[, 2] / sum(data[, 2])), ")",
    sep = ""
  )

  # plot
  p <- ggplot(data, aes_(
    ymax = as.name("ymax"),
    ymin = as.name("ymin"), xmax = 4, xmin = 3,
    fill = as.name(colnames(data)[1])
  )) +
    geom_rect() +
    coord_polar(theta = "y") + # Try to remove that to understand how the chart is built initially
    xlim(c(circ.width, 5)) + # Try to remove that to see how to make a pie chart
    theme_void() +
    ggtitle(conf$general$title) +
    theme(plot.title = element_text(hjust = 0.5)) +
    scale_fill_manual(values = add_alpha(get_hiplot_color(conf$general$palette,
      nrow(data), conf$general$paletteCustom), alpha_usr))

  # show labels
  if (lab.show) {
    p <- p +
      geom_text(x = 5 + (4 - conf$extra$width) / 3,
      aes(y = labelPosition, label = label), size = 4) +
      theme(legend.position = "none")
  }
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}
