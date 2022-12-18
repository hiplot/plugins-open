#######################################################
# Eulerr charts.                                      #
#-----------------------------------------------------#
# Author: Jianfeng Li                                 #
# Email: lee_jianfeng@hiplot.org                      #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2021-11-04                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2022 by "National Center for          #
# Translational Medicine·Shanghai                     #
# All rights reserved.                                #
#######################################################

pkgs <- c("kohonen")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  target <- data[,1]
  target <- factor(target, levels = unique(target))
  data <- data[,-1]
  data <- as.data.frame(data)
  for (i in 1:ncol(data)) {
    data[,i] <- as.numeric(data[,i])
  }
  data <- as.matrix(data)
  set.seed(7)
  xdim <- conf$extra$xdim
  ydim <- conf$extra$ydim
  topo <- conf$extra$topo
  kohmap <- xyf(scale(data), target,
                grid = somgrid(xdim, ydim, topo), rlen=100)
  keep_vars <- c(keep_vars, kohmap)

  color_key <- get_hiplot_color(conf$general$paletteCont, -1, conf$general$paletteCustom)
  colors <- function (n, alpha, rev = FALSE) {
    colorRampPalette(color_key)(n)
  }
}

############# Section 2 #############
#           plot section
#####################################
{
  p <- function () {
    par(mfrow = c(3,2))
    xyfpredictions <- classmat2classvec(getCodes(kohmap, 2))
    plot(kohmap, type="counts", col = as.integer(target),
        palette.name = colors,
        pchs = as.integer(target), 
        main = "Counts plot", shape = "straight", border = NA)

    som.hc <- cutree(hclust(object.distances(kohmap, "codes")), conf$extra$classCount)
    add.cluster.boundaries(kohmap, som.hc)

    plot(kohmap, type="mapping",
        labels = as.integer(target), col = colors(3)[as.integer(target)],
        palette.name = colors,
        shape = "straight",
        main = "Mapping plot")

    ## add background colors to units according to their predicted class labels
    xyfpredictions <- classmat2classvec(getCodes(kohmap, 2))
    bgcols <- colors(3)
    plot(kohmap, type="mapping", col = as.integer(target),
        pchs = as.integer(target), bgcol = bgcols[as.integer(xyfpredictions)],
        main = "Another mapping plot", shape = "straight", border = NA)

    similarities <- plot(kohmap, type="quality", shape = "straight",
                        palette.name = colors)

    plot(kohmap, type="codes", shape = "straight", 
        main = c("Codes X", "Codes Y"), palette.name = colors)

    set.seed(7)
    sommap <- som(scale(data),grid = somgrid(xdim, ydim, topo))

    ## and the same for rectangular maps
    plot(sommap, type="dist.neighbours", 
        shape = "straight",
        palette.name = colors,
        main = "SOM neighbour distances")
    ## use hierarchical clustering to cluster the codebook vectors
    som.hc <- cutree(hclust(object.distances(sommap, "codes")), conf$extra$classCount)
    add.cluster.boundaries(sommap, som.hc)

    ## Show 'component planes'
    if (conf$extra$drawProperty) {
      for (i in 1:ncol(getCodes(sommap, 1))) {
        set.seed(7)
        sommap <- som(scale(data), grid = somgrid(xdim, ydim, topo))
        plot(sommap, shape = "straight", type = "property", 
            property = getCodes(sommap, 1)[,i],
            palette.name = colors,
            main = colnames(getCodes(sommap, 1))[i])
      }
    }
  }
}

############# Section 3 #############
#          output section
#####################################
{
  cat(sprintf('kohmap <- xyf(scale(data), target,
                grid = somgrid(%s, %s, %s), rlen=100)', xdim, ydim, topo), sep = "\n")
  print(p)
  outpdf <- sprintf("%s.pdf", opt$outputFilePrefix)
  pdf(
    outpdf,
    width = conf$general$size$width,
    height = conf$general$size$height,
  )
  p()
  dev.off()
  pdf2image(outpdf)
}

