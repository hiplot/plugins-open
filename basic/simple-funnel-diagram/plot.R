library(magrittr)
library(echarts4r)

simple_funnel_diagram <- function(data, title, theme) {
  p <- data %>%
    e_charts() %>%
    e_funnel(value, key) %>%
    e_title(title) %>%
    e_theme(theme)
  return(p)
}

# ====================== Plugin Caller ======================

p <- simple_funnel_diagram(
  data = if (exists("data") && is.data.frame(data)) data else "",
  title = conf$extra$title,
  theme = conf$extra$theme
)

export_single(p)