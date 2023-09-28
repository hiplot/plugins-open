# @hiplot start
# @appname extended_scatter
# @apptitle
# Extended scatter
# 扩展散点图
# @alias extended_scatter
# @author Xiaosheng
# @version 0.1.0
# @release 2023-07-31
# @description
# zh: 扩展散点图
# en: extended scatter
# @main extended_scatter
# @library ggplot2 ggExtra
# @param data export::data::hiplot-textarea::{"default": "data.txt", "required": true}
# en: Data Table
# zh: 数据表
# @param x export::dataArg::data::{"index":1, "default": "wt", "required": true}
# en: x
# zh: x
# @param y export::dataArg::data::{"index":2, "default": "mpg", "required": true}
# en: y
# zh: y
# @param size export::dataArg::data::{"index":2, "default": "cyl", "required": true}
# en: size
# zh: size
# @param group export::dataArg::data::{"index":2, "default": "cyl", "required": true}
# en: group
# zh: group
# @return ggplot::["png"]::{"cliMode": true, "width":6, "height": 4}
# @data
# write_tsv(mtcars, "data.txt")
# @hiplot end


library(ggplot2)
library(ggExtra)


extended_scatter <- function(data, x, y, size, group, add_rug, rug_alpha, rug_size, rug_color,
                             marginal_type, marginal_fill, marginal_color, marginal_size, marginal_bins) {
  # classic plot :
  p <- ggplot(data, aes_string(x = x, y = y, color = group, size = size)) +
    geom_point()+theme(legend.position = "none")

  if (add_rug) {
    p <- p + geom_rug(alpha = rug_alpha, size = rug_size, col = rug_color)
  }

  if (marginal_type != "") {
    p <- ggMarginal(p,
                    type = marginal_type,
                    fill = marginal_fill,
                    color = marginal_color,
                    size = marginal_size,
                    bins = marginal_bins,
                    aes_string(group = group)
    )
  }

  return(p)
}

# ====================== Plugin Caller ======================

p <- extended_scatter(
  data = if (exists("data") && is.data.frame(data)) data else "",
  x = conf$dataArg[[1]][[1]]$value,
  y = conf$dataArg[[1]][[2]]$value,
  size = conf$dataArg[[1]][[2]]$value,
  group = conf$dataArg[[1]][[2]]$value,
  add_rug = conf$extra$add_rug,
  rug_alpha = conf$extra$rug_alpha,
  rug_size = conf$extra$rug_size,
  rug_color = conf$extra$rug_color,
  marginal_type = conf$extra$marginal_type,
  marginal_fill = conf$extra$marginal_fill,
  marginal_color = conf$extra$marginal_color,
  marginal_size = conf$extra$marginal_size,
  marginal_bins = conf$extra$marginal_bins
)

export_single(p)
