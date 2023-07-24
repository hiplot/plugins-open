library(ggplot2)

circular_pie_chart <- function(data, x, y, show_label, width, bottom_text, label_size) {
  # 计算百分比并添加到data中
  data$draw_percent <- data[[y]] / sum(data[[y]]) * 100

  # 复制一份数据，用于绘制空柱形图

  # 源数据class定义为1
  data$draw_class <- 1

  # 复制数据的值和class都置空
  data2 <- data
  data2[[y]] <- 0
  data2$draw_class <- 0

  # 合并数据
  data <- rbind(data, data2)

  # 绘图
  p <- ggplot(data, aes_string(x = "draw_class", y = y, fill = x)) +
    geom_bar(position = "stack", stat = "identity", width = width) +
    coord_polar(theta = "y") +
    theme_minimal() +
    xlab("") +
    ylab(bottom_text) +
    theme(
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      axis.text.y = element_blank(),
      axis.text.x = element_text(color = "black")
    )

  if (show_label) {
    # 只保留非空数据
    filtered_data <- data[data[[y]] > 0,]
    # 添加标签
    p <- p + geom_text(
      data = filtered_data,
      aes(label = sprintf("%.2f%%", draw_percent)),
      position = position_stack(vjust = 0.5),
      size = label_size
    )
  }

  return(p)
}

# ====================== Plugin Caller ======================

p <- circular_pie_chart(
  data = if (exists("data") && is.data.frame(data)) data else "",
  x = conf$dataArg[[1]][[1]]$value,
  y = conf$dataArg[[1]][[2]]$value,
  show_label = conf$extra$show_label,
  width = conf$extra$width,
  bottom_text = conf$extra$bottom_text,
  label_size = conf$extra$label_size
)

p <- p + return_hiplot_palette(
  conf$general$palette,
  conf$general$paletteCustom
)

p <- p + return_hiplot_palette_color(
  conf$general$palette,
  conf$general$paletteCustom
)

export_single(p)
