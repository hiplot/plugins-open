# @hiplot start
# @appname interval_bar_chart
# @apptitle
# Interval bar chart
# 区间条形图
# @alias interval_bar_chart
# @author Xiaosheng
# @version 0.1.0
# @release 2023-07-19
# @description
# zh: 区间条形图
# en: interval bar chart
# @main interval_bar_chart
# @library ggplot2
# @param data export::data::hiplot-textarea::{"default": "data.txt", "required": true}
# en: Data Table
# zh: 数据表
# @param min export::dataArg::data::{"index":1, "default": "min_temperature", "required": true}
# en: min
# zh: min
# @param max export::dataArg::data::{"index":2, "default": "max_temperature", "required": false}
# en: max
# zh: max
# @param name export::dataArg::data::{"index":3, "default": "month", "required": true}
# en: name
# zh: name
# @return ggplot::["png"]::{"cliMode": true, "width":4, "height": 4}
# @data
# data <- data.frame(
#   month = c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"),
#   min_temperature = c(15, 17, 20, 25, 30, 32, 35, 33, 30, 25, 20, 18),
#   max_temperature = c(20, 25, 26, 30, 35, 35, 38, 36, 33, 30, 25, 22)
# )
# write_tsv(data, "data.txt")
# @hiplot end


library(ggplot2)

interval_bar_chart <- function(data, name, min, max, mean_name, need_mean_line, title, x_label, y_label, bar_color, line_color, line_size, bar_width, alpha) {

  data$name_num <- match(data[[name]], unique(data[[name]]))

  cat(length(data[[mean_name]]))

  p <- ggplot(data, aes(x = data[[name]], y = data[[max]])) +
    geom_rect(aes(
      xmin = name_num - bar_width, xmax = name_num + bar_width,
      ymin = data[[min]], ymax = data[[max]]
    ), fill = bar_color, alpha = alpha) +
    labs(title = title, x = x_label, y = y_label) +
    theme_minimal() +
    scale_x_discrete()

  cat("Hello world!")


  if (need_mean_line) {
    if (mean_name == "") {
      data$mean <- (data[[min]] + data[[max]]) / 2
    }
    p <- p + geom_line(aes(x = data$name_num, y = data$mean), color = line_color, size = line_size)
  }

  return(p)
}


# ====================== Plugin Caller ======================

p <- interval_bar_chart(
  data = if (exists("data") && is.data.frame(data)) data else "",
  min = conf$dataArg[[1]][[1]]$value,
  max = conf$dataArg[[1]][[2]]$value,
  name = conf$dataArg[[1]][[3]]$value,
  mean_name = conf$dataArg[[1]][[4]]$value,
  need_mean_line = ifelse(conf$extra$need_mean_line == "", TRUE, conf$extra$need_mean_line),
  title = conf$extra$title,
  x_label = ifelse(conf$extra$x_label == "", "Undefined", conf$extra$x_label),
  y_label = ifelse(conf$extra$y_label == "", "Undefined", conf$extra$y_label),
  bar_color = ifelse(conf$extra$bar_color == "", "#e05c35", conf$extra$bar_color),
  line_color = ifelse(conf$extra$line_color == "", "#49a2e9", conf$extra$line_color),
  line_size = ifelse(conf$extra$line_size == 0, 1.2, conf$extra$line_size),
  bar_width = ifelse(conf$extra$bar_width == 0, 0.4, conf$extra$bar_width),
  alpha = ifelse(conf$extra$alpha == 0, 1, conf$extra$alpha)
)

p <- set_complex_general_theme(set_palette_theme(p, conf))

export_single(p)
