library(ggalign)

p1 <- ggplot(mtcars) +
    geom_point(aes(mpg, disp)) +
    ggtitle("Plot 1")

#Add base plot:
align_plots(p1, ggwrap(~ plot(mtcars$mpg, mtcars$disp)))

#base plot should be provided using formula.
align_plots(
    p1,
    ggwrap(
        ~ plot(mtcars$mpg, mtcars$disp),
        align = "full"
    )
)

align_plots(
    p1,
    ggwrap(~ plot(mtcars$mpg, mtcars$disp)) +
        # add title for new plot
        ggtitle("Plot 2")
)

#Set plot widths:]
align_plots(
    p1,
    ggwrap(~ plot(mtcars$mpg, mtcars$disp)),
    widths = c(1, 2)
)

#Since ggwrap() is automatically called in most cases, you can write code like:
align_plots(
    p1,
    ~ plot(mtcars$mpg, mtcars$disp)
)

#Add grid grobs, for example:
align_plots(
    p1,
    grid::textGrob("Some really important text")
)

#Add cluster plot:
hc <- hclust(dist(USArrests), "ave")
align_plots(p1, ~ plot(hc))

#Add lattice plots:
align_plots(
    p1,
    lattice::xyplot(disp ~ mpg, data = mtcars)
)

#Add pheatmap:
align_plots(
    p1,
    pheatmap::pheatmap(matrix(rnorm(200), 20, 10), silent = TRUE)
)