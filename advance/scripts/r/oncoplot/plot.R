#######################################################
# Oncoplot.                                           #
#-----------------------------------------------------#
# Author: Jianfeng Li                                 #
# Email: lee_jianfeng@hiplot.org                      #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2021-11-22                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2022 by "National Center for          #
# Translational Medicine·Shanghai                     #
# All rights reserved.                                #
#######################################################

pkgs <- c("ComplexHeatmap", "circlize",
  "ggplotify", "randomcoloR", "cowplot", "ggplot2", "tidyverse", "dplyr",
  "patchwork", "openxlsx")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  cols <- c()
  geneclass <- unlist(conf$dataArg[[1]][[1]]$value)
  sampleclass <- unlist(conf$dataArg[[2]][[1]]$value)
  data[,"Hugo_Symbol"] <- data[,unlist(conf$dataArg[[1]][[2]]$value)]
  data[,"Variant_Classification"] <- data[,unlist(conf$dataArg[[1]][[3]]$value)]

  data <- data[!data$Variant_Classification %in% conf$extra$omit_classification,]
  data <- data[data$Tumor_Sample_Barcode %in% data2[,1],]
  data$idx <- paste(data[,1], data[,2], data[,3], sep = "_")
  conf$extra$gene_class_order <- unlist(conf$extra$gene_class_order)
  conf$extra$white_genes <- unlist(conf$extra$white_genes)

  for (i in 1:nrow(data3)) {
    cols[data3[i,1]] <- data3[i,2]
  }
  x <- paste0(data$Tumor_Sample_Barcode, data$Hugo_Symbol)
  x <- !duplicated(x)
  fil <- sort(table(data$Hugo_Symbol[x]), decreasing = TRUE)
  res <- names(fil)[(fil >= conf$extra$min_mut_num) | (names(fil) %in% conf$extra$white_genes)]
  has_sampleclass <- length(sampleclass) > 0 && sampleclass != ""
  has_geneclass <- length(geneclass) > 0 && geneclass != ""
  
  genes <- res
  samples <- data2[,1]

  mutdat <- NULL
  smap <- c("two_hit", "three_hit", "four_hit", "more_than_four_hit")
  names(smap) <- 1:4
  for (i in genes) {
    tmp <- rep(0, length(samples))
    tmp_mut <- data[data$Hugo_Symbol == i,]
    for(k in 1:length(samples)) {
      s <- paste0(tmp_mut$Variant_Classification[tmp_mut$Tumor_Sample_Barcode == samples[k]], 
                  collapse = '/')
      x <- str_count(s, "/")
      if (conf$extra$merge_multi_hit && x != 0) {
        s <- "Multi_Hit"
      } else if (conf$extra$merge_multi_hit_count && x != 0) {
        if (x %in% names(smap)) {
          s <- smap[x]
        } else {
          s <- "more_than_four_hit"
        }
      }
      tmp[k] <- s
    }
    tmp[tmp == ''] <- '0'
    mutdat <- rbind(mutdat, tmp)
    rownames(mutdat)[nrow(mutdat)] <- i
  }
  mutdat <- as.data.frame(mutdat)
  colnames(mutdat) <- samples
  row.names(data2) <- data2[,1]

  col_meta <- list()
  col_meta_pre <- list()
  for (i in c(2:ncol(data2))) {
    ref <- unique(data2[, i])
    ref <- ref[!is.na(ref) & ref != ""]
    if (any(is.numeric(ref)) & length(ref) > 2) {
      data2[is.infinite(data2[,i]) ,i] <- NA
      col_meta_pre[[colnames(data2)[i]]] <- col_fun_cont(data2[,i])
    } else if (length(ref) == 2 & any(is.numeric(ref))) {
      col_meta_pre[[colnames(data2)[i]]] <- col_tag
      names(col_meta_pre[[colnames(data2)[i]]]) <- sort(ref)
    } else if (length(ref) == 2 & any(is.character(ref))) {
      col_meta_pre[[colnames(data2)[i]]] <- c("#196ABD", "#C20B01")
      names(col_meta_pre[[colnames(data2)[i]]]) <- ref
    } else if (length(unique(data2[, i])) > 2) {
      col_meta_pre[[colnames(data2)[i]]] <- distinctColorPalette(
        length(unique(data2[, i]))
      )
      names(col_meta_pre[[colnames(data2)[i]]]) <- sort(ref)
      data2[, i] <- factor(data2[, i], levels = sort(ref))
    }
    x <- names(col_meta_pre[[colnames(data2)[i]]])
    x <- is.na(x)
    if(any(x)) {
      col_meta_pre[[colnames(data2)[i]]] <- col_meta_pre[[colnames(data2)[i]]][!x]
    }
    x <- col_meta_pre[[colnames(data2)[i]]]
    if (is.character(x) && any(names(x) %in% data3[,1])) {
      idx <- match(names(x), data3[,1])
      idx <- idx[!is.na(idx)]
      if (length(idx) > 0)
        col_meta_pre[[colnames(data2)[i]]][!is.na(idx)] <- data3[idx,2]
    }
  }
}

