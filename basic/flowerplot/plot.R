#######################################################
# Flower plot.                                        #
#-----------------------------------------------------#
# Author: < Wei Dong >                                #
# Email: dongw26@mail2.sysu.edu.cn                    #
# Website: http://bioinfomics.top/                    #
#                                                     #
# Date: 2021-05-14                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2020 by Hiplot Team                   #
# All rights reserved.                                #
#######################################################

# load required packages
pkgs <- c("flowerplot", "ggplotify")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  # check data columns
  if (ncol(data) >= 2) {
    # nothing
  } else {
    print("Error: Input data should be at least 2 columns!")
  }
  
  # set the start angle of rotation in degress
  # angle <- conf$extra$angle
  
  # set the radii of the ellipses along the x-axes
  # a <- conf$extra$a
  
  # set the radii of the ellipses along the y-axes
  # b <- conf$extra$b
  
  # set the radius of the circle
  # r <- conf$extra$r
  
  # set the radius of the central circle
  # circle_col <- conf$extra$circle_col
  
  # set the label text cex
  # lab_size <- conf$extra$label_text_cex
  
  # set the color palettes
  # The diverging palettes are: BrBG PiYG PRGn PuOr RdBu RdGy RdYlBu RdYlGn Spectral
  # ellipse_col_pal <- conf$general$paletteCont
  # ellipse_col <- get_hiplot_color(conf$general$paletteCont, 2, conf$general$paletteContCustom)
}

############# Section 2 #############
#           plot section
#####################################
{
  keep_vars <- c(keep_vars, "ellipse_col")
  if (conf$general$palette == 'null') {
    ellipse_col <- grDevices::colorRampPalette(get_hiplot_color(conf$general$paletteCont, -1, conf$general$paletteContCustom))(ncol(data))
  } else {
    ellipse_col <- get_hiplot_color(conf$general$palette, -1, conf$general$paletteCustom)
  }
  # Make the flower plot
  p <- as.ggplot(function(){
    flowerplot(
    flower_dat = data,
    angle = conf$extra$angle,
    a = conf$extra$a,
    b = conf$extra$b,
    r = conf$extra$r,
    ellipse_col = ellipse_col,
    circle_col = conf$extra$circle_col,
    label_text_cex = conf$extra$label_text_cex
  )})
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}
