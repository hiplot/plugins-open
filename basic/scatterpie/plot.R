pkgs <- c("scatterpie")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  # check data
  # check data columns
  if (ncol(data) < 4) {
    stop("Input data should have at least 4 columns!")
  }

  if (!all(is.numeric(data[[1]]), is.numeric(data[[2]]))) {
    stop("The 1st and 2nd column should be numeric!")
  }

  data_format <- conf$extra$data_format

  if (data_format == "long") {
    if (!all(is.character(data[[3]]), is.numeric(data[[4]]))) {
      print("Error: The 3rd and 4th column should be character and numeric when the data format is long!")
    }
  }
}

############# Section 2 #############
#           plot section
#####################################
{
  x <- colnames(data)[1]
  y <- colnames(data)[2]
  if (data_format != "long") {
    p <- ggplot() +
      geom_scatterpie(aes_string(x = x, y = y),
        data = data,
        cols = colnames(data)[-c(1, 2)]
      )
  } else {
    p <- ggplot() +
      geom_scatterpie(aes_string(x = x, y = y),
        data = data,
        cols = colnames(data)[3], long_format = TRUE
      )
  }

  p <- p +
    ggtitle(conf$general$title)

  ## add color palette
  p <- p + return_hiplot_palette_color(conf$general$palette,
      conf$general$paletteCustom) +
    return_hiplot_palette(conf$general$palette,
      conf$general$paletteCustom)

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
