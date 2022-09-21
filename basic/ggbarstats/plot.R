#######################################################
# ggscatterstats plot.                                #
#-----------------------------------------------------#
# Author: Jianfeng Li                                 #
# Email: lee_jianfeng@hiplot.org                      #
# Website: hiplot-academic.com                      #
#                                                     #
# Date: 2021-01-28                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2020 by Hiplot Team                   #
# All rights reserved.                                #
#######################################################
pkgs <- "ggstatsplot"
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  axis <- sapply(conf$dataArg[[1]], function(x) x$value)
  data[, axis[1]] <- set_factors(data[, axis[1]], rev = TRUE)
  data[, axis[2]] <- set_factors(data[, axis[2]])
  if (is.character(axis[3]) && axis[3] != "") {
    data[, axis[3]] <- set_factors(data[, axis[3]])
  }
}

############# Section 2 #############
#           plot section
#####################################
{
  set.seed(123)
  cmd_extra <- paste0("plotgrid.args = list(ncol = conf$extra$ncol),
    paired = conf$extra$paired,
    k = conf$general$digits",
    ifelse(conf$extra$boxplot, ", marginal.type = 'boxplot'", ""))
  
  prog = "ggbarstats"
  if (axis[3] != "") {
    g <- unique(data[,axis[3]])
    print(g)
    if (length(g) > 100) {
      stop("Unique values of group should < 100")
    }
    for (i in 1:length(g)) {
      fil <- data[,axis[3]] == g[i]
      cmd <- sprintf("p <- %s(data = data[fil,],
      x = %s, y = %s,
      title= paste('', axis[3], g[i], sep = ':'),
      %s)",
        prog,
        axis[1], axis[2],
        cmd_extra)
      assign(paste0("p", i), set_palette_theme(eval(parse(text = cmd)), conf))
    }
    cmd <- sprintf("p <- %s + plot_layout(ncol=%s) + plot_annotation(title = conf$general$title)",
    paste0("p", 1:length(g), collapse = " + "), conf$extra$ncol)
    eval(parse(text = cmd))
  } else {
    cmd <- sprintf("p <- %s(data = data, x = %s, y = %s,
      %s)",
        prog,
        axis[1], axis[2],
        cmd_extra)
    eval(parse(text = cmd))
    p <- set_palette_theme(p, conf)
  }

}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}
