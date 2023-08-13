# @hiplot start
# @appname tricolor_histogram
# @apptitle
# Tricolor histogram
# 三色直方图
# @alias tricolor_histogram
# @author Xiaosheng
# @version 0.1.0
# @release 2023-07-31
# @description
# zh: 三色直方图
# en: tricolor histogram
# @main tricolor_histogram
# @library ggplot2
# @param data export::data::hiplot-textarea::{"default": "data.txt", "required": true}
# en: Data Table
# zh: 数据表
# @param value export::dataArg::data::{"index":1, "default": "values", "required": true}
# en: value
# zh: value
# @return ggplot::["png"]::{"cliMode": true, "width":6, "height": 4}
# @data
# data <- data.frame(values = c(rnorm(1000, mean = 6)))
# write_tsv(data, "data.txt")
# @hiplot end

library(ggplot2)

tricolor_histogram <- function(data, value, left_color, middle_color, right_color, alpha, binwidth, low_value, high_value) {
  data$draw_color <- ifelse(data$value < low_value, right_color,
                            ifelse(data$value > high_value, middle_color, left_color)
  )

  # 创建条形图，并设置颜色
  p <- ggplot(data, aes_string(x = value, fill = "draw_color")) +
    geom_histogram(alpha = alpha, binwidth = binwidth, position = "identity") +
    scale_fill_manual(values = c(left_color, middle_color, right_color))

  return(p)
}


# p <- tricolor_histogram(data, "values", "red", "yellow", "green", 0.5, 0.05, 5, 7)
#
#
# p


# ====================== Plugin Caller ======================

p <- tricolor_histogram(
  data = if (exists("data") && is.data.frame(data)) data else "",
  value = conf$dataArg[[1]][[1]]$value,
  left_color = conf$extra$left_color,
  middle_color = conf$extra$middle_color,
  right_color = conf$extra$right_color,
  alpha = conf$extra$alpha,
  binwidth = conf$extra$binwidth,
  low_value = conf$extra$low_value,
  high_value = conf$extra$high_value
)

p <- set_complex_general_theme(set_palette_theme(p, conf))

export_single(p)
