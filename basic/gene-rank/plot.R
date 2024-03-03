#######################################################
# Gene ranking dotplot.                               #
#-----------------------------------------------------#
# Author: < Wei Dong >                                #
# Email: dongw26@mail2.sysu.edu.cn                    #
# Website: http://bioinfomics.top/                    #
#                                                     #
# Date: 2021-02-02                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2020 by Hiplot Team                   #
# All rights reserved.                                #
#######################################################

############# Section 1 ########################## input options, data and configuration
pkgs <- c("ggrepel", "ggplot2")
pacman::p_load(pkgs, character.only = TRUE)

############# section
{
  # check data columns
  if (ncol(data) == 3) {
    # nothing
  } else {
    print("Error: Input data should be 3 columns!")
  }
  # rename data colnames
  colnames(data) <- c("gene", "log2FC", "pvalue")
  
  # set the color palettes The diverging palettes are: BrBG PiYG PRGn PuOr RdBu
  # RdGy RdYlBu RdYlGn Spectral
  colors <- rev(get_hiplot_color(conf$general$paletteCont, -1, conf$general$paletteCustom))
}

############# Section 2 ############# plot section
{
  # ordered by log2FoldChange and pvalue
  data <- data[order(-data$log2FC, data$pvalue), ]
  # add the rank column
  data$rank <- 1:nrow(data)
  # head(data)
  
  # get the top n up and down gene for labeling
  top_n_up <- rownames(head(data, conf$extra$top_n))
  top_n_down <- rownames(tail(data, conf$extra$top_n))
  genes_to_label <- c(top_n_up, top_n_down)
  keep_vars <- c(keep_vars, "genes_to_label", "colors")
  data2 <- data[genes_to_label, ]
  
  # Make the gene ranking dotplot
  p2 <- function() {
    ggplot(data, aes(rank, log2FC, color = pvalue, size = abs(log2FC))) + 
        geom_point() + 
        scale_color_gradientn(colours = colors) +
        geom_hline(yintercept = c(-conf$extra$log_fc, conf$extra$log_fc), linetype = 2, size = 0.3) +
        geom_hline(yintercept = 0, linetype = 1, size = 0.5) +
        geom_vline(xintercept = median(data$rank), linetype = 2, size = 0.3) + 
        geom_text_repel(data = data2, 
          aes(rank, log2FC, label = gene),
          size = conf$extra$label_size, color = "red") +
        xlab(conf$general$x_lab) + ylab(conf$general$y_lab) + 
        ylim(c(-max(abs(data$log2FC)), max(abs(data$log2FC)))) +
        labs(color = "Pvalue", size = "Log2FoldChange") +
        theme_bw(base_size = 12)
  }
  ## add theme
  theme <- conf$general$theme
  p <- choose_ggplot_theme(p2(), theme)
  p <- set_complex_general_theme(p)
}

############# Section 3 ############# output section
{
  export_single(p)
  p <- p2
  rm(p2)
}
