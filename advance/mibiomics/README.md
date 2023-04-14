# Latest Update
01/04/2020: New figure available in Network Exploration Tab. You can now identify the significant important variables of your WGCNA module by plotting them according to their VIP score and associated pvalue with the parameter of interest. This new functionnality is available at the bottom of the network exploration tab in the PLS section.

23/03/2020: You can know select the correlation threshold in bipartite network (Multi-Omics analysis section).

11/03/2020: A new version of MiBiOmics is available with new examples datasets (from Cancer Genome Network Atlas and TARA oceans) and new help buttons. 

Please do not hesitate to report issues related to MiBiOmics usage. Common reported issues are described at the end of this README.

# MiBiOmics
MiBiOmics is a shiny-based web application to perform correlation network analysis and multi-omics analysis on omics datasets

## Installation

MiBiOmics is be available at https://shiny-bird.univ-nantes.fr/app/Mibiomics but can also be runned locally with a conda environment or with docker. To run MiBiOmics locally you need to install *MiBiOmics.yml* environment and run the following commands :

```bash
conda env create -f MiBiOmics.yml
conda activate MiBiOmics
R -e 'shiny::runUrl("https://gitlab.univ-nantes.fr/combi-ls2n/mibiomics/repository/master/archive.tar.gz")'
```

All the necessary packages will be installed automatically for the usage of MiBiOmics.
The first launch will take some time (about one hour) due to the installation of all the necessary packages.

At the end of the local installation procedure the following sentence will appear :

```bash
Listening on http://127.0.0.1:####
```
To open MiBiOmics you need to open the http link. The first time you may encounter the error message: 

```bash
Error in library: package "metagenomeSeq" not found
```
If it happens, stop MiBiOmics and re-launch it again. The package metagenomeSeq is installed. If you still have libraries errors at the launching of MiBiOmics, please contact us.

You can also use the Docker image available at: https://hub.docker.com/repository/docker/jojoh2943/mibiomics_v2

## Data Upload & pre-treatment:


In the first section you can upload one, two or even three omics tables:

|        | OTU1  | OTU2 | OTU3 |
| ------ | ------ | ----- | ----- |
| Sample 1 |   1    |   0   |  512  |
| Sample 2 |  106   |   0   |   26  |
| Sample 3 |   0    |   3   |   0   |
| Sample 4 |   19   |   0   |   6   |

Omics table may contain Gene names, OTUs/ASVs or even metabolites in columns. Rownames must be unique.
An annotation table describing your samples is also necessary:


|        |  Site  |  ADN  | group |
| ------ | ------ | ----- | ----- |
|Sample 1|   1    |  0.63 |   A   |
|Sample 2|   2    |  1.12 |   B   |
|Sample 3|   2    |  0.45 |   A   |
|Sample 4|   5    |  1.04 |   A   |

If an Omics table containing ASVs or OTUs is uploaded, you can also add a taxonomic table describing the phylogenetic information of each OTUs/ASVs.

|        |Kingdom |Phylum | Class | Order |Family |Species|
| ------ | ------ | ----- | ----- | ----- | ----- | ----- |
| OTU1  |  ...   |  ...  |  ...  |  ...  |  ...  |  ...  |
| OTU2  |  ...   |  ...  |  ...  |  ...  |  ...  |  ...  |
| OTU3  |  ...   |  ...  |  ...  |  ...  |  ...  |  ...  |
| OTU4  |  ...   |  ...  |  ...  |  ...  |  ...  |  ...  |

Each Omics Table can be filtrated, normalized, and transformed. If your uploaded table is large this step may take some time.

## Data Overview:

When you are ready, you uploaded your datasets, you treated your data with filtration and/or normalization and/or transformation, you will be able to explore your dataset(s) variability in the second tab of MiBiOmics. In this section, a PCA or a PCoA will allow you to see the main axis of variability. You can change the color of your samples according to the external variables uploaded with the annotation table to see what might play a part in this variability.

A cluster dendrogramme is also plotted to help you visualize which samples are closely related.

If you uploaded an OTUs Counting Table with the corresponding Taxa Table you will be able to see a figure representing the relative taxa abundance of each sample at different taxonomic level.

_If you uploaded more than one omics table:_
Use the tabsets called 'second dataset' and 'third datasets' to explore the variability of your other omics layers.

## Network Inference:

