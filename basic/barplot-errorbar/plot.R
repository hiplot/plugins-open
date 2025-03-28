#######################################################
# Barplot errorbar.                                   #
#-----------------------------------------------------#
# Author: benben-miao                                 #
#                                                     #
# Email: benben.miao@outlook.com                      #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2021-11-07                                    #
# Version: 0.2                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2020 by Hiplot Team                   #
# All rights reserved.                                #
#######################################################

pkgs <- c("Rmisc", "ggplot2", "ggpubr")
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
  if (!is.numeric(data[, 2])) {
    data[, 2] <- factor(data[, 2], levels = unique(data[, 2]))
  }
  if (is.null(conf$extra$pval)) {
    pval <- "none"
  } else {
    if (str_detect(toupper(conf$extra$pval), "VALUE")) {
      pval <- ""
    } else if (str_detect(toupper(conf$extra$pval), "SIG")) {
      pval <- "p.signif"
    } else {
      pval <- "none"
    }
  }
}

############# Section 2 #############
#           plot section
#####################################
{
  keep_vars <- c(keep_vars, "data_sd")
  if (ncol(data) == 3) {
    if (!is.numeric(data[, 3])) {
      data[, 3] <- factor(data[, 3], levels = unique(data[, 3]))
    }
    data_sd <- summarySE(data,
      measurevar = colnames(data)[1],
      groupvars = colnames(data)[2:3]
    )
    p <- ggplot(
      data_sd,
      aes(
        x = data_sd[, 1],
        y = data_sd[, 4],
        fill = data_sd[, 2]
      )
    ) +
      geom_bar(
        stat = "identity",
        color = conf$extra$bar_colour,
        position = position_dodge(),
        alpha = conf$general$alpha
      ) +
      geom_errorbar(
        aes(
          ymin = data_sd[, 4] - sd,
          ymax = data_sd[, 4] + sd
        ),
        width = conf$extra$errorbar_width,
        position = position_dodge(0.9)
      )
      if (!is.null(conf$extra$point) && conf$extra$point) {
        p <- p + geom_point(data = data, aes(data[, 2], data[, 1], fill = data[, 3], color = data[, 3]), size = 2, fill = "black",
        pch = 19)
      }
      if (pval != "none") {
        if (pval == "") pval <- "p"
        p <- p + stat_compare_means(data = data, aes(data[, 2], data[, 1], fill = data[, 3], color = data[, 3]),
        label = pval, vjust = -2, method = conf$extra$stat_method)
      }
      p <- p + labs(
        title = conf$general$title,
        x = colnames(data_sd)[1],
        y = colnames(data_sd)[4],
        fill = colnames(data_sd)[2],
        color = colnames(data_sd)[2]
      )
  } else {
    data_sd <- summarySE(data,
      measurevar = colnames(data)[1],
      groupvars = colnames(data)[2]
    )
    p <- ggplot(
      data_sd,
      aes(
        x = data_sd[, 1],
        y = data_sd[, 3],
        fill = data_sd[, 1]
      )
    ) +
      geom_bar(
        stat = "identity",
        color = conf$extra$bar_colour,
        position = position_dodge(),
        alpha = conf$general$alpha
      ) +
      geom_errorbar(
        aes(
          ymin = data_sd[, 3] - sd,
          ymax = data_sd[, 3] + sd
        ),
        width = conf$extra$errorbar_width,
        position = position_dodge(0.9)
      ) +
      labs(
        title = conf$general$title,
        x = colnames(data_sd)[1],
        y = colnames(data_sd)[3],
        fill = colnames(data_sd)[1]
      )
      if (!is.null(conf$extra$point) && conf$extra$point) {
        p <- p + geom_jitter(data = data, aes(data[, 2], data[, 1], fill = data[, 2]), size = 2, fill = "black",
        pch = 19, width = 0.2)
      }
      if (pval != "none") {
        if (pval == "") pval <- "p"
        p <- p + stat_compare_means(data = data, aes(data[, 2], data[, 1], fill = data[, 2]),
        label = pval, ref.group = ".all.", vjust = -2, method = conf$extra$stat_method)
      }
  }

  p <- p + return_hiplot_palette_color(conf$general$palette,
      conf$general$paletteCustom) +
    return_hiplot_palette(conf$general$palette,
      conf$general$paletteCustom)

  p <- set_complex_general_theme(set_palette_theme(p, conf))

  if (pval != "none") {
    p <- p + scale_y_continuous(expand = expansion(mult = c(0, 0.2)))
  }
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}
