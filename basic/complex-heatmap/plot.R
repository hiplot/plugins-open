#######################################################
# ComplexHeatmap.                                     #
#-----------------------------------------------------#
# Author: Jianfeng Li                                 #
# Email: lee_jianfeng@hiplot.org                      #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2020-09-06                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2022 by "National Center for          #
# Translational Medicine·Shanghai                     #
# All rights reserved.                                #
#######################################################

pkgs <- c("ComplexHeatmap", "circlize", "ggplotify", "randomcoloR", "stringr")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  keep_vars_ref <- ls() 
  row.names(data) <- data[, 1]
  data <- data[, -1]
  axis_raw <- conf$dataArg[[1]][[1]][["value"]]
  exp_start_col <- which(colnames(data) == axis_raw[2])
  mut_start_col <- which(colnames(data) == axis_raw[1])
  heat_mat <- as.matrix(t(data[, exp_start_col:ncol(data)]))
  mut_mat <- as.matrix(t(data[, mut_start_col:(exp_start_col - 1)]))
  mut_mat[is.na(mut_mat)] <- ""

  conf$extra$color_key <- str_split(conf$extra$color_key, " |,|;")[[1]]

  cols <- c()
  for (i in 1:nrow(data2)) {
    cols[data2[i,1]] <- data2[i,2]
  }
  col_meta <- list()
  col_meta_pre <- list()
  items <- c()
  for (i in 1:(mut_start_col - 1)) {
    ref <- unique(data[, i])
    ref <- ref[!is.na(ref) & ref != ""]
    if (any(is.numeric(ref)) & length(ref) > 2) {
      col_meta_pre[[colnames(data)[i]]] <- col_fun_cont(data[,i])
    } else if (length(ref) == 2 & any(is.numeric(ref))) {
      col_meta_pre[[colnames(data)[i]]] <- col_tag
      items <- c(items, ref)
    } else if (length(ref) == 2 & any(is.character(ref))) {
      col_meta_pre[[colnames(data)[i]]] <- c("#196ABD", "#C20B01")
      items <- c(items, unique(data[, i]))
    } else if (length(unique(data[, i])) > 2) {
      col_meta_pre[[colnames(data)[i]]] <- distinctColorPalette(
        length(unique(data[, i]))
      )
      items <- c(items, unique(data[, i]))
    }
  }
  meta_mat2 <- NULL
  meta_mat2_unique_names <- c()
  meta_mat2_unique_cols <- c()
  for (i in names(col_meta_pre)) {
    if (!is.function(col_meta_pre[[i]])) {
      meta_mat2_unique_names <- c(meta_mat2_unique_names, i)
      meta_mat2_unique_cols <- c(meta_mat2_unique_cols, col_meta_pre[[i]])
      meta_mat2 <- cbind(meta_mat2, data[, i])
      colnames(meta_mat2)[ncol(meta_mat2)] <- i
    } else {
      col_meta[[i]] <- col_meta_pre[[i]]
    }
  }
  meta_mat2 <- as.matrix(meta_mat2)
  col_meta[["Meta2"]] <- structure(
    names = items[!duplicated(items)],
    meta_mat2_unique_cols[!duplicated(items)]
  )
}

