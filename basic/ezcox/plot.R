#######################################################
# Easy cox analysis and visualization.                #
#-----------------------------------------------------#
# Author: Shixiang Wang                               #
#                                                     #
# Date: 2020-08-10                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2020 by Hiplot Team                   #
# All rights reserved.                                #
#######################################################

# pv=ezcox
# Rscript run_debug.R -c $pv/data.json -i $pv/data.txt -o $pv/test -t $pv --enableExample

# 函数参数除了 default，其他直接转换 hiplot 前端支持的所有选项
#
# @hiplot start
# @appname ezcox
# @apptitle
# Cox Models Forest
# Cox 模型森林图
# @target basic
# @tag model survival
# @author Hiplot Team | Shixiang Wang
# @email wangshx@shanghaitech.edu.cn
# @url https://github.com/ShixiangWang/ezcox
# @citation Wang, Shixiang, et al. "The predictive power of tumor
# mutational burden in lung cancer immunotherapy response is influenced
# by patients' sex." International journal of cancer (2019).
# @version v0.2.0
# @release 2020-08-11
# @description
# en: Used for survival data analysis.
# zh: 用于生存数据分析。
# @main call_ezcox
# @library readr ezcox
#
# @param data export::data::hiplot-textarea::{"default": "data.txt", "required": true}
# en: A table with at least 3 columns, the 1rd and 2nd columns refer to 'time' and
# 'survival' of sample.
# zh: 至少 3 列的数值的表格，第 1 列和第 2 列分别对应样本的生存时间和状态。
#
# @param covariates export::dataArg::data::{"index":1, "default":["sex","ph.ecog"], "blackItems":["time","status"], "required":true}
# en: Batch Process Covariates
# zh: 批处理协变量
# @param controls export::dataArg::data::{"index":2, "default":"age", "blackItems":["time","status"], "required":false}
# en: Controls
# zh: 控制变量
# @param vars_to_show export::dataArg::data::{"index":3, "blackItems":["time","status"], "required":false, "individual":true}
# en: Select Show Variables
# zh: 展示变量
# @param merge_models export::extra::switch::{"default": false}
# en: Merge Models
# zh: 合并模型
# @param drop_controls export::extra::switch::{"default": false}
# en: Drop Controls
# zh: 去除控制变量
# @param add_caption export::extra::switch::{"default": true}
# en: Add Caption
# zh: 添加说明文字
#
# @return ggplot::["pdf", "png"]::{"width": 6, "height": 4}
# @data
# # 此处可以编写生成示例数据的代码
# # 示例数据文件需要跟数据表格参数对应起来
# # 或者忽略该标签，手动提交示例数据
# library(readr)
# library(survival)
# write_tsv(lung[, c("time", "status", "sex", "ph.ecog", "age")], "data.txt")
# @hiplot end
# ====================== Plugin Caller ======================

p <- call_ezcox(
  data = data,
  covariates = unlist(conf$dataArg[[1]][[1]]$value),
  controls = unlist(conf$dataArg[[1]][[2]]$value),
  vars_to_show = unlist(conf$dataArg[[1]][[3]]$value),
  merge_models = conf$extra$merge_models,
  drop_controls = conf$extra$drop_controls,
  add_caption = conf$extra$add_caption
)

export_single(p)
