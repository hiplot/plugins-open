library(ggalign)

p1 <- ggplot(mtcars) +
    geom_point(aes(mpg, disp))
p2 <- ggplot(mtcars) +
    geom_boxplot(aes(factor(gear), disp))
p3 <- ggplot(mtcars) +
    geom_bar(aes(factor(gear))) +
    facet_wrap(~cyl)

align_plots(p1, align_plots(p2, p3), ncol = 1) + layout_tags("1")

#To treat a nested layout as a single plot with a single tag, disable its internal tags by setting tags = NULL:
align_plots(p1, align_plots(p2, p3) + layout_tags(NULL), ncol = 1) +
    layout_tags("A")

#Apply multilevel tagging where the outer layout uses letters and the inner layout uses numbers. You can specify a separator between parent and child tags:
align_plots(
    p1,
    align_plots(p2, p3) + layout_tags(1, sep = ": "),
    ncol = 1
) +
    layout_tags("A")

#You can customize tags by adding a prefix and/or suffix. Note that the parent layout’s prefix and suffix are applied to all plots, including nested layouts:
align_plots(
    p1,
    align_plots(p2, p3) + layout_tags(1, sep = ": "),
    ncol = 1
) +
    layout_tags("A", prefix = "Fig.")

#Instead of built-in sequences, you can provide your own tag vector:
align_plots(
    p1,
    align_plots(p2, p3) + layout_tags(1),
    ncol = 1
) +
    layout_tags(c("&", "%"))

#Tags inherit their appearance from the plot’s theme. To modify tag styling for all plots in a layout, use the & operator:
align_plots(
    p1,
    align_plots(p2, p3) + layout_tags(1, sep = ": "),
    ncol = 1
) +
    layout_tags("A", prefix = "Fig.") &
    theme(plot.tag = element_text(color = "red"))

