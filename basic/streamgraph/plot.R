#######################################################
# Streamgraph.                                        #
#-----------------------------------------------------#
# Author: < Wei Dong >                                #
# Email: dongw26@mail2.sysu.edu.cn                    #
# Website: http://bioinfomics.top/                    #
#                                                     #
# Date: 2020-11-28                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2020 by Hiplot Team                   #
# All rights reserved.                                #
#######################################################

# load required packages
pkgs <- c("streamgraph")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  # check data columns
  if (ncol(data) == 3) {
    # nothing
  } else {
    print("Error: Input data should be 3 columns!")
  }
  
  # rename data colnames
  colnames(data) <- c("date","key","value")
  
  # set the offset type, default is"silhouette"
  offset <- conf$extra$offset
  
  # set the interpolate type, default is "cardinal"
  interpolate <- conf$extra$interpolate
  
  # set the color palettes
  # The diverging palettes are: BrBG PiYG PRGn PuOr RdBu RdGy RdYlBu RdYlGn Spectral
  palettes <- conf$general$paletteCont
  if (palettes == "custom") {
    stop('streamgraph do not support custom palettes')
  }
}

############# Section 2 #############
#           plot section
#####################################
{
  
  # Make the streamgraph plot
  p <- streamgraph(data, key = "key", value = "value", date = "date",
                   offset = offset, interpolate = interpolate,
                   interactive = F, scale = "date") %>% 
    sg_fill_brewer(palette = palettes)
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}
