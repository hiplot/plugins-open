# @hiplot start
# @appname group-comparison
# @apptitle
# Plot heatmap for sub-group comparison
# 分组比较热图
# @target basic
# @tag group heatmap comparison
# @author Shixiang Wang
# @url https://github.com/ShixiangWang/sigminer
# @citation See citation part of https://github.com/ShixiangWang/sigminer
# @version 0.1.0
# @release 2022-05-13
# @description
# en: Plot heatmap for sub-group comparison
# zh: 分组比较热图
# @main plotentry
# @library ggplot2 readr
# @param data export::data::hiplot-textarea::{"default": "data.txt", "required": true}
# en: Data Table
# zh: 数据表
# @param grp_vars export::dataArg::data::{"index":1, "default": "g1", "required": true, "class":"col-12 col-md-6"}
# en: Group variable
# zh: 分组变量
# @param enrich_vars export::dataArg::data::{"index":2, "default": ["e1", "e2"], "required": true, "class":"col-12 col-md-6"}
# en: Comparison variable
# zh: 比较变量
# @param cross export::extra::switch::{"default": true, "class":"col-12 col-md-4"}
# en: Cross the variable combination
# zh: 进行变量组合
# @param add_text_annotation export::extra::switch::{"default": true, "class":"col-12 col-md-4"}
# en: Add text annotation
# zh: 添加文本注释
# @param fill_by_p_value export::extra::switch::{"default": true, "class":"col-12 col-md-4"}
# en: Fill by P value
# zh: 用P值作为填充值
# @param use_fdr export::extra::switch::{"default": true, "class":"col-12 col-md-4"}
# en: Use FDR value
# zh: 使用矫正P值
# @param cut_p_value export::extra::switch::{"default": false, "class":"col-12 col-md-4"}
# en: Cut P values
# zh: 使用P值分组
# @param cluster_row export::extra::switch::{"default": false, "class":"col-12 col-md-4"}
# en: Cluster rows
# zh: 对亚组聚类
# @param co_method export::extra::select::{"default": "t.test", "items": ["t.test", "wilcox.test"], "class":"col-12 col-md-6"}
# en: Co
# zh: 点大小
# @param scales export::extra::select::{"default": "free", "items": ["free", "fixed"], "class":"col-12 col-md-6"}
# en: Scale
# zh: 标尺
# @param ref_group export::extra::combobox::{"default":[], "items_func": "this.selectCols('1-data', 0)", "multiple":true, "class":"col-12 col-md-12"}
# en: Reference subgroup
# zh: 参考亚组
# @return ggplot::["pdf", "png"]::{"cliMode": true, "title": "", "width":3, "height": 2, "theme": "theme_bw"}
# @data
# set.seed(1234)
# df <- data.frame(
#   g1 = rep(LETTERS[1:3], c(50, 40, 10)),
#   g2 = rep(c("AA", "VV", "XX"), c(50, 40, 10)),
#   e1 = sample(c("P", "N"), 100, replace = TRUE),
#   e2 = rnorm(100)
# )
# write_tsv(df, "data.txt")
# @hiplot end
if (packageVersion("sigminer") < "2.1.5") remotes::install_github("ShixiangWang/sigminer")
library(sigminer)

unlist_and_covert <- function(x, recursive = FALSE) {
  if (!is.null(x)) {
    x <- unlist(x, recursive = recursive)
    if (!is.null(x)) {
      y <- sapply(x, function(x) {
        if (identical(x, "NA")) NA else x
      })
      names(y) <- names(x)
      x <- y
    }
  }
  x
}

plotentry <- function(data,
                      grp_vars = NULL, enrich_vars = NULL, cross = TRUE,
                      co_method = c("t.test", "wilcox.test"), ref_group = NA,
                      scales = "free", add_text_annotation = TRUE,
                      fill_by_p_value = TRUE, use_fdr = TRUE, cut_p_value = FALSE,
                      cluster_row = FALSE) {
  ref_group <- unlist_and_covert(ref_group)
  if (is.null(ref_group)) ref_group <- NA
  rv <- group_enrichment(data, grp_vars, enrich_vars, cross, co_method, ref_group)
  if (length(unique(rv$grp_var)) == 1) {
    p <- show_group_enrichment(rv,
      return_list = TRUE,
      scales = scales, add_text_annotation = add_text_annotation,
      fill_by_p_value = fill_by_p_value, use_fdr = use_fdr, cut_p_value = cut_p_value,
      cluster_row = cluster_row
    )
    p <- p[[1]]
  } else {
    p <- show_group_enrichment(rv,
      scales = scales, add_text_annotation = add_text_annotation,
      fill_by_p_value = fill_by_p_value, use_fdr = use_fdr, cut_p_value = cut_p_value,
      cluster_row = cluster_row
    )
  }
  return(p)
}