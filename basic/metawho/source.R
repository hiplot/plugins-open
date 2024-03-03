# @hiplot start
# @appname metawho
# @apptitle
# Meta-Subgroup analysis
# 元分析亚组比较
# @target basic
# @tag meta comparison forestplot
# @author Hiplot team | Shixiang Wang
# @url https://github.com/ShixiangWang/metawho
# @citation
# - Wang, Shixiang, et al. “The predictive power of tumor mutational burden in lung cancer immunotherapy response is influenced by patients’ sex.” International journal of cancer (2019).
# - Fisher, David J., et al. “Meta-analytical methods to identify who benefits most from treatments: daft, deluded, or deft approach?.” bmj 356 (2017): j573.
# @version 0.1.0
# @release 2021-03-07
# @description
# en: Meta-analytical method to Identify Who Benefits Most from Treatments
# zh: 确定谁从治疗中获益最大的元分析方法
# @main who
# @library metawho
# @param data export::data::hiplot-textarea::{"default": "data.txt", "required": true}
# en: Data Table
# zh: 数据表
# @param conf_interval export::extra::slider::{"default":0.95, "min":0, "max":1, "step":0.01, "class":"col-12"}
# en: Confidence interval
# zh: 置信区间
# @return ggplot::["pdf", "png"]::{"cliMode": true, "width":8, "height": 6}
# @data
# ### specify hazard ratios (hr)
# hr <- c(0.30, 0.11, 1.25, 0.63, 0.90, 0.28)
# ### specify lower bound for hr confidence intervals
# ci.lb <- c(0.09, 0.02, 0.82, 0.42, 0.41, 0.12)
# ### specify upper bound for hr confidence intervals
# ci.ub <- c(1.00, 0.56, 1.90, 0.95, 1.99, 0.67)
# ### specify sample number
# ni <- c(16L, 18L, 118L, 122L, 37L, 38L)
# ### trials
# trial <- c(
#   "Rizvi 2015", "Rizvi 2015",
#   "Rizvi 2018", "Rizvi 2018",
#   "Hellmann 2018", "Hellmann 2018"
# )
# ### subgroups
# subgroup <- rep(c("Male", "Female"), 3)
#
# entry <- paste(trial, subgroup, sep = "-")
# wang2019 <-
#   data.frame(
#     entry = entry,
#     trial = trial,
#     subgroup = subgroup,
#     hr = hr,
#     ci.lb = ci.lb,
#     ci.ub = ci.ub,
#     ni = ni,
#     stringsAsFactors = FALSE
#   )
# write_tsv(wang2019, "data.txt")
# @hiplot end

pkgs <- c("metawho")
pacman::p_load(pkgs, character.only = TRUE)

who <- function(data, conf_interval) {
  data = deft_prepare(data, conf_level = 1 - conf_interval)
  res = deft_do(data, group_level = unique(data$subgroup))
  # Here export a ggplot object
  # Or the whole main function generate a basic R plot
  p1 = deft_show(res, element = "all")
  p2 = deft_show(res, element = "subgroup")
  p = plot_grid(p1, p2, nrow = 2)
  return(p)
}

