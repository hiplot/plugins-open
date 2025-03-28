#######################################################
# Immunedeconv.                                       #
#-----------------------------------------------------#
# Author: Jianfeng Li                                 #
# Email: lee_jianfeng@hiplot.org                      #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2020-08-13                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2022 by "National Center for          #
# Translational Medicine·Shanghai                     #
# All rights reserved.                                #
#######################################################

pacman::p_load(immunedeconv)
pacman::p_load(dplyr)
pacman::p_load(tidyr)
pacman::p_load(tibble)
pacman::p_load(openxlsx)
pacman::p_load(configr)
pkgs <- c("immunedeconv", "dplyr",
  "tidyr", "tibble", "openxlsx", "configr",
  "ggplot2")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  set_cibersort_binary(file.path(
    upload_dir,
    "public/script/cibersort/cibersort.R"
  ))
  set_cibersort_mat(file.path(
    upload_dir,
    "public/script/cibersort/LM22.txt"
  ))


  infile <- ""
  if (conf$data$expmat$link != "") {
    infile <- parse_file_link(conf$data$expmat$link)
  }

  if (infile != "") {
    if (str_detect(infile, ".xlsx$")) {
      expr_mat <- as.data.frame(read.xlsx(infile, 1))
    } else {
      expr_mat <- as.data.frame(data.table::fread(infile))
    }
  } else {
    expr_mat <- dataset_racle$expr_mat
  }
  expr_mat <- expr_mat[!duplicated(expr_mat[, 1]), ]
  rownames(expr_mat) <- expr_mat[, 1]
  expr_mat <- expr_mat[, -1]
}

############# Section 2 #############
#           plot section
#####################################
{
  if (conf$extra$method == "quantiseq") {
    res <- deconvolute(expr_mat, "quantiseq",
      tumor = conf$extra$tumor,
      scale_mrna = conf$extra$scale_mrna, arrays = conf$extra$arrays
    )
    dat <- res %>%
      gather(sample, fraction, -cell_type)
    # plot as stacked bar chart
    p <- ggplot(dat, aes(x = sample, y = fraction, fill = cell_type)) +
      geom_bar(stat = "identity") +
      coord_flip() +
      scale_fill_brewer(palette = "Paired") +
      scale_x_discrete(limits = rev(levels(res))) +
      ggtitle(conf$general$title)
  } else {
    cancer_type <- list(
      acc = "Adenocortical Carcinoma",
      blca = "Bladder Carcinoma", brca = "Breast Carcinoma",
      cesc = "Cervical Squamous Carcinoma", coad = "Colon Carcinoma",
      dlbc = "Diffuse Large B-cell Lymphoma", gbm = "Glioblastoma Multiforme",
      hnsc = "Head and Neck Carcinoma", kich = "Kidney Chromophobe",
      kirc = "Kidney Renal Clear Cell Carcinoma",
      kirp = "Kidney Renal Papillary Cell Carcinoma",
      lgg = "Lower Grade Glioma", lihc = "Liver Hepatocellular Carcinoma",
      luad = "Lung Adenocarcinoma", lusc = "Lung Squamous Carcinoma",
      ov = "Ovarian Serous Cystadenocarcinoma",
      prad = "Prostate Adenocarcinoma",
      read = "Rectum Adenocarcinoma", skcm = "Skin Cutaneous Melanoma",
      stad = "Stomach Adenocarcinoma", thca = "Thyroid Carcinoma",
      ucec = "Uterine Corpus Endometrial Carcinoma",
      ucs = "Uterine Carsinosarcoma"
    )

    conf$extra$timer_cancer_type <- names(cancer_type[
      sapply(cancer_type, function(x) {
        return(x == conf$extra$timer_cancer_type)
      })
    ])
    res <- deconvolute(expr_mat, conf$extra$method,
      indications = rep(conf$extra$timer_cancer_type, ncol(expr_mat)),
      scale_mrna = conf$extra$scale_mrna, arrays = conf$extra$arrays
    )
    dat <- res %>%
      gather(sample, score, -cell_type)
    dat$sample <- factor(dat$sample, unique(dat$sample))
    p <- ggplot(dat, aes(x = sample, y = score, color = cell_type)) +
      geom_point(alpha = conf$general$alpha, size = conf$extra$pointSize) +
      facet_wrap(~cell_type, scales = "free_x", ncol = 3) +
      scale_color_brewer(palette = "Paired", guide = FALSE) +
      coord_flip() +
      theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) +
      ggtitle(conf$general$title)
  }
  ## add color palette
  p <- p + return_hiplot_palette_color(conf$general$palette,
      conf$general$paletteCustom) +
    return_hiplot_palette(conf$general$palette,
      conf$general$paletteCustom)

  ## add theme
  p <- set_complex_general_theme(set_palette_theme(p, conf))
}


############# Section 3 #############
#          output section
#####################################
{
  out_xlsx <- paste(opt$outputFilePrefix, ".xlsx", sep = "")
  write.xlsx(dat, out_xlsx)
  export_single(p)
}
