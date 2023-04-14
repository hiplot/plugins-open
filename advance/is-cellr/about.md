---
title: "vignette"
author: "Mitul Patel"
date: "`r format(Sys.time(), '%d %B, %Y')`"
---

<style>
body {
text-align: justify}
</style>

Single-cell RNA sequencing (scRNA-seq) enables the high-throughput quantification of gene expression profiles of individual cells and discovery of cellular heterogeneity and functional diversity. The increased complexity of scRNA-seq data present significant challenges for the effective analysis and interpretation of results. iS-CellR (Interactive platform for Single-cell RNAseq) is a web-based Shiny application designed to provide a comprehensive analysis of single-cell RNA sequencing data. iS-CellR provides a fast method for filtering and normalization of raw data, dimensionality reductions (linear and non-linear) to identify cell types clusters, differential gene expression analysis to locate markers, and inter-/intra-sample heterogeneity analysis. iS-CellR integrates the Seurat package with Shiny's reactive programming framework and interactive visualization using plotly library. iS-CellR runs on any modern web browser and provides access to powerful R libraries through a graphical user interface. Each session of iS-CellR allows the user to share, reproduce and archive results without requiring programming skills.

### How to Get Started and Load Data

__*It is important that the input file should follow the same format as descibed below.*__

To get started, please load in a CSV/TSV separated values file. The file should contain the count data where:

1. Columns are Cells
2. Rows are Genes
3. Optional: Cell names or Cell type in Column header followed by Cell id. eg. Tcell_TC1_fcount_1.

__NOTE:__ An example CSV file can be accessed <a href='data/Maligant50.csv', target='blank', download = 'Maligant50.csv'><strong>here</strong></a> (right click save as).

### Notes on Plots and Processed Data

All plots can be downloaded at a high resolution in PDF. This functionality works best in <strong>Chrome</strong> and <strong>Firefox</strong>. Within the Shiny app, user  can control the labelling of clusters.  User can also provide list of genes to compare their expression levels. 

### Questions
For any issues or questions that might arise, please email <strong>Mitul.Patel@immunocore.com</strong>.

