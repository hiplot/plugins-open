#######################################################
# CEMitool plot.                                      #
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

pkgs <- c("CEMiTool", "openxlsx", "data.table")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  # check conf
  file_paths <- list()
  for (i in seq_len(length(conf$data))) {
    if (conf$data[[i]]$link != "") {
      file_paths[names(conf$data)[i]] <- parse_file_link(conf$data[[i]]$link)
    } else if (i == 3) {
      file_paths[names(conf$data)[i]] <- system.file("extdata", "interactions.tsv", package = "CEMiTool")
    }
  }

  data <- as.data.frame(read_data(file_paths[["1-expmat"]]))
  rownames(data) <- data[, 1]
  data <- data[, -1]
  print(head(data))
  gmt_fname <- file_paths[["2-gmt"]]
  gmt_in <- read_gmt(gmt_fname)
  print(head(gmt_in))

  int_fname <- file_paths[["3-int_df"]]
  int_df <- read.delim(int_fname)
  print(head(int_df))

  cem <- cemitool(expr0, sample_annot, gmt_in,
    interactions = int_df,
    filter = TRUE, plot = TRUE, verbose = TRUE
  )
}

############# Section 2/3 #############
#           plot & output section
#####################################
{
  # create report as html document
  outdir <- dirname(opt$outputFilePrefix)
  dir.create(sprintf(
    "%s/tables",
    outdir
  ))
  # write analysis results into files
  write_files(cem, directory = sprintf(
    "%s/tables",
    outdir
  ), force = TRUE)

  dir.create(sprintf(
    "%s/plots",
    outdir
  ))
  # save all plots
  save_plots(cem, "all", directory = sprintf(
    "%s/plots",
    outdir
  ), force = TRUE)

  dir.create(sprintf(
    "%s/report",
    outdir
  ))
  generate_report(cem, directory = sprintf(
    "%s/report",
    outdir
  ), force = TRUE)

  file.rename(
    sprintf("%s/report/report.html", outdir),
    sprintf("%s/report.html", outdir)
  )
  unlink(sprintf("%s/report", outdir))

  pdfs <- list.files(sprintf("%s/plots", outdir),
    full.names = TRUE
  )
  pdfs2image(pdfs)

  tb <- list.files(sprintf("%s/tables", outdir),
    full.names = TRUE
  )
  wb <- createWorkbook()
  for (i in tb) {
    addWorksheet(wb, basename(i))
    writeData(wb, basename(i), fread(i), colNames = TRUE, rowNames = FALSE)
  }
  out_xlsx <- paste(opt$outputFilePrefix, ".xlsx", sep = "")
  saveWorkbook(wb, out_xlsx, overwrite = TRUE)
}
