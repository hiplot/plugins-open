#######################################################
# Violin plot.                                        #
#-----------------------------------------------------#
# Author: benben-miao                                 #
#                                                     #
# Email: benben.miao@outlook.com                      #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2020-08-17                                    #
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
}

############# Section 2 #############
#           plot section
#####################################
{
  if (!is.numeric(data[, 3])) {
    data[, 3] <- factor(data[, 3], levels = unique(data[, 3]))
  }
  groups <- unique(data[, 2])
  ngroups <- length(groups)
  p <- ggviolin(data,
    x = colnames(data)[2],
    y = colnames(data)[1],
    color = colnames(data)[3],
    add = conf$extra$add_geom,
    add.params = list(
      fill = "white",
      size = 1
    ),
    title = conf$general$title,
    xlab = colnames(data)[2],
    ylab = colnames(data)[1],
    fill = colnames(data)[3],
    palette = get_hiplot_color(conf$general$palette, -1,
      conf$general$paletteCustom),
    alpha = alpha_usr,
    trim = F
  )

  if (conf$extra$stat_method != "none") {
    p <- p + stat_compare_means(aes(group = data[, colnames(data)[3]]),
      method = conf$extra$stat_method,
      # label = "p.val",
      vjust = conf$extra$stat_pos,
      label.x.npc = "left",
      label.y.npc = "top",
      tip.length = 0.03,
      bracket.size = 0.3,
      step.increase = 0,
      position = "identity",
      na.rm = FALSE,
      show.legend = NA,
      inherit.aes = TRUE,
      geom = "text"
    )
  }

  theme2 <- conf$general$theme
  p <- choose_ggplot_theme(p, theme2)
  p <- set_complex_general_theme(p)
  # change theme
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}

