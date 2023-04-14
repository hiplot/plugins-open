# Visual Surrogate Variable Analysis (*V-SVA*)

### An R Shiny application for detecting and annotating hidden sources of variation in single cell RNA-seq data

## Last Update: March, 3rd, 2020

Authors: *Nathan Lawlor*, *Eladio J. Marquez*, *Donghyung Lee*, and *Duygu Ucar*

App Maintainer: *Nathan Lawlor*

App Location:  https://vsva.jax.org

Manuscript now published in *Bioinformatics*! For more information on our Shiny app, please see: https://academic.oup.com/bioinformatics/advance-article/doi/10.1093/bioinformatics/btaa128/5771333

***

### Introduction

Single cell RNA-sequencing (scRNA-seq) technology enables studying gene expression programs from individual cells. However, these data are subject to diverse sources of variation, including “unwanted” variation that needs to be removed in downstream analyses (e.g., batch effects) and “wanted” or biological sources of variation (e.g., variation associated with a cell type) that needs to be precisely described. Surrogate variable analysis (SVA) based algorithms, are commonly used for batch correction and more recently for studying “wanted” variation in scRNA-seq data. We recently developed *Iteratively Adjusted-Surrogate Variable Analysis (IA-SVA)*, which can effectively estimate surrogate variables associated with hidden variation (wanted or unwanted) in scRNA-seq data. However, interpreting whether these variables are biologically meaningful or stemming from technical reasons remains a challenge. 

To facilitate the interpretation of surrogate variables detected by algorithms including IA-SVA, SVA, or ZINB-WaVE, we developed an R Shiny application **(Visual Surrogate Variable Analysis (V-SVA))** that provides a web-browser interface for the identification and annotation of hidden sources of variation in scRNA-seq data. This interactive framework includes tools for discovery of genes associated with detected sources of variation, gene annotation using publicly available databases and gene sets, and data visualization using dimension reduction methods. 

***

### Tutorial/Guide

For an in depth guide of how to use this shiny app, please see the Word Document at: https://github.com/nlawlor/V-SVA/blob/master/Data/VSVA_Shiny_App_Manual.docx

### Required Input Files 

1. The app requires first a matrix of gene expression data (rows as genes, columns as samples). This file may be formatted as a tab-delimited text file, .CSV file, or .Rds object.  

An example 10X Genomics single cell RNA-seq expression matrix obtained from [*Kang et al. 2017*](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5784859/) which contains a subset of 200 human peripheral blood mononuclear cells (PBMCs) 
is provided at: https://github.com/nlawlor/V-SVA/blob/master/Data/test.exp.txt and can be used to test the app.

This matrix, when loaded into R:

```R, echo=FALSE, message=FALSE, eval=TRUE
df <- read.delim("Data/test.exp.txt", header = T, check.names = F, stringsAsFactors = F, row.names = 1)
df[1:4, 1:4]
```

Looks like this: ![](https://github.com/nlawlor/V-SVA/blob/master/img/exp.matrix.png)

2. (Optional) Users may also provide a matrix of sample metadata (rows as sample names, columns as traits). Like the expression matrix, this file may be formatted as a tab-delimited text file, .CSV file, or .Rds object.  

An example metadata file for the above expression matrix can be found at: https://github.com/nlawlor/V-SVA/blob/master/Data/test.metadata.txt.

This matrix, when loaded into R:

```R, echo=FALSE, message=FALSE, eval=TRUE
meta <- read.delim("Data/test.metadata.txt", header = T, check.names = F, stringsAsFactors = F, row.names = 1)
meta[1:4, ]
```
Looks like this: ![](https://github.com/nlawlor/V-SVA/blob/master/img/metadata.png)

**Please Note: The sample identifiers contained in the rows of the metadata matrix should be the same as the identifiers provided in the columns of the expression matrix**

***

### Overview of features included in V-SVA

* **Identify hidden sources of variability in transcriptomic data:**

![](https://github.com/nlawlor/V-SVA/blob/master/img/sv.plots.png)

* **Discover marker genes associated with a variable of interest:**

![](https://github.com/nlawlor/V-SVA/blob/master/img/marker.genes.png)

* **Use molecular pathways/genesets to annotated sources of variation:**

![](https://github.com/nlawlor/V-SVA/blob/master/img/pathway.analysis.png)

* **Dimension reduction and interactive visualization of data:**

![](https://github.com/nlawlor/V-SVA/blob/master/img/tsne.gif)

***

### Availability

* **V-SVA** is currently hosted on dedicated **The Jackson Laboratory** Shiny servers (two 24 Core and 192GB RAM servers) and is freely available [here]( https://vsva.jax.org).

### Publication

Our method has been published in *Bioinformatics* as an open access application note! To read more, please find the article which is freely available here: https://academic.oup.com/bioinformatics/advance-article/doi/10.1093/bioinformatics/btaa128/5771333

### Other Resources

* **IA-SVA** is also available as an R-package that may be downloaded from **Bioconductor** [here](https://www.bioconductor.org/packages/devel/bioc/html/iasva.html), and the source code is available [here](https://github.com/UcarLab/iasva)

* The published manuscript describing the IA-SVA software can be found in **Scientific Reports** [here](https://www.nature.com/articles/s41598-018-35365-9)
