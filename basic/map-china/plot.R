#######################################################
# China Map.                                          #
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

require(maptools)
require(maps)

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

  # read in data file
  usr_cnames <- colnames(data)
  colnames(data) <- c("name", "value")
  # read in map data
  china_map <- rgdal::readOGR(sprintf("%s/china.shp", script_dir))

  # extract province information from shap file
  china_province <- setDT(china_map@data)
  setnames(china_province, "NAME", "province")

  # transform to UTF-8 coding format
  china_province[, province := iconv(province, from = "GBK", to = "UTF-8")]
  # create id to join province back to lat and long, id = 0 ~ 924
  china_province[, id := .I - 1]
  # there are more shapes for one province due to small islands
  china_province[, province := as.factor(province)]
  dt_china <- setDT(fortify(china_map))
  dt_china[, id := as.numeric(id)]
  setkey(china_province, id)
  setkey(dt_china, id)
  dt_china <- china_province[dt_china]

  # set input data
  data <- data.table(data)
  setkey(data, name)
  setkey(dt_china, province)
  china_map_pop <- data[dt_china]
}

############# Section 2 #############
#           plot section
#####################################
{
  p <- ggplot(
    china_map_pop,
    aes(x = long, y = lat, group = group, fill = value)
  ) +
    labs(fill = usr_cnames[2]) +
    geom_polygon() +
    geom_path() +
    scale_fill_gradientn(colours = colorpanel(75,
      low = "darkgreen",
      mid = "yellow", high = "red"
    ), na.value = "grey10") +
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
