#######################################################
# Upset plot.                                         #
#-----------------------------------------------------#
# Author: Jianfeng Li                                 #
# Email: lee_jianfeng@hiplot.org                      #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2021-03-15                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2022 by "National Center for          #
# Translational Medicine·Shanghai                     #
# All rights reserved.                                #
#######################################################

# packages section
pkgs <- c("VennDiagram", "ComplexHeatmap", "ggplotify", "ggplot2", "openxlsx")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  # check input data list number
  if (conf$extra$type == "list") {
    for (i in seq_len(ncol(data))) {
      data[is.na(data[, i]), i] <- ""
    }
    data2 <- as.list(data)
    data2 <- lapply(data2, function(x) {x[x != ""]})
    data2 <- list_to_matrix(data2)
  } else {
    row.names(data) <- data[,1]
    data2 <- data[,-1]
  }
  m = make_comb_mat(data2, mode = conf$extra$mode)
  ss = set_size(m)
  cs = comb_size(m)
}

############# Section 2 #############
#           plot section
#####################################
{
  if (conf$extra$reorderSets == "none") {
    set_order <- order(names(ss))
  } else if (conf$extra$reorderSets == "asc") {
    set_order <- order(ss)
  } else {
    set_order <- order(ss, decreasing = TRUE)
  }
  if (conf$extra$reorderComb == "" || conf$extra$reorderComb == "degree-asc") {
    comb_order <- order(comb_degree(m), -cs, decreasing = TRUE)
  } else if (conf$extra$reorderComb == "degree-desc") {
    comb_order <- order(comb_degree(m), -cs)
  } else if (conf$extra$reorderComb == "asc") {
    comb_order <- order(cs)
  } else {
    comb_order <- order(cs, decreasing = TRUE)
  }
  p <- as.ggplot(function(){
    cmd <- sprintf('top_annotation <- HeatmapAnnotation(
      "%s" = anno_barplot(cs, 
          ylim = c(0, max(cs)*1.1),
          border = FALSE, 
          gp = gpar(fill = conf$extra$comBarColor, fontsize = 10), 
          height = unit(5, "cm")
      ), 
      annotation_name_side = "left", 
      annotation_name_rot = 90
    )', conf$extra$combLabel)
    eval(parse(text = cmd))
    cmd <- sprintf('left_annotation <- rowAnnotation(
      "%s" = anno_barplot(-ss,
          axis_param = list(
          at = seq(-max(ss), 0, round(max(ss)/5)),
          labels = rev(seq(0, max(ss), round(max(ss)/5))),
          labels_rot = 0),
          baseline = 0,
          border = FALSE, 
          gp = gpar(fill = conf$extra$setBarColor, fontsize = 10), 
          width = unit(4, "cm")
      ),
      set_name = anno_text(set_name(m), 
          location = 0.5, 
          just = "center",
          width = max_text_width(set_name(m)) + unit(5, "mm")
      )
    )', conf$extra$setsLabel)
    eval(parse(text = cmd))
    ht = UpSet(m,
      comb_col = conf$extra$comColor,
      bg_col = conf$extra$bgCol,
      bg_pt_col = conf$extra$bgPtCol,
      pt_size = unit(conf$extra$ptSize, "mm"),
      lwd = conf$extra$lwd,
      set_order = set_order,
      comb_order = comb_order,
      top_annotation = top_annotation,
      left_annotation = left_annotation, 
      right_annotation = NULL,
      show_row_names = FALSE
    )
      ht = draw(ht)
      od = column_order(ht)
      decorate_annotation(conf$extra$combLabel, {
          grid.text(cs[od], x = seq_along(cs), y = unit(cs[od], "native") + unit(2, "pt"), 
              default.units = "native", just = c("left", "bottom"), 
              gp = gpar(fontsize = 10, col = "#000000",
              fontfamily = conf$general$font), hjust = 0.5)
      })
  })
  p <- p + ggtitle(conf$general$title) + theme(plot.title = element_text(hjust = 0.6))
  data_list <- list()
  for (i in colnames(data2)) {
    data_list[[i]] <- row.names(data2)[data2[,i] == 1]
  }
  print(data_list)
  partitions <- get.venn.partitions(data_list)
  partitions <- partitions[partitions[,ncol(partitions)] != 0,]
  partitions <- partitions[order(partitions[,ncol(partitions)], decreasing = TRUE),]
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
  out_xlsx <- paste(opt$outputFilePrefix, ".xlsx", sep = "")
  write.xlsx(partitions, out_xlsx)
}
