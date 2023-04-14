# **Evaluation of Computational Methods for Human Microbiome Analysis Using Simulated Data**
This is the repository for the simulated data, code, and visualization (Shiny App) presented in the paper <b>Evaluation of Computational Methods for Human Microbiome Analysis Using Simulated Data (not yet published) </b>.  
*Code written by Sandro Valenzuela.*

### DATA

To download the simulated data, please click on the following links according to the number of species simulated you wish to try:

* Data simulating 10 species from the Human Oral Microbiome Database [here](https://www.dropbox.com/sh/q0cofhwzn9sgq9p/AAD_AVvjAxZ7BgtLHdJFkmHoa?dl=0).
* Data simulating 100 species from the Human Oral Microbiome Database [here](https://www.dropbox.com/sh/g9bu3wn9db9lri7/AACulJZXryp5XchjNZ6dybHea?dl=0).
* Data simulating 426 species from the Human Oral Microbiome Database [here](https://www.dropbox.com/sh/14hnrspr2u4pfia/AABepBjoYoRbNpTvLyTgzxbKa?dl=0). 

### CODE

To streamline data generation and analyses, we wrote four modules that work sequentially to from simulation, execution, parsing, and analysis. Check out the following repositories for each step:

* To simulate reads as we did in the study [here](https://github.com/microgenomics/simulationsMethods).

* To execute the methods and pipelines benchmarked in the study [here](https://github.com/microgenomics/executionMethods).

* To parse the results from the different software pipelines [here](https://github.com/microgenomics/parseMethods).

* and to carry out statistical analyses [here](https://github.com/microgenomics/analysisMethods).



### VISUALIZATION in dedicated Shiny App

![R Shiny app interface](Fig1_Full_GUI_new.png)

To run the app, simply download the R scripts in this folder as well as data and modules. Make sure R is installed on your machine (https://www.r-project.org/). For a slick R dev interface, we recommend using Rstudio (https://www.rstudio.com/)

Before attempting to run the app, make sure that the following required packages are installed:

- shiny 
- shinythemes
- stringr
- ggplot2
- reshape2
- phyloseq
- plyr

The Phyloseq package should be downloaded from bioconductor following the instructions given at: https://bioconductor.org/packages/release/bioc/html/phyloseq.html. 

All other packages can be downloaded using the R command: install.packages(<i>nameofthepackage</i>).  

