# 辅助函数：检查并提示安装依赖包
check_dependency <- function(pkg_name) {
  if (!requireNamespace(pkg_name, quietly = TRUE)) {
    stop(
      sprintf("需要安装包「%s」以运行此函数，请执行：\ninstall.packages('%s')", 
              pkg_name, pkg_name), 
      call. = FALSE
    )
  }
}

# 提前检查核心依赖
check_dependency("ggalign")
check_dependency("scales")

plot_marginal_basic <- function(data = mpg,
                                x = "displ",
                                y = "hwy",
                                colour = "class",
                                anno_size_top = 0.3,
                                anno_size_right = 0.3,
                                point_size = 2,
                                density_stack = TRUE,
                                base_theme = theme_bw(),
                                color_palette = NULL) {
  # 1. 检查变量是否存在于数据中
  required_vars <- c(x, y, colour)
  missing_vars <- setdiff(required_vars, colnames(data))
  if (length(missing_vars) > 0) {
    stop(sprintf("数据中缺少变量：%s", paste(missing_vars, collapse = ", ")), call. = FALSE)
  }
  
  # 2. 初始化基础图层
  p <- ggside(data, aes(.data[[x]], .data[[y]], colour = .data[[colour]])) +
    scheme_theme(base_theme) +
    layout_theme(panel.border = element_blank()) +
    geom_point(size = point_size)
  
  # 3. 添加顶部边际密度图
  p <- p +
    anno_top(size = anno_size_top) +
    ggalign() +  # 明确绑定顶部注释层
    geom_density(
      aes(.data[[x]], y = after_stat(density), colour = .data[[colour]]),
      position = if (density_stack) "stack" else "identity"
    )
  
  # 4. 添加右侧边际密度图
  p <- p +
    anno_right(size = anno_size_right) +
    ggalign() +  # 明确绑定右侧注释层
    geom_density(
      aes(x = after_stat(density), .data[[y]], colour = .data[[colour]]),
      position = if (density_stack) "stack" else "identity"
    )
  
  # 5. 自定义颜色方案（可选）
  if (!is.null(color_palette)) {
    if (color_palette %in% rownames(brewer.pal.info)) {
      p <- p + scale_color_brewer(palette = color_palette)
    } else {
      warning(sprintf("未知色板「%s」，使用默认颜色", color_palette))
    }
  }
  
  return(p)
}

# 示例用法
# p_basic <- plot_marginal_basic()
# print(p_basic)

plot_marginal_faceted <- function(data = NULL,
                                  x = "Sepal.Width",
                                  y = "Sepal.Length",
                                  colour = "Species",
                                  facet_rows = "Species",
                                  facet_cols = "Group",
                                  anno_size_top = 0.3,
                                  anno_size_right = 0.3,
                                  point_size = 2,
                                  base_theme = theme_bw(),
                                  color_palette = "Dark2",
                                  breaks_num = 3L) {
  # 1. 检查依赖包
  check_dependency("RColorBrewer")
  
  # 2. 处理默认数据（复刻原始iris+Group列）
  if (is.null(data)) {
    data <- iris
    data$Group <- rep(c("Group1", "Group2"), 75)
    message("使用默认数据（iris + Group列）")
  }
  
  # 3. 检查变量是否存在
  required_vars <- c(x, y, colour, facet_rows, facet_cols)
  missing_vars <- setdiff(required_vars, colnames(data))
  if (length(missing_vars) > 0) {
    stop(sprintf("数据中缺少变量：%s", paste(missing_vars, collapse = ", ")), call. = FALSE)
  }
  
  # 4. 初始化基础分面散点图
  p <- ggside(data, aes(.data[[x]], .data[[y]], colour = .data[[colour]])) +
    geom_point(size = point_size) +
    # 主图分面
    facet_grid(as.formula(sprintf("%s ~ %s", facet_rows, facet_cols))) +
    theme(
      strip.background = element_blank(),
      strip.text = element_blank()
    )
  
  # 5. 顶部边际密度（按列分面）
  p <- p +
    anno_top(size = anno_size_top) +
    ggalign() +
    geom_density(
      aes(.data[[x]], y = after_stat(density), colour = .data[[colour]]),
      position = "stack"
    ) +
    facet_grid(cols = vars(.data[[facet_cols]])) +
    theme(
      strip.text = element_text(margin = margin(5, 5, 5, 5)),
      strip.background = element_rect(fill = "grey")
    )
  
  # 6. 右侧边际密度（按行分面）
  p <- p +
    anno_right(size = anno_size_right) +
    ggalign() +
    geom_density(
      aes(x = after_stat(density), .data[[y]], colour = .data[[colour]]),
      position = "stack"
    ) +
    facet_grid(rows = vars(.data[[facet_rows]])) +
    theme(
      strip.text = element_text(margin = margin(5, 5, 5, 5)),
      strip.background = element_rect(fill = "grey")
    )
  
  # 7. 全局样式（主题+颜色+刻度）
  p <- p -
    quad_scope(scheme_theme(base_theme), "tri") &
    scale_color_brewer(palette = color_palette, guide = "none") &
    scale_x_continuous(breaks = scales::pretty_breaks(breaks_num)) &
    scale_y_continuous(breaks = scales::pretty_breaks(breaks_num)) &
    theme(
      axis.text = element_text(),
      axis.title = element_text(face = "bold")
    )
  
  return(p)
}

