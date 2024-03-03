#######################################################
# 3D pie graph.                                       #
#-----------------------------------------------------#
# Author: < Mingjie Wang > from < Ke Yan Mao >        #
# Affiliation: Shanghai Hiplot Team                   #
# Email: customer_service1501@tengyunbio.com          #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2020-04-12                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2020 by Hiplot Team                   #
# All rights reserved.                                #
#######################################################

pkgs <- c("plotrix", "ggplotify")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  colnames(data) <- c("Group", "Value")
  data$Value <- as.numeric(data$Value)
  data <- data[data$Value != 0,]
}

############# Section 2 #############
#           plot section
#####################################
{
  colors <- get_hiplot_color(conf$general$palette,
        length(unique(data$Group)), conf$general$paletteCustom)
  conf$extra$colors <- colors
  p <- function() {
    pie3D(
      data$Value,
      radius = conf$extra$radius,
      height = conf$extra$height,
      theta = conf$extra$theta,
      labels = paste(
        data$Group,
        "\n(n=",
        data$Value,
        ", ",
        round(data$Value / sum(data$Value) * 100, 2),
        "%)",
        sep = ""
      ),
      explode = conf$extra$explode,
      main = conf$general$title,
      labelcex = 1,
      shade = 0.4,
      labelcol = "black",
      col = conf$extra$colors
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
