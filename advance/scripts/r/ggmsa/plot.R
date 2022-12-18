#######################################################
# ggmsa.                                              #
#-----------------------------------------------------#
# Author: Jianfeng Li                                 #
# Email: lee_jianfeng@openbiox.org                    #
#                                                     #
# Date: 2022-04-18                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2022 by "National Center for          #
# Translational Medicine·Shanghai                     #
# All rights reserved.                                #
#######################################################

pkgs <- c("ggmsa", "ggplotify", "ggplot2")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  msa_fa <- parse_file_link(conf$data[[1]]$link)
}

############# Section 2 #############
#           plot section
#####################################
{
  #conf$extra$font <- conf$general$font
  params <- list(msa = msa_fa)
  for (i in names(conf$extra)) {
    if (i %in% c("start", "end")) {
      if (conf$extra[[i]] != "") {
        params[[i]] <- as.numeric(conf$extra[[i]])
      } else {
        params[[i]] <- NULL
      }
      next
    }
    params[[i]] <- conf$extra[[i]]
  }
  p <- do.call(ggmsa, params) + geom_seqlogo() + geom_msaBar()
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}
