#######################################################
# R code flow chart.                                  #
#-----------------------------------------------------#
# Author: Jianfeng Li                                 #
# Email: lee_jianfeng@hiplot.org                      #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2020-08-13                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2022 by "National Center for          #
# Translational Medicine·Shanghai                     #
# All rights reserved.                                #
#######################################################
pkgs <- c("flow")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  if (!str_detect(conf$data$code, "^function[ ]*[(]+")) {
    cmd <- sprintf("data <- function(){%s}", conf$data$code)
  } else {
    cmd <- sprintf("data <- %s", conf$data$code)
  }
  eval(parse(text = cmd))
}

############# Section 2 #############
#           plot section
#####################################
{
  for (i in conf$general$imageExportType) {
    if (i %in% c('png', 'jpeg')) {
      raw <- flow_view(data,
        out = i
      )
      file.copy(raw, paste(opt$outputFilePrefix, ".", i, sep = ""))
      conf$general$imageExportType <- conf$general$imageExportType[
        conf$general$imageExportType != i
      ]
    }
  }
  svg_raw <- flow_view(data, out = "html")
  p <- function () {
    flow_view(data, out = "html")
  }
}

############# Section 3 #############
#          output section
#####################################
{
  out_pdf <- paste(opt$outputFilePrefix, ".pdf", sep = "")
  html2pdf(svg_raw, out_pdf)
  pdf2image(out_pdf)
  if (! 'pdf' %in% conf$general$imageExportType) {
    file.remove(out_pdf)
  }
}
