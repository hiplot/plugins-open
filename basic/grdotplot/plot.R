pkgs <- c("sigminer", "ggplot2")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  # check data
  # check data columns
  if (ncol(data) < 2) {
    stop("Input data should have at least 2 columns!")
  }


  gvar <- conf$dataArg[[1]][[1]]$value  # the column to set groups
  dvar <- conf$dataArg[[1]][[2]]$value # the column to set continuous variable
  
  # logical values: TRUE or FALSE
  # 按中位数对组排序：默认 FALSE
  set_order <- conf$extra$order_by_median
  if (!is.numeric(data[, gvar])) {
    data[, gvar] <- factor(data[, gvar], levels = unique(data[, gvar]))
  }
}

############# Section 2 #############
#           plot section
#####################################
{

  p <- show_group_distribution(
    data,
    gvar = gvar, 
    dvar = dvar,
    order_by_fun = set_order
  ) + 
    ggtitle(conf$general$title)

  # 下面这些设置没什么意义
  # ## add color palette
  # p <- p + return_hiplot_palette_color(conf$general$palette,
  #conf$general$paletteCustom) +
  #   return_hiplot_palette(conf$general$palette,
  #conf$general$paletteCustom)

  # theme <- conf$general$theme
  # p <- choose_ggplot_theme(p, theme)
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}

