#######################################################
# China Map.                                          #
#-----------------------------------------------------#
# Author: < Mingjie Wang > from < Ke Yan Mao >        #
# Affiliation: Shanghai Hiplot Team                   #
# Email: customer_service1501@tengyunbio.com          #
# Website: hiplot-academic.com                      #
#                                                     #
# Date: 2020-04-10                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2020 by Hiplot Team                   #
# All rights reserved.                                #
#######################################################

pkgs <- c("ggplot2", "data.table")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  # read in data file
  usr_cnames <- colnames(data)
  colnames(data) <- c("name", "value")

  dt_china <- readRDS(file.path(script_dir, "map-china/china.rds"))
  data <- data.table(data)
  setkey(data, name)
  setkey(dt_china, FCNAME)
  china_map_pop <- data[dt_china]
}

############# Section 2 #############
#           plot section
#####################################
{
  if (is.null(conf$general$paletteCont)) {
    conf$general$paletteCont <- "RdYlBu"
  }
  colors <- get_hiplot_color(conf$general$paletteCont)
  p <- ggplot(
    china_map_pop,
    aes(x = long, y = lat, group = group, fill = value)
  ) +
    labs(fill = usr_cnames[2]) +
    geom_polygon() +
    geom_path() +
    scale_fill_gradientn(colours = colors,
    na.value = "grey10",
    limits = c(0, max(china_map_pop$value) * 1.2)) +
    ggtitle(conf$general$title)
  ## set theme
  theme <- conf$general$theme
  p <- choose_ggplot_theme(p, theme)
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}
