# @hiplot start
# @appname group_dumbbell
# @apptitle
# Group Dumbbell
# 分组哑铃图
# @alias group_dumbbell
# @author Xiaosheng
# @version 0.1.0
# @release 2023-07-27
# @description
# zh: 分组哑铃图
# en: Group Dumbbell
# @main group_dumbbell
# @library ggplot2
# @param data export::data::hiplot-textarea::{"default": "data.txt", "required": true}
# en: Data Table
# zh: 数据表
# @param x_start export::dataArg::data::{"index":1, "default": "y1952", "required": true}
# en: x_start
# zh: x_start
# @param x_end export::dataArg::data::{"index":2, "default": "y2007h", "required": true}
# en: x_end
# zh: x_end
# @param y export::dataArg::data::{"index":3, "default": "country", "required": true}
# en: y
# zh: y
# @param group export::dataArg::data::{"index":4, "default": "group", "required": true}
# en: group
# zh: group
# @return ggplot::["png"]::{"cliMode": true, "width":6, "height": 4}
# @data
# data <- data.frame(
#   country = c("Argentina", "Bolivia", "Brazil", "Canada", "Chile", "Colombia",
#               "Costa Rica", "Cuba", "Dominican Republic", "Ecuador", "El Salvador",
#               "Guatemala", "Haiti", "Honduras", "Jamaica", "Mexico", "Nicaragua",
#               "Panama", "Paraguay", "Peru", "Puerto Rico", "Trinidad and Tobago",
#               "United States", "Uruguay", "Venezuela"),
#   y1952 = c(62.485, 40.414, 50.917, 68.75, 54.745, 50.643, 57.206, 59.421, 45.928,
#             48.357, 45.262, 42.023, 37.579, 41.912, 58.53, 50.789, 42.314, 55.191,
#             62.649, 43.902, 64.28, 59.1, 68.44, 66.071, 55.088),
#   y2007 = c(75.32, 65.554, 72.39, 80.653, 78.553, 72.889, 78.782, 78.273, 72.235,
#             74.994, 71.878, 70.259, 60.916, 70.198, 72.567, 76.195, 72.899, 75.537,
#             71.752, 71.421, 78.746, 69.819, 78.242, 76.384, 73.747),
#   group = c(rep("A", 13), rep("B", 12))
# )
# write_tsv(data, "data.txt")
# @hiplot end

library(ggplot2)
library(ggalt)

# Create the data frame with an additional column "group"


group_dumbbell <- function(data, x_start, x_end, y, group, line_size, dot_size) {
  data <- data[order(data[[group]], data[[x_start]]),]
  data[[y]] <- factor(data[[y]], levels = data[[y]])
  p <- ggplot(data = data, aes_string(x = x_start, xend = x_end, y = y, color = group)) +
    geom_dumbbell(size = line_size, size_xend = dot_size, size_x = dot_size) +
    theme_minimal()
  return(p)
}

# ====================== Plugin Caller ======================

p <- group_dumbbell(
  data = if (exists("data") && is.data.frame(data)) data else "",
  x_start = conf$dataArg[[1]][[1]]$value,
  x_end = conf$dataArg[[1]][[2]]$value,
  y = conf$dataArg[[1]][[3]]$value,
  group = conf$dataArg[[1]][[4]]$value,
  line_size = conf$extra$line_size,
  dot_size = conf$extra$dot_size
)

p <- set_complex_general_theme(set_palette_theme(p, conf))

export_single(p)
