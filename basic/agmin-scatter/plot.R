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

pkgs <- c("agmin", "patchwork", "openxlsx", "ggpubr")
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
    data[, axis[2]] <- as.numeric(data[, axis[2]])
    data[, axis[2]] <- transform_val(conf$general$transformY, data[, axis[2]])
  }
  if (axis[3] != "") {
    data$age_cut <- factor(data[, axis[3]])
  }
  facet_var <- NULL
  if (axis[4] != "") {
    facet_var <- axis[4]
    data[, facet_var] <- factor(data[, facet_var])
  }
}

############# Section 2 #############
#           plot section
#####################################
{
  p <- ggscatter(data, x = axis[1], y=axis[2], size = 0.5, color = "age_cut") + 
    xlab(axis[1]) + ylab(axis[2]) + 
    geom_smooth(method = 'lm', formula = y~x, se = TRUE, show.legend = FALSE) +
    stat_cor(aes(label = paste(..r.label.., ..p.label.., sep = '~`,`~')), 
             method = conf$extra$stat_method,
             label.x.npc = 'left', label.y.npc = 'top', size = 4) +
    theme_bw()

  if (!is.null(facet_var)) {
    p <- p + eval(parse(text = sprintf("facet_wrap(~%s)", facet_var)))
  }
  p <- p + return_hiplot_palette_color(
    conf$general$palette,
    conf$general$paletteCustom
  ) +
    return_hiplot_palette(
      conf$general$palette,
      conf$general$paletteCustom
    )
  p <- set_complex_general_theme(set_palette_theme(p, conf))
}

############# Section 3 #############
#          output section
#####################################
{
  write.xlsx(data, paste0(opt$outputFilePrefix, ".xlsx"))
  export_single(p + plot_annotation(tag_levels = "A"))
}
