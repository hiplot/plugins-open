if (packageVersion("sigminer") < "2.0.0") {
  BiocManager::install("sigminer")
}
pkgs <- c("purrr", "sigminer", "ggplot2")
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

  xvar <- conf$dataArg[[1]][[1]]$value # the column to set x axis
  yvar <- conf$dataArg[[1]][[2]]$value # the column to set y axis
  cor_method <- conf$extra$cor_method
  vis_method <- conf$extra$vis_method
  legend_title <- conf$general$legendTitle
  # logical values: TRUE or FALSE
  lab <- conf$extra$lab
  hc_order <- conf$extra$hc_order
  test <- conf$extra$test
}

message("Show digits: ", lab)
############# Section 2 #############
#           plot section
#####################################
{
  p <- show_cor(
    data = data,
    x_vars = xvar,
    y_vars = yvar,
    cor_method = cor_method,
    vis_method = vis_method,
    lab = lab,
    test = test,
    hc_order = hc_order,
    legend.title = legend_title
  ) +
    ggtitle(conf$general$title)

  ## add theme
  theme <- conf$general$theme
  p <- choose_ggplot_theme(p, theme)
  p <- set_complex_general_theme(p)
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}
