
<p align="center">📊 <b>TCGA Survival Analysis GUI: Graphical User Interface for Sequential t-SNE / UMAP Survival Analysis</b></p>

## Publication
(see citation below)

🔗[`Sequential Analysis of Transcript Expression Patterns Improves Survival Prediction in Multiple Cancers`](https://doi.org/10.1186/s12885-020-06756-x)

## Usage 

### 🌐 Online version 
Go to 🔗[`Sequential t-SNE / UMAP Suvival Analysis Rhiny App`](https://chpupsom19.shinyapps.io/survival_analysis_tsne_umap_tcga/). 

### 💻 Standalone version  
<details>
<summary><b>Installation</b></summary>  

Ensure that the following packages are installed in your R enviornment: 

`shiny`,`survminer`,`survival`,`plotly`,`ComplexHeatmap`, `tsne`, `Rtsne`, `plotly`, `shinydashboard`,`dashboardthemes`,`dplyr`,`umap`,`dbscan`

If any package is missing, Please run the following command in your [`RStudio`](https://www.rstudio.com/) and it will install all packages automatically.  

```R
# Check "BiocManager"
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

# Package list
libs <- c("shiny", "survminer","survival","plotly","ComplexHeatmap","tsne","Rtsne","plotly","shinydashboard","dashboardthemes","dplyr","umap",dbscan")

# Install packages if missing
for (i in libs){
  if( !is.element(i, .packages(all.available = TRUE)) ) {
     BiocManager::install(i, suppressUpdates=TRUE)
  }
}
```
</details>

<details>
<summary><b>Launch</b></summary> 
    
1. Click `Clone or download` button on the top of this page, then click [`Download ZIP`]();  
2. Unzip the file to an desired folder location.;  
3. In R Studio set the working directory to the folder location choosen in step 2 (use `setwd()` to set your working directory);
    
</details>

## Project Details 
We recently demonstrated that long-term intra-group survival disparities in 30 of 34 human cancer types are associated with distinct expression pattern differences of small numbers of functionally related transcripts relevant to cancer signaling, proliferation and metabolism. These differences can be expressed as clusters using the dimensionality reduction technique “t-distributed stochastic neighbor embedding” (t-SNE). These clusters more accurately correlated with survival than did standard classification such as clinical stage or hormone receptor status in the case of breast cancer. We have now comprehensively examined that sequential analyses employing either t-SNE to t-SNE or whole transcriptome to t-SNE analyses are superior to either individual method at predicting long-term survival.   

## Methods
RNAseq data from 10,227 tumors in The Cancer Genome Atlas were previously analyzed using t-SNE-based clustering of 362 transcripts comprising 15 distinct cancer-related pathways. After showing that certain clusters were associated with differential survival, they were re-analyzed by t-SNE with a second pathway’s transcripts. Alternatively, groups with differential survival based on whole transcriptome profiling from tcga.ngchm.net were subject to a second, t-SNE-based analysis.

## 📈 Features and Directions 

### User Input 1: 
Choose the cancer and 1 or 2 pathways in the anaysis and can further filter patients using up to 3 phenotypic variables. The cancers options are all possible cancers in TCGA and select pediatric cancers from TARGET. The cancer related pathways were predefined and the genes in each pathway can be found in file under data/data2/merged/merged_pathway_lists.txt. 

### User Input 2: 
Choose phenotypes to filter the patients in the analysis. Up to 3 phenotypes can be choosen at one time. These phenotypes are all found through TCGA. (This feature is being under development so you may run into bugs) 

### Module 1 (Green): 3D Clustering Plots
This generates the 3D plots that shows clustering of patients using their RNASeq expression for the genes in the choosen pathway

### Module 2 (Red): Kaplan-Meyer Survival Curves for 1 Pathway 
The clusters of patients in a 3D plot for 1 pathway analysis are compared among each other for survival differences generating kaplan meyer survivial curves for each cluster

### Module 3 (Orange): Sequential Clusters Analysis Kaplan-Meyer Survival Curves 
The user first selects clusters from the analysis of pathway 1 to then split by the patient's clusters from the pathway 2 analysis. These new groupings that merge both pathway's clusters are displayed as kaplan meyer curves. This module highights the benefits of a sequential appraoch on survival predictability.

### Module 4: (Red): Sequential Cluster and Dendrogram Group Kaplan-Meyer Survival Curves
The complete transcritome for patients with the choosen cancer was used to generate a heirarchical clustering of the patients generating a dendrogram and a heatmap to visualize the expression differences.

### User Input 4: 
The user chooses clusters determined in pathway 1 analysis and groups in the dendrogram to split clusters by and generate survival curves comparing the choosen groups. Pathway 2 is not required and not used in this module.

### Tab 2: Using Pre-generated t-SNE Clusters
This tab displays a pre-generated t-SNE clustering of patients using the genes in a selected pathway. t-SNE was run using custom settings to achieve sufficent clustering of patients for all combinations of cancers and pathways. Users can select 1 or 2 pathways to view the individual clustering and kaplan meyer plots comparing survival of clusters. The analysis reactively generates with the options selected. After the plots load, users can choose up to 3 phenotypes to filter patients. This will filter patients after t-SNE clustering of all patients and display subsequent plots using only the cluster membership of patients that satisfy the choosen constraints. With 1 pathway loaded, users can preform a sequential analysis with dendogram groups shown in the heatmap. With two pathways loaded, users can preform a sequential analysis with t-SNE clusters from two pathways.

### Tab 3: Custom t-SNE or UMAP clustering
This tab enables users to preform a custom clustering of patients in any of the cancers using the cancer related pathways provided or a custom set of genes. The user can choose whether to use t-SNE or UMAP for the dimensionality reduction step and reactive options for either algorithm are shown to the user. Default values are choosen but users can select their own settings. Prior to running the analysis, users can choose up to 3 phenotypes to filter patients. After running the analysis, the same plots and analysis described in Tab 2 is shown.

## 📕 Publication

🔗[`Sequential Analysis of Transcript Expression Patterns Improves Survival Prediction in Multiple Cancers`](https://doi.org/10.1186/s12885-020-06756-x)
Mandel, J., Avula, R. & Prochownik, E.V. BMC Cancer 20, 297 (2020). https://doi.org/10.1186/s12885-020-06756-x



    

