#######################################################
# Gene expression cluster trend.                      #
#-----------------------------------------------------#
# Author: < Wei Dong >                                #
# Email: dongw26@mail2.sysu.edu.cn                    #
# Website: http://bioinfomics.top/                    #
#                                                     #
# Date: 2020-11-17                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2020 by Hiplot Team                   #
# All rights reserved.                                #
#######################################################

# load required packages
pkgs <- c("Mfuzz", "ggplotify", "RColorBrewer", "openxlsx")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  # check data columns
  if (ncol(data) < 2) {
    stop("Error: Input data should have at least 2 columns!")
  }
  
  # set the color palettes
  # The diverging palettes are: BrBG PiYG PRGn PuOr RdBu RdGy RdYlBu RdYlGn Spectral
  pal <- conf$general$paletteCont
  if (pal != "custom") {
    palettes <- brewer.pal(8, pal)
  } else {
    palettes <- custom_color_filter(conf$general$paletteCustom)
  }
  colors <- rev(colorRampPalette(palettes)(1000))
}

############# Section 2 #############
#           plot section
#####################################
{
  # 将基因表达矩阵转换为ExpressionSet对象
  row.names(data) <- data[,1]
  data <- data[,-1]
  data <- as.matrix(data)
  eset <- new("ExpressionSet",exprs = data)
  # Data pre-processing
  # 过滤缺失值超过25%的基因
  eset <- filter.NA(eset,thres=conf$extra$thres)
  # 根据均值mean填补缺失值
  #eset <- fill.NA(eset,mode="mean",k=10)
  
  # 根据标准差去除样本间差异太小的基因
  eset <- filter.std(eset,min.std=conf$extra$min_std,visu = F)
  
  # 数据标准化
  eset <- standardise(eset)
  
  # 设定聚类数目
  c <- conf$extra$cluster_num
  
  # 评估出最佳的m值
  m <- mestimate(eset)
  
  # 进行mfuzz聚类
  cl <- mfuzz(eset, c = c, m = m)
  
  # 提取聚类分群结果
  out_cluster <- as.data.frame(cbind(Gene=names(cl$cluster),eset@assayData$exprs,Cluster=paste0("Cluster ",cl$cluster)))
  
  if (is.null(conf$extra$centre)) {
    conf$extra$centre <- TRUE
  }
  # 绘制基因表达聚类趋势折线图
  p <- as.ggplot(function(){
        mfuzz.plot2(
        eset,
        cl,
        xlab = conf$general$xlab,
        ylab = conf$general$ylab,
        mfrow = c(2,(c/2+0.5)),
        colo = colors,
        centre = conf$extra$centre,
        centre.col = "red",
        time.labels = colnames(eset),
        x11=F)
    })
}

############# Section 3 #############
#          output section
#####################################
{
  keep_vars <- c(keep_vars, cl)
  write.xlsx(
    out_cluster,
    paste0(opt$outputFilePrefix, "outCluster.xlsx")
  )
  export_single(p)
}
