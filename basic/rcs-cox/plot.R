#######################################################
#     RCS-cox                                         #
#-----------------------------------------------------#
# Author: Houshi Xu                                   #
#                                                     #
# Email: houshi@sjtu.edu.cn                           #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2020-09-29                                    #
# Version: 0.2                                        #
# 增加协变量                                           #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2020 by Hiplot Team                   #
# All rights reserved.                                #
#######################################################

############# Section 1 ##########################
# input options, data and configuration section
##################################################
pkgs <- c("rms", "survival", "ggplot2")
pacman::p_load(pkgs, character.only = TRUE)

{
  label_vars <- c("main", "time", "event")

  for (i in seq_len(length(conf$dataArg[[1]]))) {
    assign(label_vars[i], conf$dataArg[[1]][[i]]$value)
  }

  cutoff_value <- conf$extra[["cutoff"]]

  colnames(data)[which(colnames(data) == main)] <- "main"
  colnames(data)[which(colnames(data) == time)] <- "time"
  colnames(data)[which(colnames(data) == event)] <- "event"
}
############# Section 2 #############
#           plot section
#####################################
{
  data <- na.omit(data)
  ex <- set::not(colnames(data), c("main", "time", "event"))
  ex <- str_c(ex, collapse = "+")
  dd <<- datadist(data)
  options(datadist = "dd")

  for (i in 3:5) {
    fit <- coxph(as.formula(paste0("Surv(time, event) ~ rcs(main, nk = i, inclx = T)+", ex, collapse = "+")),
      data = data, x = TRUE
    )
    tmp <- extractAIC(fit)
    if (i == 3) {
      AIC <- tmp[2]
      nk <<- 3
    }
    if (tmp[2] < AIC) {
      AIC <- tmp[2]
      nk <<- i
    }
  }
  fit <- cph(as.formula(paste0("Surv(time, event) ~ rcs(main, nk = nk, inclx = T)+", ex, collapse = "+")),
    data = data, x = TRUE
  )
  # cutoff_value = "Median"
  # 设定参考值 默认Median
  if (cutoff_value == "Median") {
    dd$limits$main[2] <- median(data$main)
  } else if (cutoff_value == "Define") {
    dd$limits$main[2] <- conf$extra$define
  }
  fit <- update(fit)
  orr <- Predict(fit, main, fun = exp, ref.zero = TRUE)
  p <- ggplot() +
    geom_line(
      data = orr,
      aes(main, yhat), linetype = "solid",
      size = 1, alpha = 1, colour = conf$extra$line_color
    ) +
    geom_ribbon(
      data = orr, aes(main, ymin = lower, ymax = upper),
      alpha = conf$general$alpha, fill = conf$extra$ribbon_color
    ) +
    geom_hline(yintercept = 1, linetype = 2, size = 0.5) +
    geom_vline(xintercept = dd$limits$main[2], linetype = 2, size = 0.5) +
    labs(x = " ", y = "Hazard Ratio(95%CI)") +
    ggtitle(conf$general$title)
  ## set theme
  p <- set_complex_general_theme(set_palette_theme(p, conf))
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}
