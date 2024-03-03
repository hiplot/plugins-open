#######################################################
# Fan plot.                                           #
#-----------------------------------------------------#
# Author: < Mingjie Wang > from < Ke Yan Mao >        #
# Affiliation: Shanghai Hiplot Team                   #
# Email: customer_service1501@tengyunbio.com          #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2020-04-15                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2020 by Hiplot Team                   #
# All rights reserved.                                #
#######################################################

pkgs <- c("plotrix", "ggplotify")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  # check data
  # check data columns
  if (ncol(data) != 2) {
    print("Error: Input data should be 2 columns!")
  }

  # check conf arguments
  # check alpha
  alpha_usr <- conf$general$alpha
  if (is.numeric(alpha_usr) & alpha_usr >= 0 & alpha_usr <= 1) {
    # nothing
  } else {
    print("Error, alpha should be a decimal between 0-1")
  }
  # check label ratio
  label_ratio <- conf$extra$ratio
}

############# Section 2 #############
#           plot section
#####################################
{
  if (label_ratio) {
    p <- as.ggplot(function() {
      fan.plot(data[, 2],
      main = conf$general$title,
      labels = paste(as.character(data[, 1]),
        "(", sprintf("%4.2f%%", data[, 2] / sum(data[, 2]) * 100), ")",
        sep = ""
      ),
      col = add_alpha(
        get_hiplot_color(conf$general$palette, nrow(data),
        conf$general$paletteCustom),
        alpha_usr
      )
    )}
  )
  } else {
    p <- as.ggplot(function() {
      fan.plot(data[, 2],
      main = conf$general$title,
      labels = as.character(data[, 1]),
      col = add_alpha(
        get_hiplot_color(conf$general$palette, nrow(data),
        conf$general$paletteCustom),
        alpha_usr
      )
    )})
  }
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(print(p))
}
