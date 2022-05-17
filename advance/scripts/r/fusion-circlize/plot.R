#######################################################
# Fusion Circlize.                                    #
#-----------------------------------------------------#
# Author: Jianfeng Li                                 #
# Email: lee_jianfeng@hiplot.org                      #
# Website: hiplot-academic.com                      #
#                                                     #
# Date: 2020-08-13                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2020 by Hiplot Team                   #
# All rights reserved.                                #
#######################################################

pkgs <- c("GenomicRanges", "TxDb.Hsapiens.UCSC.hg38.knownGene",
  "org.Hs.eg.db", "circlize", "ggplotify", "data.table")
pacman::p_load(pkgs, character.only = TRUE)

txdb_hg38 <- TxDb.Hsapiens.UCSC.hg38.knownGene

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  # check conf
  if (!is.data.frame(data)) {
    data <- as.data.frame(data)
  }
  f_col <- conf$dataArg[[1]][[1]]$value
  w_col <- conf$dataArg[[1]][[2]]$value
  link_col <- conf$dataArg[[1]][[3]]$value
  lab_col <- conf$dataArg[[1]][[3]]$value
  if (is.null(w_col)) {
    freq <- as.data.frame(table(data[,f_col]))
    w_col <- "freq"
    data[,w_col] <- freq[match(data[,f_col], freq[,1]),2]
  } else {
    freq <- data[,c(f_col, w_col)]
  }
  freq <- freq[order(freq[, 2], decreasing = T), ]
  check_fusion <- str_split(freq[, 1], "/|::")

  genes <- as.data.frame(transcripts(txdb_hg38))
  colnames(genes)[1:3] <- c("chrom", "txStart", "txEnd")
  symbol <- AnnotationDbi::select(org.Hs.eg.db,
    keys = genes$tx_name,
    keytype = "UCSCKG", columns = "SYMBOL"
  )

  genes <- cbind(genes, symbol)
  genes <- genes[!is.na(genes$SYMBOL), ]
  genes <- genes[genes$SYMBOL %in% unique(unlist(str_split(freq[, 1], "/|::"))), ]
  genes <- genes[genes$chr %in% sprintf("chr%s", c(1:22, "X", "Y")),]
  result <- lapply(unique(genes$SYMBOL), function(x) {
    x <- genes[genes$SYMBOL == x, ]
    x[order(x$width, decreasing = TRUE), ][1, ]
  })
  result <- rbindlist(result)
  colnames(result)[1:3] <- c("chr", "start", "end")
  result <- as.data.frame(result)
  bed1 <- NULL
  bed2 <- NULL
  result$chr <- as.character(result$chr)

  result <- rbind(result, result[1, ])
  result[nrow(result), c(1, 2, 3, 9)] <- c(
    "chr14", 105566277,
    106879844, "IGH"
  )
  result <- rbind(result, result[1, ])
  result[nrow(result), c(1, 2, 3, 9)] <- c(
    "chr14", 105851705,
    105856218, "IGHM"
  )
  result <- rbind(result, result[1, ])
  result[nrow(result), c(1, 2, 3, 9)] <- c(
    "chr14", 105736343,
    105743071, "IGHG1"
  )
  result <- rbind(result, result[1, ])
  result[nrow(result), c(1, 2, 3, 9)] <- c(
    "chr2", 88857361,
    89330679, "IGK"
  )
  result <- rbind(result, result[1, ])
  result[nrow(result), c(1, 2, 3, 9)] <- c(
    "chr14", 21621904,
    22552132, "TRA"
  )
  result <- rbind(result, result[1, ])
  result[nrow(result), c(1, 2, 3, 9)] <- c(
    "chr16", 90173217,
    90222678, "LINC02193"
  )

  result$start <- as.numeric(result$start)
  result$end <- as.numeric(result$end)
  for (i in sapply(str_split(freq[, 1], "/"), function(x) {
    x[1]
  })) {
    tmp <- result[result$SYMBOL == i, ]
    if (nrow(tmp) == 0) {
      tmp <- result[1, ]
      tmp[1, 1] <- NA
    }
    bed1 <- rbind(bed1, tmp)
  }
  for (i in sapply(str_split(freq[, 1], "/"), function(x) {
    x[2]
  })) {
    tmp <- result[result$SYMBOL == i, ]
    if (nrow(tmp) == 0) {
      tmp <- result[1, ]
      tmp[1, 1] <- NA
    }
    bed2 <- rbind(bed2, tmp)
  }
  bed1 <- as.data.frame(bed1)
  bed2 <- as.data.frame(bed2)
  rownames(bed1) <- 1:nrow(bed1)
  rownames(bed2) <- 1:nrow(bed2)

  get_idx <- function (nm) {
    x <- str_detect(data[,f_col], sprintf("^%s/|/%s$", nm, nm)) | 
      str_detect(data[,f_col], sprintf("^%s::|::%s$", nm, nm))
  }
  bed1_final <- bed1[!is.na(bed1[, 1]) & !is.na(bed2[, 1]), ]
  bed2_final <- bed2[!is.na(bed1[, 1]) & !is.na(bed2[, 1]), ]
  bed1_final2 <- bed1_final
  bed2_final2 <- bed2_final
  for (i in 1:nrow(bed1_final)) {
    w <- data[which(get_idx(bed1_final$SYMBOL[i]))[1],w_col]
    bed1_final$start[i] <- bed1_final$start[i] - 1000000 - 200000 * w
    bed1_final$end[i] <- bed1_final$end[i] + 1000000 + 200000 * w
  }
  for (i in 1:nrow(bed2_final)) {
    w <- data[which(get_idx(bed2_final$SYMBOL[i]))[1],w_col]
    bed2_final$start[i] <- bed2_final$start[i] - 1000000 - 200000 * w
    bed2_final$end[i] <- bed2_final$end[i] + 1000000 + 200000 * w
  }

  colors_link <- c(rep("gray", nrow(bed1_final)))
  label_df <- rbind(bed1_final2, bed2_final2)
  col <- rep("gray", nrow(label_df))
  label_df <- cbind(label_df, col)
  label_df <- label_df[!duplicated(label_df$SYMBOL),]
  cl <- unique(data[,lab_col])
  colors <- get_hiplot_color(conf$general$palette, -1,
    conf$general$paletteCustom)
    colors <- colors[1:length(cl)]
  names(colors) <- cl

  for (i in 1:nrow(label_df)) {
    x <- get_idx(label_df[i, "SYMBOL"])
    label_df[i, "col"] <- colors[data[which(x)[1],lab_col]]
  }
  for (i in 1:nrow(bed1_final)) {
    x <- get_idx(bed1_final[i, "SYMBOL"])
    colors_link[i] <- colors[data[which(x)[1],lab_col]]
  }
  print(bed1_final)
  print(bed2_final)
}

############# Section 2 #############
#           plot section
#####################################
{
  p <- as.ggplot(function() {
    circos.par("track.height" = 1, cell.padding = c(0, 0, 0, 0))
    circos.initializeWithIdeogram(ideogram.height = 
      convert_height(conf$extra$ideogram_height, "cm"))
    if (conf$extra$show_gene)
      circos.genomicLabels(label_df,
        labels.column = 9,  cex = conf$extra$label_size,
        side = conf$extra$label_side,
        connection_height = cm_h(conf$extra$connection_height),
        labels_height = cm_h(conf$extra$labels_height),
        col = label_df$col)

    if (conf$extra$show_link)
      circos.genomicLink(bed1_final,
        bed2_final,
        col = colors_link,
        border = NA, lwd = 10
      )
  })
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}
