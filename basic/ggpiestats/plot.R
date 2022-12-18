#######################################################
# ggwithinstats plot.                                 #
#-----------------------------------------------------#
# Author: Jianfeng Li                                 #
# Email: lee_jianfeng@hiplot.org                      #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2021-01-28                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2022 by "National Center for          #
# Translational Medicine·Shanghai                     #
# All rights reserved.                                #
#######################################################
pkgs <- "ggstatsplot"
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  axis <- sapply(conf$dataArg[[1]], function(x) x$value)
  data[, axis[1]] <- set_factors(data[, axis[1]])
  if (is.character(axis[2]) && axis[2] != "") {
    data[, axis[2]] <- set_factors(data[, axis[2]])
  }
}

############# Section 2 #############
#           plot section
#####################################
{
  set.seed(123)
  cmd_extra <- "title = conf$general$title,
    paired = conf$extra$paired,
    k = conf$general$digits"
  prog <- "ggpiestats"
  cmd <- sprintf("p <- %s(data = data, x = %s,
    %s%s)",
      prog,
      axis[1],
      ifelse(axis[2] != "", sprintf("y = %s,", axis[2]), ""),
      cmd_extra)
  eval(parse(text = cmd))
  p <- set_palette_theme(eval(parse(text = cmd)), conf)
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}
