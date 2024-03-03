#######################################################
# GOCircle plot.                                        #
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
  
  # set the displayed GO term number
  nsub <- conf$extra$nsub
  
  # set the label size
  label_size <- conf$extra$label_size
  
  # set the radius of inner circle
  rad1 <- conf$extra$rad1
  
  # set the radius of outer circle
  rad2 <- conf$extra$rad2
  
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
  p <- function() {
    GOCircle(data,
                title = conf$general$title,
                nsub = nsub,
                rad1 = rad1,
                rad2 = rad2,
                table.legend = table_legend,
                zsc.col = colors,
                label.size = label_size
                ) + 
    theme(plot.title = element_text(hjust = 0.5))
  }

  if (table_legend) {
    p2 <- as.ggplot(print(p))
  } else {
    p2 <- p()
  }

}

############# Section 3 #############
#          output section
#####################################
{
  tryCatch(export_single(p2), error = function(e) {
    export_single(p)
  })
}
