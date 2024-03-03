#######################################################
# Matrix-Bubble.                                      #
#-----------------------------------------------------#
# Author: benben-miao                                 #
#                                                     #
# Email: benben.miao@outlook.com                      #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2020-09-10                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2020 by Hiplot Team                   #
# All rights reserved.                                #
#######################################################

pkgs <- c("ggalluvial", "ggplot2")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  data[, 1] <- factor(data[, 1], levels = unique(data[, 1]))
  data[, 2] <- factor(data[, 2], levels = unique(data[, 2]))
}

############# Section 2 #############
#           plot section
#####################################
{
  if (conf$general$palette == "default") {
        p <- ggplot(
        data = data,
        aes_string(
          x = colnames(data)[1], y = colnames(data)[2],
          size = colnames(data)[3]
        )
      )
  } else {
    p <- ggplot(
        data = data,
        aes_string(
          x = colnames(data)[1], y = colnames(data)[2],
          size = colnames(data)[3],
          color = colnames(data)[2]
        )
      )
  }
  p <- p +
    geom_point(alpha = conf$general$alpha) +
    # guides(colour = "legend", size = "legend") +
    labs(
      title = conf$general$title,
      x = colnames(data)[1],
      y = colnames(data)[2]
    ) +
    guides(color = FALSE) +
    theme(
      panel.background = element_blank(),
      panel.grid.major = element_line(colour = "gray"),
      strip.background = element_blank(),
      panel.border = element_rect(
        colour = conf$extra$panel_border_color,
        fill = NA
      ),
      panel.spacing = unit(conf$extra$panel_space, "lines"),
      plot.title = element_text(
        size = conf$general$titleSize,
        hjust = 0.5
      ),
      text = element_text(
        family = conf$general$font
      ),
      legend.title = element_text(
        size = conf$general$legendTitleSize
      ),
      axis.text.x = element_text(
        angle=conf$general$xAxisTextAngle,
        hjust=conf$general$xAxisHjust,
        vjust=conf$general$xAxisVjust
      )
    )
  if (ncol(data) == 4) {
    data[, 4] <- factor(data[, 4], levels = unique(data[, 4]))
    eval(parse(text = sprintf(
      paste0("p <- p + facet_grid(~%s,",
      "scales = 'fixed', margins = F)"),
      colnames(data)[4]
    )))
  }
  p <- p + return_hiplot_palette_color(conf$general$palette,
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