############# Section 2 #############
#           plot section
#####################################
{
  mutdat_tmp <- NULL
  if (str_detect(conf$extra$order_mode, "pathway_first")) {
    data[is.na(data[,geneclass]),geneclass] <- "Other"
    if (length(conf$extra$gene_class_order) > 0) {
      for (i in conf$extra$gene_class_order) {
        idx <- data[,geneclass] == i
        fil <- row.names(mutdat)[row.names(mutdat) %in% data[idx, "Hugo_Symbol"]]
        mutdat_tmp <- rbind(mutdat_tmp, mutdat[fil,])
      }
    } else {
      for (i in unique(data[,geneclass])) {
        idx <- data[,geneclass] == i
        fil <- row.names(mutdat)[row.names(mutdat) %in% data[idx, "Hugo_Symbol"]]
        mutdat_tmp <- rbind(mutdat_tmp, mutdat[fil,])
      }
    }
  } else {
    idx <- sort(rowSums(mutdat != "0"), decreasing = TRUE)
    mutdat_tmp <- mutdat[names(idx),]
  }
  mutdat <- as.matrix(mutdat_tmp)
  mutdat2 <- mutdat
  if (!str_detect(conf$extra$order_mode, "simple")) {
    for (i in 1:ncol(mutdat2)) {
      mutdat2[,i] <- sapply(strsplit(mutdat2[,i], "/"), function(x) {
        if (x == "0") return (0)
        y <- cols[names(cols) %in% unique(mutdat)]
        x <- sort(unique(x), decreasing = TRUE)
        sum(match(x, names(y))^2, na.rm = TRUE)
      })
    }
    storage.mode(mutdat2) <- "numeric"
    cmd <- "mutdat[,order(%s, decreasing = TRUE)]"
    vnames <- c()
    for (i in 1:nrow(mutdat)) {
      vnames <- c(vnames, sprintf("as.numeric(mutdat2[%s,])", i))
    }
  } else {
    mutdat2[mutdat2 != 0] <- 1
    cmd <- "mutdat[,order(%s, decreasing = TRUE)]"
    vnames <- c()
    for (i in 1:nrow(mutdat)) {
      vnames <- c(vnames, sprintf("mutdat2[%s,]", i))
    }
  }

  cmd <- sprintf(cmd, paste0(vnames, collapse = ","))
  mutdat <- eval(parse(text = cmd))
  mutdat <- as.data.frame(mutdat)
  if (conf$extra$add_pathway_row) {
    if(length(conf$extra$gene_class_order) > 0) {
      x <- conf$extra$gene_class_order
    } else {
      x <- unique(data[,geneclass])
    }
    for (i in x) {
      idx <- data[,geneclass] == i
      tmp <- as.matrix(mutdat[unique(data[idx, "Hugo_Symbol"]),])
      tmp <- tmp[!is.na(tmp[,1]),]
      tmp[tmp != "0"] <- 1
      storage.mode(tmp) <- "numeric"
      if (is.null(nrow(tmp))) {
        v <- tmp
      } else {
        v <- colSums(tmp)
      }
      v2 <- v
      v[as.numeric(v) == 1] <- "one_hit"
      for (j in names(smap)) {
        v[as.numeric(v2) == (as.numeric(j) + 1)] <- smap[j]
      }
      v[as.numeric(v2) > 4] <- smap[4]
      mutdat <- rbind(mutdat, v)
      row.names(mutdat)[nrow(mutdat)] <- i
    }
  }
  mutdat <- as.matrix(mutdat)

  if (has_geneclass) {
    x <- data[!duplicated(paste0(data$Hugo_Symbol, data[,geneclass])), ]
    x <- x[x$Hugo_Symbol %in% rownames(mutdat),]
    x <- x[match(rownames(mutdat), x$Hugo_Symbol),]
    if (length(conf$extra$gene_class_order) > 0) {
      x[,geneclass] <- factor(x[,geneclass], unique(c(conf$extra$gene_class_order, "Other", "Pathway")))
    } else {
      x[,geneclass] <- factor(x[,geneclass], unique(c(x[,geneclass], "Other", "Pathway")))
    }
    row_split <- x[,geneclass]
    row_split[is.na(row_split) & row.names(mutdat) %in% unique(data[,geneclass])] <- "Pathway"
    row_split[is.na(row_split)] <- "Other"
  }
  params <- list(mutdat,
              get_type = function(x) {if (x != "0") strsplit(x, "/")[[1]]},
              alter_fun = alter_fun, col = cols, row_order = 1:nrow(mutdat),
              column_order = 1:ncol(mutdat), show_column_names = TRUE,
              show_pct = conf$extra$show_pct,
              border = conf$extra$border,
              #column_labels = rep("", ncol(mutdat)),
              show_heatmap_legend = FALSE,
              pct_gp = gpar(fontsize = conf$extra$fontsizePct),
              column_names_gp = gpar(fontsize = conf$general$fontsizeCol),
              row_names_gp = gpar(fontsize = conf$general$fontsizeRow)
  )
  if (has_sampleclass) {
    params$column_split = data2[colnames(mutdat), sampleclass]
    if (length(conf$extra$sample_class_order) > 0) {
      params$column_split <- factor(params$column_split, levels = conf$extra$sample_class_order)
    } else {
      params$column_split <- factor(params$column_split, levels = unique(params$column_split))
    }
  }
  if (has_geneclass) {
    params$row_split = row_split
  }
  if (conf$extra$order_mode == "raw") {
    params$column_order <- match(data2[,1], colnames(mutdat))
  }
  if (conf$extra$symbol_side == "left") {
    params$row_names_side <- "left"
    params$pct_side <- "right"
  } else {
    params$row_names_side <- "right"
    params$pct_side <- "left"
  }
  if (conf$extra$top_annotation == "none") {
    params["top_annotation"] <- list(NULL)
  }
  if (conf$extra$right_annotation == "none") {
    params["right_annotation"] <- list(NULL)
  }
  params2 <- list()
  for (i in 2:ncol(data2)) {
    params2[[colnames(data2)[i]]] <- data2[colnames(mutdat),i]
  }
  params2$col <- col_meta_pre
  params2$show_legend <- FALSE
  ha <- do.call(HeatmapAnnotation, params2)

  params$bottom_annotation <- ha
  ocp <- do.call(oncoPrint, params)
  df <- get_variant_group_freq(data, params, mutdat)
  cols_label <- c(unique(data$Variant_Classification), "Multiple", "Negative")
  print(df)
  if (!is.null(conf$extra$draw_pie_matrix) && conf$extra$draw_pie_matrix) {
    p <- draw_pie_matrix(df, cols_label, cols[cols_label])
  } else {
    p1 <- as.ggplot(function() {
      draw(ocp, annotation_legend_side = "bottom", heatmap_legend_side = "bottom")
    })
    
    p2 <- as.ggplot(function() {
      legend_tmp <- list()
      for (i in names(col_meta_pre)) {
        if (is.function(col_meta_pre[[i]])) {
          legend_tmp[[i]] <- Legend(
            col_fun = col_meta_pre[[i]],
            title = i, direction = "horizontal"
          )
        } else if (identical(col_meta_pre[[i]], col_tag)) {
          legend_tmp[[i]] <- Legend(
            at = names(col_meta_pre[[i]]), title = i,
            direction = "horizontal",
            labels = c("No", "Yes"),
            legend_gp = gpar(fill = col_meta_pre[[i]])
          )
        } else {
          legend_tmp[[i]] <- Legend(
            at = names(col_meta_pre[[i]]), title = i,
            direction = "horizontal",
            legend_gp = gpar(fill = col_meta_pre[[i]])
          )
        }
      }
      ref_mut <- unique(unlist(str_split(mutdat, "/")))
      ref_mut <- ref_mut[ref_mut!= "0" & ref_mut != "" & ref_mut != "NANA"]
      ref_mut <- ref_mut[!is.na(ref_mut)]
      idx <- match(rev(names(cols)), ref_mut)
      ref_mut <- ref_mut[idx[!is.na(idx)]]
      lgd_mut <- Legend(
        at = ref_mut, title = "Mutations",
        direction = "horizontal",
        legend_gp = gpar(fill = cols[ref_mut])
      )
      legend_tmp[[length(legend_tmp) + 1]] <- lgd_mut
      legend_tmp$direction <- "horizontal"
      legend_tmp$max_width <- unit(conf$extra$legend_max_width, "cm")
      legend_tmp$column_gap <- unit(conf$extra$legend_column_gap, "cm")
      legend_tmp$row_gap <- unit(conf$extra$legend_row_gap, "cm")
      p <- do.call(packLegend, legend_tmp)
      ggdraw(draw(p))
    })
  
    p <- plot_grid(p1, p2, ncol = 1, rel_heights = c(4, 1))
  }
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
  df <- cbind(df, variant_class=NA)
  df[1, "variant_class"] <- paste0(cols_label, collapse = ",")
  out_xlsx <- paste(opt$outputFilePrefix, ".xlsx", sep = "")
  wb <- createWorkbook()
  addWorksheet(wb, "mut_matrix")
  addWorksheet(wb, "mut_stat")
  writeData(wb, "mut_matrix", mutdat, row.names = TRUE)
  writeData(wb, "mut_stat", t(df), row.names = TRUE)
  saveWorkbook(wb, out_xlsx, overwrite = TRUE)
}
