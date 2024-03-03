#######################################################
# Survival analysis.                                  #
#-----------------------------------------------------#
# Author: < Mingjie Wang > from < Ke Yan Mao >        #
# Affiliation: Shanghai Hiplot Team                   #
# Email: customer_service1501@tengyunbio.com          #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2019-11-28                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2020 by Hiplot Team                   #
# All rights reserved.                                #
#######################################################
pkgs <- c("survminer", "survival", "ggplotify")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  colnames(data) <- c("Time", "Status", "Group")

  # survival plot
  data[,1] <- as.numeric(data[,1])
  fit <- survfit(Surv(Time, Status == 1) ~ Group, data = data)
  theme <- conf$general$theme
  theme <- choose_ggplot_theme2(theme)
  data <- data[data[,1] < conf$extra$xlim_end,]
}

############# Section 2 #############
#           plot section
#####################################
{
  if (is.null(conf$extra$line_size)) {
    conf$extra$line_size <- 1
  }
  if (is.null(conf$extra$func)) {
    conf$extra$func <- conf$extra[["function"]]
  }
  params <- list(
      fit, # survfit object with calculated statistics.
      data = data, # data used to fit survival curves.
      risk.table = conf$extra$risk_table, # show risk table.
      pval = conf$extra$pval, # show p-value of log-rank test.
      conf.int = conf$extra$intervals,
      # show confidence intervals for point estimates of survival curves.
      fun = conf$extra$func,
      size = conf$extra$line_size,
      # survival estimates.
      xlab = conf$extra$xlab,
      ylab = conf$extra$ylab,
      ggtheme = theme, # customize plot and risk table with a theme.
      risk.table.y.text.col = TRUE, # colour risk table text annotations.
      risk.table.height = conf$extra$risk_table_height, # the height of the risk table
      risk.table.y.text = conf$extra$risk_table_y_text,
      # show bars instead of names in text annotations in legend of risk table.
      ncensor.plot = conf$extra$ncensor_plot, # plot the number of censored subjects at time t
      ncensor.plot.height = conf$extra$ncensor_plot_height,
      conf.int.style = conf$extra$conf_int_style, # customize style of confidence intervals
      surv.median.line = conf$extra$surv_median_line, # add the median survival pointer.
      palette = get_hiplot_color(conf$general$palette, -1,
        conf$general$paletteCustom),
      xlim = c(conf$extra$xlim_start, conf$extra$xlim_end),
      ylim = c(conf$extra$ylim_start, conf$extra$ylim_end),
      break.x.by = conf$extra$break_x
    )
    p <- as.ggplot(function(){
      print(do.call(ggsurvplot, params))
    })
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}
