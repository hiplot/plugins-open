#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2022 by "National Center for          #
# Translational Medicine·Shanghai                     #
# All rights reserved.                                #
#######################################################

pkgs <- c("igraph", "stringr", "ggplotify")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  data[,conf$dataArg[[1]][[2]]$value] <- factor(data[,conf$dataArg[[1]][[2]]$value],
    levels = unique(data[,conf$dataArg[[1]][[2]]$value]))
  data$hiplot_color_type <- as.numeric(data[,conf$dataArg[[1]][[2]]$value])
  net <- graph_from_data_frame(d = data2, vertices = data, directed = T)
  # Generate colors based on type:
  colrs <- get_hiplot_color(conf$general$palette, -1, conf$general$paletteCustom)
  colrs2 <- get_hiplot_color(conf$general$palette2, -1, conf$general$paletteCustom2)
  V(net)$color <- colrs[V(net)$hiplot_color_type]

  if (is.null(conf$dataArg[[1]][[3]]$value) || conf$dataArg[[1]][[3]]$value == "") {
    # Compute node degrees (#links) and use that to set node size:
    deg <- degree(net, mode="all")
    V(net)$size <- transform_val(conf$extra$transform_size, deg)
  } else {
    # Alternatively, we can set node size based on size column:
    size <- eval(parse(text = sprintf("V(net)$%s", conf$dataArg[[1]][[3]]$value)))
    size <- transform_val(conf$extra$transform_size, size)
    V(net)$size <- size
  }

  # The labels are currently node IDs.
  # Setting them to NA will render no labels:
  V(net)$label.color <- "black"
  V(net)$label <- NA

  # Set edge width based on weight:
  weight_column <- conf$dataArg[[2]][[1]]$value
  if (!is.null(weight_column) && weight_column != "") {
    E(net)$width <- transform_val(conf$extra$transform_width,
      eval(parse(text = sprintf("E(net)$%s", weight_column))))
  }

  #change arrow size and edge color:
  E(net)$arrow.size <- .2
  E(net)$edge.color <- "gray80"
  edge.start <- ends(net, es=E(net), names=F)[,1]
  edge.col <- V(net)$color[edge.start]
}

############# Section 2 #############
#           plot section
#####################################
{
  keep_vars <- c(keep_vars, "net")
  raw <- par()
  p <- as.ggplot(function () {
    par(mar=c(8,2,2,2))
    radian.rescale <- function(x, start=0, direction=1) {
      c.rotate <- function(x) (x + start) %% (4 * pi) * direction
      c.rotate(scales::rescale(x, c(0, 2 * pi), range(x)))
    }

    label <- eval(parse(text = sprintf("V(net)$%s", conf$dataArg[[1]][[1]]$value)))

    l <- do.call(conf$extra$layout, list(net))
    params <- list(net, layout = l, main = conf$general$title,
        edge.color = edge.col, edge.curved = .1,
        vertex.shape = conf$extra$node_shape,
        edge.lty = conf$extra$line_type,
        label.family = conf$general$font,
        vertex.label.family = conf$general$font,
        vertex.label.dist = conf$extra$label_dist,
        edge.arrow.mode = conf$extra$arrow,
        edge.arrow.size = conf$extra$arrow_size,
        edge.arrow.width = conf$extra$arrow_width
    )
    if (conf$extra$layout %in% c("layout_as_star", "layout_in_circle")) {
      lab.locs <- radian.rescale(x=1:length(label),
                              direction=-1, start=0)
      params$vertex.label.degree <- lab.locs
    }
    if (conf$extra$show_text) {
      params$vertex.label <- label
    }
    params$mark.col <- colrs2
    params$mark.border <- NA
    mark_group_column <- conf$dataArg[[1]][[4]]$value
    if (!is.null(mark_group_column) && mark_group_column != "") {
      mark.groups <- list()
      count <- 1
      for (i in unique(data[,mark_group_column])) {
        mark.groups[[count]] <- which(data[,mark_group_column] == i)
        count <- count + 1
      }
      params$mark.groups <- mark.groups
    }
    do.call(plot, params)
    legend(x = -1.7, y = -1.4, unique(data[,conf$dataArg[[1]][[2]]$value]), pch = 21,
          col = "#777777", pt.bg = colrs, pt.cex = 2, cex = .8, bty = "n",
          ncol = 1)
    legend(x = -1.2, y = -1.37,
      legend=round(sort(unique(E(net)$width)), 2), pt.cex= 0.8,
        col='black', ncol = 3, bty = "n", lty = 1,
        lwd = round(sort(unique(E(net)$width)), 2)
    )
    if (length(unique(V(net)$size)) > 8) {
      size_leg <- sort(unique(V(net)$size))[seq(1, length(unique(V(net)$size)), 2)]
    } else {
      size_leg <- sort(unique(V(net)$size))
    }
    legend(x = 0.5, y = -1.3,
          size_leg,
          pch = 21,
          col = "black", pt.bg = "#777777",
          pt.cex = size_leg / 3.8, cex = .8, bty = "n",
          ncol = 3,
          y.intersp = 3,
          x.intersp = 2.5,
          text.width = 0.25
    )
    par(mar=raw$mar)
  })
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}
