## [GOCircle Plot](https://hiplot-academic.com/basic/gocircle)

- Introduction

  The gocircle plot is used to display the circular plot combines gene expression and gene- annotation enrichment data. A subset of terms is displayed like the GOBar plot in combination with a scatter plot of the gene expression data. The whole plot is drawn on a specific coordinate system to achieve the circular layout. The segments are labeled with the term ID.

- Analysis of case data

  The loaded data are the results of GO enrichment with seven columns: category, GO id, GO term, gene count, gene name, logFC, adjust pvalue and zscore.

- Interpretation of case statistics graphics

  As shown in the example figure,  the outer circle shows a scatter plot for each term of the logFC of the assigned genes. Red circles display up-regulation and blue ones down-regulation by default.

- Extra Parameters

  Show Items:  A numeric vector defines how many processes are displayed (starting from the first row of data). 

  Label Size: Size of the segment labels (default=5).

  Rad1: The radius of the inner circle (default=2).

  Rad2: The radius of the outer circle (default=3).

  Table Legend: Shall a table be displayd or not? (default=TRUE).

- Reference Packages

  GOplot: (Maintainer: Wencke Walter <wencke.walter@arcor.de>)

