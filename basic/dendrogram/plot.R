#######################################################
# Dendrogram plot.                                    #
#-----------------------------------------------------#
# Author: < Mingjie Wang > from < Ke Yan Mao >        #
# Affiliation: Shanghai Hiplot Team                   #
# Email: customer_service1501@tengyunbio.com          #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2020-04-30                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2020 by Hiplot Team                   #
# All rights reserved.                                #
#######################################################

pkgs <- c("ape", "ggplotify", "openxlsx")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  tree_type <- conf$extra$type
  if (tree_type %in% c("phylogram", "fan", "cladogram", "radial", "unrooted")) {
    # nothing
  } else {
    tree_type <- "phylogram"
    print("Error, dendrogram type is wrong, using \"phylogram\" as default.")
  }

  # check alpha
  alpha_usr <- conf$general$alpha
  if (is.numeric(alpha_usr) & alpha_usr >= 0 & alpha_usr <= 1) {
    # nothing
  } else {
    print("Error, alpha should be a decimal between 0-1")
  }
}
############# Section 2 #############
#           plot section
#####################################
{
  # format data frame
  data <- data[, -1]

  # hclust
  if (!is.character(conf$extra$hc_method) ||
    is.null(conf$extra$hc_method) ||
    conf$extra$hc_method == "") {
    conf$extra$hc_method = "complete"
  }
  d <- dist(t(data), method = conf$extra$dist)
  hc <- hclust(d, method = conf$extra$hc_method)

  # vector of colors
  if (conf$extra$labelcol) {
    mypal <- add_alpha(
      get_hiplot_color(conf$general$palette, conf$extra$clade,
        conf$general$paletteCustom),
      alpha_usr
    )
  } else {
    mypal <- add_alpha("black", alpha_usr)
  }

  # cutting dendrogram in defined clusters
  clus <- cutree(hc, conf$extra$clade)

  # plot
  p <- as.ggplot(function() {
    par(mar = c(5, 5, 10, 5), mgp = c(2.5, 1, 0))
    plot(as.phylo(hc),
      type = conf$extra$type,
      tip.color = mypal[clus], label.offset = 1,
      cex = 1, font = 2, use.edge.length = T
    )
    title(conf$general$title, line = 1)
  })
}

############# Section 3 #############
#          output section
#####################################
{
  print(unlist(hc))
  out_xlsx <- paste(opt$outputFilePrefix, ".xlsx", sep = "")
  write.xlsx(as.data.frame(as.matrix(d)), out_xlsx)
  export_single(p)
}
