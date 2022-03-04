#######################################################
# Fusion Circlize.                                    #
#-----------------------------------------------------#
# Author: Jianfeng Li                                 #
# Email: lee_jianfeng@hiplot.org                      #
# Website: https://hiplot.com.cn                      #
#                                                     #
# Date: 2020-08-13                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2020 by Hiplot Team                   #
# All rights reserved.                                #
#######################################################

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  outdir <- sprintf("%s/output", dirname(opt$outputFilePrefix))
  dir.create(outdir)
  if (conf$extra$refgenefile == "hg19") {
    db <- "~/../public/opt/bio/AGFusion/AGFusionDB/agfusion.homo_sapiens.75.db"
  } else if (conf$extra$refgenefile == "hg38") {
    db <- "~/../public/opt/bio/AGFusion/AGFusionDB/agfusion.homo_sapiens.95.db"
  }
}

############# Section 2 #############
#           plot section
#####################################
{
  pdfs <- c()
  for (i in 1:nrow(data)) {
    tmpOutDir <- paste0(outdir, '/', data[i,1], '-', data[i,1])
    cmds <- paste(
      "source activate agfusion; unset DISPLAY;",
      "agfusion annotate --type pdf",
      "-g5", data[i,1],
      "-g3", data[i,2],
      "-j5", data[i,3],
      "-j3", data[i,4],
      "-o", tmpOutDir,
      "-db", db,
      ifelse(conf$extra$wt, "--WT", "")
    )
    cat(cmds, sep = "\n")
    system_safe(cmds)
  }
}


############# Section 3 #############
#          output section
#####################################
{
  export_directory(outdir = outdir, recursive = TRUE)
}