# 示例用法
# p_faceted <- plot_marginal_faceted()
# print(p_faceted)

plot_ggpubr_density <- function(data = iris,
                                x = "Sepal.Length",
                                y = "Sepal.Width",
                                colour = "Species",
                                fill = "Species",
                                anno_size_top = 0.2,
                                anno_size_right = 0.2,
                                point_size = 3,
                                point_alpha = 0.6,
                                density_alpha = 0.6,
                                base_theme = theme_classic(),
                                use_ggsci_jco = TRUE) {
  # 1. 检查依赖包
  check_dependency("ggsci")
  
  # 2. 检查变量
  required_vars <- c(x, y, colour, fill)
  missing_vars <- setdiff(required_vars, colnames(data))
  if (length(missing_vars) > 0) {
    stop(sprintf("数据中缺少变量：%s", paste(missing_vars, collapse = ", ")), call. = FALSE)
  }
  
  # 3. 初始化基础散点图
  p <- ggside(data, aes(.data[[x]], .data[[y]], colour = .data[[colour]])) +
    geom_point(size = point_size, alpha = point_alpha) +
    theme(base_theme)
  
  # 4. 顶部边际密度（带填充）
  p <- p +
    anno_top(size = anno_size_top) +
    ggalign() +
    geom_density(
      aes(.data[[x]], fill = .data[[fill]]),
      alpha = density_alpha,
      colour = NA  # 隐藏密度图边框，避免与散点颜色冲突
    ) +
    theme_no_axes()
  
  # 5. 右侧边际密度（带填充）
  p <- p +
    anno_right(size = anno_size_right) +
    ggalign() +
    geom_density(
      aes(y = .data[[y]], fill = .data[[fill]]),
      alpha = density_alpha,
      colour = NA
    ) +
    theme_no_axes()
  
  # 6. 应用GGpubr风格颜色（ggsci::jco）
  if (use_ggsci_jco) {
    p <- p +
      ggsci::scale_color_jco() +
      ggsci::scale_fill_jco() +
      theme(legend.position = "none")  # 隐藏图例（原始案例风格）
  }
  
  return(p)
}

# 示例用法
# p_ggpubr_dens <- plot_ggpubr_density(base_theme = theme_light())
# print(p_ggpubr_dens)