WGCNA is a R package which uses a system biology approach to find patterns of correlation in omics datasets (Peter Langfelder and Steve Horvath, 2008). Based on correlation networks, the method defines modules as groups of highly interconnected genes and reduce the dimensionality of the data by helping the user concentrate on the module of interest. A motivation for the implementation of this application was to give the ability to create the network in a user-friendly way and to understand better the influence of the principal parameters, like the soft power or the minimum module size, on the structure of the Network. We strongly advise users to read [the authors' publication](https://bmcbioinformatics.biomedcentral.com/articles/10.1186/1471-2105-9-559) or to try [their tutorial](https://horvath.genetics.ucla.edu/html/CoexpressionNetwork/Rpackages/WGCNA/Tutorials/index.html) in order to better understand the WGCNA method.

Once your in the Network Inference section, you will be able to change the soft power and minimum size module to see how the structure of your correlation network is affected. This step migth take a while to be completed if the counting table uploaded is too large ( > 5000). Unfortunately, it is not possible to perform correlation network with datasets larger than 10 000 and we are currently working on this issue.

_If you uploaded more than one omics table:_

Use the tabsets called 'second dataset' and 'third datasets' to perform the network inference on your other omics layers. /! The next section, 'Network exploration' can only be used once the network inference step has been performed on all datasets.

## Network Exploration:

The Network exploration page allows you to characterise the modules, to understand what are the common properties of the genes/OTUs belonging to a same group. In this section you will be able to see which samples contribute the most to the formation of a module, how modules correlate to external traits and the relationship between the module membership of a gene/OTU and its correlation to external traits. In this page you can explore the inside of the network, part by part, and associate a group of highly interconnected genes/OTUs to a particular external parameter of the experiment.

If you uploaded an OTUs counting table, you will be able to explore the relative taxon abundance of each module.

_If you uploaded more than one omics table:_

Use the tabsets called 'second dataset' and 'third datasets' to explore the modules of your other networks.

## Multi-Omics Analysis:

**Ordination technique: Co-Inertia Analysis**

The co-inertia analysis is performed with the omicade4 R package used to perform multiple co-inertia analysis and created by Meng C, et al. in 2013. This package is based on the work realized by [Stephane Dray, Daniel Chessel and Jean Thioulouse in 2003](https://pdfs.semanticscholar.org/7789/8adf13dfd073efddcf044e6efb49294cf402.pdf?_ga=2.195525546.789625893.1565097558-2032186863.1565097558). With the co-inertia they created a methodoly to associate two datasets and to represent the co-variance between both datasets. In MiBiOmics, the co-inertia is represented in two different ways. In the first figure (on the top in the multi-omics analysis tab), the samples are placed on the plot according to their values in the co-inertia first and second axis. The closest they are to the maximal correlation line in red, the more they are correlated according to their expressions/concentrations/abundances values in both datasets. The second figure represents the co-variance between the values of each sample in both datasets. Each sample is represented twice in the plot: the filled circle represents the first datasets and more specifically the position of the sample in the first ordination space, the empty square represents the second datasets and the position of the same sample in the second ordination space. Both representation of the samples are linked with a line and the length of the line indicates how much the values of the same sample co-vary from one dataset to the other. The longer is the line the less the values of the same sample co-vary from one dataset to the other. The variables that are the most associated with the covariance of both datasets are also plotted on the co-inertia. They can belong to both datasets. The RV score indicates the quality of the co-inertia. It values varies between 0 and 1 and the closest it is to 1, the best is the covariation between both datasets.

The co-inertia information tabset shows the length of this line for each samples represented with a dendrogramme, and two other figures. This tabsets might help to isolate the samples with a low covariation and see if it can be associated with a external clinical traits.

**Ordination Technique: Procrustes Analysis**

Procrustes analysis is realized in MiBiOmics thanks to the [vegan](http://cc.oulu.fi/~jarioksa/opetus/metodi/vegantutor.pdf) R package created by Jari Oksanen. The procrustes method was originally created by [J. C. Gower in 1975](https://link.springer.com/content/pdf/10.1007%2FBF02291478.pdf) and uses the 3D configuration of the datasets ordinations, reorientate and re-scale them to allow the comparison of these differents ordination in multidimensional space. The procrustes analysis plot can be found in the procrustes analysis tabset and can be interpreted as the co-inertia analysis plot. (only available when 2 Omics table are uploaded)

**Correlation Network analysis: using WGCNA modules to compare sub-parts of two different networks.**

The first heatmap represents the correlation between each modules of both networks. The more two modules are correlated the more they might be associated to each other. This heatmap needs to be used as a guide to select the module of both network (and both omics layers) to each other. Only one module of each network can be selected to pursue the analysis. These correlations are also represented with hive plots.

Once a module from each network (each omics dataset) is selected, the pairwise correlation between each variables of each modules is performed and represented in two different manners: a bi-partite networks and a correlation heatmap. In the bi-partite networks, red nodes represents the variables of the first dataset and blue nodes the variables of the second datasets. A line between two nodes indicates an association. The following heatmap represents the correlation values between the variables of the first selected module (first omics layer) and the variables of the second selected module (second omic layer)

# Common sources of error in MiBiOmics:
Most error messages appear during the loading of the data or in the multi-omics section. They are mostly due to file format. To prevent these common error messages, here are some suggestions:
* Make sure your column names all begin with a character (in r, column names beginning with a number are modified)
* Upload an annotation file with at least 2 variables containing non-unique values.
* Rownames must be unique identifiers.

# Reported Issue:
* During local installation, on your Rstudio session, if you obtain the following error:
```bash
Warning: Error in writeImpl: Text to be written must be a length-one character vector
[No stack trace available] 
```
It is because there is a conflict between your current R and shiny versions and the required library for the installation of MiBiOmics. We advise to create a conda environment with the MiBiOmics.yml file and run your R session from this environment to prevent any conflict issue between packages. If you are not familiar with conda all the information for the installation and creation of conda environment are available here. 
You can also use the web-server version: https://shiny-bird.univ-nantes.fr/app/Mibiomics 
Or the docker image: https://hub.docker.com/repository/docker/jojoh2943/mibiomics_v2

* When downloading figures and MiBiOmics outputs with the local version, if the file is not found and you have the following error message:

```bash
sh: 1: : Permission denied
```
You need to run your R session as an administrator (via the terminal use sudo).

* When downloading the last heatmap in the Multi-Omics analysis section you may encounter the following error:

```bash
Error in saveWidget: Saving a widget with selfcontained = TRUE requires pandoc.
```
In this case, please install pandoc on your PC.

