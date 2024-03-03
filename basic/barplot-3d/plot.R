#######################################################
# 3D bar plot.                                        #
#-----------------------------------------------------#
# Author: < Mingjie Wang > from < Ke Yan Mao >        #
# Affiliation: Shanghai Hiplot Team                   #
# Email: customer_service1501@tengyunbio.com          #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2020-04-25                                    #
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
  # check data
  # check data columns
  if (ncol(data) != 3) {
    print("Error: Input data should be 3 columns!")
  }

  # check conf arguments
  # check alpha
  alpha_usr <- conf$general$alpha
  if (is.numeric(alpha_usr) & alpha_usr >= 0 & alpha_usr <= 1) {
    # nothing
  } else {
    print("Error, alpha should be a decimal between 0-1")
  }
}
############# Section 2 #############
#  plot section and output section
#####################################
{
  # convert data vector to a matrix
  mat <- matrix(rep(1, nrow(data)), nrow = length(unique(data[, 2])))
  rownames(mat) <- unique(data[, 2])
  colnames(mat) <- unique(data[, 3])
  mat
  for (i in 1:nrow(mat)) {
    for (j in seq_len(ncol(mat))) {
      mat[i, j] <- data[, 1][data[, 2] == rownames(mat)[i] &
        data[, 3] == colnames(mat)[j]]
    }
  }

  p <- as.ggplot(function() {
    hist3D(
      x = 1:nrow(mat), y = seq_len(ncol(mat)), z = mat,
      bty = "g", phi = conf$extra$phi,
      theta = conf$extra$theta,
      xlab = colnames(data)[2],
      ylab = colnames(data)[3], zlab = colnames(data)[1],
      main = conf$general$title, colkey = F,
      border = "black", shade = 0.8, axes = T,
      ticktype = "detailed", space = 0.3, d = 2, cex.axis = 0.3,
      colvar = as.numeric(as.factor(data[, 2])), alpha = conf$general$alpha,
      col = get_hiplot_color(conf$general$palette, length(unique(data[, 2])),
        conf$general$paletteCustom)
    )

    # Use text3D to label x axis
    text3D(
      x = 1:nrow(mat), y = rep(0.5, nrow(mat)), z = rep(3, nrow(mat)),
      labels = rownames(mat),
      add = TRUE, adj = 0, cex = 0.8
    )
    # Use text3D to label y axis
    text3D(
      x = rep(1, ncol(mat)), y = seq_len(ncol(mat)), z = rep(0, ncol(mat)),
      labels = colnames(mat), bty = "g",
      add = TRUE, adj = 1, cex = 0.8
    )
  })
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}

