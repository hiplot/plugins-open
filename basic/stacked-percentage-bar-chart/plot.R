library(ggplot2)
library(dplyr)

percentsge_stacked_bar_chart <- function(data, y, title, x_label, y_label, add_percent_label) {
  data$total <- rowSums(data[, -1])
  data_long <- tidyr::gather(data, kinds, value, -y, -total)
  data_long <- data_long %>%
    group_by({ { y } }) %>%
    mutate(percent = value / total * 100)
  data_long[[y]] <- factor(data_long[[y]], levels = data[[y]])

  p <- ggplot(data_long, aes_string(x = "percent", y = y, fill = "kinds")) +
    geom_bar(stat = "identity", position = "stack") +
    labs(title = title, x = x_label, y = y_label) +
    scale_x_continuous(labels = scales::percent_format(scale = 1)) +
    theme_minimal()

  if (add_percent_label) {
    p <- p + geom_text(aes(label = ifelse(percent != 0, paste0(round(percent), "%"), "")),
                       position = position_stack(vjust = 0.5)
    )
  }

  return(p)
}

# ====================== Plugin Caller ======================

p <- percentsge_stacked_bar_chart(
  data = if (exists("data") && is.data.frame(data)) data else "",
  y = conf$dataArg[[1]][[1]]$value,
  title = conf$general$title,
  x_label = conf$extra$x_label,
  y_label = conf$extra$y_label,
  add_percent_label = conf$extra$add_percent_label
)

p <- set_complex_general_theme(set_palette_theme(p, conf))

export_single(p)
