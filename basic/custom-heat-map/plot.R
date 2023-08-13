library(ggplot2)

custom_heat_map <- function(data, low_color, high_color, text_size, circle_size) {
  draw_data <- as.matrix(data[, 2:ncol(data)])
  row_num <- nrow(draw_data)
  col_num <- ncol(draw_data)
  col_labels <- colnames(data)
  col_labels <- col_labels[2:ncol(data)]
  row_labels <- data$name
  rm(data)

  df <- expand.grid(row = 1:row_num, col = 1:col_num)
  df$value <- c(draw_data)

  p <- ggplot(df, aes(x = col, y = row, fill = value)) +
    geom_point(shape = 21, size = circle_size, aes(fill = value), color = "white") +
    scale_fill_gradient(low = low_color, high = high_color) +
    guides(fill = guide_colorbar(title = "Value")) +
    theme(
      panel.background = element_rect(fill = "white"),
      panel.grid = element_blank(),
      axis.text = element_text(size = text_size),
      axis.ticks = element_blank(),
      axis.title = element_blank()
    ) +
    scale_x_continuous(breaks = 1:col_num, labels = col_labels, position = "top") +
    scale_y_reverse(breaks = 1:row_num, labels = row_labels, position = "left")
  return(p)
}


# ====================== Plugin Caller ======================

p <- custom_heat_map(
  data = if (exists("data") && is.data.frame(data)) data else "",
  low_color = conf$extra$low_color,
  high_color = conf$extra$high_color,
  text_size = conf$extra$text_size,
  circle_size = conf$extra$circle_size
)

export_single(p)
