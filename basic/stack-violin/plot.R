# AppName: StackViolin
# Author: benben-miao
# Email: benben.miao@outlook.com
# Github: https://github.com/benben-miao
# Date: 2020-08-23
pkgs <- c("limma", "Seurat", "magrittr", "ggplot2", "openxlsx")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
}

############# Section 2 #############
#           plot section
#####################################
{
  data <- as.matrix(data)
  rownames(data) <- data[, 1]
  exp <- data[, 2:ncol(data)]
  dimnames <- list(
    rownames(exp),
    colnames(exp)
  )
  data <- matrix(as.numeric(as.matrix(exp)),
    nrow = nrow(exp),
    dimnames = dimnames
  )
  data <- avereps(data,
    ID = rownames(data)
  )
  # 将矩阵转换为Seurat对象，并对数据进行过滤
  pbmc <- CreateSeuratObject(
    counts = data,
    project = "seurat",
    min.cells = 0,
    min.features = 0,
    names.delim = "_",
  )
  # 使用PercentageFeatureSet函数计算线粒体基因的百分比
  pbmc[["percent.mt"]] <- PercentageFeatureSet(
    object = pbmc,
    pattern = "^MT-"
  )
  # 对数据进行过滤
  pbmc <- subset(
    x = pbmc,
    subset = nFeature_RNA > 50 & percent.mt < 5
  )
  # 对数据进行标准化
  pbmc <- NormalizeData(
    object = pbmc,
    normalization.method = "LogNormalize",
    scale.factor = 10000
  )
  # 提取那些在细胞间变异系数较大的基因
  pbmc <- FindVariableFeatures(
    object = pbmc,
    selection.method = "vst",
    nfeatures = 1500
  )
  # PCA降维之前的标准预处理步骤
  pbmc <- ScaleData(pbmc)
  pbmc <- RunPCA(
    object = pbmc,
    npcs = 20,
    pc.genes = VariableFeatures(object = pbmc)
  )
  # 每个PC的p值分布和均匀分布
  pbmc <- JackStraw(
    object = pbmc,
    num.replicate = 100
  )
  pbmc <- ScoreJackStraw(
    object = pbmc,
    dims = 1:20
  )
  # 计算邻接距离
  pbmc <- FindNeighbors(
    object = pbmc,
    dims = 1:20
  )
  # 对细胞分组,优化标准模块化
  pbmc <- FindClusters(
    object = pbmc,
    resolution = 0.5
  )
  # TSNE聚类
  pbmc <- RunTSNE(
    object = pbmc,
    dims = 1:20
  )
  # 寻找差异表达的特征
  log_fc_filter <- 0.5
  adj_pval_filter <- 0.05
  pbmc_markers <- FindAllMarkers(
    object = pbmc,
    only.pos = FALSE,
    min.pct = 0.25,
    logfc.threshold = log_fc_filter
  )
  pbmc_sig_markers <- pbmc_markers[(abs(as.numeric(
    as.vector(pbmc_markers$avg_logFC)
  )) > log_fc_filter &
    as.numeric(as.vector(pbmc_markers$p_val_adj)) <
      adj_pval_filter), ]
  modify_vlnplot <- function(obj,
                             feature,
                             pt.size = 0,
                             plot.margin = unit(c(-0.75, 0, -0.75, 0), "cm"),
                             ...) {
    p <- VlnPlot(obj,
      features = feature,
      pt.size = pt.size,
      ...
    )
    theme <- conf$general$theme
    p <- choose_ggplot_theme(p, theme)

    p <- p +
      xlab("") +
      ylab(feature) +
      ggtitle(conf$general$title) +
      theme(
        axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks.x = element_blank(),
        axis.ticks.y = element_line(),
        axis.title.y = element_text(angle = conf$extra$yangle, vjust = 0.5),
        plot.margin = plot.margin,
        text = element_text(
          family = conf$general$font
        ),
        plot.title = element_text(
          size = conf$general$titleSize,
          hjust = 0.5
        ),
        axis.title = element_text(
          size = conf$general$axisTitleSize
        ),
        legend.position = conf$general$legendPos,
        legend.direction = conf$general$legendDir,
        legend.title = element_text(
          size = conf$general$legendTitleSize
        ),
        legend.text = element_text(
          size = conf$general$legendTextSize
        )
      ) +
      return_hiplot_palette_color(conf$general$palette,
        conf$general$paletteCustom) +
      return_hiplot_palette(conf$general$palette,
        conf$general$paletteCustom)
    return(p)
  }

  ## main function
  stacked_vln_plot <- function(obj,
                             features,
                             pt.size = 0,
                             plot.margin = unit(c(-0.75, 0, -0.75, 0), "cm"),
                             ...) {
    plot_list <- purrr::map(
      features,
      function(x) {
        modify_vlnplot(
          obj = obj,
          feature = x,
          ...
        )
      }
    )
    plot_list[[length(plot_list)]] <- plot_list[[length(plot_list)]] +
      theme(
        axis.text.x = element_text(),
        axis.ticks.x = element_line()
      )
    p <- patchwork::wrap_plots(
      plotlist = plot_list,
      ncol = 1
    )
    return(p)
  }

  p <- stacked_vln_plot(pbmc, data2[, 1], pt.size = 0)
}

############# Section 3 #############
#          output section
#####################################
{
  write.xlsx(
    pbmc_sig_markers,
    paste0(opt$outputFilePrefix, "sigMarkers.xlsx")
  )
  export_single(p)
}
