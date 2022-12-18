plot_xy_CatGroup_hiplot <- function (data, xcol, ycol, CatGroup, symsize = 10, symthick = 1,
    s_alpha = 1, ColPal = "all_grafify", ColSeq = TRUE, ColRev = FALSE,
    TextXAngle = 0, fontsize = 20, symsize_col = NULL, shape = 21)
{
    if (symsize_col != "") {
      symsize <- data[,symsize_col]
    }
    data[,CatGroup] <- factor(data[,CatGroup], levels = unique(data[,CatGroup]))
    P <- ggplot2::ggplot(data, aes_string(x = xcol, y = ycol)) + 
    labs(fill = enquo(CatGroup),
         color = enquo(CatGroup)) +
         theme_classic(base_size = fontsize) +
         theme(strip.background = element_blank()) +
         guides(x = guide_axis(angle = TextXAngle))

    if (!is.numeric(shape) && symsize_col == "") {
      P <- P + geom_point(
          size = symsize,
          alpha = s_alpha, aes_string(
            color = CatGroup,
            shape = CatGroup
          ),
          stroke = symthick
        )
    } else if (!is.numeric(shape) && symsize_col != "") {
      P <- P + geom_point(
          alpha = s_alpha, aes_string(
            size = symsize,
            color = CatGroup,
            shape = CatGroup
          ),
          stroke = symthick
        )
    } else if (symsize_col != "") {
      P <- P + 
        geom_point(
          alpha = s_alpha,
          aes_string(
            size = symsize,
            fill = CatGroup
          ),
          shape = 21,
          stroke = symthick
        )
    } else {
      P <- P + 
        geom_point(size = symsize,
          alpha = s_alpha, aes_string(
              fill = CatGroup
            ),
            shape = 21,
            stroke = symthick
      )
    }
    P
}
