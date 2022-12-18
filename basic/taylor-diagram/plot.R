#######################################################
# taylor-diagram.                                     #
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

pkgs <- c("openair", "gridExtra", "stringr")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  obs <- unlist(conf$dataArg[[1]][[1]]$value)
  mod <- unlist(conf$dataArg[[1]][[2]]$value)
  group <- unlist(conf$dataArg[[1]][[3]]$value)
}

############# Section 2 #############
#           plot section
#####################################
{
  params <- list(data, obs = obs, mod = mod, group = group,
    main = conf$general$title)
  for (i in names(conf$extra)) {
    if (i %in% c("annotate", "text_obs")) {
      conf$extra[[i]] <- str_replace_all(conf$extra[[i]],
        "\\\\n", "\n")
    }
    params[[str_replace_all(i, "_", ".")]] <- conf$extra[[i]]
  }
  params$cols <- get_hiplot_color(conf$general$palette, -1, 
    conf$general$paletteCustom)
  p <- do.call(TaylorDiagram, params)
  p <- gridExtra::grid.arrange(p$plot)
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}
