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

  if (conf$extra$query_mode == "or") {
    query <- paste0(data[, 1], collapse = ") OR (")
  } else {
    query <- paste0(data[, 1], collapse = ") AND (")
  }
  query <- paste0("(", query, ")")

  kw <- tempfile()
  if (nrow(data2) > 0) {
    writeLines(data2[, 1], kw)
  }
}

############# Section 2 #############
#           plot section
#####################################
{
  outdir <- sprintf("%s/output", dirname(opt$outputFilePrefix))
  dir.create(outdir)
  setwd(outdir)
  cmd <- sprintf(paste("bget api ncbi",
  "-q '%s' -e '2385782219@qq.com'",
  ifelse(!is.null(conf$extra$proxy) && conf$extra$proxy != "",
    paste0("--proxy ", conf$extra$proxy),
    ""
  ),
  "-m 20",
  "-r 5",
  "--size %s",
  "--from %s | awk '/<[?]xml version=\"1.0\"",
  "[?]>/{close(f); f=\"abstract.http.XML.tmp\"",
  "++c;next} {print>f;}'", sep = " "), query, conf$extra$size - 1,
  conf$extra$from)
  system_safe(cmd)

  xml_list <- list.files(".", "XML.tmp")
  json_list <- paste0(xml_list, ".json")
  for (i in xml_list) {
    system_safe(sprintf(paste0("bioctl cvrt -t 30",
      " --xml2json pubmed %s > %s.json"), i, i))
  }
  cmd <- "bioextr --mode pubmed"
  cmd <- sprintf(paste(cmd,
      ifelse(conf$extra$extract_url, "--call-urls", ""),
      ifelse(conf$extra$keep_abs, "--keep-abs", ""),
      ifelse(nrow(data2) > 0, "--call-cor", ""),
      "--keywords-file %s -t 30 '%s' > result.json", sep = " "),
    kw, paste0(json_list, collapse = "' '"))
  system_safe(cmd)
  file.remove(kw)

  if (file.exists("result.json") && file.size("result.json") > 5) {
    system_safe("json2csv -o result.csv -i result.json")
  }

  if (file.exists("result.csv")) {
    dat <- fread("result.csv", sep = ",", data.table = FALSE)
    for (i in seq_len(ncol(dat))) {
      dat[, i] <- str_replace_all(dat[, i], '""', '"')
    }
    for (i in 1:nrow(dat)) {
      if (dat[i, "Correlation"] != "{}")
        dat[i, "Correlation"] <- jsonlite::prettify(dat[i, "Correlation"], 2)

      if (dat[i, "URLs"] != "")
        dat[i, "URLs"] <- jsonlite::prettify(dat[i, "URLs"], 2)
    }
    write.xlsx(dat, paste0(opt$outputFilePrefix, ".xlsx"))
    file.remove("result.csv")
  }
  system(sprintf("tar -czv * -f %s.tar.gz", opt$outputFilePrefix))
  unlink(outdir, recursive = TRUE)
}
