#######################################################
# Parallel coordinate plot.                           #
#-----------------------------------------------------#
# Author: < Mingjie Wang > from < Ke Yan Mao >        #
# Affiliation: Shanghai Hiplot Team                   #
# Email: customer_service1501@tengyunbio.com          #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2020-10-07                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2020 by Hiplot Team                   #
# All rights reserved.                                #
#######################################################

pkgs <- c("GGally", "hrbrthemes", "viridis")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  ## check data
  # get colnames of data
  usr_cname <- colnames(data)

  # check data columns
  if (ncol(data) >= 3) {
    # nothing
  } else {
    print("Error: Input data should be at least 3 columns!")
  }
}

############# Section 2 #############
#           plot section
#####################################
{
  # check scale method
  scale.method <- conf$extra$scale
  if (conf$extra$scale %in% c(
    "std", "robust", "uniminmax",
    "globalminmax", "center", "centerObs"
  )) {
    # nothing
  } else {
    print("Error scale method selected. Using \'globalminmax\' as default.")
    scale.method <- "globalminmax"
  }
  if (!is.numeric(data[, ncol(data)])) {
    data[, ncol(data)] <- factor(data[, ncol(data)],
      levels = unique(data[, ncol(data)]))
  }
  p <- ggparcoord(data,
    columns = 2:(ncol(data) - 1), groupColumn = ncol(data),
    title = conf$general$title,
    alphaLines = conf$general$alpha,
    scale = scale.method,
    showPoints = as.logical(conf$extra$show_points),
    boxplot = as.logical(conf$extra$box)
  ) +
    theme_ipsum() +
    scale_color_viridis(discrete = TRUE) +
    theme(plot.title = element_text(size = 10))

  # show with facet
  if (conf$extra$facet) {
    p <- p + facet_grid(formula(paste("~", (colnames(data)[ncol(data)]))))
  }

  ## add color palette
  if (conf$general$palette != "default") {
    p <- p + return_hiplot_palette_color(conf$general$palette,
    conf$general$paletteCustom)
  }

  # change theme
  p <- set_complex_general_theme(set_palette_theme(p, conf))
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}
