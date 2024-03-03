#######################################################
# Violin plot.                                        #
#-----------------------------------------------------#
# Author: < Mingjie Wang > from < Ke Yan Mao >        #
# Affiliation: Shanghai Hiplot Team                   #
# Email: customer_service1501@tengyunbio.com          #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2019-11-28                                    #
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
  ## check conf
  # check alpha
  alpha_usr <- conf$general$alpha
  if (is.numeric(alpha_usr) & alpha_usr >= 0 & alpha_usr <= 1) {
    # nothing
  } else {
    print("Error, alpha should be a decimal between 0-1")
  }

  # check arguments
  add_box <- "none"
  if (conf$extra$box) {
    add_box <- "boxplot"
  }

  # pvalue
  if (str_detect(toupper(conf$extra$pval), "VALUE")) {
    pval <- ""
  } else if (str_detect(toupper(conf$extra$pval), "SIG")) {
    pval <- "p.signif"
  } else {
    pval <- "none"
  }

  ## check data
  # get colnames of data
  usr_cname <- colnames(data)

  # check data columns
  if (ncol(data) %in% c(2, 3)) {
    # nothing
  } else {
    print("Error: Input data should be 2 or 3 columns!")
  }
  data[,1] <- as.numeric(data[,1])
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

    p <- ggviolin(data,
      x = usr_cname[2], y = usr_cname[1],
      fill = usr_cname[2], add = add_box,
      xlab = usr_cname[2], ylab = usr_cname[1],
      add.params = list(fill = "white"),
      palette = get_hiplot_color(conf$general$palette, -1,
        conf$general$paletteCustom),
      title = conf$general$title,
      alpha = conf$general$alpha
    )

    if (pval != "none") {
      p <- p + stat_compare_means(comparisons = my_comparisons, label = pval)
    }
  } else {
    groups <- unique(data[, 2])
    ngroups <- length(groups)
    comb <- combn(1:ngroups, 2)

    my_comparisons <- list()
    for (i in seq_len(ncol(comb))) {
      my_comparisons[[i]] <- groups[comb[, i]]
    }

    p <- ggviolin(
      data,
      x = usr_cname[2], y = usr_cname[1],
      facet.by = usr_cname[3], add = add_box, fill = usr_cname[2],
      xlab = usr_cname[3], ylab = usr_cname[1],
      add.params = list(fill = "white"),
      palette = get_hiplot_color(conf$general$palette, -1,
        conf$general$paletteCustom),
      title = conf$general$title,
      alpha = conf$general$alpha
    )

    if (pval != "none") {
      p <- p + stat_compare_means(comparisons = my_comparisons, label = pval)
    }
  }
  # change theme
  theme <- conf$general$theme
  p <- choose_ggplot_theme(p, theme)
  p <- set_complex_general_theme(p)
  p <- p + scale_y_continuous(expand = expansion(mult = c(0.1, 0.1)))
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}
