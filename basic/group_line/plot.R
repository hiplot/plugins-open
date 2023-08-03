library(ggplot2)

group_line <- function(data, x, y, names, groups) {
  p <- ggplot(data, aes_string(x = x, y = y, group = names, color = groups)) +
    geom_line() +
    geom_point()

  return(p)
}


# ====================== Plugin Caller ======================

p <- group_line(
  data = if (exists("data") && is.data.frame(data)) data else "",
  x = conf$dataArg[[1]][[1]]$value,
  y = conf$dataArg[[1]][[2]]$value,
  names = conf$dataArg[[1]][[3]]$value,
  groups = conf$dataArg[[1]][[4]]$value
)

p <- set_complex_general_theme(set_palette_theme(p, conf))

export_single(p)
