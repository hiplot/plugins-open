#######################################################
# cor-heatmap2.                                       #
#-----------------------------------------------------#
# Author: Jianfeng Li                                 #
# Email: lee_jianfeng@hiplot.org                      #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2021-11-28                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2022 by "National Center for          #
# Translational Medicine·Shanghai                     #
# All rights reserved.                                #
#######################################################

pkgs <- c("corrplot", "ggplotify", "ggplot2", "ggcorrplot")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  data <- data[!is.na(data[, 1]), ]
  idx <- duplicated(data[, 1])
  data[idx, 1] <- paste0(data[idx, 1], "--dup-", cumsum(idx)[idx])
  rownames(data) <- data[, 1]
  data <- data[, -1]
  str2num_df <- function(x) {
    x[] <- lapply(x, function(l) as.numeric(l))
    x
  }
  cor_method <- conf$extra$cor_method
  # calculate correlations and p values
  if (conf$extra$insig == "on") {
    if (str_detect(toupper(conf$extra$correlation), "^R")) {
      tmp <- t(str2num_df(data))
      corr <- round(cor(tmp, use = "na.or.complete", method = cor_method), 3)
      p_mat <- round(cor_pmat(tmp, method = cor_method), 3)
    } else {
      corr <- round(cor(data, use = "na.or.complete", method = cor_method), 3)
      p_mat <- round(cor_pmat(data, method = cor_method), 3)
    }
  } else {
    if (str_detect(toupper(conf$extra$correlation), "^R")) {
      tmp <- t(str2num_df(data))
      corr <- round(cor(tmp, use = "na.or.complete", method = cor_method), 3)
    } else {
      corr <- round(cor(data, use = "na.or.complete", method = cor_method), 3)
    }
  }

  if (is.null(conf$extra$color_low)) {
    conf$extra$color_low <- "#0000FF"
    conf$extra$color_mid <- "#FFFFFF"
    conf$extra$color_high <- "#FF0000"
  }
}

############# Section 2 #############
#           plot section
#####################################
{
  cols <- colorRampPalette(c(conf$extra$color_low, conf$extra$color_mid, conf$extra$color_high))(200)
  params <- list(corr, method=conf$extra$shape, type = conf$extra$half,
        tl.col = "black", diag = conf$extra$diag,
        col = cols,
        order = conf$extra$order_method,
        hclust.method = conf$extra$hc_method)
  if (conf$extra$insig == "on") {
    params$p.mat <- p_mat
    params$sig.level = conf$extra$sig_level
    params$insig <- conf$extra$insig_type
    params$pch <- conf$extra$pch
    params$pch.cex <- conf$extra$pch_size
  }
  if (conf$extra$lab) {
    params$addCoef.col = "black"
    params$number.cex <- conf$extra$number_size
  }
  p <- as.ggplot(function(){
    do.call(corrplot, params)
  })
  p <- set_complex_general_theme(p) + 
    theme(axis.text.y = element_blank(), axis.text.x = element_blank()) +
    xlab("") + ylab("") +
    ggtitle(conf$general$title)
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}
