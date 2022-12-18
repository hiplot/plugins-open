pkgs <- c("clusterProfiler", "DOSE", "enrichplot", "ggplot2", 
  "openxlsx", "ReactomePA", "AnnotationHub", "MeSHDbi", "meshes")
pacman::p_load(pkgs, character.only = TRUE)

species = list("org.Ag.eg.db" = "Arabidopsis",
        "org.At.tair.db" = "Arabidopsis thaliana",
        "org.Bt.eg.db" = "Bovine",
        "org.Ce.eg.db" = "Annelida",
        "org.Cf.eg.db" = "Canis lupus familiaris",
        "org.Dm.eg.db" = "Diptera",
        "org.Dr.eg.db" = "Danio rerio",
        "org.EcK12.eg.db" = "E coli strain K12",
        "org.EcSakai.eg.db" = "E coli strain Sakai",
        "org.Gg.eg.db" = "Chicken",
        "org.Hs.eg.db" = "Homo sapiens",
        "org.Mm.eg.db" = "Mouse",
        "org.Mmu.eg.db" = "Mus musculus",
        "org.Mxanthus.db" = "Myxococcus xanthus DK 1622",
        "org.Pf.plasmo.db" = "Plasmodium falciparum",
        "org.Pt.eg.db" = "Pan troglodytes",
        "org.Rn.eg.db" = "Rattus",
        "org.Sc.sgd.db" = "Saccharomyces cerevisiae",
        "org.Ss.eg.db" = "Sus domesticus",
        "org.Xl.eg.db" = "Xenopus laevis")

ref_mode <- list(
  BP = "enrichGO", MF = "enrichGO", CC = "enrichGO",
  KEGG = "enricher", DO = "enrichDO", NCG = "enrichNCG", DGN = "enrichDGN",
  ReactomePA = "enrichPathway", WikiPathways = "enrichWP",
  MeSH = "enrichMeSH"
)

ref_title <- list(
  BP = "GO enrichment analysis (BP)",
  MF = "GO enrichment analysis (MF)",
  CC = "GO enrichment analysis (CC)", KEGG = "KEGG enrichment analysis",
  DO = "Disease Ontology (DO) enrichment analysis",
  NCG = "Network of Caner Genes (NCG) enrichment analysis",
  DGN = "DisGeNET enrichment analysis",
  ReactomePA = "Reactome pathway over-representation analysis",
  WikiPathways = "WikiPathways over-representation analysis",
  MeSH = "MeSH over-representation analysis"
)

get_species <- function(x) {
  if (x %in% names(species)) {
    return (species[[x]])
  } else {
    return (x)
  }
}

run_go_kegg <- function(data, conf) {
  # convert id
  if (str_detect(data[1], "^ENS")) {
    entrezid <- bitr(data,
      fromType = "ENSEMBL", toType = "ENTREZID",
      OrgDb = org_db, drop = T
    )
    data <- entrezid[, 2]
  } else if (str_detect(data[1], "^[A-Za-z]")) {
    entrezid <- bitr(unique(c(data, toupper(data))),
      fromType = "SYMBOL", toType = "ENTREZID",
      OrgDb = org_db, drop = T
    )
    data <- entrezid[, 2]
  }
  data <- as.numeric(data)
  gene <- data[order(data, decreasing = TRUE)]
  enrich_res <- list()
  for (i in conf$extra$mode) {
    param <- list(
      gene = gene, pvalueCutoff = conf$extra$pvalueCutoff,
      qvalueCutoff = conf$extra$qvalueCutoff,
      pAdjustMethod = conf$extra$pAdjustMethod,
      minGSSize = conf$extra$minGSSize,
      maxGSSize = conf$extra$maxGSSize
    )
    if (i %in% c("BP", "MF", "CC")) {
      param$ont <- i
      param$OrgDb <- get(org_db)
    } else if (i == "KEGG") {
      param$TERM2GENE <- kegg_db[[1]]
      param$TERM2NAME <- kegg_db[[2]]
    } else if (i == "WikiPathways") {
      param$organism <- get_species(org_db)
    }
    if (!i %in% c("KEGG", "WikiPathways", "MeSH")) {
      param$readable <- TRUE
    }
    if (i == "MeSH") {
      ah <- AnnotationHub()
      MeSH_dat <- query(ah, c("MeSHDb", get_species(org_db)))
      file_MeSH <- MeSH_dat[[1]]
      db <- MeSHDbi::MeSHDb(file_MeSH)
      param$MeSHDb <- db
      param$database <- conf$extra$meshDB
      param$category = conf$extra$meshCat
    }
    if (conf$extra$doseBackground) {
      param$universe <- names(geneList)
    }
    cmd <- sprintf("do.call(%s, param)", ref_mode[[i]])
    enrich_res[[i]] <- eval(parse(text = cmd))
    if (i %in% c("KEGG", "WikiPathways", "MeSH")) {
      ref <- tryCatch(bitr(enrich_res[[i]]@gene,
        fromType = "ENTREZID", toType = "SYMBOL",
        OrgDb = org_db, drop = T
      ), error = function(e) {})
      if (!is.null(ref)) {
        final <- ref[, 2]
        names(final) <- ref[, 1]
        enrich_res[[i]]@result$geneID <- sapply(
          enrich_res[[i]]@result$geneID,
          function(x) {
            paste(final[str_split(x, "/")[[1]]], collapse = "/")
          }
        )
      }
    }
  }
  return(enrich_res)
}

