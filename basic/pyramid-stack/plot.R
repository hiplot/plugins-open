#######################################################
# Pyramid stack.                                      #
#-----------------------------------------------------#
# Author: Jianfeng Li                                 #
# Email: lee_jianfeng@hiplot.org                      #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2022-10-05                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2022 by "National Center for          #
# Translational Medicine·Shanghai                     #
# All rights reserved.                                #
#######################################################
pkgs <- c("ggplot2", "ggthemes")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  if (!is.null(conf$general$xbreaks)) conf$general$ybreaks <- unlist(conf$general$xbreaks)
  conf$general$xbreaks <- NULL
}

############# Section 2 #############
#           plot section
#####################################
{
  data[,3] <- factor(data[,3], levels = unique(data[,3]))
  data[,1] <- factor(data[,1], levels = unique(data[,1]))
  cnames <- colnames(data)
  g1 <- unique(data[,2])[1]
  g2 <- unique(data[,2])[2]
  if (conf$extra$stack) {
    p <- eval(parse(text =sprintf('ggplot(data = data, aes(x = %s, y = %s, fill = %s)) +
    geom_col(data = data %%>%% filter(%s == g2) %%>%% arrange(rev(%s))) + 
    geom_col(data = data %%>%% filter(%s == g1) %%>%% arrange(rev(%s)), mapping = aes(y = -%s)) +
    coord_flip() +
    geom_hline(yintercept = 0) +
    theme_economist(horizontal = FALSE) +
    scale_fill_economist() +
    labs(y = "%s | %s (left) - %s (right)", x= "")', cnames[1], cnames[4], cnames[3],
      cnames[2], cnames[3], cnames[2], cnames[3], cnames[4], cnames[4], g1, g2)))
  } else {
    p <- eval(parse(text =sprintf('ggplot(data = data, aes(x = %s, y = %s, fill = %s)) +
    geom_bar(data = data %%>%% filter(%s == g2) %%>%% arrange(rev(%s)),
            stat = "identity",
            position = "identity") +
    geom_bar(data = data %%>%% filter(%s == g1) %%>%% arrange(rev(%s)),
            stat = "identity",
            position = "identity",
            mapping = aes(y = -%s)) +
    coord_flip() +
    #extra style shazzaz
    geom_hline(yintercept = 0) +
    theme_economist(horizontal = FALSE) +
    scale_fill_economist() +
    labs(y = "%s | %s (left) - %s (right)", x= "")', cnames[1], cnames[4], cnames[3],
      cnames[2], cnames[3], cnames[2], cnames[3], cnames[4], cnames[4], g1, g2)))
  }

  p <- p +
  theme(panel.grid.major = element_blank(),
    panel.grid.minor = element_blank())

  ## add color palette
  p <- p + return_hiplot_palette_color(conf$general$palette,
      conf$general$paletteCustom) +
    return_hiplot_palette(conf$general$palette,
      conf$general$paletteCustom)

  ## set theme
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

