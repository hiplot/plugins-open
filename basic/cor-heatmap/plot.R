#######################################################
# Correlation heatmap.                                #
#-----------------------------------------------------#
# Author: < Mingjie Wang > from < Ke Yan Mao >        #
# Affiliation: Shanghai Hiplot Team                   #
# Email: customer_service1501@tengyunbio.com          #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2020-04-11                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2020 by Hiplot Team                   #
# All rights reserved.                                #
#######################################################

pkgs <- c("ggcorrplot")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  data <- data[!is.na(data[, 1]), ]
  idx <- duplicated(data[, 1])
  data[idx, 1] <- paste0(data[idx, 1], "--dup-", cumsum(idx)[idx])
  print(data)
  if (nrow(data) > 600 && conf$extra$correlation == "row") {
    stop("Hiplot cor-heatmap plugin only support Nrow cor <= 600")
  }
  if (ncol(data) > 600 && conf$extra$correlation == "col") {
    stop("Hiplot cor-heatmap plugin only support Ncol cor <= 600")
  }
  rownames(data) <- data[, 1]
  data <- data[, -1]
  str2num_df <- function(x) {
    final <- NULL
    for (i in seq_len(ncol(x))) {
      final <- cbind(final, as.numeric(x[, i]))
    }
    colnames(final) <- colnames(x)
    return(final)
  }
  cor_method <- conf$extra$cor_method
  # calculate correlations and p values
  if (conf$extra$insig == "on") {
    if (str_detect(toupper(conf$extra$correlation), "^R")) {
      tmp <- str2num_df(t(data))
      corr <- round(cor(tmp, use = "na.or.complete", method = cor_method), 3)
      p_mat <- round(cor_pmat(tmp, method = cor_method), 3)
    } else {
      corr <- round(cor(data, use = "na.or.complete", method = cor_method), 3)
      p_mat <- round(cor_pmat(data, method = cor_method), 3)
    }
  } else {
    if (str_detect(toupper(conf$extra$correlation), "^R")) {
      tmp <- str2num_df(t(data))
      corr <- round(cor(tmp, use = "na.or.complete", method = cor_method), 3)
    } else {
      corr <- round(cor(data, use = "na.or.complete", method = cor_method), 3)
    }
  }

  # plot
  if (str_detect(toupper(conf$extra$shape), "CIRCLE")) {
    method <- "circle"
  } else if (str_detect(toupper(conf$extra$shape), "SQUARE")) {
    method <- "square"
  } else {
    print("Error: Wrong shape selected!")
  }

  if (str_detect(toupper(conf$extra$half), "UPPER")) {
    type <- "upper"
  } else if (str_detect(toupper(conf$extra$half), "LOWER")) {
    type <- "low"
  } else {
    type <- "full"
  }

  if (!conf$extra$reorder) {
    reorder <- FALSE
  } else {
    reorder <- TRUE
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
  if (conf$extra$insig == "off") {
    p <- ggcorrplot(
      corr,
      colors = c(conf$extra$color_low, conf$extra$color_mid, conf$extra$color_high),
      method = method,
      hc.order = reorder,
      hc.method = conf$extra$hc_method,
      outline.col = "white",
      ggtheme = return_ggplot_theme(conf$general$theme),
      type = type,
      lab = conf$extra$lab,
      lab_size = 3,
      legend.title = "Correlation"
    ) +
      ggtitle(conf$general$title)
  } else if (conf$extra$insig == "on") {
    p <- ggcorrplot(
      corr,
      colors = c(conf$extra$color_low, conf$extra$color_mid, conf$extra$color_high),
      method = method,
      hc.order = reorder,
      hc.method = conf$extra$hc_method,
      outline.col = "white",
      ggtheme = return_ggplot_theme(conf$general$theme),
      type = type,
      lab = conf$extra$lab,
      lab_size = 3,
      legend.title = "Correlation",
      sig.level = conf$extra$sig_level,
      insig = conf$extra$insig_type,
      pch = conf$extra$pch,
      pch.col = conf$extra$pch_col,
      p.mat = p_mat
    ) +
      ggtitle(conf$general$title)
  }
  p <- set_complex_general_theme(p)
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}
