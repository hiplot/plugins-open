## [PCAtools](/basic/pcatools)

PCAtools can reduce the dimensionality of data through principal component analysis, and view principal component related features at a two-dimensional level

- Data table 1 (numerical matrix):

  Each column is a sample, and each row is a feature (such as gene, chip probe)

- Data sheet 2 (sample information):

  The first column is the sample, and the other columns are the phenotypic characteristics of the sample, which can be used to mark the color and shape of the point and perform correlation analysis with the principal component

- Data table 2 parameter columns

  Bi-plot color column (single choice) | Used to map phenotypic features to Bi-plot and mark points in different colors

  Bi-plot shape column (single choice) | Used to map phenotypic features to Bi-plot and mark points as different shapes

  Eigencorplot phenotype column (multiple choice) | Used to draw correlation heat map of phenotype and principal component
  
- Extra parameters:

  \* Components | The number of principal components of screeplot, pairsplot, plotloadings, and eigencorplot

  Top Variance | Used to filter the included numerical matrix features
  
  Corelation Method | Method pass to `cor` function for corelation calulation

  Method for Missing Values | Method for handling missing values in corelation calulation

  Screeplot Bar, Loadings \* |  Control the colors of images elements

Detail introduction about [PCAtools](http://www.bioconductor.org/packages/release/bioc/vignettes/PCAtools/inst/doc/PCAtools.html)
