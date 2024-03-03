#######################################################
# Risk plot.                                          #
#-----------------------------------------------------#
# Author: Houshi Xu                                   #
# Affiliation: Shanghai Hiplot Team                   #
# Email: houshi@sjtu.edu.cn                           #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2021-03-10                                    #
# Version: 0.1.1                                      #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2020 by Hiplot Team                   #
# All rights reserved.                                #
#######################################################

pkgs <- c("survminer", "fastStat", "cutoff", "ggplot2")
pacman::p_load(pkgs, character.only = TRUE)

{
  label_vars <- c("time", "event", "riskscore")

  for (i in seq_len(length(conf$dataArg[[1]]))) {
    assign(label_vars[i], conf$dataArg[[1]][[i]]$value)
  }

  cutoff_value <- conf$extra[["cutoff"]]
  size_points <- conf$extra[["size_points"]]
  size_dashline <- conf$extra[["size_dashline"]]
  user_define<- conf$extra[["user_define"]]

  data[["time"]] <- data[, time]
  data[["event"]] <- data[, event]
  data[["riskscore"]] <- data[, riskscore]
  print(data)
}

##################################################################################

# 数据处理 1.排序；2.设定cutoff值（中位数、ROC、cox）；3.根据cutoff值分组

# FigureA risk plot
# FigureB survival plot
# FigureC Heatmap
# middle  index

# 为防止不同主题字体大小不同影响比例，所以不再使用其他主题

