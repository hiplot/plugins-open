#######################################################
# Circular Barplot.                                   #
#-----------------------------------------------------#
# Author: < Wei Dong >                                #
# Email: dongw26@mail2.sysu.edu.cn                    #
# Website: http://bioinfomics.top/                    #
#                                                     #
# Date: 2020-11-27                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2020 by Hiplot Team                   #
# All rights reserved.                                #
#######################################################

pkgs <- c("ggplot2", "dplyr")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  # check data columns
  if (ncol(data) == 3) {
    # nothing
  } else {
    print("Error: Input data should be 3 columns!")
  }
  
  # rename data colnames
  colnames(data) <- c("individual","group","value")
  data$group <- as.factor(data$group)
  
  # whether sort the value
  sort_value <- conf$extra$sort_value
  
  # set the label
  label <- conf$extra$label
  
  # set the label size
  label_size <- conf$extra$label_size

}

############# Section 2 #############
#           plot section
#####################################
{
  
  # Set a number of 'empty bar' to add at the end of each group
  empty_bar <- conf$extra$gapbar_num
  to_add <- data.frame( matrix(NA, empty_bar*nlevels(data$group), ncol(data)) )
  colnames(to_add) <- colnames(data)
  to_add$group <- rep(levels(data$group), each=empty_bar)
  data <- rbind(data, to_add)
  # sort by group or value
  if(sort_value){
    data <- data %>% arrange(group,value)
  }else{
    data <- data %>% arrange(group)
  }
  data$id <- seq(1, nrow(data))
  #head(data)
  
  # Get the name and the y position of each label
  label_data <- data
  number_of_bar <- nrow(label_data)
  angle <- 90 - 360 * (label_data$id-0.5) /number_of_bar     # I substract 0.5 because the letter must have the angle of the center of the bars. Not extreme right(1) or extreme left (0)
  label_data$hjust <- ifelse( angle < -90, 1, 0)
  label_data$angle <- ifelse(angle < -90, angle+180, angle)
  #head(label_data)
  
  # prepare a data frame for base lines
  base_data <- data %>% 
    group_by(group) %>% 
    summarize(start=min(id), end=max(id) - empty_bar) %>% 
    rowwise() %>% 
    mutate(title=mean(c(start, end)))
  #head(base_data)
  
  # Make the plot
  p <- ggplot(data, aes(x=as.factor(id), y=value, fill=group)) +       # Note that id is a factor. If x is numeric, there is some space between the first bar
    
    geom_bar(aes(x=as.factor(id), y=value, fill=group), stat="identity", alpha=0.5) +
    ylim(-50,max(na.omit(data$value))+30) +
    
    # Add a val=100/75/50/25 lines. I do it at the beginning to make sur barplots are OVER it.
    #geom_segment(data=grid_data, aes(x = end, y = 80, xend = start, yend = 80), colour = "grey", alpha=1, size=0.3 , inherit.aes = FALSE ) +
    #geom_segment(data=grid_data, aes(x = end, y = 60, xend = start, yend = 60), colour = "grey", alpha=1, size=0.3 , inherit.aes = FALSE ) +
    #geom_segment(data=grid_data, aes(x = end, y = 40, xend = start, yend = 40), colour = "grey", alpha=1, size=0.3 , inherit.aes = FALSE ) +
    #geom_segment(data=grid_data, aes(x = end, y = 20, xend = start, yend = 20), colour = "grey", alpha=1, size=0.3 , inherit.aes = FALSE ) +
    
    # Add text showing the value of each 100/75/50/25 lines
    #annotate("text", x = rep(max(data$id),4), y = c(20, 40, 60, 80), label = c("20", "40", "60", "80") , color="grey", size=3 , angle=0, fontface="bold", hjust=1) +
    
    theme_minimal() +
    theme(
      #legend.position = "none",
      axis.text = element_blank(),
      axis.title = element_blank(),
      panel.grid = element_blank(),
      plot.margin = unit(rep(-1,4), "cm") 
    ) +
    coord_polar() + 
    
    # Add base line information
    # 添加下划线
    geom_segment(data=base_data, aes(x = start, y = -5, xend = end, yend = -5), colour = "black", alpha=0.8, size=0.8 , inherit.aes = FALSE )  +
    # 添加各组的名字
    geom_text(data=base_data, aes(x = title, y = -12, label=group), colour = "black", alpha=0.8, size=4, fontface="bold", inherit.aes = FALSE)
  
  if(label){
    # 添加标签注释信息
    p <- p + geom_text(data=label_data, aes(x=id, y=value+8, label=individual, hjust=hjust), color="black", fontface="bold",alpha=0.6, size=label_size, angle= label_data$angle, inherit.aes = FALSE ) +
             geom_text(data=label_data, aes(x=id, y=value-10, label=value, hjust=hjust), color="black", fontface="bold",alpha=0.6, size=label_size, angle= label_data$angle, inherit.aes = FALSE )
  }
  
  # add color palette
  p <- p + return_hiplot_palette(conf$general$palette,
                                 conf$general$paletteCustom)
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}
