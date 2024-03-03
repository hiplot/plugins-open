#######################################################
# Error bar line plot.                                #
#-----------------------------------------------------#
# Author: < Mingjie Wang > from < Ke Yan Mao >        #
# Affiliation: Shanghai Hiplot Team                   #
# Email: customer_service1501@tengyunbio.com          #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2020-04-13                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2020 by Hiplot Team                   #
# All rights reserved.                                #
#######################################################

pkgs <- c("ggpubr")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  # check arguments
  if (str_detect(toupper(conf$extra$pval), "VALUE")) {
    pval <- ""
  } else if (str_detect(toupper(conf$extra$pval), "SIG")) {
    pval <- "p.signif"
  } else {
    pval <- "none"
  }

  usr_cname <- colnames(data)

  # check data columns
  if (ncol(data) %in% c(2, 3)) {
    # nothing
  } else {
    print("Error: Input data should be 2 or 3 columns!")
  }
  if (ncol(data) == 2 && !is.numeric(data[, 2])) {
    data[, 2] <- factor(data[, 2], levels = unique(data[, 2]))
  }
  if (ncol(data) == 3 && !is.numeric(data[, 3])) {
    data[, 3] <- factor(data[, 3], levels = unique(data[, 3]))
  }
  data[,1] <- transform_val(conf$general$transformY, data[,1])
}

############# Section 2 #############
#           plot section
#####################################
{
  if (ncol(data) == 2) {
    groups <- unique(data[, 2])
    ngroups <- length(groups)
    comb <- combn(1:ngroups, 2)

    my_comparisons <- list()
    for (i in seq_len(ncol(comb))) {
      my_comparisons[[i]] <- groups[comb[, i]]
    }

    p <- ggline(data,
      x = usr_cname[2], y = usr_cname[1],
      add = "mean_se",
      xlab = usr_cname[2], ylab = usr_cname[1],
      title = conf$general$title
    )

    if (pval != "none") {
      p <- p + stat_compare_means(comparisons = my_comparisons, label = pval)
    }
  } else {
    p <- ggline(data, usr_cname[3],
      y = usr_cname[1],
      add = "mean_se", color = usr_cname[2],
      xlab = usr_cname[3], ylab = usr_cname[1],
      title = conf$general$title,
      palette = "npg"
    )
    if (pval == "") {
      p <- p + stat_compare_means(aes_(group = as.name(usr_cname[2])))
    } else if (pval == "p.signif") {
      p <- p + stat_compare_means(aes_(group = as.name(usr_cname[2])),
        label = pval
      )
    } else {
      # nothing
    }
  }

  ## add color palette
  p <- p + return_hiplot_palette_color(conf$general$palette,
    conf$general$paletteCustom)

  ## set theme
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

