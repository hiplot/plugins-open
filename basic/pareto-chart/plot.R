library(ggplot2)

pareto_chart <- function(data, x, y) {
  data <- data[order(-data[[y]]), ]
  data[[x]] <- factor(data[[x]], levels = data[[x]])

  # calculate percentage number
  data$accumulating <- cumsum(data[[y]])
  max_y <- max(data[[y]])
  cal_num <- sum(data[[y]]) / max_y
  data$accumulating <- data$accumulating / cal_num

  p <- ggplot(data, aes_string(x = x, y = y, fill = x)) +
    geom_bar(stat = "identity") +
    geom_line(aes(y = accumulating), group = 1) +
    geom_point(aes(y = accumulating), show.legend = FALSE) +
    scale_y_continuous(sec.axis = sec_axis(trans = ~ . / max_y * 100, name = "Percentage"))

  return(p)
}

# ====================== Plugin Caller ======================

p <- pareto_chart(
  data = if (exists("data") && is.data.frame(data)) data else "",
  x = conf$dataArg[[1]][[1]]$value,
  y = conf$dataArg[[1]][[2]]$value
)

p <- set_complex_general_theme(set_palette_theme(p, conf))

export_single(p)
