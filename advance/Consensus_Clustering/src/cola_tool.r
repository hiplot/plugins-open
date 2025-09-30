#!/usr/bin/env Rscript

# Cola Consensus Clustering Analysis Tool
# A function-based R script for consensus clustering analysis

library(cola)

# Main function for consensus clustering analysis
cola_analysis <- function(
  input_file = "data/example_data.rds",
  use_adjust_matrix = TRUE,
  top_value_methods = c("SD", "MAD", "CV", "ATC"),
  partition_methods = c("hclust", "kmeans", "pam", "skmeans", "mclust"),
  output_dir = "result/cola_analysis_report",
  cores = NULL
) {
  # Load data
  if (!file.exists(input_file)) {
    stop("Input file does not exist: ", input_file)
  }
  
  cat("Loading data from:", input_file, "\n")
  mat <- readRDS(input_file)
  
  # Apply adjust_matrix if specified
  if (use_adjust_matrix) {
    cat("Applying adjust_matrix...\n")
    mat <- adjust_matrix(mat)
  } else {
    cat("Skipping adjust_matrix...\n")
  }
  
  # Identify available cores if not specified
  if (is.null(cores)) {
    cores <- parallel::detectCores() - 1
    if (cores < 1) cores <- 1
  }
  
  cat("Using", cores, "cores for analysis\n")
  
  # Run consensus clustering
  cat("Running consensus clustering with methods:\n")
  cat("Top value methods:", paste(top_value_methods, collapse = ", "), "\n")
  cat("Partition methods:", paste(partition_methods, collapse = ", "), "\n")
  
  rl <- run_all_consensus_partition_methods(
    mat,
    top_value_method = top_value_methods,
    partition_method = partition_methods,
    cores = cores
  )
  
  # Create output directory if it doesn't exist
  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)
  }
  
  # Generate HTML report
  cat("Generating HTML report in:", output_dir, "\n")
  cola_report(rl, output_dir = output_dir)
  
  cat("Analysis complete! Report saved to:", output_dir, "\n")
  
  # Return the results list
  return(invisible(rl))
}

# Example usage with default parameters
if (!interactive()) {
  # If running as a script, execute with default parameters
  cola_analysis()
} else {
  # If running in interactive mode, show usage
  cat("
Cola Consensus Clustering Analysis Tool
  
Usage examples:
  # With default parameters
  result <- cola_analysis()
  
  # With custom parameters
  result <- cola_analysis(
    input_file = 'my_data.rds',
    use_adjust_matrix = FALSE,
    top_value_methods = c('SD', 'CV'),
    partition_methods = c('hclust', 'kmeans'),
    output_dir = 'my_results',
    cores = 4
  )
  
  # Available top value methods: 'SD', 'MAD', 'CV', 'ATC'
  # Available partition methods: 'hclust', 'kmeans', 'pam', 'skmeans', 'mclust'
")
}



