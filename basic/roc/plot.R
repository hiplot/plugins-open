#######################################################
# ROC plot.                                           #
#-----------------------------------------------------#
# Author: < Mingjie Wang > from < Ke Yan Mao >        #
# Affiliation: Shanghai Hiplot Team                   #
# Email: customer_service1501@tengyunbio.com          #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2019-12-8                                     #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2020 by Hiplot Team                   #
# All rights reserved.                                #
#######################################################

pkgs <- c("pROC", "ggplotify", "openxlsx")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  name_val <- colnames(data)[2:ncol(data)]
  num_value <- ncol(data) - 1
  col <- get_hiplot_color(conf$general$palette, num_value,
    conf$general$paletteCustom)

  # check arguments
  # smooth or not
  smooth <- conf$extra$smooth

  # interval or not
  interval <- conf$extra$interval
}

############# Section 2 #############
#           plot section
#####################################
{
  if (interval == "none") {
    ## plot without intervals
    # pdf
    p <- as.ggplot(function() {
      for (i in 1:num_value) {
        if (i == 1) {
          roc_data <- roc(data[, 1], data[, i + 1],
            percent = T, plot = T, grid = conf$extra$grid, lty = i, quiet = T,
            print.auc = F, col = col[i], smooth = smooth,
            main = conf$general$title
          )
          text(30, 50, "AUC", font = 2, col = "darkgray")
          text(30, 50 - 10 * i,
            paste(name_val[i], ":", sprintf("%0.4f", as.numeric(roc_data$auc))),
            col = col[i]
          )
        } else {
          roc_data <- roc(data[, 1], data[, i + 1],
            percent = T, plot = T, grid = conf$extra$grid, add = T, lty = i, quiet = T,
            print.auc = F, col = col[i]
          )
          text(30, 50 - 10 * i,
            paste(name_val[i], ":", sprintf("%0.4f", as.numeric(roc_data$auc))),
            col = col[i]
          )
        }
      }
    })
  } else {
    ## plot with intervals
    # pdf
    p <- as.ggplot(function() {
      par(mfrow = c(1, num_value), pty = "s")
      for (i in 1:num_value) {
        roc_data <- roc(data[, 1], data[, i + 1],
          percent = T, plot = T, grid = conf$extra$grid, quiet = T,
          print.auc = F, col = col[i]
        )
        sens_ci <- ci.se(roc_data,
          boot.n = 100, conf.level = 0.95,
          specificities = seq(0, 100, 5)
        )
        plot(sens_ci,
          type = interval,
          xlim = c(0, 100), ylim = c(0, 100),
          col = transparentColor(col[i], 100)
        )

        text(30, 40, "AUC", font = 2, col = "darkgray")
        text(30, 30,
          paste(name_val[i], ":", sprintf("%0.4f", as.numeric(roc_data$auc))),
          col = col[i]
        )
      }
    })
  }

  ## Performance ##
  get_roc_performance <- function(rocdata) {
    performance <- coords(roc_data, "best",
      best.method = "youden",
      ret = c(
        "threshold", "sensitivity", "specificity",
        "npv", "ppv", "tpr", "fpr",
        "tnr", "fnr", "fdr", "accuracy",
        "precision", "youden"
      ),
      transpose = F
    )
    res <- t(as.data.frame(performance))
    auc <- as.numeric(roc_data$auc)
    res <- rbind(auc, res)
    return(res)
  }

  wb <- createWorkbook()
  if (conf$extra$evaluation) {
    perf_all <- NULL
    roc_data_all <- NULL
    for (i in 1:num_value) {
      roc_data <- roc(data[, 1], data[, i + 1],
        percent = T, plot = F
      )
      roc_data_all <- c(roc_data_all, roc_data)
      perf <- get_roc_performance(roc_data)
      colnames(perf) <- name_val[i]
      perf_all <- cbind(perf_all, perf)
    }
    perf_all <- as.data.frame(perf_all)
    perf_all[["Index"]] <- c(
      "AUC", "Best Cut-off Value", "Sensitivity", "Specificity",
      "Negative Predictive Value", "Positive Predictive Value",
      "True Positive Rate", "False Positive Rate",
      "True Negatice Rate", "False Negative Rate",
      "False Discovery Rate", "Accuracy", "Precision", "Youden Index"
    )
    perf_all <- perf_all[, c(ncol(perf_all), 1:(ncol(perf_all) - 1))]
    addWorksheet(wb, "Model.Performance")
    writeData(wb, "Model.Performance", perf_all,
      colNames = TRUE, rowNames = FALSE
    )
  }
  ## Delong Comparisons ##
  if(num_value >= 2){
    if (conf$extra$compare) {
      pair <- t(combn(2:ncol(data), 2))
  
      compair_result <- NULL
      for (i in 1:nrow(pair)) {
        name1 <- colnames(data)[pair[i, 1]]
        compair_result[["Model1ROC"]] <- c(compair_result[["Model1ROC"]], name1)
        roc1 <- roc(data[, 1], data[, pair[i, 1]],
          percent = T, plot = F
        )
  
        name2 <- colnames(data)[pair[i, 2]]
        compair_result[["Model2.ROC"]] <- c(compair_result[["Model2.ROC"]], name2)
        roc2 <- roc(data[, 1], data[, pair[i, 2]],
          percent = T, plot = F
        )
  
        pv <- roc.test(roc1, roc2,
          reuse.auc = FALSE,
          boot.n = 1000, boot.stratified = F
        )[["p.value"]]
        compair_result[["Pvalue.Delong.test"]] <-
          c(compair_result[["Pvalue.Delong.test"]], pv)
      }
      compair_result <- as.data.frame(compair_result)
      addWorksheet(wb, "Delong.Comparision")
      writeData(wb, "Delong.Comparision", compair_result,
        colNames = TRUE, rowNames = FALSE
      )
    }
  }
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
  out_xlsx <- paste(opt$outputFilePrefix, ".xlsx", sep = "")
  saveWorkbook(wb, out_xlsx, overwrite = TRUE)
}
