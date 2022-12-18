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
  svg <- sapply(conf$data$infile$link, function(x) {
    parse_file_link(x)
  })
}

############# Section 2 #############
#           plot section
#####################################
{
  setwd(dirname(opt$outputFilePrefix))
  outdir <- sprintf("%s/output", dirname(opt$outputFilePrefix))
  dir.create(outdir)
  svgs <- paste0(svg, collapse = "' '")
  cmd <- sprintf("xvfb-run java -jar -Xmx10336m /cluster/home/public/opt/bio/baitk/1.13/batik-rasterizer-1.13.jar -m application/pdf '%s' -d %s", svgs, outdir)
  system_safe(cmd)
  pdfs <- list.files(outdir, "*.pdf", full.names = TRUE)
  print(pdfs)
  merge_pdf <- paste0(opt$outputFilePrefix, ".pdf")
  if (length(pdfs) != 0) {
    if (length(pdfs) == 1) {
      file.copy(pdfs[1], merge_pdf)
    } else {
      merge_pdfs(pdfs, merge_pdf)
    }
  }
  if (file.exists(merge_pdf)) {
    pdf2image(merge_pdf, 1)
  }
  if (!"pdf" %in% conf$general$imageExportType) {
    file.remove(merge_pdf)
  }
}
