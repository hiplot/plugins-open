#######################################################
# Diffusion Map                                       #
#-----------------------------------------------------#
# Author: Jianfeng Li                                 #
# Email: lee_jianfeng@hiplot.org                      #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2022-07-09                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2022 by "National Center for          #
# Translational Medicine·Shanghai                     #
# All rights reserved.                                #
#######################################################
pkgs <- c("destiny", "scatterplot3d", "ggpubr", "ggplotify", "openxlsx")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  sample.info <- data2
  rownames(data) <- data[, 1]
  data <- as.matrix(data[, -1])
  ## tsne
  set.seed(123)
  print(conf$extra$perplexity)
  print(conf$extra$theta)
  dm_info <- DiffusionMap(t(data))
  dm_info <- cbind(DC1 = dm_info$DC1, DC2 = dm_info$DC2, DC3 = dm_info$DC3)

  # handle data
  dm_data <- data.frame(
    sample = colnames(data),
    dm_info
  )
  axis <- sapply(conf$dataArg[[1]], function(x) x$value)
  if (is.null(axis[1]) ||
    axis[1] == "") {
    colorBy <- rep('ALL', nrow(sample.info))
  } else {
    colorBy <- sample.info[match(colnames(data), sample.info[, 1]), axis[1]]
    colorBy <- factor(colorBy,
    level = colorBy[!duplicated(colorBy)])
    dm_data$colorBy = colorBy
  }
  if (is.null(axis[2]) ||
    axis[2] == "") {
    shapeBy <- NULL
  } else {
    shapeBy <- sample.info[match(colnames(data), sample.info[, 1]), axis[2]]
    shapeBy <- factor(shapeBy, level = shapeBy[!duplicated(shapeBy)])
    dm_data$shapeBy = shapeBy
  }
}

############# Section 2 #############
#           plot section
#####################################
{
  if (!conf$extra$three_dim) {
    params <- list(data = dm_data, x = "DC1", y = "DC2",
      size = 2, palette = "lancet", alpha = conf$general$alpha)
    if (!is.null(axis[1]) && axis[1] != "") {
      params$color = "colorBy"
    }
    if (!is.null(axis[2]) && axis[2] != "") {
      params$shape = "shapeBy"
    }
    p <- do.call(ggscatter, params) +
      labs(color = axis[1], shape = axis[2]) +
      ggtitle(conf$general$title)
    ## add color palette
    p <- p + return_hiplot_palette_color(conf$general$palette,
        conf$general$paletteCustom) +
      return_hiplot_palette(conf$general$palette,
        conf$general$paletteCustom)
    ## set theme
    theme <- conf$general$theme
    p <- choose_ggplot_theme(p, theme)
    p <- set_complex_general_theme(p)
  } else {
    group.color <- get_hiplot_color(conf$general$palette, -1, conf$general$paletteCustom)
    names(group.color) <- unique(dm_data$colorBy)
    group.color <- group.color[!is.na(names(group.color))]
    if (length(group.color) == 0) {
      group.color <- c(Default="black")
      dm_data$colorBy <- "Default"
    }
    p <- as.ggplot(function(){
      scatterplot3d(x = dm_data$DC1, y = dm_data$DC2, z = dm_data$DC3,
                    color =  alpha(group.color[dm_data$colorBy], conf$general$alpha),
                    xlim=c(min(dm_data$DC1), max(dm_data$DC1)),
                    ylim=c(min(dm_data$DC2), max(dm_data$DC2)),
                    zlim=c(min(dm_data$DC3), max(dm_data$DC3)),
                    pch = 16, cex.symbols  = 0.6,
                    scale.y = 0.8,
                    xlab = "DC1", ylab = "DC2", zlab = "DC3",
                    angle = conf$extra$angle,
                    main = conf$general$title,
                    col.axis = "#444444", col.grid = "#CCCCCC")
      legend("right", legend = names(group.color),
            col = alpha(group.color, 0.8), pch = 16)
    })
    theme <- conf$general$theme
    p <- choose_ggplot_theme(p, theme)
  }
}

############# Section 3 #############
#          output section
#####################################
{
  keep_vars <- c(keep_vars, "dm_data")
  write.xlsx(dm_data, paste0(opt$outputFilePrefix, ".xlsx"))
  export_single(p)
}

