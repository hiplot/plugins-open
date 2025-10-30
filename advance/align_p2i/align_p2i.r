library(ggalign)
library(ggplot2)
library(RColorBrewer)

# 辅助函数：检查依赖包
check_magick_deps <- function() {
  if (!requireNamespace("ggalign", quietly = TRUE)) {
    stop("需安装包「ggalign」以使用geom_magick，请执行：install.packages('ggalign')", call. = FALSE)
  }
}

# 核心工具函数：用图片替代点的可视化
plot_image_points <- function(data = NULL,
                              x_col = "x",        # x轴变量列名
                              y_col = "y",        # y轴变量列名
                              image_col = "image",# 图片路径/URL列名
                              fill_col = "fill",  # 填充色分组列名
                              alpha_col = "alpha",# 透明度变量列名
                              size = 12,          # 图片大小
                              show_legend = FALSE,# 是否显示图例
                              clip = "off",       # 坐标裁剪模式（"off"避免图片被截断）
                              fill_palette = "Set1",  # 填充色方案
                              n_points = 10,      # 生成默认数据时的点数量
                              default_image = "https://jeroenooms.github.io/images/frink.png",  # 默认图片URL
                              ...) {  # 传递给geom_magick的其他参数（如angle旋转等）
  # 1. 检查依赖
  check_magick_deps()
  
  # 2. 处理数据：生成默认数据或验证用户数据
  if (is.null(data)) {
    # 生成与原始代码一致的默认数据
    set.seed(123)
    data <- data.frame(
      x = rnorm(n_points),
      y = rnorm(n_points),
      image = default_image,
      fill = sample(c("A", "B", "C", "D"), n_points, replace = TRUE),
      alpha = rnorm(n_points, mean = 0.5, sd = 0.1)
    )
    # 确保alpha在0-1之间
    data$alpha <- pmax(pmin(data$alpha, 1), 0)
    message("使用默认生成数据，包含", n_points, "个点，图片URL：", default_image)
  } else {
    # 验证用户数据必须包含的列
    required_cols <- c(x_col, y_col, image_col, fill_col, alpha_col)
    missing_cols <- setdiff(required_cols, colnames(data))
    if (length(missing_cols) > 0) {
      stop(sprintf("数据中缺少必要列：%s", paste(missing_cols, collapse = ", ")), call. = FALSE)
    }
    # 验证alpha列范围（0-1）
    if (any(data[[alpha_col]] < 0 | data[[alpha_col]] > 1)) {
      warning("alpha列存在超出0-1的值，将自动截断至0-1范围", call. = FALSE)
      data[[alpha_col]] <- pmax(pmin(data[[alpha_col]], 1), 0)
    }
    message("使用用户提供数据，包含", nrow(data), "个点")
  }
  
  # 3. 构建可视化
  p <- ggplot(data, aes(
    x = .data[[x_col]], 
    y = .data[[y_col]]
  )) +
    # 添加图片点（映射图片、填充色、透明度）
    geom_magick(
      aes(
        image = .data[[image_col]],
        fill = .data[[fill_col]],
        alpha = .data[[alpha_col]]
      ),
      size = size,
      show.legend = show_legend,
      ...  # 传递额外参数（如angle=30旋转图片）
    ) +
    # 坐标设置（避免图片被裁剪）
    coord_cartesian(clip = clip)
  
  # 4. 设置填充色方案
  if (fill_palette %in% rownames(brewer.pal.info)) {
    p <- p + scale_fill_brewer(palette = fill_palette)
  } else {
    warning(sprintf("未知色板「%s」，使用默认颜色", fill_palette), call. = FALSE)
  }
  
  return(p)
}


# ------------------------------
# 示例用法：覆盖原始场景+扩展场景
# ------------------------------
# 1. 场景1：复现原始代码效果（默认参数）
p_default <- plot_image_points()
# print(p_default)

# 2. 场景2：自定义点数量和图片大小
p_custom_size <- plot_image_points(
  n_points = 15,  # 15个点
  size = 10,      # 图片缩小为10
  fill_palette = "Dark2"  # 切换色板
)
# print(p_custom_size)

# 3. 场景3：使用自定义数据（例如本地图片路径或其他URL）
# 准备自定义数据（示例：2个点，不同图片URL）
custom_data <- data.frame(
  x = c(1, 2),
  y = c(3, 4),
  image = c(
    "https://jeroenooms.github.io/images/frink.png",  # 原始图片
    "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1b/R_logo.svg/1200px-R_logo.svg.png"  # R logo
  ),
  fill = c("A", "B"),
  alpha = c(0.8, 0.6)
)
p_custom_data <- plot_image_points(
  data = custom_data,
  size = 15,  # 放大图片
  show_legend = TRUE  # 显示图例
)
# print(p_custom_data)

# 4. 场景4：旋转图片+调整坐标裁剪
p_rotated <- plot_image_points(
  angle = 45,  # 图片旋转45度（通过...传递给geom_magick）
  clip = "on",  # 开启裁剪（超出坐标范围的图片部分会被截断）
  size = 8
)
# print(p_rotated)