#######################################################
# Agmin-MAF.                                          #
#-----------------------------------------------------#
# Author: Jianfeng Li                                 #
# Email: lee_jianfeng@hiplot.org                      #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2024-03-09                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2022 by "National Center for          #
# Translational Medicine·Shanghai                     #
# All rights reserved.                                #
#######################################################

pkgs <- c("agmin", "patchwork", "openxlsx", "sigminer")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  axis <- as.character(sapply(conf$dataArg[[1]], function(x) x$value))
  axis2 <- as.character(sapply(conf$dataArg[[2]], function(x) x$value))
  data$age_cut <- ag_cut(data[, axis[1]],
    low_breaks = conf$general$lowAgeBreaks,
    high_breaks = conf$general$highAgeBreaks,
    interval = conf$general$ageInterval,
    to_char = conf$general$ageToChar
  )
  if (axis[2] != "") {
    data$age_cut <- factor(data[,axis[2]])
    group <- "age_cut"
  } else {
    group <- "age_cut"
  }
  facet_var <- NULL
  if (axis[3] != "") {
    facet_var <- axis[3]
    data[,facet_var] <- factor(data[,facet_var])
  }

  gene <- axis2[1]
  gene_class <- axis2[2]
  palt <- data3[,2]
  names(palt) <- data3[,1]

  row.names(data) <- data[,1]
  data2 <- data2[!data2[,axis2[2]] %in% conf$extra$omit_type,]
  palt_hiplot <- get_hiplot_color(conf$general$palette, -1,
      conf$general$paletteCustom)
}

############# Section 2 #############
#           plot section
#####################################
{
  p <- NULL
  if ("bar_total" %in% conf$extra$mode) {
    p <- vis_mutc_bar(data2,palt = palt,
      sample_id = colnames(data2)[1], gene = gene, type = gene_class) +
      theme(legend.position = "top")
  } else if ("bar_by_group" %in% conf$extra$mode) {
    for(i in levels(data$age_cut)) {
      ptmp <- vis_mutc_bar(data2[data2[,1] %in% data[data$age_cut == i,1],],
        palt = palt,
        sample_id = colnames(data2)[1], gene = gene, type = gene_class) + ggtitle(i)
      if ("bar_total" %in% conf$extra$mode) {
        ptmp <- ptmp + theme(legend.position = "none") + ylab("")
      }
      if (is.null(p)) {
        p <- ptmp + theme(legend.position = "top")
      } else {
        p <- p + ptmp + theme(legend.position = "none")
      }
    }
    if (length(unique(data$age_cut)) > 2) {
      p <- p + plot_layout(ncol = 2)
    }
    p <- p + plot_annotation(tag_level = "A")
  } else if ("scatter_age_cor_by_group" %in% conf$extra$mode) {
    if (axis[3] == "") {
      data2[,"facet_var"] <- "all"
      axis[3] = "facet_var"
    }
    row.names(data) <- data[,1]
    p <- vis_mutc_scatter(data, data2,
      age = axis[1],
      fill = ifelse(axis[3] == "facet_var", palt_hiplot[1], axis[3]),
      facet_var = axis[3],
      sample_id = colnames(data2)[1],
    gene = gene, type = gene_class)
  } else if (conf$extra$mode %in% c("boxplot_mutc_by_group") ) {
    p <- vis_mutc_boxplot(data, data2,
      age = axis[1],
      fill = group,
      facet_var = axis[3],
      sample_id = colnames(data2)[1],
    gene = gene, type = gene_class)
  } else if (conf$extra$mode %in% c("percent_mutc_by_group")) {
    row.names(data) <- data[,1]
    p <- vis_mutc_percent(data, data2,
      age = axis[1],
      y_axis = group,
      facet_var = axis[3],
      palt = palt_hiplot,
      sample_id = colnames(data2)[1],
    gene = gene, type = gene_class,
    logist_mutc = conf$extra$logist_mutc)
  } else if (conf$extra$mode %in% c("line_rate_by_group")) {
    p <- vis_mut_line(data, data2,
      age = axis[1],
      fill = axis[3],
      sample_id = colnames(data2)[1],
    gene = gene, type = gene_class)
  } else if (conf$extra$mode %in% "show_group_distribution") {
    data2_gridplot <- data2[!duplicated(paste0(data2[,1], data2[,axis2[1]])),]
    data2_gridplot$age <- data[match(data2_gridplot[,1],
      row.names(data)), axis[1]]
    p <- show_group_distribution(
      data2_gridplot,
      gvar = axis2[1], 
      dvar = "age",
      order_by_fun = TRUE,
      nrow = round(length(unique(data2_gridplot[,axis2[1]])) / 12, 0)
    ) +
      theme(panel.border = element_blank())
  }
  
  if (conf$extra$mode %in% c("scatter_age_cor",
      "boxplot_mutc_by_group", "percent_mutc_by_group",
      "line_rate_by_group")) {
    p <- p + return_hiplot_palette_color(conf$general$palette,
      conf$general$paletteCustom) +
    return_hiplot_palette(conf$general$palette,
      conf$general$paletteCustom)
  }
  p <- set_complex_general_theme(p)
  
  if (conf$extra$mode == "show_group_distribution") p <- p + theme(axis.text.x = element_blank())
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}
