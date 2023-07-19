library("echarts4r")
library("echarts4r.assets")

custom_icon_scatter <- function(data, x, y, size, symbol, label_name, svg_path, theme) {
  draw_data <- data.frame(
    x = data[[x]],
    y = data[[y]],
    size = data[[size]]
  )
  rm(data)

  if (symbol != "") {
    svg_path <- ea_icons(symbol)
  } else if (svg_path != "") {
    svg_path <- paste0("path://", svg_path)
  }

  p <- draw_data |>
      e_charts(x) |>
      e_scatter(
        y,
        size,
        symbol = svg_path,
        name = label_name
      ) |>
      e_theme(theme)

  return(p)
}



# ====================== Plugin Caller ======================

p <- custom_icon_scatter(
  data = if (exists("data") && is.data.frame(data)) data else "",
  x = conf$dataArg[[1]][[1]]$value,
  y = conf$dataArg[[1]][[2]]$value,
  size = conf$dataArg[[1]][[3]]$value,
  symbol = conf$extra$symbol,
  label_name = conf$extra$label_name,
  svg_path = conf$extra$svg_path,
  theme = conf$extra$theme
)

export_htmlwidget(p)