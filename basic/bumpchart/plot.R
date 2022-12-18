#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2022 by "National Center for          #
# Translational Medicine·Shanghai                     #
# All rights reserved.                                #
#######################################################

pkgs <- c("ggbump", "ggplot2", "dplyr")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  # check data
  # check data columns
  if (ncol(data) != 3) {
    print("Error: Input data should be 3 columns!")
  }
}

############# Section 2 #############
#           plot section
#####################################
{
  keep_vars <- c(keep_vars, "colors")
  if (conf$general$palette == "null") {
    colors <- grDevices::colorRampPalette(get_hiplot_color(conf$general$paletteCont, -1, conf$general$paletteContCustom))(length(unique(data[,3])))
  } else {
    colors <- get_hiplot_color(conf$general$palette, -1, conf$general$paletteCustom)
  }
  p <- ggplot(data, aes(x = x, y = y, color = group)) +
    geom_bump(size = conf$extra$line_size) +
    geom_point(size = conf$extra$point_size) +
    geom_text(data = data %>% filter(x == min(x)),
              aes(x = x - 0.1, label = group),
              size = conf$extra$text_size, hjust = 1) +
    geom_text(data = data %>% filter(x == max(x)),
              aes(x = x + 0.1, label = group),
              size = conf$extra$text_size, hjust = 0) +
    theme_void() +
    theme(legend.position = "none") +
    scale_color_manual(values = colors)
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}
