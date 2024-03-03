#######################################################
# Radar plot.                                         #
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

pkgs <- c("ggradar", "scales", "tibble", "dplyr", "ggplot2")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  data <- as.data.frame(t(data))
  colnames(data) <- data[1, ]
  data <- data[-1, ]
  for (i in seq_len(ncol(data))) {
    data[, i] <- as.numeric(data[, i])
  }
  if (is.null(conf$extra$rescale)) conf$extra$rescale <- TRUE
  data_radar <- data %>%
    rownames_to_column(var = "sample")
  if (conf$extra$rescale){
    data_radar <- data_radar %>% mutate_at(vars(-sample), rescale)
  } else {
    data_radar <- data_radar %>% mutate_at(vars(-sample), function(x) {x})
  }
}

############# Section 2 #############
#           plot section
#####################################
{
  params <- list(data_radar,
    gridline.max.linetype = 1,
    group.point.size = 4,
    group.line.width = 1,
    font.radar = conf$general$font,
    fill.alpha = conf$general$alpha)
  for (i in names(conf$extra)) {
    if (i == "rescale") next
    params[[i]] <- conf$extra[[i]]
  }
  if (!conf$extra$rescale) {
    x <- as.numeric(as.matrix(data[,-1]))
    params$values.radar <- c(min(x, na.rm = TRUE),
      mean(x, na.rm = TRUE), max(x, na.rm = TRUE))
    params$grid.min <- params$values.radar[1]
    params$grid.mid <- params$values.radar[2]
    params$grid.max <- params$values.radar[3]
  }
  p <- do.call(ggradar, params) +
    ggtitle(conf$general$title)

  ## add color palette
  p <- p + return_hiplot_palette_color(conf$general$palette,
      conf$general$paletteCustom) +
    return_hiplot_palette(conf$general$palette,
      conf$general$paletteCustom)

  theme <- conf$general$theme
  p <- choose_ggplot_theme(p, theme)
  p <- set_complex_general_theme(p)

  if (theme == "default") {
    p <- p +
    theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.title.y=element_blank(),
        axis.ticks.y=element_blank())
  }
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}

