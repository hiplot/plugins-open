#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2022 by "National Center for          #
# Translational Medicine·Shanghai                     #
# All rights reserved.                                #
#######################################################
pkgs <- c("ggplotify", "beanplot")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  cnames <- colnames(data)
  colnames(data) <- c("Y", "X", "Group")
  GroupOrder <- as.numeric(factor(data[, 2],
    levels = unique(data[, 2])))
  data[, 2] <- paste0(data[,2], " ", as.numeric(factor(data[, 3])))
  data <- cbind(data, GroupOrder)
}

############# Section 2 #############
#           plot section
#####################################
{
  col <- get_hiplot_color(conf$general$palette, 2, conf$general$paletteCustom)
  p <- as.ggplot(function(){
    beanplot(Y ~ reorder(X, GroupOrder, mean), data = data, ll = 0.04,
            main = conf$general$title,
            ylab = ifelse(conf$extra$horizontal, cnames[2], cnames[1]),
            xlab = ifelse(conf$extra$horizontal, cnames[1], cnames[2]),
            side = "both",
            border = NA, horizontal = conf$extra$horizontal,
            col = list(c(col[1], col[1]),
            c(col[2], col[2])),
            beanlines = conf$extra$beanlines,
            overallline = conf$extra$overallline,
            kernel = conf$extra$kernel
            )
    legend("bottomright",
      fill = c(col[1], col[2]),
      legend = levels(factor(data[, 3])))
  })
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}
