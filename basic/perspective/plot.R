#######################################################
# 3D perspective plot.                                #
#-----------------------------------------------------#
# Author: < Mingjie Wang > from < Ke Yan Mao >        #
# Affiliation: Shanghai Hiplot Team                   #
# Email: customer_service1501@tengyunbio.com          #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2019-11-28                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2020 by Hiplot Team                   #
# All rights reserved.                                #
#######################################################

pkgs <- c("shape", "ggplotify")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  data <- as.matrix(data)
  col <- drapecol(data)
}

############# Section 2 #############
#           plot section
#####################################
{
  p <- as.ggplot(function() {
    persp(as.matrix(data),
      theta = 45, phi = 20,
      expand = 0.5,
      r = 180, col = col,
      ltheta = 120,
      shade = 0.5,
      ticktype = "detailed",
      xlab = "X", ylab = "Y", zlab = "Z",
      border = "black" # could be NA
    )
    title(conf$general$title, line = 0)
  })
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}
