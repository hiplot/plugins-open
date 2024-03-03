#######################################################
# Venn plot.                                          #
#-----------------------------------------------------#
# Author: < Mingjie Wang > from < Ke Yan Mao >        #
# Affiliation: Shanghai Hiplot Team                   #
# Email: customer_service1501@tengyunbio.com          #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2019-11-28                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2020 by Hiplot Team                   #
# All rights reserved.                                #
#######################################################

# packages section
pkgs <- c("VennDiagram", "grDevices", "openxlsx")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  # check input data list number
  for (i in seq_len(ncol(data))) {
    data[is.na(data[, i]), i] <- ""
  }
  raw <- data
  data <- as.data.frame(raw[raw[, 1] != "", 1])
  colnames(data) <- colnames(raw)[1]
  list.num <- 1
  for (i in 2:ncol(raw)) {
    if (any(!is.na(raw[, i]) & raw[, i] != "")) {
      tmp <- raw[i]
      tmp <- tmp[tmp[, 1] != "", ]
      tmp <- as.data.frame(tmp)
      colnames(tmp) <- colnames(raw)[i]
      assign(paste0("data", i), tmp)
      list.num <- list.num + 1
    }
  }
  if (! "data2" %in% ls()) {
    stop("Error, at least 2 data files should be provided.")
  }

  # check conf arguments
  # check alpha
  alpha_usr <- conf$general$alpha
  if (is.numeric(alpha_usr) & alpha_usr >= 0 & alpha_usr <= 1) {
    if (alpha_usr > 0.75) {
      alpha_usr <- 0.75
    }
  } else {
    print("Error, alpha should be a decimal between 0-1")
  }
}

############# Section 2 #############
#           plot section
#####################################
{
  eulerr <- FALSE
  if (!is.null(conf$extra$eulerr)) {
    eulerr <- conf$extra$eulerr
  }
  if (list.num == 2) {
    data <- colname2data(data)
    data2 <- colname2data(data2)

    data_list <- list(n1 = data$V1, n2 = data2$V1)
    names(data_list) <- colnames(raw)[1:2]
    p <- venn.diagram(data_list,
      scaled = eulerr,
      euler.d = eulerr,
      filename = NULL,
      fill = get_hiplot_color(conf$general$palette, list.num,
        conf$general$paletteCustom),
      cat.col = get_hiplot_color(conf$general$palette, list.num,
        conf$general$paletteCustom),
      label.col = "black",
      cex = 1,
      main = conf$general$title,
      main.cex = 1.5,
      cat.cex = 1,
      cat.pos = 0,
      alpha = alpha_usr,
      main.fontfamily = conf$general$font,
      fontfamily = conf$general$font,
      cat.fontfamily = conf$general$font,
      cat.fontface = "bold",
      margin = 0.1
    )
  } else if (list.num == 3) {
    data <- colname2data(data)
    data2 <- colname2data(data2)
    data3 <- colname2data(data3)

    data_list <- list(n1 = data$V1, n2 = data2$V1, n3 = data3$V1)
    names(data_list) <- colnames(raw)[1:3]
    p <- venn.diagram(data_list,
      scaled = eulerr,
      euler.d = eulerr,
      filename = NULL,
      fill = get_hiplot_color(conf$general$palette, list.num,
        conf$general$paletteCustom),
      cat.col = get_hiplot_color(conf$general$palette, list.num,
        conf$general$paletteCustom),
      label.col = "black",
      cex = 1,
      main = conf$general$title,
      main.cex = 1.5,
      cat.cex = 1,
      alpha = alpha_usr,
      main.fontfamily = conf$general$font,
      fontfamily = conf$general$font,
      cat.fontfamily = conf$general$font,
      cat.fontface = "bold",
      margin = 0.1
    )
  } else if (list.num == 4) {
    data <- colname2data(data)
    data2 <- colname2data(data2)
    data3 <- colname2data(data3)
    data4 <- colname2data(data4)

    data_list <- list(n1 = data$V1, n2 = data2$V1, n3 = data3$V1, n4 = data4$V1)
    names(data_list) <- colnames(raw)[1:4]
    p <- venn.diagram(data_list,
      scaled = eulerr,
      euler.d = eulerr,
      filename = NULL,
      fill = get_hiplot_color(conf$general$palette, list.num,
        conf$general$paletteCustom),
      cat.col = get_hiplot_color(conf$general$palette, list.num,
        conf$general$paletteCustom),
      label.col = "black",
      cex = 1,
      main = conf$general$title,
      main.cex = 1.5,
      cat.cex = 1,
      alpha = alpha_usr,
      main.fontfamily = conf$general$font,
      fontfamily = conf$general$font,
      cat.fontfamily = conf$general$font,
      cat.fontface = "bold",
      margin = 0.1
    )
  } else {
    data <- colname2data(data)
    data2 <- colname2data(data2)
    data3 <- colname2data(data3)
    data4 <- colname2data(data4)
    data5 <- colname2data(data5)

    data_list <- list(
      n1 = data$V1, n2 = data2$V1, n3 = data3$V1,
      n4 = data4$V1, n5 = data5$V1
    )
    names(data_list) <- colnames(raw)[1:5]

    p <- venn.diagram(data_list,
      scaled = eulerr,
      euler.d = eulerr,
      filename = NULL,
      col = "black",
      fill = get_hiplot_color(conf$general$palette, list.num,
        conf$general$paletteCustom),
      cex = c(
        1.5, 1.5, 1.5, 1.5, 1.5, 1, 0.8, 1, 0.8, 1, 0.8, 1, 0.8,
        1, 0.8, 1, 0.55, 1, 0.55, 1, 0.55, 1, 0.55, 1, 0.55, 1, 1, 1, 1, 1, 1.5
      ),
      cat.col = get_hiplot_color(conf$general$palette, list.num,
        conf$general$paletteCustom),
      cat.cex = 1,
      main.fontfamily = conf$general$font,
      fontfamily = conf$general$font,
      cat.fontface = "bold",
      cat.fontfamily = conf$general$font,
      margin = 0.1,
      main = conf$general$title,
      alpha = alpha_usr
    )
  }
  venn_partitions <- VennDiagram::get.venn.partitions(data_list)
  wb <- createWorkbook()
  addWorksheet(wb, "venn_partitions")
  writeData(wb, "venn_partitions", venn_partitions,
    colNames = TRUE, rowNames = FALSE
  )
}

############# Section 3 #############
#          output section
#####################################
{
  p <- ggdraw(p)
  out_xlsx <- paste(opt$outputFilePrefix, ".xlsx", sep = "")
  saveWorkbook(wb, out_xlsx, overwrite = TRUE)
  export_single(p)
  log_files <- list.files(".", "VennDiagram.*.log")
  if (length(log_files) > 0) {
    file.remove(log_files)
  }
}
