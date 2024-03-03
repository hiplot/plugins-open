#######################################################
# Chord diagram.                                        #
#-----------------------------------------------------#
# Author: benben-miao                                 #
#                                                     #
# Email: benben.miao@outlook.com                      #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2020-09-01                                   #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2020 by Hiplot Team                   #
# All rights reserved.                                #
#######################################################
pkgs <- c("circlize", "ggplotify")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  ## check conf
  # check alpha
  keep_vars <- c(keep_vars, "alpha_usr", "color_num", "grid_color")
  alpha_usr <- conf$general$alpha
  if (is.numeric(alpha_usr) & alpha_usr >= 0 & alpha_usr <= 1) {
    # nothing
  } else {
    print("Error, alpha should be a decimal between 0-1")
  }
}

############# Section 2 #############
#           plot section
#####################################
{
  row.names(data) <- data[, 1]
  data <- data[, -1]
  if (conf$extra$data_stru == "matrix") {
    color_num <- length(union(rownames(data), colnames(data)))
  } else if (conf$extra$data_stru == "frame") {
    color_num <- length(union(data[, 1], data[, 2]))
  }
  # df = data.frame(from = rep(rownames(mat), times = ncol(mat)),
  #     to = rep(colnames(mat), each = nrow(mat)),
  #     value = as.vector(mat),
  #     stringsAsFactors = FALSE)

  # color_num <- length(union(rownames(mat), colnames(mat)))
  grid_color <- get_hiplot_color(conf$general$palette, color_num,
    conf$general$paletteCustom)
  data <- as.matrix(data)
  p <- list()
  if (conf$extra$label_dir == "hor") {
    p <- as.ggplot(function() {
      chordDiagram(data,
        grid.col = grid_color,
        grid.border = NULL,
        transparency = alpha_usr,
        # col = colorRamp2(c(min(mat),max(mat)),c("green","blue"),transparency = 0.5),
        row.col = NULL,
        column.col = NULL,
        order = NULL,
        directional = conf$extra$directional, # 1, -1, 0, 2
        direction.type = conf$extra$direction_type, # diffHeight and arrows
        diffHeight = convert_height(2, "mm"),
        reduce = 1e-5,
        xmax = NULL,
        self.link = 2,
        symmetric = FALSE,
        keep.diagonal = FALSE,
        preAllocateTracks = NULL,
        annotationTrack = c("name", "grid", "axis"),
        annotationTrackHeight = convert_height(c(conf$extra$dist_name, conf$extra$width_circle), "mm"),
        link.border = NA,
        link.lwd = par("lwd"),
        link.lty = par("lty"),
        link.sort = FALSE,
        link.decreasing = TRUE,
        # link.arr.length = ifelse(link.arr.type == "big.arrow", 0.02, 0.4),
        # link.arr.width = link.arr.length/2,
        # link.arr.type = "triangle",
        # link.arr.lty = par("lty"),
        # link.arr.lwd = par("lwd"),
        # link.arr.col = par("col"),
        link.largest.ontop = FALSE,
        link.visible = conf$extra$link_visible,
        link.rank = NULL,
        link.overlap = FALSE,
        scale = conf$extra$scale,
        group = NULL,
        big.gap = 10,
        small.gap = 1
      )
    })
  } else if (conf$extra$label_dir == "ver") {
    p <- as.ggplot(function() {
      chordDiagram(data,
        grid.col = grid_color,
        grid.border = NULL,
        transparency = alpha_usr,
        # col = colorRamp2(c(min(mat),max(mat)),c("green","blue"),transparency = 0.5),
        row.col = NULL,
        column.col = NULL,
        order = NULL,
        directional = conf$extra$directional, # 1, -1, 0, 2
        direction.type = conf$extra$direction_type, # diffHeight and arrows
        diffHeight = convert_height(2, "mm"),
        reduce = 1e-5,
        xmax = NULL,
        self.link = 2,
        symmetric = FALSE,
        keep.diagonal = FALSE,
        preAllocateTracks = 1,
        annotationTrack = "grid",
        annotationTrackHeight = convert_height(c(conf$extra$dist_name, conf$extra$width_circle), "mm"),
        link.border = NA,
        link.lwd = par("lwd"),
        link.lty = par("lty"),
        link.sort = FALSE,
        link.decreasing = TRUE,
        # link.arr.length = ifelse(link.arr.type == "big.arrow", 0.02, 0.4),
        # link.arr.width = link.arr.length/2,
        # link.arr.type = "triangle",
        # link.arr.lty = par("lty"),
        # link.arr.lwd = par("lwd"),
        # link.arr.col = par("col"),
        link.largest.ontop = FALSE,
        link.visible = conf$extra$link_visible,
        link.rank = NULL,
        link.overlap = FALSE,
        scale = conf$extra$scale,
        group = NULL,
        big.gap = 10,
        small.gap = 1
      )
      circos.trackPlotRegion(
        track.index = 1,
        panel.fun = function(x, y) {
          xlim <- get.cell.meta.data("xlim")
          ylim <- get.cell.meta.data("ylim")
          sector.name <- get.cell.meta.data("sector.index")
          circos.text(mean(xlim),
            ylim[1] + conf$extra$dist_label,
            sector.name,
            facing = "clockwise",
            niceFacing = TRUE,
            adj = c(0, 0.5)
          )
          circos.axis(
            h = "top",
            labels.cex = 0.5,
            major.tick.percentage = 0.2,
            sector.index = sector.name,
            track.index = 2
          )
        },
        bg.border = NA
      )
    })
  }
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
  circos.clear()
}
