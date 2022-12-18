#######################################################
# Pie group.                                          #
#-----------------------------------------------------#
# Author: Jianfeng Li                                 #
# Email: lee_jianfeng@hiplot.org                      #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2021-11-14                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2022 by "National Center for          #
# Translational Medicine·Shanghai                     #
# All rights reserved.                                #
#######################################################
pkgs <- c("patchwork", "ggplotify")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  axis <- sapply(conf$dataArg[[1]], function(x) x$value)
  data[, axis[1]] <- set_factors(data[, axis[1]])
  if (is.character(axis[2]) && axis[2] != "") {
    data[, axis[2]] <- set_factors(data[, axis[2]])
  }
}

############# Section 2 #############
#           plot section
#####################################
{
  col <- get_hiplot_color(conf$general$palette, -1,
    conf$general$paletteCustom)
  p <- NULL
  for (i in unique(data[,axis[2]])) {
    data_tmp <- data[data[,axis[2]] == i,]
    x <- table(data_tmp[,axis[1]])
    ptmp <- as.ggplot(function(){
      par(oma=c(0,0,0,0))
      pie(x,
        labels = sprintf("%s\n(n=%s, %s%%)", names(x), x,
          round(x / sum(x) * 100, conf$general$digits)),
        col = col,
        main = paste0(axis[2], ":", i),
        edges = conf$extra$edges,
        radius = conf$extra$radius,
        clockwise = conf$extra$clockwise
      )
    })
    if (is.null(p)) {
      p <- ptmp
    } else {
      p <- p + ptmp
    }
  }
  p <- p + plot_layout(ncol = conf$extra$ncol)
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}
