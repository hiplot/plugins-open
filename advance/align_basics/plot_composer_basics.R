library(ggalign)
library(ggplot2)

# 辅助函数：检查依赖包（确保ggalign已安装）
check_dependency <- function(pkg_name) {
  if (!requireNamespace(pkg_name, quietly = TRUE)) {
    stop(
      sprintf("需安装包「%s」以运行此函数，请执行：\ninstall.packages('%s')", 
              pkg_name, pkg_name), 
      call. = FALSE
    )
  }
}
check_dependency("ggalign")


# 核心工具函数：灵活组合多个ggplot图
combine_plots_with_ggalign <- function(...,
                                       ncol = 2,
                                       widths = NULL) {
  # 1. 收集并统一处理输入的图（支持多图直接传参、列表传参、含空图）
  input_plots <- list(...)
  # 若输入为单个列表（如list(p1,p2)），则解包为单个图元素
  if (length(input_plots) == 1 && is.list(input_plots[[1]])) {
    input_plots <- input_plots[[1]]
  }
  
  # 2. 基础校验：确保输入非空
  if (length(input_plots) == 0) {
    stop("请至少传入1个ggplot对象或NULL（空图）", call. = FALSE)
  }
  
  # 3. 图类型校验：仅允许ggplot对象或NULL（空图）
  valid_plot_types <- sapply(input_plots, function(x) {
    is.null(x) || inherits(x, "ggplot")
  })
  if (!all(valid_plot_types)) {
    invalid_indices <- which(!valid_plot_types)
    stop(
      sprintf("位置%s的输入不是ggplot对象或NULL（空图）", 
              paste(invalid_indices, collapse = ", ")), 
      call. = FALSE
    )
  }
  
  # 4. 宽度参数校验：若提供widths，需与图数量一致
  if (!is.null(widths)) {
    if (length(widths) != length(input_plots)) {
      warning(
        sprintf("widths长度（%d）与图数量（%d）不匹配，将忽略widths参数", 
                length(widths), length(input_plots))
      )
      widths <- NULL
    }
  }
  
  # 5. 调用align_plots组合图（传递所有有效参数）
  combined_plot <- align_plots(
    !!!input_plots,  # 解包图列表
    ncol = ncol,
    widths = widths
  )
  
  return(combined_plot)
}


# ------------------------------
# 示例用法：覆盖原始代码所有场景
# ------------------------------
# 第一步：先创建原始代码中的4个基础图（与原逻辑一致）
p1 <- ggplot(mtcars) +
  geom_point(aes(mpg, disp)) +
  ggtitle("Plot 1")

p2 <- ggplot(mtcars) +
  geom_boxplot(aes(gear, disp, group = gear)) +
  ggtitle("Plot 2")

p3 <- ggplot(mtcars) +
  geom_point(aes(hp, wt, colour = mpg)) +
  ggtitle("Plot 3")

p4 <- ggplot(mtcars) +
  geom_bar(aes(gear)) +
  facet_wrap(~cyl) +
  ggtitle("Plot 4")

# 1. 场景1：直接组合2个图（默认ncol=2，横向排列）
plot_comb1 <- combine_plots_with_ggalign(p1, p2)
# print(plot_comb1)

# 2. 场景2：按行排列（ncol=1，纵向排列）
plot_comb2 <- combine_plots_with_ggalign(p1, p2, ncol = 1)
# print(plot_comb2)

# 3. 场景3：组合图列表（支持直接传列表，无需!!!解包）
plot_list <- list(p1, p2, p3)
plot_comb3 <- combine_plots_with_ggalign(plot_list)  # 也可写combine_plots_with_ggalign(p1,p2,p3)
# print(plot_comb3)

# 4. 场景4：自定义图宽度（2个图宽度比2:1）
plot_comb4 <- combine_plots_with_ggalign(p1, p2, widths = c(2, 1))
# print(plot_comb4)

# 5. 场景5：组合多个图（4个图，2列，宽度比2:1）
plot_comb5 <- combine_plots_with_ggalign(p1, p2, p3, p4, ncol = 2, widths = c(2, 1))
# print(plot_comb5)

# 6. 场景6：添加空图（中间留空，3个位置：p1 + 空图 + p2）
plot_comb6 <- combine_plots_with_ggalign(p1, NULL, p2)  # NULL代表空图
# print(plot_comb6)