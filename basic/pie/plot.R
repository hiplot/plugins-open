#######################################################
# Pie graph.                                          #
#-----------------------------------------------------#
# Author: < Mingjie Wang > from < Ke Yan Mao >        #
# Affiliation: Shanghai Hiplot Team                   #
# Email: customer_service1501@tengyunbio.com          #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2019-11-13                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2020 by Hiplot Team                   #
# All rights reserved.                                #
#######################################################

pkgs <- c("ggplot2", "dplyr")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  # read in data
  colnames(data) <- c("Group", "Value")
}

############# Section 2 #############
#           plot section
#####################################
{
  # plot
  blank_theme <- theme_minimal() +
    theme(
      axis.title.x = element_blank(),
      axis.title.y = element_blank(),
      axis.text.x = element_blank(),
      axis.text.y = element_blank(),
      panel.border = element_blank(),
      panel.grid = element_blank(),
      axis.ticks = element_blank(),
      plot.title = element_text(size = 14, face = "bold")
    )

  # Compute the position of labels
  data <- data %>%
    arrange(desc(Group)) %>%
    mutate(prop = Value / sum(data$Value) * 100) %>%
    mutate(ypos = Value / length(unique(Group)) +
      c(0, cumsum(Value)[-length(Value)]) + 5)
  p <- ggplot(data, aes(x = "", y = Value, fill = Group)) +
    geom_col(width = 1) +
    geom_bar(
      stat = "identity",
      width = 1,
      color = "white"
    ) +
    coord_polar(
      theta = "y",
      start = 0,
      direction = -1
    ) +
    guides(fill = guide_legend(title = "Group")) +
    scale_fill_discrete(
      breaks = data$Group,
      labels = paste(data$Group,
        " (",
        round(data$Value / sum(data$Value) * 100, 2),
        "%)",
        sep = ""
      )
    ) +
    blank_theme +
    geom_text(aes(y = ypos, label = sprintf(
      "%s\n(n=%s, %s%%)", Group, Value,
      round(Value / sum(data$Value) * 100, 2)
    )), color = "white", fontface = "bold")

  ## add color palette
  p <- p + return_hiplot_palette_color(conf$general$palette,
      conf$general$paletteCustom) +
    return_hiplot_palette(conf$general$palette,
      conf$general$paletteCustom)

  theme <- conf$general$theme
  p <- choose_ggplot_theme(p, theme)
  p <- p +
    ggtitle(conf$general$title) + 
    theme(plot.title = element_text(hjust = 0.5, vjust = -1))
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}

