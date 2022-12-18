#######################################################
# ggseqlogo charts.                                   #
#-----------------------------------------------------#
# Author: Jianfeng Li                                 #
# Email: lee_jianfeng@hiplot.org                      #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2020-08-13                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2022 by "National Center for          #
# Translational Medicine·Shanghai                     #
# All rights reserved.                                #
#######################################################

pkgs <- c("ggseqlogo", "ggplot2")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  usr_cnames <- colnames(data)

  items <- conf$extra$items
  seq_type <- conf$extra$seq_type
  col_scheme <- conf$extra$col_scheme

  if (length(conf$extra$items) > 0) {
    data <- data[, colnames(data) %in% conf$extra$items]
  }
  data <- data[, !sapply(data, function(x) {
    all(is.na(x))
  })]
  data <- as.list(data)
  data <- lapply(data, function(x) {
    return(x[!is.na(x)])
  })
}

############# Section 2 #############
#           plot section
#####################################
{
p <- ggseqlogo(data,
  ncol = conf$extra$ncol,
  col_scheme = conf$extra$col_scheme,
  seq_type = conf$extra$seq_type,
  method = conf$extra$method
) + labs(title = conf$general$title) +
  theme(plot.title = element_text(hjust = 0.5))

## set theme
theme <- conf$general$theme
p <- choose_ggplot_theme(p, theme)
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}

