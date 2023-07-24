library(waterfalls)

waterfalls_plot <- function(data, name, value, calc_total, width, up_color, down_color, total_rect_color) {
  data[[name]] <- factor(data[[name]], levels = data[[name]])
  data$value <- data[[value]]

  fill_by_sign <- TRUE
  # 如果value大于0，设置为up_color，否则设置为down_color
  if (up_color != "" && down_color != "") {
    data$fill <- ifelse(data$value > 0, up_color, down_color)
    fill_by_sign <- FALSE
  }

  p <- waterfall(data,
                 calc_total = calc_total,
                 rect_width = width,
                 fill_by_sign = fill_by_sign,
                 fill_colours = data$fill,
                 total_rect_color = total_rect_color)

  return(p)
}

# ====================== Plugin Caller ======================

p <- waterfalls_plot(
  data = if (exists("data") && is.data.frame(data)) data else "",
  name = conf$dataArg[[1]][[1]]$value,
  value = conf$dataArg[[1]][[2]]$value,
  calc_total = conf$extra$calc_total,
  width = conf$extra$width,
  up_color = ifelse(conf$extra$up_color == "", "", conf$extra$up_color),
  down_color = ifelse(conf$extra$down_color == "", "", conf$extra$down_color),
  total_rect_color = ifelse(conf$extra$total_color == "", "black", conf$extra$total_color)
)

p <- set_complex_general_theme(set_palette_theme(p, conf))

export_single(p)
