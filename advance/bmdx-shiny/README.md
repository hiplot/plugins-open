# BMDx

## Using BMDx source from GitHub

### Linux system library dependencies

```BASH
libv8-3.14-dev
libxml2-dev
libssl-dev
```

### Install R dependencies

```R
#Install Bioconductor dependencies
source("http://bioconductor.org/biocLite.R")
bioc_pkgs <- c("org.Hs.eg.db", "org.Mm.eg.db", "org.Rn.eg.db", "KEGG.db", "reactome.db", "GOSim", "GO.db")
bioc_pkgs.inst <- bioc_pkgs[!(bioc_pkgs %in% rownames(installed.packages()))]
if(length(bioc_pkgs.inst)>0){
  print(paste0("Missing ", length(bioc_pkgs.inst), " Bioconductor Packages:"))
  for(pkg in bioc_pkgs.inst){
    print(paste0("Installing Package:'", pkg, "'..."))
    biocLite(pkg, suppressUpdates=TRUE)
    print("Installed!!!")
  }
}

#Install CRAN dependencies
cran_pkgs <- c("drc", "bmd", "alr3", "jtools", "zeallot", "ggplotify", "RColorBrewer", "reshape", "gplots", "ggplot2", "shiny", "shinyjs", "shinydashboard", "shinyFiles", "tibble", "plotly", "rhandsontable", "gProfileR", "DT", "randomcoloR", "readxl", "cellranger", "devtools", "scales", "xlsx",
               "gtools", "shinycssloaders", "shinyBS", "tidyverse", "gridExtra", "gtable", "grid","XLConnect")
cran_pkgs.inst <- cran_pkgs[!(cran_pkgs %in% rownames(installed.packages()))]
if(length(cran_pkgs.inst)>0){
  print(paste0("Missing ", length(cran_pkgs.inst), " CRAN Packages:"))
  for(pkg in cran_pkgs.inst){
    print(paste0("Installing Package:'", pkg, "'..."))
    install.packages(pkg, repo="http://cran.rstudio.org", dependencies=TRUE)
    print("Installed!!!")
  }
}
```

### Run BMDx From GitHub
```R
# Load 'shiny' library
library(shiny)
library(shinyjs)
# run on the host port 8787 (or whaterver port you want to map on your system)
runGitHub("BMDx", "Greco-Lab")
```
