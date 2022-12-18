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
  if (is.character(axis[2]) && axis[2] != "") {
    data[, axis[2]] <- set_factors(data[, axis[2]])
  }
}

############# Section 2 #############
#           plot section
#####################################
{
  set.seed(123)
  cmd_extra <- "effsize.type = conf$extra$effsizeType,
    type = conf$extra$type,
    k = conf$general$digits,
    centrality.k = conf$general$digits,
    %s
    plotgrid.args = list(ncol = conf$extra$ncol)"
  checked_params <- list(
    centralityLineType = "centrality.parameter = conf$extra$centralityLineType",
    centralityLine = "centrality.line.args = list(size = 1, color = conf$extra$centralityLine)",
    barFill = "bar.fill = conf$extra$barFill, centrality.label.args = list(color = conf$extra$barFill, size = 3)",
    testValue = "test.value = as.numeric(conf$extra$testValue)",
    normalCurve = " normal.curve = conf$extra$normalCurve,
    normal.curve.args = list(size = 1)"
  )
  merged_params <- ""
  for (i in names(checked_params)) {
    if (!is.null(conf$extra[[i]])) {
      merged_params <- paste0(merged_params, checked_params[[i]], ", ")
    }
  }
  cmd_extra <- sprintf(cmd_extra, merged_params)
  prog = "gghistostats"
  if (axis[2] != "") {
    prog <- "grouped_gghistostats"
  }
  cmd <- sprintf("p <- %s(data = data, x = %s,
    %s%s)",
      prog,
      axis[1],
      ifelse(axis[2] != "", sprintf("grouping.var = %s,", axis[2]), ""),
      cmd_extra)
  eval(parse(text = cmd))
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
