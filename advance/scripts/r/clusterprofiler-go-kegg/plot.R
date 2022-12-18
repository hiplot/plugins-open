#######################################################
# CEMitool plot.                                      #
#-----------------------------------------------------#
# Author: Jianfeng Li                                 #
# Email: lee_jianfeng@hiplot.org                      #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2020-08-13                                    #
# Version: 0.1.1                                      #
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
  if (!str_detect(conf$data[["2-kegg_db"]]$value, "/")) {
    kegg_db <- clusterProfiler::download_KEGG(species = conf$data[["2-kegg_db"]]$value)
  } else {
    kegg_db <- readRDS(parse_file_link(conf$data[["2-kegg_db"]]$link))
  }
  org_db <- conf$data[["3-org_db"]]
  require(org_db, character.only = TRUE)
  utils::data(geneList)
  data <- as.data.frame(data)
  theme <- conf$general$theme
  enrich_res <- list()
  for (i in colnames(data)) {
    data <- rbind(data, colnames(data))
    enrich_res[[i]] <- run_go_kegg(data[, i], conf)
  }
}

############# Section 2/3 #############
#           plot & output section
#####################################
{
  wb <- createWorkbook()
  p_list <- list()
  for (i in names(enrich_res)) {
    res <- enrich_res[[i]]
    p_list[[i]] <- plot_enrich_res(res, i)
    for (j in names(res)) {
      addWorksheet(wb, paste(i, j, sep = "_"))
      writeData(wb, paste(i, j, sep = "_"),
        res[[j]]@result,
        colNames = TRUE, rowNames = FALSE
      )
    }
  }
}

############# Section 3 #############
#          output section
#####################################
{
  asp <- conf$general$size$width / conf$general$size$height
  pdfs <- c()
  outdir <- paste0(dirname(opt$outputFilePrefix), "/output/")
  dir.create(outdir)
  opt2 <- opt
  conf2 <- conf
  for (i in names(p_list)) {
    conf$general$imageExportType <- c("pdf")
    opt$outputFilePrefix <- paste0(outdir, i, ".a-dotplot")
    export_single(p_list[[i]][["p"]])
    if (!is.null(p_list[[i]][["p1"]])) {
      opt$outputFilePrefix <- paste0(outdir, i, ".b-barplot")
      export_single(p_list[[i]][["p1"]])
    }
    if (!is.null(p_list[[i]][["p2"]])) {
      opt$outputFilePrefix <- paste0(outdir, i, ".c-emapplot")
      export_single(p_list[[i]][["p2"]])
    }
    if (!is.null(p_list[[i]][["p3"]])) {
      opt$outputFilePrefix <- paste0(outdir, i, ".d-cnetplot")
      export_single(p_list[[i]][["p3"]])
    }
    if (!is.null(p_list[[i]][["p4"]])) {
      opt$outputFilePrefix <- paste0(outdir, i, ".e-treeplot")
      export_single(p_list[[i]][["p4"]])
    }
  }
  opt <- opt2
  conf <- conf2
  export_directory()
  out_xlsx <- paste(opt$outputFilePrefix, ".xlsx", sep = "")
  saveWorkbook(wb, out_xlsx, overwrite = TRUE)
}
