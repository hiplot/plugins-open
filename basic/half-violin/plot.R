#######################################################
# Half violin.                                        #
#-----------------------------------------------------#
# Author: < Mingjie Wang > from < Ke Yan Mao >        #
# Affiliation: Shanghai Hiplot Team                   #
# Email: customer_service1501@tengyunbio.com          #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2019-11-19                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2020 by Hiplot Team                   #
# All rights reserved.                                #
#######################################################

pkgs <- c("ggplot2", "dplyr", "ggpubr")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  colnames(data) <- c("Value", "Group")
  if (!is.numeric(data[, 2])) {
    data[, 2] <- factor(data[, 2], levels = unique(data[, 2]))
  }
}

############# Section 2 #############
#           plot section
#####################################
{
  p2 <- function () {
    # functions to draw half violin
    "%||%" <- function(a, b) {
      if (!is.null(a)) {
        a
      } else {
        b
      }
    }
    geom_flat_violin <-
      function(mapping = NULL,
              data = NULL,
              stat = "ydensity",
              position = "dodge",
              trim = TRUE,
              scale = "area",
              show.legend = NA,
              inherit.aes = TRUE,
              ...) {
        ggplot2::layer(
          data = data,
          mapping = mapping,
          stat = stat,
          geom = geom_flat_violin_proto,
          position = position,
          show.legend = show.legend,
          inherit.aes = inherit.aes,
          params = list(
            trim = trim,
            scale = scale,
            ...
          )
        )
      }

    geom_flat_violin_proto <-
      ggproto(
        "geom_flat_violin_proto",
        Geom,
        setup_data = function(data, params) {
          data$width <- data$width %||%
            params$width %||% (resolution(data$x, FALSE) * 0.9)

          # ymin, ymax, xmin, and xmax define the bounding rectangle for each group
          data %>%
            dplyr::group_by(.data = ., group) %>%
            dplyr::mutate(
              .data = .,
              ymin = min(y),
              ymax = max(y),
              xmin = x,
              xmax = x + width / 2
            )
        },

        draw_group = function(data, panel_scales, coord) {
          # Find the points for the line to go all the way around
          data <- base::transform(data,
            xminv = x,
            xmaxv = x + violinwidth * (xmax - x)
          )

          # Make sure it's sorted properly to draw the outline
          newdata <-
            base::rbind(
              dplyr::arrange(.data = base::transform(data, x = xminv), y),
              dplyr::arrange(.data = base::transform(data, x = xmaxv), -y)
            )

          # Close the polygon: set first and last point the same
          # Needed for coord_polar and such
          newdata <- rbind(newdata, newdata[1, ])

          ggplot2:::ggname(
            "geom_flat_violin",
            GeomPolygon$draw_panel(newdata, panel_scales, coord)
          )
        },

        draw_key = draw_key_polygon,

        default_aes = ggplot2::aes(
          weight = 1,
          colour = "grey20",
          fill = "white",
          size = 0.5,
          alpha = NA,
          linetype = "solid"
        ),

        required_aes = c("x", "y")
    )
    p <- ggplot(data = data, aes(Group, Value, fill = Group)) +
    geom_flat_violin(
      alpha = conf$general$alpha,
      scale = "count",
      trim = FALSE
    ) +
    geom_boxplot(
      width = 0.05,
      fill = "white",
      alpha = conf$general$alpha,
      outlier.colour = NA,
      position = position_nudge(0.05)
    ) +
    stat_summary(
      fun = mean,
      geom = "point",
      fill = "white",
      shape = 21,
      size = 2,
      position = position_nudge(0.05)
    ) +
    geom_dotplot(
      alpha = conf$general$alpha,
      binaxis = "y",
      dotsize = 0.5,
      stackdir = "down",
      binwidth = 0.1,
      position = position_nudge(-0.025)
    ) +
    theme(legend.position = "none") +
    xlab(colnames(data)[2]) +
    ylab(colnames(data)[1]) +
    guides(fill = F) +
    ggtitle(conf$general$title)
    return(p)
  }
  ## add color palette
  p <- p2() + return_hiplot_palette_color(conf$general$palette,
      conf$general$paletteCustom) +
    return_hiplot_palette(conf$general$palette,
      conf$general$paletteCustom)
  ## set theme
  p <- set_complex_general_theme(set_palette_theme(p, conf))
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
  p <- p2
  rm(p2)
}

