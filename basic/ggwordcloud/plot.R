#######################################################
# Wordcloud plot.                                     #
#-----------------------------------------------------#
# Author: Jianfeng Li                                 #
# Email: lee_jianfeng@hiplot.org                      #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2020-08-16                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2022 by "National Center for          #
# Translational Medicine·Shanghai                     #
# All rights reserved.                                #
#######################################################

pkgs <- c("ggwordcloud", "randomcoloR")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  row.names(data) <- data[, 1]
  if (ncol(data) == 1 || (ncol(data) > 1 && all(is.na(data[, 2])))) {
    data <- as.data.frame(table(data[, 1]))
  }
  inmask <- NULL
  if (conf$data$inmask$link != "") {
    inmask <- parse_file_link(conf$data$inmask$link)
  }
}

############# Section 2 #############
#           plot section
#####################################

if (!conf$extra$gradient) {
  col <- as.factor(data[, 2])
} else {
  col <- data[, 2]
}

data <- cbind(data, col)

p <- ggplot(
  data,
  aes_(
    label = as.name(colnames(data)[1]), size = as.name(colnames(data)[2]),
    color = col
  )
) +
  scale_size_area(max_size = 40) +
  theme_minimal()

if (!is.null(inmask)) {
  p <- p + geom_text_wordcloud_area(
    mask = png::readPNG(inmask),
    rm_outside = TRUE
  )
} else {
  p <- p + geom_text_wordcloud_area(rm_outside = TRUE)
}

if (conf$extra$gradient) {
  p <- p + scale_color_gradient(low = conf$extra$glow, high = conf$extra$ghigh)
} else {
  palette <- distinctColorPalette(length(unique(data[, 2])))
  ref_cols <- get_hiplot_color(conf$general$palette, 15,
  conf$general$paletteCustom)
  palette[(length(palette) - length(ref_cols)):length(palette)]
  if (length(palette) > 15) {
    background_len <- 1:(length(palette) - 15)
    palette[background_len] <- colorRampPalette(c(
      "#5859A6",
      "#8687D8"
    ))(length(background_len))
  }
  p <- p + scale_color_manual(values = palette)
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}
