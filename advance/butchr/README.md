[![Build Status](https://travis-ci.org/hdsu-bioquant/ShinyButchR.svg?branch=master)](https://travis-ci.org/hdsu-bioquant/ShinyButchR)


<img src="figs/ShinyButchR_figs/shinyButchR_logo.png" width="300">

# ShinyButchR 


`ShinyButchR` is an interactive R/Shiny app to perform NMF on an input matrix.
`ShinyButchR` uses `ButchR` (https://github.com/wurst-theke/ButchR) to run the matrix decomposition and generate 
diagnostic plots and visualizations that helps to find association of the NMF 
signatures to known biological factors.

## Citation 
Andres Quintero, Daniel Hübschmann, Nils Kurzawa, Sebastian Steinhauser, Philipp Rentzsch, Stephen Krämer, Carolin Andresen, Jeongbin Park, Roland Eils, Matthias Schlesner, Carl Herrmann, [ShinyButchR: interactive NMF-based decomposition workflow of genome-scale datasets](https://doi.org/10.1093/biomethods/bpaa022), Biology Methods and Protocols, bpaa022.



# How to use ShinyButchR 

The app can be used directly from the official 
[ShinyButchR website](https://hdsu-bioquant.shinyapps.io/shinyButchR/).
A pre-build image can be pulled from Docker 
[hdsu/shinybutchr](https://hub.docker.com/r/hdsu/shinybutchr):

`docker run --rm  -p 3838:3838 hdsu/shinybutchr`  

or also the Github repository can be pulled from 
[hdsu-bioquant/ShinyButchR](https://github.com/hdsu-bioquant/ShinyButchR).

## Loading screen

When you start the app, the first displayed screen is a loading screen, while the
app loads ButchR and TensorFlow (**Figure 1**).  
Depending on the system, this step may take from a few seconds to around one 
minute. If you are using `ShinyButchR` from the 
[ShinyButchR website](https://hdsu-bioquant.shinyapps.io/shinyButchR/), and the 
app was idle for more than one hour; a new instance has to be created by 
shinyapps.io, this process can take around one to one and a half minutes.  

![ShinyButchR loading screen](figs/ShinyButchR_figs/ShinyButchR_001.png)
  
  
## Data and annotation screen  

When the app is loaded, you are prompted to either run an analysis using the 
demo dataset or to upload your own data (**Figure 2**). For this tutorial, we 
are using the demo dataset from the publicly available RNA-seq dataset of 
sorted blood cell populations, which comprises 12 cell populations and 45 samples 
(Corces et al., 2016).  

![ShinyButchR welcome screen](figs/ShinyButchR_figs/ShinyButchR_002.png)  
  

The options available in the **Data and annotation** screen are (**Figure 3**):
1. Upload a non-negative matrix in a csv or RDS file format using the file 
browser. You can also clear previously loaded datasets by clicking in the 
`clear` button.
2. Upload a table with annotation data in a csv or RDS file, the first column 
should match the column names in the input matrix. This file is optional and 
you can run the NMF based analysis without the annotation file.
3. NMF parameters: 
  - Select the minimum and maximum factorization rank (minimum 
value allowed is 2 and maximum value allowed is 30). 
  - Select a factorization method, from "NMF" and "GRNMF_SC". 
  - Number of initializations: number of times that the decomposition should be run with random initializations in ShinyButchR the limit in 10.
  - Convergence threshold: in ShinyButchR, the convergence of the NMF is reach when every sample (in the columns of the input matrix) is assigned to the same signature (on the basis of maximum exposure) after n iterations.
4. Start NMF: after uploading a non-negative matrix (and optionally a table
with annotation data), the NMF-based analysis run by clicking the
`Submit` button.


![ShinyButchR Data and annotation screen](figs/ShinyButchR_figs/ShinyButchR_003.png)
  
To load the demo dataset, click on the `demo` button inside the 
Matrix upload box  (**Figure 4.1**). After loading the demo dataset, the first 
five rows of the input matrix and annotation data are displayed in the 
**Matrix upload** and **Annotation upload** boxes.

The default parameters to run NMF for the demo are: 
- Minimum factorization rank: 2
- Maximum factorization rank: 10
- Factorization method: NMF
- Number of initializations: 2
- Convergence threshold: 30

Now the data is ready to be run the workflow, click the `Submit` button 
in the **Start NMF** box (**Figure 4.2**).


![ShinyButchR load demo data](figs/ShinyButchR_figs/ShinyButchR_004.png)

# Data exploration with ShinyButchR
  

## Start NMF

The matrix decomposition starts after clicking the `Submit` button in the 
**Start NMF** box (**Figure 5**). The running time of the decomposition depends 
on the initial NMF parameters. For the demo default parameters, it takes around
one minute.


![ShinyButchR running NMF](figs/ShinyButchR_figs/ShinyButchR_005.png)



## NMF results

When the NMF decomposition finishes, you are prompted to the **NMF plots** screen,
where you can explore all the results:

## Heatmat of the H matrix

One of the big advantages of the lower-dimensional representation obtained by 
NMF is the possibility of representing the resulting H matrix as a heatmap.
In this representation, the rows of the matrix are the **Signatures** identified 
by NMF and the columns represent the samples in the original matrix. 
The differential exposure of the samples to the signature can be seen in this 
type of plot, allowing to understand which samples are closely related 
(**Figure 6**).

![H matrix heatmap](figs/ShinyButchR_figs/ShinyButchR_006.1.png)

In case you have more than one type of annotation for the samples in the input 
matrix, it is possible to display them all by clicking on the 
`Select columns to use` input box (**Figure 7**).

![H matrix heatmap - annotation](figs/ShinyButchR_figs/ShinyButchR_007.png)


In `ShinyButchR` you can change the factorization rank in the `Select K` input 
box (**Figure 8.1**) to display a heatmap of the H matrix, based in any of the 
factorization ranks included in the original range of ranks used to run the 
analysis.



## UMAP based on the H matrix  
  
To identify clusters on the samples, a UMAP is run using the H matrix as input.
It is possible to select the factorization rank to change the H matrix used to
run UMAP. In addition, the coloring of the samples on the scatter plot is 
customizable depending on the uploaded annotation table (**Figure 8.2**).

![H matrix heatmap and UMAP - select K](figs/ShinyButchR_figs/ShinyButchR_008.png)


## Recovery plots based on the H matrix

The association of the recovered signatures to known biological and clinical 
variables is one of the most important steps in an NMF-based workflow.
In ShinyButchR, a recovery plot is made for all the associated categorical 
variables available in the annotation table (**Figure 9.1**).


## Determining the optimal factorization rank

Based on the results of the factorization quality metrics, the optimal number 
of signatures (k) is determined by minimizing the Frobenius error, the coefficient 
of variation and the mean Amari distance, while maximizing the sum and mean 
silhouette width and the cophenic coefficient (**Figure 9.2**).


![Recovery plots and optimal factorization rank](figs/ShinyButchR_figs/ShinyButchR_009.png)

## Riverplot visualization

To visualize the stability and hierarchical relationships between signatures, 
a Riverplot or Sankey diagram is displayed showing the similarity between 
signatures across factorization ranks. The cutoff of displayed similarities can 
be changed with the slider, as well as the range of factorization ranks to use 
in the visualization (**Figure 10**).


![riverplot](figs/ShinyButchR_figs/ShinyButchR_010.png)



# Download results

ShinyButchR allows to download the results as an RDS object of class 
**ButchR_NMF** compatible with the latest version of ButchR (**Figure 11.1**). 
To use this object, you can start a new R session and read it like this:

```
library(ButchR)
nmf_exp <- readRDS("~/path/to/NMF_object.RDS")

```

It is also possible to download csv and RDS files of the H and W matrices for a 
selected factorization rank (**Figure 11.2**).

![Download results](figs/ShinyButchR_figs/ShinyButchR_011.png)
