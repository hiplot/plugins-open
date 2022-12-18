#######################################################
# Fusion Circlize.                                    #
#-----------------------------------------------------#
# Author: Jianfeng Li                                 #
# Email: lee_jianfeng@hiplot.org                      #
# Website: hiplot.org                                 #
#                                                     #
# Date: 2022-02-11                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2022 by "National Center for          #
# Translational Medicine·Shanghai                     #
# All rights reserved.                                #
#######################################################

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  pkgs <- c("cola")
  pacman::p_load(pkgs, character.only = TRUE)

  data <- data[!is.na(data[, 1]), ]
  idx <- duplicated(data[, 1])
  data[idx, 1] <- paste0(data[idx, 1], "--dup-", cumsum(idx)[idx])
  for (i in 2:ncol(data)) {
    data[, i] <- as.numeric(data[, i])
  }
  data1 <- as.matrix(data[, -1])
  rownames(data1) <- data[, 1]
  data <- data1
  rm(data1)
}

############# Section 2 #############
#           plot section
#####################################
{
  data = adjust_matrix(data)
  params <- list(data, cores = 4, max_k = conf$extra$max_k,
    scale_rows = conf$extra$scale_rows,
    p_sampling = conf$extra$p_sampling,
    partition_repeat = conf$extra$partition_repeat
  )
  if (nrow(data2) > 0) {
    params$anno = data2
  }
  rl <- do.call(run_all_consensus_partition_methods, params)
}

############# Section 3 #############
#          output section
#####################################
{
  outdir <- paste0(dirname(opt$outputFilePrefix), "/output/", cores = 4)
  cola_report(rl, output_dir = outdir)
  export_directory()
  keep_vars <- c(keep_vars, rl)
}
