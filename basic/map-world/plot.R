#######################################################
# World Map.                                          #
#-----------------------------------------------------#
# Author: < Mingjie Wang > from < Ke Yan Mao >        #
# Affiliation: Shanghai Hiplot Team                   #
# Email: customer_service1501@tengyunbio.com          #
# Website: hiplot.org                                 #
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
  data[,2] <- as.numeric(data[,2])
  data <- data.table(data)
  dt_world <- readRDS(file.path(script_dir, "map-world/world.rds"))
  colnames(data)[1] <- "region"
  setkey(data, region)
  setkey(dt_world, ENG_NAME)
  data2 <- data[dt_world]
  data <- as.data.frame(data)
  data2 <- as.data.frame(data2)
  data2$group <- as.numeric(data2$group)
  data2[,colnames(data)[2]] <- as.numeric(data2[,colnames(data)[2]])
  data2 <- subset(data2, region != "Antarctica")
}

############# Section 2 #############
#           plot section
#####################################
{
  if (is.null(conf$general$paletteCont)) {
    conf$general$paletteCont <- "RdYlBu"
  }
  colors <- get_hiplot_color(conf$general$paletteCont)
  p <- ggplot(data2) +
    geom_polygon(aes(x = long, y = lat, group = group, fill = data2[,colnames(data)[2]]),
                alpha = 0.9, size = 0.5)+
    geom_path(aes(x = long, y = lat, group = group), 
             color = "black", size = 0.2) +
    scale_fill_gradientn(colours = colors,
    na.value = "grey10",
    limits = c(0, max(data2[,colnames(data)[2]]) * 1.2)) +
    ggtitle(conf$general$title)
  ## set theme
  p <- set_complex_general_theme(set_palette_theme(p, conf)) + labs(fill = colnames(data)[2])
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}

