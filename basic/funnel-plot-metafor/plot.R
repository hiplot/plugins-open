#######################################################
# metafor.                                            #
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

pkgs <- c("metafor", "ggplotify")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  conf$extra$shade <- get_hiplot_color(conf$general$palette, 3, 
    conf$general$paletteCustom)
  data2 <- eval(parse(text =
    sprintf("escalc(measure=conf$extra$measure, %s, data = data)",
      paste0(conf$extra$exprs, collapse = ","))))
  res <- rma(yi, vi, data = data2) 
}

############# Section 2 #############
#           plot section
#####################################
{
  params <- list(x = res,
    main = conf$general$title)
  for (i in names(conf$extra)) {
    params[[i]] <- conf$extra[[i]]
    if (i %in% c("refline", "level")) {
      params[[i]] <- as.numeric(params[[i]])
    } else {
      params[[i]] <- unlist(params[[i]])
    }
  }
  p <- as.ggplot(function(){
    do.call(funnel, params)
  })
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}
