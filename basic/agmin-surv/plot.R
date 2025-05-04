#######################################################
# Agmin                                               #
#-----------------------------------------------------#
# Author: Jianfeng Li                                 #
# Email: lee_jianfeng@openbiox.org                    #
#                                                     #
# Date: 2024-03-05                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2024 by "National Center for          #
# Translational Medicine·Shanghai                     #
# All rights reserved.                                #
#######################################################

pkgs <- c("agmin", "patchwork", "openxlsx", "ggplotify")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  axis <- as.character(sapply(conf$dataArg[[1]], function(x) x$value))
  data$age_cut <- ag_cut(data[, axis[1]],
    low_breaks = conf$general$lowAgeBreaks,
    high_breaks = conf$general$highAgeBreaks,
    interval = conf$general$ageInterval,
    to_char = conf$general$ageToChar
  )
  colnames(data)[which(colnames(data) == axis[2])] <- "os"
  colnames(data)[which(colnames(data) == axis[3])] <- "os_status"
  if (axis[4] != "") {
    data$age_cut <- factor(data[, axis[4]])
  }
  facet_var <- NULL
  if (axis[5] != "") {
    facet_var <- axis[5]
    data[, facet_var] <- factor(data[, facet_var])
  }
}

############# Section 2 #############
#           plot section
#####################################
{
  if (conf$general$palette == "default") {
    palt <- ag_col()
  } else {
    palt <- get_hiplot_color(
      conf$general$palette,
      -1, conf$general$paletteCustom
    )
  }
  names(palt) <- levels(data$age_cut)

  if (is.null(facet_var)) {
    p <- as.ggplot(function() {
      print(vis_surv(data, palt = palt,
            leg_labs = levels(data[, "age_cut"]),
            break.x.by = conf$extra$break_x,
            break_y = conf$extra$break_y,
            fun = conf$extra$func,
            xlab = conf$extra$xlab,
            ylab = conf$extra$ylab,
            xlim = c(conf$extra$xlim_start, conf$extra$xlim_end),
            ylim = c(conf$extra$ylim_start, conf$extra$ylim_end),
            line_size = conf$extra$line_size,
            surv_median_line = conf$extra$surv_median_line))
    })
  } else {
    p <- NULL
    for (i in unique(data[, facet_var])) {
      data_subset <- data[data[, facet_var] == i, ]
      data_subset[, "age_cut"] <- factor(data_subset[, "age_cut"])
      ptmp <- as.ggplot(function() {
        print(
          vis_surv(data_subset, palt = palt, 
            leg_labs = levels(data_subset[, "age_cut"]),
            break.x.by = conf$extra$break_x,
            break_y = conf$extra$break_y,
            fun = conf$extra$func,
            xlab = conf$extra$xlab,
            ylab = conf$extra$ylab,
            xlim = c(conf$extra$xlim_start, conf$extra$xlim_end),
            ylim = c(conf$extra$ylim_start, conf$extra$ylim_end),
            line_size = conf$extra$line_size,
            surv_median_line = conf$extra$surv_median_line
          ) + ggtitle(sprintf("%s-%s", facet_var, i))
        )
      })
      if (is.null(p)) {
        p <- ptmp
      } else {
        p <- p + ptmp
      }
    }
  }
}

############# Section 3 #############
#          output section
#####################################
{
  write.xlsx(data, paste0(opt$outputFilePrefix, ".xlsx"))
  export_single(p)
}
