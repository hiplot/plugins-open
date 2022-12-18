#######################################################
# Discover-mut-test.                                  #
#-----------------------------------------------------#
# Author: Jianfeng Li                                 #
# Email: lee_jianfeng@hiplot.org                      #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2021-11-03                                    #
# Version: 0.1                                        #
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
  pacman::p_load(discover)
  pacman::p_load(corrplot)
  pacman::p_load(ggplotify)
  pacman::p_load(openxlsx)
  pacman::p_load(ggplot2)
  pacman::p_load(patchwork)

  samplename <- conf$dataArg[[1]][[1]]$value
  gene <- conf$dataArg[[1]][[2]]$value
  mutclass <- conf$dataArg[[1]][[3]]$value
  print(samplename)
  print(gene)
  print(mutclass)
}

############# Section 2 #############
#           plot section
#####################################
{
  count <- table(data[,gene])
  data <- data[data[,gene] %in% names(count)[count > 2],]
  genes <- unique(data[,gene])
  samples <- unique(data2[,1])
  dat <- NULL
  for (i in genes) {
    tmp <- rep(0, length(samples))
    tmp_mut <- data[data[,gene] == i, samplename]
    idx <- samples %in% tmp_mut
    tmp[idx] <- 1
    dat <- rbind(dat, tmp)
    row.names(dat)[nrow(dat)] <- i
  }
  colnames(dat) <- samples
  dat <- dat[rowSums(dat) >= conf$extra$number_thread,]
  events <- discover.matrix(dat)
  result.mutex_greater <- pairwise.discover.test(events, alternative = "greater")
  result.mutex_less <- pairwise.discover.test(events)
  res <- as.data.frame(result.mutex_less, q.threshold = 1)
  res2 <- as.data.frame(result.mutex_greater, q.threshold = 1)
  wb <- createWorkbook()
  addWorksheet(wb, "discover.test.exclusive")
  addWorksheet(wb, "discover.test.concourrence")
  writeData(wb, "discover.test.exclusive", res)
  writeData(wb, "discover.test.concourrence", res2)

  col2 = colorRampPalette(c('#67001F', '#B2182B', '#D6604D', '#F4A582',
                            '#FDDBC7', '#FFFFFF', '#D1E5F0', '#92C5DE',
                            '#4393C3', '#2166AC', '#053061'))
  res <- res[res$q.value < conf$extra$q_thread_1,]
  res2 <- res2[res2$q.value < conf$extra$q_thread_2,]

  genes <- c()
  if (nrow(res) != 0) {
    genes <- c(res$gene1, res$gene2)
  }
  if (nrow(res2) != 0) {
    genes <- c(genes, res2$gene1, res2$gene2)
  }
  genes <- unique(genes)
  print(res)
  print(res2)
 
  len <- length(genes)
  q2 <- as.data.frame(matrix(1, len, len))
  rownames(q2) <- genes
  colnames(q2) <- genes

  if (nrow(res) > 0) {
    for (i in 1:nrow(res)) {
      q2[res$gene1[i], res$gene2[i]] <- res$q.value[i]
      q2[res$gene2[i], res$gene1[i]] <- res$q.value[i]
    }
  }
  if (nrow(res2) > 0) {
    for (i in 1:nrow(res2)) {
        q2[res2$gene1[i], res2$gene2[i]] <- res2$q.value[i]
        q2[res2$gene2[i], res2$gene1[i]] <- res2$q.value[i]
    }
  }
  q <- log10(q2)
  if (nrow(res2) > 0) {
    for (i in 1:nrow(res2)) {
      q[res2$gene1[i], res2$gene2[i]] <- q[res2$gene1[i], res2$gene2[i]] * -1
      q[res2$gene2[i], res2$gene1[i]] <- q[res2$gene2[i], res2$gene1[i]] * -1
    }
  }
  q <- as.matrix(q)
  q2 <- as.matrix(q2)
  col <- rev(col2(100))
  if (all(q <= 0)) {
    col <- col[1:round(length(col) / 2)]
  }
  if (all(q >= 0)) {
    col <- col[round(length(col) / 2):length(col)]
  }
  p <- as.ggplot(function(){
    print(
      corrplot(q, order = "hclust", type = "lower",
            is.corr = FALSE,
            diag = FALSE, tl.col = 'black',
            col = col,
            p.mat = q2,
            sig.level = c(0.001, 0.01),
            pch.cex = 0.9, insig = 'label_sig',
            mar = c(2,2,2,2)
        )
      )
    }) + ggtitle("Discover test (Q value)") + theme(plot.margin = unit(rep(1,4), 'lines'))

  p2 <- as.ggplot(function(){
    print(plot(events[genes,]))
  })
}

############# Section 3 #############
#          output section
#####################################
{
   if (conf$extra$waterfall) {
    p <- p + p2 + plot_layout(ncol = 2, widths = c(1, 1.3)) + 
      plot_annotation(tag_level = "A")
   }
   export_single(p)
   saveWorkbook(wb, paste0(opt$outputFilePrefix, ".xlsx"), overwrite = TRUE)
}
