#######################################################
# Sankey plot.                                        #
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

pkgs <- c("ggalluvial", "ggplot2")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  # parse conf file
  # parse conf file
  value <- conf$dataArg[[1]][[1]]$value
  axis <- conf$dataArg[[1]][[2]]$value
  usr_axis <- c()
  for (i in seq_len(length(axis))) {
    usr_axis <- c(usr_axis, axis[i])
    assign(paste0("axis", i), axis[i])
  }
  index_axis <- match(usr_axis, colnames(data))
  index_value <- match(value, colnames(data))
  data1 <- data[, c(index_value, index_axis)]

  # define band color
  nlevels <- as.numeric(apply(data1[, -1], 2, function(data) {
    return(length(unique(data)))
  }))
  band_color <- unlist(sapply(nlevels, brewer_pal_update, "Set3"))

  # rename data
  data_rename <- data1
  colnames(data_rename) <- c(
    "value",
    paste("axis", seq_len(length(usr_axis)), sep = "")
  )

  # oder by input
  if (conf$extra$order_by_input) {
    data_rename <- as.data.frame(lapply(data_rename, function(x) if (is.numeric(x)) x else factor(x, levels = unique(x))))
  }
}

############# Section 2 #############
#           plot section
#####################################
{
  cmd <- sprintf(
    "p = ggplot(data_rename, aes(y = value, %s))",
    paste(sprintf(
      "axis%s = axis%s", seq_len(length(usr_axis)),
      seq_len(length(usr_axis))
    ), collapse = ", ")
  )
  eval(parse(text = cmd))
  
  if(conf$extra$flip == "hor"){
    p <- p + geom_alluvium(
      alpha = conf$general$alpha,
      aes(fill = data1[, colnames(data1) == conf$extra$ribbonColor]),
      width = 0, reverse = FALSE
    ) +
      scale_x_discrete(limits = usr_axis, expand = c(0.02, 0.1)) +
      ylab("") +
      scale_fill_discrete(name = conf$extra$ribbonColor) +
      coord_flip() +
      geom_stratum(
        alpha = conf$general$alpha,
        width = 1 / 8,
        reverse = FALSE,
        fill = band_color,
        color = "white"
      ) +
      geom_text(
        stat = "stratum",
        infer.label = TRUE,
        reverse = FALSE
      ) +
      ggtitle(conf$general$title) +
      guides(fill = guide_legend(title = conf$extra$ribbonColor))
  }else if(conf$extra$flip == "ver"){
    p <- p + geom_alluvium(
      alpha = conf$general$alpha,
      aes(fill = data1[, colnames(data1) == conf$extra$ribbonColor]),
      width = 0, reverse = FALSE
    ) +
      scale_x_discrete(limits = usr_axis, expand = c(0.02, 0.1)) +
      ylab("") +
      scale_fill_discrete(name = conf$extra$ribbonColor) +
      geom_stratum(
        alpha = conf$general$alpha,
        width = 1 / 8,
        reverse = FALSE,
        fill = band_color,
        color = "white"
      ) +
      geom_text(
        stat = "stratum",
        infer.label = TRUE,
        reverse = FALSE
      ) +
      ggtitle(conf$general$title) +
      guides(fill = guide_legend(title = conf$extra$ribbonColor))
  }

  ## add color palette
  p <- p + return_hiplot_palette_color(conf$general$palette,
      conf$general$paletteCustom) +
    return_hiplot_palette(conf$general$palette,
      conf$general$paletteCustom)

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

