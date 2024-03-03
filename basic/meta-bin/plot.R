#######################################################
# Meta-analysis of binary outcome data                #
#-----------------------------------------------------#
# Author: Houshi Xu                                   #
# Affiliation: Shanghai Hiplot Team                   #
# Email: houshi@sjtu.edu.cn                           #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2020-12-29                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2020 by Hiplot Team                   #
# All rights reserved.                                #
#######################################################

pkgs <- c("meta", "ggplotify")
pacman::p_load(pkgs, character.only = TRUE)

{
  label_vars <- c("ev.exp", "n.exp", "ev.cont", "n.cont",
                  "Study")

  for (i in seq_len(length(conf$dataArg[[1]]))) {
    assign(label_vars[i], conf$dataArg[[1]][[i]]$value)
  }
  
  data[, "Study"] <- data[,Study]
  data[, "ev.exp"] <- data[, ev.exp]
  data[, "n.exp"] <- data[, n.exp]
  data[, "ev.cont"] <- data[, ev.cont]
  data[, "n.cont"] <- data[, n.cont]
  data <- data[, unname(unlist(label_vars))]
  print(data)
}

pacman::p_load(meta)
############# Section 2 #############
#           plot section
#####################################
{
  m1 <- metabin(ev.exp, n.exp, 
                ev.cont, n.cont,
                studlab = Study,
                data = data)
  
  p <- as.ggplot(function(){
    meta::forest(m1, layout = conf$extra[["layout"]])
  })
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}

