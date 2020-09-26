#######################################################
# World Map.                                          #
#-----------------------------------------------------#
# Author: < Mingjie Wang >                            #
# Affiliation: Shanghai Hiplot Team                   #
# Website: https://hiplot.com.cn                      #
#                                                     #
# Date: 2020-04-10                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2020 by Hiplot Team                   #
# All rights reserved.                                #
#######################################################

pacman::p_load(maptools)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  initial_options <- commandArgs(trailingOnly = FALSE)
  file_arg_name <- "--file="
  script_name <- sub(
    file_arg_name, "",
    initial_options[grep(file_arg_name, initial_options)]
  )
  script_dir <- dirname(script_name)
  source(sprintf("%s/../lib.R", script_dir))
  source(sprintf("%s/../head.R", script_dir))

  # modify data and add Taiwan to China
  # Taiwan always belong to China
  tw <- data[data$Country == "China", ]
  tw$Country[1] <- "Taiwan"
  data <- rbind(data, tw)
  rownames(data) <- NULL

  # start plot
  # this lets us use the contry name vs 3-letter ISO
  data(wrld_simpl)
  wrld_simpl@data$id <- wrld_simpl@data$NAME
  wrld <- fortify(wrld_simpl, region = "id")
  wrld <- subset(wrld, id != "Antarctica") # we don't rly need Antarctica
  # define your own color panel
}

############# Section 2 #############
#           plot section
#####################################
{
  p <- ggplot() +
    geom_map(
      data = wrld, map = wrld,
      aes(map_id = id, x = long, y = lat),
      fill = "white", color = "#7f7f7f", size = 0.25
    ) +
    geom_map(
      data = data, map = wrld,
      aes(map_id = Country, fill = Value),
      color = "white", size = 0.25
    ) +
    scale_fill_gradientn(colours = colorpanel(75,
      low = "darkgreen",
      mid = "yellow",
      high = "red"
    )) +
    ggtitle(conf$general$title)
  ## set theme
  theme <- conf$general$theme
  p <- choose_ggplot_theme(p, theme)
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p, opt, conf)
  source(sprintf("%s/../foot.R", script_dir))
}
