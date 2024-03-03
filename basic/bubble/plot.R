#######################################################
# Bubble plot.                                        #
#-----------------------------------------------------#
# Author: < Mingjie Wang > from < Ke Yan Mao >        #
# Affiliation: Shanghai Hiplot Team                   #
# Email: customer_service1501@tengyunbio.com          #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2019-12-10                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2020 by Hiplot Team                   #
# All rights reserved.                                #
#######################################################

pkgs <- c("ggplot2")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  # parse conf file
  label_vars <- c("term", "count", "ratio", "pval")
  for (i in 1:length(conf$dataArg[[1]])) {
    assign(
      label_vars[i],
      conf$dataArg[[1]][[i]]$value
    )
  }
  top_number <- conf$extra$topnum

  data <- data[!is.na(data[, 1]) & !is.na(data[, 2]) &
    !is.na(data[, 3]) & !is.na(data[, 4]), ]
  data <- data[!is.null(data[, 1]) & !is.null(data[, 2]) &
    !is.null(data[, 3]) & !is.null(data[, 4]), ]
  if (top_number >= nrow(data)) {
    top_number <- nrow(data)
  }

  # deal with data
  dat1 <- data[c(1:top_number), ]
  # remove unnecessary words
  dat1[, term] <- capitalize(str_remove(dat1[, term], pattern = "\\w+:\\d+\\W"))
  dat1[, term] <- factor(dat1[, term],
    levels = dat1[, term][length(dat1[, term]):1]
  )
  cols <- c(term, pval, count, ratio)
  dat1 <- dat1[, cols]
  colnames(dat1) <- c("term", "pval", "count", "ratio")
  if (is.character(conf$extra$transform) && conf$extra$transform != "") {
    dat1[, "pval"] <- eval(parse(text = sprintf("%s(dat1[, 'pval'])", conf$extra$transform)))
  }
  for (i in 1:nrow(dat1)) {
    dat1[i, "ratio"] <- eval(parse(text = dat1[i, "ratio"]))
  }
  dat1[, "ratio"] <- sapply(dat1[, "ratio"], function(x) eval(parse(text = x)))
  dat1[, "ratio"] <- as.numeric(dat1[, "ratio"])
  if (is.null(conf$extra$show_percent)) conf$extra$show_percent <- FALSE
  if (conf$extra$show_percent) {
    dat1[, "ratio"] <- dat1[, "ratio"] * 100
  }
}

############# Section 2 #############
#           plot section
#####################################
{
  if (is.null(conf$extra$pq_value) || !is.character(conf$extra$transform)) {
    conf$extra$pq_value <- "P Value"
  }
  if (is.null(conf$extra$transform) || !is.character(conf$extra$transform)) {
    conf$extra$transform <- "-log10"
  }
  if (is.character(conf$extra$transform) && conf$extra$transform != "") {
    cleg <- sprintf("%s (%s)", conf$extra$transform,
        conf$extra$pq_value)
  } else {
    cleg <- conf$extra$pq_value
  }
  p <- ggplot(dat1, aes(ratio, term)) +
    geom_point(aes(size = count, colour = pval)) +
    scale_colour_gradient(low = conf$extra$low_color,
    high = conf$extra$high_color) +
    labs(
      colour = cleg,
      size = count,
      x = ifelse(!conf$extra$show_percent, ratio, paste0(ratio, " (%)")),
      y = term,
      title = conf$general$title
    ) +
    scale_x_continuous(limits = c(0, max(dat1$ratio) * 1.2)) +
    guides(
      color = guide_colorbar(order = 1),
      size = guide_legend(order = 2)) +
      scale_y_discrete(labels = function(x) {str_wrap(x, width = 65)})

  ## add theme
  theme <- conf$general$theme
  p <- choose_ggplot_theme(p, theme)
  p <- set_complex_general_theme(p)
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}
