#######################################################
# 3D Scatter plot.                                    #
#-----------------------------------------------------#
# Author: < Mingjie Wang > from < Ke Yan Mao >        #
# Affiliation: Shanghai Hiplot Team                   #
# Email: customer_service1501@tengyunbio.com          #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2020-04-15                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2020 by Hiplot Team                   #
# All rights reserved.                                #
#######################################################

pkgs <- c("plot3D", "ggplotify")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  # check arguments
  # check alpha
  if ((!is.numeric(conf$general$alpha)) ||
    conf$general$alpha < 0 || conf$general$alpha > 1) {
    stop("alpha should be a decimal between 0-1")
  }
  
  if (is.null(conf$dataArg[[1]][[1]]$value) || conf$dataArg[[1]][[1]]$value == "") {
    col_idx <- ""
  } else {
    col_idx <- which(colnames(data) == conf$dataArg[[1]][[1]]$value)
    data[, col_idx] <- as.factor(data[, col_idx])
  }
  if (is.null(conf$dataArg[[1]][[2]]$value) || conf$dataArg[[1]][[2]]$value == "") {
    shapes <- 19
    shape_idx <- ""
  } else {
    shape_idx <- which(colnames(data) == conf$dataArg[[1]][[2]]$value)
    shapes <- c(19, 15, 17, 0:14, 21:255)
    data[,shape_idx] <- as.factor(data[, shape_idx])
    shapes <- shapes[as.numeric(data[, shape_idx])]
  }
}

############# Section 2 #############
#           plot section
#####################################
{
  if (ncol(data) == 3 && col_idx == "" && shape_idx == "") {
    conf$extra$colors <- get_hiplot_color(conf$general$palette, 1,
          conf$general$paletteCustom)
    p <- as.ggplot(function() {
      scatter3D(data[, 1], data[, 2], data[, 3],
        pch = 19, cex = 1,
        phi = conf$extra$phi, theta = conf$extra$theta, ticktype = "detailed",
        bty = "b2", colkey = FALSE, alpha = conf$general$alpha,
        xlab = colnames(data)[1], ylab = colnames(data)[2],
        zlab = colnames(data)[3],
        main = conf$general$title,
        col = conf$extra$colors
      )
    })
  } else {
    if (col_idx == "") {
      conf$extra$colors <- get_hiplot_color(conf$general$palette, 1,
            conf$general$paletteCustom)
    } else {
      conf$extra$colors <- get_hiplot_color(conf$general$palette, length(unique(data[, col_idx])),
            conf$general$paletteCustom)
    }
    p <- as.ggplot(function() {
      plot3d <- scatter3D(data[, 1], data[, 2], data[, 3],
        pch = shapes, cex = 1,
        phi = conf$extra$phi, theta = conf$extra$theta, ticktype = "detailed",
        bty = "b2", colkey = FALSE, alpha = conf$general$alpha,
        xlab = colnames(data)[1], ylab = colnames(data)[2],
        zlab = colnames(data)[3],
        main = conf$general$title,
        colvar = as.numeric(as.factor(data[, 4])),
        col = conf$extra$colors
      )

      if (col_idx == shape_idx && col_idx != "") {
        print(shapes)
        legend("right", pch=unique(shapes), legend = levels(data[, col_idx]),
        cex = rel(1.1), bty = 'n', xjust = 0.5, horiz = F,
        title = colnames(data)[col_idx],
        col = conf$extra$colors)
      } else if (col_idx != "") {
        legend("right", pch=19, legend = levels(data[, col_idx]),
        cex = rel(1.1), bty = 'n', xjust = 0.5, horiz = F,
        title = colnames(data)[col_idx],
        col = conf$extra$colors)
        
        if (shape_idx != "") {
          data[, shape_idx] <- as.factor(data[, shape_idx])
          legend("bottomright", pch=unique(shapes), legend = levels(data[, shape_idx]),
          cex = rel(1.1), bty = 'n', xjust = 0.5, horiz = F,
          title = colnames(data)[shape_idx],
          col = "black")
        }
      } else if (shape_idx != "") {
        data[, shape_idx] <- as.factor(data[, shape_idx])
        legend("right", pch=unique(shapes), legend = levels(data[, shape_idx]),
        cex = rel(1.1), bty = 'n', xjust = 0.5, horiz = F, 
        title = colnames(data)[shape_idx],
        col = conf$extra$colors)
      }
    })
  }
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}
