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

pkgs <- c("agmin", "patchwork", "openxlsx")
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
  if (axis[2] != "") {
    data[,axis[2]] <- factor(data[,axis[2]])
  }
  if (axis[3] != "") {
    data$age_cut <- factor(data[,axis[3]])
  }
  facet_var <- NULL
  if (axis[4] != "") {
    facet_var <- axis[4]
    data[,facet_var] <- factor(data[,facet_var])
  }
}

############# Section 2 #############
#           plot section
#####################################
{
  palt <- get_hiplot_color(conf$general$palette,
                      -1, conf$general$paletteCustom)
  lev <- c("all", levels(data[,axis[2]]))
  names(palt)[1:length(lev)] <- lev
  palt <- palt[1:length(lev)]
  p1 <- vis_bar_logic(data, axis[2], facet_var = facet_var,
                      palt = palt,
                      xlab = ifelse(axis[3] == "", "Age groups", axis[3]),
                      negative_flag = conf$extra$negative_flag)
  
  data[,axis[2]] <- as.character(data[,axis[2]])
  data[!data[,axis[2]] %in% conf$extra$bar_val, axis[2]]  <- "0"
  if ("all" %in% conf$extra$bar_val) {
    data_tmp <- data
    data_tmp[data_tmp[,axis[2]] %in% conf$extra$bar_val, axis[2]]  <- "all"
    data <- rbind(data, data_tmp)
  }
  data[data[,axis[2]] %in% conf$extra$negative_flag, axis[2]] <- "0"
  data[,axis[2]] <- factor(data[,axis[2]])
  print(table(data[,axis[2]]))
  params <- list(data,
                age_cut_col = "age_cut",
                age_col = axis[1],
                facet_var = facet_var,
                convert_to_percent = conf$extra$convert_to_percent,
                fill = axis[2],
                palt = palt,
                bar_val = conf$extra$bar_val,
                show_zero = FALSE)

  params$add_param <- list(
    title = paste0(axis[2], "-",
    paste0(conf$extra$bar_val,collapse = "/"), " counts"),
    title_median = FALSE, title_iqr = FALSE, digits = 0)
  p2 <- do.call(vis_bar, params)
  p2 <- p2 + xlab(ifelse(axis[3] == "", "Age groups", axis[3]))
  p2 <- set_complex_general_theme(p2)
}

############# Section 3 #############
#          output section
#####################################
{
  write.xlsx(data, paste0(opt$outputFilePrefix, ".xlsx"))
  export_single(p1 + p2 + plot_annotation(tag_levels = "A"))
}
