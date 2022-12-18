#######################################################
# chi-square-fisher.                                  #
#-----------------------------------------------------#
# Author: Jianfeng Li                                 #
# Affiliation: Shanghai Hiplot Team                   #
# Email: lee_jianfeng@hiplot.org                      #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2021-03-15                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2022 by "National Center for          #
# Translational Medicine·Shanghai                     #
# All rights reserved.                                #
#######################################################

pkgs <- c("visdat", "ggplot2", "openxlsx")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  if (is.numeric(unlist(data[,-1]))) {
    rownames(data) <- data[,1]
    data <- data[,-1]
  } else {
    data <- xtabs(data)
  }
  if (conf$extra$addMean && conf$extra$by == "row") {
    average <- apply(data, 2, function(x) {mean(x, na.rm = TRUE)})
    data <- rbind(data, average)
    rownames(data)[nrow(data)] <- "mean"
  } else if (conf$extra$addMean) {
    average <- apply(data, 1, function(x) {mean(x, na.rm = TRUE)})
    data <- cbind(data, average)
    colnames(data)[ncol(data)] <- "mean"
  }
  if (conf$extra$addMedian && conf$extra$by == "row") {
    mid <- unlist(lapply(data, function(x) {median(x, na.rm = TRUE)}))
    data <- rbind(data, mid)
    rownames(data)[nrow(data)] <- "median"
  } else if (conf$extra$addMedian) {
    mid <- apply(data, 1, function(x) {median(x, na.rm = TRUE)})
    data <- cbind(data, mid)
    colnames(data)[ncol(data)] <- "median"
  }
}

############# Section 2 #############
#           plot section
#####################################
{
  if (conf$extra$by == "row") {
    cb <- combn(nrow(data), 2)
  } else {
    cb <- combn(ncol(data), 2)
  }
  final <- data.frame()
  for (i in 1:ncol(cb)) {
    if (conf$extra$by == "row") {
      tmp <- data[cb[,i],]
      groups <- paste0(rownames(data)[cb[,i]], collapse = " | ")
    } else {
      tmp <- t(data[,cb[,i]])
      groups <- paste0(colnames(data)[cb[,i]], collapse = " | ")
    }
    res <- tryCatch({
      chisq.test(tmp)
    }, warning = function (w) {
      tryCatch({fisher.test(tmp)}, error = function (e) {
        return(fisher.test(tmp, simulate.p.value = TRUE))
      })
    })
    print(tmp)
    print(res)
    val_percent <- apply(tmp, 1, function(x) {
        sprintf("%s (%s%%)", x, round(x / sum(x), 2) * 100)
    })
    val_percent1 <- paste0(colnames(tmp), ":", val_percent[,1])
    val_percent1 <- paste0(val_percent1, collapse = " | ")
    val_percent2 <- paste0(colnames(tmp), ":", val_percent[,2])
    val_percent2 <- paste0(val_percent2, collapse = " | ")
    tmp <- data.frame(
      groups = groups,
      val_percent_left = val_percent1,
      val_percent_right = val_percent2,
      statistic = ifelse(is.null(res$statistic), NA,
        as.numeric(res$statistic)),
      pvalue = as.numeric(res$p.value),
      method = res$method
    )
    final <- rbind(final, tmp)
  }
  final <- as.data.frame(final)
  final$pvalue < as.numeric(final$pvalue)
  final$statistic < as.numeric(final$statistic)
  colors <- get_hiplot_color(conf$general$paletteCont, -1,
    conf$general$paletteCustom)
  if (!all(is.na(final[,"statistic"]))) {
    p1 <- vis_value(final["statistic"]) + scale_fill_gradientn(colours = colors)
  } else {
    p1 <- ggplot()
  }
  p2 <- vis_expect(final["pvalue"], ~.x < 0.05) +
    return_hiplot_palette(conf$general$palette,
      conf$general$paletteCustom)
  p <- p1 + p2
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
  out_xlsx <- paste(opt$outputFilePrefix, ".xlsx", sep = "")
  write.xlsx(final, out_xlsx)
}