plot_grid_enrich_res <- function(pobj) {
  p <- NULL
  for (i in names(pobj)) {
    pobj[[i]] <- tryCatch({
      ggdraw(pobj[[i]]); pobj[[i]]
    }, error = function(e) {
      ggplot()
    }, warning = function(w) {
      ggplot()
    })
    if (is.null(p)) {
      p <- pobj[[i]]
    } else {
      p <- tryCatch({
        p + pobj[[i]]
      }, error = function(e) {
        p + ggplot()
      }, warning = function(w) {
        p + ggplot()
      })
    }
  }
  if (is.null(p)) {
    p <- ggplot()
  } else {
    p <- p + plot_layout(ncol = 1) +  plot_annotation(tag_levels = 'A')
  }
  return(p)
}

plot_enrich_res <- function(res, title) {
  ret <- list()
  pobj <- list()
  for (i in names(res)) {
    pobj[[i]] <- tryCatch({
      dotplot(res[[i]], showCategory = conf$extra$showCategory, orderBy = "x") +
      ggtitle(ref_title[[i]])
    }, error = function(e) {ggplot()}, warning = function(w) {ggplot()})
    pobj[[i]] <- tryCatch({
      pobj[[i]] + scale_y_discrete(labels = function(x) {str_wrap(x, width = 65)})
    }, error = function(e){ggplot()}, warning = function(w) {ggplot()})
    pobj[[i]] <- choose_ggplot_theme(pobj[[i]], theme)
  }
  p <- plot_grid_enrich_res(pobj) + plot_annotation(title = title)
  ret[["p"]] <- p

  pobj1 <- list()
  if (conf$extra$drawBarplot) {
    for (i in names(res)) {
      pobj1[[i]] <- tryCatch({
        barplot(res[[i]], showCategory = conf$extra$showCategory) +
        ggtitle(ref_title[[i]])
      }, error = function(e) {ggplot()}, warning = function(w) {ggplot()})
      pobj1[[i]] <- tryCatch({
        pobj1[[i]] + scale_y_discrete(labels = function(x) {str_wrap(x, width = 65)})
      }, error = function(e){ggplot()}, warning = function(w) {ggplot()})
      pobj1[[i]] <- choose_ggplot_theme(pobj1[[i]], theme)
    }
    p1 <- plot_grid_enrich_res(pobj1) + plot_annotation(title = title)
    ret[["p1"]] <- p1
  }

  pobj2 <- list()
  if (conf$extra$drawEnrichmentMap) {
    for (i in names(res)) {
      pobj2[[i]] <- tryCatch(emapplot(pairwise_termsim(res[[i]]),
        layout = "kk"
      ) + ggtitle(ref_title[[i]]), error = function(e) {
        return(ggplot())
      })
      pobj2[[i]] <- choose_ggplot_theme(pobj2[[i]], theme)
    }
    p2 <- plot_grid_enrich_res(pobj2) + plot_annotation(title = title)
    ret[["p2"]] <- p2
  }

  pobj3 <- list()
  if (conf$extra$drawCnetPlot) {
    for (i in names(res)) {
      pobj3[[i]] <- tryCatch(cnetplot(pairwise_termsim(res[[i]]),
        circular = TRUE, colorEdge = TRUE,
        showCategory = conf$extra$showCategory
      ) + ggtitle(ref_title[[i]]) +
        return_hiplot_palette_color(conf$general$palette,
          conf$general$paletteCustom) +
        return_hiplot_palette(conf$general$palette,
          conf$general$paletteCustom), error = function(e) {
        return(ggplot())
      })
      pobj3[[i]] <- choose_ggplot_theme(pobj3[[i]], theme)
    }
    p3 <- plot_grid_enrich_res(pobj3) + plot_annotation(title = title)
    ret[["p3"]] <- p3
  }

  pobj4 <- list()
  if (!is.null(conf$extra$drawTreePlot) && conf$extra$drawTreePlot) {
    for (i in names(res)) {
      pobj4[[i]] <- tryCatch(treeplot(pairwise_termsim(res[[i]]),
        hclust_method = conf$extra$hclustMethod,
        nClusterTree = conf$extra$nClusterTree,
        hilight = conf$extra$hilightTree,
        group_color = get_hiplot_color(conf$general$palette,
          conf$extra$nClusterTree, conf$general$paletteCustom)
      ) + ggtitle(ref_title[[i]]), error = function(e) {
        return(ggplot())
      }) + theme(
        text = element_text(
          family = conf$general$font
      ))
      pobj2[[i]] <- choose_ggplot_theme(pobj2[[i]], theme)
    }
    p4 <- plot_grid_enrich_res(pobj4) + plot_annotation(title = title)
    ret[["p4"]] <- p4
  }
  return(ret)
}
