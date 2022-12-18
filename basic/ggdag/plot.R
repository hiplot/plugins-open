#######################################################
# ggdag directed acyclic graphs.                      #
#-----------------------------------------------------#
# Author: Jianfeng Li                                 #
# Email: lee_jianfeng@hiplot.org                      #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2020-08-23                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2022 by "National Center for          #
# Translational Medicine·Shanghai                     #
# All rights reserved.                                #
#######################################################

pkgs <- c("ggdag")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  cmd <- sprintf(
    paste0(
      "tidy_ggdag <- dagify(",
      "%s, exposure = conf$data$exposure,",
      "outcome = conf$data$outcome)"
    ),
    conf$data$graph
  )
  eval(parse(text = cmd))
  data <- tidy_dagitty(tidy_ggdag)
}

############# Section 2 #############
#           plot section
#####################################
{
  p <- ggdag(data) + ggtitle(conf$general$title) +
    theme(plot.title = element_text(hjust = 0.5))
  theme <- conf$general$theme
  if (theme != "default") {
    p <- choose_ggplot_theme(p, theme)
  } else {
    p <- p + theme_dag()
  }
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}