############# Section 2 #############
#           plot section
#####################################
{
  params <- list()
  for (i in names(col_meta)) {
    if (i != "Meta2") {
      params[[i]] <- data[, i]
    }
  }
  params2 <- list(
    Meta2 = meta_mat2,
    gap = 0,
    border = TRUE,
    show_annotation_name = TRUE,
    col = col_meta,
    na_col = "#FFFFFF",
    show_legend = FALSE,
    annotation_legend_param = list(direction = "horizontal")
  )
  for (i in names(params2)) {
    params[[i]] <- params2[[i]]
  }
  ha <- do.call(HeatmapAnnotation, params)
  hlist <- Heatmap(heat_mat,
        col = col_fun_cont(heat_mat, cols = conf$extra$color_key),
        name = "Expression",
        gap = 0,
        clustering_distance_columns = conf$extra$hc_distance_cols,
        clustering_distance_rows = conf$extra$hc_distance_rows,
        clustering_method_columns = conf$extra$hc_method,
        show_row_dend = TRUE, show_column_dend = TRUE,
        show_row_names = FALSE,
        row_title_gp = gpar(col = "#FFFFFF00"),
        cluster_rows = TRUE,
        cluster_columns = TRUE,
        bottom_annotation = ha,
        show_heatmap_legend = TRUE,
        heatmap_legend_param = list(direction = "horizontal")
      )
  p1 <- as.ggplot(
    function() {
      p <- draw(hlist, annotation_legend_side = "right", heatmap_legend_side = "top")
      ggdraw(p)
    }
  )
  idx <- sort(rowSums(!is.na(mut_mat) & mut_mat != "0" & mut_mat != ""), decreasing = TRUE)
  mut_mat <- mut_mat[names(idx),]

  p2 <- as.ggplot(
    function() {
      params <- list(mut_mat,
        get_type = function(x) strsplit(x, "/")[[1]],
        alter_fun = alter_fun, col = cols, row_order = 1:nrow(mut_mat),
        show_column_names = TRUE,
        show_pct = TRUE,
        right_annotation = NULL,
        top_annotation = NULL,
        border = TRUE,
        heatmap_legend_param = list(direction = "horizontal"),
        show_heatmap_legend = FALSE)
      if (conf$extra$sync_mut_order) {
        params$column_order <- unlist(column_order(hlist))
      } else {
        mut_mat2 <- mut_mat
        for (i in 1:ncol(mut_mat)) {
          mut_mat2[,i] <- sapply(strsplit(mut_mat2[,i], "/"), function(x) {
            if (length(x) == 0) return (0)
            if (is.na(x) | x == "0" | x == '') return (0)
            y <- cols[names(cols) %in% unique(mut_mat)]
            x <- sort(unique(x), decreasing = TRUE)
            sum(match(x, names(y))^2, na.rm = TRUE)
          })
        }
        storage.mode(mut_mat2) <- "numeric"
        cmd <- "mut_mat[,order(%s, decreasing = TRUE)]"
        vnames <- c()
        for (i in 1:nrow(mut_mat)) {
          vnames <- c(vnames, sprintf("as.numeric(mut_mat2[%s,])", i))
        }
        cmd <- sprintf(cmd, paste0(vnames, collapse = ","))
        mut_mat2 <- eval(parse(text = cmd))
        params$column_order = match(colnames(mut_mat2), colnames(mut_mat))
      }
      p <- draw(do.call(oncoPrint, params), annotation_legend_side = "bottom", heatmap_legend_side = "bottom")
      ggdraw(p)
    }
  )

  p3 <- as.ggplot(function() {
    legend_tmp <- list()
    for (i in names(col_meta_pre)) {
      if (is.function(col_meta_pre[[i]])) {
        legend_tmp[[i]] <- Legend(
          col_fun = col_meta_pre[[i]],
          title = i, direction = "horizontal"
        )
      } else if (identical(col_meta_pre[[i]], col_tag)) {
        legend_tmp[[i]] <- Legend(
          at = unique(data[, i]), title = i,
          direction = "horizontal",
          labels = c("No", "Yes"),
          legend_gp = gpar(fill = col_meta_pre[[i]])
        )
      } else {
         legend_tmp[[i]] <- Legend(
          at = unique(data[, i]), title = i,
          direction = "horizontal",
          legend_gp = gpar(fill = col_meta_pre[[i]])
        )
      }
    }
    ref_mut <- unique(unlist(str_split(mut_mat, "/")))
    ref_mut <- ref_mut[ref_mut != "" & ref_mut != "NANA"]
    ref_mut <- ref_mut[!is.na(ref_mut)]
    lgd_mut <- Legend(
      at = ref_mut, title = "Mutations",
      direction = "horizontal",
      legend_gp = gpar(fill = cols[ref_mut])
    )
    legend_tmp[[length(legend_tmp) + 1]] <- lgd_mut
    legend_tmp$direction <- "horizontal"
    legend_tmp$max_width <- unit(14, "cm")
    legend_tmp$column_gap <- unit(5, "mm")
    legend_tmp$row_gap <- unit(0.5, "cm")
    p <- do.call(packLegend, legend_tmp)
    ggdraw(draw(p))
  })
  conf$extra$rel_height <- as.numeric(str_split(conf$extra$rel_height, ", |,| |;")[[1]])
  p <- plot_grid(p1, p2, p3, ncol = 1, rel_heights = conf$extra$rel_height)
  keep_vars_ref2 <- ls()
  keep_vars <- c(keep_vars, keep_vars_ref2[!keep_vars_ref2 %in% keep_vars_ref])
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}