plot_ggpubr_boxplot <- function(data = iris,
                                x = "Sepal.Length",
                                y = "Sepal.Width",
                                colour = "Species",
                                anno_size_top = 0.2,
                                anno_size_right = 0.2,
                                point_size = 3,
                                point_alpha = 0.6,
                                boxplot_fill = "grey",
                                base_theme = theme_classic()) {
  # 1. 检查依赖包
  check_dependency("ggsci")
  
  # 2. 检查变量
  required_vars <- c(x, y, colour)
  missing_vars <- setdiff(required_vars, colnames(data))
  if (length(missing_vars) > 0) {
    stop(sprintf("数据中缺少变量：%s", paste(missing_vars, collapse = ", ")), call. = FALSE)
  }
  
  # 3. 初始化基础散点图
  p <- ggside(data, aes(.data[[x]], .data[[y]], colour = .data[[colour]])) +
    geom_point(size = point_size, alpha = point_alpha) +
    ggsci::scale_color_jco() +  # GGpubr经典jco色板
    theme(base_theme)
  
  # 4. 顶部边际箱线图
  p <- p +
    anno_top(size = anno_size_top) +
    ggalign() +
    geom_boxplot(
      aes(.data[[x]]),
      fill = boxplot_fill,
      colour = "black",  # 箱线图边框色
      linewidth = 0.5
    ) +
    theme_no_axes()
  
  # 5. 右侧边际箱线图
  p <- p +
    anno_right(size = anno_size_right) +
    ggalign() +
    geom_boxplot(
      aes(y = .data[[y]]),
      fill = boxplot_fill,
      colour = "black",
      linewidth = 0.5
    ) +
    theme_no_axes()
  
  return(p)
}

# 示例用法
# p_ggpubr_box <- plot_ggpubr_boxplot(boxplot_fill = "lightblue")
# print(p_ggpubr_box)

plot_ggpubr_smooth_cor <- function(data = iris,
                                   x = "Sepal.Length",
                                   y = "Sepal.Width",
                                   colour = "Species",
                                   fill = "Species",
                                   anno_size_top = 0.2,
                                   anno_size_right = 0.2,
                                   point_size = 3,
                                   point_alpha = 0.6,
                                   density_alpha = 0.6,
                                   smooth_method = "lm",
                                   smooth_formula = y ~ x,
                                   base_theme = theme_light()) {
  # 1. 检查依赖包
  check_dependency("ggsci")
  check_dependency("ggpubr")
  
  # 2. 检查变量
  required_vars <- c(x, y, colour, fill)
  missing_vars <- setdiff(required_vars, colnames(data))
  if (length(missing_vars) > 0) {
    stop(sprintf("数据中缺少变量：%s", paste(missing_vars, collapse = ", ")), call. = FALSE)
  }
  
  # 3. 初始化基础图层（散点+平滑线+相关性）
  p <- ggside(data, aes(.data[[x]], .data[[y]], colour = .data[[colour]])) +
    geom_point(size = point_size, alpha = point_alpha) +
    geom_smooth(method = smooth_method, formula = smooth_formula, linewidth = 0.8) +
    ggpubr::stat_cor(  # 添加相关性统计
      aes(label = after_stat(rr.label)),
      p.accuracy = 0.001,
      r.accuracy = 0.01
    ) +
    ggsci::scale_color_jco() +
    theme(base_theme)
  
  # 4. 顶部边际密度
  p <- p +
    anno_top(size = anno_size_top) +
    ggalign() +
    geom_density(
      aes(.data[[x]], fill = .data[[fill]]),
      alpha = density_alpha,
      colour = NA
    ) +
    theme_no_axes()
  
  # 5. 右侧边际密度
  p <- p +
    anno_right(size = anno_size_right) +
    ggalign() +
    geom_density(
      aes(y = .data[[y]], fill = .data[[fill]]),
      alpha = density_alpha,
      colour = NA
    ) +
    theme_no_axes()
  
  # 6. 全局样式
  p <- p +
    ggsci::scale_fill_jco() +
    theme(legend.position = "none")
  
  return(p)
}

# 示例用法
# p_ggpubr_cor <- plot_ggpubr_smooth_cor(smooth_method = "lm")
# print(p_ggpubr_cor)

