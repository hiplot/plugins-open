#######################################################
# Box plot.                                           #
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

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  pkgs <- c("ggpubr")
  pacman::p_load(pkgs, character.only = TRUE)

  # check arguments
  if (conf$extra$point) {
    add_point <- "jitter"
  } else {
    add_point <- "none"
  }

  if (is.null(conf$extra$pval) || str_detect(toupper(conf$extra$pval), "VALUE")) {
    pval <- ""
  } else if (str_detect(toupper(conf$extra$pval), "SIG")) {
    pval <- "p.signif"
  } else {
    pval <- "none"
  }
  # read in data file
  usr_cname <- colnames(data)
  # check data columns
  if (ncol(data) %in% c(2, 3)) {
    # nothing
  } else {
    stop("Error: Input data should be 2 or 3 columns!")
  }
  fil <- sapply(data, function(x) {
    return(all(is.na(x)))
  })
  fil2 <- !(is.na(data[, 1]) | is.na(data[, 2]))

  data <- data[fil2, !fil]
  data[, 1] <- as.numeric(data[, 1])
  if (length(conf$extra$test_groups) == 0) {
    groups <- unique(data[, 2])
  } else {
    groups <- conf$extra$test_groups
  }
  my_comparisons <- combn(groups, 2, simplify = FALSE)
  # Avoid numeric groups
  my_comparisons <- lapply(my_comparisons, as.character)
}

############# Section 2 #############
#           plot section
#####################################
{
  if (ncol(data) == 2) {
    if (length(unique(data[,2])) > 100) {
      stop("Unique values of the second column should < 100")
    }
    p <- ggboxplot(data,
      x = usr_cname[2],
      y = usr_cname[1],
      notch = conf$extra$notch,
      color = usr_cname[2],
      add = add_point,
      xlab = usr_cname[2],
      ylab = usr_cname[1],
      palette = get_hiplot_color(conf$general$palette, -1,
        conf$general$paletteCustom),
      title = conf$general$title
    )
    theme <- conf$general$theme
    p <- choose_ggplot_theme(p, theme)

    p <- p + theme(
        plot.title = element_text(
          hjust = 0.5,
          vjust = 0.5
        ),
        legend.position = conf$general$legendPos
      )
    if (pval != "none") {
      p <- p + stat_compare_means(
        comparisons = my_comparisons,
        label = pval, method = conf$extra$method
      )
    }
  } else {
    if (length(unique(data[,2])) > 100) {
      stop("Unique values of the second column should < 100")
    }
    if (length(unique(data[,3])) > 100) {
      stop("Unique values of the 3th column should < 100")
    }
    # ncol = 3
    if (conf$extra$order_by_table) {
      data[, usr_cname[3]] <- factor(data[, usr_cname[3]],
        level = data[
          !duplicated(data[, usr_cname[3]]),
          usr_cname[3]
        ]
      )
    }
    p <- ggboxplot(
      data,
      x = usr_cname[2],
      y = usr_cname[1],
      notch = conf$extra$notch,
      facet.by = usr_cname[3],
      add = add_point,
      color = usr_cname[2],
      xlab = usr_cname[3],
      ylab = usr_cname[1],
      palette = get_hiplot_color(conf$general$palette, -1,
        conf$general$paletteCustom),
      title = conf$general$title
    )
    theme <- conf$general$theme
    p <- choose_ggplot_theme(p, theme)
    p <- p + theme(
        plot.title = element_text(
          hjust = 0.5,
          vjust = 0.5
        ),
        legend.position = conf$general$legendPos
      )
    if (pval != "none") {
      p <- p + stat_compare_means(
        comparisons = my_comparisons,
        label = pval, method = conf$extra$stat_method
      )
    }
  }

  p <- set_complex_general_theme(p)
  p <- p + scale_y_continuous(expand = expansion(mult = c(0.1, 0.1)))
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}
