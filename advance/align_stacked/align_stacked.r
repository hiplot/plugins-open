library(ggalign)

# Simulate data (same seed and structure)
set.seed(0)
data <- matrix(sample(1:99, 50, replace = TRUE), nrow = 10)
rownames(data) <- paste0("V", 1:10)
colnames(data) <- letters[1:5]
category <- rep(c(1, 1, 2, 2, 4), each = 2)

stack_discretev(data) +

    # add bar for total
    ggalign(rowSums, size = 0.1) +
    geom_tile(aes(y = 1, fill = value)) +
    scale_fill_viridis_c(name = "Total") +

    # add bar for catogery
    ggalign(factor(category), size = 0.1) +
    geom_tile(aes(y = 1, fill = value)) +
    scale_fill_brewer(palette = "Set2", name = "Category") -
    scale_y_continuous(breaks = NULL, name = NULL) +

    ggalign() +
    geom_bar(aes(y = value, fill = .column_names),
        stat = "identity", position = position_fill()
    ) +
    scale_fill_brewer(palette = "Dark2", name = "Stacked Bar")