#######################################################
# Waterfall Charts                                    #
#-----------------------------------------------------#
# Author: < Wei Dong >                                #
# Email: dongw26@mail2.sysu.edu.cn                    #
# Website: http://bioinfomics.top/                    #
#                                                     #
# Date: 2020-10-29                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2020 by Hiplot Team                   #
# All rights reserved.                                #
#######################################################

# load required packages
pkgs <- c("waterfalls", "ggplot2")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  # check data columns
  if (ncol(data) == 2) {
    # nothing
  } else {
    stop("Error: Input data should be 2 columns!")
  }

  # rename data colnames
  raw_colnames <- colnames(data)
  colnames(data) <- c("label", "value")

  # set the color palettes
  # The qualitative palettes are: 
  # Accent, Dark2, Paired, Pastel1, Pastel2, Set1, Set2, Set3
  pal <- conf$general$palette
  colors <- get_hiplot_color(pal, nrow(data) + 1,
        conf$general$paletteCustom)

  # set the plot title
  title <- conf$general$title
}

############# Section 2 #############
#           plot section
#####################################
{
  # 设置是否计算总数(TRUE or FALSE)
  totals <- conf$extra$calc_total

  # 设置标签字体大小(1-5)
  sizes <- conf$extra$rect_text_size

  # 设置条形的宽度大小(0-1)
  widths <- conf$extra$rect_width

  # 设置连接线的类型(1-6)
  ltys <- conf$extra$linetype

  # 设置正负值是否显示同样的颜色(TRUE or FALSE)
  signs <- conf$extra$fill_by_sign

  # 绘制瀑布图
  p <- waterfall(data,
    rect_text_labels = data$value,
    rect_text_size = sizes,
    rect_text_labels_anchor = "centre",
    calc_total = totals,
    total_axis_text = "Total",
    total_rect_text = sum(data$value),
    total_rect_color = "steelblue",
    total_rect_text_color = "black",
    rect_width = widths,
    rect_border = "black",
    draw_lines = TRUE,
    linetype = ltys,
    fill_by_sign = signs,
    fill_colours = colors,
    scale_y_to_waterfall = T
  )
  # 添加主题设置
  p <- p + theme(
    axis.text = element_text(size = 12),
    plot.title = element_text(hjust = 0.5)
  ) +
    labs(x = raw_colnames[1], y = raw_colnames[2], title = title)

  ## select themes
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
