#######################################################
# funnel-plot.                                        #
#-----------------------------------------------------#
# Author: Jianfeng Li                                 #
# Email: lee_jianfeng@openbiox.org                    #
#                                                     #
# Date: 2022-04-17                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2022 by "National Center for          #
# Translational Medicine·Shanghai                     #
# All rights reserved.                                #
#######################################################

pkgs <- c("FunnelPlotR", "gridExtra")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  target <- unlist(conf$dataArg[[1]][[1]]$value)
  vars <- unlist(conf$dataArg[[1]][[2]]$value)
  factor_vars <- unlist(conf$dataArg[[1]][[3]]$value)
  denominator <- unlist(conf$dataArg[[1]][[4]]$value)
  group <- unlist(conf$dataArg[[1]][[5]]$value)

  for (i in factor_vars) {
    data[,i] <- factor(data[,i], levels = unique(data[,i]))
  }
  data[,target] <- as.numeric(data[,target])

  if (conf$extra$label == "NA") {
    conf$extra$label <- NA
  }
  if (conf$extra$draw_adjusted) {
    conf$extra$draw_unadjusted <- FALSE
  } else {
    conf$extra$draw_unadjusted <- TRUE
  }
  if (conf$general$xbreaks[1] == "auto") {
    conf$general$xbreaks <- "auto"
  }
  if (conf$general$ybreaks[1] == "auto") {
    conf$general$ybreaks <- "auto"
  }
  conf$extra$x_label <- conf$general$xlab
}

############# Section 2 #############
#           plot section
#####################################
{
  mod<- eval(parse(text =
    sprintf('glm(%s ~ %s, family="%s", data=data)',
     target, paste0(vars, collapse = " + "),
     conf$extra$family)
  ))

  print(summary(mod))

  params <- list(title = conf$general$title, numerator = data[,target],
    denominator = data[,denominator], group = data[,group])
  for (i in names(conf$extra)) {
    params[[i]] <- conf$extra[[i]]
  }
  params$plot_cols <- get_hiplot_color(conf$general$palette, -1, 
    conf$general$paletteCustom)
  p <- do.call(funnel_plot, params)
  p <- plot(p)
  p <- set_complex_general_theme(set_palette_theme(p, conf))
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}
