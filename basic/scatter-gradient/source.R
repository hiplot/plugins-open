plot_xy_NumGroup_hiplot <- function (data, xcol, ycol, NumGroup, symsize = 10, symthick = 1,
    s_alpha = 1, ColPal = "all_grafify", ColSeq = TRUE, ColRev = FALSE,
    TextXAngle = 0, fontsize = 20, symsize_col = NULL, shape = 21)
{
    if (symsize_col != "") {
      symsize <- data[,symsize_col]
    }
    P <- ggplot2::ggplot(data, aes_string(x = xcol, y = ycol)) + 
    labs(fill = enquo(NumGroup),
         color = enquo(NumGroup)) +
         theme_classic(base_size = fontsize) +
         theme(strip.background = element_blank()) +
         guides(x = guide_axis(angle = TextXAngle))

    if (symsize_col == "" && shape < 21) {
      P <- P + geom_point(
          size = symsize,
          alpha = s_alpha, aes_string(
            color = NumGroup
          ),
          shape = shape,
          stroke = symthick
        )
    } else if (symsize_col == "" && shape >= 21) {
      P <- P + geom_point(
          size = symsize,
          alpha = s_alpha, aes_string(
            fill = NumGroup
          ),
          shape = shape,
          stroke = symthick
        )
    } else if (symsize_col != "" && shape >= 21) {
      P <- P + geom_point(
          alpha = s_alpha, aes_string(
            size = symsize,
            fill = NumGroup
          ),
          shape = shape,
          stroke = symthick
        )
    } else {
      P <- P + geom_point(
        alpha = s_alpha, aes_string(
          size = symsize,
          color = NumGroup
        ),
        shape = shape,
        stroke = symthick
      )
    }
    P
}
