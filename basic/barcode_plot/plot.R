# @hiplot start
# @appname barcode_plot
# @apptitle
# Barcode plot
# 条码图
# @alias barcode_plot
# @author Xiaosheng
# @version 0.1.0
# @release 2023-07-20
# @description
# zh: 条码图
# en: barcode plot
# @main barcode_plot
# @library ggplot2 dplyr
# @param data export::data::hiplot-textarea::{"default": "data.txt", "required": true}
# en: Data Table
# zh: 数据表
# @param x export::dataArg::data::{"index":1, "default": "sales", "required": true}
# en: x
# zh: x
# @param y export::dataArg::data::{"index":2, "default": "region", "required": false}
# en: y
# zh: y
# @return ggplot::["png"]::{"cliMode": true, "width":4, "height": 4}
# @data
# data <- data.frame(
#   region = c(rep("GuangDong", 500), rep("GuangXi", 500), rep("FuJian", 500)),
#   sales = c(rnorm(500, mean = 50, sd = 4), rnorm(500, mean = 45, sd = 7), rnorm(500, mean=48, sd = 6))
# )
# write_tsv(data, "data.txt")
# @hiplot end


library(ggplot2)
library(dplyr)

barcode_plot <- function(data, x, y, width, height, color, title, x_label, y_label) {
  # draw_data <- data.frame(x = data[[x]], y = data[[y]])
  p <- ggplot(data, aes_string(x = x, y = y)) +
    geom_tile(width = width, height = height, fill = color) + # 控制条带的宽度和高度
    theme_minimal() +
    labs(title = title, x = x_label, y = y_label)
  return(p)
}


# ====================== Plugin Caller ======================

p <- barcode_plot(
  data = if (exists("data") && is.data.frame(data)) data else "",
  x = conf$dataArg[[1]][[1]]$value,
  y = conf$dataArg[[1]][[2]]$value,
  width = ifelse(conf$extra$width <= 0, 0.1, conf$extra$width),
  height = ifelse(conf$extra$height <= 0, 0.9, conf$extra$height),
  color = ifelse(conf$extra$color == "", "blue", conf$extra$color),
  title = conf$extra$title,
  x_label = conf$extra$x_label,
  y_label = conf$extra$y_label
)

p <- set_complex_general_theme(set_palette_theme(p, conf))

export_single(p)
