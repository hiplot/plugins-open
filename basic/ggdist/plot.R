#######################################################
# ggdist charts.                                      #
#-----------------------------------------------------#
# Author: Jianfeng Li                                 #
# Email: lee_jianfeng@hiplot.org                      #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2020-08-13                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2022 by "National Center for          #
# Translational Medicine·Shanghai                     #
# All rights reserved.                                #
#######################################################

pkgs <- c("ggdist", "tidyr", "broom", "modelr", "ggplot2")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  if (!is.numeric(data[, 1])) {
    data[, 1] <- factor(data[, 1], levels = rev(unique(data[, 1])))
  }
  data <- tibble(data)
  eval(parse(text = sprintf(
    "data2 = lm(%s ~ %s, data = data)",
    colnames(data)[2], colnames(data)[1]
  )))
}

############# Section 2 #############
#           plot section
#####################################
{
  theme_set(theme_ggdist())
  data3 <- eval(parse(text = sprintf(
    "data_grid(data, %s)",
    colnames(data)[1]
  ))) %>%
    augment(data2, newdata = ., se_fit = TRUE)
  p <- ggplot(data3, aes_(y = as.name(colnames(data[1])))) +
    stat_dist_halfeye(
      aes(
        dist = "student_t", arg1 = df.residual(data2),
        arg2 = .fitted, arg3 = .se.fit
      ),
      scale = .5
    ) +
    geom_point(aes_(x = as.name(colnames(data[2]))),
      data = data, pch = "|", size = 2,
      position = position_nudge(y = -.15)
    )

  p <- p + ggtitle(conf$general$title)
  p <- p + xlab(colnames(data)[2]) + ylab(colnames(data)[1])
  p <- set_complex_general_theme(set_palette_theme(p, conf))
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}
