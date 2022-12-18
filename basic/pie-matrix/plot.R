#######################################################
# Pie matrix.                                         #
#-----------------------------------------------------#
# Author: Jianfeng Li                                 #
# Email: lee_jianfeng@openbiox.org                    #
#                                                     #
# Date: 2022-03-27                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2022 by "National Center for          #
# Translational Medicine·Shanghai                     #
# All rights reserved.                                #
#######################################################
pkgs <- c("patchwork", "ggplotify")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  axis <- sapply(conf$dataArg[[1]], function(x) x$value)
  data[, axis[1]] <- set_factors(data[, axis[1]])
  if (is.character(axis[2]) && axis[2] != "") {
    data[, axis[2]] <- set_factors(data[, axis[2]])
  }
  if (is.character(axis[3]) && axis[3] != "") {
    data[, axis[3]] <- set_factors(data[, axis[3]])
  }
}

############# Section 2 #############
#           plot section
#####################################
{
  col <- get_hiplot_color(conf$general$palette, -1,
    conf$general$paletteCustom)

  df <- matrix(NA, nrow = length(unique(data[,axis[2]])),
    ncol = length(unique(data[,axis[1]])))
  row.names(df) <- unique(data[,axis[2]])
  colnames(df) <- unique(data[,axis[1]])

  for (i in 1:nrow(df)) {
    for (j in 1:ncol(df)) {
      for (k in unique(data[,axis[3]])) {
        if (is.na(df[i, j])) {
          df[i, j] <- sum(data[,axis[1]] == unique(data[,axis[1]])[j] &
            data[,axis[2]] == unique(data[,axis[2]])[i] &
            data[,axis[3]] == k)
        } else {
          df[i, j] <- paste0(df[i, j], ",", 
            sum(data[,axis[1]] == unique(data[,axis[1]])[j] &
              data[,axis[2]] == unique(data[,axis[2]])[i] &
              data[,axis[3]] == k))
        }
      }
    }
  }
  df <- as.matrix(df)
  print(df)
  p <- df %>% as.table() %>%
      as.data.frame() %>%
      mutate(Freq = str_split(Freq,",")) %>%
      unnest(Freq) %>%
      mutate(Freq = as.integer(Freq)) %>%
      # Convert the values to a percentage (which adds up to 1 for each graph)
      group_by(Var1, Var2) %>%
      mutate(Freq = ifelse(is.na(Freq), NA, Freq / sum(Freq)),
            color = row_number()) %>%
      ungroup() %>%
      # Plot
      ggplot(aes("", Freq, fill=factor(color,
        labels = unique(data[,axis[3]])))) + 
      geom_bar(width = 2, stat = "identity") +
      coord_polar("y") +       # Make it a pie chart
      facet_wrap(~Var1+Var2, ncol = ncol(df)) + # Break it down into 9 charts
      # Below is just aesthetics
      theme(axis.text = element_blank(),
            axis.ticks = element_blank(),
            panel.grid = element_blank(),
            axis.title = element_blank()) +
      guides(fill = FALSE)
    p <- set_palette_theme(p, conf)
    p <- p + theme(legend.position = "bottom") +
        theme(legend.direction = "horizontal") +
        guides(fill = guide_legend(nrow = 1, title = axis[3]))

}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}
