#######################################################
# Extract colors.                                     #
#-----------------------------------------------------#
# Author: Jianfeng Li                                 #
# Email: lee_jianfeng@hiplot.org                      #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2021-11-14                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2022 by "National Center for          #
# Translational Medicine·Shanghai                     #
# All rights reserved.                                #
#######################################################

pkgs <- c("rPlotter", "ggplotify", "patchwork", "openxlsx")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  images <- sapply(conf$data$images$link, function(x) {
    parse_file_link(x)
  })
}

############# Section 2 #############
#           plot section
#####################################
{
  p <- NULL
  cols <- list()
  wb <- createWorkbook()
  for (i in 1:length(images)) {
    sname <- paste0("image-", i)
    addWorksheet(wb, sname)
    cols[[i]] <- extract_colours(images[i], num_col = conf$extra$num_col)

    ptmp <- as.ggplot(function(){
      pie(rep(1, length(cols[[i]])),
      labels = cols[[i]],
      col = cols[[i]] , main = basename(images[i]))
    })
    if (is.null(p)) {
      p <- ptmp
    } else {
      p <- p + ptmp
    }
    writeData(wb, sname, cols[[i]])
  }
  p <- p + plot_layout(ncol = 2) + plot_annotation(tag_level = "A")
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
  saveWorkbook(wb, paste0(opt$outputFilePrefix, ".xlsx"), overwrite = TRUE)
}
