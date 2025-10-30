library(ggalign)
library(ggplot2)
library(grid)

# 辅助函数：检查依赖包是否安装
check_inset_deps <- function() {
  required_pkgs <- c("ggalign", "ggplot2", "grid")
  missing_pkgs <- Filter(function(pkg) !requireNamespace(pkg, quietly = TRUE), required_pkgs)
  
  if (length(missing_pkgs) > 0) {
    stop(
      sprintf("需安装以下包以运行函数：%s\n安装命令：install.packages(c('%s'))",
              paste(missing_pkgs, collapse = ", "),
              paste(missing_pkgs, collapse = "', '")
      ),
      call. = FALSE
    )
  }
}

# 核心工具函数：快速添加子图到主图
add_inset_plot <- function(main_plot,
                           inset_plot,
                           vp_x = 0.6,        # 子图x轴相对位置（0-1，主图左下角为(0,0)）
                           vp_y = 0.6,        # 子图y轴相对位置（0-1，主图右上角为(1,1)）
                           vp_just = c(0, 0), # 子图对齐方式（c(水平, 垂直)，如c(0,0)=左下对齐）
                           vp_width = 0.4,    # 子图相对宽度（0-1，相对于主图宽度）
                           vp_height = 0.4,   # 子图相对高度（0-1，相对于主图高度）
                           ...) {             # 额外传递给grid::viewport的参数（如clip、angle等）
  # 1. 检查依赖包
  check_inset_deps()
  
  # 2. 参数校验：确保主图/子图为ggplot对象
  if (!inherits(main_plot, "ggplot")) {
    stop("'main_plot'必须是ggplot对象（如ggplot(mtcars) + geom_point(...)）", call. = FALSE)
  }
  if (!inherits(inset_plot, "ggplot")) {
    stop("'inset_plot'必须是ggplot对象（如ggplot(mtcars) + geom_boxplot(...)）", call. = FALSE)
  }
  
  # 3. 参数校验：位置与大小参数需在合理范围
  if (vp_x < 0 || vp_x > 1) {
    warning("'vp_x'建议设为0-1（相对坐标），当前值：", vp_x, call. = FALSE)
  }
  if (vp_y < 0 || vp_y > 1) {
    warning("'vp_y'建议设为0-1（相对坐标），当前值：", vp_y, call. = FALSE)
  }
  if (vp_width <= 0 || vp_width > 1) {
    stop("'vp_width'必须设为0-1（相对宽度），当前值：", vp_width, call. = FALSE)
  }
  if (vp_height <= 0 || vp_height > 1) {
    stop("'vp_height'必须设为0-1（相对高度），当前值：", vp_height, call. = FALSE)
  }
  if (length(vp_just) != 2) {
    stop("'vp_just'必须是长度为2的向量（如c(0,0)、c('left','bottom')）", call. = FALSE)
  }
  
  # 4. 创建子图视口（viewport）
  inset_vp <- viewport(
    x = vp_x,
    y = vp_y,
    just = vp_just,
    width = vp_width,
    height = vp_height,
    ...  # 传递额外参数（如clip = "on"、angle = 0等）
  )
  
  # 5. 组合主图与子图
  combined_plot <- main_plot + inset(inset_plot, vp = inset_vp)
  
  return(combined_plot)
}


# ------------------------------
# 示例用法：覆盖原始场景+扩展场景
# ------------------------------
# 1. 场景1：复现原始代码（子图左下对齐，位于主图(0.6,0.6)位置，宽高0.4）
# 先创建主图和子图
main_scatter <- ggplot(mtcars) +
  geom_point(aes(mpg, disp)) +
  ggtitle("主图：mpg vs disp")

inset_boxplot <- ggplot(mtcars) +
  geom_boxplot(aes(gear, disp, group = gear)) +
  ggtitle("子图：disp按gear分组") +
  theme(plot.title = element_text(size = 10))  # 缩小子图标题

# 调用工具函数（默认参数=原始代码效果）
plot_original <- add_inset_plot(
  main_plot = main_scatter,
  inset_plot = inset_boxplot
)
# print(plot_original)

# 2. 场景2：自定义子图位置（右上角对齐，位于主图(0.9,0.9)）
plot_topright <- add_inset_plot(
  main_plot = main_scatter,
  inset_plot = inset_boxplot,
  vp_x = 0.9,
  vp_y = 0.9,
  vp_just = c(1, 1),  # 右上对齐（x=1右对齐，y=1上对齐）
  vp_width = 0.3,
  vp_height = 0.3
)
# print(plot_topright)

# 3. 场景3：自定义子图样式（添加边框，禁止裁剪）
plot_with_border <- add_inset_plot(
  main_plot = main_scatter,
  inset_plot = inset_boxplot,
  vp_x = 0.2,
  vp_y = 0.8,
  vp_just = c(0, 1),  # 左上对齐
  vp_width = 0.35,
  vp_height = 0.35,
  gp = gpar(lwd = 2, col = "red")  # 子图边框（lwd=线宽，col=颜色）
)
# print(plot_with_border)