
# ====================== Plugin Caller ======================

p <- plotentry(
  data = if (exists("data") && is.data.frame(data)) data else "",
  grp_vars = conf$dataArg[[1]][[1]]$value,
  enrich_vars = conf$dataArg[[1]][[2]]$value,
  cross = conf$extra$cross,
  add_text_annotation = conf$extra$add_text_annotation,
  fill_by_p_value = conf$extra$fill_by_p_value,
  use_fdr = conf$extra$use_fdr,
  cut_p_value = conf$extra$cut_p_value,
  cluster_row = conf$extra$cluster_row,
  co_method = conf$extra$co_method,
  scales = conf$extra$scales,
  ref_group = conf$extra$ref_group
)

p <- set_complex_general_theme(set_palette_theme(p, conf))

export_single(p)
