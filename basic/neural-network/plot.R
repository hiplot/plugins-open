#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2022 by "National Center for          #
# Translational Medicine·Shanghai                     #
# All rights reserved.                                #
#######################################################

pkgs <- c("NeuralNetTools", "nnet", "ggplotify")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  keep_vars <- c(keep_vars, "mod")
  conf$extra$hide_layer_size <- as.numeric(conf$extra$hide_layer_size)
  f <- sprintf("%s ~ %s",
    paste0(conf$dataArg[[1]][[1]]$value, collapse = "+"),
    paste0(conf$dataArg[[1]][[2]]$value, collapse = "+"))
  print(f)
  params <- list(as.formula(f), data = data,
    size = conf$extra$hide_layer_size,
    maxint = conf$extra$maxint,
    decay = conf$extra$decay)
  if (conf$extra$mode %in% c("linout", "entropy", "softmax", "censored")) {
    params[[conf$extra$mode]] <- TRUE
  }
  params$rlang <- 1/max(abs(data[, conf$dataArg[[1]][[2]]$value]))
  mod <- do.call(nnet, params)
}

############# Section 2 #############
#           plot section
#####################################
{
  p <- as.ggplot(function(){
    plotnet(mod)
  })
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}
