#######################################################
# HiC heatmap.                                        #
#-----------------------------------------------------#
# Author: < Wei Dong >                                #
# Email: dongw26@mail2.sysu.edu.cn                    #
# Website: http://bioinfomics.top/                    #
#                                                     #
# Date: 2020-09-28                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2020 by Hiplot Team                   #
# All rights reserved.                                #
#######################################################

pkgs <- c("ggplot2")
pacman::p_load(pkgs, character.only = TRUE)
############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  # check data columns
  if (ncol(data) == 3) {
    # nothing
  } else {
    stop("Error: Input data should be 3 columns!")
  }

  # rename data colnames
  colnames(data) <- c("index_bin1", "index_bin2", "freq")

  # set the color palettes
  # The diverging palettes are: BrBG PiYG PRGn PuOr RdBu RdGy RdYlBu RdYlGn Spectral
  colors <- get_hiplot_color(conf$general$paletteCont, -1, conf$general$paletteCustom)

  # set the plot title
  title <- conf$general$title
  # set the plot theme
  plot_theme <- conf$general$theme
  # set the legend position
  legend_pos <- conf$general$legendPos
}

############# Section 2 #############
#           plot section
#####################################
{
  # 计算bins的个数
  bins_num <- max(data$index_bin1) + 1

  # 设置HiC数据的resolution
  res <- conf$extra$resolution * 1000

  # 设置分隔单位,以50Mb为单位进行分隔
  intervals <- conf$extra$interval
  spacing <- intervals * 1000000

  # 计算breaks的数目
  breaks_num <- (res * bins_num) / spacing

  # 设置breaks
  breaks <- c()
  for (i in 0:breaks_num) {
    breaks <- c(breaks, i * intervals)
  }

  # 绘制HiC互作热图
  p <- ggplot(data = data, aes(x = index_bin1 * res, y = index_bin2 * res)) +
    geom_tile(aes(fill = freq))
  p <- choose_ggplot_theme(p, plot_theme)

  p <- p +
    scale_fill_gradientn(colours = colors,
    limits = c(0, max(data$freq) * 1.2)) +
    scale_y_reverse() +
    scale_x_continuous(
      breaks = breaks * 1000000,
      labels = paste0(breaks, "Mb")
    ) +
    scale_y_continuous(
      breaks = breaks * 1000000,
      labels = paste0(breaks, "Mb")
    ) +
    theme(panel.grid = element_blank(), axis.title = element_blank()) +
    labs(title = paste0(title, " (resolution: ", res / 1000, "Kb)")) +
    theme(
      plot.title = element_text(hjust = 0.5),
      legend.position = legend_pos,
      legend.key.size = unit(0.8, "cm")
    )
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}
