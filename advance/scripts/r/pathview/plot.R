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
  pkgs <- c("pathview", "clusterProfiler", "stringr")
  pacman::p_load(pkgs, character.only = TRUE)

  species <- conf$data[["3-kegg_db"]]$value
  if (!str_detect(conf$data[["3-kegg_db"]]$value, "/")) {
    kegg_db <- clusterProfiler::download_KEGG(species = conf$data[["3-kegg_db"]]$value)
  } else {
    kegg_db <- readRDS(parse_file_link(conf$data[["3-kegg_db"]]$link))
    species <- str_replace_all(conf$data[["3-kegg_db"]]$value, ".*/", "")
    species <- str_replace_all(species, "_.*", "")
  }
  org_db <- conf$data[["4-org_db"]]
  require(org_db, character.only = TRUE)
  groups <- str_split(readLines(parse_file_link(conf$data[["2-cls"]]$link))[3], " |\t")[[1]]
  exp <- data.table::fread(parse_file_link(conf$data[["1-expmat"]]$link), data.table = FALSE)
  if (colnames(exp)[2] == "DESCRIPTION" || is.na(exp[1,2]) || exp[1,2] == "na") exp <- exp[,-2]
  exp <- exp[!duplicated(exp[,1]),]
  row.names(exp) <- exp[,1]
  exp <- exp[,-1]
  print(head(exp))
  ug <- groups[!duplicated(groups)]
  final <- NULL
  for (i in 1:length(ug)) {
    x <- paste0("exp_G", i)
    assign(x, exp[,colnames(exp) %in% colnames(exp)[groups == ug[i]]])
    x <- rowMeans(get(x))
    final <- cbind(final, x)
    colnames(final)[ncol(final)] <- ug[i]
  }
  final <- as.data.frame(t(apply(final, 1, scale)))
  colnames(final) <- ug
  print(head(final))
  if (str_detect(row.names(exp)[1], "^ENS")) {
    ids <- row.names(exp)
    entrezid <- bitr(ids,
      fromType = "ENSEMBL", toType = "ENTREZID",
      OrgDb = org_db, drop = FALSE)
    idx <- match(row.names(exp), entrezid[, 1])
    ref_ids <- entrezid[idx, 2]
  } else if (str_detect(row.names(exp)[1], "^[A-Za-z]")) {
    ids <- row.names(exp)
    entrezid <- bitr(ids,
      fromType = "SYMBOL", toType = "ENTREZID",
      OrgDb = org_db, drop = FALSE)
    idx <- match(row.names(exp), entrezid[, 1])
    ref_ids <- entrezid[idx, 2]
  } else {
    ref_ids <- row.names(exp)
  }
}
############# Section 2 #############
#           plot section
#####################################
{
  outdir <- file.path(dirname(opt$outputFilePrefix), "output")
  dir.create(outdir)
  owd <- getwd()
  setwd(outdir)
  x <- kegg_db[[2]][,2] %in% conf$extra$pathways
  pthid <- kegg_db[[2]][x, 1]
  pathways <- kegg_db[[2]][x, 2]
  p <- list()
  for (x in 1:length(pthid)) {
    nm <- str_replace_all(pathways[x], " |/", ".")
    nm <- str_replace_all(nm, fixed("..."), ".")
    nm <- str_replace_all(nm, fixed(".."), ".")
    i <- pthid[x]
    x2 <- kegg_db[[1]][,2][kegg_db[[1]][,1] == i]
    print(x2)
    for (j in 1:ncol(final)) {
      genedata <- final[ref_ids %in% x2, j]
      print(genedata)
      names(genedata) <- ref_ids[ref_ids %in% x2]
      pathview(genedata, pathway.id = i,  species = species,
      out.suffix = paste(nm, ug[j], sep = "_"), kegg.native = F, res = 500, cex = 0.7,
      low = list(gene = "#2d82d9", cpd = "blue"),
      high = list(gene = "#ff0000", cpd = "yellow"),
      pdf.size = c(14, 14))
    }
    if (conf$extra$draw_heatmap) {
      exp_tmp <- final[ref_ids %in% x2,]
      color_key <- c("#3300CC", "#3399FF", "white", "#FF3333", "#CC0000")
      col <- colorRampPalette(color_key)(50)
      p[[i]] <- pheatmap::pheatmap(exp_tmp, color = col,
        border_color = NA, clustering_method = "ward.D2",
        clustering_distance_cols = "euclidean",
        clustering_distance_rows = "euclidean",
        cluster_rows = TRUE,
        cluster_cols = FALSE,
        scale = "row",
        main = nm)
      height <- 0.3 * nrow(exp_tmp)
      if (height < 15) height <- 15
      if (height > 50) height <- 50
      cowplot::save_plot(filename = sprintf("%s.%s.heatmap.pdf", i, nm),
        p[[i]], base_height =  height, base_asp = 0.2, limitsize = FALSE)
    }
  }
  file.remove('Rplots.pdf')
  setwd(owd)
}

############# Section 3 #############
#          output section
#####################################
{
  export_directory()
}
