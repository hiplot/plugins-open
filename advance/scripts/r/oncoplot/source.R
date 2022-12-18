get_variant_group_freq <- function (data, params, mutdat) {
  if (is.null(params$column_split)) {
    params$column_split <- rep("ALL", nrow(data2))
  }
  if (length(unique(params$column_split)) == 1) {
    df <- data.frame(df=rep(NA, nrow(mutdat)))
    df <- t(df)
  } else {
    df <- matrix(NA, ncol = nrow(mutdat),
      nrow=length(unique(params$column_split)))
  }
  colnames(df) <- row.names(mutdat)
  row.names(df) <- unique(params$column_split)
  row.names(df)[is.na(row.names(df))] <- "NA"
  for (i in 1:nrow(mutdat)) {
    for (j in unique(params$column_split)) {
      if (is.na(j)) {
        tmp <- as.character(mutdat[i, is.na(params$column_split)])
        j <- "NA"
      } else {
        tmp <- as.character(mutdat[i, params$column_split %in% j])
      }
      tmp[str_detect(tmp, "/")] <- "Multiple"
      tmp <- table(tmp)
      names(tmp)[names(tmp) == "0"] <- "Negative"
      tmp2 <- c()
      for (k in c(unique(data$Variant_Classification), "Multiple", "Negative")) {
        tmp2[k] <- tmp[k]
        if (is.null(tmp[k]) | is.na(tmp[k])) tmp2[k] <- 0
      }
      df[j, i] <- paste0(tmp2, collapse = ",")
    }
  }
  return(df)
}

draw_pie_matrix <- function (df, cols_label, cols) {
  df <- as.matrix(df)
  p <- df %>% as.table() %>%
    as.data.frame() %>%
    mutate(Freq = str_split(Freq,",")) %>%
    unnest(Freq) %>%
    mutate(Freq = as.integer(Freq)) %>%
    # Convert the values to a percentage (which adds up to 1 for each graph)
    group_by(Var1, Var2) %>%
    mutate(Freq = ifelse(is.na(Freq), NA, Freq / sum(Freq)),
          color = row_number()) %>%
    ungroup() %>%
    # Plot
    ggplot(aes("", Freq, fill=factor(color,
      labels = cols_label))) + 
    geom_bar(width = 2, stat = "identity") +
    coord_polar("y") +       # Make it a pie chart
    facet_wrap(~Var1+Var2, ncol = ncol(df)) + # Break it down into 9 charts
    # Below is just aesthetics
    theme(axis.text = element_blank(),
          axis.ticks = element_blank(),
          panel.grid = element_blank(),
          axis.title = element_blank()) +
    guides(fill = FALSE)
  p <- p + theme_void()
  p <- p + scale_fill_manual(values = cols)
  p <- p + theme(legend.position = "bottom") +
      theme(legend.direction = "horizontal") +
      guides(fill = guide_legend(nrow = 1, title = "Variant Class"),  )

  return (p)
}