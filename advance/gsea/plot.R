#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2022 by "National Center for          #
# Translational Medicine·Shanghai                     #
# All rights reserved.                                #
#######################################################
check_encoding <- function (x) {
  res <- system(sprintf("file -bi %s", x), intern = TRUE)
  if (stringr::str_detect(res, "utf-16le")) {
    stop(sprintf("Please convert file encoding of %s from UTF-16 to UTF-8", 
      basename(x)))
  }
}

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  library(stringr)
  outdir <- sprintf("%s/output", dirname(opt$outputFilePrefix))
  dir.create(outdir)
  ## Input should be a segmentation file
  ref_vars <- c("in_exp", "in_cls", "in_gmt")
  in_vars <- c("1-expmat", "2-cls", "3-gmt")
  for (i in seq_len(length(in_vars))) {
    if ("data" %in% names(conf) && in_vars[i] %in% names(conf$data) &&
      conf$data[[in_vars[i]]]$link != "") {
      assign(ref_vars[i], parse_file_link(conf$data[[in_vars[i]]]$link))
    }
  }
  if (is.null(conf$extra$cli_version) || conf$extra$cli_version == "") {
    conf$extra$cli_version <- "4.1.0"
  }
  gsea_root <- sprintf("/cluster/home/public/opt/bio/gsea/%s/",
          conf$extra$cli_version)
  if (conf$extra$cli_version == "4.2.3") {
    jdk11_root <- getOption("hiplot.jdk11_bin")
    gsea_root <- sprintf("export PATH=%s:$PATH && %s", jdk11_root, gsea_root)
  }
}
############# Section 2 #############
#           plot section
#####################################
{
  if (length(conf$extra$test_groups) == 0) {
    conf$extra$test_groups <- readLines(in_cls)[2]
    conf$extra$test_groups <- str_replace_all(conf$extra$test_groups, "#", "")
    conf$extra$test_groups <- str_split(conf$extra$test_groups, " |\t")[[1]]
    conf$extra$test_groups <- conf$extra$test_groups[conf$extra$test_groups != ""]
  }
  if (length(conf$extra$test_groups) < 2) {
    stop("test_groups need >= 2")
  }
  if (!conf$extra$enable_versus_rest) {
    my_comparisons <- combn(conf$extra$test_groups, 2, simplify = FALSE)
    # Avoid numeric groups
    my_comparisons <- lapply(my_comparisons, as.character)
  } else if (length(conf$extra$test_groups) >= 3) {
    my_comparisons <- list()
    my_comparisons <- lapply(
      conf$extra$test_groups,
      function(x) {
        return(c(x, "REST"))
      }
    )
  } else {
    stop("test_groups need >= 3 when set enable_versus_rest")
  }
  pdfs <- c()
  owd <- getwd()
  setwd(tempdir())
  todelete <- c()
  for (i in c(in_exp, in_cls)) {
    check_encoding(i)
  }
  for (gmt in in_gmt) {
    for (i in seq_len(length(my_comparisons))) {
      outdir_tmp <- file.path(outdir, basename(gmt))
      case <- my_comparisons[[i]][1]
      ctr <- my_comparisons[[i]][2]
      cmd <- paste(
        sprintf(
          "gsea-cli.sh GSEA -res '%s' -cls '%s#%s_versus_%s' -gmx '%s'",
          in_exp, in_cls, case, ctr, gmt
        ),
        "-mode", conf$extra$mode,
        "-norm", conf$extra$norm,
        "-nperm", conf$extra$nperm,
        "-permute phenotype",
        "-rnd_type", conf$extra$rnd_type,
        "-scoring_scheme", conf$extra$scoring_scheme,
        sprintf("-rpt_label %s_vs_%s", case, ctr),
        "-metric", conf$extra$metric,
        "-sort", conf$extra$sort,
        "-order", conf$extra$order,
        "-include_only_symbols",
        ifelse(conf$extra$include_only_symbols, "true", "false"),
        "-make_sets", ifelse(conf$extra$make_sets, "true", "false"),
        "-median", ifelse(conf$extra$median, "true", "false"),
        "-num", conf$extra$num, "-plot_top_x", conf$extra$plot_top_x,
        "-rnd_seed", conf$extra$rnd_seed,
        "-save_rnd_lists", ifelse(conf$extra$save_rnd_lists,
          "true", "false"
        ),
        "-set_max", conf$extra$set_max,
        "-set_min", conf$extra$set_min,
        "-zip_report false",
        "-out", outdir_tmp
      )
      cmd <- str_replace_all(cmd, fixed("//"), "/")
      cat(sprintf("GSEA v%s program started:\n\n", conf$extra$cli_version))
      cmd2 <- str_remove_all(cmd, "/cluster/apps/hiplot")
      cat(paste0(cmd2, "\n"), sep = "\n")
      cmd <- paste0(gsea_root, cmd)
      system_safe(cmd)
      outdir_tmp_sub <- dir(outdir_tmp)
      outdir_tmp_sub <- outdir_tmp_sub[str_detect(outdir_tmp_sub,
        fixed(sprintf("%s_vs_%s", case, ctr)))]
      gsea_out_dir <- file.path(outdir_tmp, outdir_tmp_sub)
      if (length(conf$general$imageExportType) > 0) {
        cmd <- paste(
          "source activate gseapy;",
          sprintf(
            "gseapy replot -i '%s' -o '%s/GSEApy_reports'",
            gsea_out_dir, gsea_out_dir
          )
        )
        system_safe(cmd)
        report <- list.files(gsea_out_dir, "gsea_report_for_.*.tsv")
        to_delete <- NULL
        gseapy_pdfs <- list.files(
          file.path(gsea_out_dir, "GSEApy_reports"),
          ".pdf",
          full.names = TRUE
        )
        todelete <- c(todelete, file.path(gsea_out_dir, "GSEApy_reports"))
        if (length(gseapy_pdfs) > 0) pdfs <- c(pdfs, gseapy_pdfs)
      }
    }
  }
  pdfs2image(pdfs)
  unlink(todelete, recursive = TRUE)
  setwd(owd)
}

############# Section 3 #############
#          output section
#####################################
{
  owd <- getwd()
  setwd(outdir)
  if (length(conf$general$imageExportType) > 0) {
    unlink(file.path(gsea_out_dir, "GSEApy_reports"),
      recursive = TRUE)
  }
  system_safe(sprintf(
    "tar -czv * -f %s.addition.tar.gz",
    opt$outputFilePrefix
  ))
  setwd(owd)
  unlink(outdir, recursive = TRUE)
}
