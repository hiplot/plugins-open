
#######################################################
# Author: houshi xu                                   #
# Copyright (C) 2020 by Hiplot Team                   #
# All rights reserved.                                #
#######################################################

pkgs <- c("clusterProfiler")
pacman::p_load(pkgs, character.only = TRUE)

{
  data[,2] <- as.numeric(data[,2])
  geneList <- data[,2]
  names(geneList) <- data[,1]
  geneList <- sort(geneList, decreasing = TRUE)

  term <- data.frame(term=data2[,1],
                  gene=data2[,2])

  y <- clusterProfiler::GSEA(geneList,TERM2GENE = term,pvalueCutoff = 1)

  p <- gseaplot(
            y,
              y@result$Description[1],
              color = conf$extra$color,
              by = "runningScore",
              color.line = conf$extra$colorLine,
              color.vline= conf$extra$colorVline,
              title = conf$general$title,
          )
  
  theme <- conf$general$theme
  p <- choose_ggplot_theme(p, theme)
}

{
  export_single(p)
}


