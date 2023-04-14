## [Gene Cluster Trend](https://hiplot.com.cn/basic/gene-trend)

- Introduction

  The gene cluster trend is used to display different gene expression trend with multiple lines showing the similar expression patterns in each cluster.

- Analysis of case data

  The loaded data are a gene expression matrix with each row represent a gene and each column represent a time-point sample.

- Interpretation of case statistics graphics

  As shown in the example figure, the genes are clustered into different groups, with each group showing similar expression patterns across different time-points. The average expression trend is highlighted in each cluster.

- Extra Parameters

  Cluster Num: set the number of desired cluster.

  Draw Cluster Centre Line: whether draw the centre line of the average expression in every cluster.

  Threshold: set the threshold for excluding genes. If the percentage of missing values (indicated by NA in the expression matrix) is larger than thres, the corresponding gene will be excluded.

  MinStd: set the threshold for minimum standard deviation. If the standard deviation of a gene's expression is smaller than min.std the corresponding gene will be excluded.

- Reference Packages

  Mfuzz: (Maintainer: Matthias Futschik <matthias.futschik@sysbiolab.eu>)



