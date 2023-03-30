#######################################################
# scrna-tool-vis.                                     #
#-----------------------------------------------------#
# Author: Jianfeng Li                                 #
# Email: lee_jianfeng@openbiox.org                    #
#                                                     #
# Date: 2022-04-18                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2023 by "National Center for          #
# Translational Medicine·Shanghai                     #
# All rights reserved.                                #
#######################################################
pkgs <- c("scRNAtoolVis", "patchwork")
pacman::p_load(pkgs, character.only = TRUE)


if (conf$data$`0-data`$link != "") {
  data <- parse_file_link(conf$data$`0-data`$link)
}
if (conf$data$`1-data`$link != "") {
  data2 <- parse_file_link(conf$data$`1-data`$link)
}
data <- read_data(data)
data2 <- read_data(data2)
data2$cluster <- as.character(data2$cluster)
print(head(data))
print(head(data2))
col <- get_hiplot_color(conf$general$palette,-1,
        conf$general$paletteCustom)
p <- NULL
if ("jjDotPlot" %in% conf$extra$mode) {
  p <- jjDotPlot(object = data,
          gene = data2$gene)
}
if ("jjVolcano" %in% conf$extra$mode && is.null(p)) {
  p <- jjVolcano(diffData = data2)
} else if ("jjVolcano" %in% conf$extra$mode) {
  p <- p + jjVolcano(diffData = data2)
}

if ("markerVocalno" %in% conf$extra$mode && is.null(p)) {
  p <- markerVocalno(markers = data2,
                topn = 5,
                labelCol = col)
} else if ("markerVocalno" %in% conf$extra$mode) {
  p <- p + markerVocalno(markers = data2,
                topn = 5,
                labelCol = col)
}

export_single(p)
