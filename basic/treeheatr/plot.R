#######################################################
# Heatmap-integrated Decision Tree Visualizations     #
#-----------------------------------------------------#
# Author: Jianfeng Li                                 #
# Email: lee_jianfeng@hiplot.org                      #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2020-08-22                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2022 by "National Center for          #
# Translational Medicine·Shanghai                     #
# All rights reserved.                                #
#######################################################

pkgs <- c("treeheatr", "ggplotify")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  target_lab <- conf$dataArg[[1]][[1]]$value

  ## Make sure numeric values not be transformed as characters
  x <- data
  wrong_cols <- suppressWarnings(sapply(x, function(x) {
    if (!is.numeric(x)) {
      sum(!is.na(as.numeric(x))) > 0.7 * length(x)
    } else {
      FALSE
    }
  }))
  if (any(wrong_cols)) {
    ix <- which(wrong_cols)
    for (i in ix) {
      data[[i]] <- suppressWarnings(as.numeric(data[[i]]))
    }
    rm(ix)
  }
  rm(x, wrong_cols)
}

############# Section 2 #############
#           plot section
#####################################
{
  p <- as.ggplot(function() {
    print(heat_tree(data,
      target_lab = target_lab,
      task = conf$extra$task,
      show = conf$extra$show,
      heat_rel_height = conf$extra$heat_rel_height,
      panel_space = conf$extra$panel_space,
      clust_samps = conf$extra$clust_samps,
      clust_target = conf$extra$clust_target,
      lev_fac = conf$extra$lev_fac,
      cont_legend = conf$extra$legend_cont, # cont
      cate_legend = conf$extra$legend_cate # cate
    ))
  })
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}
