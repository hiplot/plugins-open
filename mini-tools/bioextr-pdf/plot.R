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
  pkgs <- c("openxlsx", "data.table", "stringr")
  pacman::p_load(pkgs, character.only = TRUE)

  infiles <- c()
  tmp_infiles <- c()
  tmp_tables <- c()
  for (i in conf$data$infile$link) {
    tmp <- parse_file_link(i)
    if (xfun::file_ext(tmp) == "pdf") {
      tmp_infile <- paste0(tempfile(), "_hiplot___", basename(tmp))
      tmp_infiles <- c(tmp_infiles, tmp_infile)
      infiles <- c(infiles, tmp_infile)
      system_safe(sprintf("pdf2plain %s > %s", tmp, tmp_infile))
    } else {
      infiles <- c(infiles, tmp)
    }
  }
  kw <- tempfile()
  if (nrow(data) > 0) {
    writeLines(data[, 1], kw)
  }
}

############# Section 2 #############
#           plot section
#####################################
{
  outdir <- sprintf("%s/output", dirname(opt$outputFilePrefix))
  dir.create(outdir)
  setwd(outdir)
  cmd <- "bioextr --mode plain"
  cmd <- sprintf(paste(cmd,
      ifelse(conf$extra$extract_url, "--call-urls", ""),
      ifelse(nrow(data) > 0, "--call-cor", ""),
      "--keywords-file %s -t 30 '%s' > result.json", sep = " "),
    kw, paste0(infiles, collapse = "' '"))
  system_safe(cmd)
  file.remove(kw)

  if (file.exists("result.json") && file.size("result.json") > 5) {
    system_safe("json2csv -o result.csv -i result.json")
  }

  wb <- createWorkbook()

  if (file.exists("result.csv")) {
    dat <- fread("result.csv", sep = ",", data.table = FALSE)
    for (i in seq_len(ncol(dat))) {
      dat[, i] <- str_replace_all(dat[, i], '""', '"')
    }
    dat[, 1] <- str_replace_all(dat[, 1], "/.*/.*_hiplot___", "")
    for (i in 1:nrow(dat)) {
      dat[i, 2] <- jsonlite::prettify(dat[i, 2], 2)
      if (dat[i, 3] != "")
        dat[i, 3] <- jsonlite::prettify(dat[i, 3], 2)
    }
    addWorksheet(wb, "Main")
    writeData(wb, "Main",
      dat,
      colNames = TRUE, rowNames = FALSE
    )
    file.remove("result.csv")
  }

  if (length(tmp_infiles) > 0) {
    file.remove(tmp_infiles)
  }
  saveWorkbook(wb, paste0(opt$outputFilePrefix, ".xlsx"), overwrite = TRUE)

  unlink(outdir, recursive = TRUE)
}
