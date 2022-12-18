#######################################################
# Venn2   .                                           #
#-----------------------------------------------------#
# Author: Jianfeng Li                                 #
# Email: lee_jianfeng@openbiox.org                    #
#                                                     #
# Date: 2022-04-02                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2022 by "National Center for          #
# Translational Medicine·Shanghai                     #
# All rights reserved.                                #
#######################################################

pkgs <- c("VennDiagram", "venn", "grDevices", "ggplotify", "ggplot2", "ggpolypath", "openxlsx")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  data_venn <- as.list(data)
  data_venn <- lapply(data_venn, function(x) {
    x[is.na(x)] <- ""
    x <- x[x != ""]
    return(x)
  })
}

############# Section 2 #############
#           plot section
#####################################
{
  params <- conf$extra
  params$x <- data_venn
  params$opacity <- conf$general$alpha
  params$ggplot <- TRUE
  params$zcolor <- get_hiplot_color(conf$general$palette, length(data_venn),
        conf$general$paletteCustom)
  p <- as.ggplot(function(){
    print(do.call(venn, params))
  }) + ggtitle(conf$general$title) +
  theme(plot.title = element_text(hjust = 0.5))

  venn_partitions <- VennDiagram::get.venn.partitions(data_venn)
  wb <- createWorkbook()
  addWorksheet(wb, "venn_partitions")
  writeData(wb, "venn_partitions", venn_partitions,
    colNames = TRUE, rowNames = FALSE
  )
}

############# Section 3 #############
#          output section
#####################################
{
  out_xlsx <- paste(opt$outputFilePrefix, ".xlsx", sep = "")
  saveWorkbook(wb, out_xlsx, overwrite = TRUE)
  export_single(p)
}
