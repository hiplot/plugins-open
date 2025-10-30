library(ggalign)
library(viridis)
library(RColorBrewer)

plot_enhanced_heatmap <- function(data = NULL,
                                  # 数据生成参数
                                  nr1 = 4, nr2 = 8, nr3 = 6,
                                  nc1 = 6, nc2 = 8, nc3 = 10,
                                  mean_values = c(1, 0, 0.5),
                                  sd_value = 0.5,
                                  # 增强功能参数
                                  group_labels = NULL,
                                  kmeans_centers = NULL,
                                  order_func = NULL,  # 行排序函数（与树状图排序可能冲突）
                                  add_dendro = FALSE,  # 顶部树状图
                                  dendro_k = 3,
                                  dendro_color_palette = "Dark2",
                                  annotate_top = FALSE,
                                  annotate_left = FALSE,
                                  annotate_right = FALSE,  # 右侧树状图（可能与order_func冲突）
                                  annotate_size = unit(1, "cm"),
                                  # 样式参数
                                  tile_linewidth = 0.3,  # 替换size为linewidth（兼容ggplot2）
                                  fill_palette = "viridis",
                                  ...) {
  set.seed(123)
  
  # 1. 数据处理
  if (is.null(data)) {
    nr <- nr1 + nr2 + nr3
    nc <- nc1 + nc2 + nc3
    mat <- cbind(
      rbind(
        matrix(rnorm(nr1 * nc1, mean = mean_values[1], sd = sd_value), nrow = nr1),
        matrix(rnorm(nr2 * nc1, mean = mean_values[2], sd = sd_value), nrow = nr2),
        matrix(rnorm(nr3 * nc1, mean = mean_values[2], sd = sd_value), nrow = nr3)
      ),
      rbind(
        matrix(rnorm(nr1 * nc2, mean = mean_values[2], sd = sd_value), nrow = nr1),
        matrix(rnorm(nr2 * nc2, mean = mean_values[1], sd = sd_value), nrow = nr2),
        matrix(rnorm(nr3 * nc2, mean = mean_values[2], sd = sd_value), nrow = nr3)
      ),
      rbind(
        matrix(rnorm(nr1 * nc3, mean = mean_values[3], sd = sd_value), nrow = nr1),
        matrix(rnorm(nr2 * nc3, mean = mean_values[3], sd = sd_value), nrow = nr2),
        matrix(rnorm(nr3 * nc3, mean = mean_values[1], sd = sd_value), nrow = nr3)
      )
    )
    mat <- mat[sample(nr, nr), sample(nc, nc)]
    rownames(mat) <- paste0("row", seq_len(nr))
    colnames(mat) <- paste0("column", seq_len(nc))
    data <- mat
    message("使用默认生成数据，维度: ", nrow(data), "x", ncol(data))
  } else {
    if (!is.matrix(data)) stop("输入数据必须为矩阵格式")
    message("使用用户提供数据，维度: ", nrow(data), "x", ncol(data))
  }
  
  # 检查排序冲突：右侧树状图与行排序函数不能同时使用
  if (annotate_right && !is.null(order_func)) {
    warning("右侧树状图(annotate_right)与行排序函数(order_func)可能冲突，将优先使用树状图排序")
    order_func <- NULL  # 禁用行排序函数，避免索引冲突
  }
  
  # 2. 初始化基础热图（明确主图层）
  p <- ggheatmap(data) +
    # 主热图颜色比例尺（绑定到主图层）
    {if (fill_palette == "viridis") scale_fill_viridis_c() else 
      scale_fill_distiller(palette = fill_palette)}
  
  # 3. 模块化添加增强功能
  # 3.1 样本分组（顶部注释）
  if (!is.null(group_labels)) {
    if (length(group_labels) != ncol(data)) {
      stop("group_labels长度必须与数据列数一致（", ncol(data), "）")
    }
    p <- p + anno_top(size = annotate_size) + align_group(group_labels)
  }
  
  # 3.2 k-means聚类（顶部注释）
  if (!is.null(kmeans_centers) && kmeans_centers > 0) {
    p <- p + anno_top(size = annotate_size) + align_kmeans(centers = kmeans_centers)
    if (annotate_top) {
      p <- p + ggalign(data = NULL) +  # 明确作用于顶部注释层
        geom_tile(aes(y = 1L, fill = .panel, color = .panel), linewidth = tile_linewidth) +
        theme_no_axes("y") +
        scale_fill_brewer(palette = dendro_color_palette, guide = "none") +
        scale_color_brewer(palette = dendro_color_palette, guide = "none")
    }
  }
  
  # 3.3 行排序（左侧注释）
  if (!is.null(order_func)) {
    if (!is.function(order_func)) stop("order_func必须为函数（如rowMeans）")
    p <- p + anno_left(size = annotate_size) + align_order(order_func)
  }
  
  # 3.4 顶部树状图（与k-means/分组不冲突，因为作用于不同维度）
  if (add_dendro) {
    p <- p + anno_top(size = annotate_size) + 
      align_dendro(aes(color = branch), k = dendro_k) +
      geom_point(aes(color = branch, y = y), linewidth = 1.5) +  # 用linewidth替换size
      scale_color_brewer(palette = dendro_color_palette)
  }
  
  # 3.5 右侧树状图（单独排序，不与行排序函数同时使用）
  if (annotate_right) {
    p <- p + anno_right(size = annotate_size) + 
      align_dendro(along = "row")  # 明确沿行排序，避免与其他维度冲突
  }
  
  # 3.6 左侧注释（条形图，依赖行排序）
  if (annotate_left && !is.null(order_func) && identical(order_func, rowSums)) {
    p <- p + anno_left(size = annotate_size) + 
      ggalign(rowSums) +  # 明确作用于左侧注释层
      geom_bar(aes(x = value, y = .y, fill = value),
               orientation = "y", stat = "identity", color = "black", linewidth = tile_linewidth) +
      scale_fill_viridis_c(option = "A")
  }
  
  return(p)
}


# 示例用法（修正后无冲突）
if (TRUE) {
  # 1. 基础热图
  p_basic <- plot_enhanced_heatmap()
  print(p_basic)
  
  # 2. 按样本组分组热图
  set.seed(123)
  group_labels <- sample(letters[1:4], ncol(plot_enhanced_heatmap()$data), replace = TRUE)
  p_group <- plot_enhanced_heatmap(group_labels = group_labels)
  print(p_group)
  
  # 3. k-means聚类热图
  p_kmeans <- plot_enhanced_heatmap(kmeans_centers = 3, annotate_top = TRUE)
  print(p_kmeans)
  
  # 4. 带顶部树状图的热图
  p_dendro <- plot_enhanced_heatmap(add_dendro = TRUE, dendro_k = 3)
  print(p_dendro)
  
  # 5. 右侧树状图热图（不使用行排序函数）
  p_right_dendro <- plot_enhanced_heatmap(annotate_right = TRUE)
  print(p_right_dendro)
  
  # 6. 左侧行和注释热图（使用行排序，不启用右侧树状图）
  p_left_anno <- plot_enhanced_heatmap(
    order_func = rowSums,
    annotate_left = TRUE,
    annotate_size = 0.3
  )
  print(p_left_anno)
}
