#######################################################
# ggscatterstats plot.                                #
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
pkgs <- c("ggstatsplot")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  axis <- sapply(conf$dataArg[[1]], function(x) {
    return(str_replace_all(x[["value"]], " ", ".")[1])
  })
  if (is.character(axis[3]) && axis[3] != "") {
    data[, axis[3]] <- set_factors(data[, axis[3]])
  }
  keep_vars <- c(keep_vars, "axis")
}

############# Section 2 #############
#           plot section
#####################################
{
  set.seed(123)
  params <- list(data = data,
    effsize.type = conf$extra$effsizeType,
    type = conf$extra$type,
    xfill = conf$extra$xfill,
    yfill = conf$extra$yfill,
    k = conf$general$digits,
    plotgrid.args = list(ncol = conf$extra$ncol))
  if (conf$extra$boxplot) params$marginal.type = "boxplot"
  
  prog = "ggscatterstats"
  if (axis[3] != "") {
    prog <- "grouped_ggscatterstats"
    if (length(unique(data[,axis[3]])) > 100) {
      stop("Unique values of group should < 100")
    }
  }

  message("Plot variables: ")
  print(axis)
  message("Using prog: ", prog)

  params$x <- axis[1]
  params$y <- axis[2]
  if(axis[3] != "") params$grouping.var = axis[3]
  p <- do.call(prog, params)
  if(axis[3] == "") p <- ggplotify::as.ggplot(p)
  p <- p + plot_annotation(title = conf$general$title)
  ## add theme
  theme <- conf$general$theme
  p <- choose_ggplot_theme(p, theme)
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}
