# @hiplot start
# @appname group_bubble
# @apptitle
# Group Bubble
# 分组气泡图
# @alias group_bubble
# @author Xiaosheng
# @version 0.1.0
# @release 2023-07-27
# @description
# zh: 分组气泡图
# en: Group Bubble
# @main group_bubble
# @library ggplot2
# @param data export::data::hiplot-textarea::{"default": "data.txt", "required": true}
# en: Data Table
# zh: 数据表
# @param x export::dataArg::data::{"index":1, "default": "Sepal.Length", "required": true}
# en: x
# zh: x
# @param y export::dataArg::data::{"index":2, "default": "Sepal.Width", "required": true}
# en: y
# zh: y
# @param size export::dataArg::data::{"index":3, "default": "Petal.Length", "required": true}
# en: size
# zh: size
# @param color export::dataArg::data::{"index":4, "default": "Species", "required": true}
# en: group
# zh: group
# @return ggplot::["png"]::{"cliMode": true, "width":6, "height": 4}
# @data
# library(ggplot2)
# data <- iris
# write_tsv(data, "data.txt")
# @hiplot end


library(ggplot2)

group_bubble <- function(data, x, y, size, color, min_size, max_size, alpha) {
  p <- ggplot(data = data, aes_string(x = x, y = y, size = size, color = color)) +
    geom_point(alpha = alpha) +
    scale_size(range = c(min_size, max_size)) +
    theme_minimal()
  return(p)
}

# ====================== Plugin Caller ======================

p <- group_bubble(
  data = if (exists("data") && is.data.frame(data)) data else "",
  x = conf$dataArg[[1]][[1]]$value,
  y = conf$dataArg[[1]][[2]]$value,
  size = conf$dataArg[[1]][[3]]$value,
  color = conf$dataArg[[1]][[4]]$value,
  min_size = conf$extra$min_size,
  max_size = conf$extra$max_size,
  alpha = conf$general$alpha
)

p <- set_complex_general_theme(set_palette_theme(p, conf))

export_single(p)
