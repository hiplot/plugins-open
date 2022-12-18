#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2022 by "National Center for          #
# Translational Medicine·Shanghai                     #
# All rights reserved.                                #
#######################################################

pkgs <- c("ggplot2")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  sides <- data[1,]
  data <- data[-1,]
  for (i in 1:ncol(data)) {
    data[,i] <- as.numeric(data[,i])
  }
  colrs <- get_hiplot_color(conf$general$palette, -1, conf$general$paletteCustom)
}

############# Section 2 #############
#           plot section
#####################################
{
  p <- ggplot(data, aes(x=x) )
  colrs2 <- colnames(data)
  for (i in seq_len(length(sides))) {
    if (!conf$extra$hist) {
      eval(parse(text =
        sprintf("p <- p + geom_density(aes(x = %s, y = %s..density.., color = '%s', fill = '%s'), kernel = '%s')", 
        colnames(data)[i], ifelse(sides[i] == "top", "", "-"), colnames(data)[i], colnames(data)[i], conf$extra$kernel)))
    } else {
      eval(parse(text =
        sprintf("p <- p + geom_histogram(aes(x = %s, y = %s..density.., color = '%s', fill = '%s'), bins = %s)", 
        colnames(data)[i], ifelse(sides[i] == "top", "", "-"), colnames(data)[i], colnames(data)[i], conf$extra$bins)))
    }
    names(colrs)[i] <- colnames(data)[i]
    names(colrs2)[i] <- colrs[i]
  }
  p <- p + ggtitle(conf$genera$title)
  ## add color palette
  p <- p + return_hiplot_palette(conf$general$palette,
  conf$general$paletteCustom)
  p <- p + scale_fill_manual(values=colrs, name="Densities")
  p <- p + scale_color_manual(values=colrs, name="Densities")
  ## add theme
  p <- choose_ggplot_theme(p, conf$general$theme)
  p <- set_complex_general_theme(p)
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}

