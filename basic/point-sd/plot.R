#######################################################
# Point-SD.                                           #
#-----------------------------------------------------#
# Author: Jianfeng Li                                 #
# Email: lee_jianfeng@openbiox.org                    #
#                                                     #
# Date: 2022-04-01                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2022 by Openbiox                      #
# All rights reserved.                                #
#######################################################

pkgs <- c("grafify")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  y <- unlist(conf$dataArg[[1]][[1]]$value)
  group <- unlist(conf$dataArg[[1]][[2]]$value)
  facet <- unlist(conf$dataArg[[1]][[3]]$value)
  # check data columns
  if (group != "") {
    data[, group] <- factor(data[, group], levels = unique(data[, group]))
  }
  if (facet != "") {
    data[, facet] <- factor(data[, facet], levels = unique(data[, facet]))
      data <- eval(parse(text = sprintf("data %%>%% group_by(%s) %%>%%
    mutate(median = median(get(y), na.rm = TRUE),
    mean = mean(get(y), na.rm = TRUE))", facet)))
  } else {
    data <- data %>% 
      mutate(median = median(get(y), na.rm = TRUE),
      mean = mean(get(y), na.rm = TRUE))
  }
  data[,y] <- transform_val(conf$general$transformY, data[,y])
  if (conf$extra$yintercept == "mean") {
    yintercept <- "mean"
  } else if (conf$extra$yintercept == "median") {
    yintercept <- "median"
  } else {
    data$yline <- as.numeric(conf$extra$yintercept)
    yintercept <- "yline"
  }
}

############# Section 2 #############
#           plot section
#####################################
{
  p <- plot_point_sd(data = data,
    get(group), get(y),
    symsize = conf$extra$point_size,
    symthick = conf$extra$point_thick,
    s_alpha = conf$general$alpha,
    ewid = 0)
  
  p <- p + ggtitle(conf$general$title)
  if (facet != "") {
    p <- p + facet_wrap(facet) +
      geom_hline(aes_string(yintercept = yintercept, group = facet),
        colour = 'black', linetype = 2, size = 0.5)
  } else {
    p <- p + geom_hline(aes_string(yintercept = yintercept),
        colour = 'black', linetype = 2, size = 0.5)
  }
  p <- p + xlab(group) + ylab(y) + 
    guides(fill = guide_legend(title = group))
  ## add color palette
  p <- p + return_hiplot_palette_color(conf$general$palette,
      conf$general$paletteCustom) +
    return_hiplot_palette(conf$general$palette,
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

