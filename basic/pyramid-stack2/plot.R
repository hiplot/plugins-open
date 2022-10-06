#######################################################
# Pyramid stack.                                      #
#-----------------------------------------------------#
# Author: Jianfeng Li                                 #
# Email: lee_jianfeng@hiplot.org                      #
# Website: hiplot-academic.com                      #
#                                                     #
# Date: 2022-10-05                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2022 by Jianfeng Li                   #
# All rights reserved.                                #
#######################################################
pkgs <- c("plotrix", "ggplotify")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  agegrps <- unique(data[,1])
  split_var <- unique(data[,2])
  dat_left <- as.matrix(data[data[,2] == split_var[1],-c(1,2)])
  dat_right <- as.matrix(data[data[,2] == split_var[2],-c(1,2)])
}

############# Section 2 #############
#           plot section
#####################################
{
  p <- as.ggplot(function() {
    cols <- get_hiplot_color(conf$general$palette, -1,
    conf$general$paletteCustom)
    names(cols) <- colnames(dat_left)
    cols <- cols[1:ncol(dat_left)]
    pyramid.plot(dat_left, dat_right, labels = agegrps,
                        unit=conf$general$xlab,
                        lxcol=cols,
                        rxcol=cols,
                        laxlab=as.numeric(conf$general$xbreaks),
                        raxlab=as.numeric(conf$general$xbreaks),
                        top.labels=c(split_var[1], colnames(data)[1], split_var[2]),
                        gap=4,
                        ppmar=c(4,2,4,7),
                        do.first="plot_bg(\"#FFFFFF\")")
    mtext(conf$general$title, 3, 2, cex=1)
    legend("right", inset=c(-0.25,0), legend = colnames(dat_left),
      fill=cols)
  })
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}

