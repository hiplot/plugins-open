## [GOBar Plot](https://hiplot-academic.com/basic/gobar)

- Introduction

  The gobar plot is used to display Z-score coloured barplot of terms ordered alternatively by z-score or the negative logarithm of the adjusted p-value.

- Analysis of case data

  The loaded data are the results of GO enrichment with seven columns: category, GO id, GO term, gene count, gene name, logFC, adjust pvalue and zscore.

- Interpretation of case statistics graphics

  As shown in the example figure,  the x-axis represent each GO term, the y-axis represent the -log(adj_pvalue), each bar is colored by the z-score. If display is used to facet the plot the width of the panels will be proportional to the length of the x scale.

- Extra Parameters

  Display:  A character vector indicating whether a single plot ('single') or a facet plot with panels for each category should be drawn (default='single').

- Reference Packages

  GOplot: (Maintainer: Wencke Walter <wencke.walter@arcor.de>)

