#######################################################
# Barplot errorbar2.                                  #
#-----------------------------------------------------#
# Author: Jianfeng                                    #
#                                                     #
# Email: lee_jianfeng@openbiox.org                    #
# Website: hiplot.org                        #
#                                                     #
# Date: 2022-03-31                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2022 by "National Center for          #
# Translational Medicine·Shanghai                     #
# All rights reserved.                                #
#######################################################

pkgs <- c("ggplot2", "grafify", "ggpubr")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  facet <- unlist(conf$dataArg[[1]][[1]]$value)
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
  if (length(conf$extra$test_groups) == 0) {
    groups <- unique(data[, 2])
  } else {
    groups <- conf$extra$test_groups
  }
  my_comparisons <- combn(groups, 2, simplify = FALSE)
  # Avoid numeric groups
  my_comparisons <- lapply(my_comparisons, as.character)

  if (ncol(data) == 2) {
    p <- plot_scatterbar_sd(data,
                   ycol = get(colnames(data)[1]),
                   xcol = get(colnames(data)[2]),
                   b_alpha = alpha_usr,
                   ewid = conf$extra$errorbar_width,
                   jitter = conf$extra$jitter)
    if (pval != "none") {
      if (pval == "") pval <- "p"
      if (length(conf$extra$test_groups) > 1) {
        p <- p + stat_compare_means(data = data,
          aes(data[, 2], data[, 1], fill = data[, 2]),
          comparisons = my_comparisons,
          label = pval, vjust = -2, method = conf$extra$stat_method)
      } else {
        p <- p + stat_compare_means(data = data,
          aes(data[, 2], data[, 1], fill = data[, 2]), label = pval, ref.group = ".all.", vjust = -2, method = conf$extra$stat_method)
      }
    }
    p <- p + guides(fill=guide_legend(title=colnames(data)[2]))
  } else {
    p <- plot_4d_scatterbar(data,
                   get(colnames(data)[2]),
                   get(colnames(data)[1]),
                   get(colnames(data)[3]),
                   get(colnames(data)[2]),
                   b_alpha = alpha_usr,
                   ewid = conf$extra$errorbar_width,
                   jitter = conf$extra$jitter) +
                   scale_shape_manual(values = rep(20, length(unique(data[,2]))))
    if (pval != "none") {
      if (pval == "") pval <- "p"
      p <- p + stat_compare_means(data = data, aes(data[, 2], data[, 1], fill = data[, 3], color = data[, 3]),
        label = pval, vjust = -2, method = conf$extra$stat_method)
    }
    p <- p + guides(fill=guide_legend(title=colnames(data)[3]), shape = FALSE)
  }
  if (facet != "") {
    p <- p + facet_wrap(facet)
  }
  p <- p + xlab(colnames(data)[2]) + ylab(colnames(data)[1])
  p <- p + return_hiplot_palette_color(conf$general$palette,
      conf$general$paletteCustom) +
    return_hiplot_palette(conf$general$palette,
      conf$general$paletteCustom)

  theme <- conf$general$theme
  p <- choose_ggplot_theme(p, theme)
  p <- set_complex_general_theme(p)

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
