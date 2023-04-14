## [GOBubble Plot](https://hiplot.com.cn/basic/gobubble)

- Introduction

  The gobubble plot is used to display Z-score coloured bubble plot of terms ordered alternatively by z-score or the negative logarithm of the adjusted p-value.

- Analysis of case data

  The loaded data are the results of GO enrichment with seven columns: category, GO id, GO term, gene count, gene name, logFC, adjust pvalue and zscore.

- Interpretation of case statistics graphics

  As shown in the example figure,  the x- axis of the plot represents the z-score. The negative logarithm of the adjusted p-value (corresponding to the significance of the term) is displayed on the y-axis. The area of the plotted circles is proportional to the number of genes assigned to the term. Each circle is coloured according to its category and labeled alternatively with the ID or term name.If static is set to FALSE the mouse hover effect will be enabled.

- Extra Parameters

  Display:  A character vector indicating whether a single plot ('single') or a facet plot with panels for each category should be drawn (default='single').

  Label ID: Defines whether label the GO term.

  Table Legend: Defines whether a table of GO ID and GO term should be displayed on the right side of the plot or not (default = TRUE).

  Label Threshold: Sets a threshold for the displayed labels. The threshold refers to the -log(adjusted p-value).

- Reference Packages

  GOplot: (Maintainer: Wencke Walter <wencke.walter@arcor.de>)
