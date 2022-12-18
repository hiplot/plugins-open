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
  cmd_extra <- "plotgrid.args = list(ncol = conf$extra$ncol),
    label.repel = TRUE,
    k = conf$general$digits"
  prog <- "ggpiestats"
  g <- unique(data[,axis[2]])
  print(g)
  for (i in 1:length(g)) {
    fil <- data[,axis[2]] == g[i]
    cmd <- sprintf("p <- %s(data = data[fil,],
    x = %s, 
    title= paste('', axis[2], g[i], sep = ':'),
    %s)",
      prog,
      axis[1],
      cmd_extra)
    assign(paste0("p", i), set_palette_theme(eval(parse(text = cmd)), conf))
  }
  cmd <- sprintf("p <- %s + plot_layout(ncol=%s) + plot_annotation(title = conf$general$title)",
  paste0("p", 1:length(g), collapse = " + "), conf$extra$ncol)
  eval(parse(text = cmd))
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}
