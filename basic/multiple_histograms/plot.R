library(ggplot2)


multiple_histograms <- function(data, value, group, alpha, frame_color, binwidth) {
  p <- ggplot(data, aes_string(x = value, fill = group)) +
    geom_histogram(color = frame_color, alpha = alpha, position = "identity", binwidth = binwidth)

  return(p)
}

# ====================== Plugin Caller ======================

p <- multiple_histograms(
  data = if (exists("data") && is.data.frame(data)) data else "",
  value = conf$dataArg[[1]][[1]]$value,
  group = conf$dataArg[[1]][[2]]$value,
  alpha = conf$extra$alpha,
  frame_color = conf$extra$frame_color,
  binwidth = conf$extra$binwidth
)

p <- set_complex_general_theme(set_palette_theme(p, conf))

export_single(p)
