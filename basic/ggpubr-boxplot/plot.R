
# ====================== Plugin Caller ======================

p <- ggboxplot(
  data = if (exists("data") && is.data.frame(data)) data else "",
  x = conf$dataArg[[1]][[1]]$value,
  y = conf$dataArg[[1]][[2]]$value,
  facet.by = if (conf$dataArg[[1]][[3]]$value == "") NULL else conf$dataArg[[1]][[3]]$value,
  combine = conf$extra$combine,
  merge = conf$extra$merge,
  color = conf$extra$color,
  fill = conf$extra$fill,
  bxp.errorbar = conf$extra$bxp.errorbar,
  bxp.errorbar.width = conf$extra$bxp.errorbar.width,
  linetype = conf$extra$linetype,
  size = conf$extra$size,
  width = conf$extra$width,
  outlier.shape = conf$extra$outlier.shape,
  add = conf$extra$add,
  error.plot = conf$extra$error.plot,
  scales = conf$extra$scales,
  notch = conf$extra$notch,
  repel = conf$extra$repel
) + ggtitle(conf$general$title)

if (conf$extra$add_sig_label) {
  # "p.signif"
  # "center"
  p <- p + stat_compare_means(
    label = conf$extra$sig_label_type,
    label.x.npc = conf$extra$sig_label_position,
    method = conf$extra$sig_method
  ) + scale_y_continuous(expand = expansion(mult = c(0.2, 0.2)))
}

p <- set_complex_general_theme(set_palette_theme(p, conf))

export_single(p)
