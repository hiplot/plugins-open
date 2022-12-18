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
  pkgs <- c("vcd", "DescTools", "ggplotify", "openxlsx")
  pacman::p_load(pkgs, character.only = TRUE)

  cmd <- sprintf("tbl <- xtabs(~%s, data)",
    paste0(conf$dataArg[[1]][[1]]$value, collapse = "+"))
  eval(parse(text = cmd))
  x <- ftable(tbl)
  print(x)
}

############# Section 2 #############
#           plot section
#####################################
{
  conf$extra$colors <- get_hiplot_color(conf$general$palette, -1, conf$general$paletteCustom)
  conf$extra$colors2 <- cbind(ColToHsv(conf$extra$colors[1]), ColToHsv("#FFFFFF"), ColToHsv(conf$extra$colors[2]))
  p <- as.ggplot(function() {
  
  params <- list(tbl,
    shade = TRUE,
    legend = TRUE,
    main = conf$general$title)
  if (conf$extra$mode == "binary") {
    params$gp <- shading_binary(tbl, col = conf$extra$colors[1:2])
  } else if (conf$extra$mode == "gray") {
    params$gp <- shading_hcl(tbl, c = 0)
  } else {
    params$gp <- shading_hsv(tbl, h = conf$extra$colors2["h",],
      s = conf$extra$colors2["s",], v = conf$extra$colors2["v",])
  }
  do.call(mosaic, params)
 })
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
  write.xlsx(x, paste0(opt$outputFilePrefix, ".xlsx"), row.names = FALSE)
}

