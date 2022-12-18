#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2022 by "National Center for          #
# Translational Medicine·Shanghai                     #
# All rights reserved.                                #
#######################################################

pkgs <- c("ggalt", "ggplot2")
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
  eval(parse(text = sprintf("p <- ggplot(data,
       aes(y = reorder(%s, %s),
           x = %s,
           xend = %s))", colnames(data)[1],
           colnames(data)[2], colnames(data)[2],
           colnames(data)[3])
  ))
  colors <- get_hiplot_color(conf$general$palette, -1, conf$general$paletteCustom)
  p <- p + geom_dumbbell(size = conf$extra$line_size,
                size_x = conf$extra$point_size, 
                size_xend = conf$extra$point_size,
                colour = conf$extra$line_color, 
                colour_x = colors[1], 
                colour_xend = colors[2]) +
  labs(
    title = conf$general$title,
    x = conf$general$xlab,
    y = colnames(data)[1]
  )

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
