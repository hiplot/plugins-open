#此R脚本主要完成两个任务：
#1. 创建一个热图与饼图组合的可视化函数，允许用户自定义数据矩阵的维度、角度缩放因子、填充色方案等参数。
#2. 创建一个3D热图的可视化函数，允许用户自定义数据矩阵的维度、瓦片大小、填充色选项、颜色刻度分割数等参数。
#两个函数均支持用户传入自定义数据

library(ggalign)
library(viridis)
library(scales)

# 1. 热图+饼图组合可视化函数
plot_heatmap_pie <- function(data = NULL,
                             nrow = 20L,
                             ncol = 18L,  # 默认20*18=360，与示例数据维度匹配
                             angle_scale = 360,  # 角度缩放因子（value*angle_scale）
                             fill_palette = "viridis",  # 填充色方案
                             ggheatmap_filling = NULL,  # ggheatmap的filling参数
                             ...) {
  # 设置随机种子确保可复现性
  set.seed(123)
  
  # 处理数据：用户未提供则生成随机数据
  if (is.null(data)) {
    data <- matrix(
      runif(nrow * ncol),  # 与示例一致使用runif生成[0,1)随机数
      nrow = nrow,
      ncol = ncol,
      dimnames = list(
        paste0("row", 1:nrow),
        paste0("col", 1:ncol)
      )
    )
    message("使用随机生成的数据矩阵（饼图热图），维度: ", nrow, "x", ncol)
  } else {
    # 数据校验：必须为矩阵
    if (!is.matrix(data)) {
      stop("输入数据必须为矩阵格式（饼图热图）")
    }
    message("使用用户提供的数据矩阵（饼图热图），维度: ", nrow(data), "x", ncol(data))
  }
  
  # 构建可视化
  p <- ggheatmap(data, filling = ggheatmap_filling) +
    # 饼图几何对象（角度和填充映射）
    geom_pie(aes(angle = value * angle_scale, fill = value))
  
  # 配置填充色比例尺
  if (fill_palette == "viridis") {
    p <- p + scale_fill_viridis_c()
  } else if (fill_palette %in% rownames(brewer.pal.info)) {
    p <- p + scale_fill_distiller(palette = fill_palette)
  } else {
    warning("未知的填充色方案，使用默认viridis")
    p <- p + scale_fill_viridis_c()
  }
  
  return(p)
}


# 2. 3D热图可视化函数
plot_3d_heatmap <- function(data = NULL,
                            nrow = 9L,
                            ncol = 9L,  # 默认9*9=81，与示例数据维度匹配
                            tile_width = 0.8,
                            tile_height = 0.8,
                            fill_option = "plasma",  # viridis色板选项
                            fill_breaks = 3L,  # 颜色刻度分割数
                            ggheatmap_filling = FALSE,  # ggheatmap的filling参数
                            legend_spacing = 10,  # 图例间距（mm）
                            plot_margin_top = 15,  # 顶部边距（mm）
                            clip = "off",  # 坐标裁剪模式
                            ...) {
  # 设置随机种子确保可复现性
  set.seed(123)
  
  # 处理数据：用户未提供则生成随机数据
  if (is.null(data)) {
    data <- matrix(
      rnorm(nrow * ncol),  # 与示例一致使用rnorm生成正态分布数据
      nrow = nrow,
      ncol = ncol,
      dimnames = list(
        paste0("row", 1:nrow),
        paste0("col", 1:ncol)
      )
    )
    message("使用随机生成的数据矩阵（3D热图），维度: ", nrow, "x", ncol)
  } else {
    # 数据校验：必须为矩阵
    if (!is.matrix(data)) {
      stop("输入数据必须为矩阵格式（3D热图）")
    }
    message("使用用户提供的数据矩阵（3D热图），维度: ", nrow(data), "x", ncol(data))
  }
  
  # 构建可视化
  p <- ggheatmap(
    data,
    filling = ggheatmap_filling,
    theme = theme(
      legend.box.spacing = unit(legend_spacing, "mm"),
      plot.margin = margin(t = plot_margin_top, unit = "mm")
    )
  ) +
    # 3D瓦片几何对象
    geom_tile3d(
      aes(fill = value, z = value, width = tile_width, height = tile_height),
      color = "black"
    ) +
    # 配置填充色比例尺
    scale_fill_viridis_c(
      option = fill_option,
      breaks = breaks_pretty(fill_breaks)
    ) +
    coord_cartesian(clip = clip)
  
  return(p)
}


# 示例用法
if (FALSE) {
  # 1. 热图+饼图示例
  # 默认参数
  p1 <- plot_heatmap_pie()
  print(p1)
  
  # 自定义参数
  p1_custom <- plot_heatmap_pie(
    nrow = 15,
    ncol = 10,
    angle_scale = 180,  # 角度缩放减半
    fill_palette = "YlOrRd"  # 使用brewer色板
  )
  print(p1_custom)
  
  # 使用自有数据
  my_mat_pie <- matrix(runif(200), nrow = 20, ncol = 10)
  p1_user <- plot_heatmap_pie(data = my_mat_pie)
  print(p1_user)
  
  # 2. 3D热图示例
  # 默认参数
  p2 <- plot_3d_heatmap()
  print(p2)
  
  # 自定义参数
  p2_custom <- plot_3d_heatmap(
    nrow = 12,
    ncol = 12,
    tile_width = 0.9,
    tile_height = 0.9,
    fill_option = "magma",  # 切换viridis色板
    fill_breaks = 5L,  # 更多刻度分割
    plot_margin_top = 20  # 增加顶部边距
  )
  print(p2_custom)
  
  # 使用自有数据
  my_mat_3d <- matrix(rnorm(144), nrow = 12, ncol = 12)
  p2_user <- plot_3d_heatmap(data = my_mat_3d)
  print(p2_user)
}
