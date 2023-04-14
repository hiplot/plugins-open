# MSpectraAI<img src="www/MSpectraAI_logotizuo.jpg" align="right" height="190" width="190"/>
#### A powerful software for deciphering proteome profiling of multi-tumour mass spectrometry data using deep neural networks

## Brief Description
**<font size='5'> MSpectraAI </font>** is a free, user-friendly and comprehensive software for mining and classifying raw LC-MS<sup>2</sup>-based proteomics or metabolomics data of different samples using deep learning models. Users can also built your own deep neural network model in this software. It is developed with [R](https://www.r-project.org/) and an example is shown here: [https://www.omicsolution.org/wukong/MSpectraAI/](https://www.omicsolution.org/wukong/MSpectraAI/).

## Cite this article
Wang, S., Zhu, H., Zhou, H. et al. MSpectraAI: a powerful platform for deciphering proteome profiling of multi-tumor mass spectrometry data by using deep neural networks. BMC Bioinformatics 21, 439 (2020). [https://doi.org/10.1186/s12859-020-03783-0](https://doi.org/10.1186/s12859-020-03783-0).

## Friendly Tips
* **Run this tool locally**. As we know, the raw data from mass spectrometer are usually very large. You can analyze your data on our web server, but the analysis speed will be slower. Therefore, we recomand you run this tool locally on a high configuration computer. The entire analysis time will be much shorter.
* **Be familiar with the basic usage of R language**. This web tool is developed with R, therefore, if you know some basic knowledge about R, it will help you understand this tool better. However, you need not worry if you know nothing about R, and you can learn to use our tool expertly as well after reading our manual.

## Preparation
- **Install R**. You can download R from here: [https://www.r-project.org/](https://www.r-project.org/).
- **Install RStudio** (Recommendatory but not necessary). You can download RStudio from here: [https://www.rstudio.com/](https://www.rstudio.com/).
- **Install Anaconda** (For Windows users). You can download Anaconda from here: [https://www.anaconda.com/download/](https://www.anaconda.com/download/).

## Install Packages
We recommend the R version >= 3.5.0. Particularly, if you use unix-like systems, you may need install some dependent packages in advance, for example, on CentOS 7:
```r
sudo yum -y install libxml2-devel igraph-devel libxslt-devel netcdf-devel libcurl-devel openssl-devel cairo-devel

pip install virtualenv
```

```r
#Packages
needpackages<-c("BiocManager","devtools","shiny","shinyjs","shinyBS","ggplot2","ggjoy","openxlsx","gdata","DT","gtools","ggsci","mzR",
                "plyr","tidyr","abind","data.table","parallel","ggrastr","ggthemes","viridis","glue","ComplexHeatmap",
                "reshape","impute","circlize","ROCR","keras")
#Check and install function
CheckInstallFunc <- function(x){
  for(i in x){
    #  require returns TRUE invisibly if it was able to load package
    if(!require(i, character.only = TRUE)){
      #  If package was not able to be loaded then re-install
      install.packages(i, dependencies = TRUE)
      if(!require(i, character.only = TRUE)) BiocManager::install(i, dependencies = TRUE)
      if(i=="ggrastr"){
        devtools::install_github('VPetukhov/ggrastr')
      }
    }
  }
}
#Start to check and install
CheckInstallFunc(needpackages)
#R interface to Keras: https://keras.rstudio.com/
library(keras)
install_keras()
```

## Download and Run Locally
You can download our tool from this github and unzip the file, then run:
```r
#Find the file path and run 
library(shiny)
runApp(".../MSpectraAI")
```
Then you can start your own analysis:
<img src="figs/homepage1.jpg" align="center" height="400" width="800"/>

## Detailed Introduction
The usage about this tool can be found here:
[https://github.com/wangshisheng/MSpectraAI/blob/master/SupportingNotes.pdf](https://github.com/wangshisheng/MSpectraAI/blob/master/SupportingNotes.pdf).

## Graphic Abstract
<img src="figs/TOC_MSpectraAI.jpg" align="center" height="400" width="800"/>

## Information About the Current R Session
```r
> sessionInfo()
R version 3.5.1 (2018-07-02)
Platform: x86_64-w64-mingw32/x64 (64-bit)
Running under: Windows 7 x64 (build 7601) Service Pack 1

Matrix products: default

locale:
[1] LC_COLLATE=Chinese (Simplified)_People's Republic of China.936  LC_CTYPE=Chinese (Simplified)_People's Republic of China.936   
[3] LC_MONETARY=Chinese (Simplified)_People's Republic of China.936 LC_NUMERIC=C                                                   
[5] LC_TIME=Chinese (Simplified)_People's Republic of China.936    

attached base packages:
[1] grid      parallel  stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:
 [1] keras_2.1.6           ROCR_1.0-7            gplots_3.0.1          circlize_0.4.4        ComplexHeatmap_1.18.1
 [6] glue_1.3.0            viridis_0.5.1         viridisLite_0.3.0     ggthemes_4.0.0        ggrastr_0.1.5        
[11] data.table_1.11.8     abind_1.4-5           tidyr_0.8.2           plyr_1.8.4            impute_1.53.0        
[16] mzR_2.13.6            Rcpp_0.12.19          ggsci_2.8             gtools_3.5.0          DT_0.4               
[21] gdata_2.18.0          openxlsx_4.0.17       ggjoy_0.4.1           ggridges_0.5.0        ggplot2_3.1.0        
[26] shinyBS_0.61          shinyjs_1.0           shiny_1.2.0          

loaded via a namespace (and not attached):
 [1] ProtGenerics_1.11.0 bitops_1.0-6        RColorBrewer_1.1-2  tools_3.5.0         R6_2.2.2            KernSmooth_2.23-15 
 [7] lazyeval_0.2.1      BiocGenerics_0.26.0 colorspace_1.3-2    GetoptLong_0.1.7    withr_2.1.2         tidyselect_0.2.5   
[13] gridExtra_2.3       compiler_3.5.0      Biobase_2.39.2      Cairo_1.5-9         labeling_0.3        caTools_1.17.1.1   
[19] scales_1.0.0        tfruns_1.3          stringr_1.3.1       digest_0.6.18       base64enc_0.1-3     pkgconfig_2.0.1    
[25] htmltools_0.3.6     htmlwidgets_1.3     rlang_0.3.0.1       GlobalOptions_0.1.0 rstudioapi_0.7      shape_1.4.4        
[31] bindr_0.1.1         jsonlite_1.5        tensorflow_1.8      crosstalk_1.0.0     dplyr_0.7.7         magrittr_1.5       
[37] Matrix_1.2-14       munsell_0.5.0       reticulate_1.9      stringi_1.1.7       whisker_0.3-2       yaml_2.1.19        
[43] promises_1.0.1      crayon_1.3.4        lattice_0.20-35     zeallot_0.1.0       pillar_1.2.1        rjson_0.2.19       
[49] codetools_0.2-15    httpuv_1.4.4.1      gtable_0.2.0        purrr_0.2.4.9000    reshape_0.8.7       assertthat_0.2.0   
[55] mime_0.5
```

## Contact
You could push an issue on this github. And optionally, please feel free to sent me an e-mail if you have any question or find a bug about this tool. Thank you^_^
Email: wssdandan2009@outlook.com
