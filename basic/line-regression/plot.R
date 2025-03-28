#######################################################
# Line regression.                                    #
#-----------------------------------------------------#
# Author: < Mingjie Wang > from < Ke Yan Mao >        #
# Affiliation: Shanghai Hiplot Team                   #
# Email: customer_service1501@tengyunbio.com          #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2020-04-10                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2020 by Hiplot Team                   #
# All rights reserved.                                #
#######################################################

pkgs <- c("ggrepel", "ggplot2")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  if (ncol(data) == 2) {
    data[,"Group"] <- "default" 
  }
  cnames <- colnames(data)
  colnames(data) <- c("value1", "value2", "group")
  data$group <- factor(data$group, levels = unique(data$group))
  data[,1] <- transform_val(conf$general$transformX, data[,1])
  data[,2] <- transform_val(conf$general$transformY, data[,2])
  keep_vars <- c(keep_vars, "cnames", "repels", "equation")
}

############# Section 2 #############
#           plot section
#####################################
{
  equation <- function(x, add_p = FALSE) {
    xs <- summary(x)
    lm_coef <- list(
      a = as.numeric(round(coef(x)[1], digits = 2)),
      b = as.numeric(round(coef(x)[2], digits = 2)),
      r2 = round(xs$r.squared, digits = 2),
      pval = xs$coef[2, 4] 
    )
    if (add_p) {
      lm_eq <- substitute(italic(y) == a + b %.% italic(x) * "," ~ ~
    italic(R)^2 ~ "=" ~ r2 * "," ~ ~ italic(p) ~ "=" ~ pval, lm_coef)
    } else {
      lm_eq <- substitute(italic(y) == a + b %.% italic(x) * "," ~ ~
    italic(R)^2 ~ "=" ~ r2, lm_coef)
    }
    as.expression(lm_eq)
  }
  # plots
  p <- ggplot(data, aes(x = value1, y = value2, colour = group)) +
    geom_point(show.legend = TRUE) +
    geom_smooth(method = "lm", se = T, show.legend = F) +
    geom_rug(sides = "bl", size = 1, show.legend = F) +
    theme_bw() +
    labs(
      x = cnames[1],
      y = cnames[2],
      title = "Line Regression"
    ) +
    ggtitle(conf$general$title)
  ## add annotations for each group using ggrepel
  repels <- rep("", nrow(data))
  for (g in unique(data$group)) {
    fit <- lm(value2 ~ value1, data = data[data$group == g, ])
    v <- max(data[data$group == g, "value2"])
    repels[which(data$value2 == v)[1]] <- equation(fit, add_p = conf$extra$add_p)
  }

  if (conf$extra$addFunction) {
    if (is.null(conf$extra$functionLabelPadding)) {
      conf$extra$functionLabelPadding = 5
    }
    if (is.null(conf$extra$functionSize)) {
      conf$extra$functionSize = 4
    }
    if (is.null(conf$extra$nudgeX)) {
      conf$extra$nudgeX = 0
    }
    if (is.null(conf$extra$nudgeY)) {
      conf$extra$nudgeY = 0
    }
    p <- p + geom_text_repel(
      data = data,
      label = repels,
      size = conf$extra$functionSize,
      force = conf$extra$functionLabelPadding,
      label.padding = conf$extra$functionLabelPadding,
      na.rm = TRUE,
      min.segment.length = 100,
      show.legend = FALSE,
      nudge_x = conf$extra$nudgeX,
      nudge_y = conf$extra$nudgeY
    )
  }

  ## add color palette
  if (conf$general$palette != "default") {
    p <- p + return_hiplot_palette_color(conf$general$palette,
    conf$general$paletteCustom)
  }

  ## set theme
  p <- set_complex_general_theme(set_palette_theme(p, conf))
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}

