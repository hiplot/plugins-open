#######################################################
# UMAP.                                               #
#-----------------------------------------------------#
# Author: Jianfeng Li                                 #
# Email: lee_jianfeng@hiplot.org                      #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2021-03-26                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2022 by "National Center for          #
# Translational Medicine·Shanghai                     #
# All rights reserved.                                #
#######################################################

# load required packages
pkgs <- c("fishplot", "stringr")
pacman::p_load(pkgs, character.only = TRUE)

draw_fish_plot <- function (data, samplename, outfn) {
  timepoints <- data[,1]
  parents <- data[,2]
  frac_table <- as.matrix(data[,-c(1:2)])
  #create a fish object
  col <- get_hiplot_color(conf$general$palette2, ncol(frac_table), conf$general$paletteCustom2)
  params <- list(frac_table, parents,
    timepoints = timepoints, col = col, 
    fix.missing.clones = conf$extra$fix_missing)
  if (conf$extra$clone_label) {
    params$clone.labels <- colnames(data)[-c(1:2)]
    params$clone.annots <- params$clone.labels
  }
  fish <- do.call(createFishObject, params)
  #calculate the layout of the drawing
  fish <- layoutClones(fish)
  if (conf$extra$bg_type == "solid") {
    bg.col <- get_hiplot_color(conf$general$palette, 1, conf$general$paletteCustom)
  } else {
    bg.col <- get_hiplot_color(conf$general$palette, 3, conf$general$paletteCustom)
  }
  cairo_pdf(outfn,
    width = conf$general$size$width, height = conf$general$size$height,
    family = conf$general$font)
  params <- list(
    fish,
    shape = conf$extra$shape, title.btm = samplename,
          cex.title = 1, bg.type = conf$extra$bg_type,
          title = conf$general$title,
          bg.col = bg.col,
    border = conf$extra$border,
    col.border = conf$extra$border_col,
    pad.left = conf$extra$pad_left
  )
  if (conf$extra$vline) {
    params$vlines <- data[,1]
    params$vlab <- sprintf("%s %s", conf$extra$unit, data[,1])
    params$col.vline <- conf$extra$col_vline
  }
  print(do.call(fishPlot, params), newpage = FALSE)
  dev.off()
}

pdfs <- c()
for (i in unique(data[,3])) {
  tmp <- data[data[,3] == i,]
  tmp <- tmp[,-3]
  i <- str_replace_all(i, "/| ", ".")
  i <- str_replace_all(i, fixed("..."), ".")
  i <- str_replace_all(i, fixed(".."), ".")
  outfn <- paste0(opt$outputFilePrefix, "_", i, ".pdf")
  draw_fish_plot(tmp, i, outfn)
  pdfs <- c(pdfs, outfn)
}
pdfs2image(pdfs)
file.remove(pdfs)
