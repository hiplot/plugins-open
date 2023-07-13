library(ggplot2)
library(dplyr)

circular_bar_plot <- function(data, x, y, order = FALSE, overflow = 1.15, x_size) {
  plot_data <- data.frame(class = numeric(length(data[[x]])),
                          value = numeric(length(data[[y]])))
  plot_data$class <- data[[x]]
  plot_data$value <- data[[y]]
  rm(data)

  group_sort <- plot_data %>%
    group_by(class) %>%
    summarise(count = n()) %>%
    arrange(count)

  # order by x
  if (order) {
    plot_data$class <- factor(plot_data$class, levels = group_sort$class)
  }

  # plot
  p <- ggplot(plot_data, aes(class)) +
    geom_bar(aes(fill = value)) +
    coord_polar(theta = "y") +
    theme_bw() +
    geom_text(
      hjust = 1, size = x_size,
      aes(x = class, y = 0, label = class)
    ) +
    theme_minimal() +
    xlab("") +
    ylab("") +
    theme(panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          axis.text.y = element_blank(),
          axis.text.x = element_text(color = "black", face = "bold")) +
    ylim(c(0, max(group_sort$count) * overflow))
  return(p)
}

# ====================== Plugin Caller ======================

p <- circular_bar_plot(
  data = if (exists("data") && is.data.frame(data)) data else "",
  x = conf$dataArg[[1]][[1]]$value,
  y = conf$dataArg[[1]][[2]]$value,
  order = conf$extra$order,
  overflow = conf$extra$overflow,
  x_size = conf$extra$x_size
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
