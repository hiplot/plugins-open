# @hiplot start
# @appname ggpubr-boxplot
# @apptitle
# GGPubr Boxplot
# GGPubr 箱线图
# @target basic
# @tag boxplot comparison
# @author Hiplot team | Shixiang Wang
# @url https://github.com/kassambara/ggpubr/
# @citation Alboukadel Kassambara (2020). ggpubr: 'ggplot2' Based Publication Ready Plots. R package version 0.4.0. https://CRAN.R-project.org/package=ggpubr
# @version 0.1.0
# @release 2021-03-07
# @description
# en: Feature-rich boxplot (GGPubr interface)
# zh: 特性丰富的箱线图（GGPubr 接口）
# @main ggpubr::ggboxplot
# @library ggpubr readr
# @param data export::data::hiplot-textarea::{"default": "data.txt", "required": true}
# en: Data Table
# zh: 数据表
# @param x export::dataArg::data::{"index":1, "default": "supp", "required": true}
# en: X Axis Variable
# zh: X 轴变量
# @param y export::dataArg::data::{"index":2, "default": ["len", "dose"], "required": true, "multiple": true}
# en: Y Axis Variable
# zh: Y 轴变量
# @param facet.by export::dataArg::data::{"index":3, "required": false}
# en: Facet Variable
# zh: 分面变量
# @param combine export::extra::switch::{"default": false, "class":"col-12 col-md-6"}
# en: Combine Multiple Y Variables
# zh: 结合多个 Y 轴变量
# @param merge export::extra::switch::{"default": false, "class":"col-12 col-md-6"}
# en: Merge Multiple Y Variables
# zh: 合并多个 Y 轴变量
# @param color export::extra::text-field::{"default": "black", "class":"col-12 col-md-6"}
# en: Outline Color (Can be column name)
# zh: 轮廓颜色（可以映射列名）
# @param fill export::extra::text-field::{"default": "white", "class":"col-12 col-md-6"}
# en: Fill Color (Can be column name)
# zh: 填充颜色（可以映射列名）
# @param bxp.errorbar export::extra::switch::{"default": false, "class":"col-12 col-md-6"}
# en: Shows Error Bars
# zh: 展示误差
# @param bxp.errorbar.width export::extra::slider::{"default":0.4, "min":0, "max":1, "step":0.1, "class":"col-12 col-md-6"}
# en: Error Bar Width
# zh: 误差宽度
# @param linetype export::extra::text-field::{"default": "solid", "class":"col-12 col-md-6"}
# en: Line Type
# zh: 线型
# @param size export::extra::slider::{"default":0.5, "min":0, "max":10, "step":0.1, "class":"col-12 col-md-6"}
# en: Point and Outline Size
# zh: 点和轮廓大小
# @param width export::extra::slider::{"default":0.7, "min":0, "max":1, "step":0.1, "class":"col-12 col-md-6"}
# en: Box Width
# zh: 箱宽
# @param outlier.shape export::extra::slider::{"default":19, "min":1, "max":100, "step":1, "class":"col-12 col-md-6"}
# en: Outlier Shape
# zh: 异常值点的形状
# @param add export::extra::select::{"default": "none", "items":["none", "dotplot", "jitter", "boxplot", "point", "mean", "mean_se", "mean_sd", "mean_ci", "mean_range", "median", "median_iqr", "median_hilow", "median_q1q3", "median_mad", "median_range"], "class":"col-12 col-md-6"}
# en: Add Other Plot Element
# zh: 添加其他图形元素
# @param error.plot export::extra::select::{"default":"pointrange", "items":["pointrange", "linerange", "crossbar", "errorbar", "upper_errorbar", "lower_errorbar", "upper_pointrange", "lower_pointrange", "upper_linerange", "lower_linerange"], "class":"col-12 col-md-6"}
# en: Error Plot Type
# zh: 误差可视化类型
# @param scales export::extra::select::{"default":"fixed", "items":["fixed", "free", "free_x", "free_y"], "class":"col-12 col-md-6"}
# en: Facet Scale Control
# zh: 分面标度控制
# @param notch export::extra::switch::{"default": false, "class":"col-12 col-md-6"}
# en: Add Notch
# zh: 添加凹槽
# @param repel export::extra::switch::{"default": false, "class":"col-12 col-md-6"}
# en: Avoid Overlap
# zh: 避免重叠
# @return ggplot::["pdf", "png"]::{"cliMode": true, "title": "A test plot", "width":4, "height": 4, "theme": "theme_bw", "palette": "jco"}
# @data
# library(readr)
# library(ggpubr)
# data("ToothGrowth")
# write_tsv(ToothGrowth, "data.txt")
# @hiplot end
pkgs <- c("ggpubr")
pacman::p_load(pkgs, character.only = TRUE)
