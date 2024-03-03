#######################################################
# GOBar plot.                                        #
#-----------------------------------------------------#
# Author: < Wei Dong >                                #
# Email: dongw26@mail2.sysu.edu.cn                    #
# Website: http://bioinfomics.top/                    #
#                                                     #
# Date: 2021-02-07                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2020 by Hiplot Team                   #
# All rights reserved.                                #
#######################################################

# load required packages
pkgs <- c("GOplot")
pacman::p_load(pkgs, character.only = TRUE)


############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  # check data columns
  if (ncol(data) == 8) {
    # nothing
  } else {
    stop("Error: Input data should be 8 columns!")
  }
  
  # rename data colnames
  colnames(data) <- c("category","ID","term","count","genes","logFC","adj_pval","zscore")
  data <- data[!is.na(data$adj_pval),]
  data$adj_pval <- as.numeric(data$adj_pval)
  data$zscore <- as.numeric(data$zscore)
  # zscore = (up-down)/sqrt(count)
  
  # set the plot display("single" or "multiple" plot)
  display <- conf$extra$display
  
  # set the color palettes
  # The diverging palettes are: BrBG PiYG PRGn PuOr RdBu RdGy RdYlBu RdYlGn Spectral
  pal <- conf$general$paletteCont
  if (pal != "custom") {
    colors <- brewer.pal(3, pal)
  } else {
    colors <- custom_color_filter(conf$general$paletteCustom)
  }
}

############# Section 2 #############
#           plot section
#####################################
{
  # Make the GOBar plot
  p <- GOBar(data,
             display = display,
             order.by.zscore = T,
             title = conf$general$title,
             zsc.col = colors
             ) + 
    theme(plot.title = element_text(hjust = 0.5))

}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}
