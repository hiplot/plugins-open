library(ggplot2)

interval_area_chart <- function(data, name, min, max, mean_name, need_mean_line, mean_line_color, title, x_label, y_label,
                                area_clor, min_line_color, max_line_color, line_size, alpha,
                                max_linetype, min_linetype, mean_linetype, line_label_size, add_line_label) {
  data[[name]] <- factor(data[[name]], levels = data[[name]])

  p <- ggplot(data, aes_string(x = data[[name]], group = 1)) +
    geom_line(aes_string(y = max), size = line_size, color = max_line_color, linetype = max_linetype) +
    geom_line(aes_string(y = min), size = line_size, color = min_line_color, linetype = min_linetype) +
    geom_ribbon(aes_string(ymin = min, ymax = max), fill = area_clor, alpha = alpha) +
    labs(title = title, x = x_label, y = y_label) +
    scale_color_manual(values = c(max = max_line_color, min = min_line_color))

  if (need_mean_line) {
    if (mean_name == "") {
      data$mean_num <- (data[[min]] + data[[max]]) / 2
    } else {
      data$mean_num <- data[[mean_name]]
    }
    p <- p + geom_line(aes(x = data[[name]], y = data$mean_num),
                       color = mean_line_color, size = line_size, linetype = mean_linetype
    )
  }

  if (add_line_label) {
    p <- p +
      geom_text(aes(x = data[[name]], y = data[[max]] + 1, label = data[[max]]),
                color = max_line_color, size = line_label_size, vjust = -0.5, hjust = 0
      ) +
      geom_text(aes(x = data[[name]], y = data[[min]] - 1, label = data[[min]]),
                color = min_line_color, size = line_label_size, vjust = 1.5, hjust = 0
      )
    if (need_mean_line) {
      p <- p + geom_text(aes(x = data[[name]], y = data$mean_num, label = data$mean_num),
                         color = mean_line_color, size = line_label_size, vjust = 1.5, hjust = 0
      )
    }
  }

  return(p)
}

# ====================== Plugin Caller ======================

p <- interval_area_chart(
  data = if (exists("data") && is.data.frame(data)) data else "",
  min = conf$dataArg[[1]][[1]]$value,
  max = conf$dataArg[[1]][[2]]$value,
  name = conf$dataArg[[1]][[3]]$value,
  mean_name = conf$dataArg[[1]][[4]]$value,
  need_mean_line = conf$extra$need_mean_line,
  title = conf$extra$title,
  x_label = conf$extra$x_label,
  y_label = conf$extra$y_label,
  area_clor = conf$extra$area_clor,
  min_line_color = conf$extra$min_line_color,
  max_line_color = conf$extra$max_line_color,
  mean_line_color = conf$extra$mean_line_color,
  line_size = conf$extra$line_size,
  alpha = conf$extra$alpha,
  max_linetype = ifelse(conf$extra$max_linetype == "", "solid", conf$extra$max_linetype),
  min_linetype = ifelse(conf$extra$min_linetype == "", "solid", conf$extra$min_linetype),
  mean_linetype = ifelse(conf$extra$mean_linetype == "", "solid", conf$extra$mean_linetype),
  add_line_label = conf$extra$add_line_label,
  line_label_size = conf$extra$line_label_size
)

p <- set_complex_general_theme(set_palette_theme(p, conf))

export_single(p)
