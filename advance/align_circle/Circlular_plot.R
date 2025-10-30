library(ggalign)
library(viridis)
library(RColorBrewer)

plot_circular_heatmap <- function(data = NULL,
                                  nrow = 10,
                                  ncol = 10,
                                  inner_radius = 0.1,
                                  k = 3L,
                                  dendro_size = 0.5,
                                  dendro_palette = "Dark2",
                                  heatmap_fill_palette = "viridis",
                                  group_tile_size = 0.1,
                                  group_palette = "Dark2",
                                  ...) {
  # 设置随机种子，保证结果可复现
  set.seed(123)
  
  # 处理输入数据，如果没有提供则生成随机数据
  if (is.null(data)) {
    data <- matrix(
      rnorm(nrow * ncol, mean = 0, sd = 2),
      nrow = nrow,
      ncol = ncol,
      dimnames = list(paste0("G", 1:nrow), paste0("S", 1:ncol))
    )
    message("使用随机生成的数据矩阵，维度: ", nrow, "x", ncol)
  } else {
    # 验证输入数据是否为矩阵
    if (!is.matrix(data)) {
      stop("输入的数据必须是矩阵格式")
    }
    message("使用用户提供的数据矩阵，维度: ", nrow(data), "x", ncol(data))
  }
  
  # 创建环形热图
  p <- circle_discrete(data, radial = coord_radial(inner.radius = inner_radius)) +
    
    # 添加树状图
    align_dendro(aes(color = branch), k = k, size = dendro_size) +
    scale_color_brewer(palette = dendro_palette) +
    
    # 添加热图
    ggalign() +
    geom_tile(aes(y = .column_index, fill = value)) +
    {if (heatmap_fill_palette == "viridis") scale_fill_viridis_c() else 
      scale_fill_distiller(palette = heatmap_fill_palette)} +
    
    # 添加分组tile
    ggalign(NULL, size = group_tile_size) +
    geom_tile(aes(y = 1L, fill = .panel)) +
    scale_fill_brewer(palette = group_palette, guide = "none") &
    theme_no_axes("y")
  
  return(p)
}

# 示例用法：
# 1. 使用默认参数
p1 <- plot_circular_heatmap()
print(p1)

# 2. 自定义参数
p2 <- plot_circular_heatmap(
  nrow = 15,
  ncol = 15,
  inner_radius = 0.2,
  k = 4,
  dendro_size = 0.7,
  heatmap_fill_palette = "RdBu"
)
print(p2)

# 3. 使用自己的数据
# mat <- matrix(rnorm(225), 15, 15)
# p3 <- plot_circular_heatmap(data = mat, k = 5)
# print(p3)