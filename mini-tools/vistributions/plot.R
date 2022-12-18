#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2022 by "National Center for          #
# Translational Medicine·Shanghai                     #
# All rights reserved.                                #
#######################################################
############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  pacman::p_load(vistributions)
}

############# Section 2 #############
#           plot section
#####################################
{
  paramsPlot <- conf$extra
  paramsPlot$type <- conf$extra$probsType

  f <- sprintf("vdist_%s_%s", conf$extra$type,
    conf$extra$plot)

  if (conf$extra$type == "normal" && conf$extra$plot == "prob"
    && conf$extra$probsType == "both") {
    paramsPlot$perc <- unlist(conf$extra$percRange)
  }
  if (conf$extra$type == "binom" && conf$extra$plot == "prob"
    && conf$extra$probsType == "interval") {
    paramsPlot$s <- unlist(conf$extra$sRange)
  }
  paramsPlot <- paramsPlot[names(paramsPlot) %in% formalArgs(f)]


  p <- do.call(sprintf("vdist_%s_%s", conf$extra$type,
    conf$extra$plot), paramsPlot) +
    ggtitle(conf$general$title)
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
