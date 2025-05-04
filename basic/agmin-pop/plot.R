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
  data[,"age"] <- as.numeric(data[,axis[1]])
  data$age_cut <- ag_cut(data[, axis[1]],
    low_breaks = conf$general$lowAgeBreaks,
    high_breaks = conf$general$highAgeBreaks,
    interval = conf$general$ageInterval,
    to_char = conf$general$ageToChar
  )
  if (axis[2] != "") {
    data$age_cut <- factor(data[,axis[2]])
  }
  facet_var <- NULL
  if (axis[3] != "") {
    facet_var <- axis[3]
    data[,facet_var] <- factor(data[,facet_var])
  }
}

############# Section 2 #############
#           plot section
#####################################
{
  p1 <- vis_hist(data, facet_var = facet_var, fill = conf$extra$fill)
  p1 <- set_complex_general_theme(p1)
  params <- list(data, age_cut_col = "age_cut",
                age_col = "age",
                facet_var = facet_var,
                palt = conf$extra$fill)
  if (axis[2] != "") {
    params$add_param <- list(title = paste0(axis[2], " counts"),
    title_median = FALSE, title_iqr = FALSE, digits = 0)
    p2 <- do.call(vis_bar, params)
    p2 <- p2 + xlab(axis[2])
  } else {
    p2 <- do.call(vis_bar, params)
  }
  p2 <- set_complex_general_theme(p2)
}

############# Section 3 #############
#          output section
#####################################
{
  write.xlsx(data, paste0(opt$outputFilePrefix, ".xlsx"))
  export_single(p1 + p2 + plot_annotation(tag_levels = 'A') + plot_layout(ncol = ifelse(is.null(facet_var), 2, 1)))
}
