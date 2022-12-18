#######################################################
# Ideogram-Heat.                                      #
#-----------------------------------------------------#
# Author: Jianfeng Li                                 #
# Email: lee_jianfeng@hiplot.org                      #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2021-11-26                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2022 by "National Center for          #
# Translational Medicine·Shanghai                     #
# All rights reserved.                                #
#######################################################

pkgs <- c("gtrellis", "circlize", "ggplotify", "ggsci", "stringr")
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
  conf$extra$color_key <- str_split(conf$extra$color_key, " |,|;")[[1]]
  col_fun <- col_fun_cont(data[,4], cols = conf$extra$color_key)
  cm = ColorMapping(col_fun = col_fun)
  lgd = color_mapping_legend(cm, plot = FALSE, title = "Value")

  p <- as.ggplot(function () {
    gtrellis_layout(n_track = 1, ncol = 1, track_axis = FALSE, xpadding = c(0.1, 0),
      species = conf$extra$species,
      gap = unit(4, "mm"), border = FALSE, asist_ticks = FALSE, add_ideogram_track = TRUE, 
      ideogram_track_height = unit(2, "mm"), legend = lgd)
    add_track(data, panel_fun = function(gr) {
        grid.rect((gr[[2]] + gr[[3]])/2, unit(0.2, "npc"), unit(1, "mm"), unit(0.8, "npc"), 
            hjust = 0, vjust = 0, default.units = "native", 
            gp = gpar(fill = col_fun(gr[[4]]), col = NA))    
    })
    add_track(track = 2, clip = FALSE, panel_fun = function(gr) {
        chr = get_cell_meta_data("name")
        if(chr == "chrY") {
            grid.lines(get_cell_meta_data("xlim"), unit(c(0, 0), "npc"), 
                default.units = "native")
        }
        grid.text(chr, x = 0, y = 0, just = c("left", "bottom"))
    })
  })
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}

