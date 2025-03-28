#######################################################
# Copyright (C) 2020 by Hiplot Team                   #
# All rights reserved.                                #
#######################################################
pkgs <- c("PCAtools", "ggplotify", "openxlsx")
pacman::p_load(pkgs, character.only = TRUE)

# @hiplot start
# @appname pcatools
# @apptitle
# PCAtools
# 主成分分析 (PCAtools)
# @target basic
# @tag correlation dimension
# @author Jianfeng
# @email admin@hiplot.org
# @url https://github.com/kevinblighe/PCAtools
# @version 0.1.0
# @release 2021-01-31
# @description
# en: Dimension reduction methods
# zh: 常规降维
#
# @main call_pcatools
# @library PCAtools
#
# @param datTable export::data::hiplot-textarea::{"default": {"value":"public/demo/pcatools/data.txt", "link":""}, "required": true}
# en: Data Table
# zh: 数据表
# @param sampleInfo export::data::hiplot-textarea::{"default": {"value":"public/demo/pcatools/data2.txt", "link":""}, "required": true}
# en: Sample Info
# zh: 样本信息
# @param screeplotComponents export::extra::slider::{"default":30, "min":1, "max":999, "step":1, "class":"col-12 col-md-6"}
# en: Screeplot Components
# zh: 崖低碎石图主成分数目
# @param pairsplotComponents export::extra::slider::{"default":3, "min":1, "max":999, "step":1, "class":"col-12 col-md-6"}
# en: Pairsplot Components
# zh: 散点矩阵图主成分数目
# @param plotloadingsComponents export::extra::slider::{"default":5, "min":1, "max":999, "step":1, "class":"col-12 col-md-6"}
# en: Plotloadings Components
# zh: 载荷图主成分数目
# @param eigencorplotComponents export::extra::slider::{"default":10, "min":1, "max":999, "step":1, "class":"col-12 col-md-6"}
# en: Eigencorplot Components
# zh: 关联热图主成分数目
# @param top_var export::extra::slider::{"default":90, "min":1, "max":100, "step":1, "class":"col-12"}
# en: Top Variance
# zh: Top 方差
# @param biplotColBy export::dataArg::sampleInfo::{"default": "", "index":1, "individual": true, "class":"col-12 col-md-6"}
# en: Biplot Color By
# zh: 双标图颜色列
# @param biplotShapeBy export::dataArg::sampleInfo::{"default": "", "index":2, "individual": true, "class":"col-12 col-md-6"}
# en: Biplot Shape By
# zh: 双标图形状列
# @param eigencorplotMetavars export::dataArg::sampleInfo::{"default": "", "index":3, "individual": true, "class":"col-12", "multiple":true}
# en: Eigencorplot Phenotype
# zh: 关联热图表型列
# @param screeplotColBar export::extra::color-picker::{"default": "#0085FF", "class": "col-12 col-md-3"}
# en: Screeplot Bar
# zh: 崖低碎石图颜色
# @param plotloadingsLowCol export::extra::color-picker::{"default": "#0085FF", "class": "col-12 col-md-3"}
# en: Loadings Low
# zh: 载荷图低颜色
# @param plotloadingsMidCol export::extra::color-picker::{"default": "#FFFFFF", "class": "col-12 col-md-3"}
# en: Loadings Mid
# zh: 载荷图中颜色
# @param plotloadingsHighCol export::extra::color-picker::{"default": "#FF0000", "class": "col-12 col-md-3"}
# en: Loadings High
# zh: 载荷图高颜色
#
# @return ggplot::["pdf", "png"]::{"title": "", "width": 19, "height": 14, "palette": "lancet"}
# @hiplot end
call_pcatools <- function(datTable, sampleInfo,
                          top_var,
                          screeplotComponents, screeplotColBar,
                          pairsplotComponents,
                          biplotShapeBy, biplotColBy,
                          plotloadingsComponents,
                          plotloadingsLowCol,
                          plotloadingsMidCol,
                          plotloadingsHighCol,
                          eigencorplotMetavars,
                          eigencorplotComponents) {
  row.names(datTable) <- datTable[, 1]
  datTable <- datTable[, -1]
  row.names(sampleInfo) <- sampleInfo[, 1]
  data3 <<- pca(datTable, metadata = sampleInfo, removeVar = (100 - top_var) / 100)

  for (i in c("screeplotComponents", "pairsplotComponents", "plotloadingsComponents", 
              "eigencorplotComponents")) {
    if (ncol(data3$rotated) < get(i)) {
      assign(i, ncol(data3$rotated))
    }
  }

  if (is.null(conf$general$legendPos)) {
    conf$general$legendPos <- "bottom"
  }
  p1 <- PCAtools::screeplot(
    data3,
    components = getComponents(data3, 1:screeplotComponents),
    axisLabSize = 14, titleLabSize = 20,
    colBar = screeplotColBar,
    gridlines.major = FALSE, gridlines.minor = FALSE,
    returnPlot = TRUE
  )

  params_pairsplot <- list(
    data3,
    components = getComponents(data3, c(1:pairsplotComponents)),
    triangle = TRUE, trianglelabSize = 12,
    hline = 0, vline = 0,
    pointSize = 0.8, gridlines.major = FALSE, gridlines.minor = FALSE,
    title = "", plotaxes = FALSE,
    margingaps = unit(c(0.01, 0.01, 0.01, 0.01), "cm"),
    returnPlot = TRUE,
    colkey = get_hiplot_color(
      conf$general$palette, -1,
      conf$general$paletteCustom
    ),
    legendPosition = "none"
  )
  params_biplot <- list(data3,
    showLoadings = TRUE,
    lengthLoadingsArrowsFactor = 1.5,
    sizeLoadingsNames = 4,
    colLoadingsNames = "red4",
    # other parameters
    lab = NULL,
    hline = 0, vline = c(-25, 0, 25),
    vlineType = c("dotdash", "solid", "dashed"),
    gridlines.major = FALSE, gridlines.minor = FALSE,
    pointSize = 5,
    legendLabSize = 16, legendIconSize = 8.0,
    drawConnectors = FALSE,
    title = "PCA bi-plot",
    subtitle = "PC1 versus PC2",
    caption = "27 PCs ≈ 80%",
    returnPlot = TRUE,
    legendPosition = conf$general$legendPos
  )
  if (!is.null(biplotShapeBy) && biplotShapeBy != "") {
    params_biplot$shape <- biplotShapeBy
    params_pairsplot$shape <- biplotShapeBy
    t <- params_biplot[[1]]$metadata[,biplotShapeBy]
    params_biplot[[1]]$metadata[,biplotShapeBy] <- factor(t,
      levels = t[!duplicated(t)]
    )
    params_pairsplot[[1]]$metadata[,biplotShapeBy] <- factor(t,
      levels = t[!duplicated(t)]
    )
  }
  if (!is.null(biplotColBy) && biplotColBy != "") {
    params_pairsplot$colby <- biplotColBy
    params_pairsplot$colkey <- get_hiplot_color(
      conf$general$palette, -1,
      conf$general$paletteCustom
    )
    params_biplot$colby <- biplotColBy
    params_biplot$colkey <- get_hiplot_color(
      conf$general$palette, -1,
      conf$general$paletteCustom
    )
    t1 <- params_biplot[[1]]$metadata[,biplotColBy]
    params_biplot[[1]]$metadata[,biplotColBy] <- factor(t1,
      levels = t1[!duplicated(t1)]
    )
    params_pairsplot[[1]]$metadata[,biplotColBy] <- factor(t1,
      levels = t1[!duplicated(t1)]
    )
  }

  p2 <- do.call(PCAtools::pairsplot, params_pairsplot)
  p3 <- do.call(PCAtools::biplot, params_biplot)

  p4 <- PCAtools::plotloadings(
    data3,
    rangeRetain = 0.01, labSize = 4,
    components = getComponents(data3, c(1:plotloadingsComponents)),
    title = "Loadings plot", axisLabSize = 12,
    subtitle = "PC1, PC2, PC3, PC4, PC5",
    caption = "Top 1% variables",
    gridlines.major = FALSE, gridlines.minor = FALSE,
    shape = 24, shapeSizeRange = c(4, 8),
    col = c(plotloadingsLowCol, plotloadingsMidCol, plotloadingsHighCol),
    legendPosition = "none",
    drawConnectors = FALSE,
    returnPlot = TRUE
  )

  if (length(eigencorplotMetavars) > 0 && all(eigencorplotMetavars != "")) {
    metavars <- eigencorplotMetavars
  } else {
    metavars <- colnames(sampleInfo)[2:ncol(sampleInfo)]
  }
  if (length(metavars) == 1 && metavars != colnames(sampleInfo)[1]) {
    metavars <- c(colnames(sampleInfo)[1], metavars)
  } else if (length(metavars) == 1 && metavars == colnames(sampleInfo)[1]) {
    stop('eigencorplotMetavars need >= 2 feature')
  }
  keep_vars <- c(keep_vars, "metavars")
  p5 <- PCAtools::eigencorplot(
    data3,
    components = getComponents(data3, 1:eigencorplotComponents),
    metavars = metavars,
    cexCorval = 1.0,
    fontCorval = 2,
    posLab = "all",
    rotLabX = 45,
    scale = TRUE,
    main = "PC clinical correlates",
    cexMain = 1.5,
    plotRsquared = FALSE,
    corFUN = conf$extra$corFUN,
    corUSE = conf$extra$corUSE,
    signifSymbols = c("****", "***", "**", "*", ""),
    signifCutpoints = c(0, 0.0001, 0.001, 0.01, 0.05, 1),
    returnPlot = TRUE
  )

  p6 <- plot_grid(
    p1, p2, p3,
    ncol = 3,
    labels = c("A", "B  Pairs plot", "C"),
    label_fontfamily = conf$general$font,
    label_fontface = "bold",
    label_size = 22,
    align = "h",
    rel_widths = c(1.10, 0.80, 1.10)
  )

  p7 <- plot_grid(
    p4,
    as.grob(p5),
    ncol = 2,
    labels = c("D", "E"),
    label_fontfamily = conf$general$font,
    label_fontface = "bold",
    label_size = 22,
    align = "h",
    rel_widths = c(0.8, 1.2)
  )

  p <- plot_grid(
    p6, p7,
    ncol = 1,
    rel_heights = c(1.1, 0.9)
  )

  out_xlsx <- paste(opt$outputFilePrefix, ".xlsx", sep = "")
  write.xlsx(as.data.frame(data3$rotated), out_xlsx, row.names = TRUE)

  return(p)
}
# ====================== Plugin Caller ======================

p <- call_pcatools(
  datTable = data,
  sampleInfo = data2,
  biplotColBy = conf$dataArg[[1]][[1]]$value,
  biplotShapeBy = conf$dataArg[[1]][[2]]$value,
  eigencorplotMetavars = conf$dataArg[[1]][[3]]$value,
  screeplotComponents = conf$extra$screeplotComponents,
  pairsplotComponents = conf$extra$pairsplotComponents,
  plotloadingsComponents = conf$extra$plotloadingsComponents,
  eigencorplotComponents = conf$extra$eigencorplotComponents,
  top_var = conf$extra$top_var,
  screeplotColBar = conf$extra$screeplotColBar,
  plotloadingsLowCol = conf$extra$plotloadingsLowCol,
  plotloadingsMidCol = conf$extra$plotloadingsMidCol,
  plotloadingsHighCol = conf$extra$plotloadingsHighCol
)

export_single(p)