##################################################################################
{
  data <- data[order(data[, "riskscore"], decreasing = F), ]

  ############### 设定cutoff值

  if (cutoff_value == "roc") {
    cutoff_point <- cutoff::roc(
      score = data$riskscore,
      class = data[, "event"]
    )$cutoff
  } else if (cutoff_value == "median") {
    cutoff_point <- median(x = data$riskscore, na.rm = TRUE)
  } else if (cutoff_value == "cutoff") {
    rs <- cutoff::cox(
      data = data,
      time = "time",
      y = "event",
      x = "riskscore",
      cut.numb = 1,
      n.per = 0.1,
      y.per = 0.1,
      round = 20
    )

    fastStat::to.numeric(rs$p.adjust) <- 1
    cutoff_point <- (rs$cut1[rs$p.adjust == min(rs$p.adjust)])
    if (length(cutoff_point) > 1) cutoff_point <- cutoff_point[1]
  } else if (cutoff_value == "user_define") {
    cutoff_point <- as.numeric(user_define)
  } 

  #################### 分组

  data$Group <- ifelse(data$riskscore > cutoff_point, "High", "Low")

  #################### x轴定位

  cut.position <- (1:nrow(data))[data$riskscore == cutoff_point]

  if (length(cut.position) == 0) {
    cut.position <- which.min(abs(data$riskscore - cutoff_point))
  } else if (length(cut.position) > 1) {
    cut.position <- cut.position[length(cut.position)]
  }

  ##################### 生成画 A B 图所需data.frame

  data2 <- data[, c("time", "event", "riskscore", "Group")]

  ##########################################################

  ########## Figure A

  ##########################################################
  fA <- ggplot(
    data = data2,
    aes_string(
      x = 1:nrow(data2),
      y = data2$riskscore,
      color = "Group"
    )
  ) +
    geom_point(size = size_points) +
    scale_color_manual(
      name = "Risk Group",
      values = c(
        "Low" = conf$extra$low_color,
        "High" = conf$extra$high_color
      )
    ) +
    geom_vline(
      xintercept = cut.position,
      linetype = "dotted",
      size = size_dashline
    ) +
    # bg
    theme(
      panel.grid = element_blank(),
      panel.background = element_blank()
    ) +
    # x-axis
    theme(
      axis.ticks.x = element_blank(),
      axis.line.x = element_blank(),
      axis.text.x = element_blank(),
      axis.title.x = element_blank()
    ) +
    # y-axis
    theme(
      axis.title.y = element_text(
        size = 14,
        vjust = 1,
        angle = 90
      ),
      axis.text.y = element_text(size = 11),
      axis.line.y = element_line(size = 0.5, colour = "black"),
      axis.ticks.y = element_line(size = 0.5, colour = "black")
    ) +
    # legend
    theme(
      legend.title = element_text(size = 13),
      legend.text = element_text(size = 12)
    ) +
    coord_trans() +
    ylab("Risk Score") +
    scale_x_continuous(expand = c(0, 3))
  #####################################################
  # Figure B
  #####################################################
  fB <- ggplot(
    data = data2,
    aes_string(
      x = 1:nrow(data2),
      y = data2[, "time"],
      color = factor(ifelse(data2[, "event"] == 1, "Dead", "Alive"))
    )
  ) +
    geom_point(size = size_points) +
    scale_color_manual(
      name = "Status",
      values = c(
        "Alive" = conf$extra$low_color,
        "Dead" = conf$extra$high_color
      )
    ) +
    geom_vline(
      xintercept = cut.position,
      linetype = "dotted",
      size = size_dashline
    ) +
    theme(
      panel.grid = element_blank(),
      panel.background = element_blank()
    ) +
    # x a-xis
    theme(
      axis.ticks.x = element_blank(),
      axis.line.x = element_blank(),
      axis.text.x = element_blank(),
      axis.title.x = element_blank()
    ) +
    # y-axis
    theme(
      axis.title.y = element_text(
        size = 14,
        vjust = 2,
        angle = 90
      ),
      axis.text.y = element_text(size = 11),
      axis.ticks.y = element_line(size = 0.5),
      axis.line.y = element_line(size = 0.5, colour = "black")
    ) +
    theme(
      legend.title = element_text(size = 13),
      legend.text = element_text(size = 12)
    ) +
    ylab("Survival Time") +
    coord_trans() +
    scale_x_continuous(expand = c(0, 3))
  ################################################################
  # middle
  ################################################################
  middle <- ggplot(data2, aes(
    x = 1:nrow(data2),
    y = 1
  )) +
    geom_tile(aes(fill = data2$Group)) +
    scale_fill_manual(
      name = "Risk Group",
      values = c(
        "Low" = conf$extra$low_color,
        "High" = conf$extra$high_color
      )
    ) +
    theme(
      panel.grid = element_blank(),
      panel.background = element_blank(),
      axis.line = element_blank(),
      axis.ticks = element_blank(),
      axis.text = element_blank(),
      axis.title = element_blank(),
      plot.margin = unit(c(0.15, 0, -0.3, 0), "cm")
    ) +
    theme(
      legend.title = element_text(size = 13),
      legend.text = element_text(size = 12)
    ) +
    scale_x_continuous(expand = c(0, 3)) +
    xlab("")
  ################################################################
  # Figure C and combine 是否要生成热图？
  ################################################################

  if (conf$extra$show_heatmap) {
    # 提取基因名
    heatmap_genes <- set::not(colnames(data),
    c("time", "event", "Group", "riskscore"))
    data3 <- data[, heatmap_genes]

    if (length(heatmap_genes) == 1) {
      data3 <- data.frame(data3)
      colnames(data3) <- heatmap_genes
    }
    # 归一化
    for (i in 1:ncol(data3)) {
      data3[, i] <- (data3[, i] - mean(data3[, i], na.rm = TRUE)) /
      sd(data3[, i], na.rm = TRUE)
    }
    data4 <- cbind(id = 1:nrow(data3), data3)
    data5 <- reshape2::melt(data4, id.vars = "id")

    fC <- ggplot(data5, aes_string(x = "id", y = "variable", fill = "value")) +
      geom_raster() +
      theme(
        panel.grid = element_blank(),
        panel.background = element_blank(),
        axis.line = element_blank(),
        axis.ticks = element_blank(),
        axis.text.x = element_blank(),
        axis.title = element_blank(),
        plot.background = element_blank()
      ) +
      scale_fill_gradient2(
        name = "Expression",
        low = conf$extra$gene_low,
        mid = conf$extra$gene_middle,
        high = conf$extra$gene_high
      ) +
      theme(axis.text = element_text(size = 11)) +
      theme(
        legend.title = element_text(size = 13),
        legend.text = element_text(size = 12)
      ) +
      scale_x_continuous(expand = c(0, 3))

    p <- fA + fB + middle + fC + plot_layout(
      ncol = 1,
      heights = c(0.1, 0.1, 0.01, 0.15)
    )
  } else {
    p <- fA + fB + middle + NULL + plot_layout(
      ncol = 1,
      heights = c(0.1, 0.1, 0.01, 0.02)
    )
  }

  p
}

#####################################
#          output section
#####################################
{
  export_single(p)
}