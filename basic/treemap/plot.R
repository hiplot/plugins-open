#######################################################
# Treemap                                             #
#-----------------------------------------------------#
# Author: < Mingjie Wang > from < Ke Yan Mao >        #
# Affiliation: Shanghai Hiplot Team                   #
# Email: customer_service1501@tengyunbio.com          #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2019-11-28                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2020 by Hiplot Team                   #
# All rights reserved.                                #
#######################################################

pkgs <- c("treemap")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  # check data
  # check data columns
  if (ncol(data) != 2) {
    print("Error: Input data should be 2 columns!")
  }

  # check conf
  colors <- get_hiplot_color(conf$general$palette, nrow(data),
        conf$general$paletteCustom)
  keep_vars <- c(keep_vars, "colors")
}

############# Section 2 #############
#           plot section
#####################################
{
  p <- function() {
      treemap(data,
      index = colnames(data)[1],
      vSize = colnames(data)[2],
      vColor = colnames(data)[1],
      type = "index",
      title = conf$general$title,
      algorithm = "pivotSize",
      sortID = colnames(data)[1],
      border.lwds = 1,
      fontcolor.labels = conf$extra$labelcol,
      inflate.labels = conf$extra$labelsize,
      overlap.labels = 0.5,
      fontfamily.title = conf$general$font,
      fontfamily.legend = conf$general$font,
      fontfamily.labels = conf$general$font,
      palette = colors,
      aspRatio = conf$general$size$height / conf$general$size$width
    )
  }
}

############# Section 3 #############
#          output section
#####################################
{
  outfn <- paste0(opt$outputFilePrefix, ".pdf")
  cairo_pdf(outfn, 
    width = conf$general$size$width, height = conf$general$size$height,
    family = conf$general$font)
  p()
  dev.off()
  pdfs2image(outfn)
}

