library(ggplot2)
library(dplyr)
library(ggrepel)

connected_scatterplot <- function(data, x, y, label, label_ratio, line_color, arrow_size, label_size) {
cat("00000000000000000000000000000")
  cat(data[[x]], data[[y]], data[[label]])

  cat("11111111111111111111111")

  draw_data <- data.frame(
    x = data[[x]],
    y = data[[y]],
    label = data[[label]]
  )

  cat(draw_data$x, draw_data$y, draw_data$label)

  add_label_data <- draw_data %>% sample_frac(label_ratio)
  rm(data)

  p <- ggplot(draw_data, aes(x = x, y = y, label = label)) +
    geom_point(color = line_color) +
    geom_text_repel(data = add_label_data, size = label_size) +
    geom_segment(
      color = line_color,
      aes(
        xend = c(tail(x, n = -1), NA),
        yend = c(tail(y, n = -1), NA)
      ),
      arrow = arrow(length = unit(arrow_size, "mm"))
    )

  return(p)
}

# ====================== Plugin Caller ======================

p <- connected_scatterplot(
  data = if (exists("data") && is.data.frame(data)) data else "",
  x = conf$dataArg[[1]][[1]]$value,
  y = conf$dataArg[[1]][[2]]$value,
  label = conf$dataArg[[1]][[3]]$value,
  label_ratio = conf$extra$label_ratio,
  line_color = conf$extra$line_color,
  arrow_size = conf$extra$arrow_size,
    label_size = conf$extra$label_size
)

p <- set_complex_general_theme(set_palette_theme(p, conf))

export_single(p)
