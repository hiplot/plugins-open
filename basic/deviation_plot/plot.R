library("ggpubr")

deviation_plot <- function(data, key, value, sort_method) {
  if (key == "" || value == "") stop("x and y must be provided!")
  # clculate y -> z_score
  data[["z_score"]] <- (data[[value]] - mean(data[[value]])) / sd(data[[value]])
  # define level
  data[["Group"]] <- factor(ifelse(data[["z_score"]] < 0, "low", "high"),
    levels = c("low", "high")
  )
  # plot
  p <- ggbarplot(data,
    x = key,
    y = "z_score",
    fill = "Group",
    color = "white",
    sort.val = sort_method,
    sort.by.groups = FALSE,
    x.text.angle = 90,
    xlab = key,
    ylab = value,
    rotate = TRUE
  )
  p <- set_palette_theme(p, conf)
  return(p)
}

# ====================== Plugin Caller ======================

p <- deviation_plot(
  data = if (exists("data") && is.data.frame(data)) data else "",
  key = conf$dataArg[[1]][[1]]$value,
  value = conf$dataArg[[1]][[2]]$value,
  sort_method = conf$extra$sort_method
)

p <- set_complex_general_theme(set_palette_theme(p, conf))

export_single(p)
