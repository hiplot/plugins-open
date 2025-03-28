#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2022 by "National Center for          #
# Translational Medicine·Shanghai                     #
# All rights reserved.                                #
#######################################################

pkgs <- c("ggplot2")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  # parse conf file
  label_vars <- c("term", "count", "type")
  for (i in 1:length(conf$dataArg[[1]])) {
    assign(
      label_vars[i],
      conf$dataArg[[1]][[i]]$value
    )
  }
  top_number <- conf$extra$topnum

  data <- data[!is.na(data[, 1]) & !is.na(data[, 2]) &
    !is.na(data[, 3]), ]
  data <- data[!is.null(data[, 1]) & !is.null(data[, 2]) &
    !is.null(data[, 3]), ]
  # remove unnecessary words
  data[, term] <- capitalize(str_remove(data[, term], pattern = "\\w+:\\d+\\W"))
  
  if (conf$extra$coord_flip || is.null(conf$extra$coord_flip)) {
    levs <- data[, term][length(data[, term]):1]
  } else {
    levs <- data[, term][1:length(data[, term])]
  }
  data[, term] <- factor(data[, term],
    levels = levs
  )
  data <- data[, c(term, count, type)]
  colnames(data) <- c("term", "count", "type")
  data[, "type"] <- factor(data[, "type"], levels = data[!duplicated(data[, "type"]), "type"])
  data2 <- NULL
  for (i in unique(data[, "type"])) {
    top_number <- conf$extra$topnum
    tmp <- data[data[, "type"] == i,]
    if (conf$extra$topnum >= nrow(tmp)) {
      top_number <- nrow(tmp)
    }
    rownames(tmp) <- 1:nrow(tmp)
    data2 <- rbind(data2, tmp[1:top_number,])
  }
}

############# Section 2 #############
#           plot section
#####################################
{
 p <- ggplot(data = data2, aes(x = term, y = count, fill = type)) +
  geom_bar(stat = "identity", width = 0.8) + 
  theme_bw() +
  xlab(term) +
  ylab(count) +
  guides(fill = guide_legend(title=type)) +
  ggtitle(conf$general$title)

  if (conf$extra$coord_flip || is.null(conf$extra$coord_flip)) {
    p <- p + coord_flip()
  }

  ## add color palette
  p <- p + return_hiplot_palette(conf$general$palette,
    conf$general$paletteCustom)

  ## add theme
  p <- set_complex_general_theme(set_palette_theme(p, conf))
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}
