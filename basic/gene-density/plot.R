#######################################################
# Gene density plot.                                  #
#-----------------------------------------------------#
# Author: < Wei Dong >                                #
# Email: dongw26@mail2.sysu.edu.cn                    #
# Website: http://bioinfomics.top/                    #
#                                                     #
# Date: 2020-10-06                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2020 by Hiplot Team                   #
# All rights reserved.                                #
#######################################################

# load required packages
pkgs <- c("circlize", "ComplexHeatmap", "gtrellis", "ggplotify", "RColorBrewer")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  # 检查染色体长度数据信息
  if (ncol(data) == 3) {
    # nothing
  } else {
    print("Error: Input data should be 3 columns!")
  }

  # rename data colnames
  colnames(data) <- c("chr", "start", "end")
  # 获得染色体的条数
  print(unique(data$chr))
  chrNum <- str_replace(unique(data$chr), "Chr|chr", "")

  # 设定因子，按照染色体顺序排列
  data$chr <- factor(data$chr, levels = paste0("Chr", chrNum))
  # 检查基因长度数据信息
  if (ncol(data2) == 3) {
    # nothing
  } else {
    stop("Error: Input data should be 3 columns!")
  }
  # 设置列名
  colnames(data2) <- c("chr", "start", "end")
  # 设置因子
  data2$chr <- factor(data2$chr, levels = paste0("Chr", chrNum))
  # set the color palettes
  # The diverging palettes are: BrBG PiYG PRGn PuOr RdBu RdGy RdYlBu RdYlGn Spectral
  palettes <- conf$general$paletteCont
}

############# Section 2 #############
#           plot section
#####################################
{
  # 设置窗口计算基因密度
  windows <- conf$extra$windows * 1000 # default:100kb window size
  gene_density <- genomicDensity(data2, window.size = windows)
  gene_density$chr <- factor(gene_density$chr,
    levels =  paste0("Chr", chrNum)
  )

  if (palettes != "custom") {
    palettes <- brewer.pal(6, palettes)
  } else {
    palettes <- custom_color_filter(conf$general$paletteCustom)
  }
  # 设置画板颜色
  col_fun <- colorRamp2(
    seq(0, max(gene_density[[4]]), length = 6),
    rev(palettes)
  )
  cm <- ColorMapping(col_fun = col_fun) # 做了一个数值装换，在图例上用到

  # 设置图例
  lgd <- color_mapping_legend(cm,
    plot = TRUE,
    title = "density", color_bar = "continuous"
  )
  # 绘制基因密度分布热图
  p <- as.ggplot(function() {
    gtrellis_layout(data,
      n_track = 2, ncol = 1, byrow = FALSE,
      track_axis = FALSE, add_name_track = FALSE,
      xpadding = c(0.1, 0), gap = unit(1, "mm"),
      track_height = unit.c(unit(1, "null"), unit(4, "mm")),
      track_ylim = c(0, max(gene_density[[4]]), 0, 1),
      border = FALSE, asist_ticks = FALSE, legend = lgd
    )
    # 添加基因面积图track
    add_lines_track(gene_density, gene_density[[4]],
      area = TRUE, gp = gpar(fill = "pink")
    )
    # 添加基因密度热图track
    add_heatmap_track(gene_density, gene_density[[4]], fill = col_fun)
    add_track(track = 2, clip = FALSE, panel_fun = function(gr) {
      chr <- get_cell_meta_data("name")
      if (chr == paste("Chr", length(chrNum), sep = "")) {
        grid.lines(get_cell_meta_data("xlim"), unit(c(0, 0), "npc"),
          default.units = "native"
        )
      }
      grid.text(chr, x = 0.01, y = 0.38, just = c("left", "bottom"))
    })
    circos.clear()
  })
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}

