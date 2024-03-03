#######################################################
# Violin plot.                                        #
#-----------------------------------------------------#
# Author: benben-miao                                 #
#                                                     #
# Email: benben.miao@outlook.com                      #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2020-09-01                                   #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2020 by Hiplot Team                   #
# All rights reserved.                                #
#######################################################

pkgs <- c("plotROC", "survivalROC", "grid", "ggplot2")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
}

############# Section 2 #############
#           plot section
#####################################
{
  surv_table <- data
  colnames(surv_table) <- c("surv", "cens", "risk")
  mtime <- as.data.frame(data2)[, 1]
  sroc <- lapply(mtime, function(t) {
    stroc <- survivalROC(
      Stime = surv_table$surv,
      status = surv_table$cens,
      marker = surv_table$risk,
      predict.time = t,
      method = "KM"
    )
    data.frame(
      TPF = stroc[["TP"]],
      FPF = stroc[["FP"]],
      cut = stroc[["cut.values"]],
      time = rep(
        stroc[["predict.time"]],
        length(stroc[["TP"]])
      ),
      AUC = rep(
        stroc$AUC,
        length(stroc$FP)
      )
    )
  })
  mroc <- do.call(rbind, sroc)
  mroc$time <- factor(mroc$time)
  p <- ggplot(
    mroc,
    aes(
      x = FPF,
      y = TPF,
      label = cut,
      color = time
    )
  ) +
    geom_roc(
      labels = FALSE,
      stat = "identity",
      n.cuts = 0
    )

  if (conf$extra$add_ci) {
    p <- p + geom_rocci()
  }

  p <- p + geom_abline(
    slope = 1,
    intercept = 0,
    color = "red",
    linetype = 2
  ) +
    labs(
      title = "ROC Dependence Time",
      x = "False positive rate",
      y = "True positive rate",
      color = paste("Time", "(", conf$extra$time_unit, ")")
    )

  theme2 <- conf$general$theme
  p <- choose_ggplot_theme(p, theme2)

  p <- p + theme(
    text = element_text(
      family = conf$general$font
    ),
    plot.title = element_text(
      size = conf$general$titleSize,
      hjust = 0.5
    ),
    axis.title = element_text(
      size = conf$general$axisTitleSize
    ),
    legend.position = conf$general$legendPos,
    legend.direction = conf$general$legendDir,
    legend.title = element_text(
      size = conf$general$legendTitleSize
    ),
    legend.text = element_text(
      size = conf$general$legendTextSize
    )
  ) +
    # annotate("text",
    #   x = conf$extra$anno_x,
    #   y = conf$extra$anno_y,
    #   color = "black",
    #   label = paste(
    #     "Max AUC = ",
    #     round(max(mroc$AUC), 2)
    #   )
    # ) +
    return_hiplot_palette_color(
      conf$general$palette,
      conf$general$paletteCustom
    )
  auc <- levels(factor(mroc$AUC))
  for (i in 1:length(auc)) {
    p <- p + annotate("text",
      x = conf$extra$anno_x,
      y = conf$extra$anno_y + 0.05 * i, ## 注释text的位置
      col = get_hiplot_color(
        conf$general$palette, 7,
        conf$general$paletteCustom
      )[i],
      label = paste(
        paste(paste(mtime[i], conf$extra$time_unit, sep = " "), " = "),
        round(as.numeric(auc[i]), 2)
      )
    )
  }
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}