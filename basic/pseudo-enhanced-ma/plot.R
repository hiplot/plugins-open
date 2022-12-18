#######################################################
# Pseudo-enhanced-ma.                                 #
#-----------------------------------------------------#
# Author: Jianfeng Li                                 #
# Email: lee_jianfeng@openbiox.org                    #
#                                                     #
# Date: 2020-04-10                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2022 by "National Center for          #
# Translational Medicine·Shanghai                     #
# All rights reserved.                                #
#######################################################
pkgs <- c("EnhancedVolcano")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  row.names(data) <- data[,1]
  data <- data[,-1]
  data$baseMeanNew <- 1 / (10^log(data$baseMean + 1))
}

############# Section 2 #############
#           plot section
#####################################
{
 conf$extra$yrange <- unlist(conf$extra$yrange)
 p <- EnhancedVolcano(data,
    lab = rownames(data),
    title = conf$general$title,
    subtitle = conf$extra$subtitle,
    x = 'log2FoldChange',
    y = 'baseMeanNew',
    xlab = bquote(~Log[2]~ 'fold change'),
    ylab = bquote(~Log[e]~ 'base mean + 1'),
    ylim = conf$extra$yrange,
    pCutoff = as.numeric(conf$extra$p_cutoff),
    FCcutoff = conf$extra$fc_cutoff,
    pointSize = conf$extra$pointSize,
    labSize = conf$extra$labSize,
    boxedLabels = conf$extra$boxedLabels,
    colAlpha = conf$general$alpha,
    legendLabels = c('NS', expression(Log[2]~FC),
      'Mean expression', expression(Mean-expression~and~log[2]~FC)),
    legendPosition = conf$extra$legendPosition,
    legendLabSize = 16,
    legendIconSize = 4.0,
    drawConnectors = TRUE,
    widthConnectors = 0.75,
    # encircle
      #encircle = celltype1,
      encircleCol = 'black',
      encircleSize = 2.5,
      encircleFill = 'pink',
      encircleAlpha = 1/2) + coord_flip()

  if (conf$general$palette != "default") {
    p <- p + return_hiplot_palette_color(conf$general$palette,
        conf$general$paletteCustom) +
      return_hiplot_palette(conf$general$palette,
        conf$general$paletteCustom)
  }
  theme <- conf$general$theme
  p <- choose_ggplot_theme(p, theme)
  p <- set_complex_general_theme(p)
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}

