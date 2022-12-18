#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2022 by "National Center for          #
# Translational Medicine·Shanghai                     #
# All rights reserved.                                #
#######################################################
############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  pdfs <- sapply(conf$data$pdfs$link, function(x) {
    parse_file_link(x)
  })
}

############# Section 2 #############
#           plot section
#####################################
{
  imported_info <- import_images_to_pdf(pdfs)
  pdfs <- imported_info$ret
  if (conf$extra$mode == "split") {
    pdfs2image(pdfs)
    pdfs <- split_pdfs(pdfs, dirname(opt$outputFilePrefix))
    file.remove(paste0(opt$outputFilePrefix, ".pdf"))
  } else if (conf$extra$mode == "combine-append") {
    pdfs2image(pdfs)
  } else {
    tmp_merge_pdf <- paste0(opt$outputFilePrefix, "_merged.pdf")
    if (length(pdfs) == 1) {
      file.copy(pdfs[1], tmp_merge_pdf)
    } else {
      merge_pdfs(pdfs, tmp_merge_pdf)
    }
    out_pdf <- paste0(opt$outputFilePrefix, ".pdf")
    paper_size <- ""
    dimensions <- ""
    if (conf$extra$paper_size != "custom") {
      paper_size <- paste0(
        ", f: ", conf$extra$paper_size,
        ifelse(conf$extra$landscape, "L", "P")
      )
    }
    if (conf$extra$paper_size == "custom") {
      dimensions <- paste(
        ", d:",
        round(conf$extra$dimensions_w * 28.345, 0),
        round(conf$extra$dimensions_h * 28.345, 0)
      )
    }
    for (i in seq_len(length(pdfs))) {
      tmpdir <- tempfile()
      dir.create(tmpdir)
      unlink(tmpdir, recursive = TRUE)
    }
    grid_mode <- conf$extra$mode == "combine-grid"
    cmds <- paste(
      "pdfcpu",
      ifelse(grid_mode, "nup", "grid"),
      sprintf(
        "'b: off%s%s'",
        paper_size, dimensions
      ),
      out_pdf,
      ifelse(grid_mode, conf$extra$fig_per_page,
        paste(conf$extra$ncol, conf$extra$nrow)),
      tmp_merge_pdf
    )
    system(cmds)
    if (file.exists(out_pdf)) {
      pdf2image(out_pdf, 1)
    }
    file.remove(tmp_merge_pdf)
    if (!is.null(imported_info) && length(imported_info$all_tmp_pdf) > 0) {
      file.remove(imported_info$all_tmp_pdf)
    }
  }
}
