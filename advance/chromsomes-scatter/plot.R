#######################################################
# Chromsomes-Scatter.                                 #
#-----------------------------------------------------#
# Author: Jianfeng Li                                 #
# Email: lee_jianfeng@hiplot.org                      #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2021-11-22                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2022 by "National Center for          #
# Translational Medicine·Shanghai                     #
# All rights reserved.                                #
#######################################################

pkgs <- c("gtrellis", "circlize", "ggplotify", "ggsci")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  if (sum(grep("^chr", data[1,1])) == 0) {
    data[,1] <- paste0("chr", data[,i])
  }
  cmap <- list()
  for (i in c(1:22, "X", "Y")) {
    cmap[[paste0("chr", i)]]  <- as.numeric(i)
  }
  cmap$chrX <- 23
  cmap$chrY <- 24
  data[,4] <- transform_val(conf$general$transformY, data[,4])
}

############# Section 2/3 #############
#           plot & output section
#####################################
{
  if (conf$general$palette == "default") {
    col <- c(ggsci::pal_nejm()(8), ggsci::pal_jco()(10), 
                ggsci::pal_lancet()(9))
  } else {
    col <- get_hiplot_color(conf$general$paletteCont, -1, conf$general$paletteCustom)
  }
  p <- as.ggplot(function () {
    gtrellis_layout(nrow = conf$extra$nrow, n_track = 2, track_ylim = range(data[[4]]),
                    species = conf$extra$species,
                    track_axis = c(FALSE, TRUE),
                    track_height = unit.c(2*grobHeight(textGrob("chr1")), 
                                          unit(conf$extra$track_height, "cm")),
                    track_ylab = c("", conf$extra$ylab)
    )
    add_track(panel_fun = function(gr) {
      # the use of `get_cell_meta_data()` will be introduced later
      chr = get_cell_meta_data("name")  
      grid.rect(gp = gpar(fill = "#EEEEEE"))
      grid.text(chr)
    })
    add_track(data, panel_fun = function(data) {
      grid.points((data[[2]] + data[[3]]) / 2, data[[4]], 
                  gp = gpar(
                    col = col[unlist(cmap[data[[1]]])]
                  ),
                  pch = conf$extra$pch, size = unit(conf$extra$point_size, "mm"),
      )
    })
  })
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}

