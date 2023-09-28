library(packcircles)
library(ggplot2)
library(viridis)

circle_packing <- function(data, group, value, add_label, alpha, min_text_size, max_text_size) {
  # Calculate the circle packing layout
  packing <- circleProgressiveLayout(data[[value]], sizetype = "area")
  data <- cbind(data, packing)
  dat_gg <- circleLayoutVertices(packing, npoints = 50)

  # Add colors
  palette <- return_hiplot_palette_color(conf$general$palette, conf$general$paletteCustom)
  colors <- palette$palette(length(data[[value]]))
  # TODO Take the first n values again, because the define of scale_colour_manual in ggplot2 was wrong
  # See the PR for more details: https://github.com/tidyverse/ggplot2/pull/5364
  colors <- colors[seq_along(data[[value]])]
  dat_gg$value <- rep(colors, each = 51)

  p <- ggplot() +
    geom_polygon(data = dat_gg, aes(x, y, group = id, fill = value), colour = "black", alpha = alpha) +
    scale_fill_manual(values = magma(nrow(data))) +
    theme_void() +
    theme(legend.position = "none") +
    coord_equal()

  if (add_label) {
    p <- p +
      scale_size_continuous(range = c(min_text_size, max_text_size)) +
      geom_text(data = data, aes_string("x", "y", size = value, label = group), vjust = 0) +
      geom_text(data = data, aes_string("x", "y", label = value, size = value), vjust = 1.2)
  }

  return(p)
}

# ====================== Plugin Caller ======================

p <- circle_packing(
  data = if (exists("data") && is.data.frame(data)) data else "",
  group = conf$dataArg[[1]][[1]]$value,
  value = conf$dataArg[[1]][[2]]$value,
  add_label = conf$extra$add_label,
  alpha = conf$general$alpha,
  min_text_size = conf$extra$min_text_size,
  max_text_size = conf$extra$max_text_size
)

export_single(p)
