#######################################################
# Meta-analysis of continuous outcome data            #
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
  label_vars <- c("n.e", "mean.e", "sd.e",
                  "n.c", "mean.c", "sd.c",
                  "Study")
  
  for (i in seq_len(length(conf$dataArg[[1]]))) {
    assign(label_vars[i], conf$dataArg[[1]][[i]]$value)
  }
  
  data[, "Study"] <- data[, Study]
  data[, "n.e"] <- data[,n.e]
  data[, "mean.e"] <- data[, mean.e]
  data[, "sd.e"] <- data[,sd.e]
  
  data[, "n.c"] <- data[, n.c]
  data[, "mean.c"] <- data[, mean.c]
  data[, "sd.c"] <- data[,sd.c]
  data <- data[, unname(unlist(label_vars))]
  print(data)
}

pacman::p_load(meta)
############# Section 2 #############
#           plot section
#####################################

{
  m1 <- metacont(n.e, mean.e, sd.e, 
                 n.c, mean.c, sd.c,
                 studlab = Study,
                 data = data, sm = "SMD")
  
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
