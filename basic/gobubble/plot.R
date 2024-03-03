#######################################################
# GOBubble plot.                                        #
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
pkgs <- c("GOplot", "ggplotify")
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
  
  # set the labeling threshold
  label_threshold <- conf$extra$label_threshold
  
  # set the labeling ID
  label_id <- conf$extra$label_id
  
  # set the table legend
  table_legend <- conf$extra$table_legend
  
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
  p <- function () {
    GOBubble(data,
                display = display,
                title = conf$general$title,
                colour = as.vector(colors),
                labels = label_threshold, 
                ID = label_id,
                table.legend = table_legend,
                table.col = T,
                bg.col = F) + 
    theme(plot.title = element_text(hjust = 0.5))
  }
  
  if (table_legend && display != 'multiple') {
    p <- as.ggplot(p)
  } else {
    p <- p()
  }
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}
