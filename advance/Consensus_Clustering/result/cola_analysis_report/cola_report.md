cola Report for Consensus Partitioning
==================

**Date**: 2025-09-30 02:01:58 CST, **cola version**: 2.14.0

----------------------------------------------------------------

<style type='text/css'>

body, td, th {
   font-family: Arial,Helvetica,sans-serif;
   background-color: white;
   font-size: 13px;
  max-width: 800px;
  margin: auto;
  margin-left:210px;
  padding: 0px 10px 0px 10px;
  border-left: 1px solid #EEEEEE;
  line-height: 150%;
}

tt, code, pre {
   font-family: 'DejaVu Sans Mono', 'Droid Sans Mono', 'Lucida Console', Consolas, Monaco, 

monospace;
}

h1 {
   font-size:2.2em;
   line-height:150%;
}

h2 {
   font-size:1.8em;
}

h3 {
   font-size:1.4em;
}

h4 {
   font-size:1.0em;
}

h5 {
   font-size:0.9em;
}

h6 {
   font-size:0.8em;
}

a {
  text-decoration: none;
  color: #0366d6;
}

a:hover {
  text-decoration: underline;
}

a:visited {
   color: #0366d6;
}

pre, img {
  max-width: 100%;
}
pre {
  overflow-x: auto;
}
pre code {
   display: block; padding: 0.5em;
}

code {
  font-size: 92%;
  border: 1px solid #ccc;
}

code[class] {
  background-color: #F8F8F8;
}

table, td, th {
  border: 1px solid #ccc;
}

blockquote {
   color:#666666;
   margin:0;
   padding-left: 1em;
   border-left: 0.5em #EEE solid;
}

hr {
   height: 0px;
   border-bottom: none;
   border-top-width: thin;
   border-top-style: dotted;
   border-top-color: #999999;
}

@media print {
   * {
      background: transparent !important;
      color: black !important;
      filter:none !important;
      -ms-filter: none !important;
   }

   body {
      font-size:12pt;
      max-width:100%;
   }

   a, a:visited {
      text-decoration: underline;
   }

   hr {
      visibility: hidden;
      page-break-before: always;
   }

   pre, blockquote {
      padding-right: 1em;
      page-break-inside: avoid;
   }

   tr, img {
      page-break-inside: avoid;
   }

   img {
      max-width: 100% !important;
   }

   @page :left {
      margin: 15mm 20mm 15mm 10mm;
   }

   @page :right {
      margin: 15mm 10mm 15mm 20mm;
   }

   p, h2, h3 {
      orphans: 3; widows: 3;
   }

   h2, h3 {
      page-break-after: avoid;
   }
}
</style>




## Summary



First the variable is renamed to `res_list`.


``` r
res_list = rl
```



All available functions which can be applied to this `res_list` object:


``` r
res_list
```

```
#> A 'ConsensusPartitionList' object with 20 methods.
#>   On a matrix with 1900 rows and 60 columns.
#>   Top rows are extracted by 'SD, MAD, CV, ATC' methods.
#>   Subgroups are detected by 'hclust, kmeans, pam, skmeans, mclust' method.
#>   Number of partitions are tried for k = 2, 3, 4, 5, 6.
#>   Performed in total 5000 partitions by row resampling.
#> 
#> Following methods can be applied to this 'ConsensusPartitionList' object:
#>  [1] "cola_report"           "collect_classes"       "collect_plots"         "collect_stats"        
#>  [5] "colnames"              "functional_enrichment" "get_anno_col"          "get_anno"             
#>  [9] "get_classes"           "get_matrix"            "get_membership"        "get_stats"            
#> [13] "is_best_k"             "is_stable_k"           "ncol"                  "nrow"                 
#> [17] "rownames"              "show"                  "suggest_best_k"        "test_to_known_factors"
#> [21] "top_rows_heatmap"      "top_rows_overlap"     
#> 
#> You can get result for a single method by, e.g. object["SD", "hclust"] or object["SD:hclust"]
#> or a subset of methods by object[c("SD", "MAD")], c("hclust", "kmeans")]
```

The call of `run_all_consensus_partition_methods()` was:


```
#> run_all_consensus_partition_methods(data = mat, top_value_method = top_value_methods, 
#>     partition_method = partition_methods, cores = cores)
```

Dimension of the input matrix:


``` r
mat = get_matrix(res_list)
dim(mat)
```

```
#> [1] 1900   60
```

### Density distribution

The density distribution for each sample is visualized as in one column in the
following heatmap. The clustering is based on the distance which is the
Kolmogorov-Smirnov statistic between two distributions.




``` r
library(ComplexHeatmap)
densityHeatmap(mat, ylab = "value", cluster_columns = TRUE, show_column_names = FALSE,
    mc.cores = 1)
```

![plot of chunk density-heatmap](figure_cola/density-heatmap-1.png)





### Suggest the best k



Folowing table shows the best `k` (number of partitions) for each combination
of top-value methods and partitioning methods. Clicking on the method name in
the table goes to the corresponding section for a single combination of methods.

[The cola vignette](https://jokergoo.github.io/cola_vignettes/cola.html#toc_13)
explains the definition of the metrics used for determining the best
number of partitions.


``` r
suggest_best_k(res_list)
```


|            | The best k| 1-PAC| Mean silhouette| Concordance|   |Optional k |
|:-----------|----------:|-----:|---------------:|-----------:|:--|:----------|
|[MAD:mclust](#mad-mclust)|          3| 1.000|           0.951|       0.981|** |           |
|[ATC:kmeans](#atc-kmeans)|          2| 1.000|           0.982|       0.993|** |           |
|[MAD:kmeans](#mad-kmeans)|          2| 0.999|           0.940|       0.976|** |           |
|[MAD:skmeans](#mad-skmeans)|          3| 0.953|           0.940|       0.975|** |2          |
|[MAD:pam](#mad-pam)|          2| 0.930|           0.950|       0.977|*  |           |
|[ATC:pam](#atc-pam)|          3| 0.902|           0.952|       0.978|*  |2          |
|[ATC:skmeans](#atc-skmeans)|          6| 0.902|           0.792|       0.911|*  |4          |
|[SD:skmeans](#sd-skmeans)|          2| 0.857|           0.922|       0.966|   |           |
|[ATC:mclust](#atc-mclust)|          4| 0.843|           0.849|       0.919|   |           |
|[SD:kmeans](#sd-kmeans)|          2| 0.737|           0.894|       0.953|   |           |
|[ATC:hclust](#atc-hclust)|          2| 0.617|           0.890|       0.937|   |           |
|[CV:pam](#cv-pam)|          5| 0.590|           0.627|       0.817|   |           |
|[CV:skmeans](#cv-skmeans)|          2| 0.549|           0.890|       0.934|   |           |
|[SD:mclust](#sd-mclust)|          2| 0.476|           0.855|       0.907|   |           |
|[MAD:hclust](#mad-hclust)|          3| 0.429|           0.700|       0.847|   |           |
|[CV:kmeans](#cv-kmeans)|          4| 0.378|           0.540|       0.725|   |           |
|[SD:pam](#sd-pam)|          2| 0.365|           0.694|       0.866|   |           |
|[CV:mclust](#cv-mclust)|          3| 0.359|           0.602|       0.806|   |           |
|[CV:hclust](#cv-hclust)|          3| 0.288|           0.639|       0.833|   |           |
|[SD:hclust](#sd-hclust)|          2| 0.257|           0.737|       0.857|   |           |

\*\*: 1-PAC > 0.95, \*: 1-PAC > 0.9




### CDF of consensus matrices

Cumulative distribution function curves of consensus matrix for all methods.




``` r
collect_plots(res_list, fun = plot_ecdf)
```

![plot of chunk collect-plots](figure_cola/collect-plots-1.png)



### Consensus heatmap

Consensus heatmaps for all methods. ([What is a consensus heatmap?](https://jokergoo.github.io/cola_vignettes/cola.html#toc_9))


<style type='text/css'>



.ui-helper-hidden {
	display: none;
}
.ui-helper-hidden-accessible {
	border: 0;
	clip: rect(0 0 0 0);
	height: 1px;
	margin: -1px;
	overflow: hidden;
	padding: 0;
	position: absolute;
	width: 1px;
}
.ui-helper-reset {
	margin: 0;
	padding: 0;
	border: 0;
	outline: 0;
	line-height: 1.3;
	text-decoration: none;
	font-size: 100%;
	list-style: none;
}
.ui-helper-clearfix:before,
.ui-helper-clearfix:after {
	content: "";
	display: table;
	border-collapse: collapse;
}
.ui-helper-clearfix:after {
	clear: both;
}
.ui-helper-zfix {
	width: 100%;
	height: 100%;
	top: 0;
	left: 0;
	position: absolute;
	opacity: 0;
	filter:Alpha(Opacity=0); 
}

.ui-front {
	z-index: 100;
}



.ui-state-disabled {
	cursor: default !important;
	pointer-events: none;
}



.ui-icon {
	display: inline-block;
	vertical-align: middle;
	margin-top: -.25em;
	position: relative;
	text-indent: -99999px;
	overflow: hidden;
	background-repeat: no-repeat;
}

.ui-widget-icon-block {
	left: 50%;
	margin-left: -8px;
	display: block;
}




.ui-widget-overlay {
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
}
.ui-accordion .ui-accordion-header {
	display: block;
	cursor: pointer;
	position: relative;
	margin: 2px 0 0 0;
	padding: .5em .5em .5em .7em;
	font-size: 100%;
}
.ui-accordion .ui-accordion-content {
	padding: 1em 2.2em;
	border-top: 0;
	overflow: auto;
}
.ui-autocomplete {
	position: absolute;
	top: 0;
	left: 0;
	cursor: default;
}
.ui-menu {
	list-style: none;
	padding: 0;
	margin: 0;
	display: block;
	outline: 0;
}
.ui-menu .ui-menu {
	position: absolute;
}
.ui-menu .ui-menu-item {
	margin: 0;
	cursor: pointer;
	
	list-style-image: url("data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7");
}
.ui-menu .ui-menu-item-wrapper {
	position: relative;
	padding: 3px 1em 3px .4em;
}
.ui-menu .ui-menu-divider {
	margin: 5px 0;
	height: 0;
	font-size: 0;
	line-height: 0;
	border-width: 1px 0 0 0;
}
.ui-menu .ui-state-focus,
.ui-menu .ui-state-active {
	margin: -1px;
}


.ui-menu-icons {
	position: relative;
}
.ui-menu-icons .ui-menu-item-wrapper {
	padding-left: 2em;
}


.ui-menu .ui-icon {
	position: absolute;
	top: 0;
	bottom: 0;
	left: .2em;
	margin: auto 0;
}


.ui-menu .ui-menu-icon {
	left: auto;
	right: 0;
}
.ui-button {
	padding: .4em 1em;
	display: inline-block;
	position: relative;
	line-height: normal;
	margin-right: .1em;
	cursor: pointer;
	vertical-align: middle;
	text-align: center;
	-webkit-user-select: none;
	-moz-user-select: none;
	-ms-user-select: none;
	user-select: none;

	
	overflow: visible;
}

.ui-button,
.ui-button:link,
.ui-button:visited,
.ui-button:hover,
.ui-button:active {
	text-decoration: none;
}


.ui-button-icon-only {
	width: 2em;
	box-sizing: border-box;
	text-indent: -9999px;
	white-space: nowrap;
}


input.ui-button.ui-button-icon-only {
	text-indent: 0;
}


.ui-button-icon-only .ui-icon {
	position: absolute;
	top: 50%;
	left: 50%;
	margin-top: -8px;
	margin-left: -8px;
}

.ui-button.ui-icon-notext .ui-icon {
	padding: 0;
	width: 2.1em;
	height: 2.1em;
	text-indent: -9999px;
	white-space: nowrap;

}

input.ui-button.ui-icon-notext .ui-icon {
	width: auto;
	height: auto;
	text-indent: 0;
	white-space: normal;
	padding: .4em 1em;
}



input.ui-button::-moz-focus-inner,
button.ui-button::-moz-focus-inner {
	border: 0;
	padding: 0;
}
.ui-controlgroup {
	vertical-align: middle;
	display: inline-block;
}
.ui-controlgroup > .ui-controlgroup-item {
	float: left;
	margin-left: 0;
	margin-right: 0;
}
.ui-controlgroup > .ui-controlgroup-item:focus,
.ui-controlgroup > .ui-controlgroup-item.ui-visual-focus {
	z-index: 9999;
}
.ui-controlgroup-vertical > .ui-controlgroup-item {
	display: block;
	float: none;
	width: 100%;
	margin-top: 0;
	margin-bottom: 0;
	text-align: left;
}
.ui-controlgroup-vertical .ui-controlgroup-item {
	box-sizing: border-box;
}
.ui-controlgroup .ui-controlgroup-label {
	padding: .4em 1em;
}
.ui-controlgroup .ui-controlgroup-label span {
	font-size: 80%;
}
.ui-controlgroup-horizontal .ui-controlgroup-label + .ui-controlgroup-item {
	border-left: none;
}
.ui-controlgroup-vertical .ui-controlgroup-label + .ui-controlgroup-item {
	border-top: none;
}
.ui-controlgroup-horizontal .ui-controlgroup-label.ui-widget-content {
	border-right: none;
}
.ui-controlgroup-vertical .ui-controlgroup-label.ui-widget-content {
	border-bottom: none;
}


.ui-controlgroup-vertical .ui-spinner-input {

	
	width: 75%;
	width: calc( 100% - 2.4em );
}
.ui-controlgroup-vertical .ui-spinner .ui-spinner-up {
	border-top-style: solid;
}

.ui-checkboxradio-label .ui-icon-background {
	box-shadow: inset 1px 1px 1px #ccc;
	border-radius: .12em;
	border: none;
}
.ui-checkboxradio-radio-label .ui-icon-background {
	width: 16px;
	height: 16px;
	border-radius: 1em;
	overflow: visible;
	border: none;
}
.ui-checkboxradio-radio-label.ui-checkboxradio-checked .ui-icon,
.ui-checkboxradio-radio-label.ui-checkboxradio-checked:hover .ui-icon {
	background-image: none;
	width: 8px;
	height: 8px;
	border-width: 4px;
	border-style: solid;
}
.ui-checkboxradio-disabled {
	pointer-events: none;
}
.ui-datepicker {
	width: 17em;
	padding: .2em .2em 0;
	display: none;
}
.ui-datepicker .ui-datepicker-header {
	position: relative;
	padding: .2em 0;
}
.ui-datepicker .ui-datepicker-prev,
.ui-datepicker .ui-datepicker-next {
	position: absolute;
	top: 2px;
	width: 1.8em;
	height: 1.8em;
}
.ui-datepicker .ui-datepicker-prev-hover,
.ui-datepicker .ui-datepicker-next-hover {
	top: 1px;
}
.ui-datepicker .ui-datepicker-prev {
	left: 2px;
}
.ui-datepicker .ui-datepicker-next {
	right: 2px;
}
.ui-datepicker .ui-datepicker-prev-hover {
	left: 1px;
}
.ui-datepicker .ui-datepicker-next-hover {
	right: 1px;
}
.ui-datepicker .ui-datepicker-prev span,
.ui-datepicker .ui-datepicker-next span {
	display: block;
	position: absolute;
	left: 50%;
	margin-left: -8px;
	top: 50%;
	margin-top: -8px;
}
.ui-datepicker .ui-datepicker-title {
	margin: 0 2.3em;
	line-height: 1.8em;
	text-align: center;
}
.ui-datepicker .ui-datepicker-title select {
	font-size: 1em;
	margin: 1px 0;
}
.ui-datepicker select.ui-datepicker-month,
.ui-datepicker select.ui-datepicker-year {
	width: 45%;
}
.ui-datepicker table {
	width: 100%;
	font-size: .9em;
	border-collapse: collapse;
	margin: 0 0 .4em;
}
.ui-datepicker th {
	padding: .7em .3em;
	text-align: center;
	font-weight: bold;
	border: 0;
}
.ui-datepicker td {
	border: 0;
	padding: 1px;
}
.ui-datepicker td span,
.ui-datepicker td a {
	display: block;
	padding: .2em;
	text-align: right;
	text-decoration: none;
}
.ui-datepicker .ui-datepicker-buttonpane {
	background-image: none;
	margin: .7em 0 0 0;
	padding: 0 .2em;
	border-left: 0;
	border-right: 0;
	border-bottom: 0;
}
.ui-datepicker .ui-datepicker-buttonpane button {
	float: right;
	margin: .5em .2em .4em;
	cursor: pointer;
	padding: .2em .6em .3em .6em;
	width: auto;
	overflow: visible;
}
.ui-datepicker .ui-datepicker-buttonpane button.ui-datepicker-current {
	float: left;
}


.ui-datepicker.ui-datepicker-multi {
	width: auto;
}
.ui-datepicker-multi .ui-datepicker-group {
	float: left;
}
.ui-datepicker-multi .ui-datepicker-group table {
	width: 95%;
	margin: 0 auto .4em;
}
.ui-datepicker-multi-2 .ui-datepicker-group {
	width: 50%;
}
.ui-datepicker-multi-3 .ui-datepicker-group {
	width: 33.3%;
}
.ui-datepicker-multi-4 .ui-datepicker-group {
	width: 25%;
}
.ui-datepicker-multi .ui-datepicker-group-last .ui-datepicker-header,
.ui-datepicker-multi .ui-datepicker-group-middle .ui-datepicker-header {
	border-left-width: 0;
}
.ui-datepicker-multi .ui-datepicker-buttonpane {
	clear: left;
}
.ui-datepicker-row-break {
	clear: both;
	width: 100%;
	font-size: 0;
}


.ui-datepicker-rtl {
	direction: rtl;
}
.ui-datepicker-rtl .ui-datepicker-prev {
	right: 2px;
	left: auto;
}
.ui-datepicker-rtl .ui-datepicker-next {
	left: 2px;
	right: auto;
}
.ui-datepicker-rtl .ui-datepicker-prev:hover {
	right: 1px;
	left: auto;
}
.ui-datepicker-rtl .ui-datepicker-next:hover {
	left: 1px;
	right: auto;
}
.ui-datepicker-rtl .ui-datepicker-buttonpane {
	clear: right;
}
.ui-datepicker-rtl .ui-datepicker-buttonpane button {
	float: left;
}
.ui-datepicker-rtl .ui-datepicker-buttonpane button.ui-datepicker-current,
.ui-datepicker-rtl .ui-datepicker-group {
	float: right;
}
.ui-datepicker-rtl .ui-datepicker-group-last .ui-datepicker-header,
.ui-datepicker-rtl .ui-datepicker-group-middle .ui-datepicker-header {
	border-right-width: 0;
	border-left-width: 1px;
}


.ui-datepicker .ui-icon {
	display: block;
	text-indent: -99999px;
	overflow: hidden;
	background-repeat: no-repeat;
	left: .5em;
	top: .3em;
}
.ui-dialog {
	position: absolute;
	top: 0;
	left: 0;
	padding: .2em;
	outline: 0;
}
.ui-dialog .ui-dialog-titlebar {
	padding: .4em 1em;
	position: relative;
}
.ui-dialog .ui-dialog-title {
	float: left;
	margin: .1em 0;
	white-space: nowrap;
	width: 90%;
	overflow: hidden;
	text-overflow: ellipsis;
}
.ui-dialog .ui-dialog-titlebar-close {
	position: absolute;
	right: .3em;
	top: 50%;
	width: 20px;
	margin: -10px 0 0 0;
	padding: 1px;
	height: 20px;
}
.ui-dialog .ui-dialog-content {
	position: relative;
	border: 0;
	padding: .5em 1em;
	background: none;
	overflow: auto;
}
.ui-dialog .ui-dialog-buttonpane {
	text-align: left;
	border-width: 1px 0 0 0;
	background-image: none;
	margin-top: .5em;
	padding: .3em 1em .5em .4em;
}
.ui-dialog .ui-dialog-buttonpane .ui-dialog-buttonset {
	float: right;
}
.ui-dialog .ui-dialog-buttonpane button {
	margin: .5em .4em .5em 0;
	cursor: pointer;
}
.ui-dialog .ui-resizable-n {
	height: 2px;
	top: 0;
}
.ui-dialog .ui-resizable-e {
	width: 2px;
	right: 0;
}
.ui-dialog .ui-resizable-s {
	height: 2px;
	bottom: 0;
}
.ui-dialog .ui-resizable-w {
	width: 2px;
	left: 0;
}
.ui-dialog .ui-resizable-se,
.ui-dialog .ui-resizable-sw,
.ui-dialog .ui-resizable-ne,
.ui-dialog .ui-resizable-nw {
	width: 7px;
	height: 7px;
}
.ui-dialog .ui-resizable-se {
	right: 0;
	bottom: 0;
}
.ui-dialog .ui-resizable-sw {
	left: 0;
	bottom: 0;
}
.ui-dialog .ui-resizable-ne {
	right: 0;
	top: 0;
}
.ui-dialog .ui-resizable-nw {
	left: 0;
	top: 0;
}
.ui-draggable .ui-dialog-titlebar {
	cursor: move;
}
.ui-draggable-handle {
	-ms-touch-action: none;
	touch-action: none;
}
.ui-resizable {
	position: relative;
}
.ui-resizable-handle {
	position: absolute;
	font-size: 0.1px;
	display: block;
	-ms-touch-action: none;
	touch-action: none;
}
.ui-resizable-disabled .ui-resizable-handle,
.ui-resizable-autohide .ui-resizable-handle {
	display: none;
}
.ui-resizable-n {
	cursor: n-resize;
	height: 7px;
	width: 100%;
	top: -5px;
	left: 0;
}
.ui-resizable-s {
	cursor: s-resize;
	height: 7px;
	width: 100%;
	bottom: -5px;
	left: 0;
}
.ui-resizable-e {
	cursor: e-resize;
	width: 7px;
	right: -5px;
	top: 0;
	height: 100%;
}
.ui-resizable-w {
	cursor: w-resize;
	width: 7px;
	left: -5px;
	top: 0;
	height: 100%;
}
.ui-resizable-se {
	cursor: se-resize;
	width: 12px;
	height: 12px;
	right: 1px;
	bottom: 1px;
}
.ui-resizable-sw {
	cursor: sw-resize;
	width: 9px;
	height: 9px;
	left: -5px;
	bottom: -5px;
}
.ui-resizable-nw {
	cursor: nw-resize;
	width: 9px;
	height: 9px;
	left: -5px;
	top: -5px;
}
.ui-resizable-ne {
	cursor: ne-resize;
	width: 9px;
	height: 9px;
	right: -5px;
	top: -5px;
}
.ui-progressbar {
	height: 2em;
	text-align: left;
	overflow: hidden;
}
.ui-progressbar .ui-progressbar-value {
	margin: -1px;
	height: 100%;
}
.ui-progressbar .ui-progressbar-overlay {
	background: url("data:image/gif;base64,R0lGODlhKAAoAIABAAAAAP///yH/C05FVFNDQVBFMi4wAwEAAAAh+QQJAQABACwAAAAAKAAoAAACkYwNqXrdC52DS06a7MFZI+4FHBCKoDeWKXqymPqGqxvJrXZbMx7Ttc+w9XgU2FB3lOyQRWET2IFGiU9m1frDVpxZZc6bfHwv4c1YXP6k1Vdy292Fb6UkuvFtXpvWSzA+HycXJHUXiGYIiMg2R6W459gnWGfHNdjIqDWVqemH2ekpObkpOlppWUqZiqr6edqqWQAAIfkECQEAAQAsAAAAACgAKAAAApSMgZnGfaqcg1E2uuzDmmHUBR8Qil95hiPKqWn3aqtLsS18y7G1SzNeowWBENtQd+T1JktP05nzPTdJZlR6vUxNWWjV+vUWhWNkWFwxl9VpZRedYcflIOLafaa28XdsH/ynlcc1uPVDZxQIR0K25+cICCmoqCe5mGhZOfeYSUh5yJcJyrkZWWpaR8doJ2o4NYq62lAAACH5BAkBAAEALAAAAAAoACgAAAKVDI4Yy22ZnINRNqosw0Bv7i1gyHUkFj7oSaWlu3ovC8GxNso5fluz3qLVhBVeT/Lz7ZTHyxL5dDalQWPVOsQWtRnuwXaFTj9jVVh8pma9JjZ4zYSj5ZOyma7uuolffh+IR5aW97cHuBUXKGKXlKjn+DiHWMcYJah4N0lYCMlJOXipGRr5qdgoSTrqWSq6WFl2ypoaUAAAIfkECQEAAQAsAAAAACgAKAAAApaEb6HLgd/iO7FNWtcFWe+ufODGjRfoiJ2akShbueb0wtI50zm02pbvwfWEMWBQ1zKGlLIhskiEPm9R6vRXxV4ZzWT2yHOGpWMyorblKlNp8HmHEb/lCXjcW7bmtXP8Xt229OVWR1fod2eWqNfHuMjXCPkIGNileOiImVmCOEmoSfn3yXlJWmoHGhqp6ilYuWYpmTqKUgAAIfkECQEAAQAsAAAAACgAKAAAApiEH6kb58biQ3FNWtMFWW3eNVcojuFGfqnZqSebuS06w5V80/X02pKe8zFwP6EFWOT1lDFk8rGERh1TTNOocQ61Hm4Xm2VexUHpzjymViHrFbiELsefVrn6XKfnt2Q9G/+Xdie499XHd2g4h7ioOGhXGJboGAnXSBnoBwKYyfioubZJ2Hn0RuRZaflZOil56Zp6iioKSXpUAAAh+QQJAQABACwAAAAAKAAoAAACkoQRqRvnxuI7kU1a1UU5bd5tnSeOZXhmn5lWK3qNTWvRdQxP8qvaC+/yaYQzXO7BMvaUEmJRd3TsiMAgswmNYrSgZdYrTX6tSHGZO73ezuAw2uxuQ+BbeZfMxsexY35+/Qe4J1inV0g4x3WHuMhIl2jXOKT2Q+VU5fgoSUI52VfZyfkJGkha6jmY+aaYdirq+lQAACH5BAkBAAEALAAAAAAoACgAAAKWBIKpYe0L3YNKToqswUlvznigd4wiR4KhZrKt9Upqip61i9E3vMvxRdHlbEFiEXfk9YARYxOZZD6VQ2pUunBmtRXo1Lf8hMVVcNl8JafV38aM2/Fu5V16Bn63r6xt97j09+MXSFi4BniGFae3hzbH9+hYBzkpuUh5aZmHuanZOZgIuvbGiNeomCnaxxap2upaCZsq+1kAACH5BAkBAAEALAAAAAAoACgAAAKXjI8By5zf4kOxTVrXNVlv1X0d8IGZGKLnNpYtm8Lr9cqVeuOSvfOW79D9aDHizNhDJidFZhNydEahOaDH6nomtJjp1tutKoNWkvA6JqfRVLHU/QUfau9l2x7G54d1fl995xcIGAdXqMfBNadoYrhH+Mg2KBlpVpbluCiXmMnZ2Sh4GBqJ+ckIOqqJ6LmKSllZmsoq6wpQAAAh+QQJAQABACwAAAAAKAAoAAAClYx/oLvoxuJDkU1a1YUZbJ59nSd2ZXhWqbRa2/gF8Gu2DY3iqs7yrq+xBYEkYvFSM8aSSObE+ZgRl1BHFZNr7pRCavZ5BW2142hY3AN/zWtsmf12p9XxxFl2lpLn1rseztfXZjdIWIf2s5dItwjYKBgo9yg5pHgzJXTEeGlZuenpyPmpGQoKOWkYmSpaSnqKileI2FAAACH5BAkBAAEALAAAAAAoACgAAAKVjB+gu+jG4kORTVrVhRlsnn2dJ3ZleFaptFrb+CXmO9OozeL5VfP99HvAWhpiUdcwkpBH3825AwYdU8xTqlLGhtCosArKMpvfa1mMRae9VvWZfeB2XfPkeLmm18lUcBj+p5dnN8jXZ3YIGEhYuOUn45aoCDkp16hl5IjYJvjWKcnoGQpqyPlpOhr3aElaqrq56Bq7VAAAOw==");
	height: 100%;
	filter: alpha(opacity=25); 
	opacity: 0.25;
}
.ui-progressbar-indeterminate .ui-progressbar-value {
	background-image: none;
}
.ui-selectable {
	-ms-touch-action: none;
	touch-action: none;
}
.ui-selectable-helper {
	position: absolute;
	z-index: 100;
	border: 1px dotted black;
}
.ui-selectmenu-menu {
	padding: 0;
	margin: 0;
	position: absolute;
	top: 0;
	left: 0;
	display: none;
}
.ui-selectmenu-menu .ui-menu {
	overflow: auto;
	overflow-x: hidden;
	padding-bottom: 1px;
}
.ui-selectmenu-menu .ui-menu .ui-selectmenu-optgroup {
	font-size: 1em;
	font-weight: bold;
	line-height: 1.5;
	padding: 2px 0.4em;
	margin: 0.5em 0 0 0;
	height: auto;
	border: 0;
}
.ui-selectmenu-open {
	display: block;
}
.ui-selectmenu-text {
	display: block;
	margin-right: 20px;
	overflow: hidden;
	text-overflow: ellipsis;
}
.ui-selectmenu-button.ui-button {
	text-align: left;
	white-space: nowrap;
	width: 14em;
}
.ui-selectmenu-icon.ui-icon {
	float: right;
	margin-top: 0;
}
.ui-slider {
	position: relative;
	text-align: left;
}
.ui-slider .ui-slider-handle {
	position: absolute;
	z-index: 2;
	width: 1.2em;
	height: 1.2em;
	cursor: default;
	-ms-touch-action: none;
	touch-action: none;
}
.ui-slider .ui-slider-range {
	position: absolute;
	z-index: 1;
	font-size: .7em;
	display: block;
	border: 0;
	background-position: 0 0;
}


.ui-slider.ui-state-disabled .ui-slider-handle,
.ui-slider.ui-state-disabled .ui-slider-range {
	filter: inherit;
}

.ui-slider-horizontal {
	height: .8em;
}
.ui-slider-horizontal .ui-slider-handle {
	top: -.3em;
	margin-left: -.6em;
}
.ui-slider-horizontal .ui-slider-range {
	top: 0;
	height: 100%;
}
.ui-slider-horizontal .ui-slider-range-min {
	left: 0;
}
.ui-slider-horizontal .ui-slider-range-max {
	right: 0;
}

.ui-slider-vertical {
	width: .8em;
	height: 100px;
}
.ui-slider-vertical .ui-slider-handle {
	left: -.3em;
	margin-left: 0;
	margin-bottom: -.6em;
}
.ui-slider-vertical .ui-slider-range {
	left: 0;
	width: 100%;
}
.ui-slider-vertical .ui-slider-range-min {
	bottom: 0;
}
.ui-slider-vertical .ui-slider-range-max {
	top: 0;
}
.ui-sortable-handle {
	-ms-touch-action: none;
	touch-action: none;
}
.ui-spinner {
	position: relative;
	display: inline-block;
	overflow: hidden;
	padding: 0;
	vertical-align: middle;
}
.ui-spinner-input {
	border: none;
	background: none;
	color: inherit;
	padding: .222em 0;
	margin: .2em 0;
	vertical-align: middle;
	margin-left: .4em;
	margin-right: 2em;
}
.ui-spinner-button {
	width: 1.6em;
	height: 50%;
	font-size: .5em;
	padding: 0;
	margin: 0;
	text-align: center;
	position: absolute;
	cursor: default;
	display: block;
	overflow: hidden;
	right: 0;
}

.ui-spinner a.ui-spinner-button {
	border-top-style: none;
	border-bottom-style: none;
	border-right-style: none;
}
.ui-spinner-up {
	top: 0;
}
.ui-spinner-down {
	bottom: 0;
}
.ui-tabs {
	position: relative;
	padding: .2em;
}
.ui-tabs .ui-tabs-nav {
	margin: 0;
	padding: .2em .2em 0;
}
.ui-tabs .ui-tabs-nav li {
	list-style: none;
	float: left;
	position: relative;
	top: 0;
	margin: 1px .2em 0 0;
	border-bottom-width: 0;
	padding: 0;
	white-space: nowrap;
}
.ui-tabs .ui-tabs-nav .ui-tabs-anchor {
	float: left;
	padding: .5em 1em;
	text-decoration: none;
}
.ui-tabs .ui-tabs-nav li.ui-tabs-active {
	margin-bottom: -1px;
	padding-bottom: 1px;
}
.ui-tabs .ui-tabs-nav li.ui-tabs-active .ui-tabs-anchor,
.ui-tabs .ui-tabs-nav li.ui-state-disabled .ui-tabs-anchor,
.ui-tabs .ui-tabs-nav li.ui-tabs-loading .ui-tabs-anchor {
	cursor: text;
}
.ui-tabs-collapsible .ui-tabs-nav li.ui-tabs-active .ui-tabs-anchor {
	cursor: pointer;
}
.ui-tabs .ui-tabs-panel {
	display: block;
	border-width: 0;
	padding: 1em 1.4em;
	background: none;
}
.ui-tooltip {
	padding: 8px;
	position: absolute;
	z-index: 9999;
	max-width: 300px;
}
body .ui-tooltip {
	border-width: 2px;
}

.ui-widget {
	font-family: Arial,Helvetica,sans-serif;
	font-size: 1em;
}
.ui-widget .ui-widget {
	font-size: 1em;
}
.ui-widget input,
.ui-widget select,
.ui-widget textarea,
.ui-widget button {
	font-family: Arial,Helvetica,sans-serif;
	font-size: 1em;
}
.ui-widget.ui-widget-content {
	border: 1px solid #c5c5c5;
}
.ui-widget-content {
	border: 1px solid #dddddd;
	background: #ffffff;
	color: #333333;
}
.ui-widget-content a {
	color: #333333;
}
.ui-widget-header {
	border: 1px solid #dddddd;
	background: #e9e9e9;
	color: #333333;
	font-weight: bold;
}
.ui-widget-header a {
	color: #333333;
}


.ui-state-default,
.ui-widget-content .ui-state-default,
.ui-widget-header .ui-state-default,
.ui-button,


html .ui-button.ui-state-disabled:hover,
html .ui-button.ui-state-disabled:active {
	border: 1px solid #c5c5c5;
	background: #f6f6f6;
	font-weight: normal;
	color: #454545;
}
.ui-state-default a,
.ui-state-default a:link,
.ui-state-default a:visited,
a.ui-button,
a:link.ui-button,
a:visited.ui-button,
.ui-button {
	color: #454545;
	text-decoration: none;
}
.ui-state-hover,
.ui-widget-content .ui-state-hover,
.ui-widget-header .ui-state-hover,
.ui-state-focus,
.ui-widget-content .ui-state-focus,
.ui-widget-header .ui-state-focus,
.ui-button:hover,
.ui-button:focus {
	border: 1px solid #cccccc;
	background: #ededed;
	font-weight: normal;
	color: #2b2b2b;
}
.ui-state-hover a,
.ui-state-hover a:hover,
.ui-state-hover a:link,
.ui-state-hover a:visited,
.ui-state-focus a,
.ui-state-focus a:hover,
.ui-state-focus a:link,
.ui-state-focus a:visited,
a.ui-button:hover,
a.ui-button:focus {
	color: #2b2b2b;
	text-decoration: none;
}

.ui-visual-focus {
	box-shadow: 0 0 3px 1px rgb(94, 158, 214);
}
.ui-state-active,
.ui-widget-content .ui-state-active,
.ui-widget-header .ui-state-active,
a.ui-button:active,
.ui-button:active,
.ui-button.ui-state-active:hover {
	border: 1px solid #003eff;
	background: #007fff;
	font-weight: normal;
	color: #ffffff;
}
.ui-icon-background,
.ui-state-active .ui-icon-background {
	border: #003eff;
	background-color: #ffffff;
}
.ui-state-active a,
.ui-state-active a:link,
.ui-state-active a:visited {
	color: #ffffff;
	text-decoration: none;
}


.ui-state-highlight,
.ui-widget-content .ui-state-highlight,
.ui-widget-header .ui-state-highlight {
	border: 1px solid #dad55e;
	background: #fffa90;
	color: #777620;
}
.ui-state-checked {
	border: 1px solid #dad55e;
	background: #fffa90;
}
.ui-state-highlight a,
.ui-widget-content .ui-state-highlight a,
.ui-widget-header .ui-state-highlight a {
	color: #777620;
}
.ui-state-error,
.ui-widget-content .ui-state-error,
.ui-widget-header .ui-state-error {
	border: 1px solid #f1a899;
	background: #fddfdf;
	color: #5f3f3f;
}
.ui-state-error a,
.ui-widget-content .ui-state-error a,
.ui-widget-header .ui-state-error a {
	color: #5f3f3f;
}
.ui-state-error-text,
.ui-widget-content .ui-state-error-text,
.ui-widget-header .ui-state-error-text {
	color: #5f3f3f;
}
.ui-priority-primary,
.ui-widget-content .ui-priority-primary,
.ui-widget-header .ui-priority-primary {
	font-weight: bold;
}
.ui-priority-secondary,
.ui-widget-content .ui-priority-secondary,
.ui-widget-header .ui-priority-secondary {
	opacity: .7;
	filter:Alpha(Opacity=70); 
	font-weight: normal;
}
.ui-state-disabled,
.ui-widget-content .ui-state-disabled,
.ui-widget-header .ui-state-disabled {
	opacity: .35;
	filter:Alpha(Opacity=35); 
	background-image: none;
}
.ui-state-disabled .ui-icon {
	filter:Alpha(Opacity=35); 
}




.ui-icon {
	width: 16px;
	height: 16px;
}
.ui-icon,
.ui-widget-content .ui-icon {
	background-image: url("images/ui-icons_444444_256x240.png");
}
.ui-widget-header .ui-icon {
	background-image: url("images/ui-icons_444444_256x240.png");
}
.ui-state-hover .ui-icon,
.ui-state-focus .ui-icon,
.ui-button:hover .ui-icon,
.ui-button:focus .ui-icon {
	background-image: url("images/ui-icons_555555_256x240.png");
}
.ui-state-active .ui-icon,
.ui-button:active .ui-icon {
	background-image: url("images/ui-icons_ffffff_256x240.png");
}
.ui-state-highlight .ui-icon,
.ui-button .ui-state-highlight.ui-icon {
	background-image: url("images/ui-icons_777620_256x240.png");
}
.ui-state-error .ui-icon,
.ui-state-error-text .ui-icon {
	background-image: url("images/ui-icons_cc0000_256x240.png");
}
.ui-button .ui-icon {
	background-image: url("images/ui-icons_777777_256x240.png");
}


.ui-icon-blank { background-position: 16px 16px; }
.ui-icon-caret-1-n { background-position: 0 0; }
.ui-icon-caret-1-ne { background-position: -16px 0; }
.ui-icon-caret-1-e { background-position: -32px 0; }
.ui-icon-caret-1-se { background-position: -48px 0; }
.ui-icon-caret-1-s { background-position: -65px 0; }
.ui-icon-caret-1-sw { background-position: -80px 0; }
.ui-icon-caret-1-w { background-position: -96px 0; }
.ui-icon-caret-1-nw { background-position: -112px 0; }
.ui-icon-caret-2-n-s { background-position: -128px 0; }
.ui-icon-caret-2-e-w { background-position: -144px 0; }
.ui-icon-triangle-1-n { background-position: 0 -16px; }
.ui-icon-triangle-1-ne { background-position: -16px -16px; }
.ui-icon-triangle-1-e { background-position: -32px -16px; }
.ui-icon-triangle-1-se { background-position: -48px -16px; }
.ui-icon-triangle-1-s { background-position: -65px -16px; }
.ui-icon-triangle-1-sw { background-position: -80px -16px; }
.ui-icon-triangle-1-w { background-position: -96px -16px; }
.ui-icon-triangle-1-nw { background-position: -112px -16px; }
.ui-icon-triangle-2-n-s { background-position: -128px -16px; }
.ui-icon-triangle-2-e-w { background-position: -144px -16px; }
.ui-icon-arrow-1-n { background-position: 0 -32px; }
.ui-icon-arrow-1-ne { background-position: -16px -32px; }
.ui-icon-arrow-1-e { background-position: -32px -32px; }
.ui-icon-arrow-1-se { background-position: -48px -32px; }
.ui-icon-arrow-1-s { background-position: -65px -32px; }
.ui-icon-arrow-1-sw { background-position: -80px -32px; }
.ui-icon-arrow-1-w { background-position: -96px -32px; }
.ui-icon-arrow-1-nw { background-position: -112px -32px; }
.ui-icon-arrow-2-n-s { background-position: -128px -32px; }
.ui-icon-arrow-2-ne-sw { background-position: -144px -32px; }
.ui-icon-arrow-2-e-w { background-position: -160px -32px; }
.ui-icon-arrow-2-se-nw { background-position: -176px -32px; }
.ui-icon-arrowstop-1-n { background-position: -192px -32px; }
.ui-icon-arrowstop-1-e { background-position: -208px -32px; }
.ui-icon-arrowstop-1-s { background-position: -224px -32px; }
.ui-icon-arrowstop-1-w { background-position: -240px -32px; }
.ui-icon-arrowthick-1-n { background-position: 1px -48px; }
.ui-icon-arrowthick-1-ne { background-position: -16px -48px; }
.ui-icon-arrowthick-1-e { background-position: -32px -48px; }
.ui-icon-arrowthick-1-se { background-position: -48px -48px; }
.ui-icon-arrowthick-1-s { background-position: -64px -48px; }
.ui-icon-arrowthick-1-sw { background-position: -80px -48px; }
.ui-icon-arrowthick-1-w { background-position: -96px -48px; }
.ui-icon-arrowthick-1-nw { background-position: -112px -48px; }
.ui-icon-arrowthick-2-n-s { background-position: -128px -48px; }
.ui-icon-arrowthick-2-ne-sw { background-position: -144px -48px; }
.ui-icon-arrowthick-2-e-w { background-position: -160px -48px; }
.ui-icon-arrowthick-2-se-nw { background-position: -176px -48px; }
.ui-icon-arrowthickstop-1-n { background-position: -192px -48px; }
.ui-icon-arrowthickstop-1-e { background-position: -208px -48px; }
.ui-icon-arrowthickstop-1-s { background-position: -224px -48px; }
.ui-icon-arrowthickstop-1-w { background-position: -240px -48px; }
.ui-icon-arrowreturnthick-1-w { background-position: 0 -64px; }
.ui-icon-arrowreturnthick-1-n { background-position: -16px -64px; }
.ui-icon-arrowreturnthick-1-e { background-position: -32px -64px; }
.ui-icon-arrowreturnthick-1-s { background-position: -48px -64px; }
.ui-icon-arrowreturn-1-w { background-position: -64px -64px; }
.ui-icon-arrowreturn-1-n { background-position: -80px -64px; }
.ui-icon-arrowreturn-1-e { background-position: -96px -64px; }
.ui-icon-arrowreturn-1-s { background-position: -112px -64px; }
.ui-icon-arrowrefresh-1-w { background-position: -128px -64px; }
.ui-icon-arrowrefresh-1-n { background-position: -144px -64px; }
.ui-icon-arrowrefresh-1-e { background-position: -160px -64px; }
.ui-icon-arrowrefresh-1-s { background-position: -176px -64px; }
.ui-icon-arrow-4 { background-position: 0 -80px; }
.ui-icon-arrow-4-diag { background-position: -16px -80px; }
.ui-icon-extlink { background-position: -32px -80px; }
.ui-icon-newwin { background-position: -48px -80px; }
.ui-icon-refresh { background-position: -64px -80px; }
.ui-icon-shuffle { background-position: -80px -80px; }
.ui-icon-transfer-e-w { background-position: -96px -80px; }
.ui-icon-transferthick-e-w { background-position: -112px -80px; }
.ui-icon-folder-collapsed { background-position: 0 -96px; }
.ui-icon-folder-open { background-position: -16px -96px; }
.ui-icon-document { background-position: -32px -96px; }
.ui-icon-document-b { background-position: -48px -96px; }
.ui-icon-note { background-position: -64px -96px; }
.ui-icon-mail-closed { background-position: -80px -96px; }
.ui-icon-mail-open { background-position: -96px -96px; }
.ui-icon-suitcase { background-position: -112px -96px; }
.ui-icon-comment { background-position: -128px -96px; }
.ui-icon-person { background-position: -144px -96px; }
.ui-icon-print { background-position: -160px -96px; }
.ui-icon-trash { background-position: -176px -96px; }
.ui-icon-locked { background-position: -192px -96px; }
.ui-icon-unlocked { background-position: -208px -96px; }
.ui-icon-bookmark { background-position: -224px -96px; }
.ui-icon-tag { background-position: -240px -96px; }
.ui-icon-home { background-position: 0 -112px; }
.ui-icon-flag { background-position: -16px -112px; }
.ui-icon-calendar { background-position: -32px -112px; }
.ui-icon-cart { background-position: -48px -112px; }
.ui-icon-pencil { background-position: -64px -112px; }
.ui-icon-clock { background-position: -80px -112px; }
.ui-icon-disk { background-position: -96px -112px; }
.ui-icon-calculator { background-position: -112px -112px; }
.ui-icon-zoomin { background-position: -128px -112px; }
.ui-icon-zoomout { background-position: -144px -112px; }
.ui-icon-search { background-position: -160px -112px; }
.ui-icon-wrench { background-position: -176px -112px; }
.ui-icon-gear { background-position: -192px -112px; }
.ui-icon-heart { background-position: -208px -112px; }
.ui-icon-star { background-position: -224px -112px; }
.ui-icon-link { background-position: -240px -112px; }
.ui-icon-cancel { background-position: 0 -128px; }
.ui-icon-plus { background-position: -16px -128px; }
.ui-icon-plusthick { background-position: -32px -128px; }
.ui-icon-minus { background-position: -48px -128px; }
.ui-icon-minusthick { background-position: -64px -128px; }
.ui-icon-close { background-position: -80px -128px; }
.ui-icon-closethick { background-position: -96px -128px; }
.ui-icon-key { background-position: -112px -128px; }
.ui-icon-lightbulb { background-position: -128px -128px; }
.ui-icon-scissors { background-position: -144px -128px; }
.ui-icon-clipboard { background-position: -160px -128px; }
.ui-icon-copy { background-position: -176px -128px; }
.ui-icon-contact { background-position: -192px -128px; }
.ui-icon-image { background-position: -208px -128px; }
.ui-icon-video { background-position: -224px -128px; }
.ui-icon-script { background-position: -240px -128px; }
.ui-icon-alert { background-position: 0 -144px; }
.ui-icon-info { background-position: -16px -144px; }
.ui-icon-notice { background-position: -32px -144px; }
.ui-icon-help { background-position: -48px -144px; }
.ui-icon-check { background-position: -64px -144px; }
.ui-icon-bullet { background-position: -80px -144px; }
.ui-icon-radio-on { background-position: -96px -144px; }
.ui-icon-radio-off { background-position: -112px -144px; }
.ui-icon-pin-w { background-position: -128px -144px; }
.ui-icon-pin-s { background-position: -144px -144px; }
.ui-icon-play { background-position: 0 -160px; }
.ui-icon-pause { background-position: -16px -160px; }
.ui-icon-seek-next { background-position: -32px -160px; }
.ui-icon-seek-prev { background-position: -48px -160px; }
.ui-icon-seek-end { background-position: -64px -160px; }
.ui-icon-seek-start { background-position: -80px -160px; }

.ui-icon-seek-first { background-position: -80px -160px; }
.ui-icon-stop { background-position: -96px -160px; }
.ui-icon-eject { background-position: -112px -160px; }
.ui-icon-volume-off { background-position: -128px -160px; }
.ui-icon-volume-on { background-position: -144px -160px; }
.ui-icon-power { background-position: 0 -176px; }
.ui-icon-signal-diag { background-position: -16px -176px; }
.ui-icon-signal { background-position: -32px -176px; }
.ui-icon-battery-0 { background-position: -48px -176px; }
.ui-icon-battery-1 { background-position: -64px -176px; }
.ui-icon-battery-2 { background-position: -80px -176px; }
.ui-icon-battery-3 { background-position: -96px -176px; }
.ui-icon-circle-plus { background-position: 0 -192px; }
.ui-icon-circle-minus { background-position: -16px -192px; }
.ui-icon-circle-close { background-position: -32px -192px; }
.ui-icon-circle-triangle-e { background-position: -48px -192px; }
.ui-icon-circle-triangle-s { background-position: -64px -192px; }
.ui-icon-circle-triangle-w { background-position: -80px -192px; }
.ui-icon-circle-triangle-n { background-position: -96px -192px; }
.ui-icon-circle-arrow-e { background-position: -112px -192px; }
.ui-icon-circle-arrow-s { background-position: -128px -192px; }
.ui-icon-circle-arrow-w { background-position: -144px -192px; }
.ui-icon-circle-arrow-n { background-position: -160px -192px; }
.ui-icon-circle-zoomin { background-position: -176px -192px; }
.ui-icon-circle-zoomout { background-position: -192px -192px; }
.ui-icon-circle-check { background-position: -208px -192px; }
.ui-icon-circlesmall-plus { background-position: 0 -208px; }
.ui-icon-circlesmall-minus { background-position: -16px -208px; }
.ui-icon-circlesmall-close { background-position: -32px -208px; }
.ui-icon-squaresmall-plus { background-position: -48px -208px; }
.ui-icon-squaresmall-minus { background-position: -64px -208px; }
.ui-icon-squaresmall-close { background-position: -80px -208px; }
.ui-icon-grip-dotted-vertical { background-position: 0 -224px; }
.ui-icon-grip-dotted-horizontal { background-position: -16px -224px; }
.ui-icon-grip-solid-vertical { background-position: -32px -224px; }
.ui-icon-grip-solid-horizontal { background-position: -48px -224px; }
.ui-icon-gripsmall-diagonal-se { background-position: -64px -224px; }
.ui-icon-grip-diagonal-se { background-position: -80px -224px; }





.ui-corner-all,
.ui-corner-top,
.ui-corner-left,
.ui-corner-tl {
	border-top-left-radius: 3px;
}
.ui-corner-all,
.ui-corner-top,
.ui-corner-right,
.ui-corner-tr {
	border-top-right-radius: 3px;
}
.ui-corner-all,
.ui-corner-bottom,
.ui-corner-left,
.ui-corner-bl {
	border-bottom-left-radius: 3px;
}
.ui-corner-all,
.ui-corner-bottom,
.ui-corner-right,
.ui-corner-br {
	border-bottom-right-radius: 3px;
}


.ui-widget-overlay {
	background: #aaaaaa;
	opacity: .3;
	filter: Alpha(Opacity=30); 
}
.ui-widget-shadow {
	-webkit-box-shadow: 0px 0px 5px #666666;
	box-shadow: 0px 0px 5px #666666;
} 
</style>
<script src='js/jquery-1.12.4.js'></script>
<script src='js/jquery-ui.js'></script>

<script>
$( function() {
	$( '#tabs-collect-consensus-heatmap' ).tabs();
} );
</script>
<div id='tabs-collect-consensus-heatmap'>
<ul>
<li><a href='#tab-collect-consensus-heatmap-1'>k = 2</a></li>
<li><a href='#tab-collect-consensus-heatmap-2'>k = 3</a></li>
<li><a href='#tab-collect-consensus-heatmap-3'>k = 4</a></li>
<li><a href='#tab-collect-consensus-heatmap-4'>k = 5</a></li>
<li><a href='#tab-collect-consensus-heatmap-5'>k = 6</a></li>
</ul>
<div id='tab-collect-consensus-heatmap-1'>
<pre><code class="language-r">collect_plots(res_list, k = 2, fun = consensus_heatmap, cores = 1)
</code></pre>
<p><img src="figure_cola/tab-collect-consensus-heatmap-1-1.png" alt="plot of chunk tab-collect-consensus-heatmap-1" /></p>

</div>
<div id='tab-collect-consensus-heatmap-2'>
<pre><code class="language-r">collect_plots(res_list, k = 3, fun = consensus_heatmap, cores = 1)
</code></pre>
<p><img src="figure_cola/tab-collect-consensus-heatmap-2-1.png" alt="plot of chunk tab-collect-consensus-heatmap-2" /></p>

</div>
<div id='tab-collect-consensus-heatmap-3'>
<pre><code class="language-r">collect_plots(res_list, k = 4, fun = consensus_heatmap, cores = 1)
</code></pre>
<p><img src="figure_cola/tab-collect-consensus-heatmap-3-1.png" alt="plot of chunk tab-collect-consensus-heatmap-3" /></p>

</div>
<div id='tab-collect-consensus-heatmap-4'>
<pre><code class="language-r">collect_plots(res_list, k = 5, fun = consensus_heatmap, cores = 1)
</code></pre>
<p><img src="figure_cola/tab-collect-consensus-heatmap-4-1.png" alt="plot of chunk tab-collect-consensus-heatmap-4" /></p>

</div>
<div id='tab-collect-consensus-heatmap-5'>
<pre><code class="language-r">collect_plots(res_list, k = 6, fun = consensus_heatmap, cores = 1)
</code></pre>
<p><img src="figure_cola/tab-collect-consensus-heatmap-5-1.png" alt="plot of chunk tab-collect-consensus-heatmap-5" /></p>

</div>
</div>



### Membership heatmap

Membership heatmaps for all methods. ([What is a membership heatmap?](https://jokergoo.github.io/cola_vignettes/cola.html#toc_12))


<script>
$( function() {
	$( '#tabs-collect-membership-heatmap' ).tabs();
} );
</script>
<div id='tabs-collect-membership-heatmap'>
<ul>
<li><a href='#tab-collect-membership-heatmap-1'>k = 2</a></li>
<li><a href='#tab-collect-membership-heatmap-2'>k = 3</a></li>
<li><a href='#tab-collect-membership-heatmap-3'>k = 4</a></li>
<li><a href='#tab-collect-membership-heatmap-4'>k = 5</a></li>
<li><a href='#tab-collect-membership-heatmap-5'>k = 6</a></li>
</ul>
<div id='tab-collect-membership-heatmap-1'>
<pre><code class="language-r">collect_plots(res_list, k = 2, fun = membership_heatmap, cores = 1)
</code></pre>
<p><img src="figure_cola/tab-collect-membership-heatmap-1-1.png" alt="plot of chunk tab-collect-membership-heatmap-1" /></p>

</div>
<div id='tab-collect-membership-heatmap-2'>
<pre><code class="language-r">collect_plots(res_list, k = 3, fun = membership_heatmap, cores = 1)
</code></pre>
<p><img src="figure_cola/tab-collect-membership-heatmap-2-1.png" alt="plot of chunk tab-collect-membership-heatmap-2" /></p>

</div>
<div id='tab-collect-membership-heatmap-3'>
<pre><code class="language-r">collect_plots(res_list, k = 4, fun = membership_heatmap, cores = 1)
</code></pre>
<p><img src="figure_cola/tab-collect-membership-heatmap-3-1.png" alt="plot of chunk tab-collect-membership-heatmap-3" /></p>

</div>
<div id='tab-collect-membership-heatmap-4'>
<pre><code class="language-r">collect_plots(res_list, k = 5, fun = membership_heatmap, cores = 1)
</code></pre>
<p><img src="figure_cola/tab-collect-membership-heatmap-4-1.png" alt="plot of chunk tab-collect-membership-heatmap-4" /></p>

</div>
<div id='tab-collect-membership-heatmap-5'>
<pre><code class="language-r">collect_plots(res_list, k = 6, fun = membership_heatmap, cores = 1)
</code></pre>
<p><img src="figure_cola/tab-collect-membership-heatmap-5-1.png" alt="plot of chunk tab-collect-membership-heatmap-5" /></p>

</div>
</div>



### Signature heatmap

Signature heatmaps for all methods. ([What is a signature heatmap?](https://jokergoo.github.io/cola_vignettes/cola.html#toc_21))


Note in following heatmaps, rows are scaled.



<script>
$( function() {
	$( '#tabs-collect-get-signatures' ).tabs();
} );
</script>
<div id='tabs-collect-get-signatures'>
<ul>
<li><a href='#tab-collect-get-signatures-1'>k = 2</a></li>
<li><a href='#tab-collect-get-signatures-2'>k = 3</a></li>
<li><a href='#tab-collect-get-signatures-3'>k = 4</a></li>
<li><a href='#tab-collect-get-signatures-4'>k = 5</a></li>
<li><a href='#tab-collect-get-signatures-5'>k = 6</a></li>
</ul>
<div id='tab-collect-get-signatures-1'>
<pre><code class="language-r">collect_plots(res_list, k = 2, fun = get_signatures, cores = 1)
</code></pre>
<p><img src="figure_cola/tab-collect-get-signatures-1-1.png" alt="plot of chunk tab-collect-get-signatures-1" /></p>

</div>
<div id='tab-collect-get-signatures-2'>
<pre><code class="language-r">collect_plots(res_list, k = 3, fun = get_signatures, cores = 1)
</code></pre>
<p><img src="figure_cola/tab-collect-get-signatures-2-1.png" alt="plot of chunk tab-collect-get-signatures-2" /></p>

</div>
<div id='tab-collect-get-signatures-3'>
<pre><code class="language-r">collect_plots(res_list, k = 4, fun = get_signatures, cores = 1)
</code></pre>
<p><img src="figure_cola/tab-collect-get-signatures-3-1.png" alt="plot of chunk tab-collect-get-signatures-3" /></p>

</div>
<div id='tab-collect-get-signatures-4'>
<pre><code class="language-r">collect_plots(res_list, k = 5, fun = get_signatures, cores = 1)
</code></pre>
<p><img src="figure_cola/tab-collect-get-signatures-4-1.png" alt="plot of chunk tab-collect-get-signatures-4" /></p>

</div>
<div id='tab-collect-get-signatures-5'>
<pre><code class="language-r">collect_plots(res_list, k = 6, fun = get_signatures, cores = 1)
</code></pre>
<p><img src="figure_cola/tab-collect-get-signatures-5-1.png" alt="plot of chunk tab-collect-get-signatures-5" /></p>

</div>
</div>



### Statistics table

The statistics used for measuring the stability of consensus partitioning.
([How are they
defined?](https://jokergoo.github.io/cola_vignettes/cola.html#toc_13))


<script>
$( function() {
	$( '#tabs-get-stats-from-consensus-partition-list' ).tabs();
} );
</script>
<div id='tabs-get-stats-from-consensus-partition-list'>
<ul>
<li><a href='#tab-get-stats-from-consensus-partition-list-1'>k = 2</a></li>
<li><a href='#tab-get-stats-from-consensus-partition-list-2'>k = 3</a></li>
<li><a href='#tab-get-stats-from-consensus-partition-list-3'>k = 4</a></li>
<li><a href='#tab-get-stats-from-consensus-partition-list-4'>k = 5</a></li>
<li><a href='#tab-get-stats-from-consensus-partition-list-5'>k = 6</a></li>
</ul>
<div id='tab-get-stats-from-consensus-partition-list-1'>
<pre><code class="language-r">get_stats(res_list, k = 2)
</code></pre>
<pre><code>#&gt;             k 1-PAC mean_silhouette concordance area_increased  Rand Jaccard
#&gt; SD:skmeans  2 0.857           0.922       0.966          0.508 0.492   0.492
#&gt; MAD:skmeans 2 0.999           0.959       0.983          0.506 0.494   0.494
#&gt; CV:skmeans  2 0.549           0.890       0.934          0.470 0.528   0.528
#&gt; ATC:skmeans 2 0.863           0.915       0.965          0.500 0.497   0.497
#&gt; SD:mclust   2 0.476           0.855       0.907          0.465 0.494   0.494
#&gt; MAD:mclust  2 0.659           0.925       0.940          0.474 0.506   0.506
#&gt; CV:mclust   2 0.583           0.882       0.933          0.331 0.741   0.741
#&gt; ATC:mclust  2 0.296           0.352       0.603          0.363 0.492   0.492
#&gt; SD:hclust   2 0.257           0.737       0.857          0.476 0.512   0.512
#&gt; MAD:hclust  2 0.176           0.671       0.807          0.447 0.494   0.494
#&gt; CV:hclust   2 0.354           0.653       0.843          0.339 0.675   0.675
#&gt; ATC:hclust  2 0.617           0.890       0.937          0.465 0.519   0.519
#&gt; SD:kmeans   2 0.737           0.894       0.953          0.505 0.492   0.492
#&gt; MAD:kmeans  2 0.999           0.940       0.976          0.500 0.506   0.506
#&gt; CV:kmeans   2 0.130           0.650       0.793          0.412 0.573   0.573
#&gt; ATC:kmeans  2 1.000           0.982       0.993          0.467 0.537   0.537
#&gt; SD:pam      2 0.365           0.694       0.866          0.493 0.494   0.494
#&gt; MAD:pam     2 0.930           0.950       0.977          0.507 0.492   0.492
#&gt; CV:pam      2 0.335           0.828       0.892          0.364 0.636   0.636
#&gt; ATC:pam     2 0.930           0.945       0.978          0.448 0.560   0.560
</code></pre>

</div>
<div id='tab-get-stats-from-consensus-partition-list-2'>
<pre><code class="language-r">get_stats(res_list, k = 3)
</code></pre>
<pre><code>#&gt;             k 1-PAC mean_silhouette concordance area_increased  Rand Jaccard
#&gt; SD:skmeans  3 0.632           0.783       0.887          0.310 0.780   0.578
#&gt; MAD:skmeans 3 0.953           0.940       0.975          0.318 0.796   0.607
#&gt; CV:skmeans  3 0.595           0.821       0.888          0.427 0.723   0.511
#&gt; ATC:skmeans 3 0.816           0.899       0.940          0.310 0.795   0.611
#&gt; SD:mclust   3 0.268           0.672       0.784          0.301 0.742   0.528
#&gt; MAD:mclust  3 1.000           0.951       0.981          0.396 0.792   0.605
#&gt; CV:mclust   3 0.359           0.602       0.806          0.866 0.640   0.513
#&gt; ATC:mclust  3 0.302           0.422       0.739          0.603 0.618   0.372
#&gt; SD:hclust   3 0.263           0.617       0.773          0.335 0.845   0.696
#&gt; MAD:hclust  3 0.429           0.700       0.847          0.439 0.788   0.595
#&gt; CV:hclust   3 0.288           0.639       0.833          0.509 0.821   0.741
#&gt; ATC:hclust  3 0.524           0.300       0.645          0.382 0.942   0.889
#&gt; SD:kmeans   3 0.519           0.691       0.832          0.315 0.718   0.486
#&gt; MAD:kmeans  3 0.737           0.914       0.922          0.317 0.792   0.605
#&gt; CV:kmeans   3 0.241           0.297       0.593          0.494 0.726   0.545
#&gt; ATC:kmeans  3 0.780           0.840       0.928          0.423 0.702   0.488
#&gt; SD:pam      3 0.377           0.618       0.806          0.362 0.695   0.458
#&gt; MAD:pam     3 0.497           0.623       0.808          0.309 0.811   0.632
#&gt; CV:pam      3 0.386           0.532       0.818          0.722 0.611   0.451
#&gt; ATC:pam     3 0.902           0.952       0.978          0.464 0.651   0.444
</code></pre>

</div>
<div id='tab-get-stats-from-consensus-partition-list-3'>
<pre><code class="language-r">get_stats(res_list, k = 4)
</code></pre>
<pre><code>#&gt;             k 1-PAC mean_silhouette concordance area_increased  Rand Jaccard
#&gt; SD:skmeans  4 0.631           0.741       0.856          0.114 0.823   0.540
#&gt; MAD:skmeans 4 0.675           0.706       0.839          0.108 0.950   0.853
#&gt; CV:skmeans  4 0.577           0.433       0.706          0.124 0.730   0.356
#&gt; ATC:skmeans 4 0.967           0.926       0.971          0.110 0.902   0.726
#&gt; SD:mclust   4 0.386           0.536       0.739          0.165 0.864   0.643
#&gt; MAD:mclust  4 0.737           0.701       0.775          0.101 0.890   0.693
#&gt; CV:mclust   4 0.385           0.259       0.652          0.179 0.688   0.353
#&gt; ATC:mclust  4 0.843           0.849       0.919          0.271 0.750   0.420
#&gt; SD:hclust   4 0.434           0.490       0.727          0.127 0.942   0.847
#&gt; MAD:hclust  4 0.506           0.578       0.782          0.106 0.947   0.847
#&gt; CV:hclust   4 0.236           0.290       0.490          0.223 0.575   0.308
#&gt; ATC:hclust  4 0.581           0.701       0.796          0.119 0.692   0.392
#&gt; SD:kmeans   4 0.590           0.645       0.801          0.122 0.866   0.621
#&gt; MAD:kmeans  4 0.672           0.799       0.815          0.117 1.000   1.000
#&gt; CV:kmeans   4 0.378           0.540       0.725          0.134 0.697   0.356
#&gt; ATC:kmeans  4 0.701           0.609       0.837          0.120 0.840   0.571
#&gt; SD:pam      4 0.410           0.463       0.705          0.111 0.922   0.778
#&gt; MAD:pam     4 0.467           0.398       0.673          0.115 0.828   0.572
#&gt; CV:pam      4 0.501           0.624       0.828          0.153 0.845   0.630
#&gt; ATC:pam     4 0.801           0.843       0.909          0.120 0.927   0.790
</code></pre>

</div>
<div id='tab-get-stats-from-consensus-partition-list-4'>
<pre><code class="language-r">get_stats(res_list, k = 5)
</code></pre>
<pre><code>#&gt;             k 1-PAC mean_silhouette concordance area_increased  Rand Jaccard
#&gt; SD:skmeans  5 0.625           0.570       0.776         0.0655 0.967   0.879
#&gt; MAD:skmeans 5 0.615           0.510       0.748         0.0682 0.931   0.769
#&gt; CV:skmeans  5 0.663           0.670       0.807         0.0635 0.854   0.498
#&gt; ATC:skmeans 5 0.899           0.822       0.928         0.0523 0.947   0.812
#&gt; SD:mclust   5 0.614           0.645       0.796         0.1172 0.819   0.457
#&gt; MAD:mclust  5 0.651           0.581       0.810         0.0705 0.932   0.759
#&gt; CV:mclust   5 0.484           0.528       0.727         0.0587 0.779   0.377
#&gt; ATC:mclust  5 0.756           0.722       0.869         0.0632 0.836   0.481
#&gt; SD:hclust   5 0.510           0.404       0.695         0.0710 0.871   0.639
#&gt; MAD:hclust  5 0.517           0.439       0.713         0.0645 0.960   0.871
#&gt; CV:hclust   5 0.445           0.326       0.665         0.1116 0.668   0.292
#&gt; ATC:hclust  5 0.726           0.829       0.867         0.0790 0.922   0.703
#&gt; SD:kmeans   5 0.635           0.594       0.657         0.0637 0.892   0.646
#&gt; MAD:kmeans  5 0.641           0.546       0.745         0.0695 0.888   0.676
#&gt; CV:kmeans   5 0.452           0.431       0.619         0.0895 0.870   0.594
#&gt; ATC:kmeans  5 0.850           0.885       0.922         0.0702 0.901   0.643
#&gt; SD:pam      5 0.486           0.475       0.700         0.0663 0.849   0.534
#&gt; MAD:pam     5 0.511           0.448       0.622         0.0758 0.804   0.419
#&gt; CV:pam      5 0.590           0.627       0.817         0.0919 0.810   0.450
#&gt; ATC:pam     5 0.863           0.901       0.940         0.0740 0.906   0.676
</code></pre>

</div>
<div id='tab-get-stats-from-consensus-partition-list-5'>
<pre><code class="language-r">get_stats(res_list, k = 6)
</code></pre>
<pre><code>#&gt;             k 1-PAC mean_silhouette concordance area_increased  Rand Jaccard
#&gt; SD:skmeans  6 0.612           0.411       0.690         0.0416 0.900   0.623
#&gt; MAD:skmeans 6 0.607           0.409       0.592         0.0441 0.964   0.855
#&gt; CV:skmeans  6 0.670           0.570       0.721         0.0407 0.926   0.655
#&gt; ATC:skmeans 6 0.902           0.792       0.911         0.0304 0.952   0.807
#&gt; SD:mclust   6 0.627           0.505       0.742         0.0280 0.923   0.673
#&gt; MAD:mclust  6 0.680           0.652       0.789         0.0424 0.955   0.804
#&gt; CV:mclust   6 0.619           0.508       0.651         0.0636 0.966   0.846
#&gt; ATC:mclust  6 0.877           0.722       0.849         0.0496 0.907   0.608
#&gt; SD:hclust   6 0.541           0.497       0.679         0.0433 0.911   0.671
#&gt; MAD:hclust  6 0.568           0.412       0.695         0.0520 0.911   0.691
#&gt; CV:hclust   6 0.477           0.494       0.631         0.0767 0.847   0.569
#&gt; ATC:hclust  6 0.733           0.775       0.840         0.0235 0.992   0.958
#&gt; SD:kmeans   6 0.660           0.537       0.687         0.0439 0.886   0.571
#&gt; MAD:kmeans  6 0.632           0.408       0.643         0.0431 0.905   0.651
#&gt; CV:kmeans   6 0.566           0.381       0.645         0.0594 0.956   0.820
#&gt; ATC:kmeans  6 0.882           0.622       0.846         0.0329 0.951   0.771
#&gt; SD:pam      6 0.558           0.462       0.705         0.0444 0.940   0.717
#&gt; MAD:pam     6 0.583           0.445       0.655         0.0418 0.958   0.802
#&gt; CV:pam      6 0.687           0.454       0.684         0.0433 0.798   0.322
#&gt; ATC:pam     6 0.817           0.761       0.873         0.0336 0.977   0.892
</code></pre>

</div>
</div>

Following heatmap plots the partition for each combination of methods and the
lightness correspond to the silhouette scores for samples in each method. On
top the consensus subgroup is inferred from all methods by taking the mean
silhouette scores as weight.


<script>
$( function() {
	$( '#tabs-collect-stats-from-consensus-partition-list' ).tabs();
} );
</script>
<div id='tabs-collect-stats-from-consensus-partition-list'>
<ul>
<li><a href='#tab-collect-stats-from-consensus-partition-list-1'>k = 2</a></li>
<li><a href='#tab-collect-stats-from-consensus-partition-list-2'>k = 3</a></li>
<li><a href='#tab-collect-stats-from-consensus-partition-list-3'>k = 4</a></li>
<li><a href='#tab-collect-stats-from-consensus-partition-list-4'>k = 5</a></li>
<li><a href='#tab-collect-stats-from-consensus-partition-list-5'>k = 6</a></li>
</ul>
<div id='tab-collect-stats-from-consensus-partition-list-1'>
<pre><code class="language-r">collect_stats(res_list, k = 2)
</code></pre>
<p><img src="figure_cola/tab-collect-stats-from-consensus-partition-list-1-1.png" alt="plot of chunk tab-collect-stats-from-consensus-partition-list-1" /></p>

</div>
<div id='tab-collect-stats-from-consensus-partition-list-2'>
<pre><code class="language-r">collect_stats(res_list, k = 3)
</code></pre>
<p><img src="figure_cola/tab-collect-stats-from-consensus-partition-list-2-1.png" alt="plot of chunk tab-collect-stats-from-consensus-partition-list-2" /></p>

</div>
<div id='tab-collect-stats-from-consensus-partition-list-3'>
<pre><code class="language-r">collect_stats(res_list, k = 4)
</code></pre>
<p><img src="figure_cola/tab-collect-stats-from-consensus-partition-list-3-1.png" alt="plot of chunk tab-collect-stats-from-consensus-partition-list-3" /></p>

</div>
<div id='tab-collect-stats-from-consensus-partition-list-4'>
<pre><code class="language-r">collect_stats(res_list, k = 5)
</code></pre>
<p><img src="figure_cola/tab-collect-stats-from-consensus-partition-list-4-1.png" alt="plot of chunk tab-collect-stats-from-consensus-partition-list-4" /></p>

</div>
<div id='tab-collect-stats-from-consensus-partition-list-5'>
<pre><code class="language-r">collect_stats(res_list, k = 6)
</code></pre>
<p><img src="figure_cola/tab-collect-stats-from-consensus-partition-list-5-1.png" alt="plot of chunk tab-collect-stats-from-consensus-partition-list-5" /></p>

</div>
</div>

### Partition from all methods



Collect partitions from all methods:


<script>
$( function() {
	$( '#tabs-collect-classes-from-consensus-partition-list' ).tabs();
} );
</script>
<div id='tabs-collect-classes-from-consensus-partition-list'>
<ul>
<li><a href='#tab-collect-classes-from-consensus-partition-list-1'>k = 2</a></li>
<li><a href='#tab-collect-classes-from-consensus-partition-list-2'>k = 3</a></li>
<li><a href='#tab-collect-classes-from-consensus-partition-list-3'>k = 4</a></li>
<li><a href='#tab-collect-classes-from-consensus-partition-list-4'>k = 5</a></li>
<li><a href='#tab-collect-classes-from-consensus-partition-list-5'>k = 6</a></li>
</ul>
<div id='tab-collect-classes-from-consensus-partition-list-1'>
<pre><code class="language-r">collect_classes(res_list, k = 2)
</code></pre>
<p><img src="figure_cola/tab-collect-classes-from-consensus-partition-list-1-1.png" alt="plot of chunk tab-collect-classes-from-consensus-partition-list-1" /></p>

</div>
<div id='tab-collect-classes-from-consensus-partition-list-2'>
<pre><code class="language-r">collect_classes(res_list, k = 3)
</code></pre>
<p><img src="figure_cola/tab-collect-classes-from-consensus-partition-list-2-1.png" alt="plot of chunk tab-collect-classes-from-consensus-partition-list-2" /></p>

</div>
<div id='tab-collect-classes-from-consensus-partition-list-3'>
<pre><code class="language-r">collect_classes(res_list, k = 4)
</code></pre>
<p><img src="figure_cola/tab-collect-classes-from-consensus-partition-list-3-1.png" alt="plot of chunk tab-collect-classes-from-consensus-partition-list-3" /></p>

</div>
<div id='tab-collect-classes-from-consensus-partition-list-4'>
<pre><code class="language-r">collect_classes(res_list, k = 5)
</code></pre>
<p><img src="figure_cola/tab-collect-classes-from-consensus-partition-list-4-1.png" alt="plot of chunk tab-collect-classes-from-consensus-partition-list-4" /></p>

</div>
<div id='tab-collect-classes-from-consensus-partition-list-5'>
<pre><code class="language-r">collect_classes(res_list, k = 6)
</code></pre>
<p><img src="figure_cola/tab-collect-classes-from-consensus-partition-list-5-1.png" alt="plot of chunk tab-collect-classes-from-consensus-partition-list-5" /></p>

</div>
</div>



### Top rows overlap


Overlap of top rows from different top-row methods:


<script>
$( function() {
	$( '#tabs-top-rows-overlap-by-euler' ).tabs();
} );
</script>
<div id='tabs-top-rows-overlap-by-euler'>
<ul>
<li><a href='#tab-top-rows-overlap-by-euler-1'>top_n = 123</a></li>
</ul>
<div id='tab-top-rows-overlap-by-euler-1'>
<pre><code class="language-r">top_rows_overlap(res_list, top_n = 123, method = &quot;euler&quot;)
</code></pre>
<p><img src="figure_cola/tab-top-rows-overlap-by-euler-1-1.png" alt="plot of chunk tab-top-rows-overlap-by-euler-1" /></p>

</div>
</div>

Also visualize the correspondance of rankings between different top-row methods:


<script>
$( function() {
	$( '#tabs-top-rows-overlap-by-correspondance' ).tabs();
} );
</script>
<div id='tabs-top-rows-overlap-by-correspondance'>
<ul>
<li><a href='#tab-top-rows-overlap-by-correspondance-1'>top_n = 123</a></li>
</ul>
<div id='tab-top-rows-overlap-by-correspondance-1'>
<pre><code class="language-r">top_rows_overlap(res_list, top_n = 123, method = &quot;correspondance&quot;)
</code></pre>
<p><img src="figure_cola/tab-top-rows-overlap-by-correspondance-1-1.png" alt="plot of chunk tab-top-rows-overlap-by-correspondance-1" /></p>

</div>
</div>


Heatmaps of the top rows:



<script>
$( function() {
	$( '#tabs-top-rows-heatmap' ).tabs();
} );
</script>
<div id='tabs-top-rows-heatmap'>
<ul>
<li><a href='#tab-top-rows-heatmap-1'>top_n = 123</a></li>
</ul>
<div id='tab-top-rows-heatmap-1'>
<pre><code class="language-r">top_rows_heatmap(res_list, top_n = 123)
</code></pre>
<p><img src="figure_cola/tab-top-rows-heatmap-1-1.png" alt="plot of chunk tab-top-rows-heatmap-1" /></p>

</div>
</div>



 
## Results for each method


---------------------------------------------------



### SD:hclust






The object with results only for a single top-value method and a single partitioning method 
can be extracted as:

``` r
res = res_list["SD", "hclust"]
# you can also extract it by
# res = res_list["SD:hclust"]
```

A summary of `res` and all the functions that can be applied to it:

``` r
res
```

```
#> A 'ConsensusPartition' object with k = 2, 3, 4, 5, 6.
#>   On a matrix with 1900 rows and 60 columns.
#>   Top rows (123) are extracted by 'SD' method.
#>   Subgroups are detected by 'hclust' method.
#>   Performed in total 250 partitions by row resampling.
#>   Best k for subgroups seems to be 2.
#> 
#> Following methods can be applied to this 'ConsensusPartition' object:
#>  [1] "cola_report"             "collect_classes"         "collect_plots"          
#>  [4] "collect_stats"           "colnames"                "compare_partitions"     
#>  [7] "compare_signatures"      "consensus_heatmap"       "dimension_reduction"    
#> [10] "functional_enrichment"   "get_anno_col"            "get_anno"               
#> [13] "get_classes"             "get_consensus"           "get_matrix"             
#> [16] "get_membership"          "get_param"               "get_signatures"         
#> [19] "get_stats"               "is_best_k"               "is_stable_k"            
#> [22] "membership_heatmap"      "ncol"                    "nrow"                   
#> [25] "plot_ecdf"               "predict_classes"         "rownames"               
#> [28] "select_partition_number" "show"                    "suggest_best_k"         
#> [31] "test_to_known_factors"   "top_rows_heatmap"
```

`collect_plots()` function collects all the plots made from `res` for all `k` (number of subgroups)
into one single page to provide an easy and fast comparison between different `k`.

``` r
collect_plots(res)
```

![plot of chunk SD-hclust-collect-plots](figure_cola/SD-hclust-collect-plots-1.png)

The plots are:

- The first row: a plot of the eCDF (empirical cumulative distribution
  function) curves of the consensus matrix for each `k` and the heatmap of
  predicted classes for each `k`.
- The second row: heatmaps of the consensus matrix for each `k`.
- The third row: heatmaps of the membership matrix for each `k`.
- The fouth row: heatmaps of the signatures for each `k`.

All the plots in panels can be made by individual functions and they are
plotted later in this section.

`select_partition_number()` produces several plots showing different
statistics for choosing "optimized" `k`. There are following statistics:

- eCDF curves of the consensus matrix for each `k`;
- 1-PAC. [The PAC score](https://en.wikipedia.org/wiki/Consensus_clustering#Over-interpretation_potential_of_consensus_clustering)
  measures the proportion of the ambiguous subgrouping.
- Mean silhouette score.
- Concordance. The mean probability of fiting the consensus subgroup labels in all
  partitions.
- Area increased. Denote $A_k$ as the area under the eCDF curve for current
  `k`, the area increased is defined as $A_k - A_{k-1}$.
- Rand index. The percent of pairs of samples that are both in a same cluster
  or both are not in a same cluster in the partition of k and k-1.
- Jaccard index. The ratio of pairs of samples are both in a same cluster in
  the partition of k and k-1 and the pairs of samples are both in a same
  cluster in the partition k or k-1.

The detailed explanations of these statistics can be found in [the _cola_
vignette](https://jokergoo.github.io/cola_vignettes/cola.html#toc_13).

Generally speaking, higher 1-PAC score, higher mean silhouette score or higher
concordance corresponds to better partition. Rand index and Jaccard index
measure how similar the current partition is compared to partition with `k-1`.
If they are too similar, we won't accept `k` is better than `k-1`.

``` r
select_partition_number(res)
```

![plot of chunk SD-hclust-select-partition-number](figure_cola/SD-hclust-select-partition-number-1.png)

The numeric values for all these statistics can be obtained by `get_stats()`.

``` r
get_stats(res)
```

```
#>   k 1-PAC mean_silhouette concordance area_increased  Rand Jaccard
#> 2 2 0.257           0.737       0.857         0.4756 0.512   0.512
#> 3 3 0.263           0.617       0.773         0.3353 0.845   0.696
#> 4 4 0.434           0.490       0.727         0.1270 0.942   0.847
#> 5 5 0.510           0.404       0.695         0.0710 0.871   0.639
#> 6 6 0.541           0.497       0.679         0.0433 0.911   0.671
```

`suggest_best_k()` suggests the best $k$ based on these statistics. The rules are as follows:

- All $k$ with Jaccard index larger than 0.95 are removed because increasing
  $k$ does not provide enough extra information. If all $k$ are removed, it is
  marked as no subgroup is detected.
- For all $k$ with 1-PAC score larger than 0.9, the maximal $k$ is taken as
  the best $k$, and other $k$ are marked as optional $k$.
- If it does not fit the second rule. The $k$ with the maximal vote of the
  highest 1-PAC score, highest mean silhouette, and highest concordance is
  taken as the best $k$.

``` r
suggest_best_k(res)
```

```
#> [1] 2
```


Following is the table of the partitions (You need to click the **show/hide
code output** link to see it). The membership matrix (columns with name `p*`)
is inferred by
[`clue::cl_consensus()`](https://www.rdocumentation.org/link/cl_consensus?package=clue)
function with the `SE` method. Basically the value in the membership matrix
represents the probability to belong to a certain group. The finall subgroup
label for an item is determined with the group with highest probability it
belongs to.

In `get_classes()` function, the entropy is calculated from the membership
matrix and the silhouette score is calculated from the consensus matrix.



<script>
$( function() {
	$( '#tabs-SD-hclust-get-classes' ).tabs();
} );
</script>
<div id='tabs-SD-hclust-get-classes'>
<ul>
<li><a href='#tab-SD-hclust-get-classes-1'>k = 2</a></li>
<li><a href='#tab-SD-hclust-get-classes-2'>k = 3</a></li>
<li><a href='#tab-SD-hclust-get-classes-3'>k = 4</a></li>
<li><a href='#tab-SD-hclust-get-classes-4'>k = 5</a></li>
<li><a href='#tab-SD-hclust-get-classes-5'>k = 6</a></li>
</ul>

<div id='tab-SD-hclust-get-classes-1'>
<p><a id='tab-SD-hclust-get-classes-1-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 2), get_membership(res, k = 2))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2
#&gt; SIH013     2   0.971      0.502 0.40 0.60
#&gt; SIH014     2   0.584      0.783 0.14 0.86
#&gt; SIH024     2   0.958      0.549 0.38 0.62
#&gt; SIH028     2   0.584      0.793 0.14 0.86
#&gt; SIH031     1   0.855      0.576 0.72 0.28
#&gt; SIH042     1   0.469      0.829 0.90 0.10
#&gt; SIH107     2   0.000      0.793 0.00 1.00
#&gt; SIH114     1   0.327      0.847 0.94 0.06
#&gt; SIH116     2   0.855      0.627 0.28 0.72
#&gt; SIH117     2   0.855      0.694 0.28 0.72
#&gt; SIH130     2   0.141      0.803 0.02 0.98
#&gt; SIH134     2   0.141      0.803 0.02 0.98
#&gt; SIH186     2   0.000      0.793 0.00 1.00
#&gt; SIH191     1   0.000      0.866 1.00 0.00
#&gt; SIH192     2   0.881      0.687 0.30 0.70
#&gt; SIH196     2   0.141      0.803 0.02 0.98
#&gt; SIH214     2   0.469      0.799 0.10 0.90
#&gt; SIH218     1   0.943      0.360 0.64 0.36
#&gt; SIH232     1   0.000      0.866 1.00 0.00
#&gt; SIH236     1   0.904      0.508 0.68 0.32
#&gt; SIH238     1   0.827      0.641 0.74 0.26
#&gt; SIH241     2   0.402      0.804 0.08 0.92
#&gt; SIH245     2   0.141      0.803 0.02 0.98
#&gt; SIH260     2   0.855      0.627 0.28 0.72
#&gt; SIH287     2   0.827      0.656 0.26 0.74
#&gt; SIH289     2   0.958      0.431 0.38 0.62
#&gt; SIH290     2   0.141      0.803 0.02 0.98
#&gt; SIH295     1   0.000      0.866 1.00 0.00
#&gt; SIH366     1   0.529      0.818 0.88 0.12
#&gt; SIH377     1   0.000      0.866 1.00 0.00
#&gt; SIH380     2   0.141      0.803 0.02 0.98
#&gt; SIH385     2   0.529      0.788 0.12 0.88
#&gt; SIH389     2   0.000      0.793 0.00 1.00
#&gt; SIH391     2   0.827      0.646 0.26 0.74
#&gt; SIH403     1   0.529      0.810 0.88 0.12
#&gt; SIH411     2   0.141      0.803 0.02 0.98
#&gt; SIH427     1   0.000      0.866 1.00 0.00
#&gt; SIH433     2   0.827      0.718 0.26 0.74
#&gt; SIH439     1   0.680      0.729 0.82 0.18
#&gt; SIH442     1   0.000      0.866 1.00 0.00
#&gt; SIH444     2   0.943      0.593 0.36 0.64
#&gt; SIH452     2   0.680      0.734 0.18 0.82
#&gt; SIH461     2   0.943      0.582 0.36 0.64
#&gt; SIH471     1   0.000      0.866 1.00 0.00
#&gt; SIH472     2   0.000      0.793 0.00 1.00
#&gt; SIH481     1   0.000      0.866 1.00 0.00
#&gt; SIH485     2   0.529      0.793 0.12 0.88
#&gt; SIH491     2   0.141      0.803 0.02 0.98
#&gt; SIH508     1   0.327      0.845 0.94 0.06
#&gt; SIH559     1   0.000      0.866 1.00 0.00
#&gt; SIH587     1   0.000      0.866 1.00 0.00
#&gt; SIH625     2   0.827      0.665 0.26 0.74
#&gt; SIH641     1   0.881      0.542 0.70 0.30
#&gt; SIH643     2   0.943      0.593 0.36 0.64
#&gt; SIH674     1   0.000      0.866 1.00 0.00
#&gt; SIH678     1   0.000      0.866 1.00 0.00
#&gt; SIH679     1   0.855      0.601 0.72 0.28
#&gt; SIH689     2   0.855      0.694 0.28 0.72
#&gt; SIH694     2   0.242      0.804 0.04 0.96
#&gt; SIH721     2   0.958      0.534 0.38 0.62
</code></pre>

<script>
$('#tab-SD-hclust-get-classes-1-a').parent().next().next().hide();
$('#tab-SD-hclust-get-classes-1-a').click(function(){
  $('#tab-SD-hclust-get-classes-1-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-SD-hclust-get-classes-2'>
<p><a id='tab-SD-hclust-get-classes-2-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 3), get_membership(res, k = 3))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3
#&gt; SIH013     3  0.6232      0.537 0.22 0.04 0.74
#&gt; SIH014     3  0.3415      0.657 0.02 0.08 0.90
#&gt; SIH024     3  0.5746      0.551 0.18 0.04 0.78
#&gt; SIH028     3  0.5159      0.625 0.04 0.14 0.82
#&gt; SIH031     1  0.8683      0.446 0.54 0.12 0.34
#&gt; SIH042     1  0.5334      0.780 0.82 0.12 0.06
#&gt; SIH107     2  0.6045      0.468 0.00 0.62 0.38
#&gt; SIH114     1  0.3572      0.802 0.90 0.04 0.06
#&gt; SIH116     2  0.6850      0.701 0.14 0.74 0.12
#&gt; SIH117     3  0.5334      0.613 0.12 0.06 0.82
#&gt; SIH130     3  0.5706      0.500 0.00 0.32 0.68
#&gt; SIH134     3  0.5706      0.500 0.00 0.32 0.68
#&gt; SIH186     2  0.5948      0.500 0.00 0.64 0.36
#&gt; SIH191     1  0.0892      0.807 0.98 0.02 0.00
#&gt; SIH192     3  0.7398      0.565 0.12 0.18 0.70
#&gt; SIH196     3  0.5706      0.473 0.00 0.32 0.68
#&gt; SIH214     3  0.4209      0.648 0.02 0.12 0.86
#&gt; SIH218     1  0.9093      0.178 0.46 0.14 0.40
#&gt; SIH232     1  0.2959      0.802 0.90 0.10 0.00
#&gt; SIH236     1  0.7074      0.120 0.50 0.48 0.02
#&gt; SIH238     1  0.7825      0.577 0.62 0.08 0.30
#&gt; SIH241     3  0.3832      0.648 0.02 0.10 0.88
#&gt; SIH245     3  0.5560      0.494 0.00 0.30 0.70
#&gt; SIH260     2  0.6850      0.701 0.14 0.74 0.12
#&gt; SIH287     2  0.7447      0.698 0.14 0.70 0.16
#&gt; SIH289     2  0.6922      0.624 0.20 0.72 0.08
#&gt; SIH290     3  0.5560      0.494 0.00 0.30 0.70
#&gt; SIH295     1  0.0000      0.811 1.00 0.00 0.00
#&gt; SIH366     1  0.7144      0.718 0.70 0.22 0.08
#&gt; SIH377     1  0.0892      0.810 0.98 0.02 0.00
#&gt; SIH380     3  0.5948      0.417 0.00 0.36 0.64
#&gt; SIH385     3  0.1529      0.651 0.00 0.04 0.96
#&gt; SIH389     2  0.6045      0.468 0.00 0.62 0.38
#&gt; SIH391     2  0.8479      0.519 0.12 0.58 0.30
#&gt; SIH403     1  0.5334      0.772 0.82 0.06 0.12
#&gt; SIH411     3  0.5948      0.379 0.00 0.36 0.64
#&gt; SIH427     1  0.0000      0.811 1.00 0.00 0.00
#&gt; SIH433     3  0.3572      0.631 0.06 0.04 0.90
#&gt; SIH439     1  0.9684      0.442 0.46 0.26 0.28
#&gt; SIH442     1  0.2947      0.807 0.92 0.06 0.02
#&gt; SIH444     3  0.6922      0.534 0.20 0.08 0.72
#&gt; SIH452     2  0.6922      0.685 0.08 0.72 0.20
#&gt; SIH461     3  0.5466      0.570 0.16 0.04 0.80
#&gt; SIH471     1  0.0000      0.811 1.00 0.00 0.00
#&gt; SIH472     2  0.6045      0.468 0.00 0.62 0.38
#&gt; SIH481     1  0.5159      0.782 0.82 0.14 0.04
#&gt; SIH485     3  0.3832      0.653 0.02 0.10 0.88
#&gt; SIH491     3  0.4796      0.576 0.00 0.22 0.78
#&gt; SIH508     1  0.4449      0.797 0.86 0.10 0.04
#&gt; SIH559     1  0.0000      0.811 1.00 0.00 0.00
#&gt; SIH587     1  0.0892      0.807 0.98 0.02 0.00
#&gt; SIH625     2  0.6530      0.701 0.12 0.76 0.12
#&gt; SIH641     1  0.7344      0.587 0.68 0.08 0.24
#&gt; SIH643     3  0.6495      0.548 0.20 0.06 0.74
#&gt; SIH674     1  0.2947      0.807 0.92 0.06 0.02
#&gt; SIH678     1  0.0000      0.811 1.00 0.00 0.00
#&gt; SIH679     1  0.7447      0.612 0.70 0.16 0.14
#&gt; SIH689     3  0.5334      0.613 0.12 0.06 0.82
#&gt; SIH694     3  0.5016      0.577 0.00 0.24 0.76
#&gt; SIH721     3  0.5406      0.543 0.20 0.02 0.78
</code></pre>

<script>
$('#tab-SD-hclust-get-classes-2-a').parent().next().next().hide();
$('#tab-SD-hclust-get-classes-2-a').click(function(){
  $('#tab-SD-hclust-get-classes-2-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-SD-hclust-get-classes-3'>
<p><a id='tab-SD-hclust-get-classes-3-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 4), get_membership(res, k = 4))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3   p4
#&gt; SIH013     2  0.5863     0.3618 0.18 0.70 0.12 0.00
#&gt; SIH014     2  0.3030     0.6410 0.02 0.90 0.06 0.02
#&gt; SIH024     2  0.5784     0.3797 0.10 0.70 0.20 0.00
#&gt; SIH028     2  0.5284     0.6133 0.02 0.78 0.10 0.10
#&gt; SIH031     1  0.8987    -0.3252 0.44 0.30 0.16 0.10
#&gt; SIH042     1  0.5869     0.5838 0.74 0.04 0.16 0.06
#&gt; SIH107     4  0.7602     0.4489 0.00 0.20 0.38 0.42
#&gt; SIH114     1  0.4421     0.6878 0.84 0.06 0.04 0.06
#&gt; SIH116     4  0.2611     0.5872 0.02 0.02 0.04 0.92
#&gt; SIH117     2  0.5224     0.4954 0.04 0.76 0.18 0.02
#&gt; SIH130     2  0.5956     0.5805 0.00 0.68 0.22 0.10
#&gt; SIH134     2  0.6110     0.5818 0.00 0.66 0.24 0.10
#&gt; SIH186     4  0.7654     0.4523 0.00 0.22 0.34 0.44
#&gt; SIH191     1  0.2411     0.7044 0.92 0.00 0.04 0.04
#&gt; SIH192     2  0.7885     0.3273 0.06 0.58 0.22 0.14
#&gt; SIH196     2  0.5956     0.5629 0.00 0.68 0.22 0.10
#&gt; SIH214     2  0.3886     0.6471 0.02 0.86 0.08 0.04
#&gt; SIH218     2  0.9081    -0.3944 0.36 0.38 0.16 0.10
#&gt; SIH232     1  0.3172     0.6724 0.84 0.00 0.16 0.00
#&gt; SIH236     4  0.6299    -0.0834 0.32 0.00 0.08 0.60
#&gt; SIH238     1  0.8024     0.1205 0.54 0.28 0.12 0.06
#&gt; SIH241     2  0.3821     0.6344 0.00 0.84 0.12 0.04
#&gt; SIH245     2  0.5767     0.5601 0.00 0.66 0.28 0.06
#&gt; SIH260     4  0.2611     0.5872 0.02 0.02 0.04 0.92
#&gt; SIH287     4  0.3886     0.5880 0.02 0.04 0.08 0.86
#&gt; SIH289     4  0.2411     0.5234 0.04 0.00 0.04 0.92
#&gt; SIH290     2  0.5767     0.5601 0.00 0.66 0.28 0.06
#&gt; SIH295     1  0.1411     0.7159 0.96 0.00 0.02 0.02
#&gt; SIH366     1  0.8024     0.1806 0.54 0.06 0.28 0.12
#&gt; SIH377     1  0.2647     0.7006 0.88 0.00 0.12 0.00
#&gt; SIH380     2  0.6500     0.5392 0.00 0.62 0.26 0.12
#&gt; SIH385     2  0.2921     0.6193 0.00 0.86 0.14 0.00
#&gt; SIH389     4  0.7768     0.3883 0.00 0.24 0.36 0.40
#&gt; SIH391     4  0.6966     0.3614 0.02 0.16 0.18 0.64
#&gt; SIH403     1  0.6414     0.5718 0.70 0.08 0.18 0.04
#&gt; SIH411     2  0.6720     0.4510 0.00 0.58 0.30 0.12
#&gt; SIH427     1  0.0707     0.7153 0.98 0.00 0.00 0.02
#&gt; SIH433     2  0.3853     0.5290 0.02 0.82 0.16 0.00
#&gt; SIH439     3  0.9499     0.0000 0.20 0.20 0.42 0.18
#&gt; SIH442     1  0.3606     0.6657 0.84 0.02 0.14 0.00
#&gt; SIH444     2  0.7146     0.2954 0.12 0.64 0.20 0.04
#&gt; SIH452     4  0.3525     0.5941 0.00 0.04 0.10 0.86
#&gt; SIH461     2  0.5594     0.4138 0.10 0.72 0.18 0.00
#&gt; SIH471     1  0.1411     0.7137 0.96 0.00 0.02 0.02
#&gt; SIH472     4  0.7602     0.4489 0.00 0.20 0.38 0.42
#&gt; SIH481     1  0.5886     0.5368 0.72 0.04 0.20 0.04
#&gt; SIH485     2  0.3725     0.6454 0.02 0.86 0.10 0.02
#&gt; SIH491     2  0.4553     0.6295 0.00 0.78 0.18 0.04
#&gt; SIH508     1  0.4766     0.6419 0.80 0.02 0.14 0.04
#&gt; SIH559     1  0.2335     0.7096 0.92 0.00 0.06 0.02
#&gt; SIH587     1  0.3198     0.6954 0.88 0.00 0.08 0.04
#&gt; SIH625     4  0.1637     0.5931 0.00 0.00 0.06 0.94
#&gt; SIH641     1  0.7657     0.3429 0.62 0.18 0.12 0.08
#&gt; SIH643     2  0.6890     0.3064 0.10 0.62 0.26 0.02
#&gt; SIH674     1  0.3606     0.6657 0.84 0.02 0.14 0.00
#&gt; SIH678     1  0.2335     0.7096 0.92 0.00 0.06 0.02
#&gt; SIH679     1  0.7578     0.3789 0.62 0.10 0.08 0.20
#&gt; SIH689     2  0.5224     0.4954 0.04 0.76 0.18 0.02
#&gt; SIH694     2  0.5077     0.6281 0.00 0.76 0.16 0.08
#&gt; SIH721     2  0.5657     0.4045 0.12 0.72 0.16 0.00
</code></pre>

<script>
$('#tab-SD-hclust-get-classes-3-a').parent().next().next().hide();
$('#tab-SD-hclust-get-classes-3-a').click(function(){
  $('#tab-SD-hclust-get-classes-3-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-SD-hclust-get-classes-4'>
<p><a id='tab-SD-hclust-get-classes-4-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 5), get_membership(res, k = 5))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3   p4   p5
#&gt; SIH013     3  0.4449    0.56383 0.14 0.02 0.78 0.00 0.06
#&gt; SIH014     3  0.4527    0.34761 0.00 0.26 0.70 0.00 0.04
#&gt; SIH024     3  0.4008    0.56836 0.08 0.02 0.82 0.00 0.08
#&gt; SIH028     3  0.6855    0.01961 0.00 0.36 0.48 0.04 0.12
#&gt; SIH031     1  0.7919   -0.28535 0.38 0.02 0.22 0.04 0.34
#&gt; SIH042     1  0.6305    0.25825 0.58 0.00 0.06 0.06 0.30
#&gt; SIH107     2  0.4527    0.25831 0.00 0.70 0.00 0.26 0.04
#&gt; SIH114     1  0.4312    0.51379 0.78 0.00 0.04 0.02 0.16
#&gt; SIH116     4  0.2012    0.77342 0.00 0.06 0.02 0.92 0.00
#&gt; SIH117     3  0.3694    0.57220 0.02 0.02 0.82 0.00 0.14
#&gt; SIH130     2  0.5351    0.43645 0.00 0.56 0.38 0.00 0.06
#&gt; SIH134     2  0.5394    0.42511 0.00 0.54 0.40 0.00 0.06
#&gt; SIH186     2  0.5415    0.24161 0.00 0.66 0.02 0.26 0.06
#&gt; SIH191     1  0.2249    0.57223 0.92 0.02 0.00 0.04 0.02
#&gt; SIH192     3  0.7578    0.42511 0.02 0.16 0.56 0.10 0.16
#&gt; SIH196     2  0.5220    0.46205 0.00 0.58 0.38 0.02 0.02
#&gt; SIH214     3  0.5232    0.16206 0.00 0.34 0.60 0.00 0.06
#&gt; SIH218     3  0.8606   -0.13887 0.32 0.08 0.36 0.04 0.20
#&gt; SIH232     1  0.4426    0.49482 0.74 0.02 0.02 0.00 0.22
#&gt; SIH236     4  0.5905    0.25903 0.28 0.04 0.00 0.62 0.06
#&gt; SIH238     1  0.6885    0.00968 0.50 0.02 0.22 0.00 0.26
#&gt; SIH241     3  0.6038    0.10086 0.00 0.34 0.56 0.02 0.08
#&gt; SIH245     2  0.4182    0.44044 0.00 0.60 0.40 0.00 0.00
#&gt; SIH260     4  0.2012    0.77342 0.00 0.06 0.02 0.92 0.00
#&gt; SIH287     4  0.3291    0.74750 0.00 0.12 0.04 0.84 0.00
#&gt; SIH289     4  0.3034    0.73054 0.02 0.06 0.00 0.88 0.04
#&gt; SIH290     2  0.4126    0.45328 0.00 0.62 0.38 0.00 0.00
#&gt; SIH295     1  0.1410    0.59196 0.94 0.00 0.00 0.00 0.06
#&gt; SIH366     5  0.7015    0.05154 0.38 0.04 0.02 0.08 0.48
#&gt; SIH377     1  0.3999    0.51852 0.74 0.00 0.02 0.00 0.24
#&gt; SIH380     2  0.5887    0.45936 0.00 0.54 0.38 0.02 0.06
#&gt; SIH385     3  0.4373    0.45746 0.00 0.16 0.76 0.00 0.08
#&gt; SIH389     2  0.4966    0.31238 0.00 0.70 0.02 0.24 0.04
#&gt; SIH391     4  0.7318    0.46222 0.00 0.16 0.08 0.52 0.24
#&gt; SIH403     1  0.5607    0.24595 0.54 0.00 0.08 0.00 0.38
#&gt; SIH411     2  0.4360    0.50525 0.00 0.68 0.30 0.02 0.00
#&gt; SIH427     1  0.0609    0.59448 0.98 0.00 0.00 0.00 0.02
#&gt; SIH433     3  0.2331    0.57807 0.00 0.02 0.90 0.00 0.08
#&gt; SIH439     5  0.8420    0.40434 0.10 0.08 0.20 0.12 0.50
#&gt; SIH442     1  0.4966    0.45465 0.70 0.02 0.04 0.00 0.24
#&gt; SIH444     3  0.6077    0.43304 0.04 0.06 0.58 0.00 0.32
#&gt; SIH452     4  0.4818    0.69099 0.00 0.18 0.00 0.72 0.10
#&gt; SIH461     3  0.3700    0.57121 0.08 0.02 0.84 0.00 0.06
#&gt; SIH471     1  0.1410    0.59418 0.94 0.00 0.00 0.00 0.06
#&gt; SIH472     2  0.4527    0.25831 0.00 0.70 0.00 0.26 0.04
#&gt; SIH481     1  0.5942    0.21879 0.60 0.02 0.04 0.02 0.32
#&gt; SIH485     3  0.5068    0.24016 0.00 0.30 0.64 0.00 0.06
#&gt; SIH491     2  0.5173    0.27428 0.00 0.50 0.46 0.00 0.04
#&gt; SIH508     1  0.5415    0.40421 0.66 0.00 0.06 0.02 0.26
#&gt; SIH559     1  0.1410    0.58299 0.94 0.00 0.00 0.00 0.06
#&gt; SIH587     1  0.2675    0.56990 0.90 0.02 0.00 0.04 0.04
#&gt; SIH625     4  0.3291    0.73566 0.00 0.12 0.00 0.84 0.04
#&gt; SIH641     1  0.7534    0.20213 0.52 0.06 0.14 0.02 0.26
#&gt; SIH643     3  0.4966    0.50638 0.04 0.02 0.70 0.00 0.24
#&gt; SIH674     1  0.4966    0.45465 0.70 0.02 0.04 0.00 0.24
#&gt; SIH678     1  0.1410    0.58299 0.94 0.00 0.00 0.00 0.06
#&gt; SIH679     1  0.7326    0.21685 0.56 0.04 0.04 0.12 0.24
#&gt; SIH689     3  0.2873    0.57647 0.02 0.00 0.86 0.00 0.12
#&gt; SIH694     3  0.4818   -0.28285 0.00 0.46 0.52 0.00 0.02
#&gt; SIH721     3  0.3977    0.56638 0.10 0.02 0.82 0.00 0.06
</code></pre>

<script>
$('#tab-SD-hclust-get-classes-4-a').parent().next().next().hide();
$('#tab-SD-hclust-get-classes-4-a').click(function(){
  $('#tab-SD-hclust-get-classes-4-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-SD-hclust-get-classes-5'>
<p><a id='tab-SD-hclust-get-classes-5-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 6), get_membership(res, k = 6))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3   p4   p5   p6
#&gt; SIH013     3  0.5294     0.5737 0.02 0.08 0.72 0.02 0.14 0.02
#&gt; SIH014     3  0.4873    -0.2819 0.00 0.42 0.52 0.00 0.00 0.06
#&gt; SIH024     3  0.4008     0.5832 0.06 0.08 0.80 0.00 0.06 0.00
#&gt; SIH028     2  0.6710     0.4428 0.08 0.56 0.26 0.02 0.02 0.06
#&gt; SIH031     1  0.7341     0.2600 0.38 0.02 0.28 0.02 0.28 0.02
#&gt; SIH042     5  0.6573     0.2764 0.24 0.00 0.10 0.02 0.56 0.08
#&gt; SIH107     6  0.5798     0.9483 0.00 0.32 0.00 0.20 0.00 0.48
#&gt; SIH114     5  0.5564     0.4907 0.16 0.02 0.04 0.02 0.70 0.06
#&gt; SIH116     4  0.0937     0.7196 0.00 0.04 0.00 0.96 0.00 0.00
#&gt; SIH117     3  0.4983     0.5725 0.06 0.10 0.76 0.02 0.02 0.04
#&gt; SIH130     2  0.2631     0.7168 0.00 0.82 0.18 0.00 0.00 0.00
#&gt; SIH134     2  0.2793     0.7095 0.00 0.80 0.20 0.00 0.00 0.00
#&gt; SIH186     6  0.5747     0.9022 0.00 0.30 0.00 0.20 0.00 0.50
#&gt; SIH191     5  0.3073     0.5626 0.08 0.00 0.00 0.00 0.84 0.08
#&gt; SIH192     3  0.7005     0.3532 0.10 0.22 0.54 0.10 0.00 0.04
#&gt; SIH196     2  0.3678     0.7175 0.00 0.78 0.18 0.02 0.00 0.02
#&gt; SIH214     2  0.4873     0.4133 0.00 0.52 0.42 0.00 0.00 0.06
#&gt; SIH218     3  0.8436    -0.2148 0.26 0.12 0.34 0.02 0.22 0.04
#&gt; SIH232     5  0.3592     0.5038 0.24 0.00 0.02 0.00 0.74 0.00
#&gt; SIH236     4  0.6456     0.3397 0.10 0.00 0.00 0.56 0.16 0.18
#&gt; SIH238     5  0.6941    -0.1681 0.32 0.00 0.24 0.00 0.38 0.06
#&gt; SIH241     2  0.5750     0.3801 0.08 0.54 0.34 0.00 0.00 0.04
#&gt; SIH245     2  0.4094     0.7150 0.00 0.74 0.18 0.00 0.00 0.08
#&gt; SIH260     4  0.0937     0.7196 0.00 0.04 0.00 0.96 0.00 0.00
#&gt; SIH287     4  0.2350     0.6725 0.00 0.10 0.02 0.88 0.00 0.00
#&gt; SIH289     4  0.2190     0.6992 0.04 0.00 0.00 0.90 0.00 0.06
#&gt; SIH290     2  0.3928     0.7184 0.00 0.76 0.16 0.00 0.00 0.08
#&gt; SIH295     5  0.1092     0.5897 0.02 0.00 0.00 0.00 0.96 0.02
#&gt; SIH366     1  0.6002     0.0139 0.54 0.00 0.02 0.04 0.34 0.06
#&gt; SIH377     5  0.3950     0.5233 0.24 0.00 0.04 0.00 0.72 0.00
#&gt; SIH380     2  0.4042     0.7008 0.00 0.76 0.18 0.04 0.00 0.02
#&gt; SIH385     3  0.5304     0.2784 0.06 0.28 0.62 0.00 0.00 0.04
#&gt; SIH389     6  0.5769     0.9072 0.00 0.36 0.00 0.18 0.00 0.46
#&gt; SIH391     4  0.7988     0.3562 0.14 0.10 0.14 0.46 0.00 0.16
#&gt; SIH403     5  0.6103     0.2530 0.34 0.02 0.10 0.00 0.52 0.02
#&gt; SIH411     2  0.3795     0.6777 0.00 0.80 0.12 0.02 0.00 0.06
#&gt; SIH427     5  0.1480     0.5891 0.02 0.00 0.00 0.00 0.94 0.04
#&gt; SIH433     3  0.3163     0.5456 0.00 0.14 0.82 0.00 0.00 0.04
#&gt; SIH439     1  0.7103     0.4078 0.58 0.04 0.16 0.02 0.08 0.12
#&gt; SIH442     5  0.3950     0.4758 0.24 0.00 0.04 0.00 0.72 0.00
#&gt; SIH444     3  0.6965     0.4276 0.22 0.12 0.56 0.02 0.04 0.04
#&gt; SIH452     4  0.4247     0.5576 0.06 0.00 0.00 0.70 0.00 0.24
#&gt; SIH461     3  0.3697     0.5841 0.04 0.08 0.82 0.00 0.06 0.00
#&gt; SIH471     5  0.1480     0.5843 0.04 0.00 0.00 0.00 0.94 0.02
#&gt; SIH472     6  0.5798     0.9483 0.00 0.32 0.00 0.20 0.00 0.48
#&gt; SIH481     5  0.4576     0.2567 0.40 0.00 0.04 0.00 0.56 0.00
#&gt; SIH485     2  0.4873     0.3348 0.00 0.52 0.42 0.00 0.00 0.06
#&gt; SIH491     2  0.4690     0.6225 0.04 0.70 0.22 0.00 0.00 0.04
#&gt; SIH508     5  0.4503     0.4336 0.24 0.00 0.08 0.00 0.68 0.00
#&gt; SIH559     5  0.2260     0.5599 0.14 0.00 0.00 0.00 0.86 0.00
#&gt; SIH587     5  0.3567     0.5483 0.10 0.00 0.00 0.00 0.80 0.10
#&gt; SIH625     4  0.3351     0.6428 0.04 0.00 0.00 0.80 0.00 0.16
#&gt; SIH641     5  0.7956     0.1575 0.16 0.14 0.08 0.02 0.50 0.10
#&gt; SIH643     3  0.5477     0.5499 0.12 0.10 0.70 0.00 0.02 0.06
#&gt; SIH674     5  0.3950     0.4758 0.24 0.00 0.04 0.00 0.72 0.00
#&gt; SIH678     5  0.2260     0.5599 0.14 0.00 0.00 0.00 0.86 0.00
#&gt; SIH679     5  0.8259     0.1652 0.18 0.10 0.02 0.10 0.46 0.14
#&gt; SIH689     3  0.4983     0.5759 0.06 0.10 0.76 0.02 0.02 0.04
#&gt; SIH694     2  0.5007     0.6694 0.00 0.66 0.24 0.02 0.00 0.08
#&gt; SIH721     3  0.5757     0.5475 0.06 0.12 0.70 0.02 0.08 0.02
</code></pre>

<script>
$('#tab-SD-hclust-get-classes-5-a').parent().next().next().hide();
$('#tab-SD-hclust-get-classes-5-a').click(function(){
  $('#tab-SD-hclust-get-classes-5-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>
</div>

Heatmaps for the consensus matrix. It visualizes the probability of two
samples to be in a same group.




<script>
$( function() {
	$( '#tabs-SD-hclust-consensus-heatmap' ).tabs();
} );
</script>
<div id='tabs-SD-hclust-consensus-heatmap'>
<ul>
<li><a href='#tab-SD-hclust-consensus-heatmap-1'>k = 2</a></li>
<li><a href='#tab-SD-hclust-consensus-heatmap-2'>k = 3</a></li>
<li><a href='#tab-SD-hclust-consensus-heatmap-3'>k = 4</a></li>
<li><a href='#tab-SD-hclust-consensus-heatmap-4'>k = 5</a></li>
<li><a href='#tab-SD-hclust-consensus-heatmap-5'>k = 6</a></li>
</ul>
<div id='tab-SD-hclust-consensus-heatmap-1'>
<pre><code class="language-r">consensus_heatmap(res, k = 2)
</code></pre>
<p><img src="figure_cola/tab-SD-hclust-consensus-heatmap-1-1.png" alt="plot of chunk tab-SD-hclust-consensus-heatmap-1" /></p>

</div>
<div id='tab-SD-hclust-consensus-heatmap-2'>
<pre><code class="language-r">consensus_heatmap(res, k = 3)
</code></pre>
<p><img src="figure_cola/tab-SD-hclust-consensus-heatmap-2-1.png" alt="plot of chunk tab-SD-hclust-consensus-heatmap-2" /></p>

</div>
<div id='tab-SD-hclust-consensus-heatmap-3'>
<pre><code class="language-r">consensus_heatmap(res, k = 4)
</code></pre>
<p><img src="figure_cola/tab-SD-hclust-consensus-heatmap-3-1.png" alt="plot of chunk tab-SD-hclust-consensus-heatmap-3" /></p>

</div>
<div id='tab-SD-hclust-consensus-heatmap-4'>
<pre><code class="language-r">consensus_heatmap(res, k = 5)
</code></pre>
<p><img src="figure_cola/tab-SD-hclust-consensus-heatmap-4-1.png" alt="plot of chunk tab-SD-hclust-consensus-heatmap-4" /></p>

</div>
<div id='tab-SD-hclust-consensus-heatmap-5'>
<pre><code class="language-r">consensus_heatmap(res, k = 6)
</code></pre>
<p><img src="figure_cola/tab-SD-hclust-consensus-heatmap-5-1.png" alt="plot of chunk tab-SD-hclust-consensus-heatmap-5" /></p>

</div>
</div>

Heatmaps for the membership of samples in all partitions to see how consistent they are:





<script>
$( function() {
	$( '#tabs-SD-hclust-membership-heatmap' ).tabs();
} );
</script>
<div id='tabs-SD-hclust-membership-heatmap'>
<ul>
<li><a href='#tab-SD-hclust-membership-heatmap-1'>k = 2</a></li>
<li><a href='#tab-SD-hclust-membership-heatmap-2'>k = 3</a></li>
<li><a href='#tab-SD-hclust-membership-heatmap-3'>k = 4</a></li>
<li><a href='#tab-SD-hclust-membership-heatmap-4'>k = 5</a></li>
<li><a href='#tab-SD-hclust-membership-heatmap-5'>k = 6</a></li>
</ul>
<div id='tab-SD-hclust-membership-heatmap-1'>
<pre><code class="language-r">membership_heatmap(res, k = 2)
</code></pre>
<p><img src="figure_cola/tab-SD-hclust-membership-heatmap-1-1.png" alt="plot of chunk tab-SD-hclust-membership-heatmap-1" /></p>

</div>
<div id='tab-SD-hclust-membership-heatmap-2'>
<pre><code class="language-r">membership_heatmap(res, k = 3)
</code></pre>
<p><img src="figure_cola/tab-SD-hclust-membership-heatmap-2-1.png" alt="plot of chunk tab-SD-hclust-membership-heatmap-2" /></p>

</div>
<div id='tab-SD-hclust-membership-heatmap-3'>
<pre><code class="language-r">membership_heatmap(res, k = 4)
</code></pre>
<p><img src="figure_cola/tab-SD-hclust-membership-heatmap-3-1.png" alt="plot of chunk tab-SD-hclust-membership-heatmap-3" /></p>

</div>
<div id='tab-SD-hclust-membership-heatmap-4'>
<pre><code class="language-r">membership_heatmap(res, k = 5)
</code></pre>
<p><img src="figure_cola/tab-SD-hclust-membership-heatmap-4-1.png" alt="plot of chunk tab-SD-hclust-membership-heatmap-4" /></p>

</div>
<div id='tab-SD-hclust-membership-heatmap-5'>
<pre><code class="language-r">membership_heatmap(res, k = 6)
</code></pre>
<p><img src="figure_cola/tab-SD-hclust-membership-heatmap-5-1.png" alt="plot of chunk tab-SD-hclust-membership-heatmap-5" /></p>

</div>
</div>

As soon as the classes for columns are determined, the signatures
that are significantly different between subgroups can be looked for. 
Following are the heatmaps for signatures.




Signature heatmaps where rows are scaled:



<script>
$( function() {
	$( '#tabs-SD-hclust-get-signatures' ).tabs();
} );
</script>
<div id='tabs-SD-hclust-get-signatures'>
<ul>
<li><a href='#tab-SD-hclust-get-signatures-1'>k = 2</a></li>
<li><a href='#tab-SD-hclust-get-signatures-2'>k = 3</a></li>
<li><a href='#tab-SD-hclust-get-signatures-3'>k = 4</a></li>
<li><a href='#tab-SD-hclust-get-signatures-4'>k = 5</a></li>
<li><a href='#tab-SD-hclust-get-signatures-5'>k = 6</a></li>
</ul>
<div id='tab-SD-hclust-get-signatures-1'>
<pre><code class="language-r">get_signatures(res, k = 2)
</code></pre>
<p><img src="figure_cola/tab-SD-hclust-get-signatures-1-1.png" alt="plot of chunk tab-SD-hclust-get-signatures-1" /></p>

</div>
<div id='tab-SD-hclust-get-signatures-2'>
<pre><code class="language-r">get_signatures(res, k = 3)
</code></pre>
<p><img src="figure_cola/tab-SD-hclust-get-signatures-2-1.png" alt="plot of chunk tab-SD-hclust-get-signatures-2" /></p>

</div>
<div id='tab-SD-hclust-get-signatures-3'>
<pre><code class="language-r">get_signatures(res, k = 4)
</code></pre>
<p><img src="figure_cola/tab-SD-hclust-get-signatures-3-1.png" alt="plot of chunk tab-SD-hclust-get-signatures-3" /></p>

</div>
<div id='tab-SD-hclust-get-signatures-4'>
<pre><code class="language-r">get_signatures(res, k = 5)
</code></pre>
<p><img src="figure_cola/tab-SD-hclust-get-signatures-4-1.png" alt="plot of chunk tab-SD-hclust-get-signatures-4" /></p>

</div>
<div id='tab-SD-hclust-get-signatures-5'>
<pre><code class="language-r">get_signatures(res, k = 6)
</code></pre>
<p><img src="figure_cola/tab-SD-hclust-get-signatures-5-1.png" alt="plot of chunk tab-SD-hclust-get-signatures-5" /></p>

</div>
</div>



Signature heatmaps where rows are not scaled:


<script>
$( function() {
	$( '#tabs-SD-hclust-get-signatures-no-scale' ).tabs();
} );
</script>
<div id='tabs-SD-hclust-get-signatures-no-scale'>
<ul>
<li><a href='#tab-SD-hclust-get-signatures-no-scale-1'>k = 2</a></li>
<li><a href='#tab-SD-hclust-get-signatures-no-scale-2'>k = 3</a></li>
<li><a href='#tab-SD-hclust-get-signatures-no-scale-3'>k = 4</a></li>
<li><a href='#tab-SD-hclust-get-signatures-no-scale-4'>k = 5</a></li>
<li><a href='#tab-SD-hclust-get-signatures-no-scale-5'>k = 6</a></li>
</ul>
<div id='tab-SD-hclust-get-signatures-no-scale-1'>
<pre><code class="language-r">get_signatures(res, k = 2, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-SD-hclust-get-signatures-no-scale-1-1.png" alt="plot of chunk tab-SD-hclust-get-signatures-no-scale-1" /></p>

</div>
<div id='tab-SD-hclust-get-signatures-no-scale-2'>
<pre><code class="language-r">get_signatures(res, k = 3, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-SD-hclust-get-signatures-no-scale-2-1.png" alt="plot of chunk tab-SD-hclust-get-signatures-no-scale-2" /></p>

</div>
<div id='tab-SD-hclust-get-signatures-no-scale-3'>
<pre><code class="language-r">get_signatures(res, k = 4, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-SD-hclust-get-signatures-no-scale-3-1.png" alt="plot of chunk tab-SD-hclust-get-signatures-no-scale-3" /></p>

</div>
<div id='tab-SD-hclust-get-signatures-no-scale-4'>
<pre><code class="language-r">get_signatures(res, k = 5, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-SD-hclust-get-signatures-no-scale-4-1.png" alt="plot of chunk tab-SD-hclust-get-signatures-no-scale-4" /></p>

</div>
<div id='tab-SD-hclust-get-signatures-no-scale-5'>
<pre><code class="language-r">get_signatures(res, k = 6, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-SD-hclust-get-signatures-no-scale-5-1.png" alt="plot of chunk tab-SD-hclust-get-signatures-no-scale-5" /></p>

</div>
</div>



Compare the overlap of signatures from different k:

``` r
compare_signatures(res)
```

![plot of chunk SD-hclust-signature_compare](figure_cola/SD-hclust-signature_compare-1.png)

`get_signature()` returns a data frame invisibly. To get the list of signatures, the function
call should be assigned to a variable explicitly. In following code, if `plot` argument is set
to `FALSE`, no heatmap is plotted while only the differential analysis is performed.

``` r
# code only for demonstration
tb = get_signature(res, k = ..., plot = FALSE)
```

An example of the output of `tb` is:

```
#>   which_row         fdr    mean_1    mean_2 scaled_mean_1 scaled_mean_2 km
#> 1        38 0.042760348  8.373488  9.131774    -0.5533452     0.5164555  1
#> 2        40 0.018707592  7.106213  8.469186    -0.6173731     0.5762149  1
#> 3        55 0.019134737 10.221463 11.207825    -0.6159697     0.5749050  1
#> 4        59 0.006059896  5.921854  7.869574    -0.6899429     0.6439467  1
#> 5        60 0.018055526  8.928898 10.211722    -0.6204761     0.5791110  1
#> 6        98 0.009384629 15.714769 14.887706     0.6635654    -0.6193277  2
...
```

The columns in `tb` are:

1. `which_row`: row indices corresponding to the input matrix.
2. `fdr`: FDR for the differential test. 
3. `mean_x`: The mean value in group x.
4. `scaled_mean_x`: The mean value in group x after rows are scaled.
5. `km`: Row groups if k-means clustering is applied to rows (which is done by automatically selecting number of clusters).

If there are too many signatures, `top_signatures = ...` can be set to only show the 
signatures with the highest FDRs:

``` r
# code only for demonstration
# e.g. to show the top 500 most significant rows
tb = get_signature(res, k = ..., top_signatures = 500)
```

If the signatures are defined as these which are uniquely high in current group, `diff_method` argument
can be set to `"uniquely_high_in_one_group"`:

``` r
# code only for demonstration
tb = get_signature(res, k = ..., diff_method = "uniquely_high_in_one_group")
```




UMAP plot which shows how samples are separated.


<script>
$( function() {
	$( '#tabs-SD-hclust-dimension-reduction' ).tabs();
} );
</script>
<div id='tabs-SD-hclust-dimension-reduction'>
<ul>
<li><a href='#tab-SD-hclust-dimension-reduction-1'>k = 2</a></li>
<li><a href='#tab-SD-hclust-dimension-reduction-2'>k = 3</a></li>
<li><a href='#tab-SD-hclust-dimension-reduction-3'>k = 4</a></li>
<li><a href='#tab-SD-hclust-dimension-reduction-4'>k = 5</a></li>
<li><a href='#tab-SD-hclust-dimension-reduction-5'>k = 6</a></li>
</ul>
<div id='tab-SD-hclust-dimension-reduction-1'>
<pre><code class="language-r">dimension_reduction(res, k = 2, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-SD-hclust-dimension-reduction-1-1.png" alt="plot of chunk tab-SD-hclust-dimension-reduction-1" /></p>

</div>
<div id='tab-SD-hclust-dimension-reduction-2'>
<pre><code class="language-r">dimension_reduction(res, k = 3, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-SD-hclust-dimension-reduction-2-1.png" alt="plot of chunk tab-SD-hclust-dimension-reduction-2" /></p>

</div>
<div id='tab-SD-hclust-dimension-reduction-3'>
<pre><code class="language-r">dimension_reduction(res, k = 4, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-SD-hclust-dimension-reduction-3-1.png" alt="plot of chunk tab-SD-hclust-dimension-reduction-3" /></p>

</div>
<div id='tab-SD-hclust-dimension-reduction-4'>
<pre><code class="language-r">dimension_reduction(res, k = 5, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-SD-hclust-dimension-reduction-4-1.png" alt="plot of chunk tab-SD-hclust-dimension-reduction-4" /></p>

</div>
<div id='tab-SD-hclust-dimension-reduction-5'>
<pre><code class="language-r">dimension_reduction(res, k = 6, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-SD-hclust-dimension-reduction-5-1.png" alt="plot of chunk tab-SD-hclust-dimension-reduction-5" /></p>

</div>
</div>



Following heatmap shows how subgroups are split when increasing `k`:

``` r
collect_classes(res)
```

![plot of chunk SD-hclust-collect-classes](figure_cola/SD-hclust-collect-classes-1.png)



If matrix rows can be associated to genes, consider to use `functional_enrichment(res,
...)` to perform function enrichment for the signature genes. See [this vignette](https://jokergoo.github.io/cola_vignettes/functional_enrichment.html) for more detailed explanations.


 

---------------------------------------------------



### SD:kmeans






The object with results only for a single top-value method and a single partitioning method 
can be extracted as:

``` r
res = res_list["SD", "kmeans"]
# you can also extract it by
# res = res_list["SD:kmeans"]
```

A summary of `res` and all the functions that can be applied to it:

``` r
res
```

```
#> A 'ConsensusPartition' object with k = 2, 3, 4, 5, 6.
#>   On a matrix with 1900 rows and 60 columns.
#>   Top rows (123) are extracted by 'SD' method.
#>   Subgroups are detected by 'kmeans' method.
#>   Performed in total 250 partitions by row resampling.
#>   Best k for subgroups seems to be 2.
#> 
#> Following methods can be applied to this 'ConsensusPartition' object:
#>  [1] "cola_report"             "collect_classes"         "collect_plots"          
#>  [4] "collect_stats"           "colnames"                "compare_partitions"     
#>  [7] "compare_signatures"      "consensus_heatmap"       "dimension_reduction"    
#> [10] "functional_enrichment"   "get_anno_col"            "get_anno"               
#> [13] "get_classes"             "get_consensus"           "get_matrix"             
#> [16] "get_membership"          "get_param"               "get_signatures"         
#> [19] "get_stats"               "is_best_k"               "is_stable_k"            
#> [22] "membership_heatmap"      "ncol"                    "nrow"                   
#> [25] "plot_ecdf"               "predict_classes"         "rownames"               
#> [28] "select_partition_number" "show"                    "suggest_best_k"         
#> [31] "test_to_known_factors"   "top_rows_heatmap"
```

`collect_plots()` function collects all the plots made from `res` for all `k` (number of subgroups)
into one single page to provide an easy and fast comparison between different `k`.

``` r
collect_plots(res)
```

![plot of chunk SD-kmeans-collect-plots](figure_cola/SD-kmeans-collect-plots-1.png)

The plots are:

- The first row: a plot of the eCDF (empirical cumulative distribution
  function) curves of the consensus matrix for each `k` and the heatmap of
  predicted classes for each `k`.
- The second row: heatmaps of the consensus matrix for each `k`.
- The third row: heatmaps of the membership matrix for each `k`.
- The fouth row: heatmaps of the signatures for each `k`.

All the plots in panels can be made by individual functions and they are
plotted later in this section.

`select_partition_number()` produces several plots showing different
statistics for choosing "optimized" `k`. There are following statistics:

- eCDF curves of the consensus matrix for each `k`;
- 1-PAC. [The PAC score](https://en.wikipedia.org/wiki/Consensus_clustering#Over-interpretation_potential_of_consensus_clustering)
  measures the proportion of the ambiguous subgrouping.
- Mean silhouette score.
- Concordance. The mean probability of fiting the consensus subgroup labels in all
  partitions.
- Area increased. Denote $A_k$ as the area under the eCDF curve for current
  `k`, the area increased is defined as $A_k - A_{k-1}$.
- Rand index. The percent of pairs of samples that are both in a same cluster
  or both are not in a same cluster in the partition of k and k-1.
- Jaccard index. The ratio of pairs of samples are both in a same cluster in
  the partition of k and k-1 and the pairs of samples are both in a same
  cluster in the partition k or k-1.

The detailed explanations of these statistics can be found in [the _cola_
vignette](https://jokergoo.github.io/cola_vignettes/cola.html#toc_13).

Generally speaking, higher 1-PAC score, higher mean silhouette score or higher
concordance corresponds to better partition. Rand index and Jaccard index
measure how similar the current partition is compared to partition with `k-1`.
If they are too similar, we won't accept `k` is better than `k-1`.

``` r
select_partition_number(res)
```

![plot of chunk SD-kmeans-select-partition-number](figure_cola/SD-kmeans-select-partition-number-1.png)

The numeric values for all these statistics can be obtained by `get_stats()`.

``` r
get_stats(res)
```

```
#>   k 1-PAC mean_silhouette concordance area_increased  Rand Jaccard
#> 2 2 0.737           0.894       0.953         0.5048 0.492   0.492
#> 3 3 0.519           0.691       0.832         0.3153 0.718   0.486
#> 4 4 0.590           0.645       0.801         0.1220 0.866   0.621
#> 5 5 0.635           0.594       0.657         0.0637 0.892   0.646
#> 6 6 0.660           0.537       0.687         0.0439 0.886   0.571
```

`suggest_best_k()` suggests the best $k$ based on these statistics. The rules are as follows:

- All $k$ with Jaccard index larger than 0.95 are removed because increasing
  $k$ does not provide enough extra information. If all $k$ are removed, it is
  marked as no subgroup is detected.
- For all $k$ with 1-PAC score larger than 0.9, the maximal $k$ is taken as
  the best $k$, and other $k$ are marked as optional $k$.
- If it does not fit the second rule. The $k$ with the maximal vote of the
  highest 1-PAC score, highest mean silhouette, and highest concordance is
  taken as the best $k$.

``` r
suggest_best_k(res)
```

```
#> [1] 2
```


Following is the table of the partitions (You need to click the **show/hide
code output** link to see it). The membership matrix (columns with name `p*`)
is inferred by
[`clue::cl_consensus()`](https://www.rdocumentation.org/link/cl_consensus?package=clue)
function with the `SE` method. Basically the value in the membership matrix
represents the probability to belong to a certain group. The finall subgroup
label for an item is determined with the group with highest probability it
belongs to.

In `get_classes()` function, the entropy is calculated from the membership
matrix and the silhouette score is calculated from the consensus matrix.



<script>
$( function() {
	$( '#tabs-SD-kmeans-get-classes' ).tabs();
} );
</script>
<div id='tabs-SD-kmeans-get-classes'>
<ul>
<li><a href='#tab-SD-kmeans-get-classes-1'>k = 2</a></li>
<li><a href='#tab-SD-kmeans-get-classes-2'>k = 3</a></li>
<li><a href='#tab-SD-kmeans-get-classes-3'>k = 4</a></li>
<li><a href='#tab-SD-kmeans-get-classes-4'>k = 5</a></li>
<li><a href='#tab-SD-kmeans-get-classes-5'>k = 6</a></li>
</ul>

<div id='tab-SD-kmeans-get-classes-1'>
<p><a id='tab-SD-kmeans-get-classes-1-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 2), get_membership(res, k = 2))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2
#&gt; SIH013     1   0.680      0.789 0.82 0.18
#&gt; SIH014     2   0.000      0.945 0.00 1.00
#&gt; SIH024     1   0.760      0.730 0.78 0.22
#&gt; SIH028     2   0.000      0.945 0.00 1.00
#&gt; SIH031     1   0.141      0.940 0.98 0.02
#&gt; SIH042     1   0.000      0.951 1.00 0.00
#&gt; SIH107     2   0.000      0.945 0.00 1.00
#&gt; SIH114     1   0.000      0.951 1.00 0.00
#&gt; SIH116     2   0.925      0.500 0.34 0.66
#&gt; SIH117     2   0.634      0.791 0.16 0.84
#&gt; SIH130     2   0.000      0.945 0.00 1.00
#&gt; SIH134     2   0.000      0.945 0.00 1.00
#&gt; SIH186     2   0.000      0.945 0.00 1.00
#&gt; SIH191     1   0.000      0.951 1.00 0.00
#&gt; SIH192     2   0.000      0.945 0.00 1.00
#&gt; SIH196     2   0.000      0.945 0.00 1.00
#&gt; SIH214     2   0.000      0.945 0.00 1.00
#&gt; SIH218     2   0.904      0.538 0.32 0.68
#&gt; SIH232     1   0.000      0.951 1.00 0.00
#&gt; SIH236     1   0.242      0.924 0.96 0.04
#&gt; SIH238     1   0.000      0.951 1.00 0.00
#&gt; SIH241     2   0.000      0.945 0.00 1.00
#&gt; SIH245     2   0.000      0.945 0.00 1.00
#&gt; SIH260     2   0.141      0.931 0.02 0.98
#&gt; SIH287     2   0.000      0.945 0.00 1.00
#&gt; SIH289     2   0.141      0.930 0.02 0.98
#&gt; SIH290     2   0.000      0.945 0.00 1.00
#&gt; SIH295     1   0.000      0.951 1.00 0.00
#&gt; SIH366     1   0.000      0.951 1.00 0.00
#&gt; SIH377     1   0.000      0.951 1.00 0.00
#&gt; SIH380     2   0.000      0.945 0.00 1.00
#&gt; SIH385     2   0.000      0.945 0.00 1.00
#&gt; SIH389     2   0.000      0.945 0.00 1.00
#&gt; SIH391     2   0.141      0.931 0.02 0.98
#&gt; SIH403     1   0.000      0.951 1.00 0.00
#&gt; SIH411     2   0.000      0.945 0.00 1.00
#&gt; SIH427     1   0.000      0.951 1.00 0.00
#&gt; SIH433     2   0.855      0.614 0.28 0.72
#&gt; SIH439     1   0.141      0.940 0.98 0.02
#&gt; SIH442     1   0.000      0.951 1.00 0.00
#&gt; SIH444     1   0.634      0.817 0.84 0.16
#&gt; SIH452     2   0.000      0.945 0.00 1.00
#&gt; SIH461     1   0.000      0.951 1.00 0.00
#&gt; SIH471     1   0.000      0.951 1.00 0.00
#&gt; SIH472     2   0.000      0.945 0.00 1.00
#&gt; SIH481     1   0.000      0.951 1.00 0.00
#&gt; SIH485     2   0.000      0.945 0.00 1.00
#&gt; SIH491     2   0.000      0.945 0.00 1.00
#&gt; SIH508     1   0.000      0.951 1.00 0.00
#&gt; SIH559     1   0.000      0.951 1.00 0.00
#&gt; SIH587     1   0.000      0.951 1.00 0.00
#&gt; SIH625     2   0.000      0.945 0.00 1.00
#&gt; SIH641     1   0.000      0.951 1.00 0.00
#&gt; SIH643     1   0.634      0.816 0.84 0.16
#&gt; SIH674     1   0.000      0.951 1.00 0.00
#&gt; SIH678     1   0.000      0.951 1.00 0.00
#&gt; SIH679     1   0.469      0.873 0.90 0.10
#&gt; SIH689     2   0.958      0.392 0.38 0.62
#&gt; SIH694     2   0.000      0.945 0.00 1.00
#&gt; SIH721     1   0.943      0.445 0.64 0.36
</code></pre>

<script>
$('#tab-SD-kmeans-get-classes-1-a').parent().next().next().hide();
$('#tab-SD-kmeans-get-classes-1-a').click(function(){
  $('#tab-SD-kmeans-get-classes-1-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-SD-kmeans-get-classes-2'>
<p><a id='tab-SD-kmeans-get-classes-2-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 3), get_membership(res, k = 3))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3
#&gt; SIH013     3  0.4796     0.6126 0.22 0.00 0.78
#&gt; SIH014     3  0.3686     0.6102 0.00 0.14 0.86
#&gt; SIH024     3  0.2537     0.7107 0.08 0.00 0.92
#&gt; SIH028     3  0.6045     0.0376 0.00 0.38 0.62
#&gt; SIH031     3  0.5560     0.4904 0.30 0.00 0.70
#&gt; SIH042     1  0.0892     0.8918 0.98 0.00 0.02
#&gt; SIH107     2  0.4002     0.7934 0.00 0.84 0.16
#&gt; SIH114     1  0.0000     0.8887 1.00 0.00 0.00
#&gt; SIH116     2  0.4862     0.6004 0.16 0.82 0.02
#&gt; SIH117     3  0.2414     0.6906 0.02 0.04 0.94
#&gt; SIH130     2  0.5835     0.6989 0.00 0.66 0.34
#&gt; SIH134     2  0.5835     0.6989 0.00 0.66 0.34
#&gt; SIH186     2  0.4291     0.7949 0.00 0.82 0.18
#&gt; SIH191     1  0.0000     0.8887 1.00 0.00 0.00
#&gt; SIH192     2  0.5016     0.7367 0.00 0.76 0.24
#&gt; SIH196     2  0.5397     0.7526 0.00 0.72 0.28
#&gt; SIH214     3  0.5216     0.4106 0.00 0.26 0.74
#&gt; SIH218     3  0.8137     0.5745 0.14 0.22 0.64
#&gt; SIH232     1  0.2537     0.8872 0.92 0.00 0.08
#&gt; SIH236     1  0.6758     0.4723 0.62 0.36 0.02
#&gt; SIH238     3  0.6302     0.1952 0.48 0.00 0.52
#&gt; SIH241     3  0.3686     0.6102 0.00 0.14 0.86
#&gt; SIH245     2  0.5560     0.7410 0.00 0.70 0.30
#&gt; SIH260     2  0.2414     0.7197 0.04 0.94 0.02
#&gt; SIH287     2  0.0000     0.7533 0.00 1.00 0.00
#&gt; SIH289     2  0.2947     0.7021 0.06 0.92 0.02
#&gt; SIH290     2  0.5560     0.7410 0.00 0.70 0.30
#&gt; SIH295     1  0.2066     0.8925 0.94 0.00 0.06
#&gt; SIH366     1  0.2066     0.8922 0.94 0.00 0.06
#&gt; SIH377     1  0.2537     0.8872 0.92 0.00 0.08
#&gt; SIH380     2  0.6192     0.5633 0.00 0.58 0.42
#&gt; SIH385     3  0.3340     0.6259 0.00 0.12 0.88
#&gt; SIH389     2  0.4291     0.7949 0.00 0.82 0.18
#&gt; SIH391     2  0.0892     0.7473 0.00 0.98 0.02
#&gt; SIH403     1  0.3340     0.8586 0.88 0.00 0.12
#&gt; SIH411     2  0.4796     0.7836 0.00 0.78 0.22
#&gt; SIH427     1  0.0000     0.8887 1.00 0.00 0.00
#&gt; SIH433     3  0.1781     0.6984 0.02 0.02 0.96
#&gt; SIH439     3  0.6280     0.1508 0.46 0.00 0.54
#&gt; SIH442     1  0.2959     0.8829 0.90 0.00 0.10
#&gt; SIH444     3  0.4002     0.6761 0.16 0.00 0.84
#&gt; SIH452     2  0.0892     0.7473 0.00 0.98 0.02
#&gt; SIH461     3  0.4796     0.6126 0.22 0.00 0.78
#&gt; SIH471     1  0.0892     0.8919 0.98 0.00 0.02
#&gt; SIH472     2  0.4291     0.7949 0.00 0.82 0.18
#&gt; SIH481     1  0.2959     0.8829 0.90 0.00 0.10
#&gt; SIH485     3  0.4002     0.5864 0.00 0.16 0.84
#&gt; SIH491     3  0.6192    -0.1231 0.00 0.42 0.58
#&gt; SIH508     1  0.2959     0.8829 0.90 0.00 0.10
#&gt; SIH559     1  0.0892     0.8919 0.98 0.00 0.02
#&gt; SIH587     1  0.0000     0.8887 1.00 0.00 0.00
#&gt; SIH625     2  0.0892     0.7473 0.00 0.98 0.02
#&gt; SIH641     1  0.5560     0.5829 0.70 0.00 0.30
#&gt; SIH643     3  0.3686     0.6930 0.14 0.00 0.86
#&gt; SIH674     1  0.2959     0.8829 0.90 0.00 0.10
#&gt; SIH678     1  0.0892     0.8919 0.98 0.00 0.02
#&gt; SIH679     1  0.5835     0.5283 0.66 0.34 0.00
#&gt; SIH689     3  0.2947     0.7105 0.06 0.02 0.92
#&gt; SIH694     2  0.6045     0.6418 0.00 0.62 0.38
#&gt; SIH721     3  0.2414     0.7074 0.04 0.02 0.94
</code></pre>

<script>
$('#tab-SD-kmeans-get-classes-2-a').parent().next().next().hide();
$('#tab-SD-kmeans-get-classes-2-a').click(function(){
  $('#tab-SD-kmeans-get-classes-2-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-SD-kmeans-get-classes-3'>
<p><a id='tab-SD-kmeans-get-classes-3-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 4), get_membership(res, k = 4))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3   p4
#&gt; SIH013     3  0.1913     0.7415 0.02 0.00 0.94 0.04
#&gt; SIH014     3  0.5570     0.3159 0.00 0.44 0.54 0.02
#&gt; SIH024     3  0.2411     0.7508 0.04 0.04 0.92 0.00
#&gt; SIH028     2  0.6382     0.1678 0.00 0.58 0.34 0.08
#&gt; SIH031     3  0.5151     0.6350 0.14 0.00 0.76 0.10
#&gt; SIH042     1  0.3335     0.8156 0.86 0.00 0.02 0.12
#&gt; SIH107     2  0.5062     0.3192 0.00 0.68 0.02 0.30
#&gt; SIH114     1  0.4755     0.7806 0.76 0.00 0.04 0.20
#&gt; SIH116     4  0.3037     0.6945 0.02 0.10 0.00 0.88
#&gt; SIH117     3  0.2830     0.7439 0.00 0.06 0.90 0.04
#&gt; SIH130     2  0.2345     0.7391 0.00 0.90 0.10 0.00
#&gt; SIH134     2  0.2345     0.7391 0.00 0.90 0.10 0.00
#&gt; SIH186     2  0.3606     0.6044 0.00 0.84 0.02 0.14
#&gt; SIH191     1  0.4088     0.8040 0.82 0.00 0.04 0.14
#&gt; SIH192     2  0.7121     0.2286 0.00 0.54 0.16 0.30
#&gt; SIH196     2  0.1411     0.7339 0.00 0.96 0.02 0.02
#&gt; SIH214     3  0.5957     0.3353 0.00 0.42 0.54 0.04
#&gt; SIH218     3  0.6910     0.3812 0.04 0.04 0.54 0.38
#&gt; SIH232     1  0.0707     0.8422 0.98 0.00 0.02 0.00
#&gt; SIH236     4  0.3853     0.5375 0.16 0.00 0.02 0.82
#&gt; SIH238     3  0.6320     0.4589 0.18 0.00 0.66 0.16
#&gt; SIH241     3  0.5987     0.2721 0.00 0.44 0.52 0.04
#&gt; SIH245     2  0.1211     0.7486 0.00 0.96 0.04 0.00
#&gt; SIH260     4  0.4277     0.7657 0.00 0.28 0.00 0.72
#&gt; SIH287     4  0.4406     0.7472 0.00 0.30 0.00 0.70
#&gt; SIH289     4  0.4277     0.7657 0.00 0.28 0.00 0.72
#&gt; SIH290     2  0.1211     0.7486 0.00 0.96 0.04 0.00
#&gt; SIH295     1  0.0707     0.8422 0.98 0.00 0.02 0.00
#&gt; SIH366     1  0.1411     0.8356 0.96 0.00 0.02 0.02
#&gt; SIH377     1  0.0707     0.8422 0.98 0.00 0.02 0.00
#&gt; SIH380     2  0.3172     0.6906 0.00 0.84 0.16 0.00
#&gt; SIH385     3  0.4936     0.5731 0.00 0.28 0.70 0.02
#&gt; SIH389     2  0.4797     0.4177 0.00 0.72 0.02 0.26
#&gt; SIH391     4  0.4277     0.7114 0.00 0.28 0.00 0.72
#&gt; SIH403     1  0.4079     0.7265 0.80 0.00 0.18 0.02
#&gt; SIH411     2  0.0000     0.7309 0.00 1.00 0.00 0.00
#&gt; SIH427     1  0.4332     0.7960 0.80 0.00 0.04 0.16
#&gt; SIH433     3  0.1913     0.7502 0.02 0.04 0.94 0.00
#&gt; SIH439     1  0.6299     0.0843 0.52 0.00 0.42 0.06
#&gt; SIH442     1  0.0707     0.8422 0.98 0.00 0.02 0.00
#&gt; SIH444     3  0.3198     0.7317 0.08 0.00 0.88 0.04
#&gt; SIH452     4  0.4277     0.7657 0.00 0.28 0.00 0.72
#&gt; SIH461     3  0.2335     0.7470 0.06 0.02 0.92 0.00
#&gt; SIH471     1  0.3821     0.8116 0.84 0.00 0.04 0.12
#&gt; SIH472     2  0.4472     0.4982 0.00 0.76 0.02 0.22
#&gt; SIH481     1  0.0707     0.8422 0.98 0.00 0.02 0.00
#&gt; SIH485     3  0.5606     0.2174 0.00 0.48 0.50 0.02
#&gt; SIH491     2  0.4079     0.6429 0.00 0.80 0.18 0.02
#&gt; SIH508     1  0.0707     0.8422 0.98 0.00 0.02 0.00
#&gt; SIH559     1  0.4491     0.7971 0.80 0.00 0.06 0.14
#&gt; SIH587     1  0.4755     0.7785 0.76 0.00 0.04 0.20
#&gt; SIH625     4  0.4277     0.7657 0.00 0.28 0.00 0.72
#&gt; SIH641     1  0.6605     0.2987 0.48 0.00 0.44 0.08
#&gt; SIH643     3  0.2335     0.7434 0.06 0.00 0.92 0.02
#&gt; SIH674     1  0.0707     0.8422 0.98 0.00 0.02 0.00
#&gt; SIH678     1  0.4088     0.8032 0.82 0.00 0.04 0.14
#&gt; SIH679     4  0.5883     0.1579 0.30 0.00 0.06 0.64
#&gt; SIH689     3  0.2335     0.7463 0.00 0.06 0.92 0.02
#&gt; SIH694     2  0.3606     0.6905 0.00 0.84 0.14 0.02
#&gt; SIH721     3  0.2706     0.7346 0.00 0.08 0.90 0.02
</code></pre>

<script>
$('#tab-SD-kmeans-get-classes-3-a').parent().next().next().hide();
$('#tab-SD-kmeans-get-classes-3-a').click(function(){
  $('#tab-SD-kmeans-get-classes-3-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-SD-kmeans-get-classes-4'>
<p><a id='tab-SD-kmeans-get-classes-4-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 5), get_membership(res, k = 5))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3   p4   p5
#&gt; SIH013     3  0.1732     0.7271 0.00 0.00 0.92 0.00 0.08
#&gt; SIH014     2  0.6530     0.1511 0.00 0.44 0.36 0.00 0.20
#&gt; SIH024     3  0.2754     0.7119 0.00 0.08 0.88 0.00 0.04
#&gt; SIH028     2  0.6610     0.2744 0.00 0.46 0.26 0.00 0.28
#&gt; SIH031     3  0.4527     0.6768 0.08 0.00 0.78 0.02 0.12
#&gt; SIH042     1  0.4818     0.7117 0.72 0.00 0.00 0.10 0.18
#&gt; SIH107     2  0.6254     0.1605 0.00 0.50 0.00 0.34 0.16
#&gt; SIH114     1  0.5305     0.7453 0.64 0.00 0.02 0.04 0.30
#&gt; SIH116     4  0.3110     0.7473 0.00 0.06 0.00 0.86 0.08
#&gt; SIH117     3  0.2331     0.7205 0.00 0.02 0.90 0.00 0.08
#&gt; SIH130     2  0.2754     0.6382 0.00 0.88 0.04 0.00 0.08
#&gt; SIH134     2  0.2077     0.6392 0.00 0.92 0.04 0.00 0.04
#&gt; SIH186     2  0.5961     0.3055 0.00 0.58 0.00 0.26 0.16
#&gt; SIH191     1  0.4644     0.7615 0.68 0.00 0.00 0.04 0.28
#&gt; SIH192     4  0.7862     0.1515 0.00 0.28 0.16 0.44 0.12
#&gt; SIH196     2  0.3694     0.6214 0.00 0.82 0.02 0.02 0.14
#&gt; SIH214     2  0.6837     0.1967 0.00 0.44 0.38 0.02 0.16
#&gt; SIH218     3  0.6200     0.4471 0.00 0.00 0.52 0.16 0.32
#&gt; SIH232     1  0.0609     0.8111 0.98 0.00 0.00 0.00 0.02
#&gt; SIH236     4  0.4433     0.6255 0.06 0.00 0.00 0.74 0.20
#&gt; SIH238     3  0.5890     0.5566 0.08 0.00 0.60 0.02 0.30
#&gt; SIH241     2  0.6619     0.0686 0.00 0.42 0.36 0.00 0.22
#&gt; SIH245     2  0.1648     0.6305 0.00 0.94 0.00 0.02 0.04
#&gt; SIH260     4  0.2020     0.7804 0.00 0.10 0.00 0.90 0.00
#&gt; SIH287     4  0.2732     0.7518 0.00 0.16 0.00 0.84 0.00
#&gt; SIH289     4  0.1732     0.7817 0.00 0.08 0.00 0.92 0.00
#&gt; SIH290     2  0.1216     0.6351 0.00 0.96 0.00 0.02 0.02
#&gt; SIH295     1  0.0609     0.8168 0.98 0.00 0.00 0.00 0.02
#&gt; SIH366     1  0.3521     0.7509 0.82 0.00 0.00 0.04 0.14
#&gt; SIH377     1  0.1648     0.8117 0.94 0.00 0.02 0.00 0.04
#&gt; SIH380     2  0.2012     0.6464 0.00 0.92 0.06 0.00 0.02
#&gt; SIH385     3  0.5607     0.1753 0.00 0.38 0.54 0.00 0.08
#&gt; SIH389     2  0.6133     0.2276 0.00 0.54 0.00 0.30 0.16
#&gt; SIH391     4  0.3291     0.7360 0.00 0.04 0.00 0.84 0.12
#&gt; SIH403     1  0.4854     0.5717 0.68 0.00 0.26 0.00 0.06
#&gt; SIH411     2  0.1732     0.6163 0.00 0.92 0.00 0.00 0.08
#&gt; SIH427     1  0.4748     0.7531 0.66 0.00 0.00 0.04 0.30
#&gt; SIH433     3  0.2077     0.7178 0.00 0.04 0.92 0.00 0.04
#&gt; SIH439     3  0.7589     0.2209 0.32 0.00 0.34 0.04 0.30
#&gt; SIH442     1  0.1216     0.8074 0.96 0.00 0.02 0.00 0.02
#&gt; SIH444     3  0.4096     0.6759 0.00 0.04 0.76 0.00 0.20
#&gt; SIH452     4  0.2331     0.7784 0.00 0.08 0.00 0.90 0.02
#&gt; SIH461     3  0.2438     0.7227 0.00 0.04 0.90 0.00 0.06
#&gt; SIH471     1  0.3274     0.7927 0.78 0.00 0.00 0.00 0.22
#&gt; SIH472     2  0.6200     0.2034 0.00 0.52 0.00 0.32 0.16
#&gt; SIH481     1  0.2020     0.7933 0.90 0.00 0.00 0.00 0.10
#&gt; SIH485     2  0.6326     0.2098 0.00 0.46 0.38 0.00 0.16
#&gt; SIH491     2  0.3390     0.6266 0.00 0.84 0.06 0.00 0.10
#&gt; SIH508     1  0.1216     0.8074 0.96 0.00 0.02 0.00 0.02
#&gt; SIH559     1  0.4132     0.7737 0.72 0.00 0.02 0.00 0.26
#&gt; SIH587     1  0.4840     0.7469 0.64 0.00 0.00 0.04 0.32
#&gt; SIH625     4  0.2331     0.7784 0.00 0.08 0.00 0.90 0.02
#&gt; SIH641     3  0.6149     0.1313 0.36 0.00 0.50 0.00 0.14
#&gt; SIH643     3  0.2754     0.7147 0.00 0.04 0.88 0.00 0.08
#&gt; SIH674     1  0.1216     0.8074 0.96 0.00 0.02 0.00 0.02
#&gt; SIH678     1  0.4252     0.7744 0.70 0.00 0.02 0.00 0.28
#&gt; SIH679     4  0.6759     0.4067 0.12 0.04 0.00 0.52 0.32
#&gt; SIH689     3  0.2012     0.7228 0.00 0.02 0.92 0.00 0.06
#&gt; SIH694     2  0.3390     0.6312 0.00 0.84 0.06 0.00 0.10
#&gt; SIH721     3  0.3731     0.6466 0.00 0.16 0.80 0.00 0.04
</code></pre>

<script>
$('#tab-SD-kmeans-get-classes-4-a').parent().next().next().hide();
$('#tab-SD-kmeans-get-classes-4-a').click(function(){
  $('#tab-SD-kmeans-get-classes-4-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-SD-kmeans-get-classes-5'>
<p><a id='tab-SD-kmeans-get-classes-5-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 6), get_membership(res, k = 6))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3   p4   p5   p6
#&gt; SIH013     3  0.4318     0.6805 0.06 0.06 0.80 0.00 0.04 0.04
#&gt; SIH014     2  0.3592     0.3925 0.00 0.74 0.24 0.00 0.02 0.00
#&gt; SIH024     3  0.4740     0.6558 0.04 0.12 0.76 0.00 0.04 0.04
#&gt; SIH028     2  0.5256     0.4884 0.00 0.68 0.06 0.00 0.08 0.18
#&gt; SIH031     3  0.7034     0.6004 0.12 0.22 0.52 0.00 0.12 0.02
#&gt; SIH042     5  0.4764     0.4123 0.42 0.00 0.00 0.02 0.54 0.02
#&gt; SIH107     6  0.3409     0.7178 0.00 0.00 0.00 0.30 0.00 0.70
#&gt; SIH114     1  0.2725     0.6083 0.88 0.04 0.02 0.00 0.06 0.00
#&gt; SIH116     4  0.1556     0.7555 0.08 0.00 0.00 0.92 0.00 0.00
#&gt; SIH117     3  0.4784     0.6449 0.00 0.08 0.74 0.00 0.10 0.08
#&gt; SIH130     2  0.3578     0.5251 0.00 0.66 0.00 0.00 0.00 0.34
#&gt; SIH134     2  0.4892     0.4062 0.00 0.50 0.06 0.00 0.00 0.44
#&gt; SIH186     6  0.3679     0.7448 0.00 0.04 0.00 0.20 0.00 0.76
#&gt; SIH191     1  0.2981     0.5470 0.82 0.00 0.00 0.00 0.16 0.02
#&gt; SIH192     4  0.7924     0.0638 0.00 0.10 0.08 0.44 0.16 0.22
#&gt; SIH196     2  0.4199     0.5035 0.00 0.60 0.02 0.00 0.00 0.38
#&gt; SIH214     2  0.3592     0.4054 0.00 0.74 0.24 0.02 0.00 0.00
#&gt; SIH218     3  0.8902     0.3654 0.18 0.28 0.28 0.08 0.16 0.02
#&gt; SIH232     5  0.3578     0.7340 0.34 0.00 0.00 0.00 0.66 0.00
#&gt; SIH236     4  0.4420     0.4954 0.30 0.00 0.00 0.66 0.02 0.02
#&gt; SIH238     3  0.7531     0.3708 0.32 0.18 0.38 0.00 0.10 0.02
#&gt; SIH241     2  0.6138     0.4200 0.00 0.60 0.10 0.00 0.12 0.18
#&gt; SIH245     2  0.4806     0.2983 0.00 0.48 0.00 0.02 0.02 0.48
#&gt; SIH260     4  0.0547     0.7783 0.02 0.00 0.00 0.98 0.00 0.00
#&gt; SIH287     4  0.1092     0.7656 0.00 0.02 0.00 0.96 0.00 0.02
#&gt; SIH289     4  0.1807     0.7710 0.00 0.02 0.00 0.92 0.00 0.06
#&gt; SIH290     2  0.4801     0.3423 0.00 0.50 0.00 0.02 0.02 0.46
#&gt; SIH295     5  0.4246     0.6453 0.40 0.00 0.00 0.00 0.58 0.02
#&gt; SIH366     5  0.4554     0.6271 0.20 0.04 0.00 0.00 0.72 0.04
#&gt; SIH377     5  0.4199     0.6797 0.38 0.00 0.00 0.00 0.60 0.02
#&gt; SIH380     2  0.4845     0.4525 0.00 0.54 0.06 0.00 0.00 0.40
#&gt; SIH385     2  0.5087     0.0957 0.00 0.52 0.42 0.00 0.04 0.02
#&gt; SIH389     6  0.4067     0.7669 0.00 0.04 0.00 0.26 0.00 0.70
#&gt; SIH391     4  0.5015     0.6525 0.00 0.02 0.02 0.72 0.10 0.14
#&gt; SIH403     5  0.6331     0.3243 0.32 0.06 0.12 0.00 0.50 0.00
#&gt; SIH411     6  0.4845    -0.2036 0.00 0.40 0.00 0.06 0.00 0.54
#&gt; SIH427     1  0.2260     0.5873 0.86 0.00 0.00 0.00 0.14 0.00
#&gt; SIH433     3  0.3045     0.6658 0.00 0.06 0.86 0.00 0.02 0.06
#&gt; SIH439     5  0.5139     0.3566 0.02 0.14 0.08 0.00 0.72 0.04
#&gt; SIH442     5  0.3499     0.7409 0.32 0.00 0.00 0.00 0.68 0.00
#&gt; SIH444     3  0.6307     0.5767 0.00 0.14 0.58 0.00 0.18 0.10
#&gt; SIH452     4  0.2725     0.7560 0.00 0.02 0.00 0.88 0.04 0.06
#&gt; SIH461     3  0.4523     0.6656 0.04 0.10 0.78 0.00 0.04 0.04
#&gt; SIH471     1  0.3315     0.5158 0.78 0.00 0.00 0.00 0.20 0.02
#&gt; SIH472     6  0.3198     0.7698 0.00 0.00 0.00 0.26 0.00 0.74
#&gt; SIH481     5  0.3409     0.7406 0.30 0.00 0.00 0.00 0.70 0.00
#&gt; SIH485     2  0.3315     0.4509 0.00 0.78 0.20 0.00 0.00 0.02
#&gt; SIH491     2  0.4971     0.5116 0.00 0.58 0.02 0.00 0.04 0.36
#&gt; SIH508     5  0.3409     0.7419 0.30 0.00 0.00 0.00 0.70 0.00
#&gt; SIH559     1  0.3942     0.5244 0.80 0.04 0.06 0.00 0.10 0.00
#&gt; SIH587     1  0.1267     0.6337 0.94 0.00 0.00 0.00 0.06 0.00
#&gt; SIH625     4  0.2020     0.7702 0.00 0.02 0.00 0.92 0.02 0.04
#&gt; SIH641     3  0.7160     0.1982 0.32 0.04 0.46 0.00 0.08 0.10
#&gt; SIH643     3  0.4306     0.6595 0.00 0.12 0.76 0.00 0.10 0.02
#&gt; SIH674     5  0.3499     0.7409 0.32 0.00 0.00 0.00 0.68 0.00
#&gt; SIH678     1  0.4162     0.4987 0.78 0.04 0.06 0.00 0.12 0.00
#&gt; SIH679     1  0.5574    -0.1733 0.48 0.00 0.02 0.44 0.02 0.04
#&gt; SIH689     3  0.4008     0.6599 0.00 0.06 0.80 0.00 0.06 0.08
#&gt; SIH694     2  0.3916     0.5365 0.00 0.68 0.02 0.00 0.00 0.30
#&gt; SIH721     3  0.5706     0.5286 0.06 0.26 0.62 0.00 0.02 0.04
</code></pre>

<script>
$('#tab-SD-kmeans-get-classes-5-a').parent().next().next().hide();
$('#tab-SD-kmeans-get-classes-5-a').click(function(){
  $('#tab-SD-kmeans-get-classes-5-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>
</div>

Heatmaps for the consensus matrix. It visualizes the probability of two
samples to be in a same group.




<script>
$( function() {
	$( '#tabs-SD-kmeans-consensus-heatmap' ).tabs();
} );
</script>
<div id='tabs-SD-kmeans-consensus-heatmap'>
<ul>
<li><a href='#tab-SD-kmeans-consensus-heatmap-1'>k = 2</a></li>
<li><a href='#tab-SD-kmeans-consensus-heatmap-2'>k = 3</a></li>
<li><a href='#tab-SD-kmeans-consensus-heatmap-3'>k = 4</a></li>
<li><a href='#tab-SD-kmeans-consensus-heatmap-4'>k = 5</a></li>
<li><a href='#tab-SD-kmeans-consensus-heatmap-5'>k = 6</a></li>
</ul>
<div id='tab-SD-kmeans-consensus-heatmap-1'>
<pre><code class="language-r">consensus_heatmap(res, k = 2)
</code></pre>
<p><img src="figure_cola/tab-SD-kmeans-consensus-heatmap-1-1.png" alt="plot of chunk tab-SD-kmeans-consensus-heatmap-1" /></p>

</div>
<div id='tab-SD-kmeans-consensus-heatmap-2'>
<pre><code class="language-r">consensus_heatmap(res, k = 3)
</code></pre>
<p><img src="figure_cola/tab-SD-kmeans-consensus-heatmap-2-1.png" alt="plot of chunk tab-SD-kmeans-consensus-heatmap-2" /></p>

</div>
<div id='tab-SD-kmeans-consensus-heatmap-3'>
<pre><code class="language-r">consensus_heatmap(res, k = 4)
</code></pre>
<p><img src="figure_cola/tab-SD-kmeans-consensus-heatmap-3-1.png" alt="plot of chunk tab-SD-kmeans-consensus-heatmap-3" /></p>

</div>
<div id='tab-SD-kmeans-consensus-heatmap-4'>
<pre><code class="language-r">consensus_heatmap(res, k = 5)
</code></pre>
<p><img src="figure_cola/tab-SD-kmeans-consensus-heatmap-4-1.png" alt="plot of chunk tab-SD-kmeans-consensus-heatmap-4" /></p>

</div>
<div id='tab-SD-kmeans-consensus-heatmap-5'>
<pre><code class="language-r">consensus_heatmap(res, k = 6)
</code></pre>
<p><img src="figure_cola/tab-SD-kmeans-consensus-heatmap-5-1.png" alt="plot of chunk tab-SD-kmeans-consensus-heatmap-5" /></p>

</div>
</div>

Heatmaps for the membership of samples in all partitions to see how consistent they are:





<script>
$( function() {
	$( '#tabs-SD-kmeans-membership-heatmap' ).tabs();
} );
</script>
<div id='tabs-SD-kmeans-membership-heatmap'>
<ul>
<li><a href='#tab-SD-kmeans-membership-heatmap-1'>k = 2</a></li>
<li><a href='#tab-SD-kmeans-membership-heatmap-2'>k = 3</a></li>
<li><a href='#tab-SD-kmeans-membership-heatmap-3'>k = 4</a></li>
<li><a href='#tab-SD-kmeans-membership-heatmap-4'>k = 5</a></li>
<li><a href='#tab-SD-kmeans-membership-heatmap-5'>k = 6</a></li>
</ul>
<div id='tab-SD-kmeans-membership-heatmap-1'>
<pre><code class="language-r">membership_heatmap(res, k = 2)
</code></pre>
<p><img src="figure_cola/tab-SD-kmeans-membership-heatmap-1-1.png" alt="plot of chunk tab-SD-kmeans-membership-heatmap-1" /></p>

</div>
<div id='tab-SD-kmeans-membership-heatmap-2'>
<pre><code class="language-r">membership_heatmap(res, k = 3)
</code></pre>
<p><img src="figure_cola/tab-SD-kmeans-membership-heatmap-2-1.png" alt="plot of chunk tab-SD-kmeans-membership-heatmap-2" /></p>

</div>
<div id='tab-SD-kmeans-membership-heatmap-3'>
<pre><code class="language-r">membership_heatmap(res, k = 4)
</code></pre>
<p><img src="figure_cola/tab-SD-kmeans-membership-heatmap-3-1.png" alt="plot of chunk tab-SD-kmeans-membership-heatmap-3" /></p>

</div>
<div id='tab-SD-kmeans-membership-heatmap-4'>
<pre><code class="language-r">membership_heatmap(res, k = 5)
</code></pre>
<p><img src="figure_cola/tab-SD-kmeans-membership-heatmap-4-1.png" alt="plot of chunk tab-SD-kmeans-membership-heatmap-4" /></p>

</div>
<div id='tab-SD-kmeans-membership-heatmap-5'>
<pre><code class="language-r">membership_heatmap(res, k = 6)
</code></pre>
<p><img src="figure_cola/tab-SD-kmeans-membership-heatmap-5-1.png" alt="plot of chunk tab-SD-kmeans-membership-heatmap-5" /></p>

</div>
</div>

As soon as the classes for columns are determined, the signatures
that are significantly different between subgroups can be looked for. 
Following are the heatmaps for signatures.




Signature heatmaps where rows are scaled:



<script>
$( function() {
	$( '#tabs-SD-kmeans-get-signatures' ).tabs();
} );
</script>
<div id='tabs-SD-kmeans-get-signatures'>
<ul>
<li><a href='#tab-SD-kmeans-get-signatures-1'>k = 2</a></li>
<li><a href='#tab-SD-kmeans-get-signatures-2'>k = 3</a></li>
<li><a href='#tab-SD-kmeans-get-signatures-3'>k = 4</a></li>
<li><a href='#tab-SD-kmeans-get-signatures-4'>k = 5</a></li>
<li><a href='#tab-SD-kmeans-get-signatures-5'>k = 6</a></li>
</ul>
<div id='tab-SD-kmeans-get-signatures-1'>
<pre><code class="language-r">get_signatures(res, k = 2)
</code></pre>
<p><img src="figure_cola/tab-SD-kmeans-get-signatures-1-1.png" alt="plot of chunk tab-SD-kmeans-get-signatures-1" /></p>

</div>
<div id='tab-SD-kmeans-get-signatures-2'>
<pre><code class="language-r">get_signatures(res, k = 3)
</code></pre>
<p><img src="figure_cola/tab-SD-kmeans-get-signatures-2-1.png" alt="plot of chunk tab-SD-kmeans-get-signatures-2" /></p>

</div>
<div id='tab-SD-kmeans-get-signatures-3'>
<pre><code class="language-r">get_signatures(res, k = 4)
</code></pre>
<p><img src="figure_cola/tab-SD-kmeans-get-signatures-3-1.png" alt="plot of chunk tab-SD-kmeans-get-signatures-3" /></p>

</div>
<div id='tab-SD-kmeans-get-signatures-4'>
<pre><code class="language-r">get_signatures(res, k = 5)
</code></pre>
<p><img src="figure_cola/tab-SD-kmeans-get-signatures-4-1.png" alt="plot of chunk tab-SD-kmeans-get-signatures-4" /></p>

</div>
<div id='tab-SD-kmeans-get-signatures-5'>
<pre><code class="language-r">get_signatures(res, k = 6)
</code></pre>
<p><img src="figure_cola/tab-SD-kmeans-get-signatures-5-1.png" alt="plot of chunk tab-SD-kmeans-get-signatures-5" /></p>

</div>
</div>



Signature heatmaps where rows are not scaled:


<script>
$( function() {
	$( '#tabs-SD-kmeans-get-signatures-no-scale' ).tabs();
} );
</script>
<div id='tabs-SD-kmeans-get-signatures-no-scale'>
<ul>
<li><a href='#tab-SD-kmeans-get-signatures-no-scale-1'>k = 2</a></li>
<li><a href='#tab-SD-kmeans-get-signatures-no-scale-2'>k = 3</a></li>
<li><a href='#tab-SD-kmeans-get-signatures-no-scale-3'>k = 4</a></li>
<li><a href='#tab-SD-kmeans-get-signatures-no-scale-4'>k = 5</a></li>
<li><a href='#tab-SD-kmeans-get-signatures-no-scale-5'>k = 6</a></li>
</ul>
<div id='tab-SD-kmeans-get-signatures-no-scale-1'>
<pre><code class="language-r">get_signatures(res, k = 2, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-SD-kmeans-get-signatures-no-scale-1-1.png" alt="plot of chunk tab-SD-kmeans-get-signatures-no-scale-1" /></p>

</div>
<div id='tab-SD-kmeans-get-signatures-no-scale-2'>
<pre><code class="language-r">get_signatures(res, k = 3, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-SD-kmeans-get-signatures-no-scale-2-1.png" alt="plot of chunk tab-SD-kmeans-get-signatures-no-scale-2" /></p>

</div>
<div id='tab-SD-kmeans-get-signatures-no-scale-3'>
<pre><code class="language-r">get_signatures(res, k = 4, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-SD-kmeans-get-signatures-no-scale-3-1.png" alt="plot of chunk tab-SD-kmeans-get-signatures-no-scale-3" /></p>

</div>
<div id='tab-SD-kmeans-get-signatures-no-scale-4'>
<pre><code class="language-r">get_signatures(res, k = 5, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-SD-kmeans-get-signatures-no-scale-4-1.png" alt="plot of chunk tab-SD-kmeans-get-signatures-no-scale-4" /></p>

</div>
<div id='tab-SD-kmeans-get-signatures-no-scale-5'>
<pre><code class="language-r">get_signatures(res, k = 6, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-SD-kmeans-get-signatures-no-scale-5-1.png" alt="plot of chunk tab-SD-kmeans-get-signatures-no-scale-5" /></p>

</div>
</div>



Compare the overlap of signatures from different k:

``` r
compare_signatures(res)
```

![plot of chunk SD-kmeans-signature_compare](figure_cola/SD-kmeans-signature_compare-1.png)

`get_signature()` returns a data frame invisibly. To get the list of signatures, the function
call should be assigned to a variable explicitly. In following code, if `plot` argument is set
to `FALSE`, no heatmap is plotted while only the differential analysis is performed.

``` r
# code only for demonstration
tb = get_signature(res, k = ..., plot = FALSE)
```

An example of the output of `tb` is:

```
#>   which_row         fdr    mean_1    mean_2 scaled_mean_1 scaled_mean_2 km
#> 1        38 0.042760348  8.373488  9.131774    -0.5533452     0.5164555  1
#> 2        40 0.018707592  7.106213  8.469186    -0.6173731     0.5762149  1
#> 3        55 0.019134737 10.221463 11.207825    -0.6159697     0.5749050  1
#> 4        59 0.006059896  5.921854  7.869574    -0.6899429     0.6439467  1
#> 5        60 0.018055526  8.928898 10.211722    -0.6204761     0.5791110  1
#> 6        98 0.009384629 15.714769 14.887706     0.6635654    -0.6193277  2
...
```

The columns in `tb` are:

1. `which_row`: row indices corresponding to the input matrix.
2. `fdr`: FDR for the differential test. 
3. `mean_x`: The mean value in group x.
4. `scaled_mean_x`: The mean value in group x after rows are scaled.
5. `km`: Row groups if k-means clustering is applied to rows (which is done by automatically selecting number of clusters).

If there are too many signatures, `top_signatures = ...` can be set to only show the 
signatures with the highest FDRs:

``` r
# code only for demonstration
# e.g. to show the top 500 most significant rows
tb = get_signature(res, k = ..., top_signatures = 500)
```

If the signatures are defined as these which are uniquely high in current group, `diff_method` argument
can be set to `"uniquely_high_in_one_group"`:

``` r
# code only for demonstration
tb = get_signature(res, k = ..., diff_method = "uniquely_high_in_one_group")
```




UMAP plot which shows how samples are separated.


<script>
$( function() {
	$( '#tabs-SD-kmeans-dimension-reduction' ).tabs();
} );
</script>
<div id='tabs-SD-kmeans-dimension-reduction'>
<ul>
<li><a href='#tab-SD-kmeans-dimension-reduction-1'>k = 2</a></li>
<li><a href='#tab-SD-kmeans-dimension-reduction-2'>k = 3</a></li>
<li><a href='#tab-SD-kmeans-dimension-reduction-3'>k = 4</a></li>
<li><a href='#tab-SD-kmeans-dimension-reduction-4'>k = 5</a></li>
<li><a href='#tab-SD-kmeans-dimension-reduction-5'>k = 6</a></li>
</ul>
<div id='tab-SD-kmeans-dimension-reduction-1'>
<pre><code class="language-r">dimension_reduction(res, k = 2, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-SD-kmeans-dimension-reduction-1-1.png" alt="plot of chunk tab-SD-kmeans-dimension-reduction-1" /></p>

</div>
<div id='tab-SD-kmeans-dimension-reduction-2'>
<pre><code class="language-r">dimension_reduction(res, k = 3, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-SD-kmeans-dimension-reduction-2-1.png" alt="plot of chunk tab-SD-kmeans-dimension-reduction-2" /></p>

</div>
<div id='tab-SD-kmeans-dimension-reduction-3'>
<pre><code class="language-r">dimension_reduction(res, k = 4, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-SD-kmeans-dimension-reduction-3-1.png" alt="plot of chunk tab-SD-kmeans-dimension-reduction-3" /></p>

</div>
<div id='tab-SD-kmeans-dimension-reduction-4'>
<pre><code class="language-r">dimension_reduction(res, k = 5, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-SD-kmeans-dimension-reduction-4-1.png" alt="plot of chunk tab-SD-kmeans-dimension-reduction-4" /></p>

</div>
<div id='tab-SD-kmeans-dimension-reduction-5'>
<pre><code class="language-r">dimension_reduction(res, k = 6, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-SD-kmeans-dimension-reduction-5-1.png" alt="plot of chunk tab-SD-kmeans-dimension-reduction-5" /></p>

</div>
</div>



Following heatmap shows how subgroups are split when increasing `k`:

``` r
collect_classes(res)
```

![plot of chunk SD-kmeans-collect-classes](figure_cola/SD-kmeans-collect-classes-1.png)



If matrix rows can be associated to genes, consider to use `functional_enrichment(res,
...)` to perform function enrichment for the signature genes. See [this vignette](https://jokergoo.github.io/cola_vignettes/functional_enrichment.html) for more detailed explanations.


 

---------------------------------------------------



### SD:pam






The object with results only for a single top-value method and a single partitioning method 
can be extracted as:

``` r
res = res_list["SD", "pam"]
# you can also extract it by
# res = res_list["SD:pam"]
```

A summary of `res` and all the functions that can be applied to it:

``` r
res
```

```
#> A 'ConsensusPartition' object with k = 2, 3, 4, 5, 6.
#>   On a matrix with 1900 rows and 60 columns.
#>   Top rows (123) are extracted by 'SD' method.
#>   Subgroups are detected by 'pam' method.
#>   Performed in total 250 partitions by row resampling.
#>   Best k for subgroups seems to be 2.
#> 
#> Following methods can be applied to this 'ConsensusPartition' object:
#>  [1] "cola_report"             "collect_classes"         "collect_plots"          
#>  [4] "collect_stats"           "colnames"                "compare_partitions"     
#>  [7] "compare_signatures"      "consensus_heatmap"       "dimension_reduction"    
#> [10] "functional_enrichment"   "get_anno_col"            "get_anno"               
#> [13] "get_classes"             "get_consensus"           "get_matrix"             
#> [16] "get_membership"          "get_param"               "get_signatures"         
#> [19] "get_stats"               "is_best_k"               "is_stable_k"            
#> [22] "membership_heatmap"      "ncol"                    "nrow"                   
#> [25] "plot_ecdf"               "predict_classes"         "rownames"               
#> [28] "select_partition_number" "show"                    "suggest_best_k"         
#> [31] "test_to_known_factors"   "top_rows_heatmap"
```

`collect_plots()` function collects all the plots made from `res` for all `k` (number of subgroups)
into one single page to provide an easy and fast comparison between different `k`.

``` r
collect_plots(res)
```

![plot of chunk SD-pam-collect-plots](figure_cola/SD-pam-collect-plots-1.png)

The plots are:

- The first row: a plot of the eCDF (empirical cumulative distribution
  function) curves of the consensus matrix for each `k` and the heatmap of
  predicted classes for each `k`.
- The second row: heatmaps of the consensus matrix for each `k`.
- The third row: heatmaps of the membership matrix for each `k`.
- The fouth row: heatmaps of the signatures for each `k`.

All the plots in panels can be made by individual functions and they are
plotted later in this section.

`select_partition_number()` produces several plots showing different
statistics for choosing "optimized" `k`. There are following statistics:

- eCDF curves of the consensus matrix for each `k`;
- 1-PAC. [The PAC score](https://en.wikipedia.org/wiki/Consensus_clustering#Over-interpretation_potential_of_consensus_clustering)
  measures the proportion of the ambiguous subgrouping.
- Mean silhouette score.
- Concordance. The mean probability of fiting the consensus subgroup labels in all
  partitions.
- Area increased. Denote $A_k$ as the area under the eCDF curve for current
  `k`, the area increased is defined as $A_k - A_{k-1}$.
- Rand index. The percent of pairs of samples that are both in a same cluster
  or both are not in a same cluster in the partition of k and k-1.
- Jaccard index. The ratio of pairs of samples are both in a same cluster in
  the partition of k and k-1 and the pairs of samples are both in a same
  cluster in the partition k or k-1.

The detailed explanations of these statistics can be found in [the _cola_
vignette](https://jokergoo.github.io/cola_vignettes/cola.html#toc_13).

Generally speaking, higher 1-PAC score, higher mean silhouette score or higher
concordance corresponds to better partition. Rand index and Jaccard index
measure how similar the current partition is compared to partition with `k-1`.
If they are too similar, we won't accept `k` is better than `k-1`.

``` r
select_partition_number(res)
```

![plot of chunk SD-pam-select-partition-number](figure_cola/SD-pam-select-partition-number-1.png)

The numeric values for all these statistics can be obtained by `get_stats()`.

``` r
get_stats(res)
```

```
#>   k 1-PAC mean_silhouette concordance area_increased  Rand Jaccard
#> 2 2 0.365           0.694       0.866         0.4932 0.494   0.494
#> 3 3 0.377           0.618       0.806         0.3620 0.695   0.458
#> 4 4 0.410           0.463       0.705         0.1112 0.922   0.778
#> 5 5 0.486           0.475       0.700         0.0663 0.849   0.534
#> 6 6 0.558           0.462       0.705         0.0444 0.940   0.717
```

`suggest_best_k()` suggests the best $k$ based on these statistics. The rules are as follows:

- All $k$ with Jaccard index larger than 0.95 are removed because increasing
  $k$ does not provide enough extra information. If all $k$ are removed, it is
  marked as no subgroup is detected.
- For all $k$ with 1-PAC score larger than 0.9, the maximal $k$ is taken as
  the best $k$, and other $k$ are marked as optional $k$.
- If it does not fit the second rule. The $k$ with the maximal vote of the
  highest 1-PAC score, highest mean silhouette, and highest concordance is
  taken as the best $k$.

``` r
suggest_best_k(res)
```

```
#> [1] 2
```


Following is the table of the partitions (You need to click the **show/hide
code output** link to see it). The membership matrix (columns with name `p*`)
is inferred by
[`clue::cl_consensus()`](https://www.rdocumentation.org/link/cl_consensus?package=clue)
function with the `SE` method. Basically the value in the membership matrix
represents the probability to belong to a certain group. The finall subgroup
label for an item is determined with the group with highest probability it
belongs to.

In `get_classes()` function, the entropy is calculated from the membership
matrix and the silhouette score is calculated from the consensus matrix.



<script>
$( function() {
	$( '#tabs-SD-pam-get-classes' ).tabs();
} );
</script>
<div id='tabs-SD-pam-get-classes'>
<ul>
<li><a href='#tab-SD-pam-get-classes-1'>k = 2</a></li>
<li><a href='#tab-SD-pam-get-classes-2'>k = 3</a></li>
<li><a href='#tab-SD-pam-get-classes-3'>k = 4</a></li>
<li><a href='#tab-SD-pam-get-classes-4'>k = 5</a></li>
<li><a href='#tab-SD-pam-get-classes-5'>k = 6</a></li>
</ul>

<div id='tab-SD-pam-get-classes-1'>
<p><a id='tab-SD-pam-get-classes-1-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 2), get_membership(res, k = 2))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2
#&gt; SIH013     1   0.925      0.469 0.66 0.34
#&gt; SIH014     2   0.529      0.796 0.12 0.88
#&gt; SIH024     1   0.958      0.342 0.62 0.38
#&gt; SIH028     2   0.000      0.830 0.00 1.00
#&gt; SIH031     1   0.971      0.281 0.60 0.40
#&gt; SIH042     1   0.141      0.829 0.98 0.02
#&gt; SIH107     2   0.000      0.830 0.00 1.00
#&gt; SIH114     1   0.000      0.832 1.00 0.00
#&gt; SIH116     1   0.722      0.720 0.80 0.20
#&gt; SIH117     2   0.995      0.234 0.46 0.54
#&gt; SIH130     2   0.000      0.830 0.00 1.00
#&gt; SIH134     2   0.000      0.830 0.00 1.00
#&gt; SIH186     2   0.141      0.832 0.02 0.98
#&gt; SIH191     1   0.000      0.832 1.00 0.00
#&gt; SIH192     2   0.242      0.829 0.04 0.96
#&gt; SIH196     2   0.141      0.832 0.02 0.98
#&gt; SIH214     2   0.584      0.780 0.14 0.86
#&gt; SIH218     2   0.795      0.693 0.24 0.76
#&gt; SIH232     1   0.141      0.830 0.98 0.02
#&gt; SIH236     1   0.584      0.761 0.86 0.14
#&gt; SIH238     1   1.000     -0.113 0.50 0.50
#&gt; SIH241     2   0.327      0.823 0.06 0.94
#&gt; SIH245     2   0.000      0.830 0.00 1.00
#&gt; SIH260     1   0.881      0.583 0.70 0.30
#&gt; SIH287     2   0.402      0.792 0.08 0.92
#&gt; SIH289     2   0.958      0.305 0.38 0.62
#&gt; SIH290     2   0.000      0.830 0.00 1.00
#&gt; SIH295     1   0.000      0.832 1.00 0.00
#&gt; SIH366     1   0.242      0.824 0.96 0.04
#&gt; SIH377     1   0.000      0.832 1.00 0.00
#&gt; SIH380     2   0.141      0.832 0.02 0.98
#&gt; SIH385     2   0.327      0.823 0.06 0.94
#&gt; SIH389     2   0.000      0.830 0.00 1.00
#&gt; SIH391     2   0.855      0.583 0.28 0.72
#&gt; SIH403     1   0.327      0.815 0.94 0.06
#&gt; SIH411     2   0.000      0.830 0.00 1.00
#&gt; SIH427     1   0.000      0.832 1.00 0.00
#&gt; SIH433     2   0.722      0.734 0.20 0.80
#&gt; SIH439     2   0.995      0.206 0.46 0.54
#&gt; SIH442     1   0.000      0.832 1.00 0.00
#&gt; SIH444     1   0.971      0.264 0.60 0.40
#&gt; SIH452     2   0.958      0.315 0.38 0.62
#&gt; SIH461     1   0.981      0.212 0.58 0.42
#&gt; SIH471     1   0.000      0.832 1.00 0.00
#&gt; SIH472     2   0.000      0.830 0.00 1.00
#&gt; SIH481     1   0.242      0.824 0.96 0.04
#&gt; SIH485     2   0.469      0.808 0.10 0.90
#&gt; SIH491     2   0.327      0.823 0.06 0.94
#&gt; SIH508     1   0.680      0.715 0.82 0.18
#&gt; SIH559     1   0.242      0.823 0.96 0.04
#&gt; SIH587     1   0.000      0.832 1.00 0.00
#&gt; SIH625     2   0.722      0.736 0.20 0.80
#&gt; SIH641     1   0.327      0.818 0.94 0.06
#&gt; SIH643     2   0.971      0.370 0.40 0.60
#&gt; SIH674     1   0.000      0.832 1.00 0.00
#&gt; SIH678     1   0.000      0.832 1.00 0.00
#&gt; SIH679     1   0.634      0.734 0.84 0.16
#&gt; SIH689     2   0.904      0.561 0.32 0.68
#&gt; SIH694     2   0.000      0.830 0.00 1.00
#&gt; SIH721     2   0.881      0.599 0.30 0.70
</code></pre>

<script>
$('#tab-SD-pam-get-classes-1-a').parent().next().next().hide();
$('#tab-SD-pam-get-classes-1-a').click(function(){
  $('#tab-SD-pam-get-classes-1-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-SD-pam-get-classes-2'>
<p><a id='tab-SD-pam-get-classes-2-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 3), get_membership(res, k = 3))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3
#&gt; SIH013     3  0.5970    0.64182 0.16 0.06 0.78
#&gt; SIH014     3  0.5948    0.24481 0.00 0.36 0.64
#&gt; SIH024     3  0.8838    0.51474 0.22 0.20 0.58
#&gt; SIH028     2  0.4796    0.74076 0.00 0.78 0.22
#&gt; SIH031     3  0.1529    0.67695 0.04 0.00 0.96
#&gt; SIH042     1  0.0892    0.85394 0.98 0.02 0.00
#&gt; SIH107     2  0.1529    0.79114 0.00 0.96 0.04
#&gt; SIH114     1  0.3686    0.77651 0.86 0.00 0.14
#&gt; SIH116     1  0.8576    0.36024 0.60 0.16 0.24
#&gt; SIH117     3  0.5560    0.49567 0.00 0.30 0.70
#&gt; SIH130     2  0.3340    0.79302 0.00 0.88 0.12
#&gt; SIH134     2  0.0892    0.79344 0.00 0.98 0.02
#&gt; SIH186     2  0.4002    0.75853 0.00 0.84 0.16
#&gt; SIH191     1  0.0000    0.85973 1.00 0.00 0.00
#&gt; SIH192     2  0.6126    0.42310 0.00 0.60 0.40
#&gt; SIH196     2  0.3686    0.78557 0.00 0.86 0.14
#&gt; SIH214     3  0.3340    0.63299 0.00 0.12 0.88
#&gt; SIH218     3  0.0892    0.66616 0.00 0.02 0.98
#&gt; SIH232     1  0.0000    0.85973 1.00 0.00 0.00
#&gt; SIH236     1  0.3042    0.83186 0.92 0.04 0.04
#&gt; SIH238     3  0.0892    0.67162 0.02 0.00 0.98
#&gt; SIH241     2  0.5016    0.69247 0.00 0.76 0.24
#&gt; SIH245     2  0.2066    0.79650 0.00 0.94 0.06
#&gt; SIH260     3  0.9773    0.25335 0.34 0.24 0.42
#&gt; SIH287     2  0.3340    0.76430 0.00 0.88 0.12
#&gt; SIH289     2  0.8683    0.23028 0.34 0.54 0.12
#&gt; SIH290     2  0.2066    0.79650 0.00 0.94 0.06
#&gt; SIH295     1  0.0000    0.85973 1.00 0.00 0.00
#&gt; SIH366     1  0.6280    0.05897 0.54 0.00 0.46
#&gt; SIH377     1  0.0000    0.85973 1.00 0.00 0.00
#&gt; SIH380     2  0.3340    0.76630 0.00 0.88 0.12
#&gt; SIH385     2  0.4555    0.73854 0.00 0.80 0.20
#&gt; SIH389     2  0.0000    0.78632 0.00 1.00 0.00
#&gt; SIH391     3  0.8334   -0.00342 0.08 0.44 0.48
#&gt; SIH403     1  0.5560    0.50950 0.70 0.00 0.30
#&gt; SIH411     2  0.0892    0.78897 0.00 0.98 0.02
#&gt; SIH427     1  0.0892    0.85654 0.98 0.00 0.02
#&gt; SIH433     3  0.3415    0.66081 0.02 0.08 0.90
#&gt; SIH439     3  0.4556    0.67997 0.08 0.06 0.86
#&gt; SIH442     1  0.2066    0.82928 0.94 0.00 0.06
#&gt; SIH444     3  0.9372    0.38364 0.20 0.30 0.50
#&gt; SIH452     2  0.8390    0.18093 0.10 0.56 0.34
#&gt; SIH461     3  0.5397    0.54913 0.28 0.00 0.72
#&gt; SIH471     1  0.1529    0.84397 0.96 0.00 0.04
#&gt; SIH472     2  0.2066    0.79639 0.00 0.94 0.06
#&gt; SIH481     3  0.5397    0.55028 0.28 0.00 0.72
#&gt; SIH485     3  0.6045    0.15904 0.00 0.38 0.62
#&gt; SIH491     2  0.3340    0.79109 0.00 0.88 0.12
#&gt; SIH508     3  0.7555    0.22518 0.44 0.04 0.52
#&gt; SIH559     3  0.6045    0.34761 0.38 0.00 0.62
#&gt; SIH587     1  0.1529    0.85024 0.96 0.00 0.04
#&gt; SIH625     3  0.6803    0.51590 0.04 0.28 0.68
#&gt; SIH641     1  0.5970    0.68041 0.78 0.06 0.16
#&gt; SIH643     3  0.4862    0.65333 0.16 0.02 0.82
#&gt; SIH674     1  0.0000    0.85973 1.00 0.00 0.00
#&gt; SIH678     3  0.6126    0.34313 0.40 0.00 0.60
#&gt; SIH679     1  0.2414    0.83957 0.94 0.04 0.02
#&gt; SIH689     3  0.3042    0.67561 0.04 0.04 0.92
#&gt; SIH694     2  0.4002    0.78788 0.00 0.84 0.16
#&gt; SIH721     2  0.8342   -0.07887 0.08 0.46 0.46
</code></pre>

<script>
$('#tab-SD-pam-get-classes-2-a').parent().next().next().hide();
$('#tab-SD-pam-get-classes-2-a').click(function(){
  $('#tab-SD-pam-get-classes-2-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-SD-pam-get-classes-3'>
<p><a id='tab-SD-pam-get-classes-3-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 4), get_membership(res, k = 4))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3   p4
#&gt; SIH013     3  0.7430     0.3398 0.12 0.02 0.54 0.32
#&gt; SIH014     3  0.6720     0.1300 0.00 0.30 0.58 0.12
#&gt; SIH024     3  0.8695     0.3044 0.14 0.08 0.44 0.34
#&gt; SIH028     2  0.4731     0.6994 0.00 0.78 0.06 0.16
#&gt; SIH031     3  0.0707     0.3858 0.00 0.00 0.98 0.02
#&gt; SIH042     1  0.2011     0.7704 0.92 0.00 0.00 0.08
#&gt; SIH107     2  0.4522     0.6481 0.00 0.68 0.00 0.32
#&gt; SIH114     1  0.5147     0.6556 0.74 0.00 0.20 0.06
#&gt; SIH116     1  0.8540     0.0691 0.52 0.08 0.22 0.18
#&gt; SIH117     3  0.6720     0.3555 0.00 0.12 0.58 0.30
#&gt; SIH130     2  0.3037     0.7485 0.00 0.88 0.02 0.10
#&gt; SIH134     2  0.0707     0.7652 0.00 0.98 0.00 0.02
#&gt; SIH186     2  0.6216     0.5303 0.00 0.66 0.12 0.22
#&gt; SIH191     1  0.0000     0.7761 1.00 0.00 0.00 0.00
#&gt; SIH192     2  0.5392     0.4844 0.00 0.68 0.28 0.04
#&gt; SIH196     2  0.5883     0.5393 0.00 0.64 0.06 0.30
#&gt; SIH214     3  0.6921     0.1242 0.00 0.16 0.58 0.26
#&gt; SIH218     3  0.2411     0.3899 0.00 0.04 0.92 0.04
#&gt; SIH232     1  0.3335     0.7516 0.86 0.00 0.02 0.12
#&gt; SIH236     1  0.2411     0.7644 0.92 0.00 0.04 0.04
#&gt; SIH238     3  0.1211     0.4002 0.00 0.00 0.96 0.04
#&gt; SIH241     2  0.2706     0.7578 0.00 0.90 0.08 0.02
#&gt; SIH245     2  0.0707     0.7671 0.00 0.98 0.00 0.02
#&gt; SIH260     3  0.8614    -0.2080 0.16 0.06 0.42 0.36
#&gt; SIH287     2  0.6287     0.6002 0.02 0.66 0.06 0.26
#&gt; SIH289     4  0.9366     0.1828 0.26 0.26 0.10 0.38
#&gt; SIH290     2  0.0707     0.7671 0.00 0.98 0.00 0.02
#&gt; SIH295     1  0.2335     0.7728 0.92 0.00 0.02 0.06
#&gt; SIH366     3  0.7485     0.0282 0.38 0.00 0.44 0.18
#&gt; SIH377     1  0.2921     0.7484 0.86 0.00 0.00 0.14
#&gt; SIH380     2  0.4755     0.6975 0.00 0.76 0.04 0.20
#&gt; SIH385     2  0.4079     0.6738 0.00 0.80 0.02 0.18
#&gt; SIH389     2  0.3400     0.7145 0.00 0.82 0.00 0.18
#&gt; SIH391     3  0.9162    -0.0984 0.10 0.32 0.40 0.18
#&gt; SIH403     1  0.7382     0.2335 0.52 0.00 0.26 0.22
#&gt; SIH411     2  0.3335     0.7447 0.00 0.86 0.02 0.12
#&gt; SIH427     1  0.1211     0.7786 0.96 0.00 0.04 0.00
#&gt; SIH433     3  0.7220     0.3151 0.00 0.14 0.44 0.42
#&gt; SIH439     3  0.7200     0.2016 0.06 0.04 0.54 0.36
#&gt; SIH442     1  0.6201     0.5625 0.62 0.00 0.08 0.30
#&gt; SIH444     3  0.8962     0.2242 0.12 0.24 0.48 0.16
#&gt; SIH452     4  0.8971     0.1416 0.06 0.24 0.32 0.38
#&gt; SIH461     3  0.6599     0.3391 0.04 0.02 0.50 0.44
#&gt; SIH471     1  0.4292     0.7453 0.82 0.00 0.08 0.10
#&gt; SIH472     2  0.3172     0.7347 0.00 0.84 0.00 0.16
#&gt; SIH481     3  0.6988     0.1985 0.12 0.00 0.50 0.38
#&gt; SIH485     3  0.7285     0.0645 0.00 0.30 0.52 0.18
#&gt; SIH491     2  0.3247     0.7614 0.00 0.88 0.06 0.06
#&gt; SIH508     4  0.8407    -0.3222 0.18 0.04 0.34 0.44
#&gt; SIH559     3  0.6320     0.2373 0.18 0.00 0.66 0.16
#&gt; SIH587     1  0.2411     0.7704 0.92 0.00 0.04 0.04
#&gt; SIH625     3  0.7075    -0.1031 0.02 0.08 0.54 0.36
#&gt; SIH641     1  0.4211     0.7062 0.84 0.02 0.10 0.04
#&gt; SIH643     3  0.6537     0.3695 0.02 0.04 0.54 0.40
#&gt; SIH674     1  0.3801     0.6991 0.78 0.00 0.00 0.22
#&gt; SIH678     3  0.7135     0.2007 0.20 0.00 0.56 0.24
#&gt; SIH679     1  0.2335     0.7627 0.92 0.00 0.02 0.06
#&gt; SIH689     3  0.5619     0.3995 0.00 0.04 0.64 0.32
#&gt; SIH694     2  0.4088     0.7450 0.00 0.82 0.04 0.14
#&gt; SIH721     3  0.8079     0.2294 0.02 0.18 0.40 0.40
</code></pre>

<script>
$('#tab-SD-pam-get-classes-3-a').parent().next().next().hide();
$('#tab-SD-pam-get-classes-3-a').click(function(){
  $('#tab-SD-pam-get-classes-3-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-SD-pam-get-classes-4'>
<p><a id='tab-SD-pam-get-classes-4-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 5), get_membership(res, k = 5))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3   p4   p5
#&gt; SIH013     3  0.6471     0.5296 0.06 0.00 0.62 0.20 0.12
#&gt; SIH014     4  0.7976     0.1320 0.00 0.26 0.32 0.34 0.08
#&gt; SIH024     3  0.7234     0.4928 0.12 0.10 0.62 0.04 0.12
#&gt; SIH028     2  0.6391     0.5230 0.00 0.62 0.22 0.10 0.06
#&gt; SIH031     3  0.7761     0.3019 0.02 0.02 0.34 0.32 0.30
#&gt; SIH042     1  0.2249     0.7341 0.92 0.00 0.02 0.02 0.04
#&gt; SIH107     2  0.5838     0.4984 0.00 0.56 0.06 0.36 0.02
#&gt; SIH114     1  0.5347     0.5470 0.72 0.00 0.04 0.16 0.08
#&gt; SIH116     4  0.4613     0.2062 0.36 0.02 0.00 0.62 0.00
#&gt; SIH117     3  0.4671     0.4787 0.00 0.04 0.74 0.20 0.02
#&gt; SIH130     2  0.4225     0.6871 0.00 0.80 0.06 0.12 0.02
#&gt; SIH134     2  0.1043     0.7240 0.00 0.96 0.00 0.04 0.00
#&gt; SIH186     2  0.6200     0.3445 0.00 0.56 0.10 0.32 0.02
#&gt; SIH191     1  0.0609     0.7388 0.98 0.00 0.00 0.00 0.02
#&gt; SIH192     2  0.6133     0.4643 0.00 0.66 0.08 0.18 0.08
#&gt; SIH196     2  0.7121     0.2297 0.00 0.44 0.26 0.28 0.02
#&gt; SIH214     4  0.7015     0.0601 0.00 0.08 0.38 0.46 0.08
#&gt; SIH218     3  0.6952     0.2479 0.00 0.02 0.42 0.38 0.18
#&gt; SIH232     1  0.3983     0.3971 0.66 0.00 0.00 0.00 0.34
#&gt; SIH236     1  0.1410     0.7349 0.94 0.00 0.00 0.06 0.00
#&gt; SIH238     3  0.7643     0.3823 0.02 0.02 0.40 0.32 0.24
#&gt; SIH241     2  0.3765     0.7028 0.00 0.84 0.08 0.04 0.04
#&gt; SIH245     2  0.0609     0.7193 0.00 0.98 0.00 0.02 0.00
#&gt; SIH260     4  0.4225     0.3903 0.12 0.02 0.06 0.80 0.00
#&gt; SIH287     4  0.5684    -0.1034 0.02 0.44 0.04 0.50 0.00
#&gt; SIH289     4  0.6375     0.3419 0.14 0.18 0.02 0.64 0.02
#&gt; SIH290     2  0.0609     0.7193 0.00 0.98 0.00 0.02 0.00
#&gt; SIH295     1  0.3796     0.4706 0.70 0.00 0.00 0.00 0.30
#&gt; SIH366     5  0.6200     0.4950 0.24 0.00 0.04 0.10 0.62
#&gt; SIH377     1  0.3684     0.5246 0.72 0.00 0.00 0.00 0.28
#&gt; SIH380     2  0.5733     0.5281 0.00 0.62 0.16 0.22 0.00
#&gt; SIH385     2  0.4527     0.5744 0.00 0.70 0.26 0.04 0.00
#&gt; SIH389     2  0.2929     0.6823 0.00 0.82 0.00 0.18 0.00
#&gt; SIH391     4  0.7900     0.2960 0.06 0.16 0.12 0.56 0.10
#&gt; SIH403     1  0.6458     0.0922 0.50 0.00 0.24 0.00 0.26
#&gt; SIH411     2  0.1732     0.7080 0.00 0.92 0.00 0.08 0.00
#&gt; SIH427     1  0.0000     0.7398 1.00 0.00 0.00 0.00 0.00
#&gt; SIH433     3  0.4932     0.4700 0.00 0.04 0.76 0.12 0.08
#&gt; SIH439     5  0.4281     0.4243 0.00 0.02 0.08 0.10 0.80
#&gt; SIH442     5  0.4132     0.4685 0.26 0.00 0.02 0.00 0.72
#&gt; SIH444     3  0.7330     0.3734 0.06 0.20 0.50 0.00 0.24
#&gt; SIH452     4  0.3938     0.4435 0.04 0.08 0.02 0.84 0.02
#&gt; SIH461     3  0.6315     0.3841 0.04 0.02 0.58 0.04 0.32
#&gt; SIH471     1  0.3291     0.6705 0.84 0.00 0.04 0.00 0.12
#&gt; SIH472     2  0.2873     0.7009 0.00 0.86 0.02 0.12 0.00
#&gt; SIH481     5  0.3110     0.5466 0.06 0.00 0.08 0.00 0.86
#&gt; SIH485     4  0.8029     0.1842 0.00 0.22 0.30 0.38 0.10
#&gt; SIH491     2  0.3034     0.7177 0.00 0.88 0.06 0.04 0.02
#&gt; SIH508     5  0.4794     0.5212 0.10 0.00 0.12 0.02 0.76
#&gt; SIH559     5  0.8132     0.1307 0.24 0.00 0.16 0.18 0.42
#&gt; SIH587     1  0.1216     0.7380 0.96 0.00 0.02 0.02 0.00
#&gt; SIH625     4  0.3977     0.3881 0.00 0.02 0.10 0.82 0.06
#&gt; SIH641     1  0.5604     0.5431 0.70 0.04 0.10 0.00 0.16
#&gt; SIH643     3  0.6014     0.3827 0.02 0.02 0.58 0.04 0.34
#&gt; SIH674     5  0.4126     0.2653 0.38 0.00 0.00 0.00 0.62
#&gt; SIH678     5  0.6484     0.4242 0.22 0.00 0.14 0.04 0.60
#&gt; SIH679     1  0.1732     0.7261 0.92 0.00 0.00 0.08 0.00
#&gt; SIH689     3  0.3971     0.5345 0.00 0.00 0.80 0.10 0.10
#&gt; SIH694     2  0.4558     0.6622 0.00 0.74 0.18 0.08 0.00
#&gt; SIH721     3  0.7242     0.4496 0.02 0.14 0.60 0.10 0.14
</code></pre>

<script>
$('#tab-SD-pam-get-classes-4-a').parent().next().next().hide();
$('#tab-SD-pam-get-classes-4-a').click(function(){
  $('#tab-SD-pam-get-classes-4-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-SD-pam-get-classes-5'>
<p><a id='tab-SD-pam-get-classes-5-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 6), get_membership(res, k = 6))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3   p4   p5   p6
#&gt; SIH013     3  0.4967    0.50601 0.02 0.00 0.68 0.02 0.04 0.24
#&gt; SIH014     6  0.3854    0.50537 0.00 0.12 0.04 0.00 0.04 0.80
#&gt; SIH024     3  0.8023    0.46468 0.12 0.06 0.50 0.04 0.10 0.18
#&gt; SIH028     2  0.5390    0.54155 0.00 0.64 0.06 0.06 0.00 0.24
#&gt; SIH031     6  0.5609    0.35251 0.02 0.00 0.12 0.00 0.28 0.58
#&gt; SIH042     1  0.2020    0.69291 0.92 0.00 0.02 0.04 0.02 0.00
#&gt; SIH107     4  0.5555   -0.20008 0.00 0.38 0.00 0.48 0.00 0.14
#&gt; SIH114     1  0.5486    0.39171 0.62 0.00 0.00 0.22 0.14 0.02
#&gt; SIH116     4  0.5310    0.45472 0.22 0.02 0.00 0.64 0.00 0.12
#&gt; SIH117     3  0.3258    0.54808 0.00 0.00 0.84 0.04 0.02 0.10
#&gt; SIH130     2  0.4613    0.58755 0.00 0.66 0.00 0.08 0.00 0.26
#&gt; SIH134     2  0.2728    0.66877 0.00 0.86 0.00 0.04 0.00 0.10
#&gt; SIH186     2  0.6251    0.28126 0.00 0.48 0.02 0.28 0.00 0.22
#&gt; SIH191     1  0.0937    0.68792 0.96 0.00 0.00 0.00 0.04 0.00
#&gt; SIH192     2  0.4728    0.51964 0.00 0.68 0.02 0.02 0.02 0.26
#&gt; SIH196     6  0.7143   -0.11053 0.00 0.26 0.14 0.16 0.00 0.44
#&gt; SIH214     6  0.3948    0.52644 0.00 0.04 0.06 0.06 0.02 0.82
#&gt; SIH218     6  0.3567    0.48474 0.00 0.00 0.10 0.00 0.10 0.80
#&gt; SIH232     1  0.3499    0.44223 0.68 0.00 0.00 0.00 0.32 0.00
#&gt; SIH236     1  0.1807    0.69090 0.92 0.00 0.00 0.06 0.00 0.02
#&gt; SIH238     6  0.6709    0.23844 0.02 0.00 0.22 0.04 0.20 0.52
#&gt; SIH241     2  0.3506    0.66145 0.00 0.80 0.00 0.02 0.02 0.16
#&gt; SIH245     2  0.0547    0.67418 0.00 0.98 0.00 0.02 0.00 0.00
#&gt; SIH260     4  0.2350    0.57170 0.02 0.00 0.00 0.88 0.00 0.10
#&gt; SIH287     4  0.4002    0.42053 0.00 0.32 0.00 0.66 0.00 0.02
#&gt; SIH289     4  0.4251    0.58086 0.10 0.06 0.00 0.78 0.00 0.06
#&gt; SIH290     2  0.0547    0.67418 0.00 0.98 0.00 0.02 0.00 0.00
#&gt; SIH295     1  0.3578    0.39046 0.66 0.00 0.00 0.00 0.34 0.00
#&gt; SIH366     5  0.5569    0.32979 0.32 0.00 0.00 0.00 0.52 0.16
#&gt; SIH377     1  0.3409    0.46291 0.70 0.00 0.00 0.00 0.30 0.00
#&gt; SIH380     2  0.6631    0.30972 0.00 0.52 0.10 0.24 0.00 0.14
#&gt; SIH385     2  0.5846    0.34515 0.00 0.54 0.30 0.00 0.02 0.14
#&gt; SIH389     2  0.4265    0.50389 0.00 0.66 0.00 0.30 0.00 0.04
#&gt; SIH391     4  0.7603    0.15017 0.02 0.16 0.04 0.40 0.04 0.34
#&gt; SIH403     1  0.6969    0.12935 0.50 0.00 0.22 0.02 0.20 0.06
#&gt; SIH411     2  0.1814    0.65791 0.00 0.90 0.00 0.10 0.00 0.00
#&gt; SIH427     1  0.0000    0.69211 1.00 0.00 0.00 0.00 0.00 0.00
#&gt; SIH433     3  0.2941    0.46851 0.00 0.00 0.78 0.00 0.00 0.22
#&gt; SIH439     5  0.5358    0.41251 0.00 0.02 0.06 0.04 0.68 0.20
#&gt; SIH442     5  0.2454    0.52267 0.16 0.00 0.00 0.00 0.84 0.00
#&gt; SIH444     3  0.5269    0.51279 0.02 0.10 0.72 0.00 0.10 0.06
#&gt; SIH452     4  0.4210    0.54733 0.00 0.04 0.02 0.78 0.02 0.14
#&gt; SIH461     3  0.6424    0.45871 0.00 0.00 0.50 0.04 0.22 0.24
#&gt; SIH471     1  0.4105    0.46358 0.72 0.00 0.02 0.02 0.24 0.00
#&gt; SIH472     2  0.3592    0.56015 0.00 0.74 0.00 0.24 0.00 0.02
#&gt; SIH481     5  0.2938    0.57914 0.04 0.00 0.02 0.02 0.88 0.04
#&gt; SIH485     6  0.3258    0.50992 0.00 0.04 0.06 0.02 0.02 0.86
#&gt; SIH491     2  0.2345    0.67976 0.00 0.90 0.02 0.02 0.00 0.06
#&gt; SIH508     5  0.5180    0.48862 0.10 0.00 0.12 0.04 0.72 0.02
#&gt; SIH559     5  0.7084    0.27196 0.18 0.00 0.06 0.02 0.46 0.28
#&gt; SIH587     1  0.0937    0.69171 0.96 0.00 0.00 0.04 0.00 0.00
#&gt; SIH625     6  0.4892   -0.00806 0.00 0.00 0.00 0.44 0.06 0.50
#&gt; SIH641     1  0.5877    0.34630 0.58 0.04 0.30 0.00 0.06 0.02
#&gt; SIH643     3  0.6404    0.42691 0.00 0.00 0.50 0.04 0.20 0.26
#&gt; SIH674     5  0.3706    0.23307 0.38 0.00 0.00 0.00 0.62 0.00
#&gt; SIH678     5  0.6352    0.45340 0.20 0.00 0.04 0.02 0.58 0.16
#&gt; SIH679     1  0.2094    0.68518 0.90 0.00 0.00 0.08 0.00 0.02
#&gt; SIH689     3  0.2790    0.53625 0.00 0.00 0.84 0.00 0.02 0.14
#&gt; SIH694     2  0.4983    0.60618 0.00 0.68 0.06 0.04 0.00 0.22
#&gt; SIH721     3  0.8312    0.44982 0.04 0.12 0.48 0.10 0.16 0.10
</code></pre>

<script>
$('#tab-SD-pam-get-classes-5-a').parent().next().next().hide();
$('#tab-SD-pam-get-classes-5-a').click(function(){
  $('#tab-SD-pam-get-classes-5-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>
</div>

Heatmaps for the consensus matrix. It visualizes the probability of two
samples to be in a same group.




<script>
$( function() {
	$( '#tabs-SD-pam-consensus-heatmap' ).tabs();
} );
</script>
<div id='tabs-SD-pam-consensus-heatmap'>
<ul>
<li><a href='#tab-SD-pam-consensus-heatmap-1'>k = 2</a></li>
<li><a href='#tab-SD-pam-consensus-heatmap-2'>k = 3</a></li>
<li><a href='#tab-SD-pam-consensus-heatmap-3'>k = 4</a></li>
<li><a href='#tab-SD-pam-consensus-heatmap-4'>k = 5</a></li>
<li><a href='#tab-SD-pam-consensus-heatmap-5'>k = 6</a></li>
</ul>
<div id='tab-SD-pam-consensus-heatmap-1'>
<pre><code class="language-r">consensus_heatmap(res, k = 2)
</code></pre>
<p><img src="figure_cola/tab-SD-pam-consensus-heatmap-1-1.png" alt="plot of chunk tab-SD-pam-consensus-heatmap-1" /></p>

</div>
<div id='tab-SD-pam-consensus-heatmap-2'>
<pre><code class="language-r">consensus_heatmap(res, k = 3)
</code></pre>
<p><img src="figure_cola/tab-SD-pam-consensus-heatmap-2-1.png" alt="plot of chunk tab-SD-pam-consensus-heatmap-2" /></p>

</div>
<div id='tab-SD-pam-consensus-heatmap-3'>
<pre><code class="language-r">consensus_heatmap(res, k = 4)
</code></pre>
<p><img src="figure_cola/tab-SD-pam-consensus-heatmap-3-1.png" alt="plot of chunk tab-SD-pam-consensus-heatmap-3" /></p>

</div>
<div id='tab-SD-pam-consensus-heatmap-4'>
<pre><code class="language-r">consensus_heatmap(res, k = 5)
</code></pre>
<p><img src="figure_cola/tab-SD-pam-consensus-heatmap-4-1.png" alt="plot of chunk tab-SD-pam-consensus-heatmap-4" /></p>

</div>
<div id='tab-SD-pam-consensus-heatmap-5'>
<pre><code class="language-r">consensus_heatmap(res, k = 6)
</code></pre>
<p><img src="figure_cola/tab-SD-pam-consensus-heatmap-5-1.png" alt="plot of chunk tab-SD-pam-consensus-heatmap-5" /></p>

</div>
</div>

Heatmaps for the membership of samples in all partitions to see how consistent they are:





<script>
$( function() {
	$( '#tabs-SD-pam-membership-heatmap' ).tabs();
} );
</script>
<div id='tabs-SD-pam-membership-heatmap'>
<ul>
<li><a href='#tab-SD-pam-membership-heatmap-1'>k = 2</a></li>
<li><a href='#tab-SD-pam-membership-heatmap-2'>k = 3</a></li>
<li><a href='#tab-SD-pam-membership-heatmap-3'>k = 4</a></li>
<li><a href='#tab-SD-pam-membership-heatmap-4'>k = 5</a></li>
<li><a href='#tab-SD-pam-membership-heatmap-5'>k = 6</a></li>
</ul>
<div id='tab-SD-pam-membership-heatmap-1'>
<pre><code class="language-r">membership_heatmap(res, k = 2)
</code></pre>
<p><img src="figure_cola/tab-SD-pam-membership-heatmap-1-1.png" alt="plot of chunk tab-SD-pam-membership-heatmap-1" /></p>

</div>
<div id='tab-SD-pam-membership-heatmap-2'>
<pre><code class="language-r">membership_heatmap(res, k = 3)
</code></pre>
<p><img src="figure_cola/tab-SD-pam-membership-heatmap-2-1.png" alt="plot of chunk tab-SD-pam-membership-heatmap-2" /></p>

</div>
<div id='tab-SD-pam-membership-heatmap-3'>
<pre><code class="language-r">membership_heatmap(res, k = 4)
</code></pre>
<p><img src="figure_cola/tab-SD-pam-membership-heatmap-3-1.png" alt="plot of chunk tab-SD-pam-membership-heatmap-3" /></p>

</div>
<div id='tab-SD-pam-membership-heatmap-4'>
<pre><code class="language-r">membership_heatmap(res, k = 5)
</code></pre>
<p><img src="figure_cola/tab-SD-pam-membership-heatmap-4-1.png" alt="plot of chunk tab-SD-pam-membership-heatmap-4" /></p>

</div>
<div id='tab-SD-pam-membership-heatmap-5'>
<pre><code class="language-r">membership_heatmap(res, k = 6)
</code></pre>
<p><img src="figure_cola/tab-SD-pam-membership-heatmap-5-1.png" alt="plot of chunk tab-SD-pam-membership-heatmap-5" /></p>

</div>
</div>

As soon as the classes for columns are determined, the signatures
that are significantly different between subgroups can be looked for. 
Following are the heatmaps for signatures.




Signature heatmaps where rows are scaled:



<script>
$( function() {
	$( '#tabs-SD-pam-get-signatures' ).tabs();
} );
</script>
<div id='tabs-SD-pam-get-signatures'>
<ul>
<li><a href='#tab-SD-pam-get-signatures-1'>k = 2</a></li>
<li><a href='#tab-SD-pam-get-signatures-2'>k = 3</a></li>
<li><a href='#tab-SD-pam-get-signatures-3'>k = 4</a></li>
<li><a href='#tab-SD-pam-get-signatures-4'>k = 5</a></li>
<li><a href='#tab-SD-pam-get-signatures-5'>k = 6</a></li>
</ul>
<div id='tab-SD-pam-get-signatures-1'>
<pre><code class="language-r">get_signatures(res, k = 2)
</code></pre>
<p><img src="figure_cola/tab-SD-pam-get-signatures-1-1.png" alt="plot of chunk tab-SD-pam-get-signatures-1" /></p>

</div>
<div id='tab-SD-pam-get-signatures-2'>
<pre><code class="language-r">get_signatures(res, k = 3)
</code></pre>
<p><img src="figure_cola/tab-SD-pam-get-signatures-2-1.png" alt="plot of chunk tab-SD-pam-get-signatures-2" /></p>

</div>
<div id='tab-SD-pam-get-signatures-3'>
<pre><code class="language-r">get_signatures(res, k = 4)
</code></pre>
<p><img src="figure_cola/tab-SD-pam-get-signatures-3-1.png" alt="plot of chunk tab-SD-pam-get-signatures-3" /></p>

</div>
<div id='tab-SD-pam-get-signatures-4'>
<pre><code class="language-r">get_signatures(res, k = 5)
</code></pre>
<p><img src="figure_cola/tab-SD-pam-get-signatures-4-1.png" alt="plot of chunk tab-SD-pam-get-signatures-4" /></p>

</div>
<div id='tab-SD-pam-get-signatures-5'>
<pre><code class="language-r">get_signatures(res, k = 6)
</code></pre>
<p><img src="figure_cola/tab-SD-pam-get-signatures-5-1.png" alt="plot of chunk tab-SD-pam-get-signatures-5" /></p>

</div>
</div>



Signature heatmaps where rows are not scaled:


<script>
$( function() {
	$( '#tabs-SD-pam-get-signatures-no-scale' ).tabs();
} );
</script>
<div id='tabs-SD-pam-get-signatures-no-scale'>
<ul>
<li><a href='#tab-SD-pam-get-signatures-no-scale-1'>k = 2</a></li>
<li><a href='#tab-SD-pam-get-signatures-no-scale-2'>k = 3</a></li>
<li><a href='#tab-SD-pam-get-signatures-no-scale-3'>k = 4</a></li>
<li><a href='#tab-SD-pam-get-signatures-no-scale-4'>k = 5</a></li>
<li><a href='#tab-SD-pam-get-signatures-no-scale-5'>k = 6</a></li>
</ul>
<div id='tab-SD-pam-get-signatures-no-scale-1'>
<pre><code class="language-r">get_signatures(res, k = 2, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-SD-pam-get-signatures-no-scale-1-1.png" alt="plot of chunk tab-SD-pam-get-signatures-no-scale-1" /></p>

</div>
<div id='tab-SD-pam-get-signatures-no-scale-2'>
<pre><code class="language-r">get_signatures(res, k = 3, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-SD-pam-get-signatures-no-scale-2-1.png" alt="plot of chunk tab-SD-pam-get-signatures-no-scale-2" /></p>

</div>
<div id='tab-SD-pam-get-signatures-no-scale-3'>
<pre><code class="language-r">get_signatures(res, k = 4, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-SD-pam-get-signatures-no-scale-3-1.png" alt="plot of chunk tab-SD-pam-get-signatures-no-scale-3" /></p>

</div>
<div id='tab-SD-pam-get-signatures-no-scale-4'>
<pre><code class="language-r">get_signatures(res, k = 5, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-SD-pam-get-signatures-no-scale-4-1.png" alt="plot of chunk tab-SD-pam-get-signatures-no-scale-4" /></p>

</div>
<div id='tab-SD-pam-get-signatures-no-scale-5'>
<pre><code class="language-r">get_signatures(res, k = 6, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-SD-pam-get-signatures-no-scale-5-1.png" alt="plot of chunk tab-SD-pam-get-signatures-no-scale-5" /></p>

</div>
</div>



Compare the overlap of signatures from different k:

``` r
compare_signatures(res)
```

![plot of chunk SD-pam-signature_compare](figure_cola/SD-pam-signature_compare-1.png)

`get_signature()` returns a data frame invisibly. To get the list of signatures, the function
call should be assigned to a variable explicitly. In following code, if `plot` argument is set
to `FALSE`, no heatmap is plotted while only the differential analysis is performed.

``` r
# code only for demonstration
tb = get_signature(res, k = ..., plot = FALSE)
```

An example of the output of `tb` is:

```
#>   which_row         fdr    mean_1    mean_2 scaled_mean_1 scaled_mean_2 km
#> 1        38 0.042760348  8.373488  9.131774    -0.5533452     0.5164555  1
#> 2        40 0.018707592  7.106213  8.469186    -0.6173731     0.5762149  1
#> 3        55 0.019134737 10.221463 11.207825    -0.6159697     0.5749050  1
#> 4        59 0.006059896  5.921854  7.869574    -0.6899429     0.6439467  1
#> 5        60 0.018055526  8.928898 10.211722    -0.6204761     0.5791110  1
#> 6        98 0.009384629 15.714769 14.887706     0.6635654    -0.6193277  2
...
```

The columns in `tb` are:

1. `which_row`: row indices corresponding to the input matrix.
2. `fdr`: FDR for the differential test. 
3. `mean_x`: The mean value in group x.
4. `scaled_mean_x`: The mean value in group x after rows are scaled.
5. `km`: Row groups if k-means clustering is applied to rows (which is done by automatically selecting number of clusters).

If there are too many signatures, `top_signatures = ...` can be set to only show the 
signatures with the highest FDRs:

``` r
# code only for demonstration
# e.g. to show the top 500 most significant rows
tb = get_signature(res, k = ..., top_signatures = 500)
```

If the signatures are defined as these which are uniquely high in current group, `diff_method` argument
can be set to `"uniquely_high_in_one_group"`:

``` r
# code only for demonstration
tb = get_signature(res, k = ..., diff_method = "uniquely_high_in_one_group")
```




UMAP plot which shows how samples are separated.


<script>
$( function() {
	$( '#tabs-SD-pam-dimension-reduction' ).tabs();
} );
</script>
<div id='tabs-SD-pam-dimension-reduction'>
<ul>
<li><a href='#tab-SD-pam-dimension-reduction-1'>k = 2</a></li>
<li><a href='#tab-SD-pam-dimension-reduction-2'>k = 3</a></li>
<li><a href='#tab-SD-pam-dimension-reduction-3'>k = 4</a></li>
<li><a href='#tab-SD-pam-dimension-reduction-4'>k = 5</a></li>
<li><a href='#tab-SD-pam-dimension-reduction-5'>k = 6</a></li>
</ul>
<div id='tab-SD-pam-dimension-reduction-1'>
<pre><code class="language-r">dimension_reduction(res, k = 2, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-SD-pam-dimension-reduction-1-1.png" alt="plot of chunk tab-SD-pam-dimension-reduction-1" /></p>

</div>
<div id='tab-SD-pam-dimension-reduction-2'>
<pre><code class="language-r">dimension_reduction(res, k = 3, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-SD-pam-dimension-reduction-2-1.png" alt="plot of chunk tab-SD-pam-dimension-reduction-2" /></p>

</div>
<div id='tab-SD-pam-dimension-reduction-3'>
<pre><code class="language-r">dimension_reduction(res, k = 4, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-SD-pam-dimension-reduction-3-1.png" alt="plot of chunk tab-SD-pam-dimension-reduction-3" /></p>

</div>
<div id='tab-SD-pam-dimension-reduction-4'>
<pre><code class="language-r">dimension_reduction(res, k = 5, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-SD-pam-dimension-reduction-4-1.png" alt="plot of chunk tab-SD-pam-dimension-reduction-4" /></p>

</div>
<div id='tab-SD-pam-dimension-reduction-5'>
<pre><code class="language-r">dimension_reduction(res, k = 6, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-SD-pam-dimension-reduction-5-1.png" alt="plot of chunk tab-SD-pam-dimension-reduction-5" /></p>

</div>
</div>



Following heatmap shows how subgroups are split when increasing `k`:

``` r
collect_classes(res)
```

![plot of chunk SD-pam-collect-classes](figure_cola/SD-pam-collect-classes-1.png)



If matrix rows can be associated to genes, consider to use `functional_enrichment(res,
...)` to perform function enrichment for the signature genes. See [this vignette](https://jokergoo.github.io/cola_vignettes/functional_enrichment.html) for more detailed explanations.


 

---------------------------------------------------



### SD:skmeans






The object with results only for a single top-value method and a single partitioning method 
can be extracted as:

``` r
res = res_list["SD", "skmeans"]
# you can also extract it by
# res = res_list["SD:skmeans"]
```

A summary of `res` and all the functions that can be applied to it:

``` r
res
```

```
#> A 'ConsensusPartition' object with k = 2, 3, 4, 5, 6.
#>   On a matrix with 1900 rows and 60 columns.
#>   Top rows (123) are extracted by 'SD' method.
#>   Subgroups are detected by 'skmeans' method.
#>   Performed in total 250 partitions by row resampling.
#>   Best k for subgroups seems to be 2.
#> 
#> Following methods can be applied to this 'ConsensusPartition' object:
#>  [1] "cola_report"             "collect_classes"         "collect_plots"          
#>  [4] "collect_stats"           "colnames"                "compare_partitions"     
#>  [7] "compare_signatures"      "consensus_heatmap"       "dimension_reduction"    
#> [10] "functional_enrichment"   "get_anno_col"            "get_anno"               
#> [13] "get_classes"             "get_consensus"           "get_matrix"             
#> [16] "get_membership"          "get_param"               "get_signatures"         
#> [19] "get_stats"               "is_best_k"               "is_stable_k"            
#> [22] "membership_heatmap"      "ncol"                    "nrow"                   
#> [25] "plot_ecdf"               "predict_classes"         "rownames"               
#> [28] "select_partition_number" "show"                    "suggest_best_k"         
#> [31] "test_to_known_factors"   "top_rows_heatmap"
```

`collect_plots()` function collects all the plots made from `res` for all `k` (number of subgroups)
into one single page to provide an easy and fast comparison between different `k`.

``` r
collect_plots(res)
```

![plot of chunk SD-skmeans-collect-plots](figure_cola/SD-skmeans-collect-plots-1.png)

The plots are:

- The first row: a plot of the eCDF (empirical cumulative distribution
  function) curves of the consensus matrix for each `k` and the heatmap of
  predicted classes for each `k`.
- The second row: heatmaps of the consensus matrix for each `k`.
- The third row: heatmaps of the membership matrix for each `k`.
- The fouth row: heatmaps of the signatures for each `k`.

All the plots in panels can be made by individual functions and they are
plotted later in this section.

`select_partition_number()` produces several plots showing different
statistics for choosing "optimized" `k`. There are following statistics:

- eCDF curves of the consensus matrix for each `k`;
- 1-PAC. [The PAC score](https://en.wikipedia.org/wiki/Consensus_clustering#Over-interpretation_potential_of_consensus_clustering)
  measures the proportion of the ambiguous subgrouping.
- Mean silhouette score.
- Concordance. The mean probability of fiting the consensus subgroup labels in all
  partitions.
- Area increased. Denote $A_k$ as the area under the eCDF curve for current
  `k`, the area increased is defined as $A_k - A_{k-1}$.
- Rand index. The percent of pairs of samples that are both in a same cluster
  or both are not in a same cluster in the partition of k and k-1.
- Jaccard index. The ratio of pairs of samples are both in a same cluster in
  the partition of k and k-1 and the pairs of samples are both in a same
  cluster in the partition k or k-1.

The detailed explanations of these statistics can be found in [the _cola_
vignette](https://jokergoo.github.io/cola_vignettes/cola.html#toc_13).

Generally speaking, higher 1-PAC score, higher mean silhouette score or higher
concordance corresponds to better partition. Rand index and Jaccard index
measure how similar the current partition is compared to partition with `k-1`.
If they are too similar, we won't accept `k` is better than `k-1`.

``` r
select_partition_number(res)
```

![plot of chunk SD-skmeans-select-partition-number](figure_cola/SD-skmeans-select-partition-number-1.png)

The numeric values for all these statistics can be obtained by `get_stats()`.

``` r
get_stats(res)
```

```
#>   k 1-PAC mean_silhouette concordance area_increased  Rand Jaccard
#> 2 2 0.857           0.922       0.966         0.5084 0.492   0.492
#> 3 3 0.632           0.783       0.887         0.3101 0.780   0.578
#> 4 4 0.631           0.741       0.856         0.1136 0.823   0.540
#> 5 5 0.625           0.570       0.776         0.0655 0.967   0.879
#> 6 6 0.612           0.411       0.690         0.0416 0.900   0.623
```

`suggest_best_k()` suggests the best $k$ based on these statistics. The rules are as follows:

- All $k$ with Jaccard index larger than 0.95 are removed because increasing
  $k$ does not provide enough extra information. If all $k$ are removed, it is
  marked as no subgroup is detected.
- For all $k$ with 1-PAC score larger than 0.9, the maximal $k$ is taken as
  the best $k$, and other $k$ are marked as optional $k$.
- If it does not fit the second rule. The $k$ with the maximal vote of the
  highest 1-PAC score, highest mean silhouette, and highest concordance is
  taken as the best $k$.

``` r
suggest_best_k(res)
```

```
#> [1] 2
```


Following is the table of the partitions (You need to click the **show/hide
code output** link to see it). The membership matrix (columns with name `p*`)
is inferred by
[`clue::cl_consensus()`](https://www.rdocumentation.org/link/cl_consensus?package=clue)
function with the `SE` method. Basically the value in the membership matrix
represents the probability to belong to a certain group. The finall subgroup
label for an item is determined with the group with highest probability it
belongs to.

In `get_classes()` function, the entropy is calculated from the membership
matrix and the silhouette score is calculated from the consensus matrix.



<script>
$( function() {
	$( '#tabs-SD-skmeans-get-classes' ).tabs();
} );
</script>
<div id='tabs-SD-skmeans-get-classes'>
<ul>
<li><a href='#tab-SD-skmeans-get-classes-1'>k = 2</a></li>
<li><a href='#tab-SD-skmeans-get-classes-2'>k = 3</a></li>
<li><a href='#tab-SD-skmeans-get-classes-3'>k = 4</a></li>
<li><a href='#tab-SD-skmeans-get-classes-4'>k = 5</a></li>
<li><a href='#tab-SD-skmeans-get-classes-5'>k = 6</a></li>
</ul>

<div id='tab-SD-skmeans-get-classes-1'>
<p><a id='tab-SD-skmeans-get-classes-1-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 2), get_membership(res, k = 2))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2
#&gt; SIH013     1   0.000      0.976 1.00 0.00
#&gt; SIH014     2   0.000      0.952 0.00 1.00
#&gt; SIH024     1   0.242      0.947 0.96 0.04
#&gt; SIH028     2   0.000      0.952 0.00 1.00
#&gt; SIH031     1   0.000      0.976 1.00 0.00
#&gt; SIH042     1   0.000      0.976 1.00 0.00
#&gt; SIH107     2   0.000      0.952 0.00 1.00
#&gt; SIH114     1   0.000      0.976 1.00 0.00
#&gt; SIH116     2   0.760      0.724 0.22 0.78
#&gt; SIH117     2   0.402      0.886 0.08 0.92
#&gt; SIH130     2   0.000      0.952 0.00 1.00
#&gt; SIH134     2   0.000      0.952 0.00 1.00
#&gt; SIH186     2   0.000      0.952 0.00 1.00
#&gt; SIH191     1   0.000      0.976 1.00 0.00
#&gt; SIH192     2   0.000      0.952 0.00 1.00
#&gt; SIH196     2   0.000      0.952 0.00 1.00
#&gt; SIH214     2   0.000      0.952 0.00 1.00
#&gt; SIH218     2   0.958      0.413 0.38 0.62
#&gt; SIH232     1   0.000      0.976 1.00 0.00
#&gt; SIH236     1   0.402      0.909 0.92 0.08
#&gt; SIH238     1   0.000      0.976 1.00 0.00
#&gt; SIH241     2   0.000      0.952 0.00 1.00
#&gt; SIH245     2   0.000      0.952 0.00 1.00
#&gt; SIH260     2   0.141      0.938 0.02 0.98
#&gt; SIH287     2   0.000      0.952 0.00 1.00
#&gt; SIH289     2   0.242      0.922 0.04 0.96
#&gt; SIH290     2   0.000      0.952 0.00 1.00
#&gt; SIH295     1   0.000      0.976 1.00 0.00
#&gt; SIH366     1   0.000      0.976 1.00 0.00
#&gt; SIH377     1   0.000      0.976 1.00 0.00
#&gt; SIH380     2   0.000      0.952 0.00 1.00
#&gt; SIH385     2   0.000      0.952 0.00 1.00
#&gt; SIH389     2   0.000      0.952 0.00 1.00
#&gt; SIH391     2   0.000      0.952 0.00 1.00
#&gt; SIH403     1   0.000      0.976 1.00 0.00
#&gt; SIH411     2   0.000      0.952 0.00 1.00
#&gt; SIH427     1   0.000      0.976 1.00 0.00
#&gt; SIH433     2   0.722      0.746 0.20 0.80
#&gt; SIH439     1   0.000      0.976 1.00 0.00
#&gt; SIH442     1   0.000      0.976 1.00 0.00
#&gt; SIH444     1   0.584      0.843 0.86 0.14
#&gt; SIH452     2   0.000      0.952 0.00 1.00
#&gt; SIH461     1   0.000      0.976 1.00 0.00
#&gt; SIH471     1   0.000      0.976 1.00 0.00
#&gt; SIH472     2   0.000      0.952 0.00 1.00
#&gt; SIH481     1   0.000      0.976 1.00 0.00
#&gt; SIH485     2   0.000      0.952 0.00 1.00
#&gt; SIH491     2   0.000      0.952 0.00 1.00
#&gt; SIH508     1   0.000      0.976 1.00 0.00
#&gt; SIH559     1   0.000      0.976 1.00 0.00
#&gt; SIH587     1   0.000      0.976 1.00 0.00
#&gt; SIH625     2   0.000      0.952 0.00 1.00
#&gt; SIH641     1   0.000      0.976 1.00 0.00
#&gt; SIH643     1   0.584      0.843 0.86 0.14
#&gt; SIH674     1   0.000      0.976 1.00 0.00
#&gt; SIH678     1   0.000      0.976 1.00 0.00
#&gt; SIH679     1   0.402      0.910 0.92 0.08
#&gt; SIH689     2   0.995      0.170 0.46 0.54
#&gt; SIH694     2   0.000      0.952 0.00 1.00
#&gt; SIH721     1   0.634      0.811 0.84 0.16
</code></pre>

<script>
$('#tab-SD-skmeans-get-classes-1-a').parent().next().next().hide();
$('#tab-SD-skmeans-get-classes-1-a').click(function(){
  $('#tab-SD-skmeans-get-classes-1-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-SD-skmeans-get-classes-2'>
<p><a id='tab-SD-skmeans-get-classes-2-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 3), get_membership(res, k = 3))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3
#&gt; SIH013     3  0.4796    0.69572 0.22 0.00 0.78
#&gt; SIH014     3  0.2537    0.76273 0.00 0.08 0.92
#&gt; SIH024     3  0.2537    0.80082 0.08 0.00 0.92
#&gt; SIH028     2  0.5560    0.71840 0.00 0.70 0.30
#&gt; SIH031     1  0.6302   -0.00082 0.52 0.00 0.48
#&gt; SIH042     1  0.0000    0.92414 1.00 0.00 0.00
#&gt; SIH107     2  0.1529    0.84419 0.00 0.96 0.04
#&gt; SIH114     1  0.0000    0.92414 1.00 0.00 0.00
#&gt; SIH116     2  0.4291    0.63361 0.18 0.82 0.00
#&gt; SIH117     3  0.0000    0.80986 0.00 0.00 1.00
#&gt; SIH130     2  0.5397    0.75011 0.00 0.72 0.28
#&gt; SIH134     2  0.5397    0.75011 0.00 0.72 0.28
#&gt; SIH186     2  0.2959    0.84311 0.00 0.90 0.10
#&gt; SIH191     1  0.0000    0.92414 1.00 0.00 0.00
#&gt; SIH192     2  0.1529    0.84419 0.00 0.96 0.04
#&gt; SIH196     2  0.4555    0.80839 0.00 0.80 0.20
#&gt; SIH214     3  0.5016    0.54366 0.00 0.24 0.76
#&gt; SIH218     3  0.9899    0.22267 0.32 0.28 0.40
#&gt; SIH232     1  0.0000    0.92414 1.00 0.00 0.00
#&gt; SIH236     1  0.5016    0.68867 0.76 0.24 0.00
#&gt; SIH238     1  0.4555    0.70580 0.80 0.00 0.20
#&gt; SIH241     3  0.5397    0.42634 0.00 0.28 0.72
#&gt; SIH245     2  0.4796    0.79432 0.00 0.78 0.22
#&gt; SIH260     2  0.0000    0.83271 0.00 1.00 0.00
#&gt; SIH287     2  0.0000    0.83271 0.00 1.00 0.00
#&gt; SIH289     2  0.0000    0.83271 0.00 1.00 0.00
#&gt; SIH290     2  0.4002    0.82661 0.00 0.84 0.16
#&gt; SIH295     1  0.0000    0.92414 1.00 0.00 0.00
#&gt; SIH366     1  0.0000    0.92414 1.00 0.00 0.00
#&gt; SIH377     1  0.0000    0.92414 1.00 0.00 0.00
#&gt; SIH380     2  0.5706    0.69878 0.00 0.68 0.32
#&gt; SIH385     3  0.0000    0.80986 0.00 0.00 1.00
#&gt; SIH389     2  0.2066    0.84612 0.00 0.94 0.06
#&gt; SIH391     2  0.0000    0.83271 0.00 1.00 0.00
#&gt; SIH403     1  0.0000    0.92414 1.00 0.00 0.00
#&gt; SIH411     2  0.3686    0.83369 0.00 0.86 0.14
#&gt; SIH427     1  0.0000    0.92414 1.00 0.00 0.00
#&gt; SIH433     3  0.0000    0.80986 0.00 0.00 1.00
#&gt; SIH439     1  0.5216    0.60419 0.74 0.00 0.26
#&gt; SIH442     1  0.0000    0.92414 1.00 0.00 0.00
#&gt; SIH444     3  0.4002    0.76587 0.16 0.00 0.84
#&gt; SIH452     2  0.0000    0.83271 0.00 1.00 0.00
#&gt; SIH461     3  0.4555    0.71701 0.20 0.00 0.80
#&gt; SIH471     1  0.0000    0.92414 1.00 0.00 0.00
#&gt; SIH472     2  0.2066    0.84612 0.00 0.94 0.06
#&gt; SIH481     1  0.0000    0.92414 1.00 0.00 0.00
#&gt; SIH485     3  0.2959    0.74399 0.00 0.10 0.90
#&gt; SIH491     2  0.6192    0.51870 0.00 0.58 0.42
#&gt; SIH508     1  0.0000    0.92414 1.00 0.00 0.00
#&gt; SIH559     1  0.0000    0.92414 1.00 0.00 0.00
#&gt; SIH587     1  0.0000    0.92414 1.00 0.00 0.00
#&gt; SIH625     2  0.0000    0.83271 0.00 1.00 0.00
#&gt; SIH641     1  0.2537    0.86066 0.92 0.00 0.08
#&gt; SIH643     3  0.4002    0.76656 0.16 0.00 0.84
#&gt; SIH674     1  0.0000    0.92414 1.00 0.00 0.00
#&gt; SIH678     1  0.0000    0.92414 1.00 0.00 0.00
#&gt; SIH679     1  0.4555    0.73493 0.80 0.20 0.00
#&gt; SIH689     3  0.0000    0.80986 0.00 0.00 1.00
#&gt; SIH694     2  0.5948    0.64399 0.00 0.64 0.36
#&gt; SIH721     3  0.0892    0.81170 0.02 0.00 0.98
</code></pre>

<script>
$('#tab-SD-skmeans-get-classes-2-a').parent().next().next().hide();
$('#tab-SD-skmeans-get-classes-2-a').click(function(){
  $('#tab-SD-skmeans-get-classes-2-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-SD-skmeans-get-classes-3'>
<p><a id='tab-SD-skmeans-get-classes-3-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 4), get_membership(res, k = 4))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3   p4
#&gt; SIH013     3  0.2011      0.773 0.08 0.00 0.92 0.00
#&gt; SIH014     2  0.5173      0.452 0.00 0.66 0.32 0.02
#&gt; SIH024     3  0.1637      0.799 0.00 0.06 0.94 0.00
#&gt; SIH028     2  0.1211      0.804 0.00 0.96 0.00 0.04
#&gt; SIH031     3  0.5487      0.272 0.40 0.00 0.58 0.02
#&gt; SIH042     1  0.1637      0.888 0.94 0.00 0.00 0.06
#&gt; SIH107     2  0.3975      0.644 0.00 0.76 0.00 0.24
#&gt; SIH114     1  0.3037      0.886 0.88 0.00 0.02 0.10
#&gt; SIH116     4  0.2706      0.809 0.02 0.08 0.00 0.90
#&gt; SIH117     3  0.3247      0.787 0.00 0.06 0.88 0.06
#&gt; SIH130     2  0.0000      0.812 0.00 1.00 0.00 0.00
#&gt; SIH134     2  0.0000      0.812 0.00 1.00 0.00 0.00
#&gt; SIH186     2  0.3172      0.735 0.00 0.84 0.00 0.16
#&gt; SIH191     1  0.3037      0.882 0.88 0.00 0.02 0.10
#&gt; SIH192     2  0.5606      0.079 0.00 0.50 0.02 0.48
#&gt; SIH196     2  0.0707      0.812 0.00 0.98 0.00 0.02
#&gt; SIH214     2  0.6366      0.518 0.00 0.64 0.24 0.12
#&gt; SIH218     4  0.7651      0.260 0.16 0.02 0.28 0.54
#&gt; SIH232     1  0.0000      0.902 1.00 0.00 0.00 0.00
#&gt; SIH236     4  0.4021      0.726 0.12 0.02 0.02 0.84
#&gt; SIH238     1  0.6453      0.389 0.56 0.00 0.36 0.08
#&gt; SIH241     2  0.4797      0.563 0.00 0.72 0.26 0.02
#&gt; SIH245     2  0.1211      0.804 0.00 0.96 0.00 0.04
#&gt; SIH260     4  0.2647      0.820 0.00 0.12 0.00 0.88
#&gt; SIH287     4  0.3801      0.759 0.00 0.22 0.00 0.78
#&gt; SIH289     4  0.2647      0.819 0.00 0.12 0.00 0.88
#&gt; SIH290     2  0.0707      0.810 0.00 0.98 0.00 0.02
#&gt; SIH295     1  0.0707      0.900 0.98 0.00 0.00 0.02
#&gt; SIH366     1  0.0000      0.902 1.00 0.00 0.00 0.00
#&gt; SIH377     1  0.0707      0.903 0.98 0.00 0.00 0.02
#&gt; SIH380     2  0.1637      0.797 0.00 0.94 0.06 0.00
#&gt; SIH385     3  0.5487      0.326 0.00 0.40 0.58 0.02
#&gt; SIH389     2  0.3400      0.715 0.00 0.82 0.00 0.18
#&gt; SIH391     4  0.4472      0.738 0.02 0.22 0.00 0.76
#&gt; SIH403     1  0.1913      0.898 0.94 0.00 0.04 0.02
#&gt; SIH411     2  0.1211      0.804 0.00 0.96 0.00 0.04
#&gt; SIH427     1  0.2706      0.892 0.90 0.00 0.02 0.08
#&gt; SIH433     3  0.1637      0.799 0.00 0.06 0.94 0.00
#&gt; SIH439     1  0.4939      0.619 0.74 0.00 0.22 0.04
#&gt; SIH442     1  0.0000      0.902 1.00 0.00 0.00 0.00
#&gt; SIH444     3  0.4905      0.758 0.12 0.06 0.80 0.02
#&gt; SIH452     4  0.3172      0.804 0.00 0.16 0.00 0.84
#&gt; SIH461     3  0.2921      0.771 0.14 0.00 0.86 0.00
#&gt; SIH471     1  0.2011      0.895 0.92 0.00 0.00 0.08
#&gt; SIH472     2  0.3400      0.715 0.00 0.82 0.00 0.18
#&gt; SIH481     1  0.0000      0.902 1.00 0.00 0.00 0.00
#&gt; SIH485     2  0.5512      0.492 0.00 0.66 0.30 0.04
#&gt; SIH491     2  0.2706      0.763 0.00 0.90 0.08 0.02
#&gt; SIH508     1  0.0000      0.902 1.00 0.00 0.00 0.00
#&gt; SIH559     1  0.2830      0.888 0.90 0.00 0.04 0.06
#&gt; SIH587     1  0.3525      0.874 0.86 0.00 0.04 0.10
#&gt; SIH625     4  0.2647      0.819 0.00 0.12 0.00 0.88
#&gt; SIH641     1  0.5512      0.552 0.66 0.00 0.30 0.04
#&gt; SIH643     3  0.3037      0.783 0.10 0.00 0.88 0.02
#&gt; SIH674     1  0.0000      0.902 1.00 0.00 0.00 0.00
#&gt; SIH678     1  0.2335      0.895 0.92 0.00 0.02 0.06
#&gt; SIH679     4  0.3853      0.687 0.16 0.00 0.02 0.82
#&gt; SIH689     3  0.1211      0.797 0.00 0.04 0.96 0.00
#&gt; SIH694     2  0.0000      0.812 0.00 1.00 0.00 0.00
#&gt; SIH721     3  0.4797      0.630 0.00 0.26 0.72 0.02
</code></pre>

<script>
$('#tab-SD-skmeans-get-classes-3-a').parent().next().next().hide();
$('#tab-SD-skmeans-get-classes-3-a').click(function(){
  $('#tab-SD-skmeans-get-classes-3-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-SD-skmeans-get-classes-4'>
<p><a id='tab-SD-skmeans-get-classes-4-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 5), get_membership(res, k = 5))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3   p4   p5
#&gt; SIH013     3  0.4252      0.469 0.02 0.00 0.70 0.00 0.28
#&gt; SIH014     2  0.6244      0.319 0.00 0.54 0.20 0.00 0.26
#&gt; SIH024     3  0.3852      0.638 0.02 0.00 0.76 0.00 0.22
#&gt; SIH028     2  0.5150      0.687 0.00 0.74 0.08 0.04 0.14
#&gt; SIH031     1  0.6746     -0.381 0.38 0.00 0.26 0.00 0.36
#&gt; SIH042     1  0.3868      0.619 0.80 0.00 0.00 0.06 0.14
#&gt; SIH107     2  0.3895      0.522 0.00 0.68 0.00 0.32 0.00
#&gt; SIH114     1  0.5425      0.270 0.52 0.00 0.00 0.06 0.42
#&gt; SIH116     4  0.2280      0.757 0.00 0.00 0.00 0.88 0.12
#&gt; SIH117     3  0.3627      0.650 0.02 0.04 0.86 0.02 0.06
#&gt; SIH130     2  0.2012      0.747 0.00 0.92 0.02 0.00 0.06
#&gt; SIH134     2  0.2012      0.747 0.00 0.92 0.02 0.00 0.06
#&gt; SIH186     2  0.2732      0.696 0.00 0.84 0.00 0.16 0.00
#&gt; SIH191     1  0.3852      0.629 0.76 0.00 0.00 0.02 0.22
#&gt; SIH192     2  0.6017      0.213 0.00 0.50 0.04 0.42 0.04
#&gt; SIH196     2  0.2754      0.749 0.00 0.88 0.00 0.08 0.04
#&gt; SIH214     2  0.7436      0.206 0.00 0.42 0.24 0.04 0.30
#&gt; SIH218     5  0.6379      0.502 0.08 0.00 0.10 0.18 0.64
#&gt; SIH232     1  0.0000      0.687 1.00 0.00 0.00 0.00 0.00
#&gt; SIH236     4  0.3037      0.724 0.04 0.00 0.00 0.86 0.10
#&gt; SIH238     5  0.6124      0.413 0.30 0.00 0.10 0.02 0.58
#&gt; SIH241     2  0.5263      0.497 0.00 0.66 0.24 0.00 0.10
#&gt; SIH245     2  0.0609      0.752 0.00 0.98 0.00 0.02 0.00
#&gt; SIH260     4  0.0609      0.824 0.00 0.02 0.00 0.98 0.00
#&gt; SIH287     4  0.2020      0.781 0.00 0.10 0.00 0.90 0.00
#&gt; SIH289     4  0.1043      0.822 0.00 0.04 0.00 0.96 0.00
#&gt; SIH290     2  0.0000      0.750 0.00 1.00 0.00 0.00 0.00
#&gt; SIH295     1  0.1732      0.685 0.92 0.00 0.00 0.00 0.08
#&gt; SIH366     1  0.2020      0.653 0.90 0.00 0.00 0.00 0.10
#&gt; SIH377     1  0.1043      0.690 0.96 0.00 0.00 0.00 0.04
#&gt; SIH380     2  0.2077      0.743 0.00 0.92 0.04 0.00 0.04
#&gt; SIH385     3  0.6149      0.265 0.00 0.36 0.50 0.00 0.14
#&gt; SIH389     2  0.3561      0.597 0.00 0.74 0.00 0.26 0.00
#&gt; SIH391     4  0.5524      0.504 0.02 0.28 0.00 0.64 0.06
#&gt; SIH403     1  0.3291      0.607 0.84 0.00 0.04 0.00 0.12
#&gt; SIH411     2  0.1043      0.753 0.00 0.96 0.00 0.04 0.00
#&gt; SIH427     1  0.4540      0.480 0.64 0.00 0.00 0.02 0.34
#&gt; SIH433     3  0.2077      0.684 0.00 0.04 0.92 0.00 0.04
#&gt; SIH439     1  0.5690      0.256 0.66 0.00 0.10 0.02 0.22
#&gt; SIH442     1  0.0000      0.687 1.00 0.00 0.00 0.00 0.00
#&gt; SIH444     3  0.4748      0.551 0.14 0.02 0.76 0.00 0.08
#&gt; SIH452     4  0.1043      0.822 0.00 0.04 0.00 0.96 0.00
#&gt; SIH461     3  0.5210      0.562 0.12 0.00 0.68 0.00 0.20
#&gt; SIH471     1  0.3852      0.613 0.76 0.00 0.00 0.02 0.22
#&gt; SIH472     2  0.3274      0.645 0.00 0.78 0.00 0.22 0.00
#&gt; SIH481     1  0.0000      0.687 1.00 0.00 0.00 0.00 0.00
#&gt; SIH485     2  0.6438      0.250 0.00 0.50 0.22 0.00 0.28
#&gt; SIH491     2  0.2754      0.723 0.00 0.88 0.04 0.00 0.08
#&gt; SIH508     1  0.0609      0.688 0.98 0.00 0.00 0.00 0.02
#&gt; SIH559     1  0.4726      0.279 0.58 0.00 0.02 0.00 0.40
#&gt; SIH587     1  0.4675      0.448 0.60 0.00 0.00 0.02 0.38
#&gt; SIH625     4  0.0609      0.824 0.00 0.02 0.00 0.98 0.00
#&gt; SIH641     1  0.6244      0.247 0.54 0.00 0.26 0.00 0.20
#&gt; SIH643     3  0.5978      0.612 0.10 0.04 0.70 0.02 0.14
#&gt; SIH674     1  0.0609      0.688 0.98 0.00 0.00 0.00 0.02
#&gt; SIH678     1  0.4675      0.322 0.60 0.00 0.02 0.00 0.38
#&gt; SIH679     4  0.5130      0.430 0.10 0.00 0.00 0.68 0.22
#&gt; SIH689     3  0.2012      0.666 0.00 0.02 0.92 0.00 0.06
#&gt; SIH694     2  0.2616      0.734 0.00 0.88 0.02 0.00 0.10
#&gt; SIH721     3  0.5927      0.504 0.00 0.12 0.54 0.00 0.34
</code></pre>

<script>
$('#tab-SD-skmeans-get-classes-4-a').parent().next().next().hide();
$('#tab-SD-skmeans-get-classes-4-a').click(function(){
  $('#tab-SD-skmeans-get-classes-4-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-SD-skmeans-get-classes-5'>
<p><a id='tab-SD-skmeans-get-classes-5-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 6), get_membership(res, k = 6))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3   p4   p5   p6
#&gt; SIH013     3  0.5896    -0.0464 0.32 0.00 0.54 0.00 0.04 0.10
#&gt; SIH014     3  0.6939     0.1737 0.28 0.14 0.46 0.00 0.00 0.12
#&gt; SIH024     3  0.4162     0.2320 0.12 0.00 0.78 0.00 0.04 0.06
#&gt; SIH028     2  0.6335     0.4338 0.22 0.56 0.14 0.00 0.00 0.08
#&gt; SIH031     1  0.7532    -0.0556 0.34 0.00 0.16 0.00 0.28 0.22
#&gt; SIH042     5  0.4810     0.3659 0.00 0.00 0.00 0.12 0.66 0.22
#&gt; SIH107     2  0.3351     0.6918 0.00 0.80 0.00 0.16 0.00 0.04
#&gt; SIH114     6  0.3869    -0.1099 0.00 0.00 0.00 0.00 0.50 0.50
#&gt; SIH116     4  0.2350     0.7673 0.00 0.02 0.00 0.88 0.00 0.10
#&gt; SIH117     1  0.2981     0.3832 0.82 0.00 0.16 0.00 0.00 0.02
#&gt; SIH130     2  0.3523     0.6753 0.04 0.78 0.18 0.00 0.00 0.00
#&gt; SIH134     2  0.1814     0.7262 0.00 0.90 0.10 0.00 0.00 0.00
#&gt; SIH186     2  0.2581     0.7204 0.00 0.86 0.00 0.12 0.00 0.02
#&gt; SIH191     5  0.4144     0.2227 0.00 0.00 0.00 0.02 0.62 0.36
#&gt; SIH192     2  0.7234     0.4695 0.14 0.52 0.04 0.20 0.00 0.10
#&gt; SIH196     2  0.2956     0.7196 0.00 0.84 0.12 0.04 0.00 0.00
#&gt; SIH214     3  0.7706     0.1723 0.22 0.26 0.40 0.04 0.00 0.08
#&gt; SIH218     6  0.8244    -0.2531 0.20 0.04 0.18 0.14 0.02 0.42
#&gt; SIH232     5  0.0000     0.6081 0.00 0.00 0.00 0.00 1.00 0.00
#&gt; SIH236     4  0.3156     0.7021 0.00 0.00 0.00 0.80 0.02 0.18
#&gt; SIH238     6  0.6502    -0.0340 0.04 0.00 0.40 0.02 0.10 0.44
#&gt; SIH241     2  0.6882     0.3115 0.30 0.44 0.18 0.00 0.00 0.08
#&gt; SIH245     2  0.2880     0.7410 0.02 0.88 0.06 0.02 0.00 0.02
#&gt; SIH260     4  0.1480     0.7852 0.00 0.04 0.00 0.94 0.00 0.02
#&gt; SIH287     4  0.3523     0.6911 0.00 0.18 0.00 0.78 0.00 0.04
#&gt; SIH289     4  0.0000     0.7843 0.00 0.00 0.00 1.00 0.00 0.00
#&gt; SIH290     2  0.3633     0.7384 0.04 0.84 0.06 0.02 0.00 0.04
#&gt; SIH295     5  0.1814     0.5834 0.00 0.00 0.00 0.00 0.90 0.10
#&gt; SIH366     5  0.2790     0.5224 0.02 0.00 0.00 0.00 0.84 0.14
#&gt; SIH377     5  0.2631     0.5116 0.00 0.00 0.00 0.00 0.82 0.18
#&gt; SIH380     2  0.4210     0.6896 0.02 0.78 0.14 0.02 0.00 0.04
#&gt; SIH385     1  0.6639    -0.1447 0.40 0.12 0.40 0.00 0.00 0.08
#&gt; SIH389     2  0.3351     0.6910 0.00 0.80 0.00 0.16 0.00 0.04
#&gt; SIH391     4  0.6129     0.5951 0.06 0.24 0.02 0.60 0.00 0.08
#&gt; SIH403     5  0.4860     0.4485 0.04 0.00 0.10 0.00 0.72 0.14
#&gt; SIH411     2  0.2020     0.7394 0.00 0.92 0.02 0.04 0.00 0.02
#&gt; SIH427     5  0.4337    -0.1015 0.00 0.00 0.00 0.02 0.50 0.48
#&gt; SIH433     1  0.4144     0.2911 0.62 0.02 0.36 0.00 0.00 0.00
#&gt; SIH439     5  0.7120     0.1569 0.14 0.00 0.10 0.04 0.54 0.18
#&gt; SIH442     5  0.1267     0.5997 0.00 0.00 0.00 0.00 0.94 0.06
#&gt; SIH444     1  0.3688     0.3375 0.80 0.00 0.02 0.00 0.14 0.04
#&gt; SIH452     4  0.3321     0.7564 0.00 0.10 0.00 0.82 0.00 0.08
#&gt; SIH461     3  0.5679     0.1531 0.12 0.00 0.64 0.00 0.18 0.06
#&gt; SIH471     5  0.3578     0.2472 0.00 0.00 0.00 0.00 0.66 0.34
#&gt; SIH472     2  0.3688     0.7022 0.00 0.80 0.02 0.14 0.00 0.04
#&gt; SIH481     5  0.1480     0.5790 0.00 0.00 0.02 0.00 0.94 0.04
#&gt; SIH485     3  0.7132     0.1617 0.26 0.22 0.42 0.00 0.00 0.10
#&gt; SIH491     2  0.5034     0.6329 0.16 0.70 0.10 0.00 0.00 0.04
#&gt; SIH508     5  0.0937     0.6005 0.00 0.00 0.00 0.00 0.96 0.04
#&gt; SIH559     6  0.4328     0.1221 0.00 0.00 0.02 0.00 0.46 0.52
#&gt; SIH587     5  0.4337    -0.1259 0.00 0.00 0.00 0.02 0.50 0.48
#&gt; SIH625     4  0.1807     0.7804 0.00 0.06 0.00 0.92 0.00 0.02
#&gt; SIH641     6  0.7525     0.0698 0.12 0.02 0.08 0.02 0.38 0.38
#&gt; SIH643     1  0.5977     0.2355 0.58 0.00 0.22 0.00 0.16 0.04
#&gt; SIH674     5  0.0000     0.6081 0.00 0.00 0.00 0.00 1.00 0.00
#&gt; SIH678     6  0.4337     0.0810 0.00 0.00 0.02 0.00 0.48 0.50
#&gt; SIH679     4  0.5626     0.3289 0.02 0.00 0.00 0.54 0.10 0.34
#&gt; SIH689     1  0.3950     0.3420 0.72 0.00 0.24 0.00 0.00 0.04
#&gt; SIH694     2  0.5523     0.5419 0.06 0.64 0.22 0.00 0.00 0.08
#&gt; SIH721     3  0.4259     0.2788 0.06 0.06 0.80 0.00 0.02 0.06
</code></pre>

<script>
$('#tab-SD-skmeans-get-classes-5-a').parent().next().next().hide();
$('#tab-SD-skmeans-get-classes-5-a').click(function(){
  $('#tab-SD-skmeans-get-classes-5-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>
</div>

Heatmaps for the consensus matrix. It visualizes the probability of two
samples to be in a same group.




<script>
$( function() {
	$( '#tabs-SD-skmeans-consensus-heatmap' ).tabs();
} );
</script>
<div id='tabs-SD-skmeans-consensus-heatmap'>
<ul>
<li><a href='#tab-SD-skmeans-consensus-heatmap-1'>k = 2</a></li>
<li><a href='#tab-SD-skmeans-consensus-heatmap-2'>k = 3</a></li>
<li><a href='#tab-SD-skmeans-consensus-heatmap-3'>k = 4</a></li>
<li><a href='#tab-SD-skmeans-consensus-heatmap-4'>k = 5</a></li>
<li><a href='#tab-SD-skmeans-consensus-heatmap-5'>k = 6</a></li>
</ul>
<div id='tab-SD-skmeans-consensus-heatmap-1'>
<pre><code class="language-r">consensus_heatmap(res, k = 2)
</code></pre>
<p><img src="figure_cola/tab-SD-skmeans-consensus-heatmap-1-1.png" alt="plot of chunk tab-SD-skmeans-consensus-heatmap-1" /></p>

</div>
<div id='tab-SD-skmeans-consensus-heatmap-2'>
<pre><code class="language-r">consensus_heatmap(res, k = 3)
</code></pre>
<p><img src="figure_cola/tab-SD-skmeans-consensus-heatmap-2-1.png" alt="plot of chunk tab-SD-skmeans-consensus-heatmap-2" /></p>

</div>
<div id='tab-SD-skmeans-consensus-heatmap-3'>
<pre><code class="language-r">consensus_heatmap(res, k = 4)
</code></pre>
<p><img src="figure_cola/tab-SD-skmeans-consensus-heatmap-3-1.png" alt="plot of chunk tab-SD-skmeans-consensus-heatmap-3" /></p>

</div>
<div id='tab-SD-skmeans-consensus-heatmap-4'>
<pre><code class="language-r">consensus_heatmap(res, k = 5)
</code></pre>
<p><img src="figure_cola/tab-SD-skmeans-consensus-heatmap-4-1.png" alt="plot of chunk tab-SD-skmeans-consensus-heatmap-4" /></p>

</div>
<div id='tab-SD-skmeans-consensus-heatmap-5'>
<pre><code class="language-r">consensus_heatmap(res, k = 6)
</code></pre>
<p><img src="figure_cola/tab-SD-skmeans-consensus-heatmap-5-1.png" alt="plot of chunk tab-SD-skmeans-consensus-heatmap-5" /></p>

</div>
</div>

Heatmaps for the membership of samples in all partitions to see how consistent they are:





<script>
$( function() {
	$( '#tabs-SD-skmeans-membership-heatmap' ).tabs();
} );
</script>
<div id='tabs-SD-skmeans-membership-heatmap'>
<ul>
<li><a href='#tab-SD-skmeans-membership-heatmap-1'>k = 2</a></li>
<li><a href='#tab-SD-skmeans-membership-heatmap-2'>k = 3</a></li>
<li><a href='#tab-SD-skmeans-membership-heatmap-3'>k = 4</a></li>
<li><a href='#tab-SD-skmeans-membership-heatmap-4'>k = 5</a></li>
<li><a href='#tab-SD-skmeans-membership-heatmap-5'>k = 6</a></li>
</ul>
<div id='tab-SD-skmeans-membership-heatmap-1'>
<pre><code class="language-r">membership_heatmap(res, k = 2)
</code></pre>
<p><img src="figure_cola/tab-SD-skmeans-membership-heatmap-1-1.png" alt="plot of chunk tab-SD-skmeans-membership-heatmap-1" /></p>

</div>
<div id='tab-SD-skmeans-membership-heatmap-2'>
<pre><code class="language-r">membership_heatmap(res, k = 3)
</code></pre>
<p><img src="figure_cola/tab-SD-skmeans-membership-heatmap-2-1.png" alt="plot of chunk tab-SD-skmeans-membership-heatmap-2" /></p>

</div>
<div id='tab-SD-skmeans-membership-heatmap-3'>
<pre><code class="language-r">membership_heatmap(res, k = 4)
</code></pre>
<p><img src="figure_cola/tab-SD-skmeans-membership-heatmap-3-1.png" alt="plot of chunk tab-SD-skmeans-membership-heatmap-3" /></p>

</div>
<div id='tab-SD-skmeans-membership-heatmap-4'>
<pre><code class="language-r">membership_heatmap(res, k = 5)
</code></pre>
<p><img src="figure_cola/tab-SD-skmeans-membership-heatmap-4-1.png" alt="plot of chunk tab-SD-skmeans-membership-heatmap-4" /></p>

</div>
<div id='tab-SD-skmeans-membership-heatmap-5'>
<pre><code class="language-r">membership_heatmap(res, k = 6)
</code></pre>
<p><img src="figure_cola/tab-SD-skmeans-membership-heatmap-5-1.png" alt="plot of chunk tab-SD-skmeans-membership-heatmap-5" /></p>

</div>
</div>

As soon as the classes for columns are determined, the signatures
that are significantly different between subgroups can be looked for. 
Following are the heatmaps for signatures.




Signature heatmaps where rows are scaled:



<script>
$( function() {
	$( '#tabs-SD-skmeans-get-signatures' ).tabs();
} );
</script>
<div id='tabs-SD-skmeans-get-signatures'>
<ul>
<li><a href='#tab-SD-skmeans-get-signatures-1'>k = 2</a></li>
<li><a href='#tab-SD-skmeans-get-signatures-2'>k = 3</a></li>
<li><a href='#tab-SD-skmeans-get-signatures-3'>k = 4</a></li>
<li><a href='#tab-SD-skmeans-get-signatures-4'>k = 5</a></li>
<li><a href='#tab-SD-skmeans-get-signatures-5'>k = 6</a></li>
</ul>
<div id='tab-SD-skmeans-get-signatures-1'>
<pre><code class="language-r">get_signatures(res, k = 2)
</code></pre>
<p><img src="figure_cola/tab-SD-skmeans-get-signatures-1-1.png" alt="plot of chunk tab-SD-skmeans-get-signatures-1" /></p>

</div>
<div id='tab-SD-skmeans-get-signatures-2'>
<pre><code class="language-r">get_signatures(res, k = 3)
</code></pre>
<p><img src="figure_cola/tab-SD-skmeans-get-signatures-2-1.png" alt="plot of chunk tab-SD-skmeans-get-signatures-2" /></p>

</div>
<div id='tab-SD-skmeans-get-signatures-3'>
<pre><code class="language-r">get_signatures(res, k = 4)
</code></pre>
<p><img src="figure_cola/tab-SD-skmeans-get-signatures-3-1.png" alt="plot of chunk tab-SD-skmeans-get-signatures-3" /></p>

</div>
<div id='tab-SD-skmeans-get-signatures-4'>
<pre><code class="language-r">get_signatures(res, k = 5)
</code></pre>
<p><img src="figure_cola/tab-SD-skmeans-get-signatures-4-1.png" alt="plot of chunk tab-SD-skmeans-get-signatures-4" /></p>

</div>
<div id='tab-SD-skmeans-get-signatures-5'>
<pre><code class="language-r">get_signatures(res, k = 6)
</code></pre>
<p><img src="figure_cola/tab-SD-skmeans-get-signatures-5-1.png" alt="plot of chunk tab-SD-skmeans-get-signatures-5" /></p>

</div>
</div>



Signature heatmaps where rows are not scaled:


<script>
$( function() {
	$( '#tabs-SD-skmeans-get-signatures-no-scale' ).tabs();
} );
</script>
<div id='tabs-SD-skmeans-get-signatures-no-scale'>
<ul>
<li><a href='#tab-SD-skmeans-get-signatures-no-scale-1'>k = 2</a></li>
<li><a href='#tab-SD-skmeans-get-signatures-no-scale-2'>k = 3</a></li>
<li><a href='#tab-SD-skmeans-get-signatures-no-scale-3'>k = 4</a></li>
<li><a href='#tab-SD-skmeans-get-signatures-no-scale-4'>k = 5</a></li>
<li><a href='#tab-SD-skmeans-get-signatures-no-scale-5'>k = 6</a></li>
</ul>
<div id='tab-SD-skmeans-get-signatures-no-scale-1'>
<pre><code class="language-r">get_signatures(res, k = 2, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-SD-skmeans-get-signatures-no-scale-1-1.png" alt="plot of chunk tab-SD-skmeans-get-signatures-no-scale-1" /></p>

</div>
<div id='tab-SD-skmeans-get-signatures-no-scale-2'>
<pre><code class="language-r">get_signatures(res, k = 3, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-SD-skmeans-get-signatures-no-scale-2-1.png" alt="plot of chunk tab-SD-skmeans-get-signatures-no-scale-2" /></p>

</div>
<div id='tab-SD-skmeans-get-signatures-no-scale-3'>
<pre><code class="language-r">get_signatures(res, k = 4, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-SD-skmeans-get-signatures-no-scale-3-1.png" alt="plot of chunk tab-SD-skmeans-get-signatures-no-scale-3" /></p>

</div>
<div id='tab-SD-skmeans-get-signatures-no-scale-4'>
<pre><code class="language-r">get_signatures(res, k = 5, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-SD-skmeans-get-signatures-no-scale-4-1.png" alt="plot of chunk tab-SD-skmeans-get-signatures-no-scale-4" /></p>

</div>
<div id='tab-SD-skmeans-get-signatures-no-scale-5'>
<pre><code class="language-r">get_signatures(res, k = 6, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-SD-skmeans-get-signatures-no-scale-5-1.png" alt="plot of chunk tab-SD-skmeans-get-signatures-no-scale-5" /></p>

</div>
</div>



Compare the overlap of signatures from different k:

``` r
compare_signatures(res)
```

![plot of chunk SD-skmeans-signature_compare](figure_cola/SD-skmeans-signature_compare-1.png)

`get_signature()` returns a data frame invisibly. To get the list of signatures, the function
call should be assigned to a variable explicitly. In following code, if `plot` argument is set
to `FALSE`, no heatmap is plotted while only the differential analysis is performed.

``` r
# code only for demonstration
tb = get_signature(res, k = ..., plot = FALSE)
```

An example of the output of `tb` is:

```
#>   which_row         fdr    mean_1    mean_2 scaled_mean_1 scaled_mean_2 km
#> 1        38 0.042760348  8.373488  9.131774    -0.5533452     0.5164555  1
#> 2        40 0.018707592  7.106213  8.469186    -0.6173731     0.5762149  1
#> 3        55 0.019134737 10.221463 11.207825    -0.6159697     0.5749050  1
#> 4        59 0.006059896  5.921854  7.869574    -0.6899429     0.6439467  1
#> 5        60 0.018055526  8.928898 10.211722    -0.6204761     0.5791110  1
#> 6        98 0.009384629 15.714769 14.887706     0.6635654    -0.6193277  2
...
```

The columns in `tb` are:

1. `which_row`: row indices corresponding to the input matrix.
2. `fdr`: FDR for the differential test. 
3. `mean_x`: The mean value in group x.
4. `scaled_mean_x`: The mean value in group x after rows are scaled.
5. `km`: Row groups if k-means clustering is applied to rows (which is done by automatically selecting number of clusters).

If there are too many signatures, `top_signatures = ...` can be set to only show the 
signatures with the highest FDRs:

``` r
# code only for demonstration
# e.g. to show the top 500 most significant rows
tb = get_signature(res, k = ..., top_signatures = 500)
```

If the signatures are defined as these which are uniquely high in current group, `diff_method` argument
can be set to `"uniquely_high_in_one_group"`:

``` r
# code only for demonstration
tb = get_signature(res, k = ..., diff_method = "uniquely_high_in_one_group")
```




UMAP plot which shows how samples are separated.


<script>
$( function() {
	$( '#tabs-SD-skmeans-dimension-reduction' ).tabs();
} );
</script>
<div id='tabs-SD-skmeans-dimension-reduction'>
<ul>
<li><a href='#tab-SD-skmeans-dimension-reduction-1'>k = 2</a></li>
<li><a href='#tab-SD-skmeans-dimension-reduction-2'>k = 3</a></li>
<li><a href='#tab-SD-skmeans-dimension-reduction-3'>k = 4</a></li>
<li><a href='#tab-SD-skmeans-dimension-reduction-4'>k = 5</a></li>
<li><a href='#tab-SD-skmeans-dimension-reduction-5'>k = 6</a></li>
</ul>
<div id='tab-SD-skmeans-dimension-reduction-1'>
<pre><code class="language-r">dimension_reduction(res, k = 2, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-SD-skmeans-dimension-reduction-1-1.png" alt="plot of chunk tab-SD-skmeans-dimension-reduction-1" /></p>

</div>
<div id='tab-SD-skmeans-dimension-reduction-2'>
<pre><code class="language-r">dimension_reduction(res, k = 3, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-SD-skmeans-dimension-reduction-2-1.png" alt="plot of chunk tab-SD-skmeans-dimension-reduction-2" /></p>

</div>
<div id='tab-SD-skmeans-dimension-reduction-3'>
<pre><code class="language-r">dimension_reduction(res, k = 4, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-SD-skmeans-dimension-reduction-3-1.png" alt="plot of chunk tab-SD-skmeans-dimension-reduction-3" /></p>

</div>
<div id='tab-SD-skmeans-dimension-reduction-4'>
<pre><code class="language-r">dimension_reduction(res, k = 5, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-SD-skmeans-dimension-reduction-4-1.png" alt="plot of chunk tab-SD-skmeans-dimension-reduction-4" /></p>

</div>
<div id='tab-SD-skmeans-dimension-reduction-5'>
<pre><code class="language-r">dimension_reduction(res, k = 6, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-SD-skmeans-dimension-reduction-5-1.png" alt="plot of chunk tab-SD-skmeans-dimension-reduction-5" /></p>

</div>
</div>



Following heatmap shows how subgroups are split when increasing `k`:

``` r
collect_classes(res)
```

![plot of chunk SD-skmeans-collect-classes](figure_cola/SD-skmeans-collect-classes-1.png)



If matrix rows can be associated to genes, consider to use `functional_enrichment(res,
...)` to perform function enrichment for the signature genes. See [this vignette](https://jokergoo.github.io/cola_vignettes/functional_enrichment.html) for more detailed explanations.


 

---------------------------------------------------



### SD:mclust






The object with results only for a single top-value method and a single partitioning method 
can be extracted as:

``` r
res = res_list["SD", "mclust"]
# you can also extract it by
# res = res_list["SD:mclust"]
```

A summary of `res` and all the functions that can be applied to it:

``` r
res
```

```
#> A 'ConsensusPartition' object with k = 2, 3, 4, 5, 6.
#>   On a matrix with 1900 rows and 60 columns.
#>   Top rows (123) are extracted by 'SD' method.
#>   Subgroups are detected by 'mclust' method.
#>   Performed in total 250 partitions by row resampling.
#>   Best k for subgroups seems to be 2.
#> 
#> Following methods can be applied to this 'ConsensusPartition' object:
#>  [1] "cola_report"             "collect_classes"         "collect_plots"          
#>  [4] "collect_stats"           "colnames"                "compare_partitions"     
#>  [7] "compare_signatures"      "consensus_heatmap"       "dimension_reduction"    
#> [10] "functional_enrichment"   "get_anno_col"            "get_anno"               
#> [13] "get_classes"             "get_consensus"           "get_matrix"             
#> [16] "get_membership"          "get_param"               "get_signatures"         
#> [19] "get_stats"               "is_best_k"               "is_stable_k"            
#> [22] "membership_heatmap"      "ncol"                    "nrow"                   
#> [25] "plot_ecdf"               "predict_classes"         "rownames"               
#> [28] "select_partition_number" "show"                    "suggest_best_k"         
#> [31] "test_to_known_factors"   "top_rows_heatmap"
```

`collect_plots()` function collects all the plots made from `res` for all `k` (number of subgroups)
into one single page to provide an easy and fast comparison between different `k`.

``` r
collect_plots(res)
```

![plot of chunk SD-mclust-collect-plots](figure_cola/SD-mclust-collect-plots-1.png)

The plots are:

- The first row: a plot of the eCDF (empirical cumulative distribution
  function) curves of the consensus matrix for each `k` and the heatmap of
  predicted classes for each `k`.
- The second row: heatmaps of the consensus matrix for each `k`.
- The third row: heatmaps of the membership matrix for each `k`.
- The fouth row: heatmaps of the signatures for each `k`.

All the plots in panels can be made by individual functions and they are
plotted later in this section.

`select_partition_number()` produces several plots showing different
statistics for choosing "optimized" `k`. There are following statistics:

- eCDF curves of the consensus matrix for each `k`;
- 1-PAC. [The PAC score](https://en.wikipedia.org/wiki/Consensus_clustering#Over-interpretation_potential_of_consensus_clustering)
  measures the proportion of the ambiguous subgrouping.
- Mean silhouette score.
- Concordance. The mean probability of fiting the consensus subgroup labels in all
  partitions.
- Area increased. Denote $A_k$ as the area under the eCDF curve for current
  `k`, the area increased is defined as $A_k - A_{k-1}$.
- Rand index. The percent of pairs of samples that are both in a same cluster
  or both are not in a same cluster in the partition of k and k-1.
- Jaccard index. The ratio of pairs of samples are both in a same cluster in
  the partition of k and k-1 and the pairs of samples are both in a same
  cluster in the partition k or k-1.

The detailed explanations of these statistics can be found in [the _cola_
vignette](https://jokergoo.github.io/cola_vignettes/cola.html#toc_13).

Generally speaking, higher 1-PAC score, higher mean silhouette score or higher
concordance corresponds to better partition. Rand index and Jaccard index
measure how similar the current partition is compared to partition with `k-1`.
If they are too similar, we won't accept `k` is better than `k-1`.

``` r
select_partition_number(res)
```

![plot of chunk SD-mclust-select-partition-number](figure_cola/SD-mclust-select-partition-number-1.png)

The numeric values for all these statistics can be obtained by `get_stats()`.

``` r
get_stats(res)
```

```
#>   k 1-PAC mean_silhouette concordance area_increased  Rand Jaccard
#> 2 2 0.476           0.855       0.907          0.465 0.494   0.494
#> 3 3 0.268           0.672       0.784          0.301 0.742   0.528
#> 4 4 0.386           0.536       0.739          0.165 0.864   0.643
#> 5 5 0.614           0.645       0.796          0.117 0.819   0.457
#> 6 6 0.627           0.505       0.742          0.028 0.923   0.673
```

`suggest_best_k()` suggests the best $k$ based on these statistics. The rules are as follows:

- All $k$ with Jaccard index larger than 0.95 are removed because increasing
  $k$ does not provide enough extra information. If all $k$ are removed, it is
  marked as no subgroup is detected.
- For all $k$ with 1-PAC score larger than 0.9, the maximal $k$ is taken as
  the best $k$, and other $k$ are marked as optional $k$.
- If it does not fit the second rule. The $k$ with the maximal vote of the
  highest 1-PAC score, highest mean silhouette, and highest concordance is
  taken as the best $k$.

``` r
suggest_best_k(res)
```

```
#> [1] 2
```


Following is the table of the partitions (You need to click the **show/hide
code output** link to see it). The membership matrix (columns with name `p*`)
is inferred by
[`clue::cl_consensus()`](https://www.rdocumentation.org/link/cl_consensus?package=clue)
function with the `SE` method. Basically the value in the membership matrix
represents the probability to belong to a certain group. The finall subgroup
label for an item is determined with the group with highest probability it
belongs to.

In `get_classes()` function, the entropy is calculated from the membership
matrix and the silhouette score is calculated from the consensus matrix.



<script>
$( function() {
	$( '#tabs-SD-mclust-get-classes' ).tabs();
} );
</script>
<div id='tabs-SD-mclust-get-classes'>
<ul>
<li><a href='#tab-SD-mclust-get-classes-1'>k = 2</a></li>
<li><a href='#tab-SD-mclust-get-classes-2'>k = 3</a></li>
<li><a href='#tab-SD-mclust-get-classes-3'>k = 4</a></li>
<li><a href='#tab-SD-mclust-get-classes-4'>k = 5</a></li>
<li><a href='#tab-SD-mclust-get-classes-5'>k = 6</a></li>
</ul>

<div id='tab-SD-mclust-get-classes-1'>
<p><a id='tab-SD-mclust-get-classes-1-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 2), get_membership(res, k = 2))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2
#&gt; SIH013     1   0.722     0.7880 0.80 0.20
#&gt; SIH014     2   0.000     0.8887 0.00 1.00
#&gt; SIH024     1   0.971     0.3666 0.60 0.40
#&gt; SIH028     2   0.469     0.9256 0.10 0.90
#&gt; SIH031     1   0.529     0.8667 0.88 0.12
#&gt; SIH042     1   0.141     0.9042 0.98 0.02
#&gt; SIH107     2   0.327     0.9246 0.06 0.94
#&gt; SIH114     1   0.242     0.9046 0.96 0.04
#&gt; SIH116     2   0.958     0.4489 0.38 0.62
#&gt; SIH117     2   0.469     0.9256 0.10 0.90
#&gt; SIH130     2   0.000     0.8887 0.00 1.00
#&gt; SIH134     2   0.000     0.8887 0.00 1.00
#&gt; SIH186     2   0.327     0.9246 0.06 0.94
#&gt; SIH191     1   0.141     0.9042 0.98 0.02
#&gt; SIH192     2   0.469     0.9256 0.10 0.90
#&gt; SIH196     2   0.242     0.9158 0.04 0.96
#&gt; SIH214     2   0.402     0.9249 0.08 0.92
#&gt; SIH218     2   0.584     0.8925 0.14 0.86
#&gt; SIH232     1   0.000     0.8945 1.00 0.00
#&gt; SIH236     1   0.529     0.8667 0.88 0.12
#&gt; SIH238     1   0.402     0.8892 0.92 0.08
#&gt; SIH241     2   0.469     0.9256 0.10 0.90
#&gt; SIH245     2   0.141     0.9032 0.02 0.98
#&gt; SIH260     2   0.469     0.9256 0.10 0.90
#&gt; SIH287     2   0.469     0.9256 0.10 0.90
#&gt; SIH289     2   0.529     0.9120 0.12 0.88
#&gt; SIH290     2   0.141     0.9032 0.02 0.98
#&gt; SIH295     1   0.141     0.9042 0.98 0.02
#&gt; SIH366     1   0.242     0.9037 0.96 0.04
#&gt; SIH377     1   0.000     0.8945 1.00 0.00
#&gt; SIH380     2   0.000     0.8887 0.00 1.00
#&gt; SIH385     2   0.469     0.9256 0.10 0.90
#&gt; SIH389     2   0.327     0.9246 0.06 0.94
#&gt; SIH391     2   0.469     0.9256 0.10 0.90
#&gt; SIH403     1   0.141     0.9042 0.98 0.02
#&gt; SIH411     2   0.327     0.9246 0.06 0.94
#&gt; SIH427     1   0.141     0.9042 0.98 0.02
#&gt; SIH433     2   0.529     0.9110 0.12 0.88
#&gt; SIH439     1   0.634     0.8339 0.84 0.16
#&gt; SIH442     1   0.000     0.8945 1.00 0.00
#&gt; SIH444     1   0.827     0.6953 0.74 0.26
#&gt; SIH452     2   0.469     0.9256 0.10 0.90
#&gt; SIH461     1   0.634     0.8325 0.84 0.16
#&gt; SIH471     1   0.141     0.9042 0.98 0.02
#&gt; SIH472     2   0.327     0.9246 0.06 0.94
#&gt; SIH481     1   0.000     0.8945 1.00 0.00
#&gt; SIH485     2   0.141     0.9041 0.02 0.98
#&gt; SIH491     2   0.402     0.9267 0.08 0.92
#&gt; SIH508     1   0.000     0.8945 1.00 0.00
#&gt; SIH559     1   0.242     0.9046 0.96 0.04
#&gt; SIH587     1   0.242     0.9046 0.96 0.04
#&gt; SIH625     2   0.469     0.9256 0.10 0.90
#&gt; SIH641     1   0.469     0.8787 0.90 0.10
#&gt; SIH643     1   0.981     0.3075 0.58 0.42
#&gt; SIH674     1   0.000     0.8945 1.00 0.00
#&gt; SIH678     1   0.242     0.9046 0.96 0.04
#&gt; SIH679     1   0.722     0.7841 0.80 0.20
#&gt; SIH689     2   0.722     0.8143 0.20 0.80
#&gt; SIH694     2   0.327     0.9238 0.06 0.94
#&gt; SIH721     2   0.999     0.0691 0.48 0.52
</code></pre>

<script>
$('#tab-SD-mclust-get-classes-1-a').parent().next().next().hide();
$('#tab-SD-mclust-get-classes-1-a').click(function(){
  $('#tab-SD-mclust-get-classes-1-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-SD-mclust-get-classes-2'>
<p><a id='tab-SD-mclust-get-classes-2-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 3), get_membership(res, k = 3))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3
#&gt; SIH013     3  0.5858     0.5515 0.24 0.02 0.74
#&gt; SIH014     3  0.2959     0.7000 0.00 0.10 0.90
#&gt; SIH024     3  0.4209     0.6655 0.12 0.02 0.86
#&gt; SIH028     3  0.6495     0.6801 0.06 0.20 0.74
#&gt; SIH031     1  0.8390     0.3992 0.56 0.10 0.34
#&gt; SIH042     1  0.3572     0.8331 0.90 0.04 0.06
#&gt; SIH107     2  0.4555     0.7630 0.00 0.80 0.20
#&gt; SIH114     1  0.4035     0.8225 0.88 0.04 0.08
#&gt; SIH116     2  0.7932     0.5943 0.20 0.66 0.14
#&gt; SIH117     3  0.4556     0.7149 0.06 0.08 0.86
#&gt; SIH130     3  0.5016     0.5886 0.00 0.24 0.76
#&gt; SIH134     3  0.4555     0.6356 0.00 0.20 0.80
#&gt; SIH186     2  0.5016     0.7269 0.00 0.76 0.24
#&gt; SIH191     1  0.3415     0.8346 0.90 0.08 0.02
#&gt; SIH192     2  0.7395     0.4761 0.04 0.58 0.38
#&gt; SIH196     3  0.6280     0.0528 0.00 0.46 0.54
#&gt; SIH214     3  0.5466     0.6995 0.04 0.16 0.80
#&gt; SIH218     3  0.8483     0.5215 0.14 0.26 0.60
#&gt; SIH232     1  0.3415     0.8235 0.90 0.08 0.02
#&gt; SIH236     1  0.8759     0.3079 0.52 0.36 0.12
#&gt; SIH238     1  0.6229     0.6462 0.70 0.02 0.28
#&gt; SIH241     3  0.5159     0.7104 0.04 0.14 0.82
#&gt; SIH245     3  0.5560     0.5397 0.00 0.30 0.70
#&gt; SIH260     2  0.5746     0.7990 0.04 0.78 0.18
#&gt; SIH287     2  0.5746     0.7990 0.04 0.78 0.18
#&gt; SIH289     2  0.5746     0.7990 0.04 0.78 0.18
#&gt; SIH290     3  0.5948     0.3996 0.00 0.36 0.64
#&gt; SIH295     1  0.0892     0.8354 0.98 0.02 0.00
#&gt; SIH366     1  0.4966     0.8102 0.84 0.06 0.10
#&gt; SIH377     1  0.2414     0.8347 0.94 0.04 0.02
#&gt; SIH380     3  0.4796     0.6138 0.00 0.22 0.78
#&gt; SIH385     3  0.4966     0.7141 0.06 0.10 0.84
#&gt; SIH389     2  0.4555     0.7630 0.00 0.80 0.20
#&gt; SIH391     2  0.6922     0.7749 0.08 0.72 0.20
#&gt; SIH403     1  0.3415     0.8335 0.90 0.02 0.08
#&gt; SIH411     2  0.6280     0.2221 0.00 0.54 0.46
#&gt; SIH427     1  0.3415     0.8346 0.90 0.08 0.02
#&gt; SIH433     3  0.3415     0.6908 0.08 0.02 0.90
#&gt; SIH439     1  0.8626     0.4758 0.58 0.14 0.28
#&gt; SIH442     1  0.2947     0.8304 0.92 0.06 0.02
#&gt; SIH444     3  0.7344     0.5145 0.24 0.08 0.68
#&gt; SIH452     2  0.6245     0.7971 0.06 0.76 0.18
#&gt; SIH461     3  0.6527     0.3690 0.32 0.02 0.66
#&gt; SIH471     1  0.2947     0.8252 0.92 0.06 0.02
#&gt; SIH472     2  0.4555     0.7630 0.00 0.80 0.20
#&gt; SIH481     1  0.4556     0.8312 0.86 0.08 0.06
#&gt; SIH485     3  0.2959     0.7000 0.00 0.10 0.90
#&gt; SIH491     3  0.6000     0.6849 0.04 0.20 0.76
#&gt; SIH508     1  0.2414     0.8410 0.94 0.02 0.04
#&gt; SIH559     1  0.3572     0.8335 0.90 0.06 0.04
#&gt; SIH587     1  0.3572     0.8278 0.90 0.06 0.04
#&gt; SIH625     2  0.5746     0.7994 0.04 0.78 0.18
#&gt; SIH641     1  0.7683     0.5064 0.64 0.08 0.28
#&gt; SIH643     3  0.5970     0.6501 0.16 0.06 0.78
#&gt; SIH674     1  0.3415     0.8235 0.90 0.08 0.02
#&gt; SIH678     1  0.2947     0.8255 0.92 0.06 0.02
#&gt; SIH679     1  0.8590     0.3945 0.56 0.32 0.12
#&gt; SIH689     3  0.3415     0.6908 0.08 0.02 0.90
#&gt; SIH694     3  0.6232     0.6478 0.04 0.22 0.74
#&gt; SIH721     3  0.4209     0.6655 0.12 0.02 0.86
</code></pre>

<script>
$('#tab-SD-mclust-get-classes-2-a').parent().next().next().hide();
$('#tab-SD-mclust-get-classes-2-a').click(function(){
  $('#tab-SD-mclust-get-classes-2-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-SD-mclust-get-classes-3'>
<p><a id='tab-SD-mclust-get-classes-3-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 4), get_membership(res, k = 4))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3   p4
#&gt; SIH013     3  0.4011     0.6945 0.06 0.04 0.86 0.04
#&gt; SIH014     3  0.4227     0.6954 0.00 0.12 0.82 0.06
#&gt; SIH024     3  0.0707     0.7073 0.02 0.00 0.98 0.00
#&gt; SIH028     3  0.3853     0.6769 0.02 0.16 0.82 0.00
#&gt; SIH031     3  0.5428     0.1329 0.38 0.00 0.60 0.02
#&gt; SIH042     1  0.6890     0.4076 0.66 0.04 0.10 0.20
#&gt; SIH107     2  0.5147     0.7487 0.00 0.74 0.06 0.20
#&gt; SIH114     4  0.6835     0.4213 0.38 0.02 0.06 0.54
#&gt; SIH116     4  0.7430     0.3265 0.02 0.42 0.10 0.46
#&gt; SIH117     3  0.1913     0.7157 0.02 0.04 0.94 0.00
#&gt; SIH130     3  0.7414     0.3863 0.00 0.18 0.48 0.34
#&gt; SIH134     3  0.7198     0.4479 0.00 0.16 0.52 0.32
#&gt; SIH186     2  0.5489     0.7276 0.00 0.70 0.06 0.24
#&gt; SIH191     4  0.4855     0.5005 0.40 0.00 0.00 0.60
#&gt; SIH192     2  0.6089     0.5791 0.00 0.64 0.28 0.08
#&gt; SIH196     2  0.7474     0.4328 0.00 0.50 0.22 0.28
#&gt; SIH214     3  0.3935     0.6983 0.00 0.10 0.84 0.06
#&gt; SIH218     3  0.6649     0.5914 0.06 0.20 0.68 0.06
#&gt; SIH232     1  0.1637     0.6759 0.94 0.00 0.06 0.00
#&gt; SIH236     4  0.7620     0.3281 0.02 0.40 0.12 0.46
#&gt; SIH238     1  0.8471    -0.0357 0.34 0.02 0.32 0.32
#&gt; SIH241     3  0.4288     0.6876 0.02 0.14 0.82 0.02
#&gt; SIH245     3  0.7544     0.3137 0.00 0.20 0.46 0.34
#&gt; SIH260     2  0.3198     0.7227 0.00 0.88 0.08 0.04
#&gt; SIH287     2  0.3611     0.7502 0.00 0.86 0.08 0.06
#&gt; SIH289     2  0.3611     0.6985 0.00 0.86 0.08 0.06
#&gt; SIH290     3  0.7904    -0.1017 0.00 0.34 0.36 0.30
#&gt; SIH295     1  0.4332     0.5488 0.80 0.00 0.04 0.16
#&gt; SIH366     1  0.5166     0.5494 0.78 0.06 0.14 0.02
#&gt; SIH377     1  0.2335     0.6722 0.92 0.00 0.06 0.02
#&gt; SIH380     3  0.7285     0.4462 0.00 0.18 0.52 0.30
#&gt; SIH385     3  0.1637     0.7130 0.00 0.06 0.94 0.00
#&gt; SIH389     2  0.5327     0.7395 0.00 0.72 0.06 0.22
#&gt; SIH391     2  0.2647     0.7361 0.00 0.88 0.12 0.00
#&gt; SIH403     1  0.5175     0.5948 0.76 0.00 0.12 0.12
#&gt; SIH411     2  0.7610     0.4254 0.00 0.46 0.22 0.32
#&gt; SIH427     4  0.4855     0.5005 0.40 0.00 0.00 0.60
#&gt; SIH433     3  0.0000     0.7098 0.00 0.00 1.00 0.00
#&gt; SIH439     1  0.6931     0.3487 0.58 0.08 0.32 0.02
#&gt; SIH442     1  0.1637     0.6759 0.94 0.00 0.06 0.00
#&gt; SIH444     3  0.4753     0.5893 0.18 0.02 0.78 0.02
#&gt; SIH452     2  0.2011     0.7395 0.00 0.92 0.08 0.00
#&gt; SIH461     3  0.2345     0.6732 0.10 0.00 0.90 0.00
#&gt; SIH471     4  0.5535     0.4684 0.42 0.00 0.02 0.56
#&gt; SIH472     2  0.5147     0.7487 0.00 0.74 0.06 0.20
#&gt; SIH481     1  0.2011     0.6758 0.92 0.00 0.08 0.00
#&gt; SIH485     3  0.5428     0.6599 0.00 0.14 0.74 0.12
#&gt; SIH491     3  0.6755     0.5809 0.02 0.14 0.66 0.18
#&gt; SIH508     1  0.2011     0.6755 0.92 0.00 0.08 0.00
#&gt; SIH559     1  0.5535    -0.1443 0.56 0.00 0.02 0.42
#&gt; SIH587     4  0.4855     0.5005 0.40 0.00 0.00 0.60
#&gt; SIH625     2  0.2706     0.7325 0.00 0.90 0.08 0.02
#&gt; SIH641     3  0.8751    -0.1121 0.20 0.06 0.44 0.30
#&gt; SIH643     3  0.3398     0.6888 0.08 0.02 0.88 0.02
#&gt; SIH674     1  0.1637     0.6759 0.94 0.00 0.06 0.00
#&gt; SIH678     1  0.5487    -0.0704 0.58 0.00 0.02 0.40
#&gt; SIH679     4  0.7688     0.4565 0.04 0.34 0.10 0.52
#&gt; SIH689     3  0.0707     0.7073 0.02 0.00 0.98 0.00
#&gt; SIH694     3  0.6104     0.6033 0.00 0.14 0.68 0.18
#&gt; SIH721     3  0.1411     0.7122 0.02 0.02 0.96 0.00
</code></pre>

<script>
$('#tab-SD-mclust-get-classes-3-a').parent().next().next().hide();
$('#tab-SD-mclust-get-classes-3-a').click(function(){
  $('#tab-SD-mclust-get-classes-3-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-SD-mclust-get-classes-4'>
<p><a id='tab-SD-mclust-get-classes-4-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 5), get_membership(res, k = 5))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3   p4   p5
#&gt; SIH013     3  0.2754      0.737 0.08 0.00 0.88 0.00 0.04
#&gt; SIH014     3  0.5048      0.438 0.00 0.38 0.58 0.00 0.04
#&gt; SIH024     3  0.0000      0.767 0.00 0.00 1.00 0.00 0.00
#&gt; SIH028     3  0.5415      0.591 0.00 0.26 0.66 0.02 0.06
#&gt; SIH031     3  0.4398      0.590 0.04 0.00 0.72 0.00 0.24
#&gt; SIH042     1  0.5447     -0.386 0.50 0.00 0.00 0.06 0.44
#&gt; SIH107     2  0.4096      0.697 0.00 0.76 0.00 0.20 0.04
#&gt; SIH114     1  0.2754      0.644 0.88 0.00 0.00 0.08 0.04
#&gt; SIH116     4  0.2754      0.834 0.08 0.00 0.00 0.88 0.04
#&gt; SIH117     3  0.2675      0.765 0.00 0.04 0.90 0.02 0.04
#&gt; SIH130     2  0.2012      0.783 0.00 0.92 0.06 0.00 0.02
#&gt; SIH134     2  0.2873      0.746 0.00 0.86 0.12 0.00 0.02
#&gt; SIH186     2  0.3037      0.776 0.00 0.86 0.00 0.10 0.04
#&gt; SIH191     1  0.0609      0.699 0.98 0.00 0.00 0.00 0.02
#&gt; SIH192     2  0.6912      0.332 0.00 0.50 0.10 0.34 0.06
#&gt; SIH196     2  0.1043      0.806 0.00 0.96 0.00 0.04 0.00
#&gt; SIH214     3  0.5470      0.495 0.02 0.34 0.60 0.00 0.04
#&gt; SIH218     3  0.6542      0.484 0.02 0.06 0.58 0.30 0.04
#&gt; SIH232     5  0.3424      0.782 0.24 0.00 0.00 0.00 0.76
#&gt; SIH236     4  0.2873      0.822 0.12 0.00 0.00 0.86 0.02
#&gt; SIH238     1  0.5607      0.241 0.54 0.00 0.38 0.00 0.08
#&gt; SIH241     3  0.5130      0.657 0.00 0.22 0.68 0.00 0.10
#&gt; SIH245     2  0.1216      0.797 0.00 0.96 0.02 0.00 0.02
#&gt; SIH260     4  0.0609      0.865 0.00 0.00 0.00 0.98 0.02
#&gt; SIH287     4  0.4570      0.633 0.00 0.24 0.02 0.72 0.02
#&gt; SIH289     4  0.0000      0.866 0.00 0.00 0.00 1.00 0.00
#&gt; SIH290     2  0.0000      0.804 0.00 1.00 0.00 0.00 0.00
#&gt; SIH295     1  0.4307     -0.473 0.50 0.00 0.00 0.00 0.50
#&gt; SIH366     5  0.4398      0.734 0.24 0.00 0.00 0.04 0.72
#&gt; SIH377     5  0.4126      0.677 0.38 0.00 0.00 0.00 0.62
#&gt; SIH380     2  0.2873      0.744 0.00 0.86 0.12 0.00 0.02
#&gt; SIH385     3  0.3690      0.685 0.00 0.20 0.78 0.00 0.02
#&gt; SIH389     2  0.3521      0.741 0.00 0.82 0.00 0.14 0.04
#&gt; SIH391     4  0.3110      0.835 0.00 0.08 0.00 0.86 0.06
#&gt; SIH403     5  0.6885      0.420 0.38 0.00 0.12 0.04 0.46
#&gt; SIH411     2  0.1043      0.804 0.00 0.96 0.00 0.04 0.00
#&gt; SIH427     1  0.0609      0.699 0.98 0.00 0.00 0.00 0.02
#&gt; SIH433     3  0.1043      0.767 0.00 0.04 0.96 0.00 0.00
#&gt; SIH439     5  0.4106      0.513 0.04 0.00 0.14 0.02 0.80
#&gt; SIH442     5  0.4456      0.749 0.32 0.00 0.02 0.00 0.66
#&gt; SIH444     3  0.3274      0.663 0.00 0.00 0.78 0.00 0.22
#&gt; SIH452     4  0.2438      0.852 0.00 0.04 0.00 0.90 0.06
#&gt; SIH461     3  0.0609      0.766 0.00 0.00 0.98 0.00 0.02
#&gt; SIH471     1  0.1043      0.696 0.96 0.00 0.00 0.00 0.04
#&gt; SIH472     2  0.4096      0.697 0.00 0.76 0.00 0.20 0.04
#&gt; SIH481     5  0.3109      0.764 0.20 0.00 0.00 0.00 0.80
#&gt; SIH485     3  0.5663      0.318 0.02 0.42 0.52 0.00 0.04
#&gt; SIH491     2  0.3424      0.580 0.00 0.76 0.24 0.00 0.00
#&gt; SIH508     5  0.4360      0.753 0.30 0.00 0.00 0.02 0.68
#&gt; SIH559     1  0.2012      0.673 0.92 0.00 0.02 0.00 0.06
#&gt; SIH587     1  0.0000      0.692 1.00 0.00 0.00 0.00 0.00
#&gt; SIH625     4  0.2797      0.844 0.00 0.06 0.00 0.88 0.06
#&gt; SIH641     3  0.6263      0.260 0.34 0.02 0.54 0.00 0.10
#&gt; SIH643     3  0.1410      0.765 0.00 0.00 0.94 0.00 0.06
#&gt; SIH674     5  0.3561      0.782 0.26 0.00 0.00 0.00 0.74
#&gt; SIH678     1  0.2873      0.619 0.86 0.00 0.02 0.00 0.12
#&gt; SIH679     4  0.3731      0.770 0.16 0.00 0.00 0.80 0.04
#&gt; SIH689     3  0.0609      0.768 0.00 0.02 0.98 0.00 0.00
#&gt; SIH694     2  0.4132      0.534 0.00 0.72 0.26 0.00 0.02
#&gt; SIH721     3  0.0000      0.767 0.00 0.00 1.00 0.00 0.00
</code></pre>

<script>
$('#tab-SD-mclust-get-classes-4-a').parent().next().next().hide();
$('#tab-SD-mclust-get-classes-4-a').click(function(){
  $('#tab-SD-mclust-get-classes-4-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-SD-mclust-get-classes-5'>
<p><a id='tab-SD-mclust-get-classes-5-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 6), get_membership(res, k = 6))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3   p4   p5   p6
#&gt; SIH013     3  0.2020     0.7234 0.04 0.00 0.92 0.02 0.02 0.00
#&gt; SIH014     2  0.5447    -0.0843 0.00 0.46 0.42 0.00 0.00 0.12
#&gt; SIH024     3  0.0547     0.7183 0.02 0.00 0.98 0.00 0.00 0.00
#&gt; SIH028     3  0.6364     0.5031 0.02 0.18 0.58 0.04 0.00 0.18
#&gt; SIH031     3  0.4008     0.6763 0.04 0.00 0.80 0.02 0.12 0.02
#&gt; SIH042     5  0.4482     0.4169 0.36 0.00 0.00 0.04 0.60 0.00
#&gt; SIH107     6  0.5447     0.9253 0.00 0.42 0.00 0.12 0.00 0.46
#&gt; SIH114     1  0.3475     0.8458 0.80 0.00 0.00 0.06 0.14 0.00
#&gt; SIH116     4  0.2094     0.7231 0.08 0.00 0.00 0.90 0.00 0.02
#&gt; SIH117     3  0.4155     0.6911 0.02 0.04 0.80 0.04 0.00 0.10
#&gt; SIH130     2  0.0547     0.4449 0.00 0.98 0.02 0.00 0.00 0.00
#&gt; SIH134     2  0.1267     0.4614 0.00 0.94 0.06 0.00 0.00 0.00
#&gt; SIH186     2  0.5906    -0.8353 0.00 0.44 0.02 0.12 0.00 0.42
#&gt; SIH191     1  0.2260     0.8778 0.86 0.00 0.00 0.00 0.14 0.00
#&gt; SIH192     2  0.7852    -0.3606 0.04 0.32 0.08 0.30 0.00 0.26
#&gt; SIH196     2  0.2981     0.2154 0.00 0.82 0.00 0.02 0.00 0.16
#&gt; SIH214     3  0.6019     0.1772 0.00 0.38 0.46 0.02 0.00 0.14
#&gt; SIH218     3  0.6690     0.3759 0.06 0.06 0.52 0.32 0.02 0.02
#&gt; SIH232     5  0.1807     0.7104 0.06 0.00 0.00 0.02 0.92 0.00
#&gt; SIH236     4  0.2048     0.7177 0.12 0.00 0.00 0.88 0.00 0.00
#&gt; SIH238     3  0.5992     0.1646 0.36 0.00 0.48 0.02 0.14 0.00
#&gt; SIH241     3  0.6449     0.2777 0.02 0.28 0.42 0.00 0.00 0.28
#&gt; SIH245     2  0.0000     0.4262 0.00 1.00 0.00 0.00 0.00 0.00
#&gt; SIH260     4  0.0937     0.7427 0.00 0.00 0.00 0.96 0.00 0.04
#&gt; SIH287     4  0.4502     0.5766 0.02 0.14 0.00 0.74 0.00 0.10
#&gt; SIH289     4  0.1556     0.7398 0.00 0.00 0.00 0.92 0.00 0.08
#&gt; SIH290     2  0.1556     0.3490 0.00 0.92 0.00 0.00 0.00 0.08
#&gt; SIH295     5  0.3647     0.4161 0.36 0.00 0.00 0.00 0.64 0.00
#&gt; SIH366     5  0.2020     0.6902 0.04 0.00 0.00 0.02 0.92 0.02
#&gt; SIH377     5  0.2793     0.6538 0.20 0.00 0.00 0.00 0.80 0.00
#&gt; SIH380     2  0.1267     0.4630 0.00 0.94 0.06 0.00 0.00 0.00
#&gt; SIH385     3  0.5802     0.3285 0.00 0.34 0.52 0.02 0.00 0.12
#&gt; SIH389     2  0.5037    -0.7321 0.00 0.54 0.00 0.08 0.00 0.38
#&gt; SIH391     4  0.5535     0.4533 0.02 0.04 0.02 0.52 0.00 0.40
#&gt; SIH403     5  0.6185     0.3136 0.22 0.00 0.26 0.02 0.50 0.00
#&gt; SIH411     2  0.3460    -0.0677 0.00 0.76 0.00 0.02 0.00 0.22
#&gt; SIH427     1  0.2454     0.8641 0.84 0.00 0.00 0.00 0.16 0.00
#&gt; SIH433     3  0.3045     0.6894 0.02 0.06 0.86 0.00 0.00 0.06
#&gt; SIH439     5  0.6944     0.2467 0.06 0.00 0.14 0.02 0.46 0.32
#&gt; SIH442     5  0.2048     0.7031 0.12 0.00 0.00 0.00 0.88 0.00
#&gt; SIH444     3  0.4028     0.6823 0.02 0.00 0.78 0.02 0.02 0.16
#&gt; SIH452     4  0.4078     0.6093 0.02 0.00 0.00 0.64 0.00 0.34
#&gt; SIH461     3  0.1635     0.7226 0.02 0.00 0.94 0.02 0.02 0.00
#&gt; SIH471     1  0.2454     0.8829 0.84 0.00 0.00 0.00 0.16 0.00
#&gt; SIH472     6  0.5295     0.9249 0.00 0.44 0.00 0.10 0.00 0.46
#&gt; SIH481     5  0.1635     0.6703 0.02 0.00 0.00 0.02 0.94 0.02
#&gt; SIH485     2  0.5432    -0.0333 0.00 0.48 0.40 0.00 0.00 0.12
#&gt; SIH491     2  0.4713     0.3857 0.00 0.72 0.14 0.02 0.00 0.12
#&gt; SIH508     5  0.3156     0.6681 0.18 0.00 0.02 0.00 0.80 0.00
#&gt; SIH559     1  0.3315     0.8049 0.78 0.00 0.02 0.00 0.20 0.00
#&gt; SIH587     1  0.2048     0.8780 0.88 0.00 0.00 0.00 0.12 0.00
#&gt; SIH625     4  0.4144     0.5927 0.02 0.00 0.00 0.62 0.00 0.36
#&gt; SIH641     3  0.5887     0.5012 0.24 0.00 0.62 0.06 0.06 0.02
#&gt; SIH643     3  0.2020     0.7207 0.02 0.00 0.92 0.02 0.00 0.04
#&gt; SIH674     5  0.1556     0.7073 0.08 0.00 0.00 0.00 0.92 0.00
#&gt; SIH678     1  0.3460     0.7872 0.76 0.00 0.02 0.00 0.22 0.00
#&gt; SIH679     4  0.2790     0.6910 0.14 0.00 0.00 0.84 0.00 0.02
#&gt; SIH689     3  0.1635     0.7173 0.02 0.02 0.94 0.00 0.00 0.02
#&gt; SIH694     2  0.3795     0.4363 0.00 0.80 0.12 0.02 0.00 0.06
#&gt; SIH721     3  0.1480     0.7213 0.04 0.02 0.94 0.00 0.00 0.00
</code></pre>

<script>
$('#tab-SD-mclust-get-classes-5-a').parent().next().next().hide();
$('#tab-SD-mclust-get-classes-5-a').click(function(){
  $('#tab-SD-mclust-get-classes-5-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>
</div>

Heatmaps for the consensus matrix. It visualizes the probability of two
samples to be in a same group.




<script>
$( function() {
	$( '#tabs-SD-mclust-consensus-heatmap' ).tabs();
} );
</script>
<div id='tabs-SD-mclust-consensus-heatmap'>
<ul>
<li><a href='#tab-SD-mclust-consensus-heatmap-1'>k = 2</a></li>
<li><a href='#tab-SD-mclust-consensus-heatmap-2'>k = 3</a></li>
<li><a href='#tab-SD-mclust-consensus-heatmap-3'>k = 4</a></li>
<li><a href='#tab-SD-mclust-consensus-heatmap-4'>k = 5</a></li>
<li><a href='#tab-SD-mclust-consensus-heatmap-5'>k = 6</a></li>
</ul>
<div id='tab-SD-mclust-consensus-heatmap-1'>
<pre><code class="language-r">consensus_heatmap(res, k = 2)
</code></pre>
<p><img src="figure_cola/tab-SD-mclust-consensus-heatmap-1-1.png" alt="plot of chunk tab-SD-mclust-consensus-heatmap-1" /></p>

</div>
<div id='tab-SD-mclust-consensus-heatmap-2'>
<pre><code class="language-r">consensus_heatmap(res, k = 3)
</code></pre>
<p><img src="figure_cola/tab-SD-mclust-consensus-heatmap-2-1.png" alt="plot of chunk tab-SD-mclust-consensus-heatmap-2" /></p>

</div>
<div id='tab-SD-mclust-consensus-heatmap-3'>
<pre><code class="language-r">consensus_heatmap(res, k = 4)
</code></pre>
<p><img src="figure_cola/tab-SD-mclust-consensus-heatmap-3-1.png" alt="plot of chunk tab-SD-mclust-consensus-heatmap-3" /></p>

</div>
<div id='tab-SD-mclust-consensus-heatmap-4'>
<pre><code class="language-r">consensus_heatmap(res, k = 5)
</code></pre>
<p><img src="figure_cola/tab-SD-mclust-consensus-heatmap-4-1.png" alt="plot of chunk tab-SD-mclust-consensus-heatmap-4" /></p>

</div>
<div id='tab-SD-mclust-consensus-heatmap-5'>
<pre><code class="language-r">consensus_heatmap(res, k = 6)
</code></pre>
<p><img src="figure_cola/tab-SD-mclust-consensus-heatmap-5-1.png" alt="plot of chunk tab-SD-mclust-consensus-heatmap-5" /></p>

</div>
</div>

Heatmaps for the membership of samples in all partitions to see how consistent they are:





<script>
$( function() {
	$( '#tabs-SD-mclust-membership-heatmap' ).tabs();
} );
</script>
<div id='tabs-SD-mclust-membership-heatmap'>
<ul>
<li><a href='#tab-SD-mclust-membership-heatmap-1'>k = 2</a></li>
<li><a href='#tab-SD-mclust-membership-heatmap-2'>k = 3</a></li>
<li><a href='#tab-SD-mclust-membership-heatmap-3'>k = 4</a></li>
<li><a href='#tab-SD-mclust-membership-heatmap-4'>k = 5</a></li>
<li><a href='#tab-SD-mclust-membership-heatmap-5'>k = 6</a></li>
</ul>
<div id='tab-SD-mclust-membership-heatmap-1'>
<pre><code class="language-r">membership_heatmap(res, k = 2)
</code></pre>
<p><img src="figure_cola/tab-SD-mclust-membership-heatmap-1-1.png" alt="plot of chunk tab-SD-mclust-membership-heatmap-1" /></p>

</div>
<div id='tab-SD-mclust-membership-heatmap-2'>
<pre><code class="language-r">membership_heatmap(res, k = 3)
</code></pre>
<p><img src="figure_cola/tab-SD-mclust-membership-heatmap-2-1.png" alt="plot of chunk tab-SD-mclust-membership-heatmap-2" /></p>

</div>
<div id='tab-SD-mclust-membership-heatmap-3'>
<pre><code class="language-r">membership_heatmap(res, k = 4)
</code></pre>
<p><img src="figure_cola/tab-SD-mclust-membership-heatmap-3-1.png" alt="plot of chunk tab-SD-mclust-membership-heatmap-3" /></p>

</div>
<div id='tab-SD-mclust-membership-heatmap-4'>
<pre><code class="language-r">membership_heatmap(res, k = 5)
</code></pre>
<p><img src="figure_cola/tab-SD-mclust-membership-heatmap-4-1.png" alt="plot of chunk tab-SD-mclust-membership-heatmap-4" /></p>

</div>
<div id='tab-SD-mclust-membership-heatmap-5'>
<pre><code class="language-r">membership_heatmap(res, k = 6)
</code></pre>
<p><img src="figure_cola/tab-SD-mclust-membership-heatmap-5-1.png" alt="plot of chunk tab-SD-mclust-membership-heatmap-5" /></p>

</div>
</div>

As soon as the classes for columns are determined, the signatures
that are significantly different between subgroups can be looked for. 
Following are the heatmaps for signatures.




Signature heatmaps where rows are scaled:



<script>
$( function() {
	$( '#tabs-SD-mclust-get-signatures' ).tabs();
} );
</script>
<div id='tabs-SD-mclust-get-signatures'>
<ul>
<li><a href='#tab-SD-mclust-get-signatures-1'>k = 2</a></li>
<li><a href='#tab-SD-mclust-get-signatures-2'>k = 3</a></li>
<li><a href='#tab-SD-mclust-get-signatures-3'>k = 4</a></li>
<li><a href='#tab-SD-mclust-get-signatures-4'>k = 5</a></li>
<li><a href='#tab-SD-mclust-get-signatures-5'>k = 6</a></li>
</ul>
<div id='tab-SD-mclust-get-signatures-1'>
<pre><code class="language-r">get_signatures(res, k = 2)
</code></pre>
<p><img src="figure_cola/tab-SD-mclust-get-signatures-1-1.png" alt="plot of chunk tab-SD-mclust-get-signatures-1" /></p>

</div>
<div id='tab-SD-mclust-get-signatures-2'>
<pre><code class="language-r">get_signatures(res, k = 3)
</code></pre>
<p><img src="figure_cola/tab-SD-mclust-get-signatures-2-1.png" alt="plot of chunk tab-SD-mclust-get-signatures-2" /></p>

</div>
<div id='tab-SD-mclust-get-signatures-3'>
<pre><code class="language-r">get_signatures(res, k = 4)
</code></pre>
<p><img src="figure_cola/tab-SD-mclust-get-signatures-3-1.png" alt="plot of chunk tab-SD-mclust-get-signatures-3" /></p>

</div>
<div id='tab-SD-mclust-get-signatures-4'>
<pre><code class="language-r">get_signatures(res, k = 5)
</code></pre>
<p><img src="figure_cola/tab-SD-mclust-get-signatures-4-1.png" alt="plot of chunk tab-SD-mclust-get-signatures-4" /></p>

</div>
<div id='tab-SD-mclust-get-signatures-5'>
<pre><code class="language-r">get_signatures(res, k = 6)
</code></pre>
<p><img src="figure_cola/tab-SD-mclust-get-signatures-5-1.png" alt="plot of chunk tab-SD-mclust-get-signatures-5" /></p>

</div>
</div>



Signature heatmaps where rows are not scaled:


<script>
$( function() {
	$( '#tabs-SD-mclust-get-signatures-no-scale' ).tabs();
} );
</script>
<div id='tabs-SD-mclust-get-signatures-no-scale'>
<ul>
<li><a href='#tab-SD-mclust-get-signatures-no-scale-1'>k = 2</a></li>
<li><a href='#tab-SD-mclust-get-signatures-no-scale-2'>k = 3</a></li>
<li><a href='#tab-SD-mclust-get-signatures-no-scale-3'>k = 4</a></li>
<li><a href='#tab-SD-mclust-get-signatures-no-scale-4'>k = 5</a></li>
<li><a href='#tab-SD-mclust-get-signatures-no-scale-5'>k = 6</a></li>
</ul>
<div id='tab-SD-mclust-get-signatures-no-scale-1'>
<pre><code class="language-r">get_signatures(res, k = 2, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-SD-mclust-get-signatures-no-scale-1-1.png" alt="plot of chunk tab-SD-mclust-get-signatures-no-scale-1" /></p>

</div>
<div id='tab-SD-mclust-get-signatures-no-scale-2'>
<pre><code class="language-r">get_signatures(res, k = 3, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-SD-mclust-get-signatures-no-scale-2-1.png" alt="plot of chunk tab-SD-mclust-get-signatures-no-scale-2" /></p>

</div>
<div id='tab-SD-mclust-get-signatures-no-scale-3'>
<pre><code class="language-r">get_signatures(res, k = 4, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-SD-mclust-get-signatures-no-scale-3-1.png" alt="plot of chunk tab-SD-mclust-get-signatures-no-scale-3" /></p>

</div>
<div id='tab-SD-mclust-get-signatures-no-scale-4'>
<pre><code class="language-r">get_signatures(res, k = 5, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-SD-mclust-get-signatures-no-scale-4-1.png" alt="plot of chunk tab-SD-mclust-get-signatures-no-scale-4" /></p>

</div>
<div id='tab-SD-mclust-get-signatures-no-scale-5'>
<pre><code class="language-r">get_signatures(res, k = 6, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-SD-mclust-get-signatures-no-scale-5-1.png" alt="plot of chunk tab-SD-mclust-get-signatures-no-scale-5" /></p>

</div>
</div>



Compare the overlap of signatures from different k:

``` r
compare_signatures(res)
```

![plot of chunk SD-mclust-signature_compare](figure_cola/SD-mclust-signature_compare-1.png)

`get_signature()` returns a data frame invisibly. To get the list of signatures, the function
call should be assigned to a variable explicitly. In following code, if `plot` argument is set
to `FALSE`, no heatmap is plotted while only the differential analysis is performed.

``` r
# code only for demonstration
tb = get_signature(res, k = ..., plot = FALSE)
```

An example of the output of `tb` is:

```
#>   which_row         fdr    mean_1    mean_2 scaled_mean_1 scaled_mean_2 km
#> 1        38 0.042760348  8.373488  9.131774    -0.5533452     0.5164555  1
#> 2        40 0.018707592  7.106213  8.469186    -0.6173731     0.5762149  1
#> 3        55 0.019134737 10.221463 11.207825    -0.6159697     0.5749050  1
#> 4        59 0.006059896  5.921854  7.869574    -0.6899429     0.6439467  1
#> 5        60 0.018055526  8.928898 10.211722    -0.6204761     0.5791110  1
#> 6        98 0.009384629 15.714769 14.887706     0.6635654    -0.6193277  2
...
```

The columns in `tb` are:

1. `which_row`: row indices corresponding to the input matrix.
2. `fdr`: FDR for the differential test. 
3. `mean_x`: The mean value in group x.
4. `scaled_mean_x`: The mean value in group x after rows are scaled.
5. `km`: Row groups if k-means clustering is applied to rows (which is done by automatically selecting number of clusters).

If there are too many signatures, `top_signatures = ...` can be set to only show the 
signatures with the highest FDRs:

``` r
# code only for demonstration
# e.g. to show the top 500 most significant rows
tb = get_signature(res, k = ..., top_signatures = 500)
```

If the signatures are defined as these which are uniquely high in current group, `diff_method` argument
can be set to `"uniquely_high_in_one_group"`:

``` r
# code only for demonstration
tb = get_signature(res, k = ..., diff_method = "uniquely_high_in_one_group")
```




UMAP plot which shows how samples are separated.


<script>
$( function() {
	$( '#tabs-SD-mclust-dimension-reduction' ).tabs();
} );
</script>
<div id='tabs-SD-mclust-dimension-reduction'>
<ul>
<li><a href='#tab-SD-mclust-dimension-reduction-1'>k = 2</a></li>
<li><a href='#tab-SD-mclust-dimension-reduction-2'>k = 3</a></li>
<li><a href='#tab-SD-mclust-dimension-reduction-3'>k = 4</a></li>
<li><a href='#tab-SD-mclust-dimension-reduction-4'>k = 5</a></li>
<li><a href='#tab-SD-mclust-dimension-reduction-5'>k = 6</a></li>
</ul>
<div id='tab-SD-mclust-dimension-reduction-1'>
<pre><code class="language-r">dimension_reduction(res, k = 2, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-SD-mclust-dimension-reduction-1-1.png" alt="plot of chunk tab-SD-mclust-dimension-reduction-1" /></p>

</div>
<div id='tab-SD-mclust-dimension-reduction-2'>
<pre><code class="language-r">dimension_reduction(res, k = 3, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-SD-mclust-dimension-reduction-2-1.png" alt="plot of chunk tab-SD-mclust-dimension-reduction-2" /></p>

</div>
<div id='tab-SD-mclust-dimension-reduction-3'>
<pre><code class="language-r">dimension_reduction(res, k = 4, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-SD-mclust-dimension-reduction-3-1.png" alt="plot of chunk tab-SD-mclust-dimension-reduction-3" /></p>

</div>
<div id='tab-SD-mclust-dimension-reduction-4'>
<pre><code class="language-r">dimension_reduction(res, k = 5, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-SD-mclust-dimension-reduction-4-1.png" alt="plot of chunk tab-SD-mclust-dimension-reduction-4" /></p>

</div>
<div id='tab-SD-mclust-dimension-reduction-5'>
<pre><code class="language-r">dimension_reduction(res, k = 6, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-SD-mclust-dimension-reduction-5-1.png" alt="plot of chunk tab-SD-mclust-dimension-reduction-5" /></p>

</div>
</div>



Following heatmap shows how subgroups are split when increasing `k`:

``` r
collect_classes(res)
```

![plot of chunk SD-mclust-collect-classes](figure_cola/SD-mclust-collect-classes-1.png)



If matrix rows can be associated to genes, consider to use `functional_enrichment(res,
...)` to perform function enrichment for the signature genes. See [this vignette](https://jokergoo.github.io/cola_vignettes/functional_enrichment.html) for more detailed explanations.


 

---------------------------------------------------



### MAD:hclust






The object with results only for a single top-value method and a single partitioning method 
can be extracted as:

``` r
res = res_list["MAD", "hclust"]
# you can also extract it by
# res = res_list["MAD:hclust"]
```

A summary of `res` and all the functions that can be applied to it:

``` r
res
```

```
#> A 'ConsensusPartition' object with k = 2, 3, 4, 5, 6.
#>   On a matrix with 1900 rows and 60 columns.
#>   Top rows (190) are extracted by 'MAD' method.
#>   Subgroups are detected by 'hclust' method.
#>   Performed in total 250 partitions by row resampling.
#>   Best k for subgroups seems to be 3.
#> 
#> Following methods can be applied to this 'ConsensusPartition' object:
#>  [1] "cola_report"             "collect_classes"         "collect_plots"          
#>  [4] "collect_stats"           "colnames"                "compare_partitions"     
#>  [7] "compare_signatures"      "consensus_heatmap"       "dimension_reduction"    
#> [10] "functional_enrichment"   "get_anno_col"            "get_anno"               
#> [13] "get_classes"             "get_consensus"           "get_matrix"             
#> [16] "get_membership"          "get_param"               "get_signatures"         
#> [19] "get_stats"               "is_best_k"               "is_stable_k"            
#> [22] "membership_heatmap"      "ncol"                    "nrow"                   
#> [25] "plot_ecdf"               "predict_classes"         "rownames"               
#> [28] "select_partition_number" "show"                    "suggest_best_k"         
#> [31] "test_to_known_factors"   "top_rows_heatmap"
```

`collect_plots()` function collects all the plots made from `res` for all `k` (number of subgroups)
into one single page to provide an easy and fast comparison between different `k`.

``` r
collect_plots(res)
```

![plot of chunk MAD-hclust-collect-plots](figure_cola/MAD-hclust-collect-plots-1.png)

The plots are:

- The first row: a plot of the eCDF (empirical cumulative distribution
  function) curves of the consensus matrix for each `k` and the heatmap of
  predicted classes for each `k`.
- The second row: heatmaps of the consensus matrix for each `k`.
- The third row: heatmaps of the membership matrix for each `k`.
- The fouth row: heatmaps of the signatures for each `k`.

All the plots in panels can be made by individual functions and they are
plotted later in this section.

`select_partition_number()` produces several plots showing different
statistics for choosing "optimized" `k`. There are following statistics:

- eCDF curves of the consensus matrix for each `k`;
- 1-PAC. [The PAC score](https://en.wikipedia.org/wiki/Consensus_clustering#Over-interpretation_potential_of_consensus_clustering)
  measures the proportion of the ambiguous subgrouping.
- Mean silhouette score.
- Concordance. The mean probability of fiting the consensus subgroup labels in all
  partitions.
- Area increased. Denote $A_k$ as the area under the eCDF curve for current
  `k`, the area increased is defined as $A_k - A_{k-1}$.
- Rand index. The percent of pairs of samples that are both in a same cluster
  or both are not in a same cluster in the partition of k and k-1.
- Jaccard index. The ratio of pairs of samples are both in a same cluster in
  the partition of k and k-1 and the pairs of samples are both in a same
  cluster in the partition k or k-1.

The detailed explanations of these statistics can be found in [the _cola_
vignette](https://jokergoo.github.io/cola_vignettes/cola.html#toc_13).

Generally speaking, higher 1-PAC score, higher mean silhouette score or higher
concordance corresponds to better partition. Rand index and Jaccard index
measure how similar the current partition is compared to partition with `k-1`.
If they are too similar, we won't accept `k` is better than `k-1`.

``` r
select_partition_number(res)
```

![plot of chunk MAD-hclust-select-partition-number](figure_cola/MAD-hclust-select-partition-number-1.png)

The numeric values for all these statistics can be obtained by `get_stats()`.

``` r
get_stats(res)
```

```
#>   k 1-PAC mean_silhouette concordance area_increased  Rand Jaccard
#> 2 2 0.176           0.671       0.807         0.4469 0.494   0.494
#> 3 3 0.429           0.700       0.847         0.4390 0.788   0.595
#> 4 4 0.506           0.578       0.782         0.1056 0.947   0.847
#> 5 5 0.517           0.439       0.713         0.0645 0.960   0.871
#> 6 6 0.568           0.412       0.695         0.0520 0.911   0.691
```

`suggest_best_k()` suggests the best $k$ based on these statistics. The rules are as follows:

- All $k$ with Jaccard index larger than 0.95 are removed because increasing
  $k$ does not provide enough extra information. If all $k$ are removed, it is
  marked as no subgroup is detected.
- For all $k$ with 1-PAC score larger than 0.9, the maximal $k$ is taken as
  the best $k$, and other $k$ are marked as optional $k$.
- If it does not fit the second rule. The $k$ with the maximal vote of the
  highest 1-PAC score, highest mean silhouette, and highest concordance is
  taken as the best $k$.

``` r
suggest_best_k(res)
```

```
#> [1] 3
```


Following is the table of the partitions (You need to click the **show/hide
code output** link to see it). The membership matrix (columns with name `p*`)
is inferred by
[`clue::cl_consensus()`](https://www.rdocumentation.org/link/cl_consensus?package=clue)
function with the `SE` method. Basically the value in the membership matrix
represents the probability to belong to a certain group. The finall subgroup
label for an item is determined with the group with highest probability it
belongs to.

In `get_classes()` function, the entropy is calculated from the membership
matrix and the silhouette score is calculated from the consensus matrix.



<script>
$( function() {
	$( '#tabs-MAD-hclust-get-classes' ).tabs();
} );
</script>
<div id='tabs-MAD-hclust-get-classes'>
<ul>
<li><a href='#tab-MAD-hclust-get-classes-1'>k = 2</a></li>
<li><a href='#tab-MAD-hclust-get-classes-2'>k = 3</a></li>
<li><a href='#tab-MAD-hclust-get-classes-3'>k = 4</a></li>
<li><a href='#tab-MAD-hclust-get-classes-4'>k = 5</a></li>
<li><a href='#tab-MAD-hclust-get-classes-5'>k = 6</a></li>
</ul>

<div id='tab-MAD-hclust-get-classes-1'>
<p><a id='tab-MAD-hclust-get-classes-1-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 2), get_membership(res, k = 2))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2
#&gt; SIH013     1   0.990    -0.0462 0.56 0.44
#&gt; SIH014     2   0.795     0.7316 0.24 0.76
#&gt; SIH024     1   1.000    -0.2765 0.50 0.50
#&gt; SIH028     2   0.971     0.5657 0.40 0.60
#&gt; SIH031     1   0.469     0.7941 0.90 0.10
#&gt; SIH042     1   0.242     0.8235 0.96 0.04
#&gt; SIH107     2   0.584     0.6631 0.14 0.86
#&gt; SIH114     1   0.242     0.8375 0.96 0.04
#&gt; SIH116     1   0.402     0.8032 0.92 0.08
#&gt; SIH117     2   0.904     0.6893 0.32 0.68
#&gt; SIH130     2   0.827     0.7176 0.26 0.74
#&gt; SIH134     2   0.855     0.7173 0.28 0.72
#&gt; SIH186     2   0.680     0.6490 0.18 0.82
#&gt; SIH191     1   0.000     0.8494 1.00 0.00
#&gt; SIH192     2   0.881     0.6756 0.30 0.70
#&gt; SIH196     2   0.855     0.7173 0.28 0.72
#&gt; SIH214     2   0.795     0.7316 0.24 0.76
#&gt; SIH218     1   0.680     0.6909 0.82 0.18
#&gt; SIH232     1   0.000     0.8494 1.00 0.00
#&gt; SIH236     1   0.584     0.7208 0.86 0.14
#&gt; SIH238     1   0.529     0.7390 0.88 0.12
#&gt; SIH241     2   0.634     0.6918 0.16 0.84
#&gt; SIH245     2   0.881     0.7178 0.30 0.70
#&gt; SIH260     1   0.943     0.1623 0.64 0.36
#&gt; SIH287     2   0.584     0.6631 0.14 0.86
#&gt; SIH289     2   0.981     0.4446 0.42 0.58
#&gt; SIH290     2   0.904     0.7084 0.32 0.68
#&gt; SIH295     1   0.000     0.8494 1.00 0.00
#&gt; SIH366     1   0.327     0.8246 0.94 0.06
#&gt; SIH377     1   0.000     0.8494 1.00 0.00
#&gt; SIH380     2   0.855     0.7054 0.28 0.72
#&gt; SIH385     2   0.827     0.7176 0.26 0.74
#&gt; SIH389     2   0.634     0.6777 0.16 0.84
#&gt; SIH391     2   0.981     0.5342 0.42 0.58
#&gt; SIH403     1   0.242     0.8375 0.96 0.04
#&gt; SIH411     2   0.722     0.7254 0.20 0.80
#&gt; SIH427     1   0.141     0.8470 0.98 0.02
#&gt; SIH433     2   0.855     0.7110 0.28 0.72
#&gt; SIH439     2   0.634     0.6597 0.16 0.84
#&gt; SIH442     1   0.000     0.8494 1.00 0.00
#&gt; SIH444     1   0.999    -0.2439 0.52 0.48
#&gt; SIH452     2   0.634     0.6581 0.16 0.84
#&gt; SIH461     2   0.995     0.3754 0.46 0.54
#&gt; SIH471     1   0.242     0.8388 0.96 0.04
#&gt; SIH472     2   0.680     0.6862 0.18 0.82
#&gt; SIH481     1   0.000     0.8494 1.00 0.00
#&gt; SIH485     2   0.881     0.7117 0.30 0.70
#&gt; SIH491     2   0.722     0.6578 0.20 0.80
#&gt; SIH508     1   0.141     0.8470 0.98 0.02
#&gt; SIH559     1   0.000     0.8494 1.00 0.00
#&gt; SIH587     1   0.000     0.8494 1.00 0.00
#&gt; SIH625     2   0.981     0.4446 0.42 0.58
#&gt; SIH641     1   0.242     0.8397 0.96 0.04
#&gt; SIH643     2   0.943     0.6112 0.36 0.64
#&gt; SIH674     1   0.000     0.8494 1.00 0.00
#&gt; SIH678     1   0.000     0.8494 1.00 0.00
#&gt; SIH679     1   0.402     0.8032 0.92 0.08
#&gt; SIH689     2   0.881     0.6882 0.30 0.70
#&gt; SIH694     2   0.881     0.6882 0.30 0.70
#&gt; SIH721     2   0.943     0.6132 0.36 0.64
</code></pre>

<script>
$('#tab-MAD-hclust-get-classes-1-a').parent().next().next().hide();
$('#tab-MAD-hclust-get-classes-1-a').click(function(){
  $('#tab-MAD-hclust-get-classes-1-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-MAD-hclust-get-classes-2'>
<p><a id='tab-MAD-hclust-get-classes-2-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 3), get_membership(res, k = 3))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3
#&gt; SIH013     3  0.5835     0.4074 0.34 0.00 0.66
#&gt; SIH014     3  0.4555     0.6517 0.00 0.20 0.80
#&gt; SIH024     3  0.5216     0.5384 0.26 0.00 0.74
#&gt; SIH028     2  0.8953     0.5096 0.18 0.56 0.26
#&gt; SIH031     1  0.4796     0.7223 0.78 0.00 0.22
#&gt; SIH042     1  0.2959     0.8462 0.90 0.00 0.10
#&gt; SIH107     2  0.2537     0.7443 0.00 0.92 0.08
#&gt; SIH114     1  0.2959     0.8429 0.90 0.00 0.10
#&gt; SIH116     1  0.4966     0.8172 0.84 0.06 0.10
#&gt; SIH117     3  0.0892     0.7801 0.00 0.02 0.98
#&gt; SIH130     3  0.1529     0.7805 0.00 0.04 0.96
#&gt; SIH134     3  0.2414     0.7781 0.02 0.04 0.94
#&gt; SIH186     2  0.2947     0.7422 0.02 0.92 0.06
#&gt; SIH191     1  0.0000     0.8852 1.00 0.00 0.00
#&gt; SIH192     2  0.6803     0.5999 0.04 0.68 0.28
#&gt; SIH196     3  0.2414     0.7781 0.02 0.04 0.94
#&gt; SIH214     3  0.4555     0.6517 0.00 0.20 0.80
#&gt; SIH218     1  0.5706     0.5485 0.68 0.00 0.32
#&gt; SIH232     1  0.0000     0.8852 1.00 0.00 0.00
#&gt; SIH236     1  0.6495     0.7010 0.74 0.06 0.20
#&gt; SIH238     1  0.4555     0.7574 0.80 0.00 0.20
#&gt; SIH241     2  0.6758     0.4963 0.02 0.62 0.36
#&gt; SIH245     3  0.2947     0.7663 0.02 0.06 0.92
#&gt; SIH260     1  0.9863    -0.0645 0.40 0.26 0.34
#&gt; SIH287     2  0.2537     0.7443 0.00 0.92 0.08
#&gt; SIH289     2  0.7633     0.5597 0.20 0.68 0.12
#&gt; SIH290     3  0.6849     0.2702 0.02 0.38 0.60
#&gt; SIH295     1  0.0000     0.8852 1.00 0.00 0.00
#&gt; SIH366     1  0.2414     0.8706 0.94 0.02 0.04
#&gt; SIH377     1  0.0000     0.8852 1.00 0.00 0.00
#&gt; SIH380     3  0.0892     0.7798 0.00 0.02 0.98
#&gt; SIH385     3  0.1529     0.7805 0.00 0.04 0.96
#&gt; SIH389     2  0.5406     0.7171 0.02 0.78 0.20
#&gt; SIH391     3  0.9110    -0.1727 0.14 0.42 0.44
#&gt; SIH403     1  0.2959     0.8429 0.90 0.00 0.10
#&gt; SIH411     3  0.4555     0.6450 0.00 0.20 0.80
#&gt; SIH427     1  0.0892     0.8828 0.98 0.00 0.02
#&gt; SIH433     3  0.6244     0.1011 0.00 0.44 0.56
#&gt; SIH439     2  0.4002     0.7213 0.00 0.84 0.16
#&gt; SIH442     1  0.0000     0.8852 1.00 0.00 0.00
#&gt; SIH444     2  0.9657     0.3207 0.30 0.46 0.24
#&gt; SIH452     2  0.3415     0.7472 0.02 0.90 0.08
#&gt; SIH461     3  0.4002     0.6637 0.16 0.00 0.84
#&gt; SIH471     1  0.3415     0.8544 0.90 0.02 0.08
#&gt; SIH472     2  0.5406     0.7158 0.02 0.78 0.20
#&gt; SIH481     1  0.0000     0.8852 1.00 0.00 0.00
#&gt; SIH485     3  0.1529     0.7796 0.00 0.04 0.96
#&gt; SIH491     2  0.4862     0.7335 0.02 0.82 0.16
#&gt; SIH508     1  0.0892     0.8828 0.98 0.00 0.02
#&gt; SIH559     1  0.0000     0.8852 1.00 0.00 0.00
#&gt; SIH587     1  0.0000     0.8852 1.00 0.00 0.00
#&gt; SIH625     2  0.7932     0.5541 0.20 0.66 0.14
#&gt; SIH641     1  0.1529     0.8788 0.96 0.00 0.04
#&gt; SIH643     3  0.2066     0.7548 0.06 0.00 0.94
#&gt; SIH674     1  0.0000     0.8852 1.00 0.00 0.00
#&gt; SIH678     1  0.0000     0.8852 1.00 0.00 0.00
#&gt; SIH679     1  0.4966     0.8172 0.84 0.06 0.10
#&gt; SIH689     3  0.0000     0.7769 0.00 0.00 1.00
#&gt; SIH694     3  0.0000     0.7769 0.00 0.00 1.00
#&gt; SIH721     3  0.2066     0.7532 0.06 0.00 0.94
</code></pre>

<script>
$('#tab-MAD-hclust-get-classes-2-a').parent().next().next().hide();
$('#tab-MAD-hclust-get-classes-2-a').click(function(){
  $('#tab-MAD-hclust-get-classes-2-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-MAD-hclust-get-classes-3'>
<p><a id='tab-MAD-hclust-get-classes-3-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 4), get_membership(res, k = 4))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3   p4
#&gt; SIH013     3  0.6497   0.358112 0.20 0.00 0.64 0.16
#&gt; SIH014     3  0.3400   0.705197 0.00 0.18 0.82 0.00
#&gt; SIH024     3  0.5657   0.522689 0.16 0.00 0.72 0.12
#&gt; SIH028     2  0.8450   0.296124 0.14 0.54 0.22 0.10
#&gt; SIH031     1  0.6104   0.448047 0.68 0.00 0.18 0.14
#&gt; SIH042     1  0.5767   0.562739 0.66 0.00 0.06 0.28
#&gt; SIH107     2  0.1913   0.628394 0.00 0.94 0.04 0.02
#&gt; SIH114     1  0.4553   0.649564 0.78 0.00 0.04 0.18
#&gt; SIH116     1  0.5993   0.243082 0.60 0.02 0.02 0.36
#&gt; SIH117     3  0.1637   0.810486 0.00 0.00 0.94 0.06
#&gt; SIH130     3  0.0707   0.813263 0.00 0.02 0.98 0.00
#&gt; SIH134     3  0.1913   0.803657 0.00 0.04 0.94 0.02
#&gt; SIH186     2  0.4079   0.583053 0.00 0.80 0.02 0.18
#&gt; SIH191     1  0.0000   0.752385 1.00 0.00 0.00 0.00
#&gt; SIH192     2  0.7008   0.492935 0.02 0.62 0.24 0.12
#&gt; SIH196     3  0.1913   0.803657 0.00 0.04 0.94 0.02
#&gt; SIH214     3  0.3400   0.705197 0.00 0.18 0.82 0.00
#&gt; SIH218     1  0.7198   0.181779 0.54 0.00 0.28 0.18
#&gt; SIH232     1  0.0707   0.751541 0.98 0.00 0.00 0.02
#&gt; SIH236     4  0.5987  -0.045212 0.44 0.00 0.04 0.52
#&gt; SIH238     1  0.7135   0.284557 0.56 0.00 0.20 0.24
#&gt; SIH241     2  0.7198   0.388767 0.00 0.52 0.32 0.16
#&gt; SIH245     3  0.1913   0.802869 0.00 0.04 0.94 0.02
#&gt; SIH260     4  0.9753   0.371718 0.24 0.18 0.22 0.36
#&gt; SIH287     2  0.2411   0.626196 0.00 0.92 0.04 0.04
#&gt; SIH289     2  0.6835   0.300069 0.06 0.54 0.02 0.38
#&gt; SIH290     3  0.6299   0.339917 0.00 0.32 0.60 0.08
#&gt; SIH295     1  0.0000   0.752385 1.00 0.00 0.00 0.00
#&gt; SIH366     1  0.3975   0.655770 0.76 0.00 0.00 0.24
#&gt; SIH377     1  0.1637   0.744951 0.94 0.00 0.00 0.06
#&gt; SIH380     3  0.0000   0.811287 0.00 0.00 1.00 0.00
#&gt; SIH385     3  0.1411   0.814001 0.00 0.02 0.96 0.02
#&gt; SIH389     2  0.5383   0.598743 0.00 0.74 0.16 0.10
#&gt; SIH391     2  0.9047   0.000335 0.06 0.36 0.28 0.30
#&gt; SIH403     1  0.4755   0.645453 0.76 0.00 0.04 0.20
#&gt; SIH411     3  0.3400   0.696021 0.00 0.18 0.82 0.00
#&gt; SIH427     1  0.3400   0.698000 0.82 0.00 0.00 0.18
#&gt; SIH433     3  0.7493  -0.007884 0.00 0.32 0.48 0.20
#&gt; SIH439     2  0.4797   0.557142 0.00 0.72 0.02 0.26
#&gt; SIH442     1  0.0000   0.752385 1.00 0.00 0.00 0.00
#&gt; SIH444     4  0.9441   0.103767 0.20 0.32 0.12 0.36
#&gt; SIH452     2  0.1913   0.629853 0.00 0.94 0.04 0.02
#&gt; SIH461     3  0.5077   0.662605 0.08 0.00 0.76 0.16
#&gt; SIH471     1  0.4406   0.515373 0.70 0.00 0.00 0.30
#&gt; SIH472     2  0.4731   0.608265 0.00 0.78 0.16 0.06
#&gt; SIH481     1  0.0000   0.752385 1.00 0.00 0.00 0.00
#&gt; SIH485     3  0.1211   0.813279 0.00 0.00 0.96 0.04
#&gt; SIH491     2  0.5657   0.583497 0.00 0.72 0.12 0.16
#&gt; SIH508     1  0.3853   0.700482 0.82 0.00 0.02 0.16
#&gt; SIH559     1  0.0707   0.748140 0.98 0.00 0.00 0.02
#&gt; SIH587     1  0.0000   0.752385 1.00 0.00 0.00 0.00
#&gt; SIH625     2  0.6879   0.294204 0.06 0.52 0.02 0.40
#&gt; SIH641     1  0.3606   0.693613 0.84 0.00 0.02 0.14
#&gt; SIH643     3  0.3525   0.762380 0.04 0.00 0.86 0.10
#&gt; SIH674     1  0.0000   0.752385 1.00 0.00 0.00 0.00
#&gt; SIH678     1  0.0707   0.748140 0.98 0.00 0.00 0.02
#&gt; SIH679     1  0.5993   0.243082 0.60 0.02 0.02 0.36
#&gt; SIH689     3  0.1211   0.807756 0.00 0.00 0.96 0.04
#&gt; SIH694     3  0.0707   0.808510 0.00 0.00 0.98 0.02
#&gt; SIH721     3  0.2411   0.780814 0.04 0.00 0.92 0.04
</code></pre>

<script>
$('#tab-MAD-hclust-get-classes-3-a').parent().next().next().hide();
$('#tab-MAD-hclust-get-classes-3-a').click(function(){
  $('#tab-MAD-hclust-get-classes-3-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-MAD-hclust-get-classes-4'>
<p><a id='tab-MAD-hclust-get-classes-4-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 5), get_membership(res, k = 5))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3   p4   p5
#&gt; SIH013     3  0.6422     0.4395 0.08 0.00 0.62 0.08 0.22
#&gt; SIH014     3  0.4676     0.6386 0.00 0.14 0.74 0.12 0.00
#&gt; SIH024     3  0.5567     0.5689 0.06 0.00 0.70 0.06 0.18
#&gt; SIH028     4  0.8648     0.2581 0.08 0.30 0.16 0.40 0.06
#&gt; SIH031     1  0.6471     0.3321 0.62 0.00 0.12 0.06 0.20
#&gt; SIH042     1  0.5330     0.3066 0.52 0.00 0.02 0.02 0.44
#&gt; SIH107     2  0.2012     0.4197 0.00 0.92 0.00 0.06 0.02
#&gt; SIH114     1  0.5156     0.4982 0.70 0.00 0.02 0.06 0.22
#&gt; SIH116     1  0.5695    -0.0663 0.48 0.02 0.00 0.04 0.46
#&gt; SIH117     3  0.2012     0.7677 0.00 0.00 0.92 0.06 0.02
#&gt; SIH130     3  0.1648     0.7747 0.00 0.02 0.94 0.04 0.00
#&gt; SIH134     3  0.2438     0.7648 0.00 0.04 0.90 0.06 0.00
#&gt; SIH186     2  0.3999     0.3706 0.00 0.74 0.00 0.24 0.02
#&gt; SIH191     1  0.0000     0.6700 1.00 0.00 0.00 0.00 0.00
#&gt; SIH192     4  0.7152     0.1699 0.00 0.36 0.16 0.44 0.04
#&gt; SIH196     3  0.2438     0.7648 0.00 0.04 0.90 0.06 0.00
#&gt; SIH214     3  0.4676     0.6386 0.00 0.14 0.74 0.12 0.00
#&gt; SIH218     1  0.7651    -0.0371 0.46 0.00 0.20 0.08 0.26
#&gt; SIH232     1  0.0609     0.6706 0.98 0.00 0.00 0.00 0.02
#&gt; SIH236     5  0.5305     0.1977 0.30 0.00 0.02 0.04 0.64
#&gt; SIH238     5  0.7561    -0.0570 0.36 0.00 0.10 0.12 0.42
#&gt; SIH241     2  0.7048    -0.0274 0.00 0.46 0.28 0.24 0.02
#&gt; SIH245     3  0.2438     0.7664 0.00 0.04 0.90 0.06 0.00
#&gt; SIH260     5  0.9324    -0.0564 0.16 0.12 0.16 0.16 0.40
#&gt; SIH287     2  0.2012     0.4180 0.00 0.92 0.00 0.06 0.02
#&gt; SIH289     2  0.7099     0.0775 0.02 0.42 0.00 0.22 0.34
#&gt; SIH290     3  0.6802     0.1879 0.00 0.18 0.50 0.30 0.02
#&gt; SIH295     1  0.0609     0.6697 0.98 0.00 0.00 0.00 0.02
#&gt; SIH366     1  0.4921     0.4529 0.62 0.00 0.00 0.04 0.34
#&gt; SIH377     1  0.2516     0.6491 0.86 0.00 0.00 0.00 0.14
#&gt; SIH380     3  0.1216     0.7753 0.00 0.02 0.96 0.02 0.00
#&gt; SIH385     3  0.3034     0.7742 0.00 0.02 0.88 0.06 0.04
#&gt; SIH389     2  0.4982     0.2331 0.00 0.70 0.10 0.20 0.00
#&gt; SIH391     4  0.9036     0.2318 0.02 0.26 0.22 0.26 0.24
#&gt; SIH403     1  0.5441     0.4803 0.68 0.00 0.02 0.08 0.22
#&gt; SIH411     3  0.4872     0.6066 0.00 0.12 0.72 0.16 0.00
#&gt; SIH427     1  0.3684     0.5635 0.72 0.00 0.00 0.00 0.28
#&gt; SIH433     3  0.7170    -0.0633 0.00 0.26 0.42 0.30 0.02
#&gt; SIH439     4  0.5173    -0.0527 0.00 0.46 0.00 0.50 0.04
#&gt; SIH442     1  0.0000     0.6700 1.00 0.00 0.00 0.00 0.00
#&gt; SIH444     4  0.9490     0.1435 0.14 0.22 0.10 0.34 0.20
#&gt; SIH452     2  0.0000     0.4368 0.00 1.00 0.00 0.00 0.00
#&gt; SIH461     3  0.5604     0.6145 0.04 0.00 0.70 0.10 0.16
#&gt; SIH471     1  0.4227     0.3124 0.58 0.00 0.00 0.00 0.42
#&gt; SIH472     2  0.5646    -0.1147 0.00 0.52 0.08 0.40 0.00
#&gt; SIH481     1  0.1732     0.6658 0.92 0.00 0.00 0.00 0.08
#&gt; SIH485     3  0.1648     0.7787 0.00 0.02 0.94 0.04 0.00
#&gt; SIH491     2  0.5574     0.3159 0.00 0.66 0.08 0.24 0.02
#&gt; SIH508     1  0.4920     0.5047 0.66 0.00 0.02 0.02 0.30
#&gt; SIH559     1  0.1043     0.6588 0.96 0.00 0.00 0.00 0.04
#&gt; SIH587     1  0.0609     0.6630 0.98 0.00 0.00 0.00 0.02
#&gt; SIH625     2  0.7118     0.0608 0.02 0.40 0.00 0.22 0.36
#&gt; SIH641     1  0.3852     0.5791 0.76 0.00 0.02 0.00 0.22
#&gt; SIH643     3  0.3977     0.7142 0.02 0.00 0.82 0.10 0.06
#&gt; SIH674     1  0.0000     0.6700 1.00 0.00 0.00 0.00 0.00
#&gt; SIH678     1  0.1043     0.6588 0.96 0.00 0.00 0.00 0.04
#&gt; SIH679     1  0.5695    -0.0663 0.48 0.02 0.00 0.04 0.46
#&gt; SIH689     3  0.1216     0.7717 0.00 0.00 0.96 0.02 0.02
#&gt; SIH694     3  0.0000     0.7753 0.00 0.00 1.00 0.00 0.00
#&gt; SIH721     3  0.1410     0.7616 0.00 0.00 0.94 0.00 0.06
</code></pre>

<script>
$('#tab-MAD-hclust-get-classes-4-a').parent().next().next().hide();
$('#tab-MAD-hclust-get-classes-4-a').click(function(){
  $('#tab-MAD-hclust-get-classes-4-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-MAD-hclust-get-classes-5'>
<p><a id='tab-MAD-hclust-get-classes-5-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 6), get_membership(res, k = 6))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3   p4   p5   p6
#&gt; SIH013     3  0.5685     0.3240 0.12 0.00 0.56 0.00 0.02 0.30
#&gt; SIH014     3  0.4502     0.6212 0.00 0.02 0.74 0.10 0.00 0.14
#&gt; SIH024     3  0.5208     0.4747 0.08 0.00 0.62 0.00 0.02 0.28
#&gt; SIH028     4  0.8934     0.2642 0.08 0.16 0.12 0.30 0.04 0.30
#&gt; SIH031     5  0.7097     0.0492 0.28 0.00 0.10 0.02 0.48 0.12
#&gt; SIH042     1  0.5769    -0.1843 0.46 0.00 0.00 0.00 0.36 0.18
#&gt; SIH107     2  0.4574     0.5089 0.00 0.68 0.02 0.26 0.00 0.04
#&gt; SIH114     5  0.5655     0.1493 0.36 0.00 0.00 0.00 0.48 0.16
#&gt; SIH116     1  0.5883     0.4097 0.56 0.00 0.00 0.18 0.24 0.02
#&gt; SIH117     3  0.3111     0.7379 0.00 0.02 0.84 0.02 0.00 0.12
#&gt; SIH130     3  0.1556     0.7511 0.00 0.00 0.92 0.00 0.00 0.08
#&gt; SIH134     3  0.2581     0.7379 0.00 0.02 0.86 0.00 0.00 0.12
#&gt; SIH186     2  0.2190     0.4806 0.00 0.90 0.00 0.04 0.00 0.06
#&gt; SIH191     5  0.0937     0.6385 0.04 0.00 0.00 0.00 0.96 0.00
#&gt; SIH192     4  0.7843     0.2580 0.04 0.16 0.12 0.38 0.00 0.30
#&gt; SIH196     3  0.2581     0.7379 0.00 0.02 0.86 0.00 0.00 0.12
#&gt; SIH214     3  0.4502     0.6212 0.00 0.02 0.74 0.10 0.00 0.14
#&gt; SIH218     5  0.7906    -0.2999 0.28 0.00 0.16 0.02 0.34 0.20
#&gt; SIH232     5  0.0547     0.6356 0.02 0.00 0.00 0.00 0.98 0.00
#&gt; SIH236     1  0.5701     0.2469 0.60 0.00 0.02 0.28 0.08 0.02
#&gt; SIH238     6  0.5957     0.0000 0.38 0.00 0.00 0.00 0.22 0.40
#&gt; SIH241     2  0.6167     0.1648 0.00 0.54 0.26 0.04 0.00 0.16
#&gt; SIH245     3  0.2728     0.7394 0.00 0.04 0.86 0.00 0.00 0.10
#&gt; SIH260     1  0.8568    -0.1131 0.40 0.04 0.16 0.24 0.08 0.08
#&gt; SIH287     2  0.4326     0.5152 0.00 0.68 0.02 0.28 0.00 0.02
#&gt; SIH289     4  0.4200     0.2250 0.12 0.14 0.00 0.74 0.00 0.00
#&gt; SIH290     3  0.7184     0.2119 0.02 0.08 0.46 0.16 0.00 0.28
#&gt; SIH295     5  0.0547     0.6309 0.02 0.00 0.00 0.00 0.98 0.00
#&gt; SIH366     1  0.5020     0.2893 0.56 0.00 0.00 0.02 0.38 0.04
#&gt; SIH377     5  0.3711     0.3529 0.26 0.00 0.00 0.02 0.72 0.00
#&gt; SIH380     3  0.0937     0.7482 0.00 0.00 0.96 0.00 0.00 0.04
#&gt; SIH385     3  0.2454     0.7423 0.00 0.00 0.84 0.00 0.00 0.16
#&gt; SIH389     2  0.5523     0.3806 0.00 0.64 0.06 0.08 0.00 0.22
#&gt; SIH391     4  0.8690     0.1942 0.22 0.12 0.22 0.30 0.00 0.14
#&gt; SIH403     5  0.5769     0.1059 0.36 0.00 0.00 0.00 0.46 0.18
#&gt; SIH411     3  0.4754     0.5748 0.00 0.02 0.70 0.08 0.00 0.20
#&gt; SIH427     1  0.3828     0.2016 0.56 0.00 0.00 0.00 0.44 0.00
#&gt; SIH433     3  0.7774     0.0577 0.02 0.22 0.40 0.16 0.00 0.20
#&gt; SIH439     4  0.5486     0.2314 0.02 0.14 0.00 0.62 0.00 0.22
#&gt; SIH442     5  0.0937     0.6385 0.04 0.00 0.00 0.00 0.96 0.00
#&gt; SIH444     4  0.9433     0.1232 0.22 0.20 0.08 0.24 0.06 0.20
#&gt; SIH452     2  0.3976     0.5458 0.00 0.74 0.02 0.22 0.00 0.02
#&gt; SIH461     3  0.4700     0.5239 0.06 0.00 0.60 0.00 0.00 0.34
#&gt; SIH471     1  0.5083     0.3901 0.58 0.00 0.00 0.10 0.32 0.00
#&gt; SIH472     4  0.7048     0.1085 0.00 0.22 0.08 0.40 0.00 0.30
#&gt; SIH481     5  0.2790     0.5272 0.14 0.00 0.00 0.02 0.84 0.00
#&gt; SIH485     3  0.1480     0.7553 0.00 0.02 0.94 0.00 0.00 0.04
#&gt; SIH491     2  0.4733     0.4592 0.00 0.74 0.08 0.12 0.00 0.06
#&gt; SIH508     1  0.5087     0.2247 0.52 0.00 0.02 0.00 0.42 0.04
#&gt; SIH559     5  0.2350     0.6070 0.10 0.00 0.00 0.00 0.88 0.02
#&gt; SIH587     5  0.0937     0.6203 0.04 0.00 0.00 0.00 0.96 0.00
#&gt; SIH625     4  0.4004     0.2364 0.12 0.12 0.00 0.76 0.00 0.00
#&gt; SIH641     5  0.4764    -0.0148 0.42 0.00 0.02 0.02 0.54 0.00
#&gt; SIH643     3  0.3156     0.6960 0.00 0.00 0.80 0.02 0.00 0.18
#&gt; SIH674     5  0.0547     0.6381 0.02 0.00 0.00 0.00 0.98 0.00
#&gt; SIH678     5  0.2981     0.5838 0.16 0.00 0.00 0.00 0.82 0.02
#&gt; SIH679     1  0.5883     0.4097 0.56 0.00 0.00 0.18 0.24 0.02
#&gt; SIH689     3  0.2048     0.7456 0.00 0.00 0.88 0.00 0.00 0.12
#&gt; SIH694     3  0.0547     0.7492 0.00 0.00 0.98 0.00 0.00 0.02
#&gt; SIH721     3  0.1807     0.7367 0.02 0.00 0.92 0.00 0.00 0.06
</code></pre>

<script>
$('#tab-MAD-hclust-get-classes-5-a').parent().next().next().hide();
$('#tab-MAD-hclust-get-classes-5-a').click(function(){
  $('#tab-MAD-hclust-get-classes-5-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>
</div>

Heatmaps for the consensus matrix. It visualizes the probability of two
samples to be in a same group.




<script>
$( function() {
	$( '#tabs-MAD-hclust-consensus-heatmap' ).tabs();
} );
</script>
<div id='tabs-MAD-hclust-consensus-heatmap'>
<ul>
<li><a href='#tab-MAD-hclust-consensus-heatmap-1'>k = 2</a></li>
<li><a href='#tab-MAD-hclust-consensus-heatmap-2'>k = 3</a></li>
<li><a href='#tab-MAD-hclust-consensus-heatmap-3'>k = 4</a></li>
<li><a href='#tab-MAD-hclust-consensus-heatmap-4'>k = 5</a></li>
<li><a href='#tab-MAD-hclust-consensus-heatmap-5'>k = 6</a></li>
</ul>
<div id='tab-MAD-hclust-consensus-heatmap-1'>
<pre><code class="language-r">consensus_heatmap(res, k = 2)
</code></pre>
<p><img src="figure_cola/tab-MAD-hclust-consensus-heatmap-1-1.png" alt="plot of chunk tab-MAD-hclust-consensus-heatmap-1" /></p>

</div>
<div id='tab-MAD-hclust-consensus-heatmap-2'>
<pre><code class="language-r">consensus_heatmap(res, k = 3)
</code></pre>
<p><img src="figure_cola/tab-MAD-hclust-consensus-heatmap-2-1.png" alt="plot of chunk tab-MAD-hclust-consensus-heatmap-2" /></p>

</div>
<div id='tab-MAD-hclust-consensus-heatmap-3'>
<pre><code class="language-r">consensus_heatmap(res, k = 4)
</code></pre>
<p><img src="figure_cola/tab-MAD-hclust-consensus-heatmap-3-1.png" alt="plot of chunk tab-MAD-hclust-consensus-heatmap-3" /></p>

</div>
<div id='tab-MAD-hclust-consensus-heatmap-4'>
<pre><code class="language-r">consensus_heatmap(res, k = 5)
</code></pre>
<p><img src="figure_cola/tab-MAD-hclust-consensus-heatmap-4-1.png" alt="plot of chunk tab-MAD-hclust-consensus-heatmap-4" /></p>

</div>
<div id='tab-MAD-hclust-consensus-heatmap-5'>
<pre><code class="language-r">consensus_heatmap(res, k = 6)
</code></pre>
<p><img src="figure_cola/tab-MAD-hclust-consensus-heatmap-5-1.png" alt="plot of chunk tab-MAD-hclust-consensus-heatmap-5" /></p>

</div>
</div>

Heatmaps for the membership of samples in all partitions to see how consistent they are:





<script>
$( function() {
	$( '#tabs-MAD-hclust-membership-heatmap' ).tabs();
} );
</script>
<div id='tabs-MAD-hclust-membership-heatmap'>
<ul>
<li><a href='#tab-MAD-hclust-membership-heatmap-1'>k = 2</a></li>
<li><a href='#tab-MAD-hclust-membership-heatmap-2'>k = 3</a></li>
<li><a href='#tab-MAD-hclust-membership-heatmap-3'>k = 4</a></li>
<li><a href='#tab-MAD-hclust-membership-heatmap-4'>k = 5</a></li>
<li><a href='#tab-MAD-hclust-membership-heatmap-5'>k = 6</a></li>
</ul>
<div id='tab-MAD-hclust-membership-heatmap-1'>
<pre><code class="language-r">membership_heatmap(res, k = 2)
</code></pre>
<p><img src="figure_cola/tab-MAD-hclust-membership-heatmap-1-1.png" alt="plot of chunk tab-MAD-hclust-membership-heatmap-1" /></p>

</div>
<div id='tab-MAD-hclust-membership-heatmap-2'>
<pre><code class="language-r">membership_heatmap(res, k = 3)
</code></pre>
<p><img src="figure_cola/tab-MAD-hclust-membership-heatmap-2-1.png" alt="plot of chunk tab-MAD-hclust-membership-heatmap-2" /></p>

</div>
<div id='tab-MAD-hclust-membership-heatmap-3'>
<pre><code class="language-r">membership_heatmap(res, k = 4)
</code></pre>
<p><img src="figure_cola/tab-MAD-hclust-membership-heatmap-3-1.png" alt="plot of chunk tab-MAD-hclust-membership-heatmap-3" /></p>

</div>
<div id='tab-MAD-hclust-membership-heatmap-4'>
<pre><code class="language-r">membership_heatmap(res, k = 5)
</code></pre>
<p><img src="figure_cola/tab-MAD-hclust-membership-heatmap-4-1.png" alt="plot of chunk tab-MAD-hclust-membership-heatmap-4" /></p>

</div>
<div id='tab-MAD-hclust-membership-heatmap-5'>
<pre><code class="language-r">membership_heatmap(res, k = 6)
</code></pre>
<p><img src="figure_cola/tab-MAD-hclust-membership-heatmap-5-1.png" alt="plot of chunk tab-MAD-hclust-membership-heatmap-5" /></p>

</div>
</div>

As soon as the classes for columns are determined, the signatures
that are significantly different between subgroups can be looked for. 
Following are the heatmaps for signatures.




Signature heatmaps where rows are scaled:



<script>
$( function() {
	$( '#tabs-MAD-hclust-get-signatures' ).tabs();
} );
</script>
<div id='tabs-MAD-hclust-get-signatures'>
<ul>
<li><a href='#tab-MAD-hclust-get-signatures-1'>k = 2</a></li>
<li><a href='#tab-MAD-hclust-get-signatures-2'>k = 3</a></li>
<li><a href='#tab-MAD-hclust-get-signatures-3'>k = 4</a></li>
<li><a href='#tab-MAD-hclust-get-signatures-4'>k = 5</a></li>
<li><a href='#tab-MAD-hclust-get-signatures-5'>k = 6</a></li>
</ul>
<div id='tab-MAD-hclust-get-signatures-1'>
<pre><code class="language-r">get_signatures(res, k = 2)
</code></pre>
<p><img src="figure_cola/tab-MAD-hclust-get-signatures-1-1.png" alt="plot of chunk tab-MAD-hclust-get-signatures-1" /></p>

</div>
<div id='tab-MAD-hclust-get-signatures-2'>
<pre><code class="language-r">get_signatures(res, k = 3)
</code></pre>
<p><img src="figure_cola/tab-MAD-hclust-get-signatures-2-1.png" alt="plot of chunk tab-MAD-hclust-get-signatures-2" /></p>

</div>
<div id='tab-MAD-hclust-get-signatures-3'>
<pre><code class="language-r">get_signatures(res, k = 4)
</code></pre>
<p><img src="figure_cola/tab-MAD-hclust-get-signatures-3-1.png" alt="plot of chunk tab-MAD-hclust-get-signatures-3" /></p>

</div>
<div id='tab-MAD-hclust-get-signatures-4'>
<pre><code class="language-r">get_signatures(res, k = 5)
</code></pre>
<p><img src="figure_cola/tab-MAD-hclust-get-signatures-4-1.png" alt="plot of chunk tab-MAD-hclust-get-signatures-4" /></p>

</div>
<div id='tab-MAD-hclust-get-signatures-5'>
<pre><code class="language-r">get_signatures(res, k = 6)
</code></pre>
<p><img src="figure_cola/tab-MAD-hclust-get-signatures-5-1.png" alt="plot of chunk tab-MAD-hclust-get-signatures-5" /></p>

</div>
</div>



Signature heatmaps where rows are not scaled:


<script>
$( function() {
	$( '#tabs-MAD-hclust-get-signatures-no-scale' ).tabs();
} );
</script>
<div id='tabs-MAD-hclust-get-signatures-no-scale'>
<ul>
<li><a href='#tab-MAD-hclust-get-signatures-no-scale-1'>k = 2</a></li>
<li><a href='#tab-MAD-hclust-get-signatures-no-scale-2'>k = 3</a></li>
<li><a href='#tab-MAD-hclust-get-signatures-no-scale-3'>k = 4</a></li>
<li><a href='#tab-MAD-hclust-get-signatures-no-scale-4'>k = 5</a></li>
<li><a href='#tab-MAD-hclust-get-signatures-no-scale-5'>k = 6</a></li>
</ul>
<div id='tab-MAD-hclust-get-signatures-no-scale-1'>
<pre><code class="language-r">get_signatures(res, k = 2, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-MAD-hclust-get-signatures-no-scale-1-1.png" alt="plot of chunk tab-MAD-hclust-get-signatures-no-scale-1" /></p>

</div>
<div id='tab-MAD-hclust-get-signatures-no-scale-2'>
<pre><code class="language-r">get_signatures(res, k = 3, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-MAD-hclust-get-signatures-no-scale-2-1.png" alt="plot of chunk tab-MAD-hclust-get-signatures-no-scale-2" /></p>

</div>
<div id='tab-MAD-hclust-get-signatures-no-scale-3'>
<pre><code class="language-r">get_signatures(res, k = 4, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-MAD-hclust-get-signatures-no-scale-3-1.png" alt="plot of chunk tab-MAD-hclust-get-signatures-no-scale-3" /></p>

</div>
<div id='tab-MAD-hclust-get-signatures-no-scale-4'>
<pre><code class="language-r">get_signatures(res, k = 5, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-MAD-hclust-get-signatures-no-scale-4-1.png" alt="plot of chunk tab-MAD-hclust-get-signatures-no-scale-4" /></p>

</div>
<div id='tab-MAD-hclust-get-signatures-no-scale-5'>
<pre><code class="language-r">get_signatures(res, k = 6, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-MAD-hclust-get-signatures-no-scale-5-1.png" alt="plot of chunk tab-MAD-hclust-get-signatures-no-scale-5" /></p>

</div>
</div>



Compare the overlap of signatures from different k:

``` r
compare_signatures(res)
```

![plot of chunk MAD-hclust-signature_compare](figure_cola/MAD-hclust-signature_compare-1.png)

`get_signature()` returns a data frame invisibly. To get the list of signatures, the function
call should be assigned to a variable explicitly. In following code, if `plot` argument is set
to `FALSE`, no heatmap is plotted while only the differential analysis is performed.

``` r
# code only for demonstration
tb = get_signature(res, k = ..., plot = FALSE)
```

An example of the output of `tb` is:

```
#>   which_row         fdr    mean_1    mean_2 scaled_mean_1 scaled_mean_2 km
#> 1        38 0.042760348  8.373488  9.131774    -0.5533452     0.5164555  1
#> 2        40 0.018707592  7.106213  8.469186    -0.6173731     0.5762149  1
#> 3        55 0.019134737 10.221463 11.207825    -0.6159697     0.5749050  1
#> 4        59 0.006059896  5.921854  7.869574    -0.6899429     0.6439467  1
#> 5        60 0.018055526  8.928898 10.211722    -0.6204761     0.5791110  1
#> 6        98 0.009384629 15.714769 14.887706     0.6635654    -0.6193277  2
...
```

The columns in `tb` are:

1. `which_row`: row indices corresponding to the input matrix.
2. `fdr`: FDR for the differential test. 
3. `mean_x`: The mean value in group x.
4. `scaled_mean_x`: The mean value in group x after rows are scaled.
5. `km`: Row groups if k-means clustering is applied to rows (which is done by automatically selecting number of clusters).

If there are too many signatures, `top_signatures = ...` can be set to only show the 
signatures with the highest FDRs:

``` r
# code only for demonstration
# e.g. to show the top 500 most significant rows
tb = get_signature(res, k = ..., top_signatures = 500)
```

If the signatures are defined as these which are uniquely high in current group, `diff_method` argument
can be set to `"uniquely_high_in_one_group"`:

``` r
# code only for demonstration
tb = get_signature(res, k = ..., diff_method = "uniquely_high_in_one_group")
```




UMAP plot which shows how samples are separated.


<script>
$( function() {
	$( '#tabs-MAD-hclust-dimension-reduction' ).tabs();
} );
</script>
<div id='tabs-MAD-hclust-dimension-reduction'>
<ul>
<li><a href='#tab-MAD-hclust-dimension-reduction-1'>k = 2</a></li>
<li><a href='#tab-MAD-hclust-dimension-reduction-2'>k = 3</a></li>
<li><a href='#tab-MAD-hclust-dimension-reduction-3'>k = 4</a></li>
<li><a href='#tab-MAD-hclust-dimension-reduction-4'>k = 5</a></li>
<li><a href='#tab-MAD-hclust-dimension-reduction-5'>k = 6</a></li>
</ul>
<div id='tab-MAD-hclust-dimension-reduction-1'>
<pre><code class="language-r">dimension_reduction(res, k = 2, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-MAD-hclust-dimension-reduction-1-1.png" alt="plot of chunk tab-MAD-hclust-dimension-reduction-1" /></p>

</div>
<div id='tab-MAD-hclust-dimension-reduction-2'>
<pre><code class="language-r">dimension_reduction(res, k = 3, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-MAD-hclust-dimension-reduction-2-1.png" alt="plot of chunk tab-MAD-hclust-dimension-reduction-2" /></p>

</div>
<div id='tab-MAD-hclust-dimension-reduction-3'>
<pre><code class="language-r">dimension_reduction(res, k = 4, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-MAD-hclust-dimension-reduction-3-1.png" alt="plot of chunk tab-MAD-hclust-dimension-reduction-3" /></p>

</div>
<div id='tab-MAD-hclust-dimension-reduction-4'>
<pre><code class="language-r">dimension_reduction(res, k = 5, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-MAD-hclust-dimension-reduction-4-1.png" alt="plot of chunk tab-MAD-hclust-dimension-reduction-4" /></p>

</div>
<div id='tab-MAD-hclust-dimension-reduction-5'>
<pre><code class="language-r">dimension_reduction(res, k = 6, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-MAD-hclust-dimension-reduction-5-1.png" alt="plot of chunk tab-MAD-hclust-dimension-reduction-5" /></p>

</div>
</div>



Following heatmap shows how subgroups are split when increasing `k`:

``` r
collect_classes(res)
```

![plot of chunk MAD-hclust-collect-classes](figure_cola/MAD-hclust-collect-classes-1.png)



If matrix rows can be associated to genes, consider to use `functional_enrichment(res,
...)` to perform function enrichment for the signature genes. See [this vignette](https://jokergoo.github.io/cola_vignettes/functional_enrichment.html) for more detailed explanations.


 

---------------------------------------------------



### MAD:kmeans**






The object with results only for a single top-value method and a single partitioning method 
can be extracted as:

``` r
res = res_list["MAD", "kmeans"]
# you can also extract it by
# res = res_list["MAD:kmeans"]
```

A summary of `res` and all the functions that can be applied to it:

``` r
res
```

```
#> A 'ConsensusPartition' object with k = 2, 3, 4, 5, 6.
#>   On a matrix with 1900 rows and 60 columns.
#>   Top rows (190) are extracted by 'MAD' method.
#>   Subgroups are detected by 'kmeans' method.
#>   Performed in total 250 partitions by row resampling.
#>   Best k for subgroups seems to be 2.
#> 
#> Following methods can be applied to this 'ConsensusPartition' object:
#>  [1] "cola_report"             "collect_classes"         "collect_plots"          
#>  [4] "collect_stats"           "colnames"                "compare_partitions"     
#>  [7] "compare_signatures"      "consensus_heatmap"       "dimension_reduction"    
#> [10] "functional_enrichment"   "get_anno_col"            "get_anno"               
#> [13] "get_classes"             "get_consensus"           "get_matrix"             
#> [16] "get_membership"          "get_param"               "get_signatures"         
#> [19] "get_stats"               "is_best_k"               "is_stable_k"            
#> [22] "membership_heatmap"      "ncol"                    "nrow"                   
#> [25] "plot_ecdf"               "predict_classes"         "rownames"               
#> [28] "select_partition_number" "show"                    "suggest_best_k"         
#> [31] "test_to_known_factors"   "top_rows_heatmap"
```

`collect_plots()` function collects all the plots made from `res` for all `k` (number of subgroups)
into one single page to provide an easy and fast comparison between different `k`.

``` r
collect_plots(res)
```

![plot of chunk MAD-kmeans-collect-plots](figure_cola/MAD-kmeans-collect-plots-1.png)

The plots are:

- The first row: a plot of the eCDF (empirical cumulative distribution
  function) curves of the consensus matrix for each `k` and the heatmap of
  predicted classes for each `k`.
- The second row: heatmaps of the consensus matrix for each `k`.
- The third row: heatmaps of the membership matrix for each `k`.
- The fouth row: heatmaps of the signatures for each `k`.

All the plots in panels can be made by individual functions and they are
plotted later in this section.

`select_partition_number()` produces several plots showing different
statistics for choosing "optimized" `k`. There are following statistics:

- eCDF curves of the consensus matrix for each `k`;
- 1-PAC. [The PAC score](https://en.wikipedia.org/wiki/Consensus_clustering#Over-interpretation_potential_of_consensus_clustering)
  measures the proportion of the ambiguous subgrouping.
- Mean silhouette score.
- Concordance. The mean probability of fiting the consensus subgroup labels in all
  partitions.
- Area increased. Denote $A_k$ as the area under the eCDF curve for current
  `k`, the area increased is defined as $A_k - A_{k-1}$.
- Rand index. The percent of pairs of samples that are both in a same cluster
  or both are not in a same cluster in the partition of k and k-1.
- Jaccard index. The ratio of pairs of samples are both in a same cluster in
  the partition of k and k-1 and the pairs of samples are both in a same
  cluster in the partition k or k-1.

The detailed explanations of these statistics can be found in [the _cola_
vignette](https://jokergoo.github.io/cola_vignettes/cola.html#toc_13).

Generally speaking, higher 1-PAC score, higher mean silhouette score or higher
concordance corresponds to better partition. Rand index and Jaccard index
measure how similar the current partition is compared to partition with `k-1`.
If they are too similar, we won't accept `k` is better than `k-1`.

``` r
select_partition_number(res)
```

![plot of chunk MAD-kmeans-select-partition-number](figure_cola/MAD-kmeans-select-partition-number-1.png)

The numeric values for all these statistics can be obtained by `get_stats()`.

``` r
get_stats(res)
```

```
#>   k 1-PAC mean_silhouette concordance area_increased  Rand Jaccard
#> 2 2 0.999           0.940       0.976         0.5001 0.506   0.506
#> 3 3 0.737           0.914       0.922         0.3174 0.792   0.605
#> 4 4 0.672           0.799       0.815         0.1167 1.000   1.000
#> 5 5 0.641           0.546       0.745         0.0695 0.888   0.676
#> 6 6 0.632           0.408       0.643         0.0431 0.905   0.651
```

`suggest_best_k()` suggests the best $k$ based on these statistics. The rules are as follows:

- All $k$ with Jaccard index larger than 0.95 are removed because increasing
  $k$ does not provide enough extra information. If all $k$ are removed, it is
  marked as no subgroup is detected.
- For all $k$ with 1-PAC score larger than 0.9, the maximal $k$ is taken as
  the best $k$, and other $k$ are marked as optional $k$.
- If it does not fit the second rule. The $k$ with the maximal vote of the
  highest 1-PAC score, highest mean silhouette, and highest concordance is
  taken as the best $k$.

``` r
suggest_best_k(res)
```

```
#> [1] 2
```


Following is the table of the partitions (You need to click the **show/hide
code output** link to see it). The membership matrix (columns with name `p*`)
is inferred by
[`clue::cl_consensus()`](https://www.rdocumentation.org/link/cl_consensus?package=clue)
function with the `SE` method. Basically the value in the membership matrix
represents the probability to belong to a certain group. The finall subgroup
label for an item is determined with the group with highest probability it
belongs to.

In `get_classes()` function, the entropy is calculated from the membership
matrix and the silhouette score is calculated from the consensus matrix.



<script>
$( function() {
	$( '#tabs-MAD-kmeans-get-classes' ).tabs();
} );
</script>
<div id='tabs-MAD-kmeans-get-classes'>
<ul>
<li><a href='#tab-MAD-kmeans-get-classes-1'>k = 2</a></li>
<li><a href='#tab-MAD-kmeans-get-classes-2'>k = 3</a></li>
<li><a href='#tab-MAD-kmeans-get-classes-3'>k = 4</a></li>
<li><a href='#tab-MAD-kmeans-get-classes-4'>k = 5</a></li>
<li><a href='#tab-MAD-kmeans-get-classes-5'>k = 6</a></li>
</ul>

<div id='tab-MAD-kmeans-get-classes-1'>
<p><a id='tab-MAD-kmeans-get-classes-1-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 2), get_membership(res, k = 2))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2
#&gt; SIH013     2   0.327      0.908 0.06 0.94
#&gt; SIH014     2   0.000      0.961 0.00 1.00
#&gt; SIH024     2   0.000      0.961 0.00 1.00
#&gt; SIH028     2   0.000      0.961 0.00 1.00
#&gt; SIH031     1   0.000      0.994 1.00 0.00
#&gt; SIH042     1   0.000      0.994 1.00 0.00
#&gt; SIH107     2   0.000      0.961 0.00 1.00
#&gt; SIH114     1   0.000      0.994 1.00 0.00
#&gt; SIH116     1   0.000      0.994 1.00 0.00
#&gt; SIH117     2   0.000      0.961 0.00 1.00
#&gt; SIH130     2   0.000      0.961 0.00 1.00
#&gt; SIH134     2   0.000      0.961 0.00 1.00
#&gt; SIH186     2   0.000      0.961 0.00 1.00
#&gt; SIH191     1   0.000      0.994 1.00 0.00
#&gt; SIH192     2   0.000      0.961 0.00 1.00
#&gt; SIH196     2   0.000      0.961 0.00 1.00
#&gt; SIH214     2   0.000      0.961 0.00 1.00
#&gt; SIH218     2   0.971      0.360 0.40 0.60
#&gt; SIH232     1   0.000      0.994 1.00 0.00
#&gt; SIH236     1   0.000      0.994 1.00 0.00
#&gt; SIH238     1   0.141      0.976 0.98 0.02
#&gt; SIH241     2   0.000      0.961 0.00 1.00
#&gt; SIH245     2   0.000      0.961 0.00 1.00
#&gt; SIH260     1   0.327      0.934 0.94 0.06
#&gt; SIH287     2   0.000      0.961 0.00 1.00
#&gt; SIH289     1   0.327      0.936 0.94 0.06
#&gt; SIH290     2   0.000      0.961 0.00 1.00
#&gt; SIH295     1   0.000      0.994 1.00 0.00
#&gt; SIH366     1   0.000      0.994 1.00 0.00
#&gt; SIH377     1   0.000      0.994 1.00 0.00
#&gt; SIH380     2   0.000      0.961 0.00 1.00
#&gt; SIH385     2   0.000      0.961 0.00 1.00
#&gt; SIH389     2   0.000      0.961 0.00 1.00
#&gt; SIH391     2   0.000      0.961 0.00 1.00
#&gt; SIH403     1   0.000      0.994 1.00 0.00
#&gt; SIH411     2   0.000      0.961 0.00 1.00
#&gt; SIH427     1   0.000      0.994 1.00 0.00
#&gt; SIH433     2   0.000      0.961 0.00 1.00
#&gt; SIH439     2   0.000      0.961 0.00 1.00
#&gt; SIH442     1   0.000      0.994 1.00 0.00
#&gt; SIH444     2   0.995      0.184 0.46 0.54
#&gt; SIH452     2   0.000      0.961 0.00 1.00
#&gt; SIH461     2   0.141      0.945 0.02 0.98
#&gt; SIH471     1   0.000      0.994 1.00 0.00
#&gt; SIH472     2   0.000      0.961 0.00 1.00
#&gt; SIH481     1   0.000      0.994 1.00 0.00
#&gt; SIH485     2   0.000      0.961 0.00 1.00
#&gt; SIH491     2   0.000      0.961 0.00 1.00
#&gt; SIH508     1   0.000      0.994 1.00 0.00
#&gt; SIH559     1   0.000      0.994 1.00 0.00
#&gt; SIH587     1   0.000      0.994 1.00 0.00
#&gt; SIH625     2   0.943      0.451 0.36 0.64
#&gt; SIH641     1   0.000      0.994 1.00 0.00
#&gt; SIH643     2   0.000      0.961 0.00 1.00
#&gt; SIH674     1   0.000      0.994 1.00 0.00
#&gt; SIH678     1   0.000      0.994 1.00 0.00
#&gt; SIH679     1   0.000      0.994 1.00 0.00
#&gt; SIH689     2   0.000      0.961 0.00 1.00
#&gt; SIH694     2   0.000      0.961 0.00 1.00
#&gt; SIH721     2   0.000      0.961 0.00 1.00
</code></pre>

<script>
$('#tab-MAD-kmeans-get-classes-1-a').parent().next().next().hide();
$('#tab-MAD-kmeans-get-classes-1-a').click(function(){
  $('#tab-MAD-kmeans-get-classes-1-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-MAD-kmeans-get-classes-2'>
<p><a id='tab-MAD-kmeans-get-classes-2-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 3), get_membership(res, k = 3))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3
#&gt; SIH013     3  0.3832     0.8632 0.02 0.10 0.88
#&gt; SIH014     3  0.0000     0.9728 0.00 0.00 1.00
#&gt; SIH024     3  0.1529     0.9460 0.00 0.04 0.96
#&gt; SIH028     2  0.4291     0.9415 0.00 0.82 0.18
#&gt; SIH031     1  0.2537     0.9188 0.92 0.08 0.00
#&gt; SIH042     1  0.3686     0.9012 0.86 0.14 0.00
#&gt; SIH107     2  0.4002     0.9595 0.00 0.84 0.16
#&gt; SIH114     1  0.2066     0.9166 0.94 0.06 0.00
#&gt; SIH116     1  0.5147     0.8371 0.80 0.18 0.02
#&gt; SIH117     3  0.0000     0.9728 0.00 0.00 1.00
#&gt; SIH130     3  0.0000     0.9728 0.00 0.00 1.00
#&gt; SIH134     3  0.0000     0.9728 0.00 0.00 1.00
#&gt; SIH186     2  0.4002     0.9595 0.00 0.84 0.16
#&gt; SIH191     1  0.0892     0.9197 0.98 0.02 0.00
#&gt; SIH192     2  0.3686     0.9524 0.00 0.86 0.14
#&gt; SIH196     3  0.0000     0.9728 0.00 0.00 1.00
#&gt; SIH214     3  0.0000     0.9728 0.00 0.00 1.00
#&gt; SIH218     3  0.5817     0.7708 0.10 0.10 0.80
#&gt; SIH232     1  0.1529     0.9167 0.96 0.04 0.00
#&gt; SIH236     1  0.3340     0.8964 0.88 0.12 0.00
#&gt; SIH238     1  0.6176     0.8153 0.78 0.12 0.10
#&gt; SIH241     2  0.4002     0.9595 0.00 0.84 0.16
#&gt; SIH245     3  0.0000     0.9728 0.00 0.00 1.00
#&gt; SIH260     1  0.5397     0.7447 0.72 0.28 0.00
#&gt; SIH287     2  0.4002     0.9595 0.00 0.84 0.16
#&gt; SIH289     2  0.2414     0.8620 0.04 0.94 0.02
#&gt; SIH290     3  0.0892     0.9548 0.00 0.02 0.98
#&gt; SIH295     1  0.1529     0.9167 0.96 0.04 0.00
#&gt; SIH366     1  0.1529     0.9167 0.96 0.04 0.00
#&gt; SIH377     1  0.2537     0.9218 0.92 0.08 0.00
#&gt; SIH380     3  0.0000     0.9728 0.00 0.00 1.00
#&gt; SIH385     3  0.0000     0.9728 0.00 0.00 1.00
#&gt; SIH389     2  0.4002     0.9595 0.00 0.84 0.16
#&gt; SIH391     2  0.2959     0.9297 0.00 0.90 0.10
#&gt; SIH403     1  0.2066     0.9166 0.94 0.06 0.00
#&gt; SIH411     3  0.0000     0.9728 0.00 0.00 1.00
#&gt; SIH427     1  0.2537     0.9169 0.92 0.08 0.00
#&gt; SIH433     3  0.0000     0.9728 0.00 0.00 1.00
#&gt; SIH439     2  0.3832     0.9305 0.02 0.88 0.10
#&gt; SIH442     1  0.1529     0.9167 0.96 0.04 0.00
#&gt; SIH444     1  0.8342     0.0164 0.46 0.46 0.08
#&gt; SIH452     2  0.3686     0.9519 0.00 0.86 0.14
#&gt; SIH461     3  0.1529     0.9460 0.00 0.04 0.96
#&gt; SIH471     1  0.2537     0.9103 0.92 0.08 0.00
#&gt; SIH472     2  0.4002     0.9595 0.00 0.84 0.16
#&gt; SIH481     1  0.1529     0.9167 0.96 0.04 0.00
#&gt; SIH485     3  0.0000     0.9728 0.00 0.00 1.00
#&gt; SIH491     2  0.4002     0.9595 0.00 0.84 0.16
#&gt; SIH508     1  0.1529     0.9197 0.96 0.04 0.00
#&gt; SIH559     1  0.0000     0.9214 1.00 0.00 0.00
#&gt; SIH587     1  0.1529     0.9210 0.96 0.04 0.00
#&gt; SIH625     2  0.2414     0.8845 0.02 0.94 0.04
#&gt; SIH641     1  0.0892     0.9185 0.98 0.02 0.00
#&gt; SIH643     3  0.0000     0.9728 0.00 0.00 1.00
#&gt; SIH674     1  0.1529     0.9167 0.96 0.04 0.00
#&gt; SIH678     1  0.2066     0.9166 0.94 0.06 0.00
#&gt; SIH679     1  0.2959     0.9051 0.90 0.10 0.00
#&gt; SIH689     3  0.0000     0.9728 0.00 0.00 1.00
#&gt; SIH694     3  0.0000     0.9728 0.00 0.00 1.00
#&gt; SIH721     3  0.1781     0.9411 0.02 0.02 0.96
</code></pre>

<script>
$('#tab-MAD-kmeans-get-classes-2-a').parent().next().next().hide();
$('#tab-MAD-kmeans-get-classes-2-a').click(function(){
  $('#tab-MAD-kmeans-get-classes-2-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-MAD-kmeans-get-classes-3'>
<p><a id='tab-MAD-kmeans-get-classes-3-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 4), get_membership(res, k = 4))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3   p4
#&gt; SIH013     3  0.6617    0.66306 0.12 0.00 0.60 0.28
#&gt; SIH014     3  0.1637    0.87760 0.00 0.00 0.94 0.06
#&gt; SIH024     3  0.2921    0.84699 0.00 0.00 0.86 0.14
#&gt; SIH028     2  0.4753    0.87168 0.02 0.78 0.02 0.18
#&gt; SIH031     1  0.4522    0.78046 0.68 0.00 0.00 0.32
#&gt; SIH042     1  0.3610    0.70703 0.80 0.00 0.00 0.20
#&gt; SIH107     2  0.1913    0.91577 0.00 0.94 0.02 0.04
#&gt; SIH114     1  0.3400    0.78215 0.82 0.00 0.00 0.18
#&gt; SIH116     1  0.4894    0.66647 0.78 0.12 0.00 0.10
#&gt; SIH117     3  0.2345    0.87827 0.00 0.00 0.90 0.10
#&gt; SIH130     3  0.1211    0.88774 0.00 0.00 0.96 0.04
#&gt; SIH134     3  0.3400    0.84401 0.00 0.00 0.82 0.18
#&gt; SIH186     2  0.2335    0.91010 0.00 0.92 0.02 0.06
#&gt; SIH191     1  0.5062    0.77233 0.68 0.02 0.00 0.30
#&gt; SIH192     2  0.3853    0.89184 0.00 0.82 0.02 0.16
#&gt; SIH196     3  0.2011    0.87767 0.00 0.00 0.92 0.08
#&gt; SIH214     3  0.3198    0.87154 0.00 0.04 0.88 0.08
#&gt; SIH218     3  0.7497    0.40188 0.24 0.00 0.50 0.26
#&gt; SIH232     1  0.5428    0.74933 0.60 0.02 0.00 0.38
#&gt; SIH236     1  0.3400    0.70724 0.82 0.00 0.00 0.18
#&gt; SIH238     1  0.6248    0.53960 0.64 0.00 0.10 0.26
#&gt; SIH241     2  0.4894    0.82485 0.00 0.78 0.12 0.10
#&gt; SIH245     3  0.3400    0.84401 0.00 0.00 0.82 0.18
#&gt; SIH260     1  0.6216    0.59771 0.66 0.12 0.00 0.22
#&gt; SIH287     2  0.1411    0.91623 0.00 0.96 0.02 0.02
#&gt; SIH289     2  0.1637    0.89659 0.00 0.94 0.00 0.06
#&gt; SIH290     3  0.4079    0.83085 0.00 0.02 0.80 0.18
#&gt; SIH295     1  0.5428    0.74933 0.60 0.02 0.00 0.38
#&gt; SIH366     1  0.4079    0.78458 0.80 0.02 0.00 0.18
#&gt; SIH377     1  0.4277    0.78760 0.72 0.00 0.00 0.28
#&gt; SIH380     3  0.1211    0.88195 0.00 0.00 0.96 0.04
#&gt; SIH385     3  0.0000    0.88655 0.00 0.00 1.00 0.00
#&gt; SIH389     2  0.5147    0.85689 0.00 0.74 0.06 0.20
#&gt; SIH391     2  0.3853    0.89393 0.00 0.82 0.02 0.16
#&gt; SIH403     1  0.3610    0.77843 0.80 0.00 0.00 0.20
#&gt; SIH411     3  0.2921    0.86120 0.00 0.00 0.86 0.14
#&gt; SIH427     1  0.2345    0.77823 0.90 0.00 0.00 0.10
#&gt; SIH433     3  0.2647    0.87425 0.00 0.00 0.88 0.12
#&gt; SIH439     2  0.1211    0.90827 0.00 0.96 0.00 0.04
#&gt; SIH442     1  0.5428    0.74933 0.60 0.02 0.00 0.38
#&gt; SIH444     1  0.8453   -0.00278 0.36 0.30 0.02 0.32
#&gt; SIH452     2  0.1913    0.91284 0.00 0.94 0.02 0.04
#&gt; SIH461     3  0.3172    0.83629 0.00 0.00 0.84 0.16
#&gt; SIH471     1  0.1211    0.76796 0.96 0.00 0.00 0.04
#&gt; SIH472     2  0.3335    0.89598 0.00 0.86 0.02 0.12
#&gt; SIH481     1  0.5487    0.74948 0.58 0.02 0.00 0.40
#&gt; SIH485     3  0.0707    0.88720 0.00 0.00 0.98 0.02
#&gt; SIH491     2  0.2706    0.90750 0.00 0.90 0.02 0.08
#&gt; SIH508     1  0.2011    0.78323 0.92 0.00 0.00 0.08
#&gt; SIH559     1  0.4522    0.76759 0.68 0.00 0.00 0.32
#&gt; SIH587     1  0.5355    0.75329 0.62 0.02 0.00 0.36
#&gt; SIH625     2  0.1637    0.89659 0.00 0.94 0.00 0.06
#&gt; SIH641     1  0.2921    0.79162 0.86 0.00 0.00 0.14
#&gt; SIH643     3  0.1211    0.88451 0.00 0.00 0.96 0.04
#&gt; SIH674     1  0.5428    0.74933 0.60 0.02 0.00 0.38
#&gt; SIH678     1  0.3172    0.78847 0.84 0.00 0.00 0.16
#&gt; SIH679     1  0.2345    0.77420 0.90 0.00 0.00 0.10
#&gt; SIH689     3  0.1211    0.88774 0.00 0.00 0.96 0.04
#&gt; SIH694     3  0.2647    0.87421 0.00 0.00 0.88 0.12
#&gt; SIH721     3  0.3172    0.87522 0.00 0.00 0.84 0.16
</code></pre>

<script>
$('#tab-MAD-kmeans-get-classes-3-a').parent().next().next().hide();
$('#tab-MAD-kmeans-get-classes-3-a').click(function(){
  $('#tab-MAD-kmeans-get-classes-3-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-MAD-kmeans-get-classes-4'>
<p><a id='tab-MAD-kmeans-get-classes-4-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 5), get_membership(res, k = 5))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3   p4   p5
#&gt; SIH013     2  0.5759     0.6110 0.20 0.62 0.18 0.00 0.00
#&gt; SIH014     2  0.2754     0.8146 0.04 0.88 0.08 0.00 0.00
#&gt; SIH024     2  0.4373     0.7649 0.08 0.76 0.16 0.00 0.00
#&gt; SIH028     4  0.6422     0.5751 0.08 0.08 0.22 0.62 0.00
#&gt; SIH031     1  0.5884     0.1203 0.48 0.00 0.10 0.00 0.42
#&gt; SIH042     1  0.5414    -0.0339 0.66 0.00 0.14 0.00 0.20
#&gt; SIH107     4  0.0000     0.7150 0.00 0.00 0.00 1.00 0.00
#&gt; SIH114     1  0.5297     0.3015 0.58 0.00 0.06 0.00 0.36
#&gt; SIH116     1  0.7226     0.1078 0.56 0.00 0.18 0.14 0.12
#&gt; SIH117     2  0.3319     0.8156 0.02 0.82 0.16 0.00 0.00
#&gt; SIH130     2  0.2012     0.8190 0.02 0.92 0.06 0.00 0.00
#&gt; SIH134     2  0.4094     0.7573 0.02 0.78 0.18 0.02 0.00
#&gt; SIH186     4  0.2929     0.6762 0.00 0.00 0.18 0.82 0.00
#&gt; SIH191     5  0.1410     0.7123 0.06 0.00 0.00 0.00 0.94
#&gt; SIH192     4  0.4700     0.6554 0.02 0.02 0.26 0.70 0.00
#&gt; SIH196     2  0.4094     0.7573 0.02 0.78 0.18 0.02 0.00
#&gt; SIH214     2  0.3627     0.7985 0.04 0.84 0.10 0.02 0.00
#&gt; SIH218     1  0.6727    -0.1350 0.50 0.32 0.16 0.00 0.02
#&gt; SIH232     5  0.0609     0.7164 0.02 0.00 0.00 0.00 0.98
#&gt; SIH236     1  0.5820     0.0466 0.64 0.00 0.24 0.02 0.10
#&gt; SIH238     1  0.6274    -0.0791 0.62 0.06 0.24 0.00 0.08
#&gt; SIH241     4  0.4967     0.5867 0.00 0.06 0.28 0.66 0.00
#&gt; SIH245     2  0.4094     0.7573 0.02 0.78 0.18 0.02 0.00
#&gt; SIH260     1  0.7573    -0.1981 0.48 0.00 0.24 0.20 0.08
#&gt; SIH287     4  0.1216     0.7042 0.02 0.00 0.02 0.96 0.00
#&gt; SIH289     4  0.5700     0.3923 0.12 0.00 0.28 0.60 0.00
#&gt; SIH290     2  0.5293     0.6874 0.02 0.70 0.20 0.08 0.00
#&gt; SIH295     5  0.0000     0.7200 0.00 0.00 0.00 0.00 1.00
#&gt; SIH366     5  0.5136     0.5085 0.26 0.00 0.08 0.00 0.66
#&gt; SIH377     5  0.4675     0.2831 0.38 0.00 0.02 0.00 0.60
#&gt; SIH380     2  0.1216     0.8261 0.02 0.96 0.02 0.00 0.00
#&gt; SIH385     2  0.2331     0.8253 0.02 0.90 0.08 0.00 0.00
#&gt; SIH389     4  0.4588     0.6434 0.00 0.06 0.22 0.72 0.00
#&gt; SIH391     4  0.5484     0.4770 0.12 0.00 0.24 0.64 0.00
#&gt; SIH403     1  0.5558     0.3005 0.56 0.00 0.08 0.00 0.36
#&gt; SIH411     2  0.4106     0.7749 0.04 0.80 0.14 0.02 0.00
#&gt; SIH427     5  0.4675     0.4371 0.38 0.00 0.02 0.00 0.60
#&gt; SIH433     2  0.3999     0.7571 0.02 0.74 0.24 0.00 0.00
#&gt; SIH439     4  0.3796     0.6683 0.00 0.00 0.30 0.70 0.00
#&gt; SIH442     5  0.0609     0.7124 0.02 0.00 0.00 0.00 0.98
#&gt; SIH444     3  0.7915     0.0000 0.30 0.02 0.46 0.08 0.14
#&gt; SIH452     4  0.1043     0.7096 0.00 0.00 0.04 0.96 0.00
#&gt; SIH461     2  0.4373     0.7649 0.08 0.76 0.16 0.00 0.00
#&gt; SIH471     1  0.4798    -0.0349 0.54 0.00 0.02 0.00 0.44
#&gt; SIH472     4  0.3852     0.6749 0.00 0.02 0.22 0.76 0.00
#&gt; SIH481     5  0.3037     0.6512 0.10 0.00 0.04 0.00 0.86
#&gt; SIH485     2  0.0609     0.8308 0.00 0.98 0.02 0.00 0.00
#&gt; SIH491     4  0.3274     0.6642 0.00 0.00 0.22 0.78 0.00
#&gt; SIH508     5  0.4840     0.4840 0.32 0.00 0.04 0.00 0.64
#&gt; SIH559     5  0.4096     0.5318 0.20 0.00 0.04 0.00 0.76
#&gt; SIH587     5  0.2280     0.6452 0.12 0.00 0.00 0.00 0.88
#&gt; SIH625     4  0.5136     0.4705 0.08 0.00 0.26 0.66 0.00
#&gt; SIH641     5  0.3561     0.5904 0.26 0.00 0.00 0.00 0.74
#&gt; SIH643     2  0.3037     0.8192 0.04 0.86 0.10 0.00 0.00
#&gt; SIH674     5  0.0000     0.7200 0.00 0.00 0.00 0.00 1.00
#&gt; SIH678     1  0.5173     0.1197 0.50 0.00 0.04 0.00 0.46
#&gt; SIH679     1  0.6422     0.2757 0.46 0.00 0.18 0.00 0.36
#&gt; SIH689     2  0.2873     0.8230 0.02 0.86 0.12 0.00 0.00
#&gt; SIH694     2  0.2873     0.8219 0.02 0.86 0.12 0.00 0.00
#&gt; SIH721     2  0.3731     0.7976 0.04 0.80 0.16 0.00 0.00
</code></pre>

<script>
$('#tab-MAD-kmeans-get-classes-4-a').parent().next().next().hide();
$('#tab-MAD-kmeans-get-classes-4-a').click(function(){
  $('#tab-MAD-kmeans-get-classes-4-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-MAD-kmeans-get-classes-5'>
<p><a id='tab-MAD-kmeans-get-classes-5-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 6), get_membership(res, k = 6))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3   p4   p5   p6
#&gt; SIH013     3  0.4758     0.3091 0.00 0.06 0.58 0.00 0.00 0.36
#&gt; SIH014     3  0.1092     0.4734 0.02 0.02 0.96 0.00 0.00 0.00
#&gt; SIH024     3  0.3315     0.4626 0.00 0.02 0.78 0.00 0.00 0.20
#&gt; SIH028     4  0.6498     0.6646 0.10 0.12 0.04 0.62 0.00 0.12
#&gt; SIH031     5  0.6944     0.2797 0.06 0.14 0.02 0.00 0.46 0.32
#&gt; SIH042     6  0.6111    -0.0112 0.16 0.08 0.00 0.00 0.16 0.60
#&gt; SIH107     4  0.2474     0.7254 0.04 0.08 0.00 0.88 0.00 0.00
#&gt; SIH114     5  0.7278     0.1495 0.20 0.14 0.00 0.00 0.42 0.24
#&gt; SIH116     1  0.6984     0.6130 0.52 0.08 0.00 0.04 0.10 0.26
#&gt; SIH117     3  0.5291     0.2242 0.00 0.30 0.60 0.02 0.00 0.08
#&gt; SIH130     3  0.3851    -0.5109 0.00 0.46 0.54 0.00 0.00 0.00
#&gt; SIH134     2  0.3706     0.8778 0.00 0.62 0.38 0.00 0.00 0.00
#&gt; SIH186     4  0.3795     0.6787 0.06 0.12 0.00 0.80 0.00 0.02
#&gt; SIH191     5  0.2581     0.6245 0.00 0.02 0.00 0.00 0.86 0.12
#&gt; SIH192     4  0.5455     0.6779 0.26 0.08 0.00 0.62 0.00 0.04
#&gt; SIH196     2  0.3828     0.7815 0.00 0.56 0.44 0.00 0.00 0.00
#&gt; SIH214     3  0.3697     0.4021 0.04 0.06 0.82 0.08 0.00 0.00
#&gt; SIH218     6  0.6974     0.1602 0.08 0.20 0.30 0.00 0.00 0.42
#&gt; SIH232     5  0.0547     0.6287 0.02 0.00 0.00 0.00 0.98 0.00
#&gt; SIH236     6  0.4806    -0.4098 0.48 0.02 0.00 0.00 0.02 0.48
#&gt; SIH238     6  0.5422     0.2308 0.00 0.10 0.28 0.00 0.02 0.60
#&gt; SIH241     4  0.5603     0.5733 0.06 0.24 0.04 0.64 0.00 0.02
#&gt; SIH245     2  0.3706     0.8778 0.00 0.62 0.38 0.00 0.00 0.00
#&gt; SIH260     1  0.6207     0.4342 0.56 0.04 0.00 0.06 0.04 0.30
#&gt; SIH287     4  0.2728     0.7163 0.10 0.04 0.00 0.86 0.00 0.00
#&gt; SIH289     4  0.4328     0.4707 0.46 0.00 0.00 0.52 0.02 0.00
#&gt; SIH290     2  0.5337     0.7581 0.02 0.60 0.32 0.04 0.00 0.02
#&gt; SIH295     5  0.0547     0.6306 0.00 0.00 0.00 0.00 0.98 0.02
#&gt; SIH366     5  0.5071     0.2971 0.08 0.00 0.00 0.00 0.52 0.40
#&gt; SIH377     5  0.6678     0.3922 0.16 0.10 0.00 0.00 0.52 0.22
#&gt; SIH380     3  0.4078    -0.1258 0.02 0.34 0.64 0.00 0.00 0.00
#&gt; SIH385     3  0.2956     0.4439 0.00 0.12 0.84 0.00 0.00 0.04
#&gt; SIH389     4  0.3198     0.6884 0.00 0.26 0.00 0.74 0.00 0.00
#&gt; SIH391     4  0.5822     0.5668 0.28 0.06 0.00 0.58 0.00 0.08
#&gt; SIH403     5  0.7143     0.2191 0.16 0.14 0.00 0.00 0.44 0.26
#&gt; SIH411     3  0.5405    -0.4130 0.04 0.42 0.50 0.04 0.00 0.00
#&gt; SIH427     5  0.4902     0.2690 0.06 0.00 0.00 0.00 0.48 0.46
#&gt; SIH433     3  0.5831     0.3667 0.04 0.20 0.64 0.02 0.00 0.10
#&gt; SIH439     4  0.4711     0.6380 0.28 0.00 0.00 0.64 0.00 0.08
#&gt; SIH442     5  0.0547     0.6287 0.02 0.00 0.00 0.00 0.98 0.00
#&gt; SIH444     6  0.8086     0.0364 0.20 0.18 0.00 0.20 0.04 0.38
#&gt; SIH452     4  0.2350     0.7124 0.10 0.02 0.00 0.88 0.00 0.00
#&gt; SIH461     3  0.3315     0.4626 0.00 0.02 0.78 0.00 0.00 0.20
#&gt; SIH471     6  0.6152    -0.2466 0.16 0.02 0.00 0.00 0.40 0.42
#&gt; SIH472     4  0.4361     0.7130 0.06 0.14 0.00 0.76 0.00 0.04
#&gt; SIH481     5  0.2882     0.6079 0.02 0.02 0.00 0.00 0.86 0.10
#&gt; SIH485     3  0.3711     0.1537 0.02 0.26 0.72 0.00 0.00 0.00
#&gt; SIH491     4  0.3846     0.6762 0.08 0.10 0.00 0.80 0.00 0.02
#&gt; SIH508     5  0.4801     0.3124 0.02 0.02 0.00 0.00 0.50 0.46
#&gt; SIH559     5  0.4430     0.5493 0.08 0.04 0.00 0.00 0.76 0.12
#&gt; SIH587     5  0.2403     0.6122 0.02 0.04 0.00 0.00 0.90 0.04
#&gt; SIH625     4  0.3851     0.4843 0.46 0.00 0.00 0.54 0.00 0.00
#&gt; SIH641     5  0.3711     0.5135 0.00 0.02 0.00 0.00 0.72 0.26
#&gt; SIH643     3  0.3460     0.2651 0.00 0.22 0.76 0.00 0.00 0.02
#&gt; SIH674     5  0.0547     0.6306 0.00 0.00 0.00 0.00 0.98 0.02
#&gt; SIH678     5  0.6968     0.2544 0.18 0.12 0.00 0.00 0.48 0.22
#&gt; SIH679     1  0.6702     0.5115 0.52 0.10 0.00 0.00 0.20 0.18
#&gt; SIH689     3  0.3460     0.3491 0.00 0.22 0.76 0.00 0.00 0.02
#&gt; SIH694     3  0.5068    -0.0236 0.02 0.34 0.60 0.02 0.00 0.02
#&gt; SIH721     3  0.3985     0.4642 0.00 0.14 0.76 0.00 0.00 0.10
</code></pre>

<script>
$('#tab-MAD-kmeans-get-classes-5-a').parent().next().next().hide();
$('#tab-MAD-kmeans-get-classes-5-a').click(function(){
  $('#tab-MAD-kmeans-get-classes-5-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>
</div>

Heatmaps for the consensus matrix. It visualizes the probability of two
samples to be in a same group.




<script>
$( function() {
	$( '#tabs-MAD-kmeans-consensus-heatmap' ).tabs();
} );
</script>
<div id='tabs-MAD-kmeans-consensus-heatmap'>
<ul>
<li><a href='#tab-MAD-kmeans-consensus-heatmap-1'>k = 2</a></li>
<li><a href='#tab-MAD-kmeans-consensus-heatmap-2'>k = 3</a></li>
<li><a href='#tab-MAD-kmeans-consensus-heatmap-3'>k = 4</a></li>
<li><a href='#tab-MAD-kmeans-consensus-heatmap-4'>k = 5</a></li>
<li><a href='#tab-MAD-kmeans-consensus-heatmap-5'>k = 6</a></li>
</ul>
<div id='tab-MAD-kmeans-consensus-heatmap-1'>
<pre><code class="language-r">consensus_heatmap(res, k = 2)
</code></pre>
<p><img src="figure_cola/tab-MAD-kmeans-consensus-heatmap-1-1.png" alt="plot of chunk tab-MAD-kmeans-consensus-heatmap-1" /></p>

</div>
<div id='tab-MAD-kmeans-consensus-heatmap-2'>
<pre><code class="language-r">consensus_heatmap(res, k = 3)
</code></pre>
<p><img src="figure_cola/tab-MAD-kmeans-consensus-heatmap-2-1.png" alt="plot of chunk tab-MAD-kmeans-consensus-heatmap-2" /></p>

</div>
<div id='tab-MAD-kmeans-consensus-heatmap-3'>
<pre><code class="language-r">consensus_heatmap(res, k = 4)
</code></pre>
<p><img src="figure_cola/tab-MAD-kmeans-consensus-heatmap-3-1.png" alt="plot of chunk tab-MAD-kmeans-consensus-heatmap-3" /></p>

</div>
<div id='tab-MAD-kmeans-consensus-heatmap-4'>
<pre><code class="language-r">consensus_heatmap(res, k = 5)
</code></pre>
<p><img src="figure_cola/tab-MAD-kmeans-consensus-heatmap-4-1.png" alt="plot of chunk tab-MAD-kmeans-consensus-heatmap-4" /></p>

</div>
<div id='tab-MAD-kmeans-consensus-heatmap-5'>
<pre><code class="language-r">consensus_heatmap(res, k = 6)
</code></pre>
<p><img src="figure_cola/tab-MAD-kmeans-consensus-heatmap-5-1.png" alt="plot of chunk tab-MAD-kmeans-consensus-heatmap-5" /></p>

</div>
</div>

Heatmaps for the membership of samples in all partitions to see how consistent they are:





<script>
$( function() {
	$( '#tabs-MAD-kmeans-membership-heatmap' ).tabs();
} );
</script>
<div id='tabs-MAD-kmeans-membership-heatmap'>
<ul>
<li><a href='#tab-MAD-kmeans-membership-heatmap-1'>k = 2</a></li>
<li><a href='#tab-MAD-kmeans-membership-heatmap-2'>k = 3</a></li>
<li><a href='#tab-MAD-kmeans-membership-heatmap-3'>k = 4</a></li>
<li><a href='#tab-MAD-kmeans-membership-heatmap-4'>k = 5</a></li>
<li><a href='#tab-MAD-kmeans-membership-heatmap-5'>k = 6</a></li>
</ul>
<div id='tab-MAD-kmeans-membership-heatmap-1'>
<pre><code class="language-r">membership_heatmap(res, k = 2)
</code></pre>
<p><img src="figure_cola/tab-MAD-kmeans-membership-heatmap-1-1.png" alt="plot of chunk tab-MAD-kmeans-membership-heatmap-1" /></p>

</div>
<div id='tab-MAD-kmeans-membership-heatmap-2'>
<pre><code class="language-r">membership_heatmap(res, k = 3)
</code></pre>
<p><img src="figure_cola/tab-MAD-kmeans-membership-heatmap-2-1.png" alt="plot of chunk tab-MAD-kmeans-membership-heatmap-2" /></p>

</div>
<div id='tab-MAD-kmeans-membership-heatmap-3'>
<pre><code class="language-r">membership_heatmap(res, k = 4)
</code></pre>
<p><img src="figure_cola/tab-MAD-kmeans-membership-heatmap-3-1.png" alt="plot of chunk tab-MAD-kmeans-membership-heatmap-3" /></p>

</div>
<div id='tab-MAD-kmeans-membership-heatmap-4'>
<pre><code class="language-r">membership_heatmap(res, k = 5)
</code></pre>
<p><img src="figure_cola/tab-MAD-kmeans-membership-heatmap-4-1.png" alt="plot of chunk tab-MAD-kmeans-membership-heatmap-4" /></p>

</div>
<div id='tab-MAD-kmeans-membership-heatmap-5'>
<pre><code class="language-r">membership_heatmap(res, k = 6)
</code></pre>
<p><img src="figure_cola/tab-MAD-kmeans-membership-heatmap-5-1.png" alt="plot of chunk tab-MAD-kmeans-membership-heatmap-5" /></p>

</div>
</div>

As soon as the classes for columns are determined, the signatures
that are significantly different between subgroups can be looked for. 
Following are the heatmaps for signatures.




Signature heatmaps where rows are scaled:



<script>
$( function() {
	$( '#tabs-MAD-kmeans-get-signatures' ).tabs();
} );
</script>
<div id='tabs-MAD-kmeans-get-signatures'>
<ul>
<li><a href='#tab-MAD-kmeans-get-signatures-1'>k = 2</a></li>
<li><a href='#tab-MAD-kmeans-get-signatures-2'>k = 3</a></li>
<li><a href='#tab-MAD-kmeans-get-signatures-3'>k = 4</a></li>
<li><a href='#tab-MAD-kmeans-get-signatures-4'>k = 5</a></li>
<li><a href='#tab-MAD-kmeans-get-signatures-5'>k = 6</a></li>
</ul>
<div id='tab-MAD-kmeans-get-signatures-1'>
<pre><code class="language-r">get_signatures(res, k = 2)
</code></pre>
<p><img src="figure_cola/tab-MAD-kmeans-get-signatures-1-1.png" alt="plot of chunk tab-MAD-kmeans-get-signatures-1" /></p>

</div>
<div id='tab-MAD-kmeans-get-signatures-2'>
<pre><code class="language-r">get_signatures(res, k = 3)
</code></pre>
<p><img src="figure_cola/tab-MAD-kmeans-get-signatures-2-1.png" alt="plot of chunk tab-MAD-kmeans-get-signatures-2" /></p>

</div>
<div id='tab-MAD-kmeans-get-signatures-3'>
<pre><code class="language-r">get_signatures(res, k = 4)
</code></pre>
<p><img src="figure_cola/tab-MAD-kmeans-get-signatures-3-1.png" alt="plot of chunk tab-MAD-kmeans-get-signatures-3" /></p>

</div>
<div id='tab-MAD-kmeans-get-signatures-4'>
<pre><code class="language-r">get_signatures(res, k = 5)
</code></pre>
<p><img src="figure_cola/tab-MAD-kmeans-get-signatures-4-1.png" alt="plot of chunk tab-MAD-kmeans-get-signatures-4" /></p>

</div>
<div id='tab-MAD-kmeans-get-signatures-5'>
<pre><code class="language-r">get_signatures(res, k = 6)
</code></pre>
<p><img src="figure_cola/tab-MAD-kmeans-get-signatures-5-1.png" alt="plot of chunk tab-MAD-kmeans-get-signatures-5" /></p>

</div>
</div>



Signature heatmaps where rows are not scaled:


<script>
$( function() {
	$( '#tabs-MAD-kmeans-get-signatures-no-scale' ).tabs();
} );
</script>
<div id='tabs-MAD-kmeans-get-signatures-no-scale'>
<ul>
<li><a href='#tab-MAD-kmeans-get-signatures-no-scale-1'>k = 2</a></li>
<li><a href='#tab-MAD-kmeans-get-signatures-no-scale-2'>k = 3</a></li>
<li><a href='#tab-MAD-kmeans-get-signatures-no-scale-3'>k = 4</a></li>
<li><a href='#tab-MAD-kmeans-get-signatures-no-scale-4'>k = 5</a></li>
<li><a href='#tab-MAD-kmeans-get-signatures-no-scale-5'>k = 6</a></li>
</ul>
<div id='tab-MAD-kmeans-get-signatures-no-scale-1'>
<pre><code class="language-r">get_signatures(res, k = 2, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-MAD-kmeans-get-signatures-no-scale-1-1.png" alt="plot of chunk tab-MAD-kmeans-get-signatures-no-scale-1" /></p>

</div>
<div id='tab-MAD-kmeans-get-signatures-no-scale-2'>
<pre><code class="language-r">get_signatures(res, k = 3, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-MAD-kmeans-get-signatures-no-scale-2-1.png" alt="plot of chunk tab-MAD-kmeans-get-signatures-no-scale-2" /></p>

</div>
<div id='tab-MAD-kmeans-get-signatures-no-scale-3'>
<pre><code class="language-r">get_signatures(res, k = 4, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-MAD-kmeans-get-signatures-no-scale-3-1.png" alt="plot of chunk tab-MAD-kmeans-get-signatures-no-scale-3" /></p>

</div>
<div id='tab-MAD-kmeans-get-signatures-no-scale-4'>
<pre><code class="language-r">get_signatures(res, k = 5, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-MAD-kmeans-get-signatures-no-scale-4-1.png" alt="plot of chunk tab-MAD-kmeans-get-signatures-no-scale-4" /></p>

</div>
<div id='tab-MAD-kmeans-get-signatures-no-scale-5'>
<pre><code class="language-r">get_signatures(res, k = 6, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-MAD-kmeans-get-signatures-no-scale-5-1.png" alt="plot of chunk tab-MAD-kmeans-get-signatures-no-scale-5" /></p>

</div>
</div>



Compare the overlap of signatures from different k:

``` r
compare_signatures(res)
```

![plot of chunk MAD-kmeans-signature_compare](figure_cola/MAD-kmeans-signature_compare-1.png)

`get_signature()` returns a data frame invisibly. To get the list of signatures, the function
call should be assigned to a variable explicitly. In following code, if `plot` argument is set
to `FALSE`, no heatmap is plotted while only the differential analysis is performed.

``` r
# code only for demonstration
tb = get_signature(res, k = ..., plot = FALSE)
```

An example of the output of `tb` is:

```
#>   which_row         fdr    mean_1    mean_2 scaled_mean_1 scaled_mean_2 km
#> 1        38 0.042760348  8.373488  9.131774    -0.5533452     0.5164555  1
#> 2        40 0.018707592  7.106213  8.469186    -0.6173731     0.5762149  1
#> 3        55 0.019134737 10.221463 11.207825    -0.6159697     0.5749050  1
#> 4        59 0.006059896  5.921854  7.869574    -0.6899429     0.6439467  1
#> 5        60 0.018055526  8.928898 10.211722    -0.6204761     0.5791110  1
#> 6        98 0.009384629 15.714769 14.887706     0.6635654    -0.6193277  2
...
```

The columns in `tb` are:

1. `which_row`: row indices corresponding to the input matrix.
2. `fdr`: FDR for the differential test. 
3. `mean_x`: The mean value in group x.
4. `scaled_mean_x`: The mean value in group x after rows are scaled.
5. `km`: Row groups if k-means clustering is applied to rows (which is done by automatically selecting number of clusters).

If there are too many signatures, `top_signatures = ...` can be set to only show the 
signatures with the highest FDRs:

``` r
# code only for demonstration
# e.g. to show the top 500 most significant rows
tb = get_signature(res, k = ..., top_signatures = 500)
```

If the signatures are defined as these which are uniquely high in current group, `diff_method` argument
can be set to `"uniquely_high_in_one_group"`:

``` r
# code only for demonstration
tb = get_signature(res, k = ..., diff_method = "uniquely_high_in_one_group")
```




UMAP plot which shows how samples are separated.


<script>
$( function() {
	$( '#tabs-MAD-kmeans-dimension-reduction' ).tabs();
} );
</script>
<div id='tabs-MAD-kmeans-dimension-reduction'>
<ul>
<li><a href='#tab-MAD-kmeans-dimension-reduction-1'>k = 2</a></li>
<li><a href='#tab-MAD-kmeans-dimension-reduction-2'>k = 3</a></li>
<li><a href='#tab-MAD-kmeans-dimension-reduction-3'>k = 4</a></li>
<li><a href='#tab-MAD-kmeans-dimension-reduction-4'>k = 5</a></li>
<li><a href='#tab-MAD-kmeans-dimension-reduction-5'>k = 6</a></li>
</ul>
<div id='tab-MAD-kmeans-dimension-reduction-1'>
<pre><code class="language-r">dimension_reduction(res, k = 2, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-MAD-kmeans-dimension-reduction-1-1.png" alt="plot of chunk tab-MAD-kmeans-dimension-reduction-1" /></p>

</div>
<div id='tab-MAD-kmeans-dimension-reduction-2'>
<pre><code class="language-r">dimension_reduction(res, k = 3, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-MAD-kmeans-dimension-reduction-2-1.png" alt="plot of chunk tab-MAD-kmeans-dimension-reduction-2" /></p>

</div>
<div id='tab-MAD-kmeans-dimension-reduction-3'>
<pre><code class="language-r">dimension_reduction(res, k = 4, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-MAD-kmeans-dimension-reduction-3-1.png" alt="plot of chunk tab-MAD-kmeans-dimension-reduction-3" /></p>

</div>
<div id='tab-MAD-kmeans-dimension-reduction-4'>
<pre><code class="language-r">dimension_reduction(res, k = 5, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-MAD-kmeans-dimension-reduction-4-1.png" alt="plot of chunk tab-MAD-kmeans-dimension-reduction-4" /></p>

</div>
<div id='tab-MAD-kmeans-dimension-reduction-5'>
<pre><code class="language-r">dimension_reduction(res, k = 6, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-MAD-kmeans-dimension-reduction-5-1.png" alt="plot of chunk tab-MAD-kmeans-dimension-reduction-5" /></p>

</div>
</div>



Following heatmap shows how subgroups are split when increasing `k`:

``` r
collect_classes(res)
```

![plot of chunk MAD-kmeans-collect-classes](figure_cola/MAD-kmeans-collect-classes-1.png)



If matrix rows can be associated to genes, consider to use `functional_enrichment(res,
...)` to perform function enrichment for the signature genes. See [this vignette](https://jokergoo.github.io/cola_vignettes/functional_enrichment.html) for more detailed explanations.


 

---------------------------------------------------



### MAD:pam*






The object with results only for a single top-value method and a single partitioning method 
can be extracted as:

``` r
res = res_list["MAD", "pam"]
# you can also extract it by
# res = res_list["MAD:pam"]
```

A summary of `res` and all the functions that can be applied to it:

``` r
res
```

```
#> A 'ConsensusPartition' object with k = 2, 3, 4, 5, 6.
#>   On a matrix with 1900 rows and 60 columns.
#>   Top rows (190) are extracted by 'MAD' method.
#>   Subgroups are detected by 'pam' method.
#>   Performed in total 250 partitions by row resampling.
#>   Best k for subgroups seems to be 2.
#> 
#> Following methods can be applied to this 'ConsensusPartition' object:
#>  [1] "cola_report"             "collect_classes"         "collect_plots"          
#>  [4] "collect_stats"           "colnames"                "compare_partitions"     
#>  [7] "compare_signatures"      "consensus_heatmap"       "dimension_reduction"    
#> [10] "functional_enrichment"   "get_anno_col"            "get_anno"               
#> [13] "get_classes"             "get_consensus"           "get_matrix"             
#> [16] "get_membership"          "get_param"               "get_signatures"         
#> [19] "get_stats"               "is_best_k"               "is_stable_k"            
#> [22] "membership_heatmap"      "ncol"                    "nrow"                   
#> [25] "plot_ecdf"               "predict_classes"         "rownames"               
#> [28] "select_partition_number" "show"                    "suggest_best_k"         
#> [31] "test_to_known_factors"   "top_rows_heatmap"
```

`collect_plots()` function collects all the plots made from `res` for all `k` (number of subgroups)
into one single page to provide an easy and fast comparison between different `k`.

``` r
collect_plots(res)
```

![plot of chunk MAD-pam-collect-plots](figure_cola/MAD-pam-collect-plots-1.png)

The plots are:

- The first row: a plot of the eCDF (empirical cumulative distribution
  function) curves of the consensus matrix for each `k` and the heatmap of
  predicted classes for each `k`.
- The second row: heatmaps of the consensus matrix for each `k`.
- The third row: heatmaps of the membership matrix for each `k`.
- The fouth row: heatmaps of the signatures for each `k`.

All the plots in panels can be made by individual functions and they are
plotted later in this section.

`select_partition_number()` produces several plots showing different
statistics for choosing "optimized" `k`. There are following statistics:

- eCDF curves of the consensus matrix for each `k`;
- 1-PAC. [The PAC score](https://en.wikipedia.org/wiki/Consensus_clustering#Over-interpretation_potential_of_consensus_clustering)
  measures the proportion of the ambiguous subgrouping.
- Mean silhouette score.
- Concordance. The mean probability of fiting the consensus subgroup labels in all
  partitions.
- Area increased. Denote $A_k$ as the area under the eCDF curve for current
  `k`, the area increased is defined as $A_k - A_{k-1}$.
- Rand index. The percent of pairs of samples that are both in a same cluster
  or both are not in a same cluster in the partition of k and k-1.
- Jaccard index. The ratio of pairs of samples are both in a same cluster in
  the partition of k and k-1 and the pairs of samples are both in a same
  cluster in the partition k or k-1.

The detailed explanations of these statistics can be found in [the _cola_
vignette](https://jokergoo.github.io/cola_vignettes/cola.html#toc_13).

Generally speaking, higher 1-PAC score, higher mean silhouette score or higher
concordance corresponds to better partition. Rand index and Jaccard index
measure how similar the current partition is compared to partition with `k-1`.
If they are too similar, we won't accept `k` is better than `k-1`.

``` r
select_partition_number(res)
```

![plot of chunk MAD-pam-select-partition-number](figure_cola/MAD-pam-select-partition-number-1.png)

The numeric values for all these statistics can be obtained by `get_stats()`.

``` r
get_stats(res)
```

```
#>   k 1-PAC mean_silhouette concordance area_increased  Rand Jaccard
#> 2 2 0.930           0.950       0.977         0.5069 0.492   0.492
#> 3 3 0.497           0.623       0.808         0.3088 0.811   0.632
#> 4 4 0.467           0.398       0.673         0.1146 0.828   0.572
#> 5 5 0.511           0.448       0.622         0.0758 0.804   0.419
#> 6 6 0.583           0.445       0.655         0.0418 0.958   0.802
```

`suggest_best_k()` suggests the best $k$ based on these statistics. The rules are as follows:

- All $k$ with Jaccard index larger than 0.95 are removed because increasing
  $k$ does not provide enough extra information. If all $k$ are removed, it is
  marked as no subgroup is detected.
- For all $k$ with 1-PAC score larger than 0.9, the maximal $k$ is taken as
  the best $k$, and other $k$ are marked as optional $k$.
- If it does not fit the second rule. The $k$ with the maximal vote of the
  highest 1-PAC score, highest mean silhouette, and highest concordance is
  taken as the best $k$.

``` r
suggest_best_k(res)
```

```
#> [1] 2
```


Following is the table of the partitions (You need to click the **show/hide
code output** link to see it). The membership matrix (columns with name `p*`)
is inferred by
[`clue::cl_consensus()`](https://www.rdocumentation.org/link/cl_consensus?package=clue)
function with the `SE` method. Basically the value in the membership matrix
represents the probability to belong to a certain group. The finall subgroup
label for an item is determined with the group with highest probability it
belongs to.

In `get_classes()` function, the entropy is calculated from the membership
matrix and the silhouette score is calculated from the consensus matrix.



<script>
$( function() {
	$( '#tabs-MAD-pam-get-classes' ).tabs();
} );
</script>
<div id='tabs-MAD-pam-get-classes'>
<ul>
<li><a href='#tab-MAD-pam-get-classes-1'>k = 2</a></li>
<li><a href='#tab-MAD-pam-get-classes-2'>k = 3</a></li>
<li><a href='#tab-MAD-pam-get-classes-3'>k = 4</a></li>
<li><a href='#tab-MAD-pam-get-classes-4'>k = 5</a></li>
<li><a href='#tab-MAD-pam-get-classes-5'>k = 6</a></li>
</ul>

<div id='tab-MAD-pam-get-classes-1'>
<p><a id='tab-MAD-pam-get-classes-1-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 2), get_membership(res, k = 2))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2
#&gt; SIH013     2   0.327      0.927 0.06 0.94
#&gt; SIH014     2   0.000      0.984 0.00 1.00
#&gt; SIH024     2   0.000      0.984 0.00 1.00
#&gt; SIH028     2   0.141      0.967 0.02 0.98
#&gt; SIH031     1   0.000      0.966 1.00 0.00
#&gt; SIH042     1   0.000      0.966 1.00 0.00
#&gt; SIH107     2   0.000      0.984 0.00 1.00
#&gt; SIH114     1   0.000      0.966 1.00 0.00
#&gt; SIH116     1   0.242      0.942 0.96 0.04
#&gt; SIH117     2   0.000      0.984 0.00 1.00
#&gt; SIH130     2   0.000      0.984 0.00 1.00
#&gt; SIH134     2   0.000      0.984 0.00 1.00
#&gt; SIH186     2   0.000      0.984 0.00 1.00
#&gt; SIH191     1   0.000      0.966 1.00 0.00
#&gt; SIH192     2   0.000      0.984 0.00 1.00
#&gt; SIH196     2   0.000      0.984 0.00 1.00
#&gt; SIH214     2   0.000      0.984 0.00 1.00
#&gt; SIH218     2   0.000      0.984 0.00 1.00
#&gt; SIH232     1   0.000      0.966 1.00 0.00
#&gt; SIH236     1   0.000      0.966 1.00 0.00
#&gt; SIH238     1   0.722      0.766 0.80 0.20
#&gt; SIH241     2   0.000      0.984 0.00 1.00
#&gt; SIH245     2   0.000      0.984 0.00 1.00
#&gt; SIH260     1   0.000      0.966 1.00 0.00
#&gt; SIH287     2   0.000      0.984 0.00 1.00
#&gt; SIH289     1   0.141      0.955 0.98 0.02
#&gt; SIH290     2   0.000      0.984 0.00 1.00
#&gt; SIH295     1   0.000      0.966 1.00 0.00
#&gt; SIH366     1   0.000      0.966 1.00 0.00
#&gt; SIH377     1   0.000      0.966 1.00 0.00
#&gt; SIH380     2   0.000      0.984 0.00 1.00
#&gt; SIH385     2   0.000      0.984 0.00 1.00
#&gt; SIH389     2   0.000      0.984 0.00 1.00
#&gt; SIH391     1   0.584      0.848 0.86 0.14
#&gt; SIH403     1   0.000      0.966 1.00 0.00
#&gt; SIH411     2   0.000      0.984 0.00 1.00
#&gt; SIH427     1   0.000      0.966 1.00 0.00
#&gt; SIH433     2   0.000      0.984 0.00 1.00
#&gt; SIH439     2   0.925      0.464 0.34 0.66
#&gt; SIH442     1   0.000      0.966 1.00 0.00
#&gt; SIH444     1   0.855      0.626 0.72 0.28
#&gt; SIH452     1   0.680      0.798 0.82 0.18
#&gt; SIH461     2   0.242      0.948 0.04 0.96
#&gt; SIH471     1   0.000      0.966 1.00 0.00
#&gt; SIH472     2   0.000      0.984 0.00 1.00
#&gt; SIH481     1   0.000      0.966 1.00 0.00
#&gt; SIH485     2   0.000      0.984 0.00 1.00
#&gt; SIH491     2   0.000      0.984 0.00 1.00
#&gt; SIH508     1   0.000      0.966 1.00 0.00
#&gt; SIH559     1   0.000      0.966 1.00 0.00
#&gt; SIH587     1   0.000      0.966 1.00 0.00
#&gt; SIH625     1   0.141      0.955 0.98 0.02
#&gt; SIH641     1   0.141      0.955 0.98 0.02
#&gt; SIH643     2   0.000      0.984 0.00 1.00
#&gt; SIH674     1   0.000      0.966 1.00 0.00
#&gt; SIH678     1   0.000      0.966 1.00 0.00
#&gt; SIH679     1   0.242      0.941 0.96 0.04
#&gt; SIH689     2   0.000      0.984 0.00 1.00
#&gt; SIH694     2   0.000      0.984 0.00 1.00
#&gt; SIH721     2   0.000      0.984 0.00 1.00
</code></pre>

<script>
$('#tab-MAD-pam-get-classes-1-a').parent().next().next().hide();
$('#tab-MAD-pam-get-classes-1-a').click(function(){
  $('#tab-MAD-pam-get-classes-1-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-MAD-pam-get-classes-2'>
<p><a id='tab-MAD-pam-get-classes-2-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 3), get_membership(res, k = 3))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3
#&gt; SIH013     3  0.2947     0.6712 0.02 0.06 0.92
#&gt; SIH014     3  0.4002     0.5957 0.00 0.16 0.84
#&gt; SIH024     3  0.2537     0.6376 0.00 0.08 0.92
#&gt; SIH028     2  0.4291     0.4176 0.00 0.82 0.18
#&gt; SIH031     1  0.0000     0.8788 1.00 0.00 0.00
#&gt; SIH042     1  0.0892     0.8816 0.98 0.02 0.00
#&gt; SIH107     2  0.6280    -0.3607 0.00 0.54 0.46
#&gt; SIH114     1  0.0892     0.8754 0.98 0.02 0.00
#&gt; SIH116     1  0.5643     0.6570 0.76 0.22 0.02
#&gt; SIH117     3  0.5706     0.6609 0.00 0.32 0.68
#&gt; SIH130     3  0.5560     0.6715 0.00 0.30 0.70
#&gt; SIH134     3  0.5948     0.6394 0.00 0.36 0.64
#&gt; SIH186     2  0.2959     0.5603 0.00 0.90 0.10
#&gt; SIH191     1  0.0892     0.8816 0.98 0.02 0.00
#&gt; SIH192     2  0.5706     0.5144 0.00 0.68 0.32
#&gt; SIH196     3  0.5706     0.6569 0.00 0.32 0.68
#&gt; SIH214     3  0.6192    -0.0119 0.00 0.42 0.58
#&gt; SIH218     3  0.4449     0.6174 0.04 0.10 0.86
#&gt; SIH232     1  0.0892     0.8816 0.98 0.02 0.00
#&gt; SIH236     1  0.6677     0.6634 0.74 0.18 0.08
#&gt; SIH238     1  0.5948     0.4346 0.64 0.00 0.36
#&gt; SIH241     3  0.6192     0.5466 0.00 0.42 0.58
#&gt; SIH245     3  0.5948     0.6394 0.00 0.36 0.64
#&gt; SIH260     1  0.2947     0.8421 0.92 0.06 0.02
#&gt; SIH287     2  0.4555     0.5623 0.00 0.80 0.20
#&gt; SIH289     2  0.6309    -0.1397 0.50 0.50 0.00
#&gt; SIH290     3  0.6045     0.6241 0.00 0.38 0.62
#&gt; SIH295     1  0.0892     0.8816 0.98 0.02 0.00
#&gt; SIH366     1  0.1529     0.8739 0.96 0.04 0.00
#&gt; SIH377     1  0.0892     0.8747 0.98 0.02 0.00
#&gt; SIH380     3  0.4291     0.6783 0.00 0.18 0.82
#&gt; SIH385     3  0.0892     0.6755 0.00 0.02 0.98
#&gt; SIH389     2  0.1529     0.5734 0.00 0.96 0.04
#&gt; SIH391     2  0.7298     0.5537 0.20 0.70 0.10
#&gt; SIH403     1  0.2959     0.8207 0.90 0.10 0.00
#&gt; SIH411     3  0.5397     0.6769 0.00 0.28 0.72
#&gt; SIH427     1  0.0000     0.8788 1.00 0.00 0.00
#&gt; SIH433     3  0.4796     0.6556 0.00 0.22 0.78
#&gt; SIH439     2  0.6000     0.5506 0.04 0.76 0.20
#&gt; SIH442     1  0.0892     0.8816 0.98 0.02 0.00
#&gt; SIH444     1  0.9764    -0.0664 0.44 0.30 0.26
#&gt; SIH452     2  0.8137     0.5288 0.14 0.64 0.22
#&gt; SIH461     3  0.2947     0.6340 0.02 0.06 0.92
#&gt; SIH471     1  0.0000     0.8788 1.00 0.00 0.00
#&gt; SIH472     2  0.5216     0.3229 0.00 0.74 0.26
#&gt; SIH481     1  0.0892     0.8816 0.98 0.02 0.00
#&gt; SIH485     3  0.5216     0.6772 0.00 0.26 0.74
#&gt; SIH491     2  0.4291     0.5555 0.00 0.82 0.18
#&gt; SIH508     1  0.5016     0.6815 0.76 0.24 0.00
#&gt; SIH559     1  0.0000     0.8788 1.00 0.00 0.00
#&gt; SIH587     1  0.0892     0.8816 0.98 0.02 0.00
#&gt; SIH625     2  0.8321     0.5184 0.24 0.62 0.14
#&gt; SIH641     1  0.7310     0.3881 0.60 0.36 0.04
#&gt; SIH643     3  0.5216     0.6872 0.00 0.26 0.74
#&gt; SIH674     1  0.0892     0.8816 0.98 0.02 0.00
#&gt; SIH678     1  0.0000     0.8788 1.00 0.00 0.00
#&gt; SIH679     1  0.3415     0.8106 0.90 0.08 0.02
#&gt; SIH689     3  0.2066     0.6870 0.00 0.06 0.94
#&gt; SIH694     3  0.5948     0.6635 0.00 0.36 0.64
#&gt; SIH721     3  0.6192    -0.0650 0.00 0.42 0.58
</code></pre>

<script>
$('#tab-MAD-pam-get-classes-2-a').parent().next().next().hide();
$('#tab-MAD-pam-get-classes-2-a').click(function(){
  $('#tab-MAD-pam-get-classes-2-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-MAD-pam-get-classes-3'>
<p><a id='tab-MAD-pam-get-classes-3-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 4), get_membership(res, k = 4))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3   p4
#&gt; SIH013     2  0.7718    0.31699 0.02 0.54 0.18 0.26
#&gt; SIH014     3  0.5271    0.00442 0.00 0.34 0.64 0.02
#&gt; SIH024     3  0.6881   -0.05996 0.00 0.34 0.54 0.12
#&gt; SIH028     2  0.7707   -0.18325 0.00 0.44 0.32 0.24
#&gt; SIH031     1  0.4790    0.59363 0.62 0.00 0.00 0.38
#&gt; SIH042     1  0.3172    0.64011 0.84 0.00 0.00 0.16
#&gt; SIH107     2  0.7544   -0.01863 0.00 0.46 0.34 0.20
#&gt; SIH114     1  0.4624    0.63106 0.66 0.00 0.00 0.34
#&gt; SIH116     1  0.8025    0.26839 0.50 0.06 0.10 0.34
#&gt; SIH117     2  0.2335    0.61989 0.00 0.92 0.02 0.06
#&gt; SIH130     2  0.1913    0.62607 0.00 0.94 0.04 0.02
#&gt; SIH134     2  0.0707    0.62624 0.00 0.98 0.00 0.02
#&gt; SIH186     3  0.7805    0.25108 0.00 0.28 0.42 0.30
#&gt; SIH191     1  0.0707    0.70938 0.98 0.00 0.00 0.02
#&gt; SIH192     3  0.7610    0.15519 0.00 0.20 0.40 0.40
#&gt; SIH196     2  0.0707    0.62797 0.00 0.98 0.02 0.00
#&gt; SIH214     3  0.2921    0.33416 0.00 0.14 0.86 0.00
#&gt; SIH218     4  0.7414   -0.03495 0.00 0.18 0.34 0.48
#&gt; SIH232     1  0.3400    0.70463 0.82 0.00 0.00 0.18
#&gt; SIH236     4  0.6714    0.13675 0.36 0.10 0.00 0.54
#&gt; SIH238     4  0.7726    0.17020 0.22 0.04 0.16 0.58
#&gt; SIH241     2  0.5077    0.49853 0.00 0.76 0.16 0.08
#&gt; SIH245     2  0.0707    0.62624 0.00 0.98 0.00 0.02
#&gt; SIH260     1  0.3037    0.69917 0.88 0.00 0.02 0.10
#&gt; SIH287     3  0.7738    0.27637 0.00 0.26 0.44 0.30
#&gt; SIH289     4  0.7805    0.26090 0.28 0.00 0.30 0.42
#&gt; SIH290     2  0.2335    0.60509 0.00 0.92 0.02 0.06
#&gt; SIH295     1  0.0707    0.70938 0.98 0.00 0.00 0.02
#&gt; SIH366     1  0.1211    0.70399 0.96 0.00 0.00 0.04
#&gt; SIH377     1  0.3335    0.71263 0.86 0.00 0.02 0.12
#&gt; SIH380     2  0.4134    0.52517 0.00 0.74 0.26 0.00
#&gt; SIH385     2  0.6212    0.32690 0.00 0.56 0.38 0.06
#&gt; SIH389     3  0.7745    0.25652 0.00 0.34 0.42 0.24
#&gt; SIH391     3  0.7556    0.04678 0.14 0.02 0.54 0.30
#&gt; SIH403     1  0.4907    0.58501 0.58 0.00 0.00 0.42
#&gt; SIH411     2  0.5000    0.15073 0.00 0.50 0.50 0.00
#&gt; SIH427     1  0.1211    0.71831 0.96 0.00 0.00 0.04
#&gt; SIH433     3  0.6323   -0.09565 0.00 0.44 0.50 0.06
#&gt; SIH439     3  0.7056    0.21319 0.04 0.06 0.58 0.32
#&gt; SIH442     1  0.0000    0.71328 1.00 0.00 0.00 0.00
#&gt; SIH444     1  0.9758   -0.33548 0.34 0.24 0.16 0.26
#&gt; SIH452     3  0.5147    0.27436 0.06 0.00 0.74 0.20
#&gt; SIH461     3  0.6714   -0.09031 0.00 0.36 0.54 0.10
#&gt; SIH471     1  0.3801    0.69862 0.78 0.00 0.00 0.22
#&gt; SIH472     2  0.7493   -0.11480 0.00 0.48 0.32 0.20
#&gt; SIH481     1  0.2647    0.66120 0.88 0.00 0.00 0.12
#&gt; SIH485     2  0.4797    0.48905 0.00 0.72 0.26 0.02
#&gt; SIH491     3  0.2830    0.36595 0.00 0.04 0.90 0.06
#&gt; SIH508     1  0.5255    0.56770 0.78 0.02 0.12 0.08
#&gt; SIH559     1  0.4277    0.66012 0.72 0.00 0.00 0.28
#&gt; SIH587     1  0.4134    0.66919 0.74 0.00 0.00 0.26
#&gt; SIH625     4  0.8013    0.08757 0.18 0.02 0.34 0.46
#&gt; SIH641     1  0.7726    0.35833 0.58 0.04 0.16 0.22
#&gt; SIH643     2  0.4332    0.57405 0.00 0.80 0.16 0.04
#&gt; SIH674     1  0.0000    0.71328 1.00 0.00 0.00 0.00
#&gt; SIH678     1  0.4624    0.63106 0.66 0.00 0.00 0.34
#&gt; SIH679     1  0.6049    0.59815 0.68 0.12 0.00 0.20
#&gt; SIH689     2  0.4939    0.53957 0.00 0.74 0.22 0.04
#&gt; SIH694     2  0.3335    0.60352 0.00 0.86 0.12 0.02
#&gt; SIH721     3  0.6104    0.29523 0.00 0.18 0.68 0.14
</code></pre>

<script>
$('#tab-MAD-pam-get-classes-3-a').parent().next().next().hide();
$('#tab-MAD-pam-get-classes-3-a').click(function(){
  $('#tab-MAD-pam-get-classes-3-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-MAD-pam-get-classes-4'>
<p><a id='tab-MAD-pam-get-classes-4-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 5), get_membership(res, k = 5))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3   p4   p5
#&gt; SIH013     2  0.6682     0.3191 0.20 0.54 0.24 0.02 0.00
#&gt; SIH014     3  0.3037     0.6558 0.00 0.10 0.86 0.04 0.00
#&gt; SIH024     3  0.4225     0.6364 0.06 0.12 0.80 0.02 0.00
#&gt; SIH028     4  0.5842     0.4609 0.04 0.34 0.04 0.58 0.00
#&gt; SIH031     5  0.5425    -0.1663 0.42 0.00 0.06 0.00 0.52
#&gt; SIH042     5  0.2873     0.5494 0.12 0.00 0.02 0.00 0.86
#&gt; SIH107     4  0.6575     0.0666 0.02 0.42 0.12 0.44 0.00
#&gt; SIH114     1  0.3796     0.5383 0.70 0.00 0.00 0.00 0.30
#&gt; SIH116     1  0.7191     0.1862 0.46 0.08 0.00 0.10 0.36
#&gt; SIH117     2  0.2675     0.7587 0.04 0.90 0.04 0.02 0.00
#&gt; SIH130     2  0.1216     0.7803 0.02 0.96 0.02 0.00 0.00
#&gt; SIH134     2  0.0609     0.7750 0.00 0.98 0.00 0.02 0.00
#&gt; SIH186     4  0.4254     0.5845 0.04 0.22 0.00 0.74 0.00
#&gt; SIH191     5  0.0000     0.6008 0.00 0.00 0.00 0.00 1.00
#&gt; SIH192     4  0.6156     0.5571 0.04 0.12 0.20 0.64 0.00
#&gt; SIH196     2  0.1648     0.7681 0.00 0.94 0.04 0.02 0.00
#&gt; SIH214     3  0.3390     0.6306 0.00 0.06 0.84 0.10 0.00
#&gt; SIH218     3  0.6355     0.3099 0.38 0.10 0.50 0.02 0.00
#&gt; SIH232     1  0.4302     0.2593 0.52 0.00 0.00 0.00 0.48
#&gt; SIH236     4  0.8603     0.1451 0.32 0.04 0.10 0.38 0.16
#&gt; SIH238     1  0.5680     0.3402 0.62 0.00 0.24 0.00 0.14
#&gt; SIH241     2  0.3690     0.6217 0.02 0.78 0.00 0.20 0.00
#&gt; SIH245     2  0.1216     0.7771 0.00 0.96 0.02 0.02 0.00
#&gt; SIH260     5  0.4216     0.4357 0.10 0.00 0.00 0.12 0.78
#&gt; SIH287     4  0.4268     0.5972 0.02 0.20 0.02 0.76 0.00
#&gt; SIH289     4  0.6329     0.3081 0.12 0.00 0.02 0.56 0.30
#&gt; SIH290     2  0.2280     0.7290 0.00 0.88 0.00 0.12 0.00
#&gt; SIH295     5  0.1732     0.5620 0.08 0.00 0.00 0.00 0.92
#&gt; SIH366     5  0.1043     0.5959 0.04 0.00 0.00 0.00 0.96
#&gt; SIH377     5  0.4540     0.0703 0.34 0.00 0.02 0.00 0.64
#&gt; SIH380     2  0.4837     0.6216 0.02 0.74 0.18 0.06 0.00
#&gt; SIH385     3  0.5350    -0.0521 0.02 0.48 0.48 0.02 0.00
#&gt; SIH389     4  0.5700     0.5326 0.00 0.28 0.12 0.60 0.00
#&gt; SIH391     4  0.5915     0.5215 0.04 0.02 0.16 0.70 0.08
#&gt; SIH403     1  0.3895     0.5186 0.68 0.00 0.00 0.00 0.32
#&gt; SIH411     3  0.4398     0.6100 0.00 0.24 0.72 0.04 0.00
#&gt; SIH427     5  0.2873     0.5313 0.12 0.00 0.02 0.00 0.86
#&gt; SIH433     3  0.6263     0.5027 0.04 0.30 0.58 0.08 0.00
#&gt; SIH439     4  0.4687     0.5526 0.02 0.04 0.14 0.78 0.02
#&gt; SIH442     5  0.0000     0.6008 0.00 0.00 0.00 0.00 1.00
#&gt; SIH444     5  0.9500    -0.1333 0.14 0.26 0.10 0.18 0.32
#&gt; SIH452     4  0.6954     0.0905 0.06 0.00 0.36 0.48 0.10
#&gt; SIH461     3  0.3627     0.6452 0.04 0.10 0.84 0.02 0.00
#&gt; SIH471     5  0.4540     0.0366 0.34 0.00 0.02 0.00 0.64
#&gt; SIH472     4  0.4126     0.4079 0.00 0.38 0.00 0.62 0.00
#&gt; SIH481     5  0.2732     0.5359 0.16 0.00 0.00 0.00 0.84
#&gt; SIH485     3  0.4287     0.2483 0.00 0.46 0.54 0.00 0.00
#&gt; SIH491     3  0.4254     0.4731 0.04 0.00 0.74 0.22 0.00
#&gt; SIH508     5  0.5108     0.4851 0.06 0.04 0.04 0.08 0.78
#&gt; SIH559     5  0.4307    -0.2905 0.50 0.00 0.00 0.00 0.50
#&gt; SIH587     1  0.4302     0.1715 0.52 0.00 0.00 0.00 0.48
#&gt; SIH625     4  0.3700     0.5813 0.02 0.00 0.06 0.84 0.08
#&gt; SIH641     1  0.7385     0.1889 0.42 0.00 0.08 0.12 0.38
#&gt; SIH643     2  0.4312     0.6674 0.04 0.78 0.16 0.02 0.00
#&gt; SIH674     5  0.0000     0.6008 0.00 0.00 0.00 0.00 1.00
#&gt; SIH678     1  0.3796     0.5383 0.70 0.00 0.00 0.00 0.30
#&gt; SIH679     1  0.5607     0.4326 0.54 0.08 0.00 0.00 0.38
#&gt; SIH689     2  0.4966     0.5412 0.02 0.70 0.24 0.04 0.00
#&gt; SIH694     2  0.3641     0.7176 0.00 0.82 0.12 0.06 0.00
#&gt; SIH721     3  0.5192     0.5662 0.06 0.14 0.74 0.06 0.00
</code></pre>

<script>
$('#tab-MAD-pam-get-classes-4-a').parent().next().next().hide();
$('#tab-MAD-pam-get-classes-4-a').click(function(){
  $('#tab-MAD-pam-get-classes-4-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-MAD-pam-get-classes-5'>
<p><a id='tab-MAD-pam-get-classes-5-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 6), get_membership(res, k = 6))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3   p4   p5   p6
#&gt; SIH013     2  0.6955     0.1473 0.08 0.38 0.18 0.00 0.00 0.36
#&gt; SIH014     3  0.2474     0.6246 0.00 0.04 0.88 0.08 0.00 0.00
#&gt; SIH024     3  0.3351     0.5761 0.00 0.04 0.80 0.00 0.00 0.16
#&gt; SIH028     4  0.6478     0.2679 0.02 0.14 0.02 0.44 0.00 0.38
#&gt; SIH031     5  0.6396     0.3173 0.34 0.00 0.04 0.00 0.46 0.16
#&gt; SIH042     5  0.3523     0.5589 0.04 0.00 0.00 0.00 0.78 0.18
#&gt; SIH107     4  0.4798     0.3174 0.00 0.30 0.08 0.62 0.00 0.00
#&gt; SIH114     1  0.1556     0.5576 0.92 0.00 0.00 0.00 0.08 0.00
#&gt; SIH116     5  0.7107    -0.1142 0.30 0.00 0.00 0.08 0.38 0.24
#&gt; SIH117     2  0.3198     0.6471 0.00 0.74 0.00 0.00 0.00 0.26
#&gt; SIH130     2  0.2094     0.7434 0.00 0.90 0.02 0.00 0.00 0.08
#&gt; SIH134     2  0.0000     0.7430 0.00 1.00 0.00 0.00 0.00 0.00
#&gt; SIH186     4  0.5422     0.3656 0.00 0.24 0.02 0.62 0.00 0.12
#&gt; SIH191     5  0.1092     0.6666 0.02 0.00 0.00 0.00 0.96 0.02
#&gt; SIH192     4  0.6549     0.3524 0.00 0.12 0.08 0.48 0.00 0.32
#&gt; SIH196     2  0.0937     0.7412 0.00 0.96 0.04 0.00 0.00 0.00
#&gt; SIH214     3  0.2350     0.6157 0.00 0.02 0.88 0.10 0.00 0.00
#&gt; SIH218     3  0.7526     0.2009 0.22 0.10 0.42 0.02 0.00 0.24
#&gt; SIH232     1  0.4078     0.4095 0.64 0.00 0.00 0.00 0.34 0.02
#&gt; SIH236     4  0.8253    -0.0652 0.28 0.02 0.02 0.30 0.12 0.26
#&gt; SIH238     1  0.6862     0.0352 0.40 0.00 0.16 0.00 0.08 0.36
#&gt; SIH241     2  0.5310     0.5344 0.00 0.64 0.02 0.12 0.00 0.22
#&gt; SIH245     2  0.0000     0.7430 0.00 1.00 0.00 0.00 0.00 0.00
#&gt; SIH260     5  0.4967     0.5402 0.12 0.00 0.00 0.10 0.72 0.06
#&gt; SIH287     4  0.4055     0.4459 0.00 0.14 0.04 0.78 0.00 0.04
#&gt; SIH289     4  0.6334     0.1098 0.04 0.00 0.00 0.42 0.14 0.40
#&gt; SIH290     2  0.1807     0.7230 0.00 0.92 0.00 0.06 0.00 0.02
#&gt; SIH295     5  0.1807     0.6232 0.06 0.00 0.00 0.00 0.92 0.02
#&gt; SIH366     5  0.1267     0.6577 0.00 0.00 0.00 0.00 0.94 0.06
#&gt; SIH377     1  0.4845     0.2988 0.54 0.00 0.00 0.00 0.40 0.06
#&gt; SIH380     2  0.3318     0.6798 0.00 0.82 0.14 0.02 0.00 0.02
#&gt; SIH385     3  0.4310     0.0721 0.00 0.44 0.54 0.00 0.00 0.02
#&gt; SIH389     4  0.6920     0.2859 0.00 0.36 0.10 0.40 0.00 0.14
#&gt; SIH391     4  0.4733     0.4107 0.00 0.00 0.08 0.74 0.06 0.12
#&gt; SIH403     1  0.2350     0.5558 0.88 0.00 0.00 0.00 0.10 0.02
#&gt; SIH411     3  0.3475     0.6192 0.00 0.14 0.80 0.06 0.00 0.00
#&gt; SIH427     5  0.3270     0.6418 0.12 0.00 0.00 0.00 0.82 0.06
#&gt; SIH433     3  0.6101     0.4189 0.00 0.14 0.54 0.04 0.00 0.28
#&gt; SIH439     4  0.6271     0.3256 0.00 0.06 0.04 0.54 0.04 0.32
#&gt; SIH442     5  0.0937     0.6649 0.04 0.00 0.00 0.00 0.96 0.00
#&gt; SIH444     6  0.7549     0.0000 0.08 0.12 0.04 0.02 0.24 0.50
#&gt; SIH452     4  0.5705     0.2951 0.00 0.00 0.20 0.62 0.04 0.14
#&gt; SIH461     3  0.2350     0.6029 0.00 0.02 0.88 0.00 0.00 0.10
#&gt; SIH471     5  0.4247     0.5682 0.24 0.00 0.00 0.00 0.70 0.06
#&gt; SIH472     4  0.6331     0.2834 0.00 0.38 0.02 0.40 0.00 0.20
#&gt; SIH481     5  0.3073     0.5849 0.08 0.00 0.00 0.00 0.84 0.08
#&gt; SIH485     3  0.4246     0.2851 0.00 0.40 0.58 0.00 0.00 0.02
#&gt; SIH491     3  0.4536     0.5031 0.00 0.00 0.70 0.18 0.00 0.12
#&gt; SIH508     5  0.4334     0.4289 0.02 0.00 0.00 0.04 0.72 0.22
#&gt; SIH559     5  0.3797     0.3349 0.42 0.00 0.00 0.00 0.58 0.00
#&gt; SIH587     5  0.4246     0.3588 0.40 0.00 0.00 0.00 0.58 0.02
#&gt; SIH625     4  0.4247     0.3784 0.00 0.00 0.00 0.70 0.06 0.24
#&gt; SIH641     1  0.7793     0.1101 0.38 0.00 0.06 0.08 0.32 0.16
#&gt; SIH643     2  0.3045     0.7003 0.00 0.84 0.10 0.00 0.00 0.06
#&gt; SIH674     5  0.0000     0.6597 0.00 0.00 0.00 0.00 1.00 0.00
#&gt; SIH678     1  0.2454     0.5531 0.84 0.00 0.00 0.00 0.16 0.00
#&gt; SIH679     1  0.3592     0.5376 0.74 0.00 0.00 0.00 0.24 0.02
#&gt; SIH689     2  0.5520     0.4454 0.00 0.56 0.24 0.00 0.00 0.20
#&gt; SIH694     2  0.4754     0.6374 0.00 0.70 0.08 0.02 0.00 0.20
#&gt; SIH721     3  0.4689     0.3695 0.00 0.02 0.58 0.02 0.00 0.38
</code></pre>

<script>
$('#tab-MAD-pam-get-classes-5-a').parent().next().next().hide();
$('#tab-MAD-pam-get-classes-5-a').click(function(){
  $('#tab-MAD-pam-get-classes-5-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>
</div>

Heatmaps for the consensus matrix. It visualizes the probability of two
samples to be in a same group.




<script>
$( function() {
	$( '#tabs-MAD-pam-consensus-heatmap' ).tabs();
} );
</script>
<div id='tabs-MAD-pam-consensus-heatmap'>
<ul>
<li><a href='#tab-MAD-pam-consensus-heatmap-1'>k = 2</a></li>
<li><a href='#tab-MAD-pam-consensus-heatmap-2'>k = 3</a></li>
<li><a href='#tab-MAD-pam-consensus-heatmap-3'>k = 4</a></li>
<li><a href='#tab-MAD-pam-consensus-heatmap-4'>k = 5</a></li>
<li><a href='#tab-MAD-pam-consensus-heatmap-5'>k = 6</a></li>
</ul>
<div id='tab-MAD-pam-consensus-heatmap-1'>
<pre><code class="language-r">consensus_heatmap(res, k = 2)
</code></pre>
<p><img src="figure_cola/tab-MAD-pam-consensus-heatmap-1-1.png" alt="plot of chunk tab-MAD-pam-consensus-heatmap-1" /></p>

</div>
<div id='tab-MAD-pam-consensus-heatmap-2'>
<pre><code class="language-r">consensus_heatmap(res, k = 3)
</code></pre>
<p><img src="figure_cola/tab-MAD-pam-consensus-heatmap-2-1.png" alt="plot of chunk tab-MAD-pam-consensus-heatmap-2" /></p>

</div>
<div id='tab-MAD-pam-consensus-heatmap-3'>
<pre><code class="language-r">consensus_heatmap(res, k = 4)
</code></pre>
<p><img src="figure_cola/tab-MAD-pam-consensus-heatmap-3-1.png" alt="plot of chunk tab-MAD-pam-consensus-heatmap-3" /></p>

</div>
<div id='tab-MAD-pam-consensus-heatmap-4'>
<pre><code class="language-r">consensus_heatmap(res, k = 5)
</code></pre>
<p><img src="figure_cola/tab-MAD-pam-consensus-heatmap-4-1.png" alt="plot of chunk tab-MAD-pam-consensus-heatmap-4" /></p>

</div>
<div id='tab-MAD-pam-consensus-heatmap-5'>
<pre><code class="language-r">consensus_heatmap(res, k = 6)
</code></pre>
<p><img src="figure_cola/tab-MAD-pam-consensus-heatmap-5-1.png" alt="plot of chunk tab-MAD-pam-consensus-heatmap-5" /></p>

</div>
</div>

Heatmaps for the membership of samples in all partitions to see how consistent they are:





<script>
$( function() {
	$( '#tabs-MAD-pam-membership-heatmap' ).tabs();
} );
</script>
<div id='tabs-MAD-pam-membership-heatmap'>
<ul>
<li><a href='#tab-MAD-pam-membership-heatmap-1'>k = 2</a></li>
<li><a href='#tab-MAD-pam-membership-heatmap-2'>k = 3</a></li>
<li><a href='#tab-MAD-pam-membership-heatmap-3'>k = 4</a></li>
<li><a href='#tab-MAD-pam-membership-heatmap-4'>k = 5</a></li>
<li><a href='#tab-MAD-pam-membership-heatmap-5'>k = 6</a></li>
</ul>
<div id='tab-MAD-pam-membership-heatmap-1'>
<pre><code class="language-r">membership_heatmap(res, k = 2)
</code></pre>
<p><img src="figure_cola/tab-MAD-pam-membership-heatmap-1-1.png" alt="plot of chunk tab-MAD-pam-membership-heatmap-1" /></p>

</div>
<div id='tab-MAD-pam-membership-heatmap-2'>
<pre><code class="language-r">membership_heatmap(res, k = 3)
</code></pre>
<p><img src="figure_cola/tab-MAD-pam-membership-heatmap-2-1.png" alt="plot of chunk tab-MAD-pam-membership-heatmap-2" /></p>

</div>
<div id='tab-MAD-pam-membership-heatmap-3'>
<pre><code class="language-r">membership_heatmap(res, k = 4)
</code></pre>
<p><img src="figure_cola/tab-MAD-pam-membership-heatmap-3-1.png" alt="plot of chunk tab-MAD-pam-membership-heatmap-3" /></p>

</div>
<div id='tab-MAD-pam-membership-heatmap-4'>
<pre><code class="language-r">membership_heatmap(res, k = 5)
</code></pre>
<p><img src="figure_cola/tab-MAD-pam-membership-heatmap-4-1.png" alt="plot of chunk tab-MAD-pam-membership-heatmap-4" /></p>

</div>
<div id='tab-MAD-pam-membership-heatmap-5'>
<pre><code class="language-r">membership_heatmap(res, k = 6)
</code></pre>
<p><img src="figure_cola/tab-MAD-pam-membership-heatmap-5-1.png" alt="plot of chunk tab-MAD-pam-membership-heatmap-5" /></p>

</div>
</div>

As soon as the classes for columns are determined, the signatures
that are significantly different between subgroups can be looked for. 
Following are the heatmaps for signatures.




Signature heatmaps where rows are scaled:



<script>
$( function() {
	$( '#tabs-MAD-pam-get-signatures' ).tabs();
} );
</script>
<div id='tabs-MAD-pam-get-signatures'>
<ul>
<li><a href='#tab-MAD-pam-get-signatures-1'>k = 2</a></li>
<li><a href='#tab-MAD-pam-get-signatures-2'>k = 3</a></li>
<li><a href='#tab-MAD-pam-get-signatures-3'>k = 4</a></li>
<li><a href='#tab-MAD-pam-get-signatures-4'>k = 5</a></li>
<li><a href='#tab-MAD-pam-get-signatures-5'>k = 6</a></li>
</ul>
<div id='tab-MAD-pam-get-signatures-1'>
<pre><code class="language-r">get_signatures(res, k = 2)
</code></pre>
<p><img src="figure_cola/tab-MAD-pam-get-signatures-1-1.png" alt="plot of chunk tab-MAD-pam-get-signatures-1" /></p>

</div>
<div id='tab-MAD-pam-get-signatures-2'>
<pre><code class="language-r">get_signatures(res, k = 3)
</code></pre>
<p><img src="figure_cola/tab-MAD-pam-get-signatures-2-1.png" alt="plot of chunk tab-MAD-pam-get-signatures-2" /></p>

</div>
<div id='tab-MAD-pam-get-signatures-3'>
<pre><code class="language-r">get_signatures(res, k = 4)
</code></pre>
<p><img src="figure_cola/tab-MAD-pam-get-signatures-3-1.png" alt="plot of chunk tab-MAD-pam-get-signatures-3" /></p>

</div>
<div id='tab-MAD-pam-get-signatures-4'>
<pre><code class="language-r">get_signatures(res, k = 5)
</code></pre>
<p><img src="figure_cola/tab-MAD-pam-get-signatures-4-1.png" alt="plot of chunk tab-MAD-pam-get-signatures-4" /></p>

</div>
<div id='tab-MAD-pam-get-signatures-5'>
<pre><code class="language-r">get_signatures(res, k = 6)
</code></pre>
<p><img src="figure_cola/tab-MAD-pam-get-signatures-5-1.png" alt="plot of chunk tab-MAD-pam-get-signatures-5" /></p>

</div>
</div>



Signature heatmaps where rows are not scaled:


<script>
$( function() {
	$( '#tabs-MAD-pam-get-signatures-no-scale' ).tabs();
} );
</script>
<div id='tabs-MAD-pam-get-signatures-no-scale'>
<ul>
<li><a href='#tab-MAD-pam-get-signatures-no-scale-1'>k = 2</a></li>
<li><a href='#tab-MAD-pam-get-signatures-no-scale-2'>k = 3</a></li>
<li><a href='#tab-MAD-pam-get-signatures-no-scale-3'>k = 4</a></li>
<li><a href='#tab-MAD-pam-get-signatures-no-scale-4'>k = 5</a></li>
<li><a href='#tab-MAD-pam-get-signatures-no-scale-5'>k = 6</a></li>
</ul>
<div id='tab-MAD-pam-get-signatures-no-scale-1'>
<pre><code class="language-r">get_signatures(res, k = 2, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-MAD-pam-get-signatures-no-scale-1-1.png" alt="plot of chunk tab-MAD-pam-get-signatures-no-scale-1" /></p>

</div>
<div id='tab-MAD-pam-get-signatures-no-scale-2'>
<pre><code class="language-r">get_signatures(res, k = 3, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-MAD-pam-get-signatures-no-scale-2-1.png" alt="plot of chunk tab-MAD-pam-get-signatures-no-scale-2" /></p>

</div>
<div id='tab-MAD-pam-get-signatures-no-scale-3'>
<pre><code class="language-r">get_signatures(res, k = 4, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-MAD-pam-get-signatures-no-scale-3-1.png" alt="plot of chunk tab-MAD-pam-get-signatures-no-scale-3" /></p>

</div>
<div id='tab-MAD-pam-get-signatures-no-scale-4'>
<pre><code class="language-r">get_signatures(res, k = 5, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-MAD-pam-get-signatures-no-scale-4-1.png" alt="plot of chunk tab-MAD-pam-get-signatures-no-scale-4" /></p>

</div>
<div id='tab-MAD-pam-get-signatures-no-scale-5'>
<pre><code class="language-r">get_signatures(res, k = 6, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-MAD-pam-get-signatures-no-scale-5-1.png" alt="plot of chunk tab-MAD-pam-get-signatures-no-scale-5" /></p>

</div>
</div>



Compare the overlap of signatures from different k:

``` r
compare_signatures(res)
```

![plot of chunk MAD-pam-signature_compare](figure_cola/MAD-pam-signature_compare-1.png)

`get_signature()` returns a data frame invisibly. To get the list of signatures, the function
call should be assigned to a variable explicitly. In following code, if `plot` argument is set
to `FALSE`, no heatmap is plotted while only the differential analysis is performed.

``` r
# code only for demonstration
tb = get_signature(res, k = ..., plot = FALSE)
```

An example of the output of `tb` is:

```
#>   which_row         fdr    mean_1    mean_2 scaled_mean_1 scaled_mean_2 km
#> 1        38 0.042760348  8.373488  9.131774    -0.5533452     0.5164555  1
#> 2        40 0.018707592  7.106213  8.469186    -0.6173731     0.5762149  1
#> 3        55 0.019134737 10.221463 11.207825    -0.6159697     0.5749050  1
#> 4        59 0.006059896  5.921854  7.869574    -0.6899429     0.6439467  1
#> 5        60 0.018055526  8.928898 10.211722    -0.6204761     0.5791110  1
#> 6        98 0.009384629 15.714769 14.887706     0.6635654    -0.6193277  2
...
```

The columns in `tb` are:

1. `which_row`: row indices corresponding to the input matrix.
2. `fdr`: FDR for the differential test. 
3. `mean_x`: The mean value in group x.
4. `scaled_mean_x`: The mean value in group x after rows are scaled.
5. `km`: Row groups if k-means clustering is applied to rows (which is done by automatically selecting number of clusters).

If there are too many signatures, `top_signatures = ...` can be set to only show the 
signatures with the highest FDRs:

``` r
# code only for demonstration
# e.g. to show the top 500 most significant rows
tb = get_signature(res, k = ..., top_signatures = 500)
```

If the signatures are defined as these which are uniquely high in current group, `diff_method` argument
can be set to `"uniquely_high_in_one_group"`:

``` r
# code only for demonstration
tb = get_signature(res, k = ..., diff_method = "uniquely_high_in_one_group")
```




UMAP plot which shows how samples are separated.


<script>
$( function() {
	$( '#tabs-MAD-pam-dimension-reduction' ).tabs();
} );
</script>
<div id='tabs-MAD-pam-dimension-reduction'>
<ul>
<li><a href='#tab-MAD-pam-dimension-reduction-1'>k = 2</a></li>
<li><a href='#tab-MAD-pam-dimension-reduction-2'>k = 3</a></li>
<li><a href='#tab-MAD-pam-dimension-reduction-3'>k = 4</a></li>
<li><a href='#tab-MAD-pam-dimension-reduction-4'>k = 5</a></li>
<li><a href='#tab-MAD-pam-dimension-reduction-5'>k = 6</a></li>
</ul>
<div id='tab-MAD-pam-dimension-reduction-1'>
<pre><code class="language-r">dimension_reduction(res, k = 2, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-MAD-pam-dimension-reduction-1-1.png" alt="plot of chunk tab-MAD-pam-dimension-reduction-1" /></p>

</div>
<div id='tab-MAD-pam-dimension-reduction-2'>
<pre><code class="language-r">dimension_reduction(res, k = 3, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-MAD-pam-dimension-reduction-2-1.png" alt="plot of chunk tab-MAD-pam-dimension-reduction-2" /></p>

</div>
<div id='tab-MAD-pam-dimension-reduction-3'>
<pre><code class="language-r">dimension_reduction(res, k = 4, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-MAD-pam-dimension-reduction-3-1.png" alt="plot of chunk tab-MAD-pam-dimension-reduction-3" /></p>

</div>
<div id='tab-MAD-pam-dimension-reduction-4'>
<pre><code class="language-r">dimension_reduction(res, k = 5, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-MAD-pam-dimension-reduction-4-1.png" alt="plot of chunk tab-MAD-pam-dimension-reduction-4" /></p>

</div>
<div id='tab-MAD-pam-dimension-reduction-5'>
<pre><code class="language-r">dimension_reduction(res, k = 6, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-MAD-pam-dimension-reduction-5-1.png" alt="plot of chunk tab-MAD-pam-dimension-reduction-5" /></p>

</div>
</div>



Following heatmap shows how subgroups are split when increasing `k`:

``` r
collect_classes(res)
```

![plot of chunk MAD-pam-collect-classes](figure_cola/MAD-pam-collect-classes-1.png)



If matrix rows can be associated to genes, consider to use `functional_enrichment(res,
...)` to perform function enrichment for the signature genes. See [this vignette](https://jokergoo.github.io/cola_vignettes/functional_enrichment.html) for more detailed explanations.


 

---------------------------------------------------



### MAD:skmeans**






The object with results only for a single top-value method and a single partitioning method 
can be extracted as:

``` r
res = res_list["MAD", "skmeans"]
# you can also extract it by
# res = res_list["MAD:skmeans"]
```

A summary of `res` and all the functions that can be applied to it:

``` r
res
```

```
#> A 'ConsensusPartition' object with k = 2, 3, 4, 5, 6.
#>   On a matrix with 1900 rows and 60 columns.
#>   Top rows (190) are extracted by 'MAD' method.
#>   Subgroups are detected by 'skmeans' method.
#>   Performed in total 250 partitions by row resampling.
#>   Best k for subgroups seems to be 3.
#> 
#> Following methods can be applied to this 'ConsensusPartition' object:
#>  [1] "cola_report"             "collect_classes"         "collect_plots"          
#>  [4] "collect_stats"           "colnames"                "compare_partitions"     
#>  [7] "compare_signatures"      "consensus_heatmap"       "dimension_reduction"    
#> [10] "functional_enrichment"   "get_anno_col"            "get_anno"               
#> [13] "get_classes"             "get_consensus"           "get_matrix"             
#> [16] "get_membership"          "get_param"               "get_signatures"         
#> [19] "get_stats"               "is_best_k"               "is_stable_k"            
#> [22] "membership_heatmap"      "ncol"                    "nrow"                   
#> [25] "plot_ecdf"               "predict_classes"         "rownames"               
#> [28] "select_partition_number" "show"                    "suggest_best_k"         
#> [31] "test_to_known_factors"   "top_rows_heatmap"
```

`collect_plots()` function collects all the plots made from `res` for all `k` (number of subgroups)
into one single page to provide an easy and fast comparison between different `k`.

``` r
collect_plots(res)
```

![plot of chunk MAD-skmeans-collect-plots](figure_cola/MAD-skmeans-collect-plots-1.png)

The plots are:

- The first row: a plot of the eCDF (empirical cumulative distribution
  function) curves of the consensus matrix for each `k` and the heatmap of
  predicted classes for each `k`.
- The second row: heatmaps of the consensus matrix for each `k`.
- The third row: heatmaps of the membership matrix for each `k`.
- The fouth row: heatmaps of the signatures for each `k`.

All the plots in panels can be made by individual functions and they are
plotted later in this section.

`select_partition_number()` produces several plots showing different
statistics for choosing "optimized" `k`. There are following statistics:

- eCDF curves of the consensus matrix for each `k`;
- 1-PAC. [The PAC score](https://en.wikipedia.org/wiki/Consensus_clustering#Over-interpretation_potential_of_consensus_clustering)
  measures the proportion of the ambiguous subgrouping.
- Mean silhouette score.
- Concordance. The mean probability of fiting the consensus subgroup labels in all
  partitions.
- Area increased. Denote $A_k$ as the area under the eCDF curve for current
  `k`, the area increased is defined as $A_k - A_{k-1}$.
- Rand index. The percent of pairs of samples that are both in a same cluster
  or both are not in a same cluster in the partition of k and k-1.
- Jaccard index. The ratio of pairs of samples are both in a same cluster in
  the partition of k and k-1 and the pairs of samples are both in a same
  cluster in the partition k or k-1.

The detailed explanations of these statistics can be found in [the _cola_
vignette](https://jokergoo.github.io/cola_vignettes/cola.html#toc_13).

Generally speaking, higher 1-PAC score, higher mean silhouette score or higher
concordance corresponds to better partition. Rand index and Jaccard index
measure how similar the current partition is compared to partition with `k-1`.
If they are too similar, we won't accept `k` is better than `k-1`.

``` r
select_partition_number(res)
```

![plot of chunk MAD-skmeans-select-partition-number](figure_cola/MAD-skmeans-select-partition-number-1.png)

The numeric values for all these statistics can be obtained by `get_stats()`.

``` r
get_stats(res)
```

```
#>   k 1-PAC mean_silhouette concordance area_increased  Rand Jaccard
#> 2 2 0.999           0.959       0.983         0.5057 0.494   0.494
#> 3 3 0.953           0.940       0.975         0.3183 0.796   0.607
#> 4 4 0.675           0.706       0.839         0.1083 0.950   0.853
#> 5 5 0.615           0.510       0.748         0.0682 0.931   0.769
#> 6 6 0.607           0.409       0.592         0.0441 0.964   0.855
```

`suggest_best_k()` suggests the best $k$ based on these statistics. The rules are as follows:

- All $k$ with Jaccard index larger than 0.95 are removed because increasing
  $k$ does not provide enough extra information. If all $k$ are removed, it is
  marked as no subgroup is detected.
- For all $k$ with 1-PAC score larger than 0.9, the maximal $k$ is taken as
  the best $k$, and other $k$ are marked as optional $k$.
- If it does not fit the second rule. The $k$ with the maximal vote of the
  highest 1-PAC score, highest mean silhouette, and highest concordance is
  taken as the best $k$.

``` r
suggest_best_k(res)
```

```
#> [1] 3
#> attr(,"optional")
#> [1] 2
```

There is also optional best $k$ = 2 that is worth to check.

Following is the table of the partitions (You need to click the **show/hide
code output** link to see it). The membership matrix (columns with name `p*`)
is inferred by
[`clue::cl_consensus()`](https://www.rdocumentation.org/link/cl_consensus?package=clue)
function with the `SE` method. Basically the value in the membership matrix
represents the probability to belong to a certain group. The finall subgroup
label for an item is determined with the group with highest probability it
belongs to.

In `get_classes()` function, the entropy is calculated from the membership
matrix and the silhouette score is calculated from the consensus matrix.



<script>
$( function() {
	$( '#tabs-MAD-skmeans-get-classes' ).tabs();
} );
</script>
<div id='tabs-MAD-skmeans-get-classes'>
<ul>
<li><a href='#tab-MAD-skmeans-get-classes-1'>k = 2</a></li>
<li><a href='#tab-MAD-skmeans-get-classes-2'>k = 3</a></li>
<li><a href='#tab-MAD-skmeans-get-classes-3'>k = 4</a></li>
<li><a href='#tab-MAD-skmeans-get-classes-4'>k = 5</a></li>
<li><a href='#tab-MAD-skmeans-get-classes-5'>k = 6</a></li>
</ul>

<div id='tab-MAD-skmeans-get-classes-1'>
<p><a id='tab-MAD-skmeans-get-classes-1-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 2), get_membership(res, k = 2))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2
#&gt; SIH013     2   0.855      0.603 0.28 0.72
#&gt; SIH014     2   0.000      0.988 0.00 1.00
#&gt; SIH024     2   0.000      0.988 0.00 1.00
#&gt; SIH028     2   0.000      0.988 0.00 1.00
#&gt; SIH031     1   0.000      0.975 1.00 0.00
#&gt; SIH042     1   0.000      0.975 1.00 0.00
#&gt; SIH107     2   0.000      0.988 0.00 1.00
#&gt; SIH114     1   0.000      0.975 1.00 0.00
#&gt; SIH116     1   0.000      0.975 1.00 0.00
#&gt; SIH117     2   0.000      0.988 0.00 1.00
#&gt; SIH130     2   0.000      0.988 0.00 1.00
#&gt; SIH134     2   0.000      0.988 0.00 1.00
#&gt; SIH186     2   0.000      0.988 0.00 1.00
#&gt; SIH191     1   0.000      0.975 1.00 0.00
#&gt; SIH192     2   0.000      0.988 0.00 1.00
#&gt; SIH196     2   0.000      0.988 0.00 1.00
#&gt; SIH214     2   0.000      0.988 0.00 1.00
#&gt; SIH218     1   0.760      0.712 0.78 0.22
#&gt; SIH232     1   0.000      0.975 1.00 0.00
#&gt; SIH236     1   0.000      0.975 1.00 0.00
#&gt; SIH238     1   0.000      0.975 1.00 0.00
#&gt; SIH241     2   0.000      0.988 0.00 1.00
#&gt; SIH245     2   0.000      0.988 0.00 1.00
#&gt; SIH260     1   0.000      0.975 1.00 0.00
#&gt; SIH287     2   0.000      0.988 0.00 1.00
#&gt; SIH289     1   0.000      0.975 1.00 0.00
#&gt; SIH290     2   0.000      0.988 0.00 1.00
#&gt; SIH295     1   0.000      0.975 1.00 0.00
#&gt; SIH366     1   0.000      0.975 1.00 0.00
#&gt; SIH377     1   0.000      0.975 1.00 0.00
#&gt; SIH380     2   0.000      0.988 0.00 1.00
#&gt; SIH385     2   0.000      0.988 0.00 1.00
#&gt; SIH389     2   0.000      0.988 0.00 1.00
#&gt; SIH391     2   0.242      0.951 0.04 0.96
#&gt; SIH403     1   0.000      0.975 1.00 0.00
#&gt; SIH411     2   0.000      0.988 0.00 1.00
#&gt; SIH427     1   0.000      0.975 1.00 0.00
#&gt; SIH433     2   0.000      0.988 0.00 1.00
#&gt; SIH439     2   0.141      0.971 0.02 0.98
#&gt; SIH442     1   0.000      0.975 1.00 0.00
#&gt; SIH444     1   0.327      0.919 0.94 0.06
#&gt; SIH452     2   0.141      0.971 0.02 0.98
#&gt; SIH461     2   0.000      0.988 0.00 1.00
#&gt; SIH471     1   0.000      0.975 1.00 0.00
#&gt; SIH472     2   0.000      0.988 0.00 1.00
#&gt; SIH481     1   0.000      0.975 1.00 0.00
#&gt; SIH485     2   0.000      0.988 0.00 1.00
#&gt; SIH491     2   0.000      0.988 0.00 1.00
#&gt; SIH508     1   0.000      0.975 1.00 0.00
#&gt; SIH559     1   0.000      0.975 1.00 0.00
#&gt; SIH587     1   0.000      0.975 1.00 0.00
#&gt; SIH625     1   0.958      0.391 0.62 0.38
#&gt; SIH641     1   0.000      0.975 1.00 0.00
#&gt; SIH643     2   0.000      0.988 0.00 1.00
#&gt; SIH674     1   0.000      0.975 1.00 0.00
#&gt; SIH678     1   0.000      0.975 1.00 0.00
#&gt; SIH679     1   0.000      0.975 1.00 0.00
#&gt; SIH689     2   0.000      0.988 0.00 1.00
#&gt; SIH694     2   0.000      0.988 0.00 1.00
#&gt; SIH721     2   0.000      0.988 0.00 1.00
</code></pre>

<script>
$('#tab-MAD-skmeans-get-classes-1-a').parent().next().next().hide();
$('#tab-MAD-skmeans-get-classes-1-a').click(function(){
  $('#tab-MAD-skmeans-get-classes-1-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-MAD-skmeans-get-classes-2'>
<p><a id='tab-MAD-skmeans-get-classes-2-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 3), get_membership(res, k = 3))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3
#&gt; SIH013     3   0.000     0.9770 0.00 0.00 1.00
#&gt; SIH014     3   0.000     0.9770 0.00 0.00 1.00
#&gt; SIH024     3   0.000     0.9770 0.00 0.00 1.00
#&gt; SIH028     2   0.000     1.0000 0.00 1.00 0.00
#&gt; SIH031     1   0.000     0.9546 1.00 0.00 0.00
#&gt; SIH042     1   0.000     0.9546 1.00 0.00 0.00
#&gt; SIH107     2   0.000     1.0000 0.00 1.00 0.00
#&gt; SIH114     1   0.000     0.9546 1.00 0.00 0.00
#&gt; SIH116     1   0.369     0.8205 0.86 0.14 0.00
#&gt; SIH117     3   0.000     0.9770 0.00 0.00 1.00
#&gt; SIH130     3   0.000     0.9770 0.00 0.00 1.00
#&gt; SIH134     3   0.153     0.9500 0.00 0.04 0.96
#&gt; SIH186     2   0.000     1.0000 0.00 1.00 0.00
#&gt; SIH191     1   0.000     0.9546 1.00 0.00 0.00
#&gt; SIH192     2   0.000     1.0000 0.00 1.00 0.00
#&gt; SIH196     3   0.000     0.9770 0.00 0.00 1.00
#&gt; SIH214     3   0.369     0.8416 0.00 0.14 0.86
#&gt; SIH218     3   0.369     0.8319 0.14 0.00 0.86
#&gt; SIH232     1   0.000     0.9546 1.00 0.00 0.00
#&gt; SIH236     1   0.000     0.9546 1.00 0.00 0.00
#&gt; SIH238     1   0.254     0.8806 0.92 0.00 0.08
#&gt; SIH241     2   0.000     1.0000 0.00 1.00 0.00
#&gt; SIH245     3   0.000     0.9770 0.00 0.00 1.00
#&gt; SIH260     1   0.595     0.4593 0.64 0.36 0.00
#&gt; SIH287     2   0.000     1.0000 0.00 1.00 0.00
#&gt; SIH289     2   0.000     1.0000 0.00 1.00 0.00
#&gt; SIH290     3   0.254     0.9137 0.00 0.08 0.92
#&gt; SIH295     1   0.000     0.9546 1.00 0.00 0.00
#&gt; SIH366     1   0.000     0.9546 1.00 0.00 0.00
#&gt; SIH377     1   0.000     0.9546 1.00 0.00 0.00
#&gt; SIH380     3   0.000     0.9770 0.00 0.00 1.00
#&gt; SIH385     3   0.000     0.9770 0.00 0.00 1.00
#&gt; SIH389     2   0.000     1.0000 0.00 1.00 0.00
#&gt; SIH391     2   0.000     1.0000 0.00 1.00 0.00
#&gt; SIH403     1   0.000     0.9546 1.00 0.00 0.00
#&gt; SIH411     3   0.153     0.9511 0.00 0.04 0.96
#&gt; SIH427     1   0.000     0.9546 1.00 0.00 0.00
#&gt; SIH433     3   0.000     0.9770 0.00 0.00 1.00
#&gt; SIH439     2   0.000     1.0000 0.00 1.00 0.00
#&gt; SIH442     1   0.000     0.9546 1.00 0.00 0.00
#&gt; SIH444     1   0.630     0.0934 0.52 0.48 0.00
#&gt; SIH452     2   0.000     1.0000 0.00 1.00 0.00
#&gt; SIH461     3   0.000     0.9770 0.00 0.00 1.00
#&gt; SIH471     1   0.000     0.9546 1.00 0.00 0.00
#&gt; SIH472     2   0.000     1.0000 0.00 1.00 0.00
#&gt; SIH481     1   0.000     0.9546 1.00 0.00 0.00
#&gt; SIH485     3   0.000     0.9770 0.00 0.00 1.00
#&gt; SIH491     2   0.000     1.0000 0.00 1.00 0.00
#&gt; SIH508     1   0.000     0.9546 1.00 0.00 0.00
#&gt; SIH559     1   0.000     0.9546 1.00 0.00 0.00
#&gt; SIH587     1   0.000     0.9546 1.00 0.00 0.00
#&gt; SIH625     2   0.000     1.0000 0.00 1.00 0.00
#&gt; SIH641     1   0.000     0.9546 1.00 0.00 0.00
#&gt; SIH643     3   0.000     0.9770 0.00 0.00 1.00
#&gt; SIH674     1   0.000     0.9546 1.00 0.00 0.00
#&gt; SIH678     1   0.000     0.9546 1.00 0.00 0.00
#&gt; SIH679     1   0.000     0.9546 1.00 0.00 0.00
#&gt; SIH689     3   0.000     0.9770 0.00 0.00 1.00
#&gt; SIH694     3   0.000     0.9770 0.00 0.00 1.00
#&gt; SIH721     3   0.000     0.9770 0.00 0.00 1.00
</code></pre>

<script>
$('#tab-MAD-skmeans-get-classes-2-a').parent().next().next().hide();
$('#tab-MAD-skmeans-get-classes-2-a').click(function(){
  $('#tab-MAD-skmeans-get-classes-2-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-MAD-skmeans-get-classes-3'>
<p><a id='tab-MAD-skmeans-get-classes-3-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 4), get_membership(res, k = 4))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3   p4
#&gt; SIH013     3  0.4907     0.5530 0.00 0.00 0.58 0.42
#&gt; SIH014     3  0.3801     0.7869 0.00 0.00 0.78 0.22
#&gt; SIH024     3  0.4522     0.7130 0.00 0.00 0.68 0.32
#&gt; SIH028     2  0.3198     0.8551 0.00 0.88 0.04 0.08
#&gt; SIH031     1  0.3801     0.6331 0.78 0.00 0.00 0.22
#&gt; SIH042     1  0.4406     0.4886 0.70 0.00 0.00 0.30
#&gt; SIH107     2  0.0707     0.9182 0.00 0.98 0.00 0.02
#&gt; SIH114     1  0.4522     0.5163 0.68 0.00 0.00 0.32
#&gt; SIH116     4  0.7220     0.0192 0.42 0.14 0.00 0.44
#&gt; SIH117     3  0.3037     0.8081 0.00 0.02 0.88 0.10
#&gt; SIH130     3  0.0707     0.8317 0.00 0.00 0.98 0.02
#&gt; SIH134     3  0.3611     0.7723 0.00 0.08 0.86 0.06
#&gt; SIH186     2  0.0000     0.9188 0.00 1.00 0.00 0.00
#&gt; SIH191     1  0.0000     0.7649 1.00 0.00 0.00 0.00
#&gt; SIH192     2  0.1637     0.9075 0.00 0.94 0.00 0.06
#&gt; SIH196     3  0.2830     0.7957 0.00 0.04 0.90 0.06
#&gt; SIH214     3  0.6594     0.6616 0.00 0.14 0.62 0.24
#&gt; SIH218     4  0.4277     0.0235 0.00 0.00 0.28 0.72
#&gt; SIH232     1  0.0707     0.7633 0.98 0.00 0.00 0.02
#&gt; SIH236     1  0.4855     0.3829 0.60 0.00 0.00 0.40
#&gt; SIH238     4  0.5062     0.2904 0.30 0.00 0.02 0.68
#&gt; SIH241     2  0.3821     0.8032 0.00 0.84 0.12 0.04
#&gt; SIH245     3  0.3611     0.7718 0.00 0.08 0.86 0.06
#&gt; SIH260     4  0.7684     0.2237 0.36 0.22 0.00 0.42
#&gt; SIH287     2  0.1211     0.9143 0.00 0.96 0.00 0.04
#&gt; SIH289     2  0.2647     0.8760 0.00 0.88 0.00 0.12
#&gt; SIH290     3  0.4227     0.7353 0.00 0.12 0.82 0.06
#&gt; SIH295     1  0.0707     0.7625 0.98 0.00 0.00 0.02
#&gt; SIH366     1  0.1211     0.7568 0.96 0.00 0.00 0.04
#&gt; SIH377     1  0.2011     0.7457 0.92 0.00 0.00 0.08
#&gt; SIH380     3  0.2647     0.8258 0.00 0.00 0.88 0.12
#&gt; SIH385     3  0.1637     0.8333 0.00 0.00 0.94 0.06
#&gt; SIH389     2  0.4491     0.7504 0.00 0.80 0.14 0.06
#&gt; SIH391     2  0.2345     0.8913 0.00 0.90 0.00 0.10
#&gt; SIH403     1  0.4713     0.4514 0.64 0.00 0.00 0.36
#&gt; SIH411     3  0.4731     0.8071 0.00 0.06 0.78 0.16
#&gt; SIH427     1  0.2011     0.7559 0.92 0.00 0.00 0.08
#&gt; SIH433     3  0.3610     0.8076 0.00 0.00 0.80 0.20
#&gt; SIH439     2  0.0707     0.9181 0.00 0.98 0.00 0.02
#&gt; SIH442     1  0.0000     0.7649 1.00 0.00 0.00 0.00
#&gt; SIH444     1  0.7550    -0.1730 0.48 0.30 0.00 0.22
#&gt; SIH452     2  0.1211     0.9143 0.00 0.96 0.00 0.04
#&gt; SIH461     3  0.4406     0.7318 0.00 0.00 0.70 0.30
#&gt; SIH471     1  0.3172     0.7222 0.84 0.00 0.00 0.16
#&gt; SIH472     2  0.0707     0.9143 0.00 0.98 0.00 0.02
#&gt; SIH481     1  0.0707     0.7629 0.98 0.00 0.00 0.02
#&gt; SIH485     3  0.0707     0.8334 0.00 0.00 0.98 0.02
#&gt; SIH491     2  0.0000     0.9188 0.00 1.00 0.00 0.00
#&gt; SIH508     1  0.2345     0.7429 0.90 0.00 0.00 0.10
#&gt; SIH559     1  0.2921     0.7241 0.86 0.00 0.00 0.14
#&gt; SIH587     1  0.2647     0.7358 0.88 0.00 0.00 0.12
#&gt; SIH625     2  0.2345     0.8883 0.00 0.90 0.00 0.10
#&gt; SIH641     1  0.1211     0.7640 0.96 0.00 0.00 0.04
#&gt; SIH643     3  0.2921     0.8285 0.00 0.00 0.86 0.14
#&gt; SIH674     1  0.0000     0.7649 1.00 0.00 0.00 0.00
#&gt; SIH678     1  0.4277     0.5788 0.72 0.00 0.00 0.28
#&gt; SIH679     1  0.4713     0.4348 0.64 0.00 0.00 0.36
#&gt; SIH689     3  0.1211     0.8305 0.00 0.00 0.96 0.04
#&gt; SIH694     3  0.1913     0.8281 0.00 0.02 0.94 0.04
#&gt; SIH721     3  0.3801     0.7849 0.00 0.00 0.78 0.22
</code></pre>

<script>
$('#tab-MAD-skmeans-get-classes-3-a').parent().next().next().hide();
$('#tab-MAD-skmeans-get-classes-3-a').click(function(){
  $('#tab-MAD-skmeans-get-classes-3-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-MAD-skmeans-get-classes-4'>
<p><a id='tab-MAD-skmeans-get-classes-4-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 5), get_membership(res, k = 5))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3   p4   p5
#&gt; SIH013     3  0.3319     0.4875 0.00 0.16 0.82 0.00 0.02
#&gt; SIH014     3  0.5695    -0.0446 0.00 0.46 0.48 0.04 0.02
#&gt; SIH024     3  0.3796     0.4157 0.00 0.30 0.70 0.00 0.00
#&gt; SIH028     4  0.5192     0.7103 0.00 0.14 0.06 0.74 0.06
#&gt; SIH031     1  0.5068     0.4146 0.64 0.00 0.06 0.00 0.30
#&gt; SIH042     1  0.6047    -0.0888 0.48 0.00 0.12 0.00 0.40
#&gt; SIH107     4  0.0000     0.7981 0.00 0.00 0.00 1.00 0.00
#&gt; SIH114     1  0.5394     0.2782 0.54 0.00 0.06 0.00 0.40
#&gt; SIH116     5  0.6727     0.3720 0.32 0.00 0.02 0.16 0.50
#&gt; SIH117     2  0.4876     0.5148 0.00 0.70 0.22 0.00 0.08
#&gt; SIH130     2  0.1410     0.6779 0.00 0.94 0.06 0.00 0.00
#&gt; SIH134     2  0.2249     0.6620 0.00 0.92 0.04 0.02 0.02
#&gt; SIH186     4  0.0609     0.7994 0.00 0.00 0.02 0.98 0.00
#&gt; SIH191     1  0.0609     0.6509 0.98 0.00 0.00 0.00 0.02
#&gt; SIH192     4  0.3922     0.7580 0.00 0.00 0.04 0.78 0.18
#&gt; SIH196     2  0.1648     0.6765 0.00 0.94 0.04 0.00 0.02
#&gt; SIH214     3  0.6778     0.0891 0.00 0.34 0.38 0.28 0.00
#&gt; SIH218     3  0.6329     0.3380 0.02 0.12 0.56 0.00 0.30
#&gt; SIH232     1  0.1043     0.6512 0.96 0.00 0.00 0.00 0.04
#&gt; SIH236     5  0.5232     0.3390 0.34 0.00 0.06 0.00 0.60
#&gt; SIH238     3  0.6009     0.0260 0.24 0.00 0.58 0.00 0.18
#&gt; SIH241     4  0.5005     0.6224 0.00 0.20 0.02 0.72 0.06
#&gt; SIH245     2  0.1820     0.6767 0.00 0.94 0.02 0.02 0.02
#&gt; SIH260     5  0.7627     0.3838 0.22 0.00 0.06 0.30 0.42
#&gt; SIH287     4  0.1043     0.7924 0.00 0.00 0.00 0.96 0.04
#&gt; SIH289     4  0.4825     0.6558 0.02 0.00 0.04 0.72 0.22
#&gt; SIH290     2  0.3099     0.6490 0.00 0.88 0.04 0.04 0.04
#&gt; SIH295     1  0.0000     0.6476 1.00 0.00 0.00 0.00 0.00
#&gt; SIH366     1  0.3319     0.5330 0.82 0.00 0.02 0.00 0.16
#&gt; SIH377     1  0.3561     0.5473 0.74 0.00 0.00 0.00 0.26
#&gt; SIH380     2  0.3561     0.5404 0.00 0.74 0.26 0.00 0.00
#&gt; SIH385     2  0.4252     0.5085 0.00 0.70 0.28 0.00 0.02
#&gt; SIH389     4  0.5293     0.5998 0.00 0.24 0.02 0.68 0.06
#&gt; SIH391     4  0.4500     0.7404 0.00 0.02 0.04 0.76 0.18
#&gt; SIH403     1  0.5425     0.2761 0.52 0.00 0.06 0.00 0.42
#&gt; SIH411     2  0.5440     0.4724 0.00 0.70 0.16 0.12 0.02
#&gt; SIH427     1  0.2616     0.5883 0.88 0.00 0.02 0.00 0.10
#&gt; SIH433     2  0.6778     0.1775 0.00 0.48 0.38 0.06 0.08
#&gt; SIH439     4  0.4725     0.7181 0.00 0.00 0.08 0.72 0.20
#&gt; SIH442     1  0.1043     0.6512 0.96 0.00 0.00 0.00 0.04
#&gt; SIH444     1  0.8511    -0.2929 0.36 0.04 0.14 0.10 0.36
#&gt; SIH452     4  0.0609     0.7972 0.00 0.00 0.00 0.98 0.02
#&gt; SIH461     3  0.3561     0.4513 0.00 0.26 0.74 0.00 0.00
#&gt; SIH471     1  0.3852     0.5134 0.76 0.00 0.02 0.00 0.22
#&gt; SIH472     4  0.3700     0.7907 0.00 0.06 0.02 0.84 0.08
#&gt; SIH481     1  0.0609     0.6439 0.98 0.00 0.00 0.00 0.02
#&gt; SIH485     2  0.3106     0.6552 0.00 0.84 0.14 0.00 0.02
#&gt; SIH491     4  0.1648     0.7937 0.00 0.02 0.00 0.94 0.04
#&gt; SIH508     1  0.3390     0.5645 0.84 0.00 0.06 0.00 0.10
#&gt; SIH559     1  0.3852     0.5460 0.76 0.00 0.02 0.00 0.22
#&gt; SIH587     1  0.3109     0.5809 0.80 0.00 0.00 0.00 0.20
#&gt; SIH625     4  0.4254     0.6888 0.00 0.00 0.04 0.74 0.22
#&gt; SIH641     1  0.1043     0.6426 0.96 0.00 0.00 0.00 0.04
#&gt; SIH643     2  0.3561     0.5326 0.00 0.74 0.26 0.00 0.00
#&gt; SIH674     1  0.0609     0.6500 0.98 0.00 0.00 0.00 0.02
#&gt; SIH678     1  0.5498     0.3427 0.58 0.00 0.08 0.00 0.34
#&gt; SIH679     1  0.5267     0.1529 0.56 0.00 0.02 0.02 0.40
#&gt; SIH689     2  0.4840     0.4152 0.00 0.64 0.32 0.00 0.04
#&gt; SIH694     2  0.4718     0.5883 0.00 0.76 0.16 0.04 0.04
#&gt; SIH721     3  0.4990     0.2297 0.00 0.36 0.60 0.00 0.04
</code></pre>

<script>
$('#tab-MAD-skmeans-get-classes-4-a').parent().next().next().hide();
$('#tab-MAD-skmeans-get-classes-4-a').click(function(){
  $('#tab-MAD-skmeans-get-classes-4-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-MAD-skmeans-get-classes-5'>
<p><a id='tab-MAD-skmeans-get-classes-5-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 6), get_membership(res, k = 6))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3   p4   p5   p6
#&gt; SIH013     3  0.5529    0.44378 0.06 0.16 0.66 0.00 0.00 0.12
#&gt; SIH014     3  0.4503    0.34060 0.00 0.24 0.68 0.00 0.00 0.08
#&gt; SIH024     3  0.3483    0.48315 0.02 0.12 0.82 0.00 0.00 0.04
#&gt; SIH028     4  0.6906    0.60301 0.14 0.14 0.06 0.58 0.00 0.08
#&gt; SIH031     5  0.6831    0.02396 0.20 0.00 0.06 0.00 0.40 0.34
#&gt; SIH042     5  0.7124    0.00571 0.26 0.00 0.08 0.00 0.38 0.28
#&gt; SIH107     4  0.0937    0.72161 0.04 0.00 0.00 0.96 0.00 0.00
#&gt; SIH114     5  0.5922    0.10824 0.34 0.00 0.00 0.00 0.44 0.22
#&gt; SIH116     1  0.6516    0.35696 0.52 0.00 0.00 0.08 0.26 0.14
#&gt; SIH117     2  0.3660    0.53880 0.00 0.78 0.16 0.00 0.00 0.06
#&gt; SIH130     2  0.2260    0.60786 0.00 0.86 0.14 0.00 0.00 0.00
#&gt; SIH134     2  0.2512    0.58255 0.00 0.88 0.06 0.06 0.00 0.00
#&gt; SIH186     4  0.3795    0.67418 0.06 0.00 0.02 0.80 0.00 0.12
#&gt; SIH191     5  0.4328    0.48781 0.18 0.00 0.00 0.00 0.72 0.10
#&gt; SIH192     4  0.5507    0.66313 0.18 0.06 0.02 0.68 0.00 0.06
#&gt; SIH196     2  0.2981    0.59797 0.00 0.82 0.16 0.00 0.00 0.02
#&gt; SIH214     3  0.6886    0.17518 0.00 0.18 0.48 0.24 0.00 0.10
#&gt; SIH218     3  0.6921    0.19647 0.12 0.12 0.42 0.00 0.00 0.34
#&gt; SIH232     5  0.2474    0.53248 0.08 0.00 0.00 0.00 0.88 0.04
#&gt; SIH236     1  0.5501    0.11955 0.54 0.00 0.02 0.02 0.38 0.04
#&gt; SIH238     3  0.6474    0.08357 0.10 0.00 0.54 0.00 0.12 0.24
#&gt; SIH241     4  0.5883    0.43077 0.00 0.18 0.02 0.56 0.00 0.24
#&gt; SIH245     2  0.1480    0.59808 0.00 0.94 0.04 0.02 0.00 0.00
#&gt; SIH260     1  0.6001    0.08810 0.68 0.02 0.04 0.14 0.04 0.08
#&gt; SIH287     4  0.2631    0.70279 0.18 0.00 0.00 0.82 0.00 0.00
#&gt; SIH289     4  0.5077    0.61662 0.26 0.00 0.02 0.66 0.02 0.04
#&gt; SIH290     2  0.3697    0.55491 0.00 0.82 0.06 0.08 0.00 0.04
#&gt; SIH295     5  0.0547    0.53636 0.02 0.00 0.00 0.00 0.98 0.00
#&gt; SIH366     5  0.5643    0.34903 0.16 0.00 0.00 0.02 0.60 0.22
#&gt; SIH377     5  0.4810    0.42478 0.22 0.00 0.00 0.00 0.66 0.12
#&gt; SIH380     2  0.3198    0.54301 0.00 0.74 0.26 0.00 0.00 0.00
#&gt; SIH385     3  0.4646   -0.23604 0.00 0.46 0.50 0.00 0.00 0.04
#&gt; SIH389     4  0.4958    0.63470 0.02 0.16 0.02 0.72 0.00 0.08
#&gt; SIH391     4  0.7326    0.51862 0.10 0.06 0.08 0.56 0.02 0.18
#&gt; SIH403     5  0.6441    0.09306 0.34 0.00 0.02 0.00 0.40 0.24
#&gt; SIH411     2  0.6774    0.16832 0.02 0.48 0.30 0.16 0.00 0.04
#&gt; SIH427     5  0.5227    0.37585 0.24 0.00 0.02 0.00 0.64 0.10
#&gt; SIH433     2  0.7107    0.03471 0.00 0.38 0.24 0.08 0.00 0.30
#&gt; SIH439     4  0.5896    0.65852 0.12 0.04 0.02 0.68 0.02 0.12
#&gt; SIH442     5  0.2512    0.54902 0.06 0.00 0.00 0.00 0.88 0.06
#&gt; SIH444     6  0.8333    0.00000 0.14 0.08 0.02 0.12 0.20 0.44
#&gt; SIH452     4  0.1556    0.71824 0.08 0.00 0.00 0.92 0.00 0.00
#&gt; SIH461     3  0.3163    0.47414 0.04 0.14 0.82 0.00 0.00 0.00
#&gt; SIH471     5  0.4631    0.40675 0.22 0.00 0.02 0.00 0.70 0.06
#&gt; SIH472     4  0.4097    0.70295 0.06 0.10 0.02 0.80 0.00 0.02
#&gt; SIH481     5  0.2190    0.52631 0.04 0.00 0.00 0.00 0.90 0.06
#&gt; SIH485     2  0.4172    0.53074 0.00 0.68 0.28 0.00 0.00 0.04
#&gt; SIH491     4  0.3156    0.65475 0.00 0.00 0.02 0.80 0.00 0.18
#&gt; SIH508     5  0.5572    0.38038 0.14 0.00 0.04 0.00 0.64 0.18
#&gt; SIH559     5  0.4834    0.33684 0.26 0.00 0.00 0.00 0.64 0.10
#&gt; SIH587     5  0.3156    0.46746 0.18 0.00 0.00 0.00 0.80 0.02
#&gt; SIH625     4  0.4830    0.64843 0.28 0.02 0.02 0.66 0.00 0.02
#&gt; SIH641     5  0.3746    0.43796 0.08 0.00 0.00 0.00 0.78 0.14
#&gt; SIH643     2  0.4731    0.27248 0.02 0.56 0.40 0.00 0.00 0.02
#&gt; SIH674     5  0.1480    0.53908 0.02 0.00 0.00 0.00 0.94 0.04
#&gt; SIH678     5  0.5520    0.26322 0.24 0.00 0.00 0.00 0.56 0.20
#&gt; SIH679     1  0.5896    0.10425 0.46 0.02 0.00 0.00 0.40 0.12
#&gt; SIH689     2  0.4613    0.46202 0.00 0.66 0.26 0.00 0.00 0.08
#&gt; SIH694     2  0.6145    0.42229 0.02 0.60 0.22 0.04 0.00 0.12
#&gt; SIH721     3  0.5267    0.22310 0.00 0.32 0.56 0.00 0.00 0.12
</code></pre>

<script>
$('#tab-MAD-skmeans-get-classes-5-a').parent().next().next().hide();
$('#tab-MAD-skmeans-get-classes-5-a').click(function(){
  $('#tab-MAD-skmeans-get-classes-5-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>
</div>

Heatmaps for the consensus matrix. It visualizes the probability of two
samples to be in a same group.




<script>
$( function() {
	$( '#tabs-MAD-skmeans-consensus-heatmap' ).tabs();
} );
</script>
<div id='tabs-MAD-skmeans-consensus-heatmap'>
<ul>
<li><a href='#tab-MAD-skmeans-consensus-heatmap-1'>k = 2</a></li>
<li><a href='#tab-MAD-skmeans-consensus-heatmap-2'>k = 3</a></li>
<li><a href='#tab-MAD-skmeans-consensus-heatmap-3'>k = 4</a></li>
<li><a href='#tab-MAD-skmeans-consensus-heatmap-4'>k = 5</a></li>
<li><a href='#tab-MAD-skmeans-consensus-heatmap-5'>k = 6</a></li>
</ul>
<div id='tab-MAD-skmeans-consensus-heatmap-1'>
<pre><code class="language-r">consensus_heatmap(res, k = 2)
</code></pre>
<p><img src="figure_cola/tab-MAD-skmeans-consensus-heatmap-1-1.png" alt="plot of chunk tab-MAD-skmeans-consensus-heatmap-1" /></p>

</div>
<div id='tab-MAD-skmeans-consensus-heatmap-2'>
<pre><code class="language-r">consensus_heatmap(res, k = 3)
</code></pre>
<p><img src="figure_cola/tab-MAD-skmeans-consensus-heatmap-2-1.png" alt="plot of chunk tab-MAD-skmeans-consensus-heatmap-2" /></p>

</div>
<div id='tab-MAD-skmeans-consensus-heatmap-3'>
<pre><code class="language-r">consensus_heatmap(res, k = 4)
</code></pre>
<p><img src="figure_cola/tab-MAD-skmeans-consensus-heatmap-3-1.png" alt="plot of chunk tab-MAD-skmeans-consensus-heatmap-3" /></p>

</div>
<div id='tab-MAD-skmeans-consensus-heatmap-4'>
<pre><code class="language-r">consensus_heatmap(res, k = 5)
</code></pre>
<p><img src="figure_cola/tab-MAD-skmeans-consensus-heatmap-4-1.png" alt="plot of chunk tab-MAD-skmeans-consensus-heatmap-4" /></p>

</div>
<div id='tab-MAD-skmeans-consensus-heatmap-5'>
<pre><code class="language-r">consensus_heatmap(res, k = 6)
</code></pre>
<p><img src="figure_cola/tab-MAD-skmeans-consensus-heatmap-5-1.png" alt="plot of chunk tab-MAD-skmeans-consensus-heatmap-5" /></p>

</div>
</div>

Heatmaps for the membership of samples in all partitions to see how consistent they are:





<script>
$( function() {
	$( '#tabs-MAD-skmeans-membership-heatmap' ).tabs();
} );
</script>
<div id='tabs-MAD-skmeans-membership-heatmap'>
<ul>
<li><a href='#tab-MAD-skmeans-membership-heatmap-1'>k = 2</a></li>
<li><a href='#tab-MAD-skmeans-membership-heatmap-2'>k = 3</a></li>
<li><a href='#tab-MAD-skmeans-membership-heatmap-3'>k = 4</a></li>
<li><a href='#tab-MAD-skmeans-membership-heatmap-4'>k = 5</a></li>
<li><a href='#tab-MAD-skmeans-membership-heatmap-5'>k = 6</a></li>
</ul>
<div id='tab-MAD-skmeans-membership-heatmap-1'>
<pre><code class="language-r">membership_heatmap(res, k = 2)
</code></pre>
<p><img src="figure_cola/tab-MAD-skmeans-membership-heatmap-1-1.png" alt="plot of chunk tab-MAD-skmeans-membership-heatmap-1" /></p>

</div>
<div id='tab-MAD-skmeans-membership-heatmap-2'>
<pre><code class="language-r">membership_heatmap(res, k = 3)
</code></pre>
<p><img src="figure_cola/tab-MAD-skmeans-membership-heatmap-2-1.png" alt="plot of chunk tab-MAD-skmeans-membership-heatmap-2" /></p>

</div>
<div id='tab-MAD-skmeans-membership-heatmap-3'>
<pre><code class="language-r">membership_heatmap(res, k = 4)
</code></pre>
<p><img src="figure_cola/tab-MAD-skmeans-membership-heatmap-3-1.png" alt="plot of chunk tab-MAD-skmeans-membership-heatmap-3" /></p>

</div>
<div id='tab-MAD-skmeans-membership-heatmap-4'>
<pre><code class="language-r">membership_heatmap(res, k = 5)
</code></pre>
<p><img src="figure_cola/tab-MAD-skmeans-membership-heatmap-4-1.png" alt="plot of chunk tab-MAD-skmeans-membership-heatmap-4" /></p>

</div>
<div id='tab-MAD-skmeans-membership-heatmap-5'>
<pre><code class="language-r">membership_heatmap(res, k = 6)
</code></pre>
<p><img src="figure_cola/tab-MAD-skmeans-membership-heatmap-5-1.png" alt="plot of chunk tab-MAD-skmeans-membership-heatmap-5" /></p>

</div>
</div>

As soon as the classes for columns are determined, the signatures
that are significantly different between subgroups can be looked for. 
Following are the heatmaps for signatures.




Signature heatmaps where rows are scaled:



<script>
$( function() {
	$( '#tabs-MAD-skmeans-get-signatures' ).tabs();
} );
</script>
<div id='tabs-MAD-skmeans-get-signatures'>
<ul>
<li><a href='#tab-MAD-skmeans-get-signatures-1'>k = 2</a></li>
<li><a href='#tab-MAD-skmeans-get-signatures-2'>k = 3</a></li>
<li><a href='#tab-MAD-skmeans-get-signatures-3'>k = 4</a></li>
<li><a href='#tab-MAD-skmeans-get-signatures-4'>k = 5</a></li>
<li><a href='#tab-MAD-skmeans-get-signatures-5'>k = 6</a></li>
</ul>
<div id='tab-MAD-skmeans-get-signatures-1'>
<pre><code class="language-r">get_signatures(res, k = 2)
</code></pre>
<p><img src="figure_cola/tab-MAD-skmeans-get-signatures-1-1.png" alt="plot of chunk tab-MAD-skmeans-get-signatures-1" /></p>

</div>
<div id='tab-MAD-skmeans-get-signatures-2'>
<pre><code class="language-r">get_signatures(res, k = 3)
</code></pre>
<p><img src="figure_cola/tab-MAD-skmeans-get-signatures-2-1.png" alt="plot of chunk tab-MAD-skmeans-get-signatures-2" /></p>

</div>
<div id='tab-MAD-skmeans-get-signatures-3'>
<pre><code class="language-r">get_signatures(res, k = 4)
</code></pre>
<p><img src="figure_cola/tab-MAD-skmeans-get-signatures-3-1.png" alt="plot of chunk tab-MAD-skmeans-get-signatures-3" /></p>

</div>
<div id='tab-MAD-skmeans-get-signatures-4'>
<pre><code class="language-r">get_signatures(res, k = 5)
</code></pre>
<p><img src="figure_cola/tab-MAD-skmeans-get-signatures-4-1.png" alt="plot of chunk tab-MAD-skmeans-get-signatures-4" /></p>

</div>
<div id='tab-MAD-skmeans-get-signatures-5'>
<pre><code class="language-r">get_signatures(res, k = 6)
</code></pre>
<p><img src="figure_cola/tab-MAD-skmeans-get-signatures-5-1.png" alt="plot of chunk tab-MAD-skmeans-get-signatures-5" /></p>

</div>
</div>



Signature heatmaps where rows are not scaled:


<script>
$( function() {
	$( '#tabs-MAD-skmeans-get-signatures-no-scale' ).tabs();
} );
</script>
<div id='tabs-MAD-skmeans-get-signatures-no-scale'>
<ul>
<li><a href='#tab-MAD-skmeans-get-signatures-no-scale-1'>k = 2</a></li>
<li><a href='#tab-MAD-skmeans-get-signatures-no-scale-2'>k = 3</a></li>
<li><a href='#tab-MAD-skmeans-get-signatures-no-scale-3'>k = 4</a></li>
<li><a href='#tab-MAD-skmeans-get-signatures-no-scale-4'>k = 5</a></li>
<li><a href='#tab-MAD-skmeans-get-signatures-no-scale-5'>k = 6</a></li>
</ul>
<div id='tab-MAD-skmeans-get-signatures-no-scale-1'>
<pre><code class="language-r">get_signatures(res, k = 2, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-MAD-skmeans-get-signatures-no-scale-1-1.png" alt="plot of chunk tab-MAD-skmeans-get-signatures-no-scale-1" /></p>

</div>
<div id='tab-MAD-skmeans-get-signatures-no-scale-2'>
<pre><code class="language-r">get_signatures(res, k = 3, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-MAD-skmeans-get-signatures-no-scale-2-1.png" alt="plot of chunk tab-MAD-skmeans-get-signatures-no-scale-2" /></p>

</div>
<div id='tab-MAD-skmeans-get-signatures-no-scale-3'>
<pre><code class="language-r">get_signatures(res, k = 4, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-MAD-skmeans-get-signatures-no-scale-3-1.png" alt="plot of chunk tab-MAD-skmeans-get-signatures-no-scale-3" /></p>

</div>
<div id='tab-MAD-skmeans-get-signatures-no-scale-4'>
<pre><code class="language-r">get_signatures(res, k = 5, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-MAD-skmeans-get-signatures-no-scale-4-1.png" alt="plot of chunk tab-MAD-skmeans-get-signatures-no-scale-4" /></p>

</div>
<div id='tab-MAD-skmeans-get-signatures-no-scale-5'>
<pre><code class="language-r">get_signatures(res, k = 6, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-MAD-skmeans-get-signatures-no-scale-5-1.png" alt="plot of chunk tab-MAD-skmeans-get-signatures-no-scale-5" /></p>

</div>
</div>



Compare the overlap of signatures from different k:

``` r
compare_signatures(res)
```

![plot of chunk MAD-skmeans-signature_compare](figure_cola/MAD-skmeans-signature_compare-1.png)

`get_signature()` returns a data frame invisibly. To get the list of signatures, the function
call should be assigned to a variable explicitly. In following code, if `plot` argument is set
to `FALSE`, no heatmap is plotted while only the differential analysis is performed.

``` r
# code only for demonstration
tb = get_signature(res, k = ..., plot = FALSE)
```

An example of the output of `tb` is:

```
#>   which_row         fdr    mean_1    mean_2 scaled_mean_1 scaled_mean_2 km
#> 1        38 0.042760348  8.373488  9.131774    -0.5533452     0.5164555  1
#> 2        40 0.018707592  7.106213  8.469186    -0.6173731     0.5762149  1
#> 3        55 0.019134737 10.221463 11.207825    -0.6159697     0.5749050  1
#> 4        59 0.006059896  5.921854  7.869574    -0.6899429     0.6439467  1
#> 5        60 0.018055526  8.928898 10.211722    -0.6204761     0.5791110  1
#> 6        98 0.009384629 15.714769 14.887706     0.6635654    -0.6193277  2
...
```

The columns in `tb` are:

1. `which_row`: row indices corresponding to the input matrix.
2. `fdr`: FDR for the differential test. 
3. `mean_x`: The mean value in group x.
4. `scaled_mean_x`: The mean value in group x after rows are scaled.
5. `km`: Row groups if k-means clustering is applied to rows (which is done by automatically selecting number of clusters).

If there are too many signatures, `top_signatures = ...` can be set to only show the 
signatures with the highest FDRs:

``` r
# code only for demonstration
# e.g. to show the top 500 most significant rows
tb = get_signature(res, k = ..., top_signatures = 500)
```

If the signatures are defined as these which are uniquely high in current group, `diff_method` argument
can be set to `"uniquely_high_in_one_group"`:

``` r
# code only for demonstration
tb = get_signature(res, k = ..., diff_method = "uniquely_high_in_one_group")
```




UMAP plot which shows how samples are separated.


<script>
$( function() {
	$( '#tabs-MAD-skmeans-dimension-reduction' ).tabs();
} );
</script>
<div id='tabs-MAD-skmeans-dimension-reduction'>
<ul>
<li><a href='#tab-MAD-skmeans-dimension-reduction-1'>k = 2</a></li>
<li><a href='#tab-MAD-skmeans-dimension-reduction-2'>k = 3</a></li>
<li><a href='#tab-MAD-skmeans-dimension-reduction-3'>k = 4</a></li>
<li><a href='#tab-MAD-skmeans-dimension-reduction-4'>k = 5</a></li>
<li><a href='#tab-MAD-skmeans-dimension-reduction-5'>k = 6</a></li>
</ul>
<div id='tab-MAD-skmeans-dimension-reduction-1'>
<pre><code class="language-r">dimension_reduction(res, k = 2, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-MAD-skmeans-dimension-reduction-1-1.png" alt="plot of chunk tab-MAD-skmeans-dimension-reduction-1" /></p>

</div>
<div id='tab-MAD-skmeans-dimension-reduction-2'>
<pre><code class="language-r">dimension_reduction(res, k = 3, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-MAD-skmeans-dimension-reduction-2-1.png" alt="plot of chunk tab-MAD-skmeans-dimension-reduction-2" /></p>

</div>
<div id='tab-MAD-skmeans-dimension-reduction-3'>
<pre><code class="language-r">dimension_reduction(res, k = 4, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-MAD-skmeans-dimension-reduction-3-1.png" alt="plot of chunk tab-MAD-skmeans-dimension-reduction-3" /></p>

</div>
<div id='tab-MAD-skmeans-dimension-reduction-4'>
<pre><code class="language-r">dimension_reduction(res, k = 5, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-MAD-skmeans-dimension-reduction-4-1.png" alt="plot of chunk tab-MAD-skmeans-dimension-reduction-4" /></p>

</div>
<div id='tab-MAD-skmeans-dimension-reduction-5'>
<pre><code class="language-r">dimension_reduction(res, k = 6, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-MAD-skmeans-dimension-reduction-5-1.png" alt="plot of chunk tab-MAD-skmeans-dimension-reduction-5" /></p>

</div>
</div>



Following heatmap shows how subgroups are split when increasing `k`:

``` r
collect_classes(res)
```

![plot of chunk MAD-skmeans-collect-classes](figure_cola/MAD-skmeans-collect-classes-1.png)



If matrix rows can be associated to genes, consider to use `functional_enrichment(res,
...)` to perform function enrichment for the signature genes. See [this vignette](https://jokergoo.github.io/cola_vignettes/functional_enrichment.html) for more detailed explanations.


 

---------------------------------------------------



### MAD:mclust**






The object with results only for a single top-value method and a single partitioning method 
can be extracted as:

``` r
res = res_list["MAD", "mclust"]
# you can also extract it by
# res = res_list["MAD:mclust"]
```

A summary of `res` and all the functions that can be applied to it:

``` r
res
```

```
#> A 'ConsensusPartition' object with k = 2, 3, 4, 5, 6.
#>   On a matrix with 1900 rows and 60 columns.
#>   Top rows (190) are extracted by 'MAD' method.
#>   Subgroups are detected by 'mclust' method.
#>   Performed in total 250 partitions by row resampling.
#>   Best k for subgroups seems to be 3.
#> 
#> Following methods can be applied to this 'ConsensusPartition' object:
#>  [1] "cola_report"             "collect_classes"         "collect_plots"          
#>  [4] "collect_stats"           "colnames"                "compare_partitions"     
#>  [7] "compare_signatures"      "consensus_heatmap"       "dimension_reduction"    
#> [10] "functional_enrichment"   "get_anno_col"            "get_anno"               
#> [13] "get_classes"             "get_consensus"           "get_matrix"             
#> [16] "get_membership"          "get_param"               "get_signatures"         
#> [19] "get_stats"               "is_best_k"               "is_stable_k"            
#> [22] "membership_heatmap"      "ncol"                    "nrow"                   
#> [25] "plot_ecdf"               "predict_classes"         "rownames"               
#> [28] "select_partition_number" "show"                    "suggest_best_k"         
#> [31] "test_to_known_factors"   "top_rows_heatmap"
```

`collect_plots()` function collects all the plots made from `res` for all `k` (number of subgroups)
into one single page to provide an easy and fast comparison between different `k`.

``` r
collect_plots(res)
```

![plot of chunk MAD-mclust-collect-plots](figure_cola/MAD-mclust-collect-plots-1.png)

The plots are:

- The first row: a plot of the eCDF (empirical cumulative distribution
  function) curves of the consensus matrix for each `k` and the heatmap of
  predicted classes for each `k`.
- The second row: heatmaps of the consensus matrix for each `k`.
- The third row: heatmaps of the membership matrix for each `k`.
- The fouth row: heatmaps of the signatures for each `k`.

All the plots in panels can be made by individual functions and they are
plotted later in this section.

`select_partition_number()` produces several plots showing different
statistics for choosing "optimized" `k`. There are following statistics:

- eCDF curves of the consensus matrix for each `k`;
- 1-PAC. [The PAC score](https://en.wikipedia.org/wiki/Consensus_clustering#Over-interpretation_potential_of_consensus_clustering)
  measures the proportion of the ambiguous subgrouping.
- Mean silhouette score.
- Concordance. The mean probability of fiting the consensus subgroup labels in all
  partitions.
- Area increased. Denote $A_k$ as the area under the eCDF curve for current
  `k`, the area increased is defined as $A_k - A_{k-1}$.
- Rand index. The percent of pairs of samples that are both in a same cluster
  or both are not in a same cluster in the partition of k and k-1.
- Jaccard index. The ratio of pairs of samples are both in a same cluster in
  the partition of k and k-1 and the pairs of samples are both in a same
  cluster in the partition k or k-1.

The detailed explanations of these statistics can be found in [the _cola_
vignette](https://jokergoo.github.io/cola_vignettes/cola.html#toc_13).

Generally speaking, higher 1-PAC score, higher mean silhouette score or higher
concordance corresponds to better partition. Rand index and Jaccard index
measure how similar the current partition is compared to partition with `k-1`.
If they are too similar, we won't accept `k` is better than `k-1`.

``` r
select_partition_number(res)
```

![plot of chunk MAD-mclust-select-partition-number](figure_cola/MAD-mclust-select-partition-number-1.png)

The numeric values for all these statistics can be obtained by `get_stats()`.

``` r
get_stats(res)
```

```
#>   k 1-PAC mean_silhouette concordance area_increased  Rand Jaccard
#> 2 2 0.659           0.925       0.940         0.4735 0.506   0.506
#> 3 3 1.000           0.951       0.981         0.3955 0.792   0.605
#> 4 4 0.737           0.701       0.775         0.1012 0.890   0.693
#> 5 5 0.651           0.581       0.810         0.0705 0.932   0.759
#> 6 6 0.680           0.652       0.789         0.0424 0.955   0.804
```

`suggest_best_k()` suggests the best $k$ based on these statistics. The rules are as follows:

- All $k$ with Jaccard index larger than 0.95 are removed because increasing
  $k$ does not provide enough extra information. If all $k$ are removed, it is
  marked as no subgroup is detected.
- For all $k$ with 1-PAC score larger than 0.9, the maximal $k$ is taken as
  the best $k$, and other $k$ are marked as optional $k$.
- If it does not fit the second rule. The $k$ with the maximal vote of the
  highest 1-PAC score, highest mean silhouette, and highest concordance is
  taken as the best $k$.

``` r
suggest_best_k(res)
```

```
#> [1] 3
```


Following is the table of the partitions (You need to click the **show/hide
code output** link to see it). The membership matrix (columns with name `p*`)
is inferred by
[`clue::cl_consensus()`](https://www.rdocumentation.org/link/cl_consensus?package=clue)
function with the `SE` method. Basically the value in the membership matrix
represents the probability to belong to a certain group. The finall subgroup
label for an item is determined with the group with highest probability it
belongs to.

In `get_classes()` function, the entropy is calculated from the membership
matrix and the silhouette score is calculated from the consensus matrix.



<script>
$( function() {
	$( '#tabs-MAD-mclust-get-classes' ).tabs();
} );
</script>
<div id='tabs-MAD-mclust-get-classes'>
<ul>
<li><a href='#tab-MAD-mclust-get-classes-1'>k = 2</a></li>
<li><a href='#tab-MAD-mclust-get-classes-2'>k = 3</a></li>
<li><a href='#tab-MAD-mclust-get-classes-3'>k = 4</a></li>
<li><a href='#tab-MAD-mclust-get-classes-4'>k = 5</a></li>
<li><a href='#tab-MAD-mclust-get-classes-5'>k = 6</a></li>
</ul>

<div id='tab-MAD-mclust-get-classes-1'>
<p><a id='tab-MAD-mclust-get-classes-1-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 2), get_membership(res, k = 2))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2
#&gt; SIH013     2   0.529      0.927 0.12 0.88
#&gt; SIH014     2   0.000      0.917 0.00 1.00
#&gt; SIH024     2   0.327      0.939 0.06 0.94
#&gt; SIH028     2   0.469      0.942 0.10 0.90
#&gt; SIH031     1   0.000      0.961 1.00 0.00
#&gt; SIH042     1   0.000      0.961 1.00 0.00
#&gt; SIH107     2   0.469      0.942 0.10 0.90
#&gt; SIH114     1   0.242      0.949 0.96 0.04
#&gt; SIH116     1   0.327      0.932 0.94 0.06
#&gt; SIH117     2   0.141      0.929 0.02 0.98
#&gt; SIH130     2   0.000      0.917 0.00 1.00
#&gt; SIH134     2   0.141      0.928 0.02 0.98
#&gt; SIH186     2   0.469      0.942 0.10 0.90
#&gt; SIH191     1   0.000      0.961 1.00 0.00
#&gt; SIH192     2   0.469      0.942 0.10 0.90
#&gt; SIH196     2   0.000      0.917 0.00 1.00
#&gt; SIH214     2   0.402      0.943 0.08 0.92
#&gt; SIH218     2   0.760      0.814 0.22 0.78
#&gt; SIH232     1   0.000      0.961 1.00 0.00
#&gt; SIH236     1   0.402      0.913 0.92 0.08
#&gt; SIH238     1   0.242      0.949 0.96 0.04
#&gt; SIH241     2   0.469      0.942 0.10 0.90
#&gt; SIH245     2   0.242      0.936 0.04 0.96
#&gt; SIH260     1   0.680      0.781 0.82 0.18
#&gt; SIH287     2   0.469      0.942 0.10 0.90
#&gt; SIH289     1   0.855      0.592 0.72 0.28
#&gt; SIH290     2   0.242      0.936 0.04 0.96
#&gt; SIH295     1   0.000      0.961 1.00 0.00
#&gt; SIH366     1   0.000      0.961 1.00 0.00
#&gt; SIH377     1   0.000      0.961 1.00 0.00
#&gt; SIH380     2   0.141      0.929 0.02 0.98
#&gt; SIH385     2   0.242      0.937 0.04 0.96
#&gt; SIH389     2   0.469      0.942 0.10 0.90
#&gt; SIH391     2   0.469      0.942 0.10 0.90
#&gt; SIH403     1   0.242      0.949 0.96 0.04
#&gt; SIH411     2   0.242      0.936 0.04 0.96
#&gt; SIH427     1   0.000      0.961 1.00 0.00
#&gt; SIH433     2   0.402      0.943 0.08 0.92
#&gt; SIH439     2   0.469      0.942 0.10 0.90
#&gt; SIH442     1   0.000      0.961 1.00 0.00
#&gt; SIH444     2   0.881      0.684 0.30 0.70
#&gt; SIH452     2   0.469      0.942 0.10 0.90
#&gt; SIH461     2   0.402      0.942 0.08 0.92
#&gt; SIH471     1   0.000      0.961 1.00 0.00
#&gt; SIH472     2   0.469      0.942 0.10 0.90
#&gt; SIH481     1   0.000      0.961 1.00 0.00
#&gt; SIH485     2   0.000      0.917 0.00 1.00
#&gt; SIH491     2   0.469      0.942 0.10 0.90
#&gt; SIH508     1   0.141      0.959 0.98 0.02
#&gt; SIH559     1   0.141      0.959 0.98 0.02
#&gt; SIH587     1   0.000      0.961 1.00 0.00
#&gt; SIH625     2   0.855      0.719 0.28 0.72
#&gt; SIH641     1   0.141      0.959 0.98 0.02
#&gt; SIH643     2   0.242      0.936 0.04 0.96
#&gt; SIH674     1   0.000      0.961 1.00 0.00
#&gt; SIH678     1   0.141      0.959 0.98 0.02
#&gt; SIH679     1   0.242      0.949 0.96 0.04
#&gt; SIH689     2   0.141      0.929 0.02 0.98
#&gt; SIH694     2   0.000      0.917 0.00 1.00
#&gt; SIH721     2   0.402      0.942 0.08 0.92
</code></pre>

<script>
$('#tab-MAD-mclust-get-classes-1-a').parent().next().next().hide();
$('#tab-MAD-mclust-get-classes-1-a').click(function(){
  $('#tab-MAD-mclust-get-classes-1-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-MAD-mclust-get-classes-2'>
<p><a id='tab-MAD-mclust-get-classes-2-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 3), get_membership(res, k = 3))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3
#&gt; SIH013     3  0.0000      0.996 0.00 0.00 1.00
#&gt; SIH014     3  0.0000      0.996 0.00 0.00 1.00
#&gt; SIH024     3  0.0000      0.996 0.00 0.00 1.00
#&gt; SIH028     2  0.6280      0.159 0.00 0.54 0.46
#&gt; SIH031     1  0.0000      0.978 1.00 0.00 0.00
#&gt; SIH042     1  0.0000      0.978 1.00 0.00 0.00
#&gt; SIH107     2  0.0000      0.956 0.00 1.00 0.00
#&gt; SIH114     1  0.0000      0.978 1.00 0.00 0.00
#&gt; SIH116     1  0.1529      0.942 0.96 0.04 0.00
#&gt; SIH117     3  0.0000      0.996 0.00 0.00 1.00
#&gt; SIH130     3  0.0000      0.996 0.00 0.00 1.00
#&gt; SIH134     3  0.0000      0.996 0.00 0.00 1.00
#&gt; SIH186     2  0.0000      0.956 0.00 1.00 0.00
#&gt; SIH191     1  0.0000      0.978 1.00 0.00 0.00
#&gt; SIH192     2  0.2066      0.909 0.00 0.94 0.06
#&gt; SIH196     3  0.0000      0.996 0.00 0.00 1.00
#&gt; SIH214     3  0.0892      0.977 0.00 0.02 0.98
#&gt; SIH218     3  0.1529      0.951 0.04 0.00 0.96
#&gt; SIH232     1  0.0000      0.978 1.00 0.00 0.00
#&gt; SIH236     1  0.0000      0.978 1.00 0.00 0.00
#&gt; SIH238     1  0.0000      0.978 1.00 0.00 0.00
#&gt; SIH241     2  0.1529      0.928 0.00 0.96 0.04
#&gt; SIH245     3  0.0000      0.996 0.00 0.00 1.00
#&gt; SIH260     1  0.1781      0.945 0.96 0.02 0.02
#&gt; SIH287     2  0.0000      0.956 0.00 1.00 0.00
#&gt; SIH289     2  0.0000      0.956 0.00 1.00 0.00
#&gt; SIH290     3  0.0000      0.996 0.00 0.00 1.00
#&gt; SIH295     1  0.0000      0.978 1.00 0.00 0.00
#&gt; SIH366     1  0.0000      0.978 1.00 0.00 0.00
#&gt; SIH377     1  0.0000      0.978 1.00 0.00 0.00
#&gt; SIH380     3  0.0000      0.996 0.00 0.00 1.00
#&gt; SIH385     3  0.0000      0.996 0.00 0.00 1.00
#&gt; SIH389     2  0.0000      0.956 0.00 1.00 0.00
#&gt; SIH391     2  0.0000      0.956 0.00 1.00 0.00
#&gt; SIH403     1  0.0000      0.978 1.00 0.00 0.00
#&gt; SIH411     3  0.0000      0.996 0.00 0.00 1.00
#&gt; SIH427     1  0.0000      0.978 1.00 0.00 0.00
#&gt; SIH433     3  0.0000      0.996 0.00 0.00 1.00
#&gt; SIH439     2  0.0000      0.956 0.00 1.00 0.00
#&gt; SIH442     1  0.0000      0.978 1.00 0.00 0.00
#&gt; SIH444     1  0.8472      0.251 0.54 0.36 0.10
#&gt; SIH452     2  0.0000      0.956 0.00 1.00 0.00
#&gt; SIH461     3  0.0000      0.996 0.00 0.00 1.00
#&gt; SIH471     1  0.0000      0.978 1.00 0.00 0.00
#&gt; SIH472     2  0.0000      0.956 0.00 1.00 0.00
#&gt; SIH481     1  0.0000      0.978 1.00 0.00 0.00
#&gt; SIH485     3  0.0000      0.996 0.00 0.00 1.00
#&gt; SIH491     2  0.0000      0.956 0.00 1.00 0.00
#&gt; SIH508     1  0.0000      0.978 1.00 0.00 0.00
#&gt; SIH559     1  0.0000      0.978 1.00 0.00 0.00
#&gt; SIH587     1  0.0000      0.978 1.00 0.00 0.00
#&gt; SIH625     2  0.0000      0.956 0.00 1.00 0.00
#&gt; SIH641     1  0.0000      0.978 1.00 0.00 0.00
#&gt; SIH643     3  0.0000      0.996 0.00 0.00 1.00
#&gt; SIH674     1  0.0000      0.978 1.00 0.00 0.00
#&gt; SIH678     1  0.0000      0.978 1.00 0.00 0.00
#&gt; SIH679     1  0.0000      0.978 1.00 0.00 0.00
#&gt; SIH689     3  0.0000      0.996 0.00 0.00 1.00
#&gt; SIH694     3  0.0000      0.996 0.00 0.00 1.00
#&gt; SIH721     3  0.0000      0.996 0.00 0.00 1.00
</code></pre>

<script>
$('#tab-MAD-mclust-get-classes-2-a').parent().next().next().hide();
$('#tab-MAD-mclust-get-classes-2-a').click(function(){
  $('#tab-MAD-mclust-get-classes-2-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-MAD-mclust-get-classes-3'>
<p><a id='tab-MAD-mclust-get-classes-3-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 4), get_membership(res, k = 4))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3   p4
#&gt; SIH013     3  0.3525      0.846 0.10 0.00 0.86 0.04
#&gt; SIH014     3  0.1211      0.918 0.00 0.00 0.96 0.04
#&gt; SIH024     3  0.2706      0.900 0.02 0.00 0.90 0.08
#&gt; SIH028     2  0.5062      0.510 0.00 0.68 0.30 0.02
#&gt; SIH031     1  0.4994     -0.645 0.52 0.00 0.00 0.48
#&gt; SIH042     1  0.2921      0.565 0.86 0.00 0.00 0.14
#&gt; SIH107     2  0.0707      0.906 0.00 0.98 0.00 0.02
#&gt; SIH114     1  0.1637      0.622 0.94 0.00 0.00 0.06
#&gt; SIH116     1  0.1913      0.604 0.94 0.04 0.00 0.02
#&gt; SIH117     3  0.1211      0.920 0.00 0.00 0.96 0.04
#&gt; SIH130     3  0.1637      0.916 0.00 0.00 0.94 0.06
#&gt; SIH134     3  0.3801      0.848 0.00 0.00 0.78 0.22
#&gt; SIH186     2  0.0707      0.904 0.00 0.98 0.00 0.02
#&gt; SIH191     4  0.4855      0.991 0.40 0.00 0.00 0.60
#&gt; SIH192     2  0.2411      0.880 0.00 0.92 0.04 0.04
#&gt; SIH196     3  0.3172      0.879 0.00 0.00 0.84 0.16
#&gt; SIH214     3  0.2411      0.908 0.00 0.04 0.92 0.04
#&gt; SIH218     1  0.5570      0.060 0.54 0.00 0.44 0.02
#&gt; SIH232     4  0.4855      0.991 0.40 0.00 0.00 0.60
#&gt; SIH236     1  0.1211      0.625 0.96 0.00 0.00 0.04
#&gt; SIH238     1  0.3335      0.597 0.86 0.00 0.02 0.12
#&gt; SIH241     2  0.2411      0.881 0.00 0.92 0.04 0.04
#&gt; SIH245     3  0.3801      0.848 0.00 0.00 0.78 0.22
#&gt; SIH260     1  0.2113      0.611 0.94 0.02 0.02 0.02
#&gt; SIH287     2  0.0707      0.906 0.00 0.98 0.00 0.02
#&gt; SIH289     2  0.1913      0.881 0.04 0.94 0.00 0.02
#&gt; SIH290     3  0.3801      0.848 0.00 0.00 0.78 0.22
#&gt; SIH295     4  0.4855      0.991 0.40 0.00 0.00 0.60
#&gt; SIH366     4  0.4907      0.944 0.42 0.00 0.00 0.58
#&gt; SIH377     1  0.4994     -0.652 0.52 0.00 0.00 0.48
#&gt; SIH380     3  0.0707      0.921 0.00 0.00 0.98 0.02
#&gt; SIH385     3  0.1211      0.918 0.00 0.00 0.96 0.04
#&gt; SIH389     2  0.1637      0.895 0.00 0.94 0.00 0.06
#&gt; SIH391     2  0.0000      0.907 0.00 1.00 0.00 0.00
#&gt; SIH403     1  0.1211      0.624 0.96 0.00 0.00 0.04
#&gt; SIH411     3  0.3610      0.860 0.00 0.00 0.80 0.20
#&gt; SIH427     1  0.2921      0.564 0.86 0.00 0.00 0.14
#&gt; SIH433     3  0.1211      0.918 0.00 0.00 0.96 0.04
#&gt; SIH439     2  0.0000      0.907 0.00 1.00 0.00 0.00
#&gt; SIH442     4  0.4855      0.991 0.40 0.00 0.00 0.60
#&gt; SIH444     2  0.9211     -0.270 0.24 0.36 0.08 0.32
#&gt; SIH452     2  0.0000      0.907 0.00 1.00 0.00 0.00
#&gt; SIH461     3  0.2706      0.900 0.02 0.00 0.90 0.08
#&gt; SIH471     1  0.2921      0.568 0.86 0.00 0.00 0.14
#&gt; SIH472     2  0.0707      0.906 0.00 0.98 0.00 0.02
#&gt; SIH481     4  0.4855      0.991 0.40 0.00 0.00 0.60
#&gt; SIH485     3  0.1211      0.920 0.00 0.00 0.96 0.04
#&gt; SIH491     2  0.1211      0.899 0.00 0.96 0.00 0.04
#&gt; SIH508     1  0.4790     -0.236 0.62 0.00 0.00 0.38
#&gt; SIH559     1  0.3610      0.474 0.80 0.00 0.00 0.20
#&gt; SIH587     1  0.5000     -0.730 0.50 0.00 0.00 0.50
#&gt; SIH625     2  0.1411      0.896 0.02 0.96 0.00 0.02
#&gt; SIH641     1  0.3801      0.437 0.78 0.00 0.00 0.22
#&gt; SIH643     3  0.1211      0.918 0.00 0.00 0.96 0.04
#&gt; SIH674     4  0.4855      0.991 0.40 0.00 0.00 0.60
#&gt; SIH678     1  0.1211      0.626 0.96 0.00 0.00 0.04
#&gt; SIH679     1  0.1637      0.614 0.94 0.00 0.00 0.06
#&gt; SIH689     3  0.0000      0.921 0.00 0.00 1.00 0.00
#&gt; SIH694     3  0.1211      0.920 0.00 0.00 0.96 0.04
#&gt; SIH721     3  0.2706      0.900 0.02 0.00 0.90 0.08
</code></pre>

<script>
$('#tab-MAD-mclust-get-classes-3-a').parent().next().next().hide();
$('#tab-MAD-mclust-get-classes-3-a').click(function(){
  $('#tab-MAD-mclust-get-classes-3-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-MAD-mclust-get-classes-4'>
<p><a id='tab-MAD-mclust-get-classes-4-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 5), get_membership(res, k = 5))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3   p4   p5
#&gt; SIH013     3  0.4748      0.329 0.14 0.08 0.76 0.00 0.02
#&gt; SIH014     3  0.0609      0.559 0.00 0.02 0.98 0.00 0.00
#&gt; SIH024     3  0.1732      0.537 0.00 0.08 0.92 0.00 0.00
#&gt; SIH028     4  0.5092      0.521 0.02 0.04 0.26 0.68 0.00
#&gt; SIH031     5  0.3561      0.613 0.26 0.00 0.00 0.00 0.74
#&gt; SIH042     1  0.4262      0.375 0.56 0.00 0.00 0.00 0.44
#&gt; SIH107     4  0.0000      0.847 0.00 0.00 0.00 1.00 0.00
#&gt; SIH114     1  0.1410      0.739 0.94 0.00 0.00 0.00 0.06
#&gt; SIH116     1  0.3209      0.745 0.86 0.02 0.00 0.02 0.10
#&gt; SIH117     3  0.3109      0.356 0.00 0.20 0.80 0.00 0.00
#&gt; SIH130     3  0.3561      0.168 0.00 0.26 0.74 0.00 0.00
#&gt; SIH134     2  0.4307      0.935 0.00 0.50 0.50 0.00 0.00
#&gt; SIH186     4  0.2020      0.837 0.00 0.10 0.00 0.90 0.00
#&gt; SIH191     5  0.1410      0.838 0.06 0.00 0.00 0.00 0.94
#&gt; SIH192     4  0.3977      0.791 0.02 0.10 0.06 0.82 0.00
#&gt; SIH196     3  0.3796     -0.058 0.00 0.30 0.70 0.00 0.00
#&gt; SIH214     3  0.2797      0.487 0.00 0.06 0.88 0.06 0.00
#&gt; SIH218     1  0.6038      0.330 0.56 0.08 0.34 0.00 0.02
#&gt; SIH232     5  0.0609      0.845 0.02 0.00 0.00 0.00 0.98
#&gt; SIH236     1  0.2873      0.745 0.86 0.02 0.00 0.00 0.12
#&gt; SIH238     1  0.6008      0.642 0.66 0.06 0.08 0.00 0.20
#&gt; SIH241     4  0.4613      0.724 0.00 0.36 0.02 0.62 0.00
#&gt; SIH245     3  0.4307     -0.970 0.00 0.50 0.50 0.00 0.00
#&gt; SIH260     1  0.4281      0.702 0.80 0.02 0.00 0.10 0.08
#&gt; SIH287     4  0.0609      0.846 0.02 0.00 0.00 0.98 0.00
#&gt; SIH289     4  0.0609      0.846 0.00 0.02 0.00 0.98 0.00
#&gt; SIH290     3  0.4307     -0.970 0.00 0.50 0.50 0.00 0.00
#&gt; SIH295     5  0.0000      0.838 0.00 0.00 0.00 0.00 1.00
#&gt; SIH366     5  0.1043      0.847 0.04 0.00 0.00 0.00 0.96
#&gt; SIH377     5  0.3561      0.633 0.26 0.00 0.00 0.00 0.74
#&gt; SIH380     3  0.3424      0.250 0.00 0.24 0.76 0.00 0.00
#&gt; SIH385     3  0.1043      0.558 0.00 0.04 0.96 0.00 0.00
#&gt; SIH389     4  0.2616      0.825 0.02 0.10 0.00 0.88 0.00
#&gt; SIH391     4  0.1732      0.841 0.00 0.08 0.00 0.92 0.00
#&gt; SIH403     1  0.1410      0.739 0.94 0.00 0.00 0.00 0.06
#&gt; SIH411     2  0.4307      0.935 0.00 0.50 0.50 0.00 0.00
#&gt; SIH427     1  0.3983      0.588 0.66 0.00 0.00 0.00 0.34
#&gt; SIH433     3  0.3274      0.316 0.00 0.22 0.78 0.00 0.00
#&gt; SIH439     4  0.3983      0.743 0.00 0.34 0.00 0.66 0.00
#&gt; SIH442     5  0.1043      0.847 0.04 0.00 0.00 0.00 0.96
#&gt; SIH444     4  0.9214      0.305 0.06 0.26 0.14 0.34 0.20
#&gt; SIH452     4  0.0000      0.847 0.00 0.00 0.00 1.00 0.00
#&gt; SIH461     3  0.1732      0.537 0.00 0.08 0.92 0.00 0.00
#&gt; SIH471     1  0.3684      0.657 0.72 0.00 0.00 0.00 0.28
#&gt; SIH472     4  0.1216      0.842 0.02 0.02 0.00 0.96 0.00
#&gt; SIH481     5  0.0000      0.838 0.00 0.00 0.00 0.00 1.00
#&gt; SIH485     3  0.3109      0.369 0.00 0.20 0.80 0.00 0.00
#&gt; SIH491     4  0.4060      0.737 0.00 0.36 0.00 0.64 0.00
#&gt; SIH508     5  0.4126      0.210 0.38 0.00 0.00 0.00 0.62
#&gt; SIH559     1  0.3983      0.594 0.66 0.00 0.00 0.00 0.34
#&gt; SIH587     5  0.2280      0.764 0.12 0.00 0.00 0.00 0.88
#&gt; SIH625     4  0.0609      0.846 0.00 0.02 0.00 0.98 0.00
#&gt; SIH641     1  0.4060      0.563 0.64 0.00 0.00 0.00 0.36
#&gt; SIH643     3  0.1732      0.549 0.00 0.08 0.92 0.00 0.00
#&gt; SIH674     5  0.0000      0.838 0.00 0.00 0.00 0.00 1.00
#&gt; SIH678     1  0.1732      0.748 0.92 0.00 0.00 0.00 0.08
#&gt; SIH679     1  0.1648      0.731 0.94 0.02 0.00 0.00 0.04
#&gt; SIH689     3  0.2020      0.520 0.00 0.10 0.90 0.00 0.00
#&gt; SIH694     3  0.2280      0.500 0.00 0.12 0.88 0.00 0.00
#&gt; SIH721     3  0.1732      0.537 0.00 0.08 0.92 0.00 0.00
</code></pre>

<script>
$('#tab-MAD-mclust-get-classes-4-a').parent().next().next().hide();
$('#tab-MAD-mclust-get-classes-4-a').click(function(){
  $('#tab-MAD-mclust-get-classes-4-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-MAD-mclust-get-classes-5'>
<p><a id='tab-MAD-mclust-get-classes-5-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 6), get_membership(res, k = 6))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3   p4   p5   p6
#&gt; SIH013     3  0.7074     0.2901 0.22 0.32 0.38 0.00 0.00 0.08
#&gt; SIH014     3  0.2728     0.6483 0.00 0.04 0.86 0.00 0.00 0.10
#&gt; SIH024     3  0.4680     0.6020 0.00 0.20 0.68 0.00 0.00 0.12
#&gt; SIH028     4  0.5860     0.3867 0.02 0.14 0.20 0.62 0.00 0.02
#&gt; SIH031     5  0.4482     0.3675 0.36 0.00 0.00 0.00 0.60 0.04
#&gt; SIH042     1  0.3499     0.5411 0.68 0.00 0.00 0.00 0.32 0.00
#&gt; SIH107     4  0.0547     0.7797 0.00 0.00 0.00 0.98 0.00 0.02
#&gt; SIH114     1  0.1865     0.7412 0.92 0.00 0.00 0.00 0.04 0.04
#&gt; SIH116     1  0.2725     0.7478 0.88 0.02 0.00 0.06 0.04 0.00
#&gt; SIH117     3  0.0547     0.6334 0.00 0.02 0.98 0.00 0.00 0.00
#&gt; SIH130     3  0.1814     0.5035 0.00 0.10 0.90 0.00 0.00 0.00
#&gt; SIH134     2  0.3756     0.9770 0.00 0.60 0.40 0.00 0.00 0.00
#&gt; SIH186     4  0.2941     0.5818 0.00 0.00 0.00 0.78 0.00 0.22
#&gt; SIH191     5  0.1556     0.8081 0.08 0.00 0.00 0.00 0.92 0.00
#&gt; SIH192     4  0.4162     0.6627 0.00 0.12 0.06 0.78 0.00 0.04
#&gt; SIH196     3  0.2941     0.2485 0.00 0.22 0.78 0.00 0.00 0.00
#&gt; SIH214     3  0.4765     0.4804 0.00 0.04 0.64 0.02 0.00 0.30
#&gt; SIH218     1  0.5930     0.5332 0.58 0.24 0.14 0.00 0.00 0.04
#&gt; SIH232     5  0.1267     0.8095 0.06 0.00 0.00 0.00 0.94 0.00
#&gt; SIH236     1  0.3162     0.7476 0.86 0.02 0.00 0.02 0.08 0.02
#&gt; SIH238     1  0.5636     0.6175 0.62 0.24 0.00 0.00 0.06 0.08
#&gt; SIH241     6  0.3819     0.7450 0.00 0.00 0.02 0.28 0.00 0.70
#&gt; SIH245     2  0.3756     0.9770 0.00 0.60 0.40 0.00 0.00 0.00
#&gt; SIH260     1  0.3258     0.7302 0.84 0.02 0.00 0.10 0.04 0.00
#&gt; SIH287     4  0.1092     0.7820 0.00 0.02 0.00 0.96 0.00 0.02
#&gt; SIH289     4  0.0547     0.7655 0.02 0.00 0.00 0.98 0.00 0.00
#&gt; SIH290     2  0.3756     0.9770 0.00 0.60 0.40 0.00 0.00 0.00
#&gt; SIH295     5  0.0000     0.7935 0.00 0.00 0.00 0.00 1.00 0.00
#&gt; SIH366     5  0.1556     0.8097 0.08 0.00 0.00 0.00 0.92 0.00
#&gt; SIH377     5  0.3309     0.6202 0.28 0.00 0.00 0.00 0.72 0.00
#&gt; SIH380     3  0.1556     0.5360 0.00 0.08 0.92 0.00 0.00 0.00
#&gt; SIH385     3  0.2728     0.6509 0.00 0.04 0.86 0.00 0.00 0.10
#&gt; SIH389     4  0.4536     0.6003 0.00 0.18 0.00 0.70 0.00 0.12
#&gt; SIH391     4  0.2981     0.6266 0.00 0.02 0.00 0.82 0.00 0.16
#&gt; SIH403     1  0.3854     0.6995 0.80 0.12 0.00 0.00 0.04 0.04
#&gt; SIH411     2  0.3797     0.9287 0.00 0.58 0.42 0.00 0.00 0.00
#&gt; SIH427     1  0.3409     0.5797 0.70 0.00 0.00 0.00 0.30 0.00
#&gt; SIH433     3  0.4892     0.3867 0.00 0.06 0.50 0.00 0.00 0.44
#&gt; SIH439     6  0.3828     0.5920 0.00 0.00 0.00 0.44 0.00 0.56
#&gt; SIH442     5  0.1556     0.8097 0.08 0.00 0.00 0.00 0.92 0.00
#&gt; SIH444     6  0.6611     0.5673 0.06 0.00 0.02 0.26 0.12 0.54
#&gt; SIH452     4  0.0547     0.7797 0.00 0.00 0.00 0.98 0.00 0.02
#&gt; SIH461     3  0.5324     0.5202 0.00 0.34 0.54 0.00 0.00 0.12
#&gt; SIH471     1  0.3315     0.6857 0.78 0.00 0.00 0.00 0.20 0.02
#&gt; SIH472     4  0.2512     0.7606 0.00 0.06 0.00 0.88 0.00 0.06
#&gt; SIH481     5  0.0000     0.7935 0.00 0.00 0.00 0.00 1.00 0.00
#&gt; SIH485     3  0.1807     0.6161 0.00 0.06 0.92 0.00 0.00 0.02
#&gt; SIH491     6  0.3198     0.7444 0.00 0.00 0.00 0.26 0.00 0.74
#&gt; SIH508     5  0.6109    -0.0382 0.40 0.08 0.00 0.00 0.46 0.06
#&gt; SIH559     1  0.3592     0.6674 0.74 0.00 0.00 0.00 0.24 0.02
#&gt; SIH587     5  0.2631     0.7084 0.18 0.00 0.00 0.00 0.82 0.00
#&gt; SIH625     4  0.0000     0.7803 0.00 0.00 0.00 1.00 0.00 0.00
#&gt; SIH641     1  0.4348     0.4946 0.64 0.00 0.00 0.00 0.32 0.04
#&gt; SIH643     3  0.2454     0.6417 0.00 0.16 0.84 0.00 0.00 0.00
#&gt; SIH674     5  0.0000     0.7935 0.00 0.00 0.00 0.00 1.00 0.00
#&gt; SIH678     1  0.1480     0.7526 0.94 0.00 0.00 0.00 0.04 0.02
#&gt; SIH679     1  0.2880     0.7268 0.88 0.02 0.00 0.02 0.02 0.06
#&gt; SIH689     3  0.0547     0.6334 0.00 0.02 0.98 0.00 0.00 0.00
#&gt; SIH694     3  0.1807     0.6283 0.00 0.02 0.92 0.00 0.00 0.06
#&gt; SIH721     3  0.5144     0.5300 0.00 0.34 0.56 0.00 0.00 0.10
</code></pre>

<script>
$('#tab-MAD-mclust-get-classes-5-a').parent().next().next().hide();
$('#tab-MAD-mclust-get-classes-5-a').click(function(){
  $('#tab-MAD-mclust-get-classes-5-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>
</div>

Heatmaps for the consensus matrix. It visualizes the probability of two
samples to be in a same group.




<script>
$( function() {
	$( '#tabs-MAD-mclust-consensus-heatmap' ).tabs();
} );
</script>
<div id='tabs-MAD-mclust-consensus-heatmap'>
<ul>
<li><a href='#tab-MAD-mclust-consensus-heatmap-1'>k = 2</a></li>
<li><a href='#tab-MAD-mclust-consensus-heatmap-2'>k = 3</a></li>
<li><a href='#tab-MAD-mclust-consensus-heatmap-3'>k = 4</a></li>
<li><a href='#tab-MAD-mclust-consensus-heatmap-4'>k = 5</a></li>
<li><a href='#tab-MAD-mclust-consensus-heatmap-5'>k = 6</a></li>
</ul>
<div id='tab-MAD-mclust-consensus-heatmap-1'>
<pre><code class="language-r">consensus_heatmap(res, k = 2)
</code></pre>
<p><img src="figure_cola/tab-MAD-mclust-consensus-heatmap-1-1.png" alt="plot of chunk tab-MAD-mclust-consensus-heatmap-1" /></p>

</div>
<div id='tab-MAD-mclust-consensus-heatmap-2'>
<pre><code class="language-r">consensus_heatmap(res, k = 3)
</code></pre>
<p><img src="figure_cola/tab-MAD-mclust-consensus-heatmap-2-1.png" alt="plot of chunk tab-MAD-mclust-consensus-heatmap-2" /></p>

</div>
<div id='tab-MAD-mclust-consensus-heatmap-3'>
<pre><code class="language-r">consensus_heatmap(res, k = 4)
</code></pre>
<p><img src="figure_cola/tab-MAD-mclust-consensus-heatmap-3-1.png" alt="plot of chunk tab-MAD-mclust-consensus-heatmap-3" /></p>

</div>
<div id='tab-MAD-mclust-consensus-heatmap-4'>
<pre><code class="language-r">consensus_heatmap(res, k = 5)
</code></pre>
<p><img src="figure_cola/tab-MAD-mclust-consensus-heatmap-4-1.png" alt="plot of chunk tab-MAD-mclust-consensus-heatmap-4" /></p>

</div>
<div id='tab-MAD-mclust-consensus-heatmap-5'>
<pre><code class="language-r">consensus_heatmap(res, k = 6)
</code></pre>
<p><img src="figure_cola/tab-MAD-mclust-consensus-heatmap-5-1.png" alt="plot of chunk tab-MAD-mclust-consensus-heatmap-5" /></p>

</div>
</div>

Heatmaps for the membership of samples in all partitions to see how consistent they are:





<script>
$( function() {
	$( '#tabs-MAD-mclust-membership-heatmap' ).tabs();
} );
</script>
<div id='tabs-MAD-mclust-membership-heatmap'>
<ul>
<li><a href='#tab-MAD-mclust-membership-heatmap-1'>k = 2</a></li>
<li><a href='#tab-MAD-mclust-membership-heatmap-2'>k = 3</a></li>
<li><a href='#tab-MAD-mclust-membership-heatmap-3'>k = 4</a></li>
<li><a href='#tab-MAD-mclust-membership-heatmap-4'>k = 5</a></li>
<li><a href='#tab-MAD-mclust-membership-heatmap-5'>k = 6</a></li>
</ul>
<div id='tab-MAD-mclust-membership-heatmap-1'>
<pre><code class="language-r">membership_heatmap(res, k = 2)
</code></pre>
<p><img src="figure_cola/tab-MAD-mclust-membership-heatmap-1-1.png" alt="plot of chunk tab-MAD-mclust-membership-heatmap-1" /></p>

</div>
<div id='tab-MAD-mclust-membership-heatmap-2'>
<pre><code class="language-r">membership_heatmap(res, k = 3)
</code></pre>
<p><img src="figure_cola/tab-MAD-mclust-membership-heatmap-2-1.png" alt="plot of chunk tab-MAD-mclust-membership-heatmap-2" /></p>

</div>
<div id='tab-MAD-mclust-membership-heatmap-3'>
<pre><code class="language-r">membership_heatmap(res, k = 4)
</code></pre>
<p><img src="figure_cola/tab-MAD-mclust-membership-heatmap-3-1.png" alt="plot of chunk tab-MAD-mclust-membership-heatmap-3" /></p>

</div>
<div id='tab-MAD-mclust-membership-heatmap-4'>
<pre><code class="language-r">membership_heatmap(res, k = 5)
</code></pre>
<p><img src="figure_cola/tab-MAD-mclust-membership-heatmap-4-1.png" alt="plot of chunk tab-MAD-mclust-membership-heatmap-4" /></p>

</div>
<div id='tab-MAD-mclust-membership-heatmap-5'>
<pre><code class="language-r">membership_heatmap(res, k = 6)
</code></pre>
<p><img src="figure_cola/tab-MAD-mclust-membership-heatmap-5-1.png" alt="plot of chunk tab-MAD-mclust-membership-heatmap-5" /></p>

</div>
</div>

As soon as the classes for columns are determined, the signatures
that are significantly different between subgroups can be looked for. 
Following are the heatmaps for signatures.




Signature heatmaps where rows are scaled:



<script>
$( function() {
	$( '#tabs-MAD-mclust-get-signatures' ).tabs();
} );
</script>
<div id='tabs-MAD-mclust-get-signatures'>
<ul>
<li><a href='#tab-MAD-mclust-get-signatures-1'>k = 2</a></li>
<li><a href='#tab-MAD-mclust-get-signatures-2'>k = 3</a></li>
<li><a href='#tab-MAD-mclust-get-signatures-3'>k = 4</a></li>
<li><a href='#tab-MAD-mclust-get-signatures-4'>k = 5</a></li>
<li><a href='#tab-MAD-mclust-get-signatures-5'>k = 6</a></li>
</ul>
<div id='tab-MAD-mclust-get-signatures-1'>
<pre><code class="language-r">get_signatures(res, k = 2)
</code></pre>
<p><img src="figure_cola/tab-MAD-mclust-get-signatures-1-1.png" alt="plot of chunk tab-MAD-mclust-get-signatures-1" /></p>

</div>
<div id='tab-MAD-mclust-get-signatures-2'>
<pre><code class="language-r">get_signatures(res, k = 3)
</code></pre>
<p><img src="figure_cola/tab-MAD-mclust-get-signatures-2-1.png" alt="plot of chunk tab-MAD-mclust-get-signatures-2" /></p>

</div>
<div id='tab-MAD-mclust-get-signatures-3'>
<pre><code class="language-r">get_signatures(res, k = 4)
</code></pre>
<p><img src="figure_cola/tab-MAD-mclust-get-signatures-3-1.png" alt="plot of chunk tab-MAD-mclust-get-signatures-3" /></p>

</div>
<div id='tab-MAD-mclust-get-signatures-4'>
<pre><code class="language-r">get_signatures(res, k = 5)
</code></pre>
<p><img src="figure_cola/tab-MAD-mclust-get-signatures-4-1.png" alt="plot of chunk tab-MAD-mclust-get-signatures-4" /></p>

</div>
<div id='tab-MAD-mclust-get-signatures-5'>
<pre><code class="language-r">get_signatures(res, k = 6)
</code></pre>
<p><img src="figure_cola/tab-MAD-mclust-get-signatures-5-1.png" alt="plot of chunk tab-MAD-mclust-get-signatures-5" /></p>

</div>
</div>



Signature heatmaps where rows are not scaled:


<script>
$( function() {
	$( '#tabs-MAD-mclust-get-signatures-no-scale' ).tabs();
} );
</script>
<div id='tabs-MAD-mclust-get-signatures-no-scale'>
<ul>
<li><a href='#tab-MAD-mclust-get-signatures-no-scale-1'>k = 2</a></li>
<li><a href='#tab-MAD-mclust-get-signatures-no-scale-2'>k = 3</a></li>
<li><a href='#tab-MAD-mclust-get-signatures-no-scale-3'>k = 4</a></li>
<li><a href='#tab-MAD-mclust-get-signatures-no-scale-4'>k = 5</a></li>
<li><a href='#tab-MAD-mclust-get-signatures-no-scale-5'>k = 6</a></li>
</ul>
<div id='tab-MAD-mclust-get-signatures-no-scale-1'>
<pre><code class="language-r">get_signatures(res, k = 2, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-MAD-mclust-get-signatures-no-scale-1-1.png" alt="plot of chunk tab-MAD-mclust-get-signatures-no-scale-1" /></p>

</div>
<div id='tab-MAD-mclust-get-signatures-no-scale-2'>
<pre><code class="language-r">get_signatures(res, k = 3, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-MAD-mclust-get-signatures-no-scale-2-1.png" alt="plot of chunk tab-MAD-mclust-get-signatures-no-scale-2" /></p>

</div>
<div id='tab-MAD-mclust-get-signatures-no-scale-3'>
<pre><code class="language-r">get_signatures(res, k = 4, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-MAD-mclust-get-signatures-no-scale-3-1.png" alt="plot of chunk tab-MAD-mclust-get-signatures-no-scale-3" /></p>

</div>
<div id='tab-MAD-mclust-get-signatures-no-scale-4'>
<pre><code class="language-r">get_signatures(res, k = 5, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-MAD-mclust-get-signatures-no-scale-4-1.png" alt="plot of chunk tab-MAD-mclust-get-signatures-no-scale-4" /></p>

</div>
<div id='tab-MAD-mclust-get-signatures-no-scale-5'>
<pre><code class="language-r">get_signatures(res, k = 6, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-MAD-mclust-get-signatures-no-scale-5-1.png" alt="plot of chunk tab-MAD-mclust-get-signatures-no-scale-5" /></p>

</div>
</div>



Compare the overlap of signatures from different k:

``` r
compare_signatures(res)
```

![plot of chunk MAD-mclust-signature_compare](figure_cola/MAD-mclust-signature_compare-1.png)

`get_signature()` returns a data frame invisibly. To get the list of signatures, the function
call should be assigned to a variable explicitly. In following code, if `plot` argument is set
to `FALSE`, no heatmap is plotted while only the differential analysis is performed.

``` r
# code only for demonstration
tb = get_signature(res, k = ..., plot = FALSE)
```

An example of the output of `tb` is:

```
#>   which_row         fdr    mean_1    mean_2 scaled_mean_1 scaled_mean_2 km
#> 1        38 0.042760348  8.373488  9.131774    -0.5533452     0.5164555  1
#> 2        40 0.018707592  7.106213  8.469186    -0.6173731     0.5762149  1
#> 3        55 0.019134737 10.221463 11.207825    -0.6159697     0.5749050  1
#> 4        59 0.006059896  5.921854  7.869574    -0.6899429     0.6439467  1
#> 5        60 0.018055526  8.928898 10.211722    -0.6204761     0.5791110  1
#> 6        98 0.009384629 15.714769 14.887706     0.6635654    -0.6193277  2
...
```

The columns in `tb` are:

1. `which_row`: row indices corresponding to the input matrix.
2. `fdr`: FDR for the differential test. 
3. `mean_x`: The mean value in group x.
4. `scaled_mean_x`: The mean value in group x after rows are scaled.
5. `km`: Row groups if k-means clustering is applied to rows (which is done by automatically selecting number of clusters).

If there are too many signatures, `top_signatures = ...` can be set to only show the 
signatures with the highest FDRs:

``` r
# code only for demonstration
# e.g. to show the top 500 most significant rows
tb = get_signature(res, k = ..., top_signatures = 500)
```

If the signatures are defined as these which are uniquely high in current group, `diff_method` argument
can be set to `"uniquely_high_in_one_group"`:

``` r
# code only for demonstration
tb = get_signature(res, k = ..., diff_method = "uniquely_high_in_one_group")
```




UMAP plot which shows how samples are separated.


<script>
$( function() {
	$( '#tabs-MAD-mclust-dimension-reduction' ).tabs();
} );
</script>
<div id='tabs-MAD-mclust-dimension-reduction'>
<ul>
<li><a href='#tab-MAD-mclust-dimension-reduction-1'>k = 2</a></li>
<li><a href='#tab-MAD-mclust-dimension-reduction-2'>k = 3</a></li>
<li><a href='#tab-MAD-mclust-dimension-reduction-3'>k = 4</a></li>
<li><a href='#tab-MAD-mclust-dimension-reduction-4'>k = 5</a></li>
<li><a href='#tab-MAD-mclust-dimension-reduction-5'>k = 6</a></li>
</ul>
<div id='tab-MAD-mclust-dimension-reduction-1'>
<pre><code class="language-r">dimension_reduction(res, k = 2, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-MAD-mclust-dimension-reduction-1-1.png" alt="plot of chunk tab-MAD-mclust-dimension-reduction-1" /></p>

</div>
<div id='tab-MAD-mclust-dimension-reduction-2'>
<pre><code class="language-r">dimension_reduction(res, k = 3, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-MAD-mclust-dimension-reduction-2-1.png" alt="plot of chunk tab-MAD-mclust-dimension-reduction-2" /></p>

</div>
<div id='tab-MAD-mclust-dimension-reduction-3'>
<pre><code class="language-r">dimension_reduction(res, k = 4, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-MAD-mclust-dimension-reduction-3-1.png" alt="plot of chunk tab-MAD-mclust-dimension-reduction-3" /></p>

</div>
<div id='tab-MAD-mclust-dimension-reduction-4'>
<pre><code class="language-r">dimension_reduction(res, k = 5, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-MAD-mclust-dimension-reduction-4-1.png" alt="plot of chunk tab-MAD-mclust-dimension-reduction-4" /></p>

</div>
<div id='tab-MAD-mclust-dimension-reduction-5'>
<pre><code class="language-r">dimension_reduction(res, k = 6, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-MAD-mclust-dimension-reduction-5-1.png" alt="plot of chunk tab-MAD-mclust-dimension-reduction-5" /></p>

</div>
</div>



Following heatmap shows how subgroups are split when increasing `k`:

``` r
collect_classes(res)
```

![plot of chunk MAD-mclust-collect-classes](figure_cola/MAD-mclust-collect-classes-1.png)



If matrix rows can be associated to genes, consider to use `functional_enrichment(res,
...)` to perform function enrichment for the signature genes. See [this vignette](https://jokergoo.github.io/cola_vignettes/functional_enrichment.html) for more detailed explanations.


 

---------------------------------------------------



### CV:hclust






The object with results only for a single top-value method and a single partitioning method 
can be extracted as:

``` r
res = res_list["CV", "hclust"]
# you can also extract it by
# res = res_list["CV:hclust"]
```

A summary of `res` and all the functions that can be applied to it:

``` r
res
```

```
#> A 'ConsensusPartition' object with k = 2, 3, 4, 5, 6.
#>   On a matrix with 1900 rows and 60 columns.
#>   Top rows (7) are extracted by 'CV' method.
#>   Subgroups are detected by 'hclust' method.
#>   Performed in total 250 partitions by row resampling.
#>   Best k for subgroups seems to be 3.
#> 
#> Following methods can be applied to this 'ConsensusPartition' object:
#>  [1] "cola_report"             "collect_classes"         "collect_plots"          
#>  [4] "collect_stats"           "colnames"                "compare_partitions"     
#>  [7] "compare_signatures"      "consensus_heatmap"       "dimension_reduction"    
#> [10] "functional_enrichment"   "get_anno_col"            "get_anno"               
#> [13] "get_classes"             "get_consensus"           "get_matrix"             
#> [16] "get_membership"          "get_param"               "get_signatures"         
#> [19] "get_stats"               "is_best_k"               "is_stable_k"            
#> [22] "membership_heatmap"      "ncol"                    "nrow"                   
#> [25] "plot_ecdf"               "predict_classes"         "rownames"               
#> [28] "select_partition_number" "show"                    "suggest_best_k"         
#> [31] "test_to_known_factors"   "top_rows_heatmap"
```

`collect_plots()` function collects all the plots made from `res` for all `k` (number of subgroups)
into one single page to provide an easy and fast comparison between different `k`.

``` r
collect_plots(res)
```

![plot of chunk CV-hclust-collect-plots](figure_cola/CV-hclust-collect-plots-1.png)

The plots are:

- The first row: a plot of the eCDF (empirical cumulative distribution
  function) curves of the consensus matrix for each `k` and the heatmap of
  predicted classes for each `k`.
- The second row: heatmaps of the consensus matrix for each `k`.
- The third row: heatmaps of the membership matrix for each `k`.
- The fouth row: heatmaps of the signatures for each `k`.

All the plots in panels can be made by individual functions and they are
plotted later in this section.

`select_partition_number()` produces several plots showing different
statistics for choosing "optimized" `k`. There are following statistics:

- eCDF curves of the consensus matrix for each `k`;
- 1-PAC. [The PAC score](https://en.wikipedia.org/wiki/Consensus_clustering#Over-interpretation_potential_of_consensus_clustering)
  measures the proportion of the ambiguous subgrouping.
- Mean silhouette score.
- Concordance. The mean probability of fiting the consensus subgroup labels in all
  partitions.
- Area increased. Denote $A_k$ as the area under the eCDF curve for current
  `k`, the area increased is defined as $A_k - A_{k-1}$.
- Rand index. The percent of pairs of samples that are both in a same cluster
  or both are not in a same cluster in the partition of k and k-1.
- Jaccard index. The ratio of pairs of samples are both in a same cluster in
  the partition of k and k-1 and the pairs of samples are both in a same
  cluster in the partition k or k-1.

The detailed explanations of these statistics can be found in [the _cola_
vignette](https://jokergoo.github.io/cola_vignettes/cola.html#toc_13).

Generally speaking, higher 1-PAC score, higher mean silhouette score or higher
concordance corresponds to better partition. Rand index and Jaccard index
measure how similar the current partition is compared to partition with `k-1`.
If they are too similar, we won't accept `k` is better than `k-1`.

``` r
select_partition_number(res)
```

![plot of chunk CV-hclust-select-partition-number](figure_cola/CV-hclust-select-partition-number-1.png)

The numeric values for all these statistics can be obtained by `get_stats()`.

``` r
get_stats(res)
```

```
#>   k 1-PAC mean_silhouette concordance area_increased  Rand Jaccard
#> 2 2 0.354           0.653       0.843         0.3394 0.675   0.675
#> 3 3 0.288           0.639       0.833         0.5092 0.821   0.741
#> 4 4 0.236           0.290       0.490         0.2229 0.575   0.308
#> 5 5 0.445           0.326       0.665         0.1116 0.668   0.292
#> 6 6 0.477           0.494       0.631         0.0767 0.847   0.569
```

`suggest_best_k()` suggests the best $k$ based on these statistics. The rules are as follows:

- All $k$ with Jaccard index larger than 0.95 are removed because increasing
  $k$ does not provide enough extra information. If all $k$ are removed, it is
  marked as no subgroup is detected.
- For all $k$ with 1-PAC score larger than 0.9, the maximal $k$ is taken as
  the best $k$, and other $k$ are marked as optional $k$.
- If it does not fit the second rule. The $k$ with the maximal vote of the
  highest 1-PAC score, highest mean silhouette, and highest concordance is
  taken as the best $k$.

``` r
suggest_best_k(res)
```

```
#> [1] 3
```


Following is the table of the partitions (You need to click the **show/hide
code output** link to see it). The membership matrix (columns with name `p*`)
is inferred by
[`clue::cl_consensus()`](https://www.rdocumentation.org/link/cl_consensus?package=clue)
function with the `SE` method. Basically the value in the membership matrix
represents the probability to belong to a certain group. The finall subgroup
label for an item is determined with the group with highest probability it
belongs to.

In `get_classes()` function, the entropy is calculated from the membership
matrix and the silhouette score is calculated from the consensus matrix.



<script>
$( function() {
	$( '#tabs-CV-hclust-get-classes' ).tabs();
} );
</script>
<div id='tabs-CV-hclust-get-classes'>
<ul>
<li><a href='#tab-CV-hclust-get-classes-1'>k = 2</a></li>
<li><a href='#tab-CV-hclust-get-classes-2'>k = 3</a></li>
<li><a href='#tab-CV-hclust-get-classes-3'>k = 4</a></li>
<li><a href='#tab-CV-hclust-get-classes-4'>k = 5</a></li>
<li><a href='#tab-CV-hclust-get-classes-5'>k = 6</a></li>
</ul>

<div id='tab-CV-hclust-get-classes-1'>
<p><a id='tab-CV-hclust-get-classes-1-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 2), get_membership(res, k = 2))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2
#&gt; SIH013     2   0.000      0.817 0.00 1.00
#&gt; SIH014     2   0.242      0.815 0.04 0.96
#&gt; SIH024     2   0.925      0.393 0.34 0.66
#&gt; SIH028     2   0.242      0.815 0.04 0.96
#&gt; SIH031     2   0.881      0.406 0.30 0.70
#&gt; SIH042     2   0.000      0.817 0.00 1.00
#&gt; SIH107     2   0.000      0.817 0.00 1.00
#&gt; SIH114     1   0.990      0.322 0.56 0.44
#&gt; SIH116     2   0.000      0.817 0.00 1.00
#&gt; SIH117     2   0.000      0.817 0.00 1.00
#&gt; SIH130     2   0.242      0.815 0.04 0.96
#&gt; SIH134     2   0.242      0.815 0.04 0.96
#&gt; SIH186     2   0.925      0.393 0.34 0.66
#&gt; SIH191     1   0.990      0.322 0.56 0.44
#&gt; SIH192     1   0.990      0.322 0.56 0.44
#&gt; SIH196     2   0.855      0.554 0.28 0.72
#&gt; SIH214     2   0.242      0.815 0.04 0.96
#&gt; SIH218     2   0.000      0.817 0.00 1.00
#&gt; SIH232     1   0.990      0.588 0.56 0.44
#&gt; SIH236     2   0.855      0.554 0.28 0.72
#&gt; SIH238     2   0.000      0.817 0.00 1.00
#&gt; SIH241     2   0.242      0.815 0.04 0.96
#&gt; SIH245     2   0.242      0.815 0.04 0.96
#&gt; SIH260     2   0.242      0.815 0.04 0.96
#&gt; SIH287     2   0.855      0.554 0.28 0.72
#&gt; SIH289     2   0.000      0.817 0.00 1.00
#&gt; SIH290     2   0.242      0.815 0.04 0.96
#&gt; SIH295     1   0.855      0.711 0.72 0.28
#&gt; SIH366     2   0.469      0.696 0.10 0.90
#&gt; SIH377     1   0.990      0.588 0.56 0.44
#&gt; SIH380     2   0.242      0.815 0.04 0.96
#&gt; SIH385     2   0.469      0.696 0.10 0.90
#&gt; SIH389     2   0.242      0.815 0.04 0.96
#&gt; SIH391     2   0.000      0.817 0.00 1.00
#&gt; SIH403     1   0.990      0.322 0.56 0.44
#&gt; SIH411     2   0.242      0.815 0.04 0.96
#&gt; SIH427     2   1.000     -0.408 0.50 0.50
#&gt; SIH433     2   0.000      0.817 0.00 1.00
#&gt; SIH439     2   0.000      0.817 0.00 1.00
#&gt; SIH442     1   0.855      0.711 0.72 0.28
#&gt; SIH444     2   0.000      0.817 0.00 1.00
#&gt; SIH452     2   0.000      0.817 0.00 1.00
#&gt; SIH461     2   0.000      0.817 0.00 1.00
#&gt; SIH471     2   0.904      0.021 0.32 0.68
#&gt; SIH472     2   0.242      0.815 0.04 0.96
#&gt; SIH481     1   0.855      0.711 0.72 0.28
#&gt; SIH485     2   0.242      0.815 0.04 0.96
#&gt; SIH491     2   0.242      0.815 0.04 0.96
#&gt; SIH508     2   0.925      0.393 0.34 0.66
#&gt; SIH559     1   0.855      0.711 0.72 0.28
#&gt; SIH587     2   0.971      0.267 0.40 0.60
#&gt; SIH625     2   0.855      0.554 0.28 0.72
#&gt; SIH641     2   0.827      0.337 0.26 0.74
#&gt; SIH643     2   0.925      0.393 0.34 0.66
#&gt; SIH674     1   0.855      0.711 0.72 0.28
#&gt; SIH678     1   0.855      0.711 0.72 0.28
#&gt; SIH679     2   0.855      0.554 0.28 0.72
#&gt; SIH689     2   0.000      0.817 0.00 1.00
#&gt; SIH694     2   0.000      0.817 0.00 1.00
#&gt; SIH721     2   0.000      0.817 0.00 1.00
</code></pre>

<script>
$('#tab-CV-hclust-get-classes-1-a').parent().next().next().hide();
$('#tab-CV-hclust-get-classes-1-a').click(function(){
  $('#tab-CV-hclust-get-classes-1-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-CV-hclust-get-classes-2'>
<p><a id='tab-CV-hclust-get-classes-2-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 3), get_membership(res, k = 3))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3
#&gt; SIH013     3   0.296     0.7890 0.00 0.10 0.90
#&gt; SIH014     3   0.153     0.8205 0.00 0.04 0.96
#&gt; SIH024     3   0.854     0.0644 0.10 0.38 0.52
#&gt; SIH028     3   0.429     0.7290 0.00 0.18 0.82
#&gt; SIH031     3   0.895     0.3961 0.26 0.18 0.56
#&gt; SIH042     3   0.000     0.8209 0.00 0.00 1.00
#&gt; SIH107     3   0.000     0.8209 0.00 0.00 1.00
#&gt; SIH114     2   0.988     0.4049 0.36 0.38 0.26
#&gt; SIH116     3   0.600     0.6732 0.04 0.20 0.76
#&gt; SIH117     3   0.296     0.7890 0.00 0.10 0.90
#&gt; SIH130     3   0.153     0.8205 0.00 0.04 0.96
#&gt; SIH134     3   0.153     0.8205 0.00 0.04 0.96
#&gt; SIH186     3   0.854     0.0644 0.10 0.38 0.52
#&gt; SIH191     2   0.988     0.4049 0.36 0.38 0.26
#&gt; SIH192     2   0.988     0.4049 0.36 0.38 0.26
#&gt; SIH196     2   0.000     0.5797 0.00 1.00 0.00
#&gt; SIH214     3   0.429     0.7290 0.00 0.18 0.82
#&gt; SIH218     3   0.000     0.8209 0.00 0.00 1.00
#&gt; SIH232     1   0.400     0.5742 0.84 0.00 0.16
#&gt; SIH236     2   0.000     0.5797 0.00 1.00 0.00
#&gt; SIH238     3   0.000     0.8209 0.00 0.00 1.00
#&gt; SIH241     3   0.429     0.7290 0.00 0.18 0.82
#&gt; SIH245     3   0.153     0.8205 0.00 0.04 0.96
#&gt; SIH260     3   0.153     0.8205 0.00 0.04 0.96
#&gt; SIH287     3   0.619     0.2442 0.00 0.42 0.58
#&gt; SIH289     3   0.000     0.8209 0.00 0.00 1.00
#&gt; SIH290     3   0.153     0.8205 0.00 0.04 0.96
#&gt; SIH295     1   0.540     0.5834 0.72 0.00 0.28
#&gt; SIH366     3   0.296     0.7724 0.10 0.00 0.90
#&gt; SIH377     1   0.400     0.5742 0.84 0.00 0.16
#&gt; SIH380     3   0.153     0.8205 0.00 0.04 0.96
#&gt; SIH385     3   0.296     0.7724 0.10 0.00 0.90
#&gt; SIH389     3   0.153     0.8205 0.00 0.04 0.96
#&gt; SIH391     3   0.296     0.7890 0.00 0.10 0.90
#&gt; SIH403     2   0.988     0.4049 0.36 0.38 0.26
#&gt; SIH411     3   0.153     0.8205 0.00 0.04 0.96
#&gt; SIH427     1   0.480     0.4652 0.78 0.22 0.00
#&gt; SIH433     3   0.000     0.8209 0.00 0.00 1.00
#&gt; SIH439     3   0.296     0.7890 0.00 0.10 0.90
#&gt; SIH442     1   0.000     0.6587 1.00 0.00 0.00
#&gt; SIH444     3   0.296     0.7890 0.00 0.10 0.90
#&gt; SIH452     3   0.296     0.7890 0.00 0.10 0.90
#&gt; SIH461     3   0.000     0.8209 0.00 0.00 1.00
#&gt; SIH471     3   0.571     0.3270 0.32 0.00 0.68
#&gt; SIH472     3   0.429     0.7290 0.00 0.18 0.82
#&gt; SIH481     1   0.000     0.6587 1.00 0.00 0.00
#&gt; SIH485     3   0.429     0.7290 0.00 0.18 0.82
#&gt; SIH491     3   0.153     0.8205 0.00 0.04 0.96
#&gt; SIH508     3   0.854     0.0644 0.10 0.38 0.52
#&gt; SIH559     1   0.000     0.6587 1.00 0.00 0.00
#&gt; SIH587     2   0.455     0.4535 0.20 0.80 0.00
#&gt; SIH625     2   0.000     0.5797 0.00 1.00 0.00
#&gt; SIH641     3   0.522     0.4955 0.26 0.00 0.74
#&gt; SIH643     3   0.854     0.0644 0.10 0.38 0.52
#&gt; SIH674     1   0.540     0.5834 0.72 0.00 0.28
#&gt; SIH678     1   0.540     0.5834 0.72 0.00 0.28
#&gt; SIH679     2   0.000     0.5797 0.00 1.00 0.00
#&gt; SIH689     3   0.600     0.6732 0.04 0.20 0.76
#&gt; SIH694     3   0.000     0.8209 0.00 0.00 1.00
#&gt; SIH721     3   0.000     0.8209 0.00 0.00 1.00
</code></pre>

<script>
$('#tab-CV-hclust-get-classes-2-a').parent().next().next().hide();
$('#tab-CV-hclust-get-classes-2-a').click(function(){
  $('#tab-CV-hclust-get-classes-2-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-CV-hclust-get-classes-3'>
<p><a id='tab-CV-hclust-get-classes-3-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 4), get_membership(res, k = 4))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3   p4
#&gt; SIH013     3   0.860     0.3415 0.10 0.10 0.42 0.38
#&gt; SIH014     2   0.734     0.5863 0.00 0.46 0.38 0.16
#&gt; SIH024     4   0.121     0.5045 0.00 0.00 0.04 0.96
#&gt; SIH028     2   0.317     0.5018 0.00 0.84 0.00 0.16
#&gt; SIH031     2   0.413     0.0463 0.00 0.74 0.26 0.00
#&gt; SIH042     3   0.760     0.2997 0.00 0.20 0.42 0.38
#&gt; SIH107     3   0.760     0.2997 0.00 0.20 0.42 0.38
#&gt; SIH114     4   0.380     0.2576 0.00 0.00 0.22 0.78
#&gt; SIH116     4   0.778    -0.3188 0.24 0.00 0.38 0.38
#&gt; SIH117     3   0.860     0.3415 0.10 0.10 0.42 0.38
#&gt; SIH130     2   0.734     0.5863 0.00 0.46 0.38 0.16
#&gt; SIH134     2   0.734     0.5863 0.00 0.46 0.38 0.16
#&gt; SIH186     4   0.121     0.5045 0.00 0.00 0.04 0.96
#&gt; SIH191     4   0.380     0.2576 0.00 0.00 0.22 0.78
#&gt; SIH192     4   0.380     0.2576 0.00 0.00 0.22 0.78
#&gt; SIH196     1   0.586     0.5264 0.58 0.04 0.00 0.38
#&gt; SIH214     2   0.317     0.5018 0.00 0.84 0.00 0.16
#&gt; SIH218     3   0.760     0.2997 0.00 0.20 0.42 0.38
#&gt; SIH232     1   0.789     0.1499 0.38 0.00 0.32 0.30
#&gt; SIH236     1   0.586     0.5264 0.58 0.04 0.00 0.38
#&gt; SIH238     3   0.760     0.2997 0.00 0.20 0.42 0.38
#&gt; SIH241     2   0.317     0.5018 0.00 0.84 0.00 0.16
#&gt; SIH245     2   0.734     0.5863 0.00 0.46 0.38 0.16
#&gt; SIH260     2   0.734     0.5863 0.00 0.46 0.38 0.16
#&gt; SIH287     4   0.398     0.3222 0.00 0.24 0.00 0.76
#&gt; SIH289     3   0.760     0.2997 0.00 0.20 0.42 0.38
#&gt; SIH290     2   0.734     0.5863 0.00 0.46 0.38 0.16
#&gt; SIH295     3   0.292    -0.0535 0.14 0.00 0.86 0.00
#&gt; SIH366     3   0.499     0.2724 0.00 0.00 0.52 0.48
#&gt; SIH377     1   0.789     0.1499 0.38 0.00 0.32 0.30
#&gt; SIH380     2   0.734     0.5863 0.00 0.46 0.38 0.16
#&gt; SIH385     3   0.499     0.2724 0.00 0.00 0.52 0.48
#&gt; SIH389     2   0.734     0.5863 0.00 0.46 0.38 0.16
#&gt; SIH391     3   0.860     0.3415 0.10 0.10 0.42 0.38
#&gt; SIH403     4   0.380     0.2576 0.00 0.00 0.22 0.78
#&gt; SIH411     2   0.734     0.5863 0.00 0.46 0.38 0.16
#&gt; SIH427     1   0.758     0.3709 0.60 0.16 0.20 0.04
#&gt; SIH433     3   0.760     0.2997 0.00 0.20 0.42 0.38
#&gt; SIH439     4   0.683    -0.3145 0.10 0.00 0.42 0.48
#&gt; SIH442     3   0.586    -0.3763 0.38 0.00 0.58 0.04
#&gt; SIH444     3   0.860     0.3415 0.10 0.10 0.42 0.38
#&gt; SIH452     4   0.683    -0.3145 0.10 0.00 0.42 0.48
#&gt; SIH461     3   0.760     0.2997 0.00 0.20 0.42 0.38
#&gt; SIH471     3   0.538     0.0757 0.00 0.10 0.74 0.16
#&gt; SIH472     2   0.317     0.5018 0.00 0.84 0.00 0.16
#&gt; SIH481     3   0.832    -0.4209 0.38 0.16 0.42 0.04
#&gt; SIH485     2   0.317     0.5018 0.00 0.84 0.00 0.16
#&gt; SIH491     2   0.734     0.5863 0.00 0.46 0.38 0.16
#&gt; SIH508     4   0.121     0.5045 0.00 0.00 0.04 0.96
#&gt; SIH559     3   0.586    -0.3763 0.38 0.00 0.58 0.04
#&gt; SIH587     1   0.734     0.4868 0.46 0.16 0.00 0.38
#&gt; SIH625     1   0.586     0.5264 0.58 0.04 0.00 0.38
#&gt; SIH641     3   0.452    -0.2160 0.00 0.32 0.68 0.00
#&gt; SIH643     4   0.121     0.5045 0.00 0.00 0.04 0.96
#&gt; SIH674     3   0.292    -0.0535 0.14 0.00 0.86 0.00
#&gt; SIH678     3   0.292    -0.0535 0.14 0.00 0.86 0.00
#&gt; SIH679     1   0.698     0.4914 0.58 0.18 0.00 0.24
#&gt; SIH689     3   0.778     0.2246 0.24 0.00 0.38 0.38
#&gt; SIH694     3   0.760     0.2997 0.00 0.20 0.42 0.38
#&gt; SIH721     3   0.760     0.2997 0.00 0.20 0.42 0.38
</code></pre>

<script>
$('#tab-CV-hclust-get-classes-3-a').parent().next().next().hide();
$('#tab-CV-hclust-get-classes-3-a').click(function(){
  $('#tab-CV-hclust-get-classes-3-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-CV-hclust-get-classes-4'>
<p><a id='tab-CV-hclust-get-classes-4-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 5), get_membership(res, k = 5))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3   p4   p5
#&gt; SIH013     3   0.202     0.5685 0.00 0.00 0.90 0.10 0.00
#&gt; SIH014     3   0.356     0.2899 0.00 0.00 0.74 0.26 0.00
#&gt; SIH024     1   0.675     0.4389 0.38 0.36 0.26 0.00 0.00
#&gt; SIH028     2   0.624     0.3003 0.00 0.54 0.20 0.26 0.00
#&gt; SIH031     2   0.807    -0.0684 0.00 0.38 0.10 0.26 0.26
#&gt; SIH042     3   0.000     0.6059 0.00 0.00 1.00 0.00 0.00
#&gt; SIH107     3   0.000     0.6059 0.00 0.00 1.00 0.00 0.00
#&gt; SIH114     2   0.413    -0.2290 0.38 0.62 0.00 0.00 0.00
#&gt; SIH116     3   0.410     0.4455 0.04 0.00 0.76 0.20 0.00
#&gt; SIH117     3   0.202     0.5685 0.00 0.00 0.90 0.10 0.00
#&gt; SIH130     3   0.418    -0.0172 0.00 0.00 0.60 0.40 0.00
#&gt; SIH134     3   0.356     0.2899 0.00 0.00 0.74 0.26 0.00
#&gt; SIH186     1   0.675     0.4389 0.38 0.36 0.26 0.00 0.00
#&gt; SIH191     2   0.413    -0.2290 0.38 0.62 0.00 0.00 0.00
#&gt; SIH192     2   0.413    -0.2290 0.38 0.62 0.00 0.00 0.00
#&gt; SIH196     1   0.104     0.5247 0.96 0.00 0.00 0.04 0.00
#&gt; SIH214     2   0.624     0.3003 0.00 0.54 0.20 0.26 0.00
#&gt; SIH218     3   0.000     0.6059 0.00 0.00 1.00 0.00 0.00
#&gt; SIH232     5   0.659     0.4334 0.00 0.30 0.00 0.24 0.46
#&gt; SIH236     1   0.104     0.5247 0.96 0.00 0.00 0.04 0.00
#&gt; SIH238     3   0.000     0.6059 0.00 0.00 1.00 0.00 0.00
#&gt; SIH241     2   0.624     0.3003 0.00 0.54 0.20 0.26 0.00
#&gt; SIH245     3   0.418    -0.0172 0.00 0.00 0.60 0.40 0.00
#&gt; SIH260     3   0.356     0.2899 0.00 0.00 0.74 0.26 0.00
#&gt; SIH287     3   0.505     0.0322 0.38 0.00 0.58 0.04 0.00
#&gt; SIH289     3   0.000     0.6059 0.00 0.00 1.00 0.00 0.00
#&gt; SIH290     3   0.356     0.2899 0.00 0.00 0.74 0.26 0.00
#&gt; SIH295     5   0.342     0.2631 0.00 0.00 0.24 0.00 0.76
#&gt; SIH366     3   0.628     0.2601 0.00 0.10 0.66 0.14 0.10
#&gt; SIH377     5   0.659     0.4334 0.00 0.30 0.00 0.24 0.46
#&gt; SIH380     3   0.418    -0.0172 0.00 0.00 0.60 0.40 0.00
#&gt; SIH385     3   0.628     0.2601 0.00 0.10 0.66 0.14 0.10
#&gt; SIH389     3   0.356     0.2899 0.00 0.00 0.74 0.26 0.00
#&gt; SIH391     3   0.202     0.5685 0.00 0.00 0.90 0.10 0.00
#&gt; SIH403     2   0.413    -0.2290 0.38 0.62 0.00 0.00 0.00
#&gt; SIH411     3   0.418    -0.0172 0.00 0.00 0.60 0.40 0.00
#&gt; SIH427     5   0.665     0.4132 0.22 0.04 0.00 0.16 0.58
#&gt; SIH433     3   0.000     0.6059 0.00 0.00 1.00 0.00 0.00
#&gt; SIH439     3   0.526     0.3289 0.00 0.10 0.66 0.24 0.00
#&gt; SIH442     5   0.104     0.5817 0.00 0.04 0.00 0.00 0.96
#&gt; SIH444     3   0.202     0.5685 0.00 0.00 0.90 0.10 0.00
#&gt; SIH452     3   0.526     0.3289 0.00 0.10 0.66 0.24 0.00
#&gt; SIH461     3   0.000     0.6059 0.00 0.00 1.00 0.00 0.00
#&gt; SIH471     3   0.620    -0.3371 0.00 0.16 0.52 0.00 0.32
#&gt; SIH472     2   0.624     0.3003 0.00 0.54 0.20 0.26 0.00
#&gt; SIH481     5   0.596     0.4562 0.00 0.26 0.00 0.16 0.58
#&gt; SIH485     2   0.624     0.3003 0.00 0.54 0.20 0.26 0.00
#&gt; SIH491     3   0.356     0.2899 0.00 0.00 0.74 0.26 0.00
#&gt; SIH508     1   0.675     0.4389 0.38 0.36 0.26 0.00 0.00
#&gt; SIH559     5   0.104     0.5817 0.00 0.04 0.00 0.00 0.96
#&gt; SIH587     1   0.356     0.4516 0.74 0.00 0.00 0.26 0.00
#&gt; SIH625     1   0.104     0.5247 0.96 0.00 0.00 0.04 0.00
#&gt; SIH641     4   0.681     0.0000 0.00 0.00 0.34 0.36 0.30
#&gt; SIH643     1   0.675     0.4389 0.38 0.36 0.26 0.00 0.00
#&gt; SIH674     5   0.342     0.2631 0.00 0.00 0.24 0.00 0.76
#&gt; SIH678     5   0.342     0.2631 0.00 0.00 0.24 0.00 0.76
#&gt; SIH679     1   0.352     0.3929 0.82 0.14 0.00 0.04 0.00
#&gt; SIH689     3   0.410     0.4455 0.04 0.00 0.76 0.20 0.00
#&gt; SIH694     3   0.000     0.6059 0.00 0.00 1.00 0.00 0.00
#&gt; SIH721     3   0.000     0.6059 0.00 0.00 1.00 0.00 0.00
</code></pre>

<script>
$('#tab-CV-hclust-get-classes-4-a').parent().next().next().hide();
$('#tab-CV-hclust-get-classes-4-a').click(function(){
  $('#tab-CV-hclust-get-classes-4-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-CV-hclust-get-classes-5'>
<p><a id='tab-CV-hclust-get-classes-5-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 6), get_membership(res, k = 6))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3   p4   p5   p6
#&gt; SIH013     3  0.1814    0.61372 0.00 0.00 0.90 0.10 0.00 0.00
#&gt; SIH014     3  0.3821    0.42786 0.00 0.22 0.74 0.04 0.00 0.00
#&gt; SIH024     1  0.5876    0.52626 0.48 0.00 0.26 0.26 0.00 0.00
#&gt; SIH028     2  0.5027    0.91865 0.00 0.64 0.20 0.16 0.00 0.00
#&gt; SIH031     2  0.4834    0.55227 0.00 0.64 0.10 0.00 0.26 0.00
#&gt; SIH042     3  0.0000    0.67488 0.00 0.00 1.00 0.00 0.00 0.00
#&gt; SIH107     3  0.0000    0.67488 0.00 0.00 1.00 0.00 0.00 0.00
#&gt; SIH114     1  0.5876    0.51047 0.48 0.00 0.00 0.26 0.00 0.26
#&gt; SIH116     3  0.5669    0.37650 0.04 0.26 0.60 0.10 0.00 0.00
#&gt; SIH117     3  0.1814    0.61372 0.00 0.00 0.90 0.10 0.00 0.00
#&gt; SIH130     4  0.5945    0.44788 0.00 0.22 0.36 0.42 0.00 0.00
#&gt; SIH134     3  0.4534    0.29662 0.00 0.38 0.58 0.04 0.00 0.00
#&gt; SIH186     1  0.5876    0.52626 0.48 0.00 0.26 0.26 0.00 0.00
#&gt; SIH191     1  0.5876    0.51047 0.48 0.00 0.00 0.26 0.00 0.26
#&gt; SIH192     1  0.5876    0.51047 0.48 0.00 0.00 0.26 0.00 0.26
#&gt; SIH196     1  0.2728    0.40184 0.86 0.10 0.00 0.04 0.00 0.00
#&gt; SIH214     2  0.5027    0.91865 0.00 0.64 0.20 0.16 0.00 0.00
#&gt; SIH218     3  0.0000    0.67488 0.00 0.00 1.00 0.00 0.00 0.00
#&gt; SIH232     6  0.5569    0.48120 0.00 0.00 0.00 0.16 0.32 0.52
#&gt; SIH236     1  0.2260    0.39911 0.86 0.14 0.00 0.00 0.00 0.00
#&gt; SIH238     3  0.0000    0.67488 0.00 0.00 1.00 0.00 0.00 0.00
#&gt; SIH241     2  0.5027    0.91865 0.00 0.64 0.20 0.16 0.00 0.00
#&gt; SIH245     4  0.5945    0.44788 0.00 0.22 0.36 0.42 0.00 0.00
#&gt; SIH260     3  0.4534    0.29662 0.00 0.38 0.58 0.04 0.00 0.00
#&gt; SIH287     3  0.4534   -0.00184 0.38 0.00 0.58 0.04 0.00 0.00
#&gt; SIH289     3  0.0000    0.67488 0.00 0.00 1.00 0.00 0.00 0.00
#&gt; SIH290     3  0.3821    0.42786 0.00 0.22 0.74 0.04 0.00 0.00
#&gt; SIH295     5  0.3076    0.59075 0.00 0.00 0.00 0.24 0.76 0.00
#&gt; SIH366     4  0.5285    0.48710 0.00 0.00 0.42 0.48 0.10 0.00
#&gt; SIH377     6  0.5569    0.48120 0.00 0.00 0.00 0.16 0.32 0.52
#&gt; SIH380     4  0.5945    0.44788 0.00 0.22 0.36 0.42 0.00 0.00
#&gt; SIH385     4  0.5285    0.48710 0.00 0.00 0.42 0.48 0.10 0.00
#&gt; SIH389     3  0.4534    0.29662 0.00 0.38 0.58 0.04 0.00 0.00
#&gt; SIH391     3  0.1814    0.61372 0.00 0.00 0.90 0.10 0.00 0.00
#&gt; SIH403     1  0.5876    0.51047 0.48 0.00 0.00 0.26 0.00 0.26
#&gt; SIH411     4  0.5945    0.44788 0.00 0.22 0.36 0.42 0.00 0.00
#&gt; SIH427     5  0.5841   -0.11252 0.00 0.00 0.00 0.22 0.48 0.30
#&gt; SIH433     3  0.0000    0.67488 0.00 0.00 1.00 0.00 0.00 0.00
#&gt; SIH439     4  0.3797    0.45071 0.00 0.00 0.42 0.58 0.00 0.00
#&gt; SIH442     5  0.0937    0.44581 0.00 0.00 0.00 0.00 0.96 0.04
#&gt; SIH444     3  0.1814    0.61372 0.00 0.00 0.90 0.10 0.00 0.00
#&gt; SIH452     4  0.3797    0.45071 0.00 0.00 0.42 0.58 0.00 0.00
#&gt; SIH461     3  0.0000    0.67488 0.00 0.00 1.00 0.00 0.00 0.00
#&gt; SIH471     3  0.5569    0.13157 0.00 0.00 0.52 0.16 0.32 0.00
#&gt; SIH472     2  0.5027    0.91865 0.00 0.64 0.20 0.16 0.00 0.00
#&gt; SIH481     6  0.3864   -0.20313 0.00 0.00 0.00 0.00 0.48 0.52
#&gt; SIH485     2  0.5027    0.91865 0.00 0.64 0.20 0.16 0.00 0.00
#&gt; SIH491     3  0.3821    0.42786 0.00 0.22 0.74 0.04 0.00 0.00
#&gt; SIH508     1  0.5876    0.52626 0.48 0.00 0.26 0.26 0.00 0.00
#&gt; SIH559     5  0.0937    0.44581 0.00 0.00 0.00 0.00 0.96 0.04
#&gt; SIH587     1  0.7326    0.23838 0.42 0.20 0.00 0.22 0.00 0.16
#&gt; SIH625     1  0.2728    0.40184 0.86 0.10 0.00 0.04 0.00 0.00
#&gt; SIH641     4  0.7212    0.10829 0.00 0.22 0.10 0.38 0.30 0.00
#&gt; SIH643     1  0.5876    0.52626 0.48 0.00 0.26 0.26 0.00 0.00
#&gt; SIH674     5  0.3076    0.59075 0.00 0.00 0.00 0.24 0.76 0.00
#&gt; SIH678     5  0.3076    0.59075 0.00 0.00 0.00 0.24 0.76 0.00
#&gt; SIH679     1  0.3309    0.24936 0.72 0.28 0.00 0.00 0.00 0.00
#&gt; SIH689     3  0.5669    0.37650 0.04 0.26 0.60 0.10 0.00 0.00
#&gt; SIH694     3  0.0000    0.67488 0.00 0.00 1.00 0.00 0.00 0.00
#&gt; SIH721     3  0.0000    0.67488 0.00 0.00 1.00 0.00 0.00 0.00
</code></pre>

<script>
$('#tab-CV-hclust-get-classes-5-a').parent().next().next().hide();
$('#tab-CV-hclust-get-classes-5-a').click(function(){
  $('#tab-CV-hclust-get-classes-5-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>
</div>

Heatmaps for the consensus matrix. It visualizes the probability of two
samples to be in a same group.




<script>
$( function() {
	$( '#tabs-CV-hclust-consensus-heatmap' ).tabs();
} );
</script>
<div id='tabs-CV-hclust-consensus-heatmap'>
<ul>
<li><a href='#tab-CV-hclust-consensus-heatmap-1'>k = 2</a></li>
<li><a href='#tab-CV-hclust-consensus-heatmap-2'>k = 3</a></li>
<li><a href='#tab-CV-hclust-consensus-heatmap-3'>k = 4</a></li>
<li><a href='#tab-CV-hclust-consensus-heatmap-4'>k = 5</a></li>
<li><a href='#tab-CV-hclust-consensus-heatmap-5'>k = 6</a></li>
</ul>
<div id='tab-CV-hclust-consensus-heatmap-1'>
<pre><code class="language-r">consensus_heatmap(res, k = 2)
</code></pre>
<p><img src="figure_cola/tab-CV-hclust-consensus-heatmap-1-1.png" alt="plot of chunk tab-CV-hclust-consensus-heatmap-1" /></p>

</div>
<div id='tab-CV-hclust-consensus-heatmap-2'>
<pre><code class="language-r">consensus_heatmap(res, k = 3)
</code></pre>
<p><img src="figure_cola/tab-CV-hclust-consensus-heatmap-2-1.png" alt="plot of chunk tab-CV-hclust-consensus-heatmap-2" /></p>

</div>
<div id='tab-CV-hclust-consensus-heatmap-3'>
<pre><code class="language-r">consensus_heatmap(res, k = 4)
</code></pre>
<p><img src="figure_cola/tab-CV-hclust-consensus-heatmap-3-1.png" alt="plot of chunk tab-CV-hclust-consensus-heatmap-3" /></p>

</div>
<div id='tab-CV-hclust-consensus-heatmap-4'>
<pre><code class="language-r">consensus_heatmap(res, k = 5)
</code></pre>
<p><img src="figure_cola/tab-CV-hclust-consensus-heatmap-4-1.png" alt="plot of chunk tab-CV-hclust-consensus-heatmap-4" /></p>

</div>
<div id='tab-CV-hclust-consensus-heatmap-5'>
<pre><code class="language-r">consensus_heatmap(res, k = 6)
</code></pre>
<p><img src="figure_cola/tab-CV-hclust-consensus-heatmap-5-1.png" alt="plot of chunk tab-CV-hclust-consensus-heatmap-5" /></p>

</div>
</div>

Heatmaps for the membership of samples in all partitions to see how consistent they are:





<script>
$( function() {
	$( '#tabs-CV-hclust-membership-heatmap' ).tabs();
} );
</script>
<div id='tabs-CV-hclust-membership-heatmap'>
<ul>
<li><a href='#tab-CV-hclust-membership-heatmap-1'>k = 2</a></li>
<li><a href='#tab-CV-hclust-membership-heatmap-2'>k = 3</a></li>
<li><a href='#tab-CV-hclust-membership-heatmap-3'>k = 4</a></li>
<li><a href='#tab-CV-hclust-membership-heatmap-4'>k = 5</a></li>
<li><a href='#tab-CV-hclust-membership-heatmap-5'>k = 6</a></li>
</ul>
<div id='tab-CV-hclust-membership-heatmap-1'>
<pre><code class="language-r">membership_heatmap(res, k = 2)
</code></pre>
<p><img src="figure_cola/tab-CV-hclust-membership-heatmap-1-1.png" alt="plot of chunk tab-CV-hclust-membership-heatmap-1" /></p>

</div>
<div id='tab-CV-hclust-membership-heatmap-2'>
<pre><code class="language-r">membership_heatmap(res, k = 3)
</code></pre>
<p><img src="figure_cola/tab-CV-hclust-membership-heatmap-2-1.png" alt="plot of chunk tab-CV-hclust-membership-heatmap-2" /></p>

</div>
<div id='tab-CV-hclust-membership-heatmap-3'>
<pre><code class="language-r">membership_heatmap(res, k = 4)
</code></pre>
<p><img src="figure_cola/tab-CV-hclust-membership-heatmap-3-1.png" alt="plot of chunk tab-CV-hclust-membership-heatmap-3" /></p>

</div>
<div id='tab-CV-hclust-membership-heatmap-4'>
<pre><code class="language-r">membership_heatmap(res, k = 5)
</code></pre>
<p><img src="figure_cola/tab-CV-hclust-membership-heatmap-4-1.png" alt="plot of chunk tab-CV-hclust-membership-heatmap-4" /></p>

</div>
<div id='tab-CV-hclust-membership-heatmap-5'>
<pre><code class="language-r">membership_heatmap(res, k = 6)
</code></pre>
<p><img src="figure_cola/tab-CV-hclust-membership-heatmap-5-1.png" alt="plot of chunk tab-CV-hclust-membership-heatmap-5" /></p>

</div>
</div>

As soon as the classes for columns are determined, the signatures
that are significantly different between subgroups can be looked for. 
Following are the heatmaps for signatures.




Signature heatmaps where rows are scaled:



<script>
$( function() {
	$( '#tabs-CV-hclust-get-signatures' ).tabs();
} );
</script>
<div id='tabs-CV-hclust-get-signatures'>
<ul>
<li><a href='#tab-CV-hclust-get-signatures-1'>k = 2</a></li>
<li><a href='#tab-CV-hclust-get-signatures-2'>k = 3</a></li>
<li><a href='#tab-CV-hclust-get-signatures-3'>k = 4</a></li>
<li><a href='#tab-CV-hclust-get-signatures-4'>k = 5</a></li>
<li><a href='#tab-CV-hclust-get-signatures-5'>k = 6</a></li>
</ul>
<div id='tab-CV-hclust-get-signatures-1'>
<pre><code class="language-r">get_signatures(res, k = 2)
</code></pre>
<p><img src="figure_cola/tab-CV-hclust-get-signatures-1-1.png" alt="plot of chunk tab-CV-hclust-get-signatures-1" /></p>

</div>
<div id='tab-CV-hclust-get-signatures-2'>
<pre><code class="language-r">get_signatures(res, k = 3)
</code></pre>
<p><img src="figure_cola/tab-CV-hclust-get-signatures-2-1.png" alt="plot of chunk tab-CV-hclust-get-signatures-2" /></p>

</div>
<div id='tab-CV-hclust-get-signatures-3'>
<pre><code class="language-r">get_signatures(res, k = 4)
</code></pre>
<p><img src="figure_cola/tab-CV-hclust-get-signatures-3-1.png" alt="plot of chunk tab-CV-hclust-get-signatures-3" /></p>

</div>
<div id='tab-CV-hclust-get-signatures-4'>
<pre><code class="language-r">get_signatures(res, k = 5)
</code></pre>
<p><img src="figure_cola/tab-CV-hclust-get-signatures-4-1.png" alt="plot of chunk tab-CV-hclust-get-signatures-4" /></p>

</div>
<div id='tab-CV-hclust-get-signatures-5'>
<pre><code class="language-r">get_signatures(res, k = 6)
</code></pre>
<p><img src="figure_cola/tab-CV-hclust-get-signatures-5-1.png" alt="plot of chunk tab-CV-hclust-get-signatures-5" /></p>

</div>
</div>



Signature heatmaps where rows are not scaled:


<script>
$( function() {
	$( '#tabs-CV-hclust-get-signatures-no-scale' ).tabs();
} );
</script>
<div id='tabs-CV-hclust-get-signatures-no-scale'>
<ul>
<li><a href='#tab-CV-hclust-get-signatures-no-scale-1'>k = 2</a></li>
<li><a href='#tab-CV-hclust-get-signatures-no-scale-2'>k = 3</a></li>
<li><a href='#tab-CV-hclust-get-signatures-no-scale-3'>k = 4</a></li>
<li><a href='#tab-CV-hclust-get-signatures-no-scale-4'>k = 5</a></li>
<li><a href='#tab-CV-hclust-get-signatures-no-scale-5'>k = 6</a></li>
</ul>
<div id='tab-CV-hclust-get-signatures-no-scale-1'>
<pre><code class="language-r">get_signatures(res, k = 2, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-CV-hclust-get-signatures-no-scale-1-1.png" alt="plot of chunk tab-CV-hclust-get-signatures-no-scale-1" /></p>

</div>
<div id='tab-CV-hclust-get-signatures-no-scale-2'>
<pre><code class="language-r">get_signatures(res, k = 3, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-CV-hclust-get-signatures-no-scale-2-1.png" alt="plot of chunk tab-CV-hclust-get-signatures-no-scale-2" /></p>

</div>
<div id='tab-CV-hclust-get-signatures-no-scale-3'>
<pre><code class="language-r">get_signatures(res, k = 4, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-CV-hclust-get-signatures-no-scale-3-1.png" alt="plot of chunk tab-CV-hclust-get-signatures-no-scale-3" /></p>

</div>
<div id='tab-CV-hclust-get-signatures-no-scale-4'>
<pre><code class="language-r">get_signatures(res, k = 5, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-CV-hclust-get-signatures-no-scale-4-1.png" alt="plot of chunk tab-CV-hclust-get-signatures-no-scale-4" /></p>

</div>
<div id='tab-CV-hclust-get-signatures-no-scale-5'>
<pre><code class="language-r">get_signatures(res, k = 6, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-CV-hclust-get-signatures-no-scale-5-1.png" alt="plot of chunk tab-CV-hclust-get-signatures-no-scale-5" /></p>

</div>
</div>



Compare the overlap of signatures from different k:

``` r
compare_signatures(res)
```

![plot of chunk CV-hclust-signature_compare](figure_cola/CV-hclust-signature_compare-1.png)

`get_signature()` returns a data frame invisibly. To get the list of signatures, the function
call should be assigned to a variable explicitly. In following code, if `plot` argument is set
to `FALSE`, no heatmap is plotted while only the differential analysis is performed.

``` r
# code only for demonstration
tb = get_signature(res, k = ..., plot = FALSE)
```

An example of the output of `tb` is:

```
#>   which_row         fdr    mean_1    mean_2 scaled_mean_1 scaled_mean_2 km
#> 1        38 0.042760348  8.373488  9.131774    -0.5533452     0.5164555  1
#> 2        40 0.018707592  7.106213  8.469186    -0.6173731     0.5762149  1
#> 3        55 0.019134737 10.221463 11.207825    -0.6159697     0.5749050  1
#> 4        59 0.006059896  5.921854  7.869574    -0.6899429     0.6439467  1
#> 5        60 0.018055526  8.928898 10.211722    -0.6204761     0.5791110  1
#> 6        98 0.009384629 15.714769 14.887706     0.6635654    -0.6193277  2
...
```

The columns in `tb` are:

1. `which_row`: row indices corresponding to the input matrix.
2. `fdr`: FDR for the differential test. 
3. `mean_x`: The mean value in group x.
4. `scaled_mean_x`: The mean value in group x after rows are scaled.
5. `km`: Row groups if k-means clustering is applied to rows (which is done by automatically selecting number of clusters).

If there are too many signatures, `top_signatures = ...` can be set to only show the 
signatures with the highest FDRs:

``` r
# code only for demonstration
# e.g. to show the top 500 most significant rows
tb = get_signature(res, k = ..., top_signatures = 500)
```

If the signatures are defined as these which are uniquely high in current group, `diff_method` argument
can be set to `"uniquely_high_in_one_group"`:

``` r
# code only for demonstration
tb = get_signature(res, k = ..., diff_method = "uniquely_high_in_one_group")
```




UMAP plot which shows how samples are separated.


<script>
$( function() {
	$( '#tabs-CV-hclust-dimension-reduction' ).tabs();
} );
</script>
<div id='tabs-CV-hclust-dimension-reduction'>
<ul>
<li><a href='#tab-CV-hclust-dimension-reduction-1'>k = 2</a></li>
<li><a href='#tab-CV-hclust-dimension-reduction-2'>k = 3</a></li>
<li><a href='#tab-CV-hclust-dimension-reduction-3'>k = 4</a></li>
<li><a href='#tab-CV-hclust-dimension-reduction-4'>k = 5</a></li>
<li><a href='#tab-CV-hclust-dimension-reduction-5'>k = 6</a></li>
</ul>
<div id='tab-CV-hclust-dimension-reduction-1'>
<pre><code class="language-r">dimension_reduction(res, k = 2, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-CV-hclust-dimension-reduction-1-1.png" alt="plot of chunk tab-CV-hclust-dimension-reduction-1" /></p>

</div>
<div id='tab-CV-hclust-dimension-reduction-2'>
<pre><code class="language-r">dimension_reduction(res, k = 3, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-CV-hclust-dimension-reduction-2-1.png" alt="plot of chunk tab-CV-hclust-dimension-reduction-2" /></p>

</div>
<div id='tab-CV-hclust-dimension-reduction-3'>
<pre><code class="language-r">dimension_reduction(res, k = 4, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-CV-hclust-dimension-reduction-3-1.png" alt="plot of chunk tab-CV-hclust-dimension-reduction-3" /></p>

</div>
<div id='tab-CV-hclust-dimension-reduction-4'>
<pre><code class="language-r">dimension_reduction(res, k = 5, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-CV-hclust-dimension-reduction-4-1.png" alt="plot of chunk tab-CV-hclust-dimension-reduction-4" /></p>

</div>
<div id='tab-CV-hclust-dimension-reduction-5'>
<pre><code class="language-r">dimension_reduction(res, k = 6, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-CV-hclust-dimension-reduction-5-1.png" alt="plot of chunk tab-CV-hclust-dimension-reduction-5" /></p>

</div>
</div>



Following heatmap shows how subgroups are split when increasing `k`:

``` r
collect_classes(res)
```

![plot of chunk CV-hclust-collect-classes](figure_cola/CV-hclust-collect-classes-1.png)



If matrix rows can be associated to genes, consider to use `functional_enrichment(res,
...)` to perform function enrichment for the signature genes. See [this vignette](https://jokergoo.github.io/cola_vignettes/functional_enrichment.html) for more detailed explanations.


 

---------------------------------------------------



### CV:kmeans






The object with results only for a single top-value method and a single partitioning method 
can be extracted as:

``` r
res = res_list["CV", "kmeans"]
# you can also extract it by
# res = res_list["CV:kmeans"]
```

A summary of `res` and all the functions that can be applied to it:

``` r
res
```

```
#> A 'ConsensusPartition' object with k = 2, 3, 4, 5, 6.
#>   On a matrix with 1900 rows and 60 columns.
#>   Top rows (7) are extracted by 'CV' method.
#>   Subgroups are detected by 'kmeans' method.
#>   Performed in total 250 partitions by row resampling.
#>   Best k for subgroups seems to be 4.
#> 
#> Following methods can be applied to this 'ConsensusPartition' object:
#>  [1] "cola_report"             "collect_classes"         "collect_plots"          
#>  [4] "collect_stats"           "colnames"                "compare_partitions"     
#>  [7] "compare_signatures"      "consensus_heatmap"       "dimension_reduction"    
#> [10] "functional_enrichment"   "get_anno_col"            "get_anno"               
#> [13] "get_classes"             "get_consensus"           "get_matrix"             
#> [16] "get_membership"          "get_param"               "get_signatures"         
#> [19] "get_stats"               "is_best_k"               "is_stable_k"            
#> [22] "membership_heatmap"      "ncol"                    "nrow"                   
#> [25] "plot_ecdf"               "predict_classes"         "rownames"               
#> [28] "select_partition_number" "show"                    "suggest_best_k"         
#> [31] "test_to_known_factors"   "top_rows_heatmap"
```

`collect_plots()` function collects all the plots made from `res` for all `k` (number of subgroups)
into one single page to provide an easy and fast comparison between different `k`.

``` r
collect_plots(res)
```

![plot of chunk CV-kmeans-collect-plots](figure_cola/CV-kmeans-collect-plots-1.png)

The plots are:

- The first row: a plot of the eCDF (empirical cumulative distribution
  function) curves of the consensus matrix for each `k` and the heatmap of
  predicted classes for each `k`.
- The second row: heatmaps of the consensus matrix for each `k`.
- The third row: heatmaps of the membership matrix for each `k`.
- The fouth row: heatmaps of the signatures for each `k`.

All the plots in panels can be made by individual functions and they are
plotted later in this section.

`select_partition_number()` produces several plots showing different
statistics for choosing "optimized" `k`. There are following statistics:

- eCDF curves of the consensus matrix for each `k`;
- 1-PAC. [The PAC score](https://en.wikipedia.org/wiki/Consensus_clustering#Over-interpretation_potential_of_consensus_clustering)
  measures the proportion of the ambiguous subgrouping.
- Mean silhouette score.
- Concordance. The mean probability of fiting the consensus subgroup labels in all
  partitions.
- Area increased. Denote $A_k$ as the area under the eCDF curve for current
  `k`, the area increased is defined as $A_k - A_{k-1}$.
- Rand index. The percent of pairs of samples that are both in a same cluster
  or both are not in a same cluster in the partition of k and k-1.
- Jaccard index. The ratio of pairs of samples are both in a same cluster in
  the partition of k and k-1 and the pairs of samples are both in a same
  cluster in the partition k or k-1.

The detailed explanations of these statistics can be found in [the _cola_
vignette](https://jokergoo.github.io/cola_vignettes/cola.html#toc_13).

Generally speaking, higher 1-PAC score, higher mean silhouette score or higher
concordance corresponds to better partition. Rand index and Jaccard index
measure how similar the current partition is compared to partition with `k-1`.
If they are too similar, we won't accept `k` is better than `k-1`.

``` r
select_partition_number(res)
```

![plot of chunk CV-kmeans-select-partition-number](figure_cola/CV-kmeans-select-partition-number-1.png)

The numeric values for all these statistics can be obtained by `get_stats()`.

``` r
get_stats(res)
```

```
#>   k 1-PAC mean_silhouette concordance area_increased  Rand Jaccard
#> 2 2 0.130           0.650       0.793         0.4118 0.573   0.573
#> 3 3 0.241           0.297       0.593         0.4939 0.726   0.545
#> 4 4 0.378           0.540       0.725         0.1341 0.697   0.356
#> 5 5 0.452           0.431       0.619         0.0895 0.870   0.594
#> 6 6 0.566           0.381       0.645         0.0594 0.956   0.820
```

`suggest_best_k()` suggests the best $k$ based on these statistics. The rules are as follows:

- All $k$ with Jaccard index larger than 0.95 are removed because increasing
  $k$ does not provide enough extra information. If all $k$ are removed, it is
  marked as no subgroup is detected.
- For all $k$ with 1-PAC score larger than 0.9, the maximal $k$ is taken as
  the best $k$, and other $k$ are marked as optional $k$.
- If it does not fit the second rule. The $k$ with the maximal vote of the
  highest 1-PAC score, highest mean silhouette, and highest concordance is
  taken as the best $k$.

``` r
suggest_best_k(res)
```

```
#> [1] 4
```


Following is the table of the partitions (You need to click the **show/hide
code output** link to see it). The membership matrix (columns with name `p*`)
is inferred by
[`clue::cl_consensus()`](https://www.rdocumentation.org/link/cl_consensus?package=clue)
function with the `SE` method. Basically the value in the membership matrix
represents the probability to belong to a certain group. The finall subgroup
label for an item is determined with the group with highest probability it
belongs to.

In `get_classes()` function, the entropy is calculated from the membership
matrix and the silhouette score is calculated from the consensus matrix.



<script>
$( function() {
	$( '#tabs-CV-kmeans-get-classes' ).tabs();
} );
</script>
<div id='tabs-CV-kmeans-get-classes'>
<ul>
<li><a href='#tab-CV-kmeans-get-classes-1'>k = 2</a></li>
<li><a href='#tab-CV-kmeans-get-classes-2'>k = 3</a></li>
<li><a href='#tab-CV-kmeans-get-classes-3'>k = 4</a></li>
<li><a href='#tab-CV-kmeans-get-classes-4'>k = 5</a></li>
<li><a href='#tab-CV-kmeans-get-classes-5'>k = 6</a></li>
</ul>

<div id='tab-CV-kmeans-get-classes-1'>
<p><a id='tab-CV-kmeans-get-classes-1-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 2), get_membership(res, k = 2))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2
#&gt; SIH013     2   0.855      0.724 0.28 0.72
#&gt; SIH014     2   0.000      0.733 0.00 1.00
#&gt; SIH024     2   0.760      0.705 0.22 0.78
#&gt; SIH028     2   0.242      0.712 0.04 0.96
#&gt; SIH031     2   0.795      0.367 0.24 0.76
#&gt; SIH042     2   0.680      0.740 0.18 0.82
#&gt; SIH107     2   0.680      0.740 0.18 0.82
#&gt; SIH114     1   0.958      0.557 0.62 0.38
#&gt; SIH116     2   0.904      0.691 0.32 0.68
#&gt; SIH117     2   0.855      0.724 0.28 0.72
#&gt; SIH130     2   0.584      0.687 0.14 0.86
#&gt; SIH134     2   0.529      0.684 0.12 0.88
#&gt; SIH186     2   0.760      0.705 0.22 0.78
#&gt; SIH191     1   0.958      0.557 0.62 0.38
#&gt; SIH192     1   0.958      0.557 0.62 0.38
#&gt; SIH196     2   0.760      0.581 0.22 0.78
#&gt; SIH214     2   0.242      0.712 0.04 0.96
#&gt; SIH218     2   0.680      0.740 0.18 0.82
#&gt; SIH232     1   0.827      0.683 0.74 0.26
#&gt; SIH236     1   0.925      0.477 0.66 0.34
#&gt; SIH238     2   0.680      0.740 0.18 0.82
#&gt; SIH241     2   0.722      0.716 0.20 0.80
#&gt; SIH245     2   0.327      0.713 0.06 0.94
#&gt; SIH260     2   0.680      0.665 0.18 0.82
#&gt; SIH287     2   0.402      0.691 0.08 0.92
#&gt; SIH289     2   0.680      0.740 0.18 0.82
#&gt; SIH290     2   0.000      0.733 0.00 1.00
#&gt; SIH295     1   0.795      0.688 0.76 0.24
#&gt; SIH366     1   0.981      0.403 0.58 0.42
#&gt; SIH377     1   0.722      0.700 0.80 0.20
#&gt; SIH380     2   0.242      0.728 0.04 0.96
#&gt; SIH385     2   0.722      0.729 0.20 0.80
#&gt; SIH389     2   0.529      0.684 0.12 0.88
#&gt; SIH391     2   0.855      0.724 0.28 0.72
#&gt; SIH403     1   0.958      0.557 0.62 0.38
#&gt; SIH411     2   0.634      0.679 0.16 0.84
#&gt; SIH427     1   0.141      0.630 0.98 0.02
#&gt; SIH433     2   0.680      0.740 0.18 0.82
#&gt; SIH439     1   0.958      0.240 0.62 0.38
#&gt; SIH442     1   0.680      0.698 0.82 0.18
#&gt; SIH444     2   0.855      0.724 0.28 0.72
#&gt; SIH452     2   0.881      0.715 0.30 0.70
#&gt; SIH461     2   0.680      0.740 0.18 0.82
#&gt; SIH471     2   0.760      0.705 0.22 0.78
#&gt; SIH472     2   0.722      0.716 0.20 0.80
#&gt; SIH481     1   0.584      0.680 0.86 0.14
#&gt; SIH485     2   0.242      0.712 0.04 0.96
#&gt; SIH491     2   0.000      0.733 0.00 1.00
#&gt; SIH508     2   0.760      0.705 0.22 0.78
#&gt; SIH559     1   0.680      0.698 0.82 0.18
#&gt; SIH587     1   0.827      0.539 0.74 0.26
#&gt; SIH625     2   0.680      0.630 0.18 0.82
#&gt; SIH641     2   0.971     -0.212 0.40 0.60
#&gt; SIH643     2   0.760      0.705 0.22 0.78
#&gt; SIH674     1   0.795      0.688 0.76 0.24
#&gt; SIH678     1   0.795      0.688 0.76 0.24
#&gt; SIH679     1   0.981      0.369 0.58 0.42
#&gt; SIH689     2   0.925      0.684 0.34 0.66
#&gt; SIH694     2   0.680      0.740 0.18 0.82
#&gt; SIH721     2   0.680      0.740 0.18 0.82
</code></pre>

<script>
$('#tab-CV-kmeans-get-classes-1-a').parent().next().next().hide();
$('#tab-CV-kmeans-get-classes-1-a').click(function(){
  $('#tab-CV-kmeans-get-classes-1-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-CV-kmeans-get-classes-2'>
<p><a id='tab-CV-kmeans-get-classes-2-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 3), get_membership(res, k = 3))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3
#&gt; SIH013     3   0.583     0.2701 0.00 0.34 0.66
#&gt; SIH014     2   0.000     0.4034 0.00 1.00 0.00
#&gt; SIH024     3   0.911    -0.0215 0.14 0.42 0.44
#&gt; SIH028     2   0.456     0.3696 0.06 0.86 0.08
#&gt; SIH031     2   0.567     0.3212 0.14 0.80 0.06
#&gt; SIH042     2   0.739     0.3151 0.04 0.58 0.38
#&gt; SIH107     2   0.739     0.3151 0.04 0.58 0.38
#&gt; SIH114     1   0.922     0.3616 0.48 0.16 0.36
#&gt; SIH116     3   0.768     0.2852 0.08 0.28 0.64
#&gt; SIH117     3   0.583     0.2701 0.00 0.34 0.66
#&gt; SIH130     2   0.522     0.1260 0.00 0.74 0.26
#&gt; SIH134     2   0.522     0.1260 0.00 0.74 0.26
#&gt; SIH186     3   0.911    -0.0215 0.14 0.42 0.44
#&gt; SIH191     1   0.922     0.3616 0.48 0.16 0.36
#&gt; SIH192     1   0.922     0.3616 0.48 0.16 0.36
#&gt; SIH196     3   0.886     0.1785 0.12 0.40 0.48
#&gt; SIH214     2   0.456     0.3696 0.06 0.86 0.08
#&gt; SIH218     2   0.739     0.3151 0.04 0.58 0.38
#&gt; SIH232     1   0.542     0.6653 0.82 0.08 0.10
#&gt; SIH236     3   0.827    -0.2097 0.40 0.08 0.52
#&gt; SIH238     2   0.739     0.3151 0.04 0.58 0.38
#&gt; SIH241     2   0.833     0.2399 0.08 0.48 0.44
#&gt; SIH245     2   0.153     0.3900 0.04 0.96 0.00
#&gt; SIH260     2   0.680     0.0626 0.04 0.68 0.28
#&gt; SIH287     2   0.497     0.2956 0.06 0.84 0.10
#&gt; SIH289     2   0.739     0.3151 0.04 0.58 0.38
#&gt; SIH290     2   0.000     0.4034 0.00 1.00 0.00
#&gt; SIH295     1   0.497     0.6811 0.84 0.06 0.10
#&gt; SIH366     1   0.900     0.3166 0.56 0.20 0.24
#&gt; SIH377     1   0.357     0.6901 0.90 0.04 0.06
#&gt; SIH380     2   0.000     0.4034 0.00 1.00 0.00
#&gt; SIH385     2   0.739     0.3151 0.04 0.58 0.38
#&gt; SIH389     2   0.522     0.1260 0.00 0.74 0.26
#&gt; SIH391     3   0.583     0.2701 0.00 0.34 0.66
#&gt; SIH403     1   0.922     0.3616 0.48 0.16 0.36
#&gt; SIH411     2   0.522     0.1260 0.00 0.74 0.26
#&gt; SIH427     1   0.400     0.5900 0.84 0.00 0.16
#&gt; SIH433     2   0.739     0.3151 0.04 0.58 0.38
#&gt; SIH439     3   0.943     0.2356 0.28 0.22 0.50
#&gt; SIH442     1   0.357     0.6901 0.90 0.04 0.06
#&gt; SIH444     3   0.583     0.2701 0.00 0.34 0.66
#&gt; SIH452     3   0.595     0.2585 0.00 0.36 0.64
#&gt; SIH461     2   0.739     0.3151 0.04 0.58 0.38
#&gt; SIH471     2   0.922     0.1774 0.16 0.48 0.36
#&gt; SIH472     2   0.833     0.2399 0.08 0.48 0.44
#&gt; SIH481     1   0.207     0.6385 0.94 0.00 0.06
#&gt; SIH485     2   0.404     0.3655 0.04 0.88 0.08
#&gt; SIH491     2   0.000     0.4034 0.00 1.00 0.00
#&gt; SIH508     3   0.911    -0.0215 0.14 0.42 0.44
#&gt; SIH559     1   0.357     0.6901 0.90 0.04 0.06
#&gt; SIH587     3   0.604    -0.1920 0.38 0.00 0.62
#&gt; SIH625     3   0.833     0.1544 0.08 0.44 0.48
#&gt; SIH641     2   0.707    -0.2088 0.48 0.50 0.02
#&gt; SIH643     3   0.911    -0.0215 0.14 0.42 0.44
#&gt; SIH674     1   0.497     0.6811 0.84 0.06 0.10
#&gt; SIH678     1   0.497     0.6811 0.84 0.06 0.10
#&gt; SIH679     3   0.885     0.1431 0.14 0.32 0.54
#&gt; SIH689     3   0.768     0.2852 0.08 0.28 0.64
#&gt; SIH694     2   0.739     0.3151 0.04 0.58 0.38
#&gt; SIH721     2   0.739     0.3151 0.04 0.58 0.38
</code></pre>

<script>
$('#tab-CV-kmeans-get-classes-2-a').parent().next().next().hide();
$('#tab-CV-kmeans-get-classes-2-a').click(function(){
  $('#tab-CV-kmeans-get-classes-2-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-CV-kmeans-get-classes-3'>
<p><a id='tab-CV-kmeans-get-classes-3-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 4), get_membership(res, k = 4))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3   p4
#&gt; SIH013     3  0.5327     0.5348 0.00 0.22 0.72 0.06
#&gt; SIH014     2  0.4994     0.5629 0.00 0.52 0.48 0.00
#&gt; SIH024     3  0.6471     0.4557 0.02 0.08 0.66 0.24
#&gt; SIH028     2  0.8014     0.4919 0.04 0.44 0.40 0.12
#&gt; SIH031     2  0.9261     0.4308 0.18 0.42 0.28 0.12
#&gt; SIH042     3  0.0000     0.6750 0.00 0.00 1.00 0.00
#&gt; SIH107     3  0.0000     0.6750 0.00 0.00 1.00 0.00
#&gt; SIH114     4  0.6771     0.6946 0.12 0.04 0.16 0.68
#&gt; SIH116     3  0.6731     0.4586 0.02 0.28 0.62 0.08
#&gt; SIH117     3  0.5327     0.5348 0.00 0.22 0.72 0.06
#&gt; SIH130     2  0.4955     0.5707 0.02 0.76 0.20 0.02
#&gt; SIH134     2  0.5062     0.5613 0.00 0.68 0.30 0.02
#&gt; SIH186     3  0.6471     0.4557 0.02 0.08 0.66 0.24
#&gt; SIH191     4  0.6771     0.6946 0.12 0.04 0.16 0.68
#&gt; SIH192     4  0.6771     0.6946 0.12 0.04 0.16 0.68
#&gt; SIH196     4  0.5428     0.3726 0.00 0.38 0.02 0.60
#&gt; SIH214     2  0.8014     0.4919 0.04 0.44 0.40 0.12
#&gt; SIH218     3  0.0000     0.6750 0.00 0.00 1.00 0.00
#&gt; SIH232     1  0.3725     0.7388 0.86 0.02 0.10 0.02
#&gt; SIH236     4  0.3106     0.6436 0.04 0.04 0.02 0.90
#&gt; SIH238     3  0.0000     0.6750 0.00 0.00 1.00 0.00
#&gt; SIH241     3  0.6281     0.3429 0.04 0.10 0.72 0.14
#&gt; SIH245     2  0.6074     0.5937 0.06 0.60 0.34 0.00
#&gt; SIH260     2  0.5489     0.5192 0.00 0.70 0.24 0.06
#&gt; SIH287     2  0.6805     0.3949 0.00 0.50 0.40 0.10
#&gt; SIH289     3  0.0000     0.6750 0.00 0.00 1.00 0.00
#&gt; SIH290     2  0.4994     0.5629 0.00 0.52 0.48 0.00
#&gt; SIH295     1  0.2335     0.7762 0.92 0.02 0.06 0.00
#&gt; SIH366     1  0.6453     0.3718 0.56 0.08 0.36 0.00
#&gt; SIH377     1  0.2611     0.7391 0.92 0.02 0.02 0.04
#&gt; SIH380     2  0.5428     0.5952 0.02 0.60 0.38 0.00
#&gt; SIH385     3  0.3821     0.5591 0.04 0.12 0.84 0.00
#&gt; SIH389     2  0.5062     0.5613 0.00 0.68 0.30 0.02
#&gt; SIH391     3  0.5327     0.5348 0.00 0.22 0.72 0.06
#&gt; SIH403     4  0.6771     0.6946 0.12 0.04 0.16 0.68
#&gt; SIH411     2  0.4472     0.5703 0.00 0.76 0.22 0.02
#&gt; SIH427     1  0.5000     0.1164 0.50 0.00 0.00 0.50
#&gt; SIH433     3  0.0000     0.6750 0.00 0.00 1.00 0.00
#&gt; SIH439     2  0.9083    -0.0841 0.30 0.32 0.32 0.06
#&gt; SIH442     1  0.0707     0.7675 0.98 0.00 0.02 0.00
#&gt; SIH444     3  0.5327     0.5348 0.00 0.22 0.72 0.06
#&gt; SIH452     3  0.5986     0.4337 0.00 0.32 0.62 0.06
#&gt; SIH461     3  0.0000     0.6750 0.00 0.00 1.00 0.00
#&gt; SIH471     3  0.5637     0.5038 0.14 0.06 0.76 0.04
#&gt; SIH472     3  0.6281     0.3429 0.04 0.10 0.72 0.14
#&gt; SIH481     1  0.2921     0.6625 0.86 0.00 0.00 0.14
#&gt; SIH485     2  0.8014     0.4919 0.04 0.44 0.40 0.12
#&gt; SIH491     2  0.4994     0.5629 0.00 0.52 0.48 0.00
#&gt; SIH508     3  0.6471     0.4557 0.02 0.08 0.66 0.24
#&gt; SIH559     1  0.0707     0.7675 0.98 0.00 0.02 0.00
#&gt; SIH587     4  0.4491     0.5676 0.06 0.14 0.00 0.80
#&gt; SIH625     2  0.5570    -0.1537 0.00 0.54 0.02 0.44
#&gt; SIH641     1  0.7127     0.2420 0.52 0.38 0.08 0.02
#&gt; SIH643     3  0.6471     0.4557 0.02 0.08 0.66 0.24
#&gt; SIH674     1  0.2335     0.7762 0.92 0.02 0.06 0.00
#&gt; SIH678     1  0.2335     0.7762 0.92 0.02 0.06 0.00
#&gt; SIH679     4  0.5271     0.4564 0.02 0.34 0.00 0.64
#&gt; SIH689     3  0.6731     0.4586 0.02 0.28 0.62 0.08
#&gt; SIH694     3  0.0000     0.6750 0.00 0.00 1.00 0.00
#&gt; SIH721     3  0.0000     0.6750 0.00 0.00 1.00 0.00
</code></pre>

<script>
$('#tab-CV-kmeans-get-classes-3-a').parent().next().next().hide();
$('#tab-CV-kmeans-get-classes-3-a').click(function(){
  $('#tab-CV-kmeans-get-classes-3-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-CV-kmeans-get-classes-4'>
<p><a id='tab-CV-kmeans-get-classes-4-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 5), get_membership(res, k = 5))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3   p4   p5
#&gt; SIH013     3   0.429     0.0520 0.00 0.00 0.54 0.46 0.00
#&gt; SIH014     2   0.602     0.5279 0.04 0.50 0.42 0.04 0.00
#&gt; SIH024     3   0.600     0.4409 0.24 0.06 0.64 0.06 0.00
#&gt; SIH028     2   0.760     0.5086 0.26 0.44 0.24 0.06 0.00
#&gt; SIH031     2   0.695     0.4308 0.16 0.64 0.08 0.06 0.06
#&gt; SIH042     3   0.000     0.6581 0.00 0.00 1.00 0.00 0.00
#&gt; SIH107     3   0.000     0.6581 0.00 0.00 1.00 0.00 0.00
#&gt; SIH114     1   0.395     0.8798 0.80 0.00 0.12 0.00 0.08
#&gt; SIH116     4   0.616     0.1374 0.02 0.04 0.40 0.52 0.02
#&gt; SIH117     3   0.429     0.0520 0.00 0.00 0.54 0.46 0.00
#&gt; SIH130     2   0.473     0.2543 0.00 0.70 0.06 0.24 0.00
#&gt; SIH134     4   0.705    -0.0682 0.04 0.40 0.14 0.42 0.00
#&gt; SIH186     3   0.600     0.4409 0.24 0.06 0.64 0.06 0.00
#&gt; SIH191     1   0.395     0.8798 0.80 0.00 0.12 0.00 0.08
#&gt; SIH192     1   0.395     0.8798 0.80 0.00 0.12 0.00 0.08
#&gt; SIH196     4   0.603     0.1877 0.22 0.20 0.00 0.58 0.00
#&gt; SIH214     2   0.760     0.5086 0.26 0.44 0.24 0.06 0.00
#&gt; SIH218     3   0.000     0.6581 0.00 0.00 1.00 0.00 0.00
#&gt; SIH232     5   0.352     0.7028 0.00 0.04 0.14 0.00 0.82
#&gt; SIH236     1   0.552     0.4170 0.64 0.06 0.00 0.28 0.02
#&gt; SIH238     3   0.000     0.6581 0.00 0.00 1.00 0.00 0.00
#&gt; SIH241     3   0.607     0.3299 0.26 0.08 0.62 0.04 0.00
#&gt; SIH245     2   0.385     0.5182 0.00 0.76 0.22 0.00 0.02
#&gt; SIH260     4   0.645     0.0791 0.04 0.36 0.08 0.52 0.00
#&gt; SIH287     3   0.785     0.0504 0.20 0.26 0.44 0.10 0.00
#&gt; SIH289     3   0.000     0.6581 0.00 0.00 1.00 0.00 0.00
#&gt; SIH290     2   0.602     0.5279 0.04 0.50 0.42 0.04 0.00
#&gt; SIH295     5   0.208     0.7730 0.00 0.04 0.04 0.00 0.92
#&gt; SIH366     5   0.686     0.3213 0.00 0.18 0.32 0.02 0.48
#&gt; SIH377     5   0.429     0.6868 0.12 0.04 0.00 0.04 0.80
#&gt; SIH380     2   0.400     0.5210 0.00 0.74 0.24 0.00 0.02
#&gt; SIH385     3   0.520     0.3044 0.00 0.28 0.66 0.02 0.04
#&gt; SIH389     4   0.690    -0.0526 0.04 0.40 0.12 0.44 0.00
#&gt; SIH391     3   0.429     0.0520 0.00 0.00 0.54 0.46 0.00
#&gt; SIH403     1   0.395     0.8798 0.80 0.00 0.12 0.00 0.08
#&gt; SIH411     2   0.615     0.1573 0.04 0.56 0.06 0.34 0.00
#&gt; SIH427     5   0.765     0.1951 0.26 0.08 0.00 0.20 0.46
#&gt; SIH433     3   0.000     0.6581 0.00 0.00 1.00 0.00 0.00
#&gt; SIH439     4   0.843     0.2998 0.02 0.14 0.22 0.44 0.18
#&gt; SIH442     5   0.182     0.7608 0.02 0.02 0.00 0.02 0.94
#&gt; SIH444     3   0.429     0.0520 0.00 0.00 0.54 0.46 0.00
#&gt; SIH452     4   0.667     0.1653 0.00 0.14 0.36 0.48 0.02
#&gt; SIH461     3   0.000     0.6581 0.00 0.00 1.00 0.00 0.00
#&gt; SIH471     3   0.541     0.4426 0.00 0.04 0.72 0.10 0.14
#&gt; SIH472     3   0.596     0.3551 0.24 0.08 0.64 0.04 0.00
#&gt; SIH481     5   0.369     0.6887 0.14 0.02 0.00 0.02 0.82
#&gt; SIH485     2   0.760     0.5086 0.26 0.44 0.24 0.06 0.00
#&gt; SIH491     2   0.602     0.5279 0.04 0.50 0.42 0.04 0.00
#&gt; SIH508     3   0.600     0.4409 0.24 0.06 0.64 0.06 0.00
#&gt; SIH559     5   0.182     0.7608 0.02 0.02 0.00 0.02 0.94
#&gt; SIH587     4   0.700    -0.2570 0.40 0.10 0.00 0.44 0.06
#&gt; SIH625     4   0.569     0.3199 0.10 0.22 0.02 0.66 0.00
#&gt; SIH641     2   0.547     0.1856 0.00 0.60 0.02 0.04 0.34
#&gt; SIH643     3   0.600     0.4409 0.24 0.06 0.64 0.06 0.00
#&gt; SIH674     5   0.208     0.7730 0.00 0.04 0.04 0.00 0.92
#&gt; SIH678     5   0.208     0.7730 0.00 0.04 0.04 0.00 0.92
#&gt; SIH679     4   0.642     0.0047 0.36 0.18 0.00 0.46 0.00
#&gt; SIH689     4   0.616     0.1374 0.02 0.04 0.40 0.52 0.02
#&gt; SIH694     3   0.000     0.6581 0.00 0.00 1.00 0.00 0.00
#&gt; SIH721     3   0.000     0.6581 0.00 0.00 1.00 0.00 0.00
</code></pre>

<script>
$('#tab-CV-kmeans-get-classes-4-a').parent().next().next().hide();
$('#tab-CV-kmeans-get-classes-4-a').click(function(){
  $('#tab-CV-kmeans-get-classes-4-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-CV-kmeans-get-classes-5'>
<p><a id='tab-CV-kmeans-get-classes-5-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 6), get_membership(res, k = 6))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3   p4   p5   p6
#&gt; SIH013     3  0.5265     0.0710 0.00 0.10 0.50 0.40 0.00 0.00
#&gt; SIH014     2  0.5352     0.2119 0.00 0.64 0.24 0.04 0.00 0.08
#&gt; SIH024     3  0.5822     0.3173 0.28 0.00 0.58 0.08 0.00 0.06
#&gt; SIH028     6  0.6791     1.0000 0.10 0.36 0.12 0.00 0.00 0.42
#&gt; SIH031     2  0.5322    -0.4153 0.06 0.52 0.00 0.00 0.02 0.40
#&gt; SIH042     3  0.0000     0.6253 0.00 0.00 1.00 0.00 0.00 0.00
#&gt; SIH107     3  0.0000     0.6253 0.00 0.00 1.00 0.00 0.00 0.00
#&gt; SIH114     1  0.2474     0.8255 0.88 0.00 0.08 0.00 0.04 0.00
#&gt; SIH116     4  0.5797     0.2161 0.00 0.04 0.28 0.60 0.06 0.02
#&gt; SIH117     3  0.5265     0.0710 0.00 0.10 0.50 0.40 0.00 0.00
#&gt; SIH130     2  0.1807     0.4083 0.00 0.92 0.02 0.00 0.00 0.06
#&gt; SIH134     2  0.5210     0.3527 0.00 0.64 0.04 0.26 0.00 0.06
#&gt; SIH186     3  0.5822     0.3173 0.28 0.00 0.58 0.08 0.00 0.06
#&gt; SIH191     1  0.2474     0.8255 0.88 0.00 0.08 0.00 0.04 0.00
#&gt; SIH192     1  0.2474     0.8255 0.88 0.00 0.08 0.00 0.04 0.00
#&gt; SIH196     4  0.6930     0.1452 0.20 0.08 0.00 0.44 0.00 0.28
#&gt; SIH214     6  0.6791     1.0000 0.10 0.36 0.12 0.00 0.00 0.42
#&gt; SIH218     3  0.0000     0.6253 0.00 0.00 1.00 0.00 0.00 0.00
#&gt; SIH232     5  0.2020     0.7102 0.00 0.00 0.02 0.02 0.92 0.04
#&gt; SIH236     1  0.5938    -0.0243 0.46 0.00 0.00 0.28 0.00 0.26
#&gt; SIH238     3  0.0000     0.6253 0.00 0.00 1.00 0.00 0.00 0.00
#&gt; SIH241     3  0.5523    -0.0615 0.14 0.00 0.50 0.00 0.00 0.36
#&gt; SIH245     2  0.3258     0.3932 0.00 0.84 0.10 0.00 0.02 0.04
#&gt; SIH260     4  0.5878    -0.3064 0.00 0.44 0.04 0.44 0.00 0.08
#&gt; SIH287     3  0.8585    -0.0926 0.18 0.22 0.34 0.12 0.00 0.14
#&gt; SIH289     3  0.0000     0.6253 0.00 0.00 1.00 0.00 0.00 0.00
#&gt; SIH290     2  0.5352     0.2119 0.00 0.64 0.24 0.04 0.00 0.08
#&gt; SIH295     5  0.0000     0.7274 0.00 0.00 0.00 0.00 1.00 0.00
#&gt; SIH366     5  0.6340     0.1835 0.02 0.26 0.26 0.00 0.46 0.00
#&gt; SIH377     5  0.5422     0.6785 0.14 0.00 0.00 0.04 0.66 0.16
#&gt; SIH380     2  0.3258     0.3932 0.00 0.84 0.10 0.00 0.02 0.04
#&gt; SIH385     3  0.5455     0.3032 0.00 0.26 0.62 0.00 0.08 0.04
#&gt; SIH389     2  0.5455     0.3497 0.00 0.62 0.04 0.26 0.00 0.08
#&gt; SIH391     3  0.5265     0.0710 0.00 0.10 0.50 0.40 0.00 0.00
#&gt; SIH403     1  0.2474     0.8255 0.88 0.00 0.08 0.00 0.04 0.00
#&gt; SIH411     2  0.3572     0.3996 0.00 0.82 0.02 0.10 0.00 0.06
#&gt; SIH427     5  0.8041     0.1824 0.24 0.02 0.00 0.18 0.30 0.26
#&gt; SIH433     3  0.0000     0.6253 0.00 0.00 1.00 0.00 0.00 0.00
#&gt; SIH439     2  0.8331    -0.2306 0.02 0.32 0.16 0.28 0.20 0.02
#&gt; SIH442     5  0.4430     0.7121 0.08 0.00 0.00 0.04 0.76 0.12
#&gt; SIH444     3  0.5265     0.0710 0.00 0.10 0.50 0.40 0.00 0.00
#&gt; SIH452     4  0.6059     0.0108 0.00 0.26 0.36 0.38 0.00 0.00
#&gt; SIH461     3  0.0000     0.6253 0.00 0.00 1.00 0.00 0.00 0.00
#&gt; SIH471     3  0.6124     0.2328 0.00 0.00 0.56 0.20 0.20 0.04
#&gt; SIH472     3  0.5523    -0.0615 0.14 0.00 0.50 0.00 0.00 0.36
#&gt; SIH481     5  0.5652     0.6313 0.22 0.00 0.00 0.04 0.62 0.12
#&gt; SIH485     6  0.6791     1.0000 0.10 0.36 0.12 0.00 0.00 0.42
#&gt; SIH491     2  0.5352     0.2119 0.00 0.64 0.24 0.04 0.00 0.08
#&gt; SIH508     3  0.5822     0.3173 0.28 0.00 0.58 0.08 0.00 0.06
#&gt; SIH559     5  0.4626     0.7071 0.08 0.00 0.00 0.04 0.74 0.14
#&gt; SIH587     4  0.5904     0.1095 0.22 0.02 0.00 0.56 0.00 0.20
#&gt; SIH625     4  0.6687     0.2336 0.10 0.12 0.00 0.48 0.00 0.30
#&gt; SIH641     2  0.6339     0.1741 0.00 0.48 0.02 0.06 0.38 0.06
#&gt; SIH643     3  0.5822     0.3173 0.28 0.00 0.58 0.08 0.00 0.06
#&gt; SIH674     5  0.0000     0.7274 0.00 0.00 0.00 0.00 1.00 0.00
#&gt; SIH678     5  0.0547     0.7235 0.00 0.00 0.00 0.00 0.98 0.02
#&gt; SIH679     4  0.7325     0.0298 0.30 0.10 0.00 0.32 0.00 0.28
#&gt; SIH689     4  0.5797     0.2161 0.00 0.04 0.28 0.60 0.06 0.02
#&gt; SIH694     3  0.0000     0.6253 0.00 0.00 1.00 0.00 0.00 0.00
#&gt; SIH721     3  0.0000     0.6253 0.00 0.00 1.00 0.00 0.00 0.00
</code></pre>

<script>
$('#tab-CV-kmeans-get-classes-5-a').parent().next().next().hide();
$('#tab-CV-kmeans-get-classes-5-a').click(function(){
  $('#tab-CV-kmeans-get-classes-5-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>
</div>

Heatmaps for the consensus matrix. It visualizes the probability of two
samples to be in a same group.




<script>
$( function() {
	$( '#tabs-CV-kmeans-consensus-heatmap' ).tabs();
} );
</script>
<div id='tabs-CV-kmeans-consensus-heatmap'>
<ul>
<li><a href='#tab-CV-kmeans-consensus-heatmap-1'>k = 2</a></li>
<li><a href='#tab-CV-kmeans-consensus-heatmap-2'>k = 3</a></li>
<li><a href='#tab-CV-kmeans-consensus-heatmap-3'>k = 4</a></li>
<li><a href='#tab-CV-kmeans-consensus-heatmap-4'>k = 5</a></li>
<li><a href='#tab-CV-kmeans-consensus-heatmap-5'>k = 6</a></li>
</ul>
<div id='tab-CV-kmeans-consensus-heatmap-1'>
<pre><code class="language-r">consensus_heatmap(res, k = 2)
</code></pre>
<p><img src="figure_cola/tab-CV-kmeans-consensus-heatmap-1-1.png" alt="plot of chunk tab-CV-kmeans-consensus-heatmap-1" /></p>

</div>
<div id='tab-CV-kmeans-consensus-heatmap-2'>
<pre><code class="language-r">consensus_heatmap(res, k = 3)
</code></pre>
<p><img src="figure_cola/tab-CV-kmeans-consensus-heatmap-2-1.png" alt="plot of chunk tab-CV-kmeans-consensus-heatmap-2" /></p>

</div>
<div id='tab-CV-kmeans-consensus-heatmap-3'>
<pre><code class="language-r">consensus_heatmap(res, k = 4)
</code></pre>
<p><img src="figure_cola/tab-CV-kmeans-consensus-heatmap-3-1.png" alt="plot of chunk tab-CV-kmeans-consensus-heatmap-3" /></p>

</div>
<div id='tab-CV-kmeans-consensus-heatmap-4'>
<pre><code class="language-r">consensus_heatmap(res, k = 5)
</code></pre>
<p><img src="figure_cola/tab-CV-kmeans-consensus-heatmap-4-1.png" alt="plot of chunk tab-CV-kmeans-consensus-heatmap-4" /></p>

</div>
<div id='tab-CV-kmeans-consensus-heatmap-5'>
<pre><code class="language-r">consensus_heatmap(res, k = 6)
</code></pre>
<p><img src="figure_cola/tab-CV-kmeans-consensus-heatmap-5-1.png" alt="plot of chunk tab-CV-kmeans-consensus-heatmap-5" /></p>

</div>
</div>

Heatmaps for the membership of samples in all partitions to see how consistent they are:





<script>
$( function() {
	$( '#tabs-CV-kmeans-membership-heatmap' ).tabs();
} );
</script>
<div id='tabs-CV-kmeans-membership-heatmap'>
<ul>
<li><a href='#tab-CV-kmeans-membership-heatmap-1'>k = 2</a></li>
<li><a href='#tab-CV-kmeans-membership-heatmap-2'>k = 3</a></li>
<li><a href='#tab-CV-kmeans-membership-heatmap-3'>k = 4</a></li>
<li><a href='#tab-CV-kmeans-membership-heatmap-4'>k = 5</a></li>
<li><a href='#tab-CV-kmeans-membership-heatmap-5'>k = 6</a></li>
</ul>
<div id='tab-CV-kmeans-membership-heatmap-1'>
<pre><code class="language-r">membership_heatmap(res, k = 2)
</code></pre>
<p><img src="figure_cola/tab-CV-kmeans-membership-heatmap-1-1.png" alt="plot of chunk tab-CV-kmeans-membership-heatmap-1" /></p>

</div>
<div id='tab-CV-kmeans-membership-heatmap-2'>
<pre><code class="language-r">membership_heatmap(res, k = 3)
</code></pre>
<p><img src="figure_cola/tab-CV-kmeans-membership-heatmap-2-1.png" alt="plot of chunk tab-CV-kmeans-membership-heatmap-2" /></p>

</div>
<div id='tab-CV-kmeans-membership-heatmap-3'>
<pre><code class="language-r">membership_heatmap(res, k = 4)
</code></pre>
<p><img src="figure_cola/tab-CV-kmeans-membership-heatmap-3-1.png" alt="plot of chunk tab-CV-kmeans-membership-heatmap-3" /></p>

</div>
<div id='tab-CV-kmeans-membership-heatmap-4'>
<pre><code class="language-r">membership_heatmap(res, k = 5)
</code></pre>
<p><img src="figure_cola/tab-CV-kmeans-membership-heatmap-4-1.png" alt="plot of chunk tab-CV-kmeans-membership-heatmap-4" /></p>

</div>
<div id='tab-CV-kmeans-membership-heatmap-5'>
<pre><code class="language-r">membership_heatmap(res, k = 6)
</code></pre>
<p><img src="figure_cola/tab-CV-kmeans-membership-heatmap-5-1.png" alt="plot of chunk tab-CV-kmeans-membership-heatmap-5" /></p>

</div>
</div>

As soon as the classes for columns are determined, the signatures
that are significantly different between subgroups can be looked for. 
Following are the heatmaps for signatures.




Signature heatmaps where rows are scaled:



<script>
$( function() {
	$( '#tabs-CV-kmeans-get-signatures' ).tabs();
} );
</script>
<div id='tabs-CV-kmeans-get-signatures'>
<ul>
<li><a href='#tab-CV-kmeans-get-signatures-1'>k = 2</a></li>
<li><a href='#tab-CV-kmeans-get-signatures-2'>k = 3</a></li>
<li><a href='#tab-CV-kmeans-get-signatures-3'>k = 4</a></li>
<li><a href='#tab-CV-kmeans-get-signatures-4'>k = 5</a></li>
<li><a href='#tab-CV-kmeans-get-signatures-5'>k = 6</a></li>
</ul>
<div id='tab-CV-kmeans-get-signatures-1'>
<pre><code class="language-r">get_signatures(res, k = 2)
</code></pre>
<p><img src="figure_cola/tab-CV-kmeans-get-signatures-1-1.png" alt="plot of chunk tab-CV-kmeans-get-signatures-1" /></p>

</div>
<div id='tab-CV-kmeans-get-signatures-2'>
<pre><code class="language-r">get_signatures(res, k = 3)
</code></pre>
<p><img src="figure_cola/tab-CV-kmeans-get-signatures-2-1.png" alt="plot of chunk tab-CV-kmeans-get-signatures-2" /></p>

</div>
<div id='tab-CV-kmeans-get-signatures-3'>
<pre><code class="language-r">get_signatures(res, k = 4)
</code></pre>
<p><img src="figure_cola/tab-CV-kmeans-get-signatures-3-1.png" alt="plot of chunk tab-CV-kmeans-get-signatures-3" /></p>

</div>
<div id='tab-CV-kmeans-get-signatures-4'>
<pre><code class="language-r">get_signatures(res, k = 5)
</code></pre>
<p><img src="figure_cola/tab-CV-kmeans-get-signatures-4-1.png" alt="plot of chunk tab-CV-kmeans-get-signatures-4" /></p>

</div>
<div id='tab-CV-kmeans-get-signatures-5'>
<pre><code class="language-r">get_signatures(res, k = 6)
</code></pre>
<p><img src="figure_cola/tab-CV-kmeans-get-signatures-5-1.png" alt="plot of chunk tab-CV-kmeans-get-signatures-5" /></p>

</div>
</div>



Signature heatmaps where rows are not scaled:


<script>
$( function() {
	$( '#tabs-CV-kmeans-get-signatures-no-scale' ).tabs();
} );
</script>
<div id='tabs-CV-kmeans-get-signatures-no-scale'>
<ul>
<li><a href='#tab-CV-kmeans-get-signatures-no-scale-1'>k = 2</a></li>
<li><a href='#tab-CV-kmeans-get-signatures-no-scale-2'>k = 3</a></li>
<li><a href='#tab-CV-kmeans-get-signatures-no-scale-3'>k = 4</a></li>
<li><a href='#tab-CV-kmeans-get-signatures-no-scale-4'>k = 5</a></li>
<li><a href='#tab-CV-kmeans-get-signatures-no-scale-5'>k = 6</a></li>
</ul>
<div id='tab-CV-kmeans-get-signatures-no-scale-1'>
<pre><code class="language-r">get_signatures(res, k = 2, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-CV-kmeans-get-signatures-no-scale-1-1.png" alt="plot of chunk tab-CV-kmeans-get-signatures-no-scale-1" /></p>

</div>
<div id='tab-CV-kmeans-get-signatures-no-scale-2'>
<pre><code class="language-r">get_signatures(res, k = 3, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-CV-kmeans-get-signatures-no-scale-2-1.png" alt="plot of chunk tab-CV-kmeans-get-signatures-no-scale-2" /></p>

</div>
<div id='tab-CV-kmeans-get-signatures-no-scale-3'>
<pre><code class="language-r">get_signatures(res, k = 4, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-CV-kmeans-get-signatures-no-scale-3-1.png" alt="plot of chunk tab-CV-kmeans-get-signatures-no-scale-3" /></p>

</div>
<div id='tab-CV-kmeans-get-signatures-no-scale-4'>
<pre><code class="language-r">get_signatures(res, k = 5, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-CV-kmeans-get-signatures-no-scale-4-1.png" alt="plot of chunk tab-CV-kmeans-get-signatures-no-scale-4" /></p>

</div>
<div id='tab-CV-kmeans-get-signatures-no-scale-5'>
<pre><code class="language-r">get_signatures(res, k = 6, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-CV-kmeans-get-signatures-no-scale-5-1.png" alt="plot of chunk tab-CV-kmeans-get-signatures-no-scale-5" /></p>

</div>
</div>



Compare the overlap of signatures from different k:

``` r
compare_signatures(res)
```

![plot of chunk CV-kmeans-signature_compare](figure_cola/CV-kmeans-signature_compare-1.png)

`get_signature()` returns a data frame invisibly. To get the list of signatures, the function
call should be assigned to a variable explicitly. In following code, if `plot` argument is set
to `FALSE`, no heatmap is plotted while only the differential analysis is performed.

``` r
# code only for demonstration
tb = get_signature(res, k = ..., plot = FALSE)
```

An example of the output of `tb` is:

```
#>   which_row         fdr    mean_1    mean_2 scaled_mean_1 scaled_mean_2 km
#> 1        38 0.042760348  8.373488  9.131774    -0.5533452     0.5164555  1
#> 2        40 0.018707592  7.106213  8.469186    -0.6173731     0.5762149  1
#> 3        55 0.019134737 10.221463 11.207825    -0.6159697     0.5749050  1
#> 4        59 0.006059896  5.921854  7.869574    -0.6899429     0.6439467  1
#> 5        60 0.018055526  8.928898 10.211722    -0.6204761     0.5791110  1
#> 6        98 0.009384629 15.714769 14.887706     0.6635654    -0.6193277  2
...
```

The columns in `tb` are:

1. `which_row`: row indices corresponding to the input matrix.
2. `fdr`: FDR for the differential test. 
3. `mean_x`: The mean value in group x.
4. `scaled_mean_x`: The mean value in group x after rows are scaled.
5. `km`: Row groups if k-means clustering is applied to rows (which is done by automatically selecting number of clusters).

If there are too many signatures, `top_signatures = ...` can be set to only show the 
signatures with the highest FDRs:

``` r
# code only for demonstration
# e.g. to show the top 500 most significant rows
tb = get_signature(res, k = ..., top_signatures = 500)
```

If the signatures are defined as these which are uniquely high in current group, `diff_method` argument
can be set to `"uniquely_high_in_one_group"`:

``` r
# code only for demonstration
tb = get_signature(res, k = ..., diff_method = "uniquely_high_in_one_group")
```




UMAP plot which shows how samples are separated.


<script>
$( function() {
	$( '#tabs-CV-kmeans-dimension-reduction' ).tabs();
} );
</script>
<div id='tabs-CV-kmeans-dimension-reduction'>
<ul>
<li><a href='#tab-CV-kmeans-dimension-reduction-1'>k = 2</a></li>
<li><a href='#tab-CV-kmeans-dimension-reduction-2'>k = 3</a></li>
<li><a href='#tab-CV-kmeans-dimension-reduction-3'>k = 4</a></li>
<li><a href='#tab-CV-kmeans-dimension-reduction-4'>k = 5</a></li>
<li><a href='#tab-CV-kmeans-dimension-reduction-5'>k = 6</a></li>
</ul>
<div id='tab-CV-kmeans-dimension-reduction-1'>
<pre><code class="language-r">dimension_reduction(res, k = 2, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-CV-kmeans-dimension-reduction-1-1.png" alt="plot of chunk tab-CV-kmeans-dimension-reduction-1" /></p>

</div>
<div id='tab-CV-kmeans-dimension-reduction-2'>
<pre><code class="language-r">dimension_reduction(res, k = 3, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-CV-kmeans-dimension-reduction-2-1.png" alt="plot of chunk tab-CV-kmeans-dimension-reduction-2" /></p>

</div>
<div id='tab-CV-kmeans-dimension-reduction-3'>
<pre><code class="language-r">dimension_reduction(res, k = 4, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-CV-kmeans-dimension-reduction-3-1.png" alt="plot of chunk tab-CV-kmeans-dimension-reduction-3" /></p>

</div>
<div id='tab-CV-kmeans-dimension-reduction-4'>
<pre><code class="language-r">dimension_reduction(res, k = 5, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-CV-kmeans-dimension-reduction-4-1.png" alt="plot of chunk tab-CV-kmeans-dimension-reduction-4" /></p>

</div>
<div id='tab-CV-kmeans-dimension-reduction-5'>
<pre><code class="language-r">dimension_reduction(res, k = 6, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-CV-kmeans-dimension-reduction-5-1.png" alt="plot of chunk tab-CV-kmeans-dimension-reduction-5" /></p>

</div>
</div>



Following heatmap shows how subgroups are split when increasing `k`:

``` r
collect_classes(res)
```

![plot of chunk CV-kmeans-collect-classes](figure_cola/CV-kmeans-collect-classes-1.png)



If matrix rows can be associated to genes, consider to use `functional_enrichment(res,
...)` to perform function enrichment for the signature genes. See [this vignette](https://jokergoo.github.io/cola_vignettes/functional_enrichment.html) for more detailed explanations.


 

---------------------------------------------------



### CV:pam






The object with results only for a single top-value method and a single partitioning method 
can be extracted as:

``` r
res = res_list["CV", "pam"]
# you can also extract it by
# res = res_list["CV:pam"]
```

A summary of `res` and all the functions that can be applied to it:

``` r
res
```

```
#> A 'ConsensusPartition' object with k = 2, 3, 4, 5, 6.
#>   On a matrix with 1900 rows and 60 columns.
#>   Top rows (7) are extracted by 'CV' method.
#>   Subgroups are detected by 'pam' method.
#>   Performed in total 250 partitions by row resampling.
#>   Best k for subgroups seems to be 5.
#> 
#> Following methods can be applied to this 'ConsensusPartition' object:
#>  [1] "cola_report"             "collect_classes"         "collect_plots"          
#>  [4] "collect_stats"           "colnames"                "compare_partitions"     
#>  [7] "compare_signatures"      "consensus_heatmap"       "dimension_reduction"    
#> [10] "functional_enrichment"   "get_anno_col"            "get_anno"               
#> [13] "get_classes"             "get_consensus"           "get_matrix"             
#> [16] "get_membership"          "get_param"               "get_signatures"         
#> [19] "get_stats"               "is_best_k"               "is_stable_k"            
#> [22] "membership_heatmap"      "ncol"                    "nrow"                   
#> [25] "plot_ecdf"               "predict_classes"         "rownames"               
#> [28] "select_partition_number" "show"                    "suggest_best_k"         
#> [31] "test_to_known_factors"   "top_rows_heatmap"
```

`collect_plots()` function collects all the plots made from `res` for all `k` (number of subgroups)
into one single page to provide an easy and fast comparison between different `k`.

``` r
collect_plots(res)
```

![plot of chunk CV-pam-collect-plots](figure_cola/CV-pam-collect-plots-1.png)

The plots are:

- The first row: a plot of the eCDF (empirical cumulative distribution
  function) curves of the consensus matrix for each `k` and the heatmap of
  predicted classes for each `k`.
- The second row: heatmaps of the consensus matrix for each `k`.
- The third row: heatmaps of the membership matrix for each `k`.
- The fouth row: heatmaps of the signatures for each `k`.

All the plots in panels can be made by individual functions and they are
plotted later in this section.

`select_partition_number()` produces several plots showing different
statistics for choosing "optimized" `k`. There are following statistics:

- eCDF curves of the consensus matrix for each `k`;
- 1-PAC. [The PAC score](https://en.wikipedia.org/wiki/Consensus_clustering#Over-interpretation_potential_of_consensus_clustering)
  measures the proportion of the ambiguous subgrouping.
- Mean silhouette score.
- Concordance. The mean probability of fiting the consensus subgroup labels in all
  partitions.
- Area increased. Denote $A_k$ as the area under the eCDF curve for current
  `k`, the area increased is defined as $A_k - A_{k-1}$.
- Rand index. The percent of pairs of samples that are both in a same cluster
  or both are not in a same cluster in the partition of k and k-1.
- Jaccard index. The ratio of pairs of samples are both in a same cluster in
  the partition of k and k-1 and the pairs of samples are both in a same
  cluster in the partition k or k-1.

The detailed explanations of these statistics can be found in [the _cola_
vignette](https://jokergoo.github.io/cola_vignettes/cola.html#toc_13).

Generally speaking, higher 1-PAC score, higher mean silhouette score or higher
concordance corresponds to better partition. Rand index and Jaccard index
measure how similar the current partition is compared to partition with `k-1`.
If they are too similar, we won't accept `k` is better than `k-1`.

``` r
select_partition_number(res)
```

![plot of chunk CV-pam-select-partition-number](figure_cola/CV-pam-select-partition-number-1.png)

The numeric values for all these statistics can be obtained by `get_stats()`.

``` r
get_stats(res)
```

```
#>   k 1-PAC mean_silhouette concordance area_increased  Rand Jaccard
#> 2 2 0.335           0.828       0.892         0.3642 0.636   0.636
#> 3 3 0.386           0.532       0.818         0.7220 0.611   0.451
#> 4 4 0.501           0.624       0.828         0.1526 0.845   0.630
#> 5 5 0.590           0.627       0.817         0.0919 0.810   0.450
#> 6 6 0.687           0.454       0.684         0.0433 0.798   0.322
```

`suggest_best_k()` suggests the best $k$ based on these statistics. The rules are as follows:

- All $k$ with Jaccard index larger than 0.95 are removed because increasing
  $k$ does not provide enough extra information. If all $k$ are removed, it is
  marked as no subgroup is detected.
- For all $k$ with 1-PAC score larger than 0.9, the maximal $k$ is taken as
  the best $k$, and other $k$ are marked as optional $k$.
- If it does not fit the second rule. The $k$ with the maximal vote of the
  highest 1-PAC score, highest mean silhouette, and highest concordance is
  taken as the best $k$.

``` r
suggest_best_k(res)
```

```
#> [1] 5
```


Following is the table of the partitions (You need to click the **show/hide
code output** link to see it). The membership matrix (columns with name `p*`)
is inferred by
[`clue::cl_consensus()`](https://www.rdocumentation.org/link/cl_consensus?package=clue)
function with the `SE` method. Basically the value in the membership matrix
represents the probability to belong to a certain group. The finall subgroup
label for an item is determined with the group with highest probability it
belongs to.

In `get_classes()` function, the entropy is calculated from the membership
matrix and the silhouette score is calculated from the consensus matrix.



<script>
$( function() {
	$( '#tabs-CV-pam-get-classes' ).tabs();
} );
</script>
<div id='tabs-CV-pam-get-classes'>
<ul>
<li><a href='#tab-CV-pam-get-classes-1'>k = 2</a></li>
<li><a href='#tab-CV-pam-get-classes-2'>k = 3</a></li>
<li><a href='#tab-CV-pam-get-classes-3'>k = 4</a></li>
<li><a href='#tab-CV-pam-get-classes-4'>k = 5</a></li>
<li><a href='#tab-CV-pam-get-classes-5'>k = 6</a></li>
</ul>

<div id='tab-CV-pam-get-classes-1'>
<p><a id='tab-CV-pam-get-classes-1-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 2), get_membership(res, k = 2))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2
#&gt; SIH013     2   0.000      0.902 0.00 1.00
#&gt; SIH014     2   0.000      0.902 0.00 1.00
#&gt; SIH024     2   0.000      0.902 0.00 1.00
#&gt; SIH028     2   0.000      0.902 0.00 1.00
#&gt; SIH031     2   0.584      0.827 0.14 0.86
#&gt; SIH042     2   0.000      0.902 0.00 1.00
#&gt; SIH107     2   0.000      0.902 0.00 1.00
#&gt; SIH114     1   0.943      0.769 0.64 0.36
#&gt; SIH116     2   0.000      0.902 0.00 1.00
#&gt; SIH117     2   0.000      0.902 0.00 1.00
#&gt; SIH130     2   0.584      0.827 0.14 0.86
#&gt; SIH134     2   0.584      0.827 0.14 0.86
#&gt; SIH186     2   0.000      0.902 0.00 1.00
#&gt; SIH191     1   0.943      0.769 0.64 0.36
#&gt; SIH192     1   0.943      0.769 0.64 0.36
#&gt; SIH196     1   0.760      0.752 0.78 0.22
#&gt; SIH214     2   0.000      0.902 0.00 1.00
#&gt; SIH218     2   0.000      0.902 0.00 1.00
#&gt; SIH232     1   0.855      0.709 0.72 0.28
#&gt; SIH236     1   0.760      0.752 0.78 0.22
#&gt; SIH238     2   0.000      0.902 0.00 1.00
#&gt; SIH241     2   0.000      0.902 0.00 1.00
#&gt; SIH245     2   0.584      0.827 0.14 0.86
#&gt; SIH260     2   0.584      0.827 0.14 0.86
#&gt; SIH287     2   0.000      0.902 0.00 1.00
#&gt; SIH289     2   0.000      0.902 0.00 1.00
#&gt; SIH290     2   0.000      0.902 0.00 1.00
#&gt; SIH295     2   0.760      0.653 0.22 0.78
#&gt; SIH366     2   0.760      0.653 0.22 0.78
#&gt; SIH377     1   0.584      0.798 0.86 0.14
#&gt; SIH380     2   0.584      0.827 0.14 0.86
#&gt; SIH385     2   0.000      0.902 0.00 1.00
#&gt; SIH389     2   0.584      0.827 0.14 0.86
#&gt; SIH391     2   0.000      0.902 0.00 1.00
#&gt; SIH403     1   0.943      0.769 0.64 0.36
#&gt; SIH411     2   0.584      0.827 0.14 0.86
#&gt; SIH427     1   0.000      0.731 1.00 0.00
#&gt; SIH433     2   0.000      0.902 0.00 1.00
#&gt; SIH439     2   0.943      0.571 0.36 0.64
#&gt; SIH442     1   0.584      0.798 0.86 0.14
#&gt; SIH444     2   0.000      0.902 0.00 1.00
#&gt; SIH452     2   0.584      0.827 0.14 0.86
#&gt; SIH461     2   0.000      0.902 0.00 1.00
#&gt; SIH471     2   0.000      0.902 0.00 1.00
#&gt; SIH472     2   0.000      0.902 0.00 1.00
#&gt; SIH481     1   0.584      0.798 0.86 0.14
#&gt; SIH485     2   0.584      0.827 0.14 0.86
#&gt; SIH491     2   0.584      0.827 0.14 0.86
#&gt; SIH508     2   0.000      0.902 0.00 1.00
#&gt; SIH559     1   0.584      0.798 0.86 0.14
#&gt; SIH587     1   0.827      0.809 0.74 0.26
#&gt; SIH625     2   0.584      0.827 0.14 0.86
#&gt; SIH641     2   0.943      0.571 0.36 0.64
#&gt; SIH643     2   0.000      0.902 0.00 1.00
#&gt; SIH674     2   0.760      0.653 0.22 0.78
#&gt; SIH678     2   0.760      0.653 0.22 0.78
#&gt; SIH679     1   0.760      0.752 0.78 0.22
#&gt; SIH689     2   0.000      0.902 0.00 1.00
#&gt; SIH694     2   0.000      0.902 0.00 1.00
#&gt; SIH721     2   0.000      0.902 0.00 1.00
</code></pre>

<script>
$('#tab-CV-pam-get-classes-1-a').parent().next().next().hide();
$('#tab-CV-pam-get-classes-1-a').click(function(){
  $('#tab-CV-pam-get-classes-1-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-CV-pam-get-classes-2'>
<p><a id='tab-CV-pam-get-classes-2-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 3), get_membership(res, k = 3))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3
#&gt; SIH013     3   0.369     0.6846 0.00 0.14 0.86
#&gt; SIH014     2   0.628     0.2535 0.00 0.54 0.46
#&gt; SIH024     3   0.000     0.7786 0.00 0.00 1.00
#&gt; SIH028     3   0.502     0.5215 0.00 0.24 0.76
#&gt; SIH031     2   0.624     0.2876 0.00 0.56 0.44
#&gt; SIH042     3   0.000     0.7786 0.00 0.00 1.00
#&gt; SIH107     3   0.000     0.7786 0.00 0.00 1.00
#&gt; SIH114     3   0.631    -0.0584 0.50 0.00 0.50
#&gt; SIH116     2   0.911     0.0623 0.14 0.44 0.42
#&gt; SIH117     3   0.369     0.6846 0.00 0.14 0.86
#&gt; SIH130     2   0.000     0.6851 0.00 1.00 0.00
#&gt; SIH134     2   0.000     0.6851 0.00 1.00 0.00
#&gt; SIH186     3   0.000     0.7786 0.00 0.00 1.00
#&gt; SIH191     1   0.631    -0.0741 0.50 0.00 0.50
#&gt; SIH192     3   0.631    -0.0584 0.50 0.00 0.50
#&gt; SIH196     2   0.369     0.5751 0.14 0.86 0.00
#&gt; SIH214     3   0.502     0.5215 0.00 0.24 0.76
#&gt; SIH218     3   0.000     0.7786 0.00 0.00 1.00
#&gt; SIH232     1   0.571     0.2708 0.68 0.00 0.32
#&gt; SIH236     1   0.631     0.0545 0.50 0.50 0.00
#&gt; SIH238     3   0.000     0.7786 0.00 0.00 1.00
#&gt; SIH241     3   0.000     0.7786 0.00 0.00 1.00
#&gt; SIH245     2   0.369     0.6622 0.00 0.86 0.14
#&gt; SIH260     2   0.000     0.6851 0.00 1.00 0.00
#&gt; SIH287     3   0.502     0.5215 0.00 0.24 0.76
#&gt; SIH289     3   0.000     0.7786 0.00 0.00 1.00
#&gt; SIH290     2   0.628     0.2535 0.00 0.54 0.46
#&gt; SIH295     3   0.631     0.1456 0.50 0.00 0.50
#&gt; SIH366     3   0.595     0.4116 0.36 0.00 0.64
#&gt; SIH377     1   0.000     0.6986 1.00 0.00 0.00
#&gt; SIH380     2   0.369     0.6622 0.00 0.86 0.14
#&gt; SIH385     3   0.000     0.7786 0.00 0.00 1.00
#&gt; SIH389     2   0.000     0.6851 0.00 1.00 0.00
#&gt; SIH391     3   0.522     0.5383 0.00 0.26 0.74
#&gt; SIH403     3   0.631    -0.0584 0.50 0.00 0.50
#&gt; SIH411     2   0.000     0.6851 0.00 1.00 0.00
#&gt; SIH427     1   0.000     0.6986 1.00 0.00 0.00
#&gt; SIH433     3   0.000     0.7786 0.00 0.00 1.00
#&gt; SIH439     2   0.960     0.1009 0.22 0.46 0.32
#&gt; SIH442     1   0.000     0.6986 1.00 0.00 0.00
#&gt; SIH444     3   0.369     0.6846 0.00 0.14 0.86
#&gt; SIH452     2   0.502     0.5054 0.00 0.76 0.24
#&gt; SIH461     3   0.000     0.7786 0.00 0.00 1.00
#&gt; SIH471     3   0.369     0.6805 0.14 0.00 0.86
#&gt; SIH472     3   0.000     0.7786 0.00 0.00 1.00
#&gt; SIH481     1   0.000     0.6986 1.00 0.00 0.00
#&gt; SIH485     2   0.369     0.6622 0.00 0.86 0.14
#&gt; SIH491     2   0.369     0.6622 0.00 0.86 0.14
#&gt; SIH508     3   0.000     0.7786 0.00 0.00 1.00
#&gt; SIH559     1   0.000     0.6986 1.00 0.00 0.00
#&gt; SIH587     1   0.522     0.4851 0.74 0.26 0.00
#&gt; SIH625     2   0.000     0.6851 0.00 1.00 0.00
#&gt; SIH641     1   0.631    -0.0321 0.50 0.50 0.00
#&gt; SIH643     3   0.000     0.7786 0.00 0.00 1.00
#&gt; SIH674     3   0.631     0.1456 0.50 0.00 0.50
#&gt; SIH678     3   0.631     0.1456 0.50 0.00 0.50
#&gt; SIH679     2   0.369     0.5751 0.14 0.86 0.00
#&gt; SIH689     3   0.848     0.3806 0.14 0.26 0.60
#&gt; SIH694     3   0.000     0.7786 0.00 0.00 1.00
#&gt; SIH721     3   0.000     0.7786 0.00 0.00 1.00
</code></pre>

<script>
$('#tab-CV-pam-get-classes-2-a').parent().next().next().hide();
$('#tab-CV-pam-get-classes-2-a').click(function(){
  $('#tab-CV-pam-get-classes-2-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-CV-pam-get-classes-3'>
<p><a id='tab-CV-pam-get-classes-3-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 4), get_membership(res, k = 4))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3   p4
#&gt; SIH013     3   0.292     0.6979 0.00 0.14 0.86 0.00
#&gt; SIH014     2   0.498     0.2440 0.00 0.54 0.46 0.00
#&gt; SIH024     3   0.234     0.7459 0.00 0.00 0.90 0.10
#&gt; SIH028     3   0.750     0.3039 0.00 0.24 0.50 0.26
#&gt; SIH031     2   0.681     0.3689 0.00 0.56 0.32 0.12
#&gt; SIH042     3   0.000     0.7788 0.00 0.00 1.00 0.00
#&gt; SIH107     3   0.000     0.7788 0.00 0.00 1.00 0.00
#&gt; SIH114     4   0.000     0.8904 0.00 0.00 0.00 1.00
#&gt; SIH116     2   0.722    -0.0197 0.14 0.44 0.42 0.00
#&gt; SIH117     3   0.292     0.6979 0.00 0.14 0.86 0.00
#&gt; SIH130     2   0.000     0.7058 0.00 1.00 0.00 0.00
#&gt; SIH134     2   0.000     0.7058 0.00 1.00 0.00 0.00
#&gt; SIH186     3   0.398     0.6782 0.00 0.00 0.76 0.24
#&gt; SIH191     4   0.000     0.8904 0.00 0.00 0.00 1.00
#&gt; SIH192     4   0.000     0.8904 0.00 0.00 0.00 1.00
#&gt; SIH196     2   0.398     0.4810 0.00 0.76 0.00 0.24
#&gt; SIH214     3   0.750     0.3039 0.00 0.24 0.50 0.26
#&gt; SIH218     3   0.000     0.7788 0.00 0.00 1.00 0.00
#&gt; SIH232     1   0.000     0.7720 1.00 0.00 0.00 0.00
#&gt; SIH236     4   0.000     0.8904 0.00 0.00 0.00 1.00
#&gt; SIH238     3   0.000     0.7788 0.00 0.00 1.00 0.00
#&gt; SIH241     3   0.413     0.6517 0.00 0.00 0.74 0.26
#&gt; SIH245     2   0.292     0.6831 0.00 0.86 0.14 0.00
#&gt; SIH260     2   0.000     0.7058 0.00 1.00 0.00 0.00
#&gt; SIH287     3   0.471     0.3041 0.00 0.36 0.64 0.00
#&gt; SIH289     3   0.000     0.7788 0.00 0.00 1.00 0.00
#&gt; SIH290     2   0.498     0.2440 0.00 0.54 0.46 0.00
#&gt; SIH295     1   0.000     0.7720 1.00 0.00 0.00 0.00
#&gt; SIH366     1   0.452     0.4714 0.68 0.00 0.32 0.00
#&gt; SIH377     4   0.428     0.5682 0.28 0.00 0.00 0.72
#&gt; SIH380     2   0.292     0.6831 0.00 0.86 0.14 0.00
#&gt; SIH385     3   0.340     0.6563 0.18 0.00 0.82 0.00
#&gt; SIH389     2   0.000     0.7058 0.00 1.00 0.00 0.00
#&gt; SIH391     3   0.413     0.5769 0.00 0.26 0.74 0.00
#&gt; SIH403     4   0.000     0.8904 0.00 0.00 0.00 1.00
#&gt; SIH411     2   0.000     0.7058 0.00 1.00 0.00 0.00
#&gt; SIH427     1   0.471     0.4502 0.64 0.00 0.00 0.36
#&gt; SIH433     3   0.000     0.7788 0.00 0.00 1.00 0.00
#&gt; SIH439     1   0.720     0.3836 0.54 0.28 0.18 0.00
#&gt; SIH442     1   0.000     0.7720 1.00 0.00 0.00 0.00
#&gt; SIH444     3   0.292     0.6979 0.00 0.14 0.86 0.00
#&gt; SIH452     2   0.398     0.5367 0.00 0.76 0.24 0.00
#&gt; SIH461     3   0.000     0.7788 0.00 0.00 1.00 0.00
#&gt; SIH471     3   0.452     0.5080 0.32 0.00 0.68 0.00
#&gt; SIH472     3   0.413     0.6517 0.00 0.00 0.74 0.26
#&gt; SIH481     1   0.471     0.4502 0.64 0.00 0.00 0.36
#&gt; SIH485     2   0.672     0.4275 0.00 0.60 0.14 0.26
#&gt; SIH491     2   0.292     0.6831 0.00 0.86 0.14 0.00
#&gt; SIH508     3   0.398     0.6782 0.00 0.00 0.76 0.24
#&gt; SIH559     1   0.000     0.7720 1.00 0.00 0.00 0.00
#&gt; SIH587     4   0.413     0.5916 0.00 0.26 0.00 0.74
#&gt; SIH625     2   0.000     0.7058 0.00 1.00 0.00 0.00
#&gt; SIH641     1   0.471     0.3980 0.64 0.36 0.00 0.00
#&gt; SIH643     3   0.398     0.6782 0.00 0.00 0.76 0.24
#&gt; SIH674     1   0.000     0.7720 1.00 0.00 0.00 0.00
#&gt; SIH678     1   0.000     0.7720 1.00 0.00 0.00 0.00
#&gt; SIH679     2   0.479     0.3193 0.00 0.62 0.00 0.38
#&gt; SIH689     3   0.702     0.3438 0.32 0.14 0.54 0.00
#&gt; SIH694     3   0.000     0.7788 0.00 0.00 1.00 0.00
#&gt; SIH721     3   0.000     0.7788 0.00 0.00 1.00 0.00
</code></pre>

<script>
$('#tab-CV-pam-get-classes-3-a').parent().next().next().hide();
$('#tab-CV-pam-get-classes-3-a').click(function(){
  $('#tab-CV-pam-get-classes-3-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-CV-pam-get-classes-4'>
<p><a id='tab-CV-pam-get-classes-4-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 5), get_membership(res, k = 5))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3   p4   p5
#&gt; SIH013     4   0.252     0.7957 0.00 0.00 0.14 0.86 0.00
#&gt; SIH014     3   0.423     0.2222 0.00 0.42 0.58 0.00 0.00
#&gt; SIH024     3   0.444     0.6599 0.10 0.00 0.76 0.14 0.00
#&gt; SIH028     2   0.611     0.2858 0.26 0.56 0.18 0.00 0.00
#&gt; SIH031     2   0.000     0.7185 0.00 1.00 0.00 0.00 0.00
#&gt; SIH042     3   0.000     0.7643 0.00 0.00 1.00 0.00 0.00
#&gt; SIH107     3   0.000     0.7643 0.00 0.00 1.00 0.00 0.00
#&gt; SIH114     1   0.000     0.8414 1.00 0.00 0.00 0.00 0.00
#&gt; SIH116     4   0.252     0.7957 0.00 0.00 0.14 0.86 0.00
#&gt; SIH117     4   0.252     0.7957 0.00 0.00 0.14 0.86 0.00
#&gt; SIH130     2   0.252     0.7353 0.00 0.86 0.00 0.14 0.00
#&gt; SIH134     2   0.252     0.7353 0.00 0.86 0.00 0.14 0.00
#&gt; SIH186     3   0.568     0.5643 0.24 0.00 0.62 0.14 0.00
#&gt; SIH191     1   0.000     0.8414 1.00 0.00 0.00 0.00 0.00
#&gt; SIH192     1   0.000     0.8414 1.00 0.00 0.00 0.00 0.00
#&gt; SIH196     4   0.589    -0.0779 0.10 0.44 0.00 0.46 0.00
#&gt; SIH214     2   0.611     0.2858 0.26 0.56 0.18 0.00 0.00
#&gt; SIH218     3   0.000     0.7643 0.00 0.00 1.00 0.00 0.00
#&gt; SIH232     5   0.000     0.8141 0.00 0.00 0.00 0.00 1.00
#&gt; SIH236     1   0.000     0.8414 1.00 0.00 0.00 0.00 0.00
#&gt; SIH238     3   0.000     0.7643 0.00 0.00 1.00 0.00 0.00
#&gt; SIH241     3   0.579     0.4014 0.26 0.14 0.60 0.00 0.00
#&gt; SIH245     2   0.252     0.7271 0.00 0.86 0.14 0.00 0.00
#&gt; SIH260     2   0.252     0.7353 0.00 0.86 0.00 0.14 0.00
#&gt; SIH287     3   0.589     0.3920 0.00 0.28 0.58 0.14 0.00
#&gt; SIH289     3   0.000     0.7643 0.00 0.00 1.00 0.00 0.00
#&gt; SIH290     3   0.423     0.2222 0.00 0.42 0.58 0.00 0.00
#&gt; SIH295     5   0.000     0.8141 0.00 0.00 0.00 0.00 1.00
#&gt; SIH366     5   0.389     0.4796 0.00 0.00 0.32 0.00 0.68
#&gt; SIH377     1   0.368     0.5305 0.72 0.00 0.00 0.00 0.28
#&gt; SIH380     2   0.252     0.7271 0.00 0.86 0.14 0.00 0.00
#&gt; SIH385     3   0.293     0.6146 0.00 0.00 0.82 0.00 0.18
#&gt; SIH389     2   0.252     0.7353 0.00 0.86 0.00 0.14 0.00
#&gt; SIH391     4   0.252     0.7957 0.00 0.00 0.14 0.86 0.00
#&gt; SIH403     1   0.000     0.8414 1.00 0.00 0.00 0.00 0.00
#&gt; SIH411     2   0.252     0.7353 0.00 0.86 0.00 0.14 0.00
#&gt; SIH427     5   0.406     0.4984 0.36 0.00 0.00 0.00 0.64
#&gt; SIH433     3   0.000     0.7643 0.00 0.00 1.00 0.00 0.00
#&gt; SIH439     4   0.389     0.4585 0.00 0.00 0.00 0.68 0.32
#&gt; SIH442     5   0.000     0.8141 0.00 0.00 0.00 0.00 1.00
#&gt; SIH444     4   0.252     0.7957 0.00 0.00 0.14 0.86 0.00
#&gt; SIH452     4   0.252     0.7957 0.00 0.00 0.14 0.86 0.00
#&gt; SIH461     3   0.000     0.7643 0.00 0.00 1.00 0.00 0.00
#&gt; SIH471     3   0.389     0.4914 0.00 0.00 0.68 0.00 0.32
#&gt; SIH472     3   0.579     0.4014 0.26 0.14 0.60 0.00 0.00
#&gt; SIH481     5   0.406     0.4984 0.36 0.00 0.00 0.00 0.64
#&gt; SIH485     2   0.356     0.4576 0.26 0.74 0.00 0.00 0.00
#&gt; SIH491     2   0.252     0.7271 0.00 0.86 0.14 0.00 0.00
#&gt; SIH508     3   0.568     0.5643 0.24 0.00 0.62 0.14 0.00
#&gt; SIH559     5   0.000     0.8141 0.00 0.00 0.00 0.00 1.00
#&gt; SIH587     4   0.368     0.4875 0.28 0.00 0.00 0.72 0.00
#&gt; SIH625     4   0.426     0.0562 0.00 0.44 0.00 0.56 0.00
#&gt; SIH641     5   0.406     0.4067 0.00 0.36 0.00 0.00 0.64
#&gt; SIH643     3   0.568     0.5643 0.24 0.00 0.62 0.14 0.00
#&gt; SIH674     5   0.000     0.8141 0.00 0.00 0.00 0.00 1.00
#&gt; SIH678     5   0.000     0.8141 0.00 0.00 0.00 0.00 1.00
#&gt; SIH679     1   0.589     0.0471 0.46 0.44 0.00 0.10 0.00
#&gt; SIH689     4   0.252     0.7957 0.00 0.00 0.14 0.86 0.00
#&gt; SIH694     3   0.000     0.7643 0.00 0.00 1.00 0.00 0.00
#&gt; SIH721     3   0.000     0.7643 0.00 0.00 1.00 0.00 0.00
</code></pre>

<script>
$('#tab-CV-pam-get-classes-4-a').parent().next().next().hide();
$('#tab-CV-pam-get-classes-4-a').click(function(){
  $('#tab-CV-pam-get-classes-4-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-CV-pam-get-classes-5'>
<p><a id='tab-CV-pam-get-classes-5-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 6), get_membership(res, k = 6))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3   p4   p5   p6
#&gt; SIH013     4   0.226     0.9046 0.00 0.14 0.00 0.86 0.00 0.00
#&gt; SIH014     2   0.604    -0.1839 0.00 0.42 0.30 0.00 0.28 0.00
#&gt; SIH024     3   0.350     0.7896 0.00 0.00 0.68 0.00 0.32 0.00
#&gt; SIH028     6   0.181     0.9364 0.00 0.10 0.00 0.00 0.00 0.90
#&gt; SIH031     6   0.181     0.9364 0.00 0.10 0.00 0.00 0.00 0.90
#&gt; SIH042     5   0.536    -0.1226 0.00 0.00 0.30 0.14 0.56 0.00
#&gt; SIH107     5   0.536    -0.1226 0.00 0.00 0.30 0.14 0.56 0.00
#&gt; SIH114     1   0.181     0.7384 0.90 0.00 0.10 0.00 0.00 0.00
#&gt; SIH116     4   0.226     0.9046 0.00 0.14 0.00 0.86 0.00 0.00
#&gt; SIH117     4   0.226     0.9046 0.00 0.14 0.00 0.86 0.00 0.00
#&gt; SIH130     2   0.000     0.7004 0.00 1.00 0.00 0.00 0.00 0.00
#&gt; SIH134     2   0.000     0.7004 0.00 1.00 0.00 0.00 0.00 0.00
#&gt; SIH186     3   0.472     0.6389 0.14 0.00 0.68 0.00 0.18 0.00
#&gt; SIH191     1   0.181     0.7384 0.90 0.00 0.10 0.00 0.00 0.00
#&gt; SIH192     1   0.181     0.7384 0.90 0.00 0.10 0.00 0.00 0.00
#&gt; SIH196     2   0.399     0.5840 0.00 0.76 0.14 0.00 0.00 0.10
#&gt; SIH214     6   0.181     0.9364 0.00 0.10 0.00 0.00 0.00 0.90
#&gt; SIH218     5   0.536    -0.1226 0.00 0.00 0.30 0.14 0.56 0.00
#&gt; SIH232     5   0.687     0.0299 0.10 0.00 0.32 0.14 0.44 0.00
#&gt; SIH236     1   0.181     0.6921 0.90 0.00 0.00 0.00 0.00 0.10
#&gt; SIH238     5   0.536    -0.1226 0.00 0.00 0.30 0.14 0.56 0.00
#&gt; SIH241     6   0.181     0.8705 0.00 0.00 0.00 0.00 0.10 0.90
#&gt; SIH245     2   0.226     0.6686 0.00 0.86 0.00 0.00 0.14 0.00
#&gt; SIH260     2   0.000     0.7004 0.00 1.00 0.00 0.00 0.00 0.00
#&gt; SIH287     3   0.350     0.7896 0.00 0.00 0.68 0.00 0.32 0.00
#&gt; SIH289     5   0.536    -0.1226 0.00 0.00 0.30 0.14 0.56 0.00
#&gt; SIH290     2   0.604    -0.1839 0.00 0.42 0.30 0.00 0.28 0.00
#&gt; SIH295     5   0.687     0.0299 0.10 0.00 0.32 0.14 0.44 0.00
#&gt; SIH366     5   0.399     0.0537 0.10 0.00 0.00 0.14 0.76 0.00
#&gt; SIH377     1   0.472     0.4775 0.68 0.00 0.18 0.00 0.00 0.14
#&gt; SIH380     2   0.226     0.6686 0.00 0.86 0.00 0.00 0.14 0.00
#&gt; SIH385     5   0.420    -0.2016 0.00 0.00 0.12 0.14 0.74 0.00
#&gt; SIH389     2   0.000     0.7004 0.00 1.00 0.00 0.00 0.00 0.00
#&gt; SIH391     4   0.226     0.9046 0.00 0.14 0.00 0.86 0.00 0.00
#&gt; SIH403     1   0.181     0.7384 0.90 0.00 0.10 0.00 0.00 0.00
#&gt; SIH411     2   0.000     0.7004 0.00 1.00 0.00 0.00 0.00 0.00
#&gt; SIH427     1   0.520     0.4645 0.60 0.00 0.00 0.14 0.26 0.00
#&gt; SIH433     5   0.536    -0.1226 0.00 0.00 0.30 0.14 0.56 0.00
#&gt; SIH439     4   0.543     0.5533 0.00 0.14 0.00 0.54 0.32 0.00
#&gt; SIH442     5   0.687     0.0299 0.10 0.00 0.32 0.14 0.44 0.00
#&gt; SIH444     4   0.226     0.9046 0.00 0.14 0.00 0.86 0.00 0.00
#&gt; SIH452     4   0.226     0.9046 0.00 0.14 0.00 0.86 0.00 0.00
#&gt; SIH461     5   0.536    -0.1226 0.00 0.00 0.30 0.14 0.56 0.00
#&gt; SIH471     3   0.510     0.0715 0.00 0.00 0.62 0.14 0.24 0.00
#&gt; SIH472     6   0.181     0.8705 0.00 0.00 0.00 0.00 0.10 0.90
#&gt; SIH481     1   0.702     0.3178 0.46 0.00 0.14 0.14 0.26 0.00
#&gt; SIH485     6   0.181     0.9364 0.00 0.10 0.00 0.00 0.00 0.90
#&gt; SIH491     2   0.226     0.6686 0.00 0.86 0.00 0.00 0.14 0.00
#&gt; SIH508     3   0.350     0.7896 0.00 0.00 0.68 0.00 0.32 0.00
#&gt; SIH559     5   0.687     0.0299 0.10 0.00 0.32 0.14 0.44 0.00
#&gt; SIH587     4   0.678     0.4498 0.28 0.14 0.00 0.48 0.00 0.10
#&gt; SIH625     2   0.399     0.5840 0.00 0.76 0.14 0.00 0.00 0.10
#&gt; SIH641     2   0.836     0.0184 0.10 0.36 0.14 0.14 0.26 0.00
#&gt; SIH643     3   0.350     0.7896 0.00 0.00 0.68 0.00 0.32 0.00
#&gt; SIH674     5   0.687     0.0299 0.10 0.00 0.32 0.14 0.44 0.00
#&gt; SIH678     5   0.687     0.0299 0.10 0.00 0.32 0.14 0.44 0.00
#&gt; SIH679     2   0.493     0.4195 0.28 0.62 0.00 0.00 0.00 0.10
#&gt; SIH689     4   0.226     0.9046 0.00 0.14 0.00 0.86 0.00 0.00
#&gt; SIH694     5   0.536    -0.1226 0.00 0.00 0.30 0.14 0.56 0.00
#&gt; SIH721     5   0.536    -0.1226 0.00 0.00 0.30 0.14 0.56 0.00
</code></pre>

<script>
$('#tab-CV-pam-get-classes-5-a').parent().next().next().hide();
$('#tab-CV-pam-get-classes-5-a').click(function(){
  $('#tab-CV-pam-get-classes-5-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>
</div>

Heatmaps for the consensus matrix. It visualizes the probability of two
samples to be in a same group.




<script>
$( function() {
	$( '#tabs-CV-pam-consensus-heatmap' ).tabs();
} );
</script>
<div id='tabs-CV-pam-consensus-heatmap'>
<ul>
<li><a href='#tab-CV-pam-consensus-heatmap-1'>k = 2</a></li>
<li><a href='#tab-CV-pam-consensus-heatmap-2'>k = 3</a></li>
<li><a href='#tab-CV-pam-consensus-heatmap-3'>k = 4</a></li>
<li><a href='#tab-CV-pam-consensus-heatmap-4'>k = 5</a></li>
<li><a href='#tab-CV-pam-consensus-heatmap-5'>k = 6</a></li>
</ul>
<div id='tab-CV-pam-consensus-heatmap-1'>
<pre><code class="language-r">consensus_heatmap(res, k = 2)
</code></pre>
<p><img src="figure_cola/tab-CV-pam-consensus-heatmap-1-1.png" alt="plot of chunk tab-CV-pam-consensus-heatmap-1" /></p>

</div>
<div id='tab-CV-pam-consensus-heatmap-2'>
<pre><code class="language-r">consensus_heatmap(res, k = 3)
</code></pre>
<p><img src="figure_cola/tab-CV-pam-consensus-heatmap-2-1.png" alt="plot of chunk tab-CV-pam-consensus-heatmap-2" /></p>

</div>
<div id='tab-CV-pam-consensus-heatmap-3'>
<pre><code class="language-r">consensus_heatmap(res, k = 4)
</code></pre>
<p><img src="figure_cola/tab-CV-pam-consensus-heatmap-3-1.png" alt="plot of chunk tab-CV-pam-consensus-heatmap-3" /></p>

</div>
<div id='tab-CV-pam-consensus-heatmap-4'>
<pre><code class="language-r">consensus_heatmap(res, k = 5)
</code></pre>
<p><img src="figure_cola/tab-CV-pam-consensus-heatmap-4-1.png" alt="plot of chunk tab-CV-pam-consensus-heatmap-4" /></p>

</div>
<div id='tab-CV-pam-consensus-heatmap-5'>
<pre><code class="language-r">consensus_heatmap(res, k = 6)
</code></pre>
<p><img src="figure_cola/tab-CV-pam-consensus-heatmap-5-1.png" alt="plot of chunk tab-CV-pam-consensus-heatmap-5" /></p>

</div>
</div>

Heatmaps for the membership of samples in all partitions to see how consistent they are:





<script>
$( function() {
	$( '#tabs-CV-pam-membership-heatmap' ).tabs();
} );
</script>
<div id='tabs-CV-pam-membership-heatmap'>
<ul>
<li><a href='#tab-CV-pam-membership-heatmap-1'>k = 2</a></li>
<li><a href='#tab-CV-pam-membership-heatmap-2'>k = 3</a></li>
<li><a href='#tab-CV-pam-membership-heatmap-3'>k = 4</a></li>
<li><a href='#tab-CV-pam-membership-heatmap-4'>k = 5</a></li>
<li><a href='#tab-CV-pam-membership-heatmap-5'>k = 6</a></li>
</ul>
<div id='tab-CV-pam-membership-heatmap-1'>
<pre><code class="language-r">membership_heatmap(res, k = 2)
</code></pre>
<p><img src="figure_cola/tab-CV-pam-membership-heatmap-1-1.png" alt="plot of chunk tab-CV-pam-membership-heatmap-1" /></p>

</div>
<div id='tab-CV-pam-membership-heatmap-2'>
<pre><code class="language-r">membership_heatmap(res, k = 3)
</code></pre>
<p><img src="figure_cola/tab-CV-pam-membership-heatmap-2-1.png" alt="plot of chunk tab-CV-pam-membership-heatmap-2" /></p>

</div>
<div id='tab-CV-pam-membership-heatmap-3'>
<pre><code class="language-r">membership_heatmap(res, k = 4)
</code></pre>
<p><img src="figure_cola/tab-CV-pam-membership-heatmap-3-1.png" alt="plot of chunk tab-CV-pam-membership-heatmap-3" /></p>

</div>
<div id='tab-CV-pam-membership-heatmap-4'>
<pre><code class="language-r">membership_heatmap(res, k = 5)
</code></pre>
<p><img src="figure_cola/tab-CV-pam-membership-heatmap-4-1.png" alt="plot of chunk tab-CV-pam-membership-heatmap-4" /></p>

</div>
<div id='tab-CV-pam-membership-heatmap-5'>
<pre><code class="language-r">membership_heatmap(res, k = 6)
</code></pre>
<p><img src="figure_cola/tab-CV-pam-membership-heatmap-5-1.png" alt="plot of chunk tab-CV-pam-membership-heatmap-5" /></p>

</div>
</div>

As soon as the classes for columns are determined, the signatures
that are significantly different between subgroups can be looked for. 
Following are the heatmaps for signatures.




Signature heatmaps where rows are scaled:



<script>
$( function() {
	$( '#tabs-CV-pam-get-signatures' ).tabs();
} );
</script>
<div id='tabs-CV-pam-get-signatures'>
<ul>
<li><a href='#tab-CV-pam-get-signatures-1'>k = 2</a></li>
<li><a href='#tab-CV-pam-get-signatures-2'>k = 3</a></li>
<li><a href='#tab-CV-pam-get-signatures-3'>k = 4</a></li>
<li><a href='#tab-CV-pam-get-signatures-4'>k = 5</a></li>
<li><a href='#tab-CV-pam-get-signatures-5'>k = 6</a></li>
</ul>
<div id='tab-CV-pam-get-signatures-1'>
<pre><code class="language-r">get_signatures(res, k = 2)
</code></pre>
<p><img src="figure_cola/tab-CV-pam-get-signatures-1-1.png" alt="plot of chunk tab-CV-pam-get-signatures-1" /></p>

</div>
<div id='tab-CV-pam-get-signatures-2'>
<pre><code class="language-r">get_signatures(res, k = 3)
</code></pre>
<p><img src="figure_cola/tab-CV-pam-get-signatures-2-1.png" alt="plot of chunk tab-CV-pam-get-signatures-2" /></p>

</div>
<div id='tab-CV-pam-get-signatures-3'>
<pre><code class="language-r">get_signatures(res, k = 4)
</code></pre>
<p><img src="figure_cola/tab-CV-pam-get-signatures-3-1.png" alt="plot of chunk tab-CV-pam-get-signatures-3" /></p>

</div>
<div id='tab-CV-pam-get-signatures-4'>
<pre><code class="language-r">get_signatures(res, k = 5)
</code></pre>
<p><img src="figure_cola/tab-CV-pam-get-signatures-4-1.png" alt="plot of chunk tab-CV-pam-get-signatures-4" /></p>

</div>
<div id='tab-CV-pam-get-signatures-5'>
<pre><code class="language-r">get_signatures(res, k = 6)
</code></pre>
<p><img src="figure_cola/tab-CV-pam-get-signatures-5-1.png" alt="plot of chunk tab-CV-pam-get-signatures-5" /></p>

</div>
</div>



Signature heatmaps where rows are not scaled:


<script>
$( function() {
	$( '#tabs-CV-pam-get-signatures-no-scale' ).tabs();
} );
</script>
<div id='tabs-CV-pam-get-signatures-no-scale'>
<ul>
<li><a href='#tab-CV-pam-get-signatures-no-scale-1'>k = 2</a></li>
<li><a href='#tab-CV-pam-get-signatures-no-scale-2'>k = 3</a></li>
<li><a href='#tab-CV-pam-get-signatures-no-scale-3'>k = 4</a></li>
<li><a href='#tab-CV-pam-get-signatures-no-scale-4'>k = 5</a></li>
<li><a href='#tab-CV-pam-get-signatures-no-scale-5'>k = 6</a></li>
</ul>
<div id='tab-CV-pam-get-signatures-no-scale-1'>
<pre><code class="language-r">get_signatures(res, k = 2, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-CV-pam-get-signatures-no-scale-1-1.png" alt="plot of chunk tab-CV-pam-get-signatures-no-scale-1" /></p>

</div>
<div id='tab-CV-pam-get-signatures-no-scale-2'>
<pre><code class="language-r">get_signatures(res, k = 3, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-CV-pam-get-signatures-no-scale-2-1.png" alt="plot of chunk tab-CV-pam-get-signatures-no-scale-2" /></p>

</div>
<div id='tab-CV-pam-get-signatures-no-scale-3'>
<pre><code class="language-r">get_signatures(res, k = 4, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-CV-pam-get-signatures-no-scale-3-1.png" alt="plot of chunk tab-CV-pam-get-signatures-no-scale-3" /></p>

</div>
<div id='tab-CV-pam-get-signatures-no-scale-4'>
<pre><code class="language-r">get_signatures(res, k = 5, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-CV-pam-get-signatures-no-scale-4-1.png" alt="plot of chunk tab-CV-pam-get-signatures-no-scale-4" /></p>

</div>
<div id='tab-CV-pam-get-signatures-no-scale-5'>
<pre><code class="language-r">get_signatures(res, k = 6, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-CV-pam-get-signatures-no-scale-5-1.png" alt="plot of chunk tab-CV-pam-get-signatures-no-scale-5" /></p>

</div>
</div>



Compare the overlap of signatures from different k:

``` r
compare_signatures(res)
```

![plot of chunk CV-pam-signature_compare](figure_cola/CV-pam-signature_compare-1.png)

`get_signature()` returns a data frame invisibly. To get the list of signatures, the function
call should be assigned to a variable explicitly. In following code, if `plot` argument is set
to `FALSE`, no heatmap is plotted while only the differential analysis is performed.

``` r
# code only for demonstration
tb = get_signature(res, k = ..., plot = FALSE)
```

An example of the output of `tb` is:

```
#>   which_row         fdr    mean_1    mean_2 scaled_mean_1 scaled_mean_2 km
#> 1        38 0.042760348  8.373488  9.131774    -0.5533452     0.5164555  1
#> 2        40 0.018707592  7.106213  8.469186    -0.6173731     0.5762149  1
#> 3        55 0.019134737 10.221463 11.207825    -0.6159697     0.5749050  1
#> 4        59 0.006059896  5.921854  7.869574    -0.6899429     0.6439467  1
#> 5        60 0.018055526  8.928898 10.211722    -0.6204761     0.5791110  1
#> 6        98 0.009384629 15.714769 14.887706     0.6635654    -0.6193277  2
...
```

The columns in `tb` are:

1. `which_row`: row indices corresponding to the input matrix.
2. `fdr`: FDR for the differential test. 
3. `mean_x`: The mean value in group x.
4. `scaled_mean_x`: The mean value in group x after rows are scaled.
5. `km`: Row groups if k-means clustering is applied to rows (which is done by automatically selecting number of clusters).

If there are too many signatures, `top_signatures = ...` can be set to only show the 
signatures with the highest FDRs:

``` r
# code only for demonstration
# e.g. to show the top 500 most significant rows
tb = get_signature(res, k = ..., top_signatures = 500)
```

If the signatures are defined as these which are uniquely high in current group, `diff_method` argument
can be set to `"uniquely_high_in_one_group"`:

``` r
# code only for demonstration
tb = get_signature(res, k = ..., diff_method = "uniquely_high_in_one_group")
```




UMAP plot which shows how samples are separated.


<script>
$( function() {
	$( '#tabs-CV-pam-dimension-reduction' ).tabs();
} );
</script>
<div id='tabs-CV-pam-dimension-reduction'>
<ul>
<li><a href='#tab-CV-pam-dimension-reduction-1'>k = 2</a></li>
<li><a href='#tab-CV-pam-dimension-reduction-2'>k = 3</a></li>
<li><a href='#tab-CV-pam-dimension-reduction-3'>k = 4</a></li>
<li><a href='#tab-CV-pam-dimension-reduction-4'>k = 5</a></li>
<li><a href='#tab-CV-pam-dimension-reduction-5'>k = 6</a></li>
</ul>
<div id='tab-CV-pam-dimension-reduction-1'>
<pre><code class="language-r">dimension_reduction(res, k = 2, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-CV-pam-dimension-reduction-1-1.png" alt="plot of chunk tab-CV-pam-dimension-reduction-1" /></p>

</div>
<div id='tab-CV-pam-dimension-reduction-2'>
<pre><code class="language-r">dimension_reduction(res, k = 3, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-CV-pam-dimension-reduction-2-1.png" alt="plot of chunk tab-CV-pam-dimension-reduction-2" /></p>

</div>
<div id='tab-CV-pam-dimension-reduction-3'>
<pre><code class="language-r">dimension_reduction(res, k = 4, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-CV-pam-dimension-reduction-3-1.png" alt="plot of chunk tab-CV-pam-dimension-reduction-3" /></p>

</div>
<div id='tab-CV-pam-dimension-reduction-4'>
<pre><code class="language-r">dimension_reduction(res, k = 5, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-CV-pam-dimension-reduction-4-1.png" alt="plot of chunk tab-CV-pam-dimension-reduction-4" /></p>

</div>
<div id='tab-CV-pam-dimension-reduction-5'>
<pre><code class="language-r">dimension_reduction(res, k = 6, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-CV-pam-dimension-reduction-5-1.png" alt="plot of chunk tab-CV-pam-dimension-reduction-5" /></p>

</div>
</div>



Following heatmap shows how subgroups are split when increasing `k`:

``` r
collect_classes(res)
```

![plot of chunk CV-pam-collect-classes](figure_cola/CV-pam-collect-classes-1.png)



If matrix rows can be associated to genes, consider to use `functional_enrichment(res,
...)` to perform function enrichment for the signature genes. See [this vignette](https://jokergoo.github.io/cola_vignettes/functional_enrichment.html) for more detailed explanations.


 

---------------------------------------------------



### CV:skmeans






The object with results only for a single top-value method and a single partitioning method 
can be extracted as:

``` r
res = res_list["CV", "skmeans"]
# you can also extract it by
# res = res_list["CV:skmeans"]
```

A summary of `res` and all the functions that can be applied to it:

``` r
res
```

```
#> A 'ConsensusPartition' object with k = 2, 3, 4, 5, 6.
#>   On a matrix with 1900 rows and 60 columns.
#>   Top rows (7) are extracted by 'CV' method.
#>   Subgroups are detected by 'skmeans' method.
#>   Performed in total 250 partitions by row resampling.
#>   Best k for subgroups seems to be 2.
#> 
#> Following methods can be applied to this 'ConsensusPartition' object:
#>  [1] "cola_report"             "collect_classes"         "collect_plots"          
#>  [4] "collect_stats"           "colnames"                "compare_partitions"     
#>  [7] "compare_signatures"      "consensus_heatmap"       "dimension_reduction"    
#> [10] "functional_enrichment"   "get_anno_col"            "get_anno"               
#> [13] "get_classes"             "get_consensus"           "get_matrix"             
#> [16] "get_membership"          "get_param"               "get_signatures"         
#> [19] "get_stats"               "is_best_k"               "is_stable_k"            
#> [22] "membership_heatmap"      "ncol"                    "nrow"                   
#> [25] "plot_ecdf"               "predict_classes"         "rownames"               
#> [28] "select_partition_number" "show"                    "suggest_best_k"         
#> [31] "test_to_known_factors"   "top_rows_heatmap"
```

`collect_plots()` function collects all the plots made from `res` for all `k` (number of subgroups)
into one single page to provide an easy and fast comparison between different `k`.

``` r
collect_plots(res)
```

![plot of chunk CV-skmeans-collect-plots](figure_cola/CV-skmeans-collect-plots-1.png)

The plots are:

- The first row: a plot of the eCDF (empirical cumulative distribution
  function) curves of the consensus matrix for each `k` and the heatmap of
  predicted classes for each `k`.
- The second row: heatmaps of the consensus matrix for each `k`.
- The third row: heatmaps of the membership matrix for each `k`.
- The fouth row: heatmaps of the signatures for each `k`.

All the plots in panels can be made by individual functions and they are
plotted later in this section.

`select_partition_number()` produces several plots showing different
statistics for choosing "optimized" `k`. There are following statistics:

- eCDF curves of the consensus matrix for each `k`;
- 1-PAC. [The PAC score](https://en.wikipedia.org/wiki/Consensus_clustering#Over-interpretation_potential_of_consensus_clustering)
  measures the proportion of the ambiguous subgrouping.
- Mean silhouette score.
- Concordance. The mean probability of fiting the consensus subgroup labels in all
  partitions.
- Area increased. Denote $A_k$ as the area under the eCDF curve for current
  `k`, the area increased is defined as $A_k - A_{k-1}$.
- Rand index. The percent of pairs of samples that are both in a same cluster
  or both are not in a same cluster in the partition of k and k-1.
- Jaccard index. The ratio of pairs of samples are both in a same cluster in
  the partition of k and k-1 and the pairs of samples are both in a same
  cluster in the partition k or k-1.

The detailed explanations of these statistics can be found in [the _cola_
vignette](https://jokergoo.github.io/cola_vignettes/cola.html#toc_13).

Generally speaking, higher 1-PAC score, higher mean silhouette score or higher
concordance corresponds to better partition. Rand index and Jaccard index
measure how similar the current partition is compared to partition with `k-1`.
If they are too similar, we won't accept `k` is better than `k-1`.

``` r
select_partition_number(res)
```

![plot of chunk CV-skmeans-select-partition-number](figure_cola/CV-skmeans-select-partition-number-1.png)

The numeric values for all these statistics can be obtained by `get_stats()`.

``` r
get_stats(res)
```

```
#>   k 1-PAC mean_silhouette concordance area_increased  Rand Jaccard
#> 2 2 0.549           0.890       0.934         0.4695 0.528   0.528
#> 3 3 0.595           0.821       0.888         0.4272 0.723   0.511
#> 4 4 0.577           0.433       0.706         0.1240 0.730   0.356
#> 5 5 0.663           0.670       0.807         0.0635 0.854   0.498
#> 6 6 0.670           0.570       0.721         0.0407 0.926   0.655
```

`suggest_best_k()` suggests the best $k$ based on these statistics. The rules are as follows:

- All $k$ with Jaccard index larger than 0.95 are removed because increasing
  $k$ does not provide enough extra information. If all $k$ are removed, it is
  marked as no subgroup is detected.
- For all $k$ with 1-PAC score larger than 0.9, the maximal $k$ is taken as
  the best $k$, and other $k$ are marked as optional $k$.
- If it does not fit the second rule. The $k$ with the maximal vote of the
  highest 1-PAC score, highest mean silhouette, and highest concordance is
  taken as the best $k$.

``` r
suggest_best_k(res)
```

```
#> [1] 2
```


Following is the table of the partitions (You need to click the **show/hide
code output** link to see it). The membership matrix (columns with name `p*`)
is inferred by
[`clue::cl_consensus()`](https://www.rdocumentation.org/link/cl_consensus?package=clue)
function with the `SE` method. Basically the value in the membership matrix
represents the probability to belong to a certain group. The finall subgroup
label for an item is determined with the group with highest probability it
belongs to.

In `get_classes()` function, the entropy is calculated from the membership
matrix and the silhouette score is calculated from the consensus matrix.



<script>
$( function() {
	$( '#tabs-CV-skmeans-get-classes' ).tabs();
} );
</script>
<div id='tabs-CV-skmeans-get-classes'>
<ul>
<li><a href='#tab-CV-skmeans-get-classes-1'>k = 2</a></li>
<li><a href='#tab-CV-skmeans-get-classes-2'>k = 3</a></li>
<li><a href='#tab-CV-skmeans-get-classes-3'>k = 4</a></li>
<li><a href='#tab-CV-skmeans-get-classes-4'>k = 5</a></li>
<li><a href='#tab-CV-skmeans-get-classes-5'>k = 6</a></li>
</ul>

<div id='tab-CV-skmeans-get-classes-1'>
<p><a id='tab-CV-skmeans-get-classes-1-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 2), get_membership(res, k = 2))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2
#&gt; SIH013     2   0.000      0.939 0.00 1.00
#&gt; SIH014     2   0.000      0.939 0.00 1.00
#&gt; SIH024     2   0.529      0.881 0.12 0.88
#&gt; SIH028     2   0.529      0.881 0.12 0.88
#&gt; SIH031     1   0.795      0.662 0.76 0.24
#&gt; SIH042     2   0.000      0.939 0.00 1.00
#&gt; SIH107     2   0.000      0.939 0.00 1.00
#&gt; SIH114     1   0.327      0.882 0.94 0.06
#&gt; SIH116     2   0.327      0.915 0.06 0.94
#&gt; SIH117     2   0.000      0.939 0.00 1.00
#&gt; SIH130     2   0.327      0.915 0.06 0.94
#&gt; SIH134     2   0.141      0.933 0.02 0.98
#&gt; SIH186     2   0.529      0.881 0.12 0.88
#&gt; SIH191     1   0.327      0.882 0.94 0.06
#&gt; SIH192     1   0.327      0.882 0.94 0.06
#&gt; SIH196     1   0.634      0.798 0.84 0.16
#&gt; SIH214     2   0.529      0.881 0.12 0.88
#&gt; SIH218     2   0.000      0.939 0.00 1.00
#&gt; SIH232     1   0.584      0.862 0.86 0.14
#&gt; SIH236     1   0.242      0.887 0.96 0.04
#&gt; SIH238     2   0.000      0.939 0.00 1.00
#&gt; SIH241     2   0.529      0.881 0.12 0.88
#&gt; SIH245     1   0.760      0.783 0.78 0.22
#&gt; SIH260     2   0.327      0.915 0.06 0.94
#&gt; SIH287     2   0.529      0.881 0.12 0.88
#&gt; SIH289     2   0.000      0.939 0.00 1.00
#&gt; SIH290     2   0.000      0.939 0.00 1.00
#&gt; SIH295     1   0.529      0.865 0.88 0.12
#&gt; SIH366     1   0.529      0.865 0.88 0.12
#&gt; SIH377     1   0.141      0.892 0.98 0.02
#&gt; SIH380     2   0.327      0.915 0.06 0.94
#&gt; SIH385     2   0.327      0.915 0.06 0.94
#&gt; SIH389     2   0.141      0.933 0.02 0.98
#&gt; SIH391     2   0.000      0.939 0.00 1.00
#&gt; SIH403     1   0.327      0.882 0.94 0.06
#&gt; SIH411     2   0.327      0.915 0.06 0.94
#&gt; SIH427     1   0.000      0.894 1.00 0.00
#&gt; SIH433     2   0.000      0.939 0.00 1.00
#&gt; SIH439     1   0.529      0.865 0.88 0.12
#&gt; SIH442     1   0.000      0.894 1.00 0.00
#&gt; SIH444     2   0.000      0.939 0.00 1.00
#&gt; SIH452     2   0.327      0.915 0.06 0.94
#&gt; SIH461     2   0.000      0.939 0.00 1.00
#&gt; SIH471     2   0.242      0.923 0.04 0.96
#&gt; SIH472     2   0.529      0.881 0.12 0.88
#&gt; SIH481     1   0.000      0.894 1.00 0.00
#&gt; SIH485     2   0.529      0.881 0.12 0.88
#&gt; SIH491     2   0.000      0.939 0.00 1.00
#&gt; SIH508     2   0.529      0.881 0.12 0.88
#&gt; SIH559     1   0.000      0.894 1.00 0.00
#&gt; SIH587     1   0.000      0.894 1.00 0.00
#&gt; SIH625     2   0.584      0.876 0.14 0.86
#&gt; SIH641     1   0.971      0.456 0.60 0.40
#&gt; SIH643     2   0.529      0.881 0.12 0.88
#&gt; SIH674     1   0.529      0.865 0.88 0.12
#&gt; SIH678     1   0.529      0.865 0.88 0.12
#&gt; SIH679     1   0.000      0.894 1.00 0.00
#&gt; SIH689     2   0.327      0.915 0.06 0.94
#&gt; SIH694     2   0.000      0.939 0.00 1.00
#&gt; SIH721     2   0.000      0.939 0.00 1.00
</code></pre>

<script>
$('#tab-CV-skmeans-get-classes-1-a').parent().next().next().hide();
$('#tab-CV-skmeans-get-classes-1-a').click(function(){
  $('#tab-CV-skmeans-get-classes-1-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-CV-skmeans-get-classes-2'>
<p><a id='tab-CV-skmeans-get-classes-2-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 3), get_membership(res, k = 3))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3
#&gt; SIH013     3   0.480      0.778 0.00 0.22 0.78
#&gt; SIH014     2   0.480      0.808 0.00 0.78 0.22
#&gt; SIH024     3   0.153      0.874 0.04 0.00 0.96
#&gt; SIH028     2   0.480      0.808 0.00 0.78 0.22
#&gt; SIH031     2   0.480      0.734 0.22 0.78 0.00
#&gt; SIH042     3   0.000      0.885 0.00 0.00 1.00
#&gt; SIH107     3   0.000      0.885 0.00 0.00 1.00
#&gt; SIH114     1   0.369      0.837 0.86 0.00 0.14
#&gt; SIH116     3   0.714      0.730 0.08 0.22 0.70
#&gt; SIH117     3   0.480      0.778 0.00 0.22 0.78
#&gt; SIH130     2   0.000      0.801 0.00 1.00 0.00
#&gt; SIH134     2   0.000      0.801 0.00 1.00 0.00
#&gt; SIH186     3   0.153      0.874 0.04 0.00 0.96
#&gt; SIH191     1   0.369      0.837 0.86 0.00 0.14
#&gt; SIH192     1   0.369      0.837 0.86 0.00 0.14
#&gt; SIH196     2   0.429      0.640 0.18 0.82 0.00
#&gt; SIH214     2   0.480      0.808 0.00 0.78 0.22
#&gt; SIH218     3   0.000      0.885 0.00 0.00 1.00
#&gt; SIH232     1   0.153      0.896 0.96 0.00 0.04
#&gt; SIH236     1   0.369      0.823 0.86 0.14 0.00
#&gt; SIH238     3   0.000      0.885 0.00 0.00 1.00
#&gt; SIH241     3   0.153      0.874 0.04 0.00 0.96
#&gt; SIH245     2   0.480      0.734 0.22 0.78 0.00
#&gt; SIH260     2   0.000      0.801 0.00 1.00 0.00
#&gt; SIH287     2   0.480      0.808 0.00 0.78 0.22
#&gt; SIH289     3   0.000      0.885 0.00 0.00 1.00
#&gt; SIH290     2   0.480      0.808 0.00 0.78 0.22
#&gt; SIH295     1   0.153      0.896 0.96 0.00 0.04
#&gt; SIH366     1   0.153      0.896 0.96 0.00 0.04
#&gt; SIH377     1   0.000      0.898 1.00 0.00 0.00
#&gt; SIH380     2   0.597      0.806 0.06 0.78 0.16
#&gt; SIH385     3   0.369      0.808 0.14 0.00 0.86
#&gt; SIH389     2   0.000      0.801 0.00 1.00 0.00
#&gt; SIH391     3   0.480      0.778 0.00 0.22 0.78
#&gt; SIH403     1   0.369      0.837 0.86 0.00 0.14
#&gt; SIH411     2   0.000      0.801 0.00 1.00 0.00
#&gt; SIH427     1   0.000      0.898 1.00 0.00 0.00
#&gt; SIH433     3   0.000      0.885 0.00 0.00 1.00
#&gt; SIH439     1   0.623      0.715 0.74 0.22 0.04
#&gt; SIH442     1   0.000      0.898 1.00 0.00 0.00
#&gt; SIH444     3   0.480      0.778 0.00 0.22 0.78
#&gt; SIH452     3   0.714      0.730 0.08 0.22 0.70
#&gt; SIH461     3   0.000      0.885 0.00 0.00 1.00
#&gt; SIH471     3   0.369      0.808 0.14 0.00 0.86
#&gt; SIH472     3   0.153      0.874 0.04 0.00 0.96
#&gt; SIH481     1   0.000      0.898 1.00 0.00 0.00
#&gt; SIH485     2   0.480      0.808 0.00 0.78 0.22
#&gt; SIH491     2   0.480      0.808 0.00 0.78 0.22
#&gt; SIH508     3   0.153      0.874 0.04 0.00 0.96
#&gt; SIH559     1   0.000      0.898 1.00 0.00 0.00
#&gt; SIH587     1   0.480      0.734 0.78 0.22 0.00
#&gt; SIH625     2   0.000      0.801 0.00 1.00 0.00
#&gt; SIH641     2   0.556      0.659 0.30 0.70 0.00
#&gt; SIH643     3   0.153      0.874 0.04 0.00 0.96
#&gt; SIH674     1   0.153      0.896 0.96 0.00 0.04
#&gt; SIH678     1   0.153      0.896 0.96 0.00 0.04
#&gt; SIH679     2   0.583      0.516 0.34 0.66 0.00
#&gt; SIH689     3   0.714      0.730 0.08 0.22 0.70
#&gt; SIH694     3   0.000      0.885 0.00 0.00 1.00
#&gt; SIH721     3   0.000      0.885 0.00 0.00 1.00
</code></pre>

<script>
$('#tab-CV-skmeans-get-classes-2-a').parent().next().next().hide();
$('#tab-CV-skmeans-get-classes-2-a').click(function(){
  $('#tab-CV-skmeans-get-classes-2-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-CV-skmeans-get-classes-3'>
<p><a id='tab-CV-skmeans-get-classes-3-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 4), get_membership(res, k = 4))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3   p4
#&gt; SIH013     3  0.0000    0.56222 0.00 0.00 1.00 0.00
#&gt; SIH014     2  0.4624    0.64806 0.34 0.66 0.00 0.00
#&gt; SIH024     4  0.5915    0.38884 0.00 0.40 0.04 0.56
#&gt; SIH028     2  0.5173    0.64589 0.32 0.66 0.00 0.02
#&gt; SIH031     1  0.5535   -0.45163 0.56 0.42 0.00 0.02
#&gt; SIH042     3  0.5606    0.64795 0.00 0.48 0.50 0.02
#&gt; SIH107     3  0.5606    0.64795 0.00 0.48 0.50 0.02
#&gt; SIH114     4  0.0707    0.48006 0.02 0.00 0.00 0.98
#&gt; SIH116     3  0.2345    0.49026 0.10 0.00 0.90 0.00
#&gt; SIH117     3  0.0000    0.56222 0.00 0.00 1.00 0.00
#&gt; SIH130     2  0.7261    0.61187 0.34 0.50 0.16 0.00
#&gt; SIH134     2  0.7497    0.57508 0.26 0.50 0.24 0.00
#&gt; SIH186     4  0.5915    0.38884 0.00 0.40 0.04 0.56
#&gt; SIH191     4  0.0707    0.48006 0.02 0.00 0.00 0.98
#&gt; SIH192     4  0.0707    0.48006 0.02 0.00 0.00 0.98
#&gt; SIH196     4  0.7909    0.37685 0.02 0.16 0.36 0.46
#&gt; SIH214     2  0.5173    0.64589 0.32 0.66 0.00 0.02
#&gt; SIH218     3  0.5606    0.64795 0.00 0.48 0.50 0.02
#&gt; SIH232     1  0.4624    0.66333 0.66 0.00 0.00 0.34
#&gt; SIH236     4  0.0707    0.48411 0.00 0.00 0.02 0.98
#&gt; SIH238     3  0.5606    0.64795 0.00 0.48 0.50 0.02
#&gt; SIH241     2  0.7493   -0.50966 0.00 0.48 0.32 0.20
#&gt; SIH245     1  0.5000   -0.56503 0.50 0.50 0.00 0.00
#&gt; SIH260     2  0.7594    0.55808 0.26 0.48 0.26 0.00
#&gt; SIH287     4  0.7544    0.11305 0.34 0.20 0.00 0.46
#&gt; SIH289     3  0.5606    0.64795 0.00 0.48 0.50 0.02
#&gt; SIH290     2  0.4624    0.64806 0.34 0.66 0.00 0.00
#&gt; SIH295     1  0.4624    0.66333 0.66 0.00 0.00 0.34
#&gt; SIH366     1  0.6649    0.57794 0.56 0.00 0.10 0.34
#&gt; SIH377     1  0.4907    0.61447 0.58 0.00 0.00 0.42
#&gt; SIH380     2  0.4855    0.62024 0.40 0.60 0.00 0.00
#&gt; SIH385     1  0.7816   -0.26549 0.40 0.34 0.26 0.00
#&gt; SIH389     2  0.7497    0.57508 0.26 0.50 0.24 0.00
#&gt; SIH391     3  0.0000    0.56222 0.00 0.00 1.00 0.00
#&gt; SIH403     4  0.0707    0.48006 0.02 0.00 0.00 0.98
#&gt; SIH411     2  0.7261    0.61187 0.34 0.50 0.16 0.00
#&gt; SIH427     1  0.4948    0.59404 0.56 0.00 0.00 0.44
#&gt; SIH433     3  0.5606    0.64795 0.00 0.48 0.50 0.02
#&gt; SIH439     3  0.5986   -0.00640 0.32 0.00 0.62 0.06
#&gt; SIH442     1  0.4624    0.66333 0.66 0.00 0.00 0.34
#&gt; SIH444     3  0.0000    0.56222 0.00 0.00 1.00 0.00
#&gt; SIH452     3  0.0707    0.54877 0.02 0.00 0.98 0.00
#&gt; SIH461     3  0.5606    0.64795 0.00 0.48 0.50 0.02
#&gt; SIH471     2  0.7414   -0.54652 0.18 0.48 0.34 0.00
#&gt; SIH472     2  0.7493   -0.50966 0.00 0.48 0.32 0.20
#&gt; SIH481     1  0.4907    0.61447 0.58 0.00 0.00 0.42
#&gt; SIH485     2  0.5173    0.64589 0.32 0.66 0.00 0.02
#&gt; SIH491     2  0.4624    0.64806 0.34 0.66 0.00 0.00
#&gt; SIH508     4  0.5915    0.38884 0.00 0.40 0.04 0.56
#&gt; SIH559     1  0.4624    0.66333 0.66 0.00 0.00 0.34
#&gt; SIH587     4  0.6248    0.42933 0.10 0.00 0.26 0.64
#&gt; SIH625     4  0.9632    0.16778 0.18 0.18 0.26 0.38
#&gt; SIH641     1  0.3400   -0.00361 0.82 0.18 0.00 0.00
#&gt; SIH643     4  0.5915    0.38884 0.00 0.40 0.04 0.56
#&gt; SIH674     1  0.4624    0.66333 0.66 0.00 0.00 0.34
#&gt; SIH678     1  0.4624    0.66333 0.66 0.00 0.00 0.34
#&gt; SIH679     4  0.7770    0.35450 0.18 0.16 0.06 0.60
#&gt; SIH689     3  0.2345    0.49026 0.10 0.00 0.90 0.00
#&gt; SIH694     3  0.5606    0.64795 0.00 0.48 0.50 0.02
#&gt; SIH721     3  0.5606    0.64795 0.00 0.48 0.50 0.02
</code></pre>

<script>
$('#tab-CV-skmeans-get-classes-3-a').parent().next().next().hide();
$('#tab-CV-skmeans-get-classes-3-a').click(function(){
  $('#tab-CV-skmeans-get-classes-3-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-CV-skmeans-get-classes-4'>
<p><a id='tab-CV-skmeans-get-classes-4-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 5), get_membership(res, k = 5))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3   p4   p5
#&gt; SIH013     4  0.0000      0.945 0.00 0.00 0.00 1.00 0.00
#&gt; SIH014     2  0.2732      0.703 0.00 0.84 0.16 0.00 0.00
#&gt; SIH024     1  0.5425      0.500 0.52 0.06 0.42 0.00 0.00
#&gt; SIH028     2  0.5444      0.571 0.18 0.66 0.16 0.00 0.00
#&gt; SIH031     2  0.7188      0.459 0.16 0.56 0.10 0.00 0.18
#&gt; SIH042     3  0.2732      0.849 0.00 0.00 0.84 0.16 0.00
#&gt; SIH107     3  0.2732      0.849 0.00 0.00 0.84 0.16 0.00
#&gt; SIH114     1  0.0609      0.705 0.98 0.00 0.00 0.00 0.02
#&gt; SIH116     4  0.0000      0.945 0.00 0.00 0.00 1.00 0.00
#&gt; SIH117     4  0.0000      0.945 0.00 0.00 0.00 1.00 0.00
#&gt; SIH130     2  0.2732      0.705 0.00 0.84 0.00 0.16 0.00
#&gt; SIH134     2  0.2732      0.705 0.00 0.84 0.00 0.16 0.00
#&gt; SIH186     1  0.5425      0.500 0.52 0.06 0.42 0.00 0.00
#&gt; SIH191     1  0.0609      0.705 0.98 0.00 0.00 0.00 0.02
#&gt; SIH192     1  0.0609      0.705 0.98 0.00 0.00 0.00 0.02
#&gt; SIH196     1  0.5293      0.564 0.68 0.24 0.06 0.02 0.00
#&gt; SIH214     2  0.5444      0.571 0.18 0.66 0.16 0.00 0.00
#&gt; SIH218     3  0.2732      0.849 0.00 0.00 0.84 0.16 0.00
#&gt; SIH232     5  0.0000      0.835 0.00 0.00 0.00 0.00 1.00
#&gt; SIH236     1  0.0609      0.705 0.98 0.00 0.00 0.00 0.02
#&gt; SIH238     3  0.2732      0.849 0.00 0.00 0.84 0.16 0.00
#&gt; SIH241     3  0.5820      0.415 0.24 0.10 0.64 0.02 0.00
#&gt; SIH245     2  0.3424      0.595 0.00 0.76 0.00 0.00 0.24
#&gt; SIH260     2  0.2929      0.691 0.00 0.82 0.00 0.18 0.00
#&gt; SIH287     2  0.5673     -0.120 0.42 0.50 0.08 0.00 0.00
#&gt; SIH289     3  0.2732      0.849 0.00 0.00 0.84 0.16 0.00
#&gt; SIH290     2  0.2732      0.703 0.00 0.84 0.16 0.00 0.00
#&gt; SIH295     5  0.0000      0.835 0.00 0.00 0.00 0.00 1.00
#&gt; SIH366     5  0.2732      0.692 0.00 0.00 0.16 0.00 0.84
#&gt; SIH377     5  0.3852      0.711 0.22 0.00 0.02 0.00 0.76
#&gt; SIH380     2  0.3421      0.703 0.00 0.84 0.08 0.00 0.08
#&gt; SIH385     3  0.5579      0.542 0.00 0.00 0.60 0.10 0.30
#&gt; SIH389     2  0.2732      0.705 0.00 0.84 0.00 0.16 0.00
#&gt; SIH391     4  0.0000      0.945 0.00 0.00 0.00 1.00 0.00
#&gt; SIH403     1  0.0609      0.705 0.98 0.00 0.00 0.00 0.02
#&gt; SIH411     2  0.2732      0.705 0.00 0.84 0.00 0.16 0.00
#&gt; SIH427     5  0.3983      0.583 0.34 0.00 0.00 0.00 0.66
#&gt; SIH433     3  0.2732      0.849 0.00 0.00 0.84 0.16 0.00
#&gt; SIH439     4  0.3796      0.566 0.00 0.00 0.00 0.70 0.30
#&gt; SIH442     5  0.0609      0.834 0.02 0.00 0.00 0.00 0.98
#&gt; SIH444     4  0.0000      0.945 0.00 0.00 0.00 1.00 0.00
#&gt; SIH452     4  0.0609      0.929 0.00 0.00 0.00 0.98 0.02
#&gt; SIH461     3  0.2732      0.849 0.00 0.00 0.84 0.16 0.00
#&gt; SIH471     3  0.6344      0.299 0.00 0.00 0.44 0.16 0.40
#&gt; SIH472     3  0.6101      0.497 0.18 0.10 0.66 0.06 0.00
#&gt; SIH481     5  0.3796      0.642 0.30 0.00 0.00 0.00 0.70
#&gt; SIH485     2  0.5444      0.571 0.18 0.66 0.16 0.00 0.00
#&gt; SIH491     2  0.2732      0.703 0.00 0.84 0.16 0.00 0.00
#&gt; SIH508     1  0.5425      0.500 0.52 0.06 0.42 0.00 0.00
#&gt; SIH559     5  0.1216      0.830 0.02 0.00 0.02 0.00 0.96
#&gt; SIH587     1  0.4644      0.450 0.68 0.00 0.00 0.28 0.04
#&gt; SIH625     2  0.6313     -0.202 0.44 0.46 0.06 0.04 0.00
#&gt; SIH641     5  0.4126      0.321 0.00 0.38 0.00 0.00 0.62
#&gt; SIH643     1  0.5425      0.500 0.52 0.06 0.42 0.00 0.00
#&gt; SIH674     5  0.0000      0.835 0.00 0.00 0.00 0.00 1.00
#&gt; SIH678     5  0.0000      0.835 0.00 0.00 0.00 0.00 1.00
#&gt; SIH679     1  0.3895      0.395 0.68 0.32 0.00 0.00 0.00
#&gt; SIH689     4  0.0000      0.945 0.00 0.00 0.00 1.00 0.00
#&gt; SIH694     3  0.2732      0.849 0.00 0.00 0.84 0.16 0.00
#&gt; SIH721     3  0.2732      0.849 0.00 0.00 0.84 0.16 0.00
</code></pre>

<script>
$('#tab-CV-skmeans-get-classes-4-a').parent().next().next().hide();
$('#tab-CV-skmeans-get-classes-4-a').click(function(){
  $('#tab-CV-skmeans-get-classes-4-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-CV-skmeans-get-classes-5'>
<p><a id='tab-CV-skmeans-get-classes-5-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 6), get_membership(res, k = 6))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3   p4   p5   p6
#&gt; SIH013     4  0.4723    0.79771 0.00 0.14 0.00 0.68 0.00 0.18
#&gt; SIH014     2  0.3351    0.62251 0.00 0.80 0.04 0.00 0.00 0.16
#&gt; SIH024     3  0.2793    0.67612 0.00 0.00 0.80 0.00 0.00 0.20
#&gt; SIH028     2  0.7933    0.28935 0.28 0.30 0.14 0.26 0.00 0.02
#&gt; SIH031     4  0.7656   -0.41608 0.28 0.26 0.18 0.28 0.00 0.00
#&gt; SIH042     6  0.0000    0.83842 0.00 0.00 0.00 0.00 0.00 1.00
#&gt; SIH107     6  0.0000    0.83842 0.00 0.00 0.00 0.00 0.00 1.00
#&gt; SIH114     1  0.4348    0.58383 0.64 0.00 0.32 0.00 0.04 0.00
#&gt; SIH116     4  0.4393    0.79239 0.00 0.14 0.00 0.72 0.00 0.14
#&gt; SIH117     4  0.4723    0.79771 0.00 0.14 0.00 0.68 0.00 0.18
#&gt; SIH130     2  0.2725    0.62354 0.06 0.88 0.04 0.02 0.00 0.00
#&gt; SIH134     2  0.1092    0.63940 0.02 0.96 0.00 0.02 0.00 0.00
#&gt; SIH186     3  0.2793    0.67612 0.00 0.00 0.80 0.00 0.00 0.20
#&gt; SIH191     1  0.4348    0.58383 0.64 0.00 0.32 0.00 0.04 0.00
#&gt; SIH192     1  0.4348    0.58383 0.64 0.00 0.32 0.00 0.04 0.00
#&gt; SIH196     3  0.6059    0.13760 0.36 0.26 0.38 0.00 0.00 0.00
#&gt; SIH214     2  0.7933    0.28935 0.28 0.30 0.14 0.26 0.00 0.02
#&gt; SIH218     6  0.0000    0.83842 0.00 0.00 0.00 0.00 0.00 1.00
#&gt; SIH232     5  0.0547    0.78873 0.00 0.00 0.00 0.02 0.98 0.00
#&gt; SIH236     1  0.3821    0.55700 0.74 0.00 0.22 0.00 0.04 0.00
#&gt; SIH238     6  0.0000    0.83842 0.00 0.00 0.00 0.00 0.00 1.00
#&gt; SIH241     1  0.7515   -0.12509 0.32 0.00 0.14 0.26 0.00 0.28
#&gt; SIH245     2  0.5139    0.58105 0.04 0.72 0.08 0.02 0.14 0.00
#&gt; SIH260     2  0.2190    0.61830 0.04 0.90 0.00 0.06 0.00 0.00
#&gt; SIH287     3  0.2941    0.53086 0.00 0.22 0.78 0.00 0.00 0.00
#&gt; SIH289     6  0.0000    0.83842 0.00 0.00 0.00 0.00 0.00 1.00
#&gt; SIH290     2  0.3351    0.62251 0.00 0.80 0.04 0.00 0.00 0.16
#&gt; SIH295     5  0.0000    0.79520 0.00 0.00 0.00 0.00 1.00 0.00
#&gt; SIH366     5  0.3506    0.62139 0.00 0.02 0.00 0.02 0.80 0.16
#&gt; SIH377     5  0.3499    0.45903 0.32 0.00 0.00 0.00 0.68 0.00
#&gt; SIH380     2  0.5673    0.60152 0.04 0.72 0.08 0.02 0.08 0.06
#&gt; SIH385     6  0.5919    0.43697 0.04 0.02 0.04 0.02 0.26 0.62
#&gt; SIH389     2  0.1092    0.63940 0.02 0.96 0.00 0.02 0.00 0.00
#&gt; SIH391     4  0.4723    0.79771 0.00 0.14 0.00 0.68 0.00 0.18
#&gt; SIH403     1  0.4348    0.58383 0.64 0.00 0.32 0.00 0.04 0.00
#&gt; SIH411     2  0.1807    0.63686 0.06 0.92 0.00 0.02 0.00 0.00
#&gt; SIH427     1  0.3828    0.05667 0.56 0.00 0.00 0.00 0.44 0.00
#&gt; SIH433     6  0.0000    0.83842 0.00 0.00 0.00 0.00 0.00 1.00
#&gt; SIH439     4  0.5324    0.36363 0.00 0.12 0.00 0.54 0.34 0.00
#&gt; SIH442     5  0.0547    0.79158 0.02 0.00 0.00 0.00 0.98 0.00
#&gt; SIH444     4  0.4723    0.79771 0.00 0.14 0.00 0.68 0.00 0.18
#&gt; SIH452     4  0.4903    0.78689 0.00 0.14 0.00 0.70 0.02 0.14
#&gt; SIH461     6  0.0000    0.83842 0.00 0.00 0.00 0.00 0.00 1.00
#&gt; SIH471     6  0.4534    0.27608 0.00 0.00 0.00 0.04 0.38 0.58
#&gt; SIH472     6  0.7426    0.00878 0.30 0.00 0.12 0.26 0.00 0.32
#&gt; SIH481     5  0.3706    0.28165 0.38 0.00 0.00 0.00 0.62 0.00
#&gt; SIH485     2  0.7933    0.28935 0.28 0.30 0.14 0.26 0.00 0.02
#&gt; SIH491     2  0.3351    0.62251 0.00 0.80 0.04 0.00 0.00 0.16
#&gt; SIH508     3  0.2793    0.67612 0.00 0.00 0.80 0.00 0.00 0.20
#&gt; SIH559     5  0.0547    0.79158 0.02 0.00 0.00 0.00 0.98 0.00
#&gt; SIH587     1  0.6097    0.41473 0.60 0.00 0.08 0.18 0.14 0.00
#&gt; SIH625     3  0.5452    0.19314 0.12 0.44 0.44 0.00 0.00 0.00
#&gt; SIH641     5  0.6366    0.09445 0.04 0.36 0.06 0.04 0.50 0.00
#&gt; SIH643     3  0.2793    0.67612 0.00 0.00 0.80 0.00 0.00 0.20
#&gt; SIH674     5  0.0000    0.79520 0.00 0.00 0.00 0.00 1.00 0.00
#&gt; SIH678     5  0.0000    0.79520 0.00 0.00 0.00 0.00 1.00 0.00
#&gt; SIH679     1  0.5236    0.33373 0.66 0.22 0.08 0.00 0.04 0.00
#&gt; SIH689     4  0.4393    0.79239 0.00 0.14 0.00 0.72 0.00 0.14
#&gt; SIH694     6  0.0000    0.83842 0.00 0.00 0.00 0.00 0.00 1.00
#&gt; SIH721     6  0.0000    0.83842 0.00 0.00 0.00 0.00 0.00 1.00
</code></pre>

<script>
$('#tab-CV-skmeans-get-classes-5-a').parent().next().next().hide();
$('#tab-CV-skmeans-get-classes-5-a').click(function(){
  $('#tab-CV-skmeans-get-classes-5-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>
</div>

Heatmaps for the consensus matrix. It visualizes the probability of two
samples to be in a same group.




<script>
$( function() {
	$( '#tabs-CV-skmeans-consensus-heatmap' ).tabs();
} );
</script>
<div id='tabs-CV-skmeans-consensus-heatmap'>
<ul>
<li><a href='#tab-CV-skmeans-consensus-heatmap-1'>k = 2</a></li>
<li><a href='#tab-CV-skmeans-consensus-heatmap-2'>k = 3</a></li>
<li><a href='#tab-CV-skmeans-consensus-heatmap-3'>k = 4</a></li>
<li><a href='#tab-CV-skmeans-consensus-heatmap-4'>k = 5</a></li>
<li><a href='#tab-CV-skmeans-consensus-heatmap-5'>k = 6</a></li>
</ul>
<div id='tab-CV-skmeans-consensus-heatmap-1'>
<pre><code class="language-r">consensus_heatmap(res, k = 2)
</code></pre>
<p><img src="figure_cola/tab-CV-skmeans-consensus-heatmap-1-1.png" alt="plot of chunk tab-CV-skmeans-consensus-heatmap-1" /></p>

</div>
<div id='tab-CV-skmeans-consensus-heatmap-2'>
<pre><code class="language-r">consensus_heatmap(res, k = 3)
</code></pre>
<p><img src="figure_cola/tab-CV-skmeans-consensus-heatmap-2-1.png" alt="plot of chunk tab-CV-skmeans-consensus-heatmap-2" /></p>

</div>
<div id='tab-CV-skmeans-consensus-heatmap-3'>
<pre><code class="language-r">consensus_heatmap(res, k = 4)
</code></pre>
<p><img src="figure_cola/tab-CV-skmeans-consensus-heatmap-3-1.png" alt="plot of chunk tab-CV-skmeans-consensus-heatmap-3" /></p>

</div>
<div id='tab-CV-skmeans-consensus-heatmap-4'>
<pre><code class="language-r">consensus_heatmap(res, k = 5)
</code></pre>
<p><img src="figure_cola/tab-CV-skmeans-consensus-heatmap-4-1.png" alt="plot of chunk tab-CV-skmeans-consensus-heatmap-4" /></p>

</div>
<div id='tab-CV-skmeans-consensus-heatmap-5'>
<pre><code class="language-r">consensus_heatmap(res, k = 6)
</code></pre>
<p><img src="figure_cola/tab-CV-skmeans-consensus-heatmap-5-1.png" alt="plot of chunk tab-CV-skmeans-consensus-heatmap-5" /></p>

</div>
</div>

Heatmaps for the membership of samples in all partitions to see how consistent they are:





<script>
$( function() {
	$( '#tabs-CV-skmeans-membership-heatmap' ).tabs();
} );
</script>
<div id='tabs-CV-skmeans-membership-heatmap'>
<ul>
<li><a href='#tab-CV-skmeans-membership-heatmap-1'>k = 2</a></li>
<li><a href='#tab-CV-skmeans-membership-heatmap-2'>k = 3</a></li>
<li><a href='#tab-CV-skmeans-membership-heatmap-3'>k = 4</a></li>
<li><a href='#tab-CV-skmeans-membership-heatmap-4'>k = 5</a></li>
<li><a href='#tab-CV-skmeans-membership-heatmap-5'>k = 6</a></li>
</ul>
<div id='tab-CV-skmeans-membership-heatmap-1'>
<pre><code class="language-r">membership_heatmap(res, k = 2)
</code></pre>
<p><img src="figure_cola/tab-CV-skmeans-membership-heatmap-1-1.png" alt="plot of chunk tab-CV-skmeans-membership-heatmap-1" /></p>

</div>
<div id='tab-CV-skmeans-membership-heatmap-2'>
<pre><code class="language-r">membership_heatmap(res, k = 3)
</code></pre>
<p><img src="figure_cola/tab-CV-skmeans-membership-heatmap-2-1.png" alt="plot of chunk tab-CV-skmeans-membership-heatmap-2" /></p>

</div>
<div id='tab-CV-skmeans-membership-heatmap-3'>
<pre><code class="language-r">membership_heatmap(res, k = 4)
</code></pre>
<p><img src="figure_cola/tab-CV-skmeans-membership-heatmap-3-1.png" alt="plot of chunk tab-CV-skmeans-membership-heatmap-3" /></p>

</div>
<div id='tab-CV-skmeans-membership-heatmap-4'>
<pre><code class="language-r">membership_heatmap(res, k = 5)
</code></pre>
<p><img src="figure_cola/tab-CV-skmeans-membership-heatmap-4-1.png" alt="plot of chunk tab-CV-skmeans-membership-heatmap-4" /></p>

</div>
<div id='tab-CV-skmeans-membership-heatmap-5'>
<pre><code class="language-r">membership_heatmap(res, k = 6)
</code></pre>
<p><img src="figure_cola/tab-CV-skmeans-membership-heatmap-5-1.png" alt="plot of chunk tab-CV-skmeans-membership-heatmap-5" /></p>

</div>
</div>

As soon as the classes for columns are determined, the signatures
that are significantly different between subgroups can be looked for. 
Following are the heatmaps for signatures.




Signature heatmaps where rows are scaled:



<script>
$( function() {
	$( '#tabs-CV-skmeans-get-signatures' ).tabs();
} );
</script>
<div id='tabs-CV-skmeans-get-signatures'>
<ul>
<li><a href='#tab-CV-skmeans-get-signatures-1'>k = 2</a></li>
<li><a href='#tab-CV-skmeans-get-signatures-2'>k = 3</a></li>
<li><a href='#tab-CV-skmeans-get-signatures-3'>k = 4</a></li>
<li><a href='#tab-CV-skmeans-get-signatures-4'>k = 5</a></li>
<li><a href='#tab-CV-skmeans-get-signatures-5'>k = 6</a></li>
</ul>
<div id='tab-CV-skmeans-get-signatures-1'>
<pre><code class="language-r">get_signatures(res, k = 2)
</code></pre>
<p><img src="figure_cola/tab-CV-skmeans-get-signatures-1-1.png" alt="plot of chunk tab-CV-skmeans-get-signatures-1" /></p>

</div>
<div id='tab-CV-skmeans-get-signatures-2'>
<pre><code class="language-r">get_signatures(res, k = 3)
</code></pre>
<p><img src="figure_cola/tab-CV-skmeans-get-signatures-2-1.png" alt="plot of chunk tab-CV-skmeans-get-signatures-2" /></p>

</div>
<div id='tab-CV-skmeans-get-signatures-3'>
<pre><code class="language-r">get_signatures(res, k = 4)
</code></pre>
<p><img src="figure_cola/tab-CV-skmeans-get-signatures-3-1.png" alt="plot of chunk tab-CV-skmeans-get-signatures-3" /></p>

</div>
<div id='tab-CV-skmeans-get-signatures-4'>
<pre><code class="language-r">get_signatures(res, k = 5)
</code></pre>
<p><img src="figure_cola/tab-CV-skmeans-get-signatures-4-1.png" alt="plot of chunk tab-CV-skmeans-get-signatures-4" /></p>

</div>
<div id='tab-CV-skmeans-get-signatures-5'>
<pre><code class="language-r">get_signatures(res, k = 6)
</code></pre>
<p><img src="figure_cola/tab-CV-skmeans-get-signatures-5-1.png" alt="plot of chunk tab-CV-skmeans-get-signatures-5" /></p>

</div>
</div>



Signature heatmaps where rows are not scaled:


<script>
$( function() {
	$( '#tabs-CV-skmeans-get-signatures-no-scale' ).tabs();
} );
</script>
<div id='tabs-CV-skmeans-get-signatures-no-scale'>
<ul>
<li><a href='#tab-CV-skmeans-get-signatures-no-scale-1'>k = 2</a></li>
<li><a href='#tab-CV-skmeans-get-signatures-no-scale-2'>k = 3</a></li>
<li><a href='#tab-CV-skmeans-get-signatures-no-scale-3'>k = 4</a></li>
<li><a href='#tab-CV-skmeans-get-signatures-no-scale-4'>k = 5</a></li>
<li><a href='#tab-CV-skmeans-get-signatures-no-scale-5'>k = 6</a></li>
</ul>
<div id='tab-CV-skmeans-get-signatures-no-scale-1'>
<pre><code class="language-r">get_signatures(res, k = 2, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-CV-skmeans-get-signatures-no-scale-1-1.png" alt="plot of chunk tab-CV-skmeans-get-signatures-no-scale-1" /></p>

</div>
<div id='tab-CV-skmeans-get-signatures-no-scale-2'>
<pre><code class="language-r">get_signatures(res, k = 3, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-CV-skmeans-get-signatures-no-scale-2-1.png" alt="plot of chunk tab-CV-skmeans-get-signatures-no-scale-2" /></p>

</div>
<div id='tab-CV-skmeans-get-signatures-no-scale-3'>
<pre><code class="language-r">get_signatures(res, k = 4, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-CV-skmeans-get-signatures-no-scale-3-1.png" alt="plot of chunk tab-CV-skmeans-get-signatures-no-scale-3" /></p>

</div>
<div id='tab-CV-skmeans-get-signatures-no-scale-4'>
<pre><code class="language-r">get_signatures(res, k = 5, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-CV-skmeans-get-signatures-no-scale-4-1.png" alt="plot of chunk tab-CV-skmeans-get-signatures-no-scale-4" /></p>

</div>
<div id='tab-CV-skmeans-get-signatures-no-scale-5'>
<pre><code class="language-r">get_signatures(res, k = 6, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-CV-skmeans-get-signatures-no-scale-5-1.png" alt="plot of chunk tab-CV-skmeans-get-signatures-no-scale-5" /></p>

</div>
</div>



Compare the overlap of signatures from different k:

``` r
compare_signatures(res)
```

![plot of chunk CV-skmeans-signature_compare](figure_cola/CV-skmeans-signature_compare-1.png)

`get_signature()` returns a data frame invisibly. To get the list of signatures, the function
call should be assigned to a variable explicitly. In following code, if `plot` argument is set
to `FALSE`, no heatmap is plotted while only the differential analysis is performed.

``` r
# code only for demonstration
tb = get_signature(res, k = ..., plot = FALSE)
```

An example of the output of `tb` is:

```
#>   which_row         fdr    mean_1    mean_2 scaled_mean_1 scaled_mean_2 km
#> 1        38 0.042760348  8.373488  9.131774    -0.5533452     0.5164555  1
#> 2        40 0.018707592  7.106213  8.469186    -0.6173731     0.5762149  1
#> 3        55 0.019134737 10.221463 11.207825    -0.6159697     0.5749050  1
#> 4        59 0.006059896  5.921854  7.869574    -0.6899429     0.6439467  1
#> 5        60 0.018055526  8.928898 10.211722    -0.6204761     0.5791110  1
#> 6        98 0.009384629 15.714769 14.887706     0.6635654    -0.6193277  2
...
```

The columns in `tb` are:

1. `which_row`: row indices corresponding to the input matrix.
2. `fdr`: FDR for the differential test. 
3. `mean_x`: The mean value in group x.
4. `scaled_mean_x`: The mean value in group x after rows are scaled.
5. `km`: Row groups if k-means clustering is applied to rows (which is done by automatically selecting number of clusters).

If there are too many signatures, `top_signatures = ...` can be set to only show the 
signatures with the highest FDRs:

``` r
# code only for demonstration
# e.g. to show the top 500 most significant rows
tb = get_signature(res, k = ..., top_signatures = 500)
```

If the signatures are defined as these which are uniquely high in current group, `diff_method` argument
can be set to `"uniquely_high_in_one_group"`:

``` r
# code only for demonstration
tb = get_signature(res, k = ..., diff_method = "uniquely_high_in_one_group")
```




UMAP plot which shows how samples are separated.


<script>
$( function() {
	$( '#tabs-CV-skmeans-dimension-reduction' ).tabs();
} );
</script>
<div id='tabs-CV-skmeans-dimension-reduction'>
<ul>
<li><a href='#tab-CV-skmeans-dimension-reduction-1'>k = 2</a></li>
<li><a href='#tab-CV-skmeans-dimension-reduction-2'>k = 3</a></li>
<li><a href='#tab-CV-skmeans-dimension-reduction-3'>k = 4</a></li>
<li><a href='#tab-CV-skmeans-dimension-reduction-4'>k = 5</a></li>
<li><a href='#tab-CV-skmeans-dimension-reduction-5'>k = 6</a></li>
</ul>
<div id='tab-CV-skmeans-dimension-reduction-1'>
<pre><code class="language-r">dimension_reduction(res, k = 2, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-CV-skmeans-dimension-reduction-1-1.png" alt="plot of chunk tab-CV-skmeans-dimension-reduction-1" /></p>

</div>
<div id='tab-CV-skmeans-dimension-reduction-2'>
<pre><code class="language-r">dimension_reduction(res, k = 3, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-CV-skmeans-dimension-reduction-2-1.png" alt="plot of chunk tab-CV-skmeans-dimension-reduction-2" /></p>

</div>
<div id='tab-CV-skmeans-dimension-reduction-3'>
<pre><code class="language-r">dimension_reduction(res, k = 4, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-CV-skmeans-dimension-reduction-3-1.png" alt="plot of chunk tab-CV-skmeans-dimension-reduction-3" /></p>

</div>
<div id='tab-CV-skmeans-dimension-reduction-4'>
<pre><code class="language-r">dimension_reduction(res, k = 5, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-CV-skmeans-dimension-reduction-4-1.png" alt="plot of chunk tab-CV-skmeans-dimension-reduction-4" /></p>

</div>
<div id='tab-CV-skmeans-dimension-reduction-5'>
<pre><code class="language-r">dimension_reduction(res, k = 6, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-CV-skmeans-dimension-reduction-5-1.png" alt="plot of chunk tab-CV-skmeans-dimension-reduction-5" /></p>

</div>
</div>



Following heatmap shows how subgroups are split when increasing `k`:

``` r
collect_classes(res)
```

![plot of chunk CV-skmeans-collect-classes](figure_cola/CV-skmeans-collect-classes-1.png)



If matrix rows can be associated to genes, consider to use `functional_enrichment(res,
...)` to perform function enrichment for the signature genes. See [this vignette](https://jokergoo.github.io/cola_vignettes/functional_enrichment.html) for more detailed explanations.


 

---------------------------------------------------



### CV:mclust






The object with results only for a single top-value method and a single partitioning method 
can be extracted as:

``` r
res = res_list["CV", "mclust"]
# you can also extract it by
# res = res_list["CV:mclust"]
```

A summary of `res` and all the functions that can be applied to it:

``` r
res
```

```
#> A 'ConsensusPartition' object with k = 2, 3, 4, 5, 6.
#>   On a matrix with 1900 rows and 60 columns.
#>   Top rows (7) are extracted by 'CV' method.
#>   Subgroups are detected by 'mclust' method.
#>   Performed in total 250 partitions by row resampling.
#>   Best k for subgroups seems to be 3.
#> 
#> Following methods can be applied to this 'ConsensusPartition' object:
#>  [1] "cola_report"             "collect_classes"         "collect_plots"          
#>  [4] "collect_stats"           "colnames"                "compare_partitions"     
#>  [7] "compare_signatures"      "consensus_heatmap"       "dimension_reduction"    
#> [10] "functional_enrichment"   "get_anno_col"            "get_anno"               
#> [13] "get_classes"             "get_consensus"           "get_matrix"             
#> [16] "get_membership"          "get_param"               "get_signatures"         
#> [19] "get_stats"               "is_best_k"               "is_stable_k"            
#> [22] "membership_heatmap"      "ncol"                    "nrow"                   
#> [25] "plot_ecdf"               "predict_classes"         "rownames"               
#> [28] "select_partition_number" "show"                    "suggest_best_k"         
#> [31] "test_to_known_factors"   "top_rows_heatmap"
```

`collect_plots()` function collects all the plots made from `res` for all `k` (number of subgroups)
into one single page to provide an easy and fast comparison between different `k`.

``` r
collect_plots(res)
```

![plot of chunk CV-mclust-collect-plots](figure_cola/CV-mclust-collect-plots-1.png)

The plots are:

- The first row: a plot of the eCDF (empirical cumulative distribution
  function) curves of the consensus matrix for each `k` and the heatmap of
  predicted classes for each `k`.
- The second row: heatmaps of the consensus matrix for each `k`.
- The third row: heatmaps of the membership matrix for each `k`.
- The fouth row: heatmaps of the signatures for each `k`.

All the plots in panels can be made by individual functions and they are
plotted later in this section.

`select_partition_number()` produces several plots showing different
statistics for choosing "optimized" `k`. There are following statistics:

- eCDF curves of the consensus matrix for each `k`;
- 1-PAC. [The PAC score](https://en.wikipedia.org/wiki/Consensus_clustering#Over-interpretation_potential_of_consensus_clustering)
  measures the proportion of the ambiguous subgrouping.
- Mean silhouette score.
- Concordance. The mean probability of fiting the consensus subgroup labels in all
  partitions.
- Area increased. Denote $A_k$ as the area under the eCDF curve for current
  `k`, the area increased is defined as $A_k - A_{k-1}$.
- Rand index. The percent of pairs of samples that are both in a same cluster
  or both are not in a same cluster in the partition of k and k-1.
- Jaccard index. The ratio of pairs of samples are both in a same cluster in
  the partition of k and k-1 and the pairs of samples are both in a same
  cluster in the partition k or k-1.

The detailed explanations of these statistics can be found in [the _cola_
vignette](https://jokergoo.github.io/cola_vignettes/cola.html#toc_13).

Generally speaking, higher 1-PAC score, higher mean silhouette score or higher
concordance corresponds to better partition. Rand index and Jaccard index
measure how similar the current partition is compared to partition with `k-1`.
If they are too similar, we won't accept `k` is better than `k-1`.

``` r
select_partition_number(res)
```

![plot of chunk CV-mclust-select-partition-number](figure_cola/CV-mclust-select-partition-number-1.png)

The numeric values for all these statistics can be obtained by `get_stats()`.

``` r
get_stats(res)
```

```
#>   k 1-PAC mean_silhouette concordance area_increased  Rand Jaccard
#> 2 2 0.583           0.882       0.933         0.3314 0.741   0.741
#> 3 3 0.359           0.602       0.806         0.8656 0.640   0.513
#> 4 4 0.385           0.259       0.652         0.1787 0.688   0.353
#> 5 5 0.484           0.528       0.727         0.0587 0.779   0.377
#> 6 6 0.619           0.508       0.651         0.0636 0.966   0.846
```

`suggest_best_k()` suggests the best $k$ based on these statistics. The rules are as follows:

- All $k$ with Jaccard index larger than 0.95 are removed because increasing
  $k$ does not provide enough extra information. If all $k$ are removed, it is
  marked as no subgroup is detected.
- For all $k$ with 1-PAC score larger than 0.9, the maximal $k$ is taken as
  the best $k$, and other $k$ are marked as optional $k$.
- If it does not fit the second rule. The $k$ with the maximal vote of the
  highest 1-PAC score, highest mean silhouette, and highest concordance is
  taken as the best $k$.

``` r
suggest_best_k(res)
```

```
#> [1] 3
```


Following is the table of the partitions (You need to click the **show/hide
code output** link to see it). The membership matrix (columns with name `p*`)
is inferred by
[`clue::cl_consensus()`](https://www.rdocumentation.org/link/cl_consensus?package=clue)
function with the `SE` method. Basically the value in the membership matrix
represents the probability to belong to a certain group. The finall subgroup
label for an item is determined with the group with highest probability it
belongs to.

In `get_classes()` function, the entropy is calculated from the membership
matrix and the silhouette score is calculated from the consensus matrix.



<script>
$( function() {
	$( '#tabs-CV-mclust-get-classes' ).tabs();
} );
</script>
<div id='tabs-CV-mclust-get-classes'>
<ul>
<li><a href='#tab-CV-mclust-get-classes-1'>k = 2</a></li>
<li><a href='#tab-CV-mclust-get-classes-2'>k = 3</a></li>
<li><a href='#tab-CV-mclust-get-classes-3'>k = 4</a></li>
<li><a href='#tab-CV-mclust-get-classes-4'>k = 5</a></li>
<li><a href='#tab-CV-mclust-get-classes-5'>k = 6</a></li>
</ul>

<div id='tab-CV-mclust-get-classes-1'>
<p><a id='tab-CV-mclust-get-classes-1-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 2), get_membership(res, k = 2))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2
#&gt; SIH013     2   0.402      0.868 0.08 0.92
#&gt; SIH014     2   0.904      0.639 0.32 0.68
#&gt; SIH024     2   0.881      0.675 0.30 0.70
#&gt; SIH028     2   0.584      0.845 0.14 0.86
#&gt; SIH031     2   0.584      0.845 0.14 0.86
#&gt; SIH042     1   0.000      1.000 1.00 0.00
#&gt; SIH107     1   0.000      1.000 1.00 0.00
#&gt; SIH114     2   0.000      0.917 0.00 1.00
#&gt; SIH116     2   0.000      0.917 0.00 1.00
#&gt; SIH117     2   0.000      0.917 0.00 1.00
#&gt; SIH130     2   0.000      0.917 0.00 1.00
#&gt; SIH134     2   0.000      0.917 0.00 1.00
#&gt; SIH186     2   0.881      0.675 0.30 0.70
#&gt; SIH191     2   0.000      0.917 0.00 1.00
#&gt; SIH192     2   0.000      0.917 0.00 1.00
#&gt; SIH196     2   0.000      0.917 0.00 1.00
#&gt; SIH214     2   0.584      0.845 0.14 0.86
#&gt; SIH218     1   0.000      1.000 1.00 0.00
#&gt; SIH232     2   0.000      0.917 0.00 1.00
#&gt; SIH236     2   0.000      0.917 0.00 1.00
#&gt; SIH238     1   0.000      1.000 1.00 0.00
#&gt; SIH241     2   0.795      0.759 0.24 0.76
#&gt; SIH245     2   0.000      0.917 0.00 1.00
#&gt; SIH260     2   0.000      0.917 0.00 1.00
#&gt; SIH287     2   0.584      0.845 0.14 0.86
#&gt; SIH289     1   0.000      1.000 1.00 0.00
#&gt; SIH290     2   0.904      0.639 0.32 0.68
#&gt; SIH295     2   0.000      0.917 0.00 1.00
#&gt; SIH366     2   0.000      0.917 0.00 1.00
#&gt; SIH377     2   0.000      0.917 0.00 1.00
#&gt; SIH380     2   0.584      0.845 0.14 0.86
#&gt; SIH385     2   0.584      0.845 0.14 0.86
#&gt; SIH389     2   0.000      0.917 0.00 1.00
#&gt; SIH391     2   0.402      0.868 0.08 0.92
#&gt; SIH403     2   0.000      0.917 0.00 1.00
#&gt; SIH411     2   0.000      0.917 0.00 1.00
#&gt; SIH427     2   0.000      0.917 0.00 1.00
#&gt; SIH433     1   0.000      1.000 1.00 0.00
#&gt; SIH439     2   0.000      0.917 0.00 1.00
#&gt; SIH442     2   0.000      0.917 0.00 1.00
#&gt; SIH444     2   0.402      0.868 0.08 0.92
#&gt; SIH452     2   0.000      0.917 0.00 1.00
#&gt; SIH461     1   0.000      1.000 1.00 0.00
#&gt; SIH471     2   0.584      0.809 0.14 0.86
#&gt; SIH472     2   0.795      0.759 0.24 0.76
#&gt; SIH481     2   0.000      0.917 0.00 1.00
#&gt; SIH485     2   0.584      0.845 0.14 0.86
#&gt; SIH491     2   0.904      0.639 0.32 0.68
#&gt; SIH508     2   0.881      0.675 0.30 0.70
#&gt; SIH559     2   0.000      0.917 0.00 1.00
#&gt; SIH587     2   0.000      0.917 0.00 1.00
#&gt; SIH625     2   0.000      0.917 0.00 1.00
#&gt; SIH641     2   0.000      0.917 0.00 1.00
#&gt; SIH643     2   0.881      0.675 0.30 0.70
#&gt; SIH674     2   0.000      0.917 0.00 1.00
#&gt; SIH678     2   0.000      0.917 0.00 1.00
#&gt; SIH679     2   0.000      0.917 0.00 1.00
#&gt; SIH689     2   0.000      0.917 0.00 1.00
#&gt; SIH694     1   0.000      1.000 1.00 0.00
#&gt; SIH721     1   0.000      1.000 1.00 0.00
</code></pre>

<script>
$('#tab-CV-mclust-get-classes-1-a').parent().next().next().hide();
$('#tab-CV-mclust-get-classes-1-a').click(function(){
  $('#tab-CV-mclust-get-classes-1-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-CV-mclust-get-classes-2'>
<p><a id='tab-CV-mclust-get-classes-2-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 3), get_membership(res, k = 3))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3
#&gt; SIH013     2   0.254     0.5928 0.00 0.92 0.08
#&gt; SIH014     2   0.571     0.5042 0.00 0.68 0.32
#&gt; SIH024     2   0.976     0.4637 0.26 0.44 0.30
#&gt; SIH028     2   0.894     0.3486 0.34 0.52 0.14
#&gt; SIH031     1   0.611     0.5835 0.78 0.08 0.14
#&gt; SIH042     3   0.000     1.0000 0.00 0.00 1.00
#&gt; SIH107     3   0.000     1.0000 0.00 0.00 1.00
#&gt; SIH114     1   0.455     0.6031 0.80 0.20 0.00
#&gt; SIH116     2   0.480     0.5586 0.22 0.78 0.00
#&gt; SIH117     2   0.480     0.5586 0.22 0.78 0.00
#&gt; SIH130     2   0.369     0.5603 0.14 0.86 0.00
#&gt; SIH134     2   0.000     0.6161 0.00 1.00 0.00
#&gt; SIH186     2   0.976     0.4637 0.26 0.44 0.30
#&gt; SIH191     1   0.455     0.6031 0.80 0.20 0.00
#&gt; SIH192     1   0.455     0.6031 0.80 0.20 0.00
#&gt; SIH196     1   0.502     0.5567 0.76 0.24 0.00
#&gt; SIH214     2   0.894     0.3486 0.34 0.52 0.14
#&gt; SIH218     3   0.000     1.0000 0.00 0.00 1.00
#&gt; SIH232     1   0.000     0.7542 1.00 0.00 0.00
#&gt; SIH236     1   0.000     0.7542 1.00 0.00 0.00
#&gt; SIH238     3   0.000     1.0000 0.00 0.00 1.00
#&gt; SIH241     1   0.977    -0.1947 0.42 0.34 0.24
#&gt; SIH245     1   0.540     0.5392 0.72 0.28 0.00
#&gt; SIH260     2   0.540     0.4442 0.28 0.72 0.00
#&gt; SIH287     2   0.770     0.5570 0.18 0.68 0.14
#&gt; SIH289     3   0.000     1.0000 0.00 0.00 1.00
#&gt; SIH290     2   0.571     0.5042 0.00 0.68 0.32
#&gt; SIH295     1   0.000     0.7542 1.00 0.00 0.00
#&gt; SIH366     1   0.000     0.7542 1.00 0.00 0.00
#&gt; SIH377     1   0.000     0.7542 1.00 0.00 0.00
#&gt; SIH380     2   0.885     0.3848 0.32 0.54 0.14
#&gt; SIH385     1   0.745     0.4665 0.70 0.16 0.14
#&gt; SIH389     2   0.583     0.2655 0.34 0.66 0.00
#&gt; SIH391     2   0.254     0.5928 0.00 0.92 0.08
#&gt; SIH403     1   0.455     0.6031 0.80 0.20 0.00
#&gt; SIH411     2   0.369     0.5603 0.14 0.86 0.00
#&gt; SIH427     1   0.000     0.7542 1.00 0.00 0.00
#&gt; SIH433     3   0.000     1.0000 0.00 0.00 1.00
#&gt; SIH439     1   0.455     0.6031 0.80 0.20 0.00
#&gt; SIH442     1   0.000     0.7542 1.00 0.00 0.00
#&gt; SIH444     2   0.254     0.5928 0.00 0.92 0.08
#&gt; SIH452     2   0.480     0.5340 0.22 0.78 0.00
#&gt; SIH461     3   0.000     1.0000 0.00 0.00 1.00
#&gt; SIH471     1   0.745     0.4783 0.70 0.16 0.14
#&gt; SIH472     1   0.977    -0.1947 0.42 0.34 0.24
#&gt; SIH481     1   0.000     0.7542 1.00 0.00 0.00
#&gt; SIH485     1   0.906    -0.0567 0.48 0.38 0.14
#&gt; SIH491     2   0.571     0.5042 0.00 0.68 0.32
#&gt; SIH508     2   0.976     0.4637 0.26 0.44 0.30
#&gt; SIH559     1   0.000     0.7542 1.00 0.00 0.00
#&gt; SIH587     1   0.000     0.7542 1.00 0.00 0.00
#&gt; SIH625     1   0.502     0.5567 0.76 0.24 0.00
#&gt; SIH641     1   0.254     0.7090 0.92 0.08 0.00
#&gt; SIH643     2   0.976     0.4637 0.26 0.44 0.30
#&gt; SIH674     1   0.000     0.7542 1.00 0.00 0.00
#&gt; SIH678     1   0.000     0.7542 1.00 0.00 0.00
#&gt; SIH679     1   0.254     0.7090 0.92 0.08 0.00
#&gt; SIH689     1   0.630     0.0139 0.52 0.48 0.00
#&gt; SIH694     3   0.000     1.0000 0.00 0.00 1.00
#&gt; SIH721     3   0.000     1.0000 0.00 0.00 1.00
</code></pre>

<script>
$('#tab-CV-mclust-get-classes-2-a').parent().next().next().hide();
$('#tab-CV-mclust-get-classes-2-a').click(function(){
  $('#tab-CV-mclust-get-classes-2-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-CV-mclust-get-classes-3'>
<p><a id='tab-CV-mclust-get-classes-3-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 4), get_membership(res, k = 4))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3   p4
#&gt; SIH013     3   0.713     -0.517 0.00 0.24 0.56 0.20
#&gt; SIH014     2   0.743      0.562 0.00 0.50 0.30 0.20
#&gt; SIH024     4   0.498      0.574 0.00 0.46 0.00 0.54
#&gt; SIH028     4   0.610      0.146 0.00 0.18 0.14 0.68
#&gt; SIH031     1   0.728      0.209 0.52 0.18 0.00 0.30
#&gt; SIH042     3   0.499      0.462 0.00 0.48 0.52 0.00
#&gt; SIH107     3   0.499      0.462 0.00 0.48 0.52 0.00
#&gt; SIH114     4   0.693      0.548 0.14 0.30 0.00 0.56
#&gt; SIH116     3   0.893     -0.469 0.22 0.10 0.48 0.20
#&gt; SIH117     3   0.879     -0.524 0.08 0.24 0.48 0.20
#&gt; SIH130     2   0.978      0.586 0.30 0.32 0.18 0.20
#&gt; SIH134     3   0.958     -0.611 0.14 0.32 0.34 0.20
#&gt; SIH186     4   0.498      0.574 0.00 0.46 0.00 0.54
#&gt; SIH191     4   0.693      0.548 0.14 0.30 0.00 0.56
#&gt; SIH192     4   0.693      0.548 0.14 0.30 0.00 0.56
#&gt; SIH196     1   0.471      0.379 0.64 0.00 0.00 0.36
#&gt; SIH214     4   0.610      0.146 0.00 0.18 0.14 0.68
#&gt; SIH218     3   0.499      0.462 0.00 0.48 0.52 0.00
#&gt; SIH232     1   0.292      0.539 0.86 0.00 0.00 0.14
#&gt; SIH236     4   0.499     -0.123 0.48 0.00 0.00 0.52
#&gt; SIH238     3   0.499      0.462 0.00 0.48 0.52 0.00
#&gt; SIH241     4   0.234      0.498 0.00 0.00 0.10 0.90
#&gt; SIH245     1   0.958     -0.497 0.34 0.32 0.14 0.20
#&gt; SIH260     1   0.938     -0.326 0.44 0.18 0.18 0.20
#&gt; SIH287     4   0.728     -0.207 0.00 0.18 0.30 0.52
#&gt; SIH289     3   0.499      0.462 0.00 0.48 0.52 0.00
#&gt; SIH290     2   0.743      0.562 0.00 0.50 0.30 0.20
#&gt; SIH295     1   0.000      0.620 1.00 0.00 0.00 0.00
#&gt; SIH366     1   0.292      0.515 0.86 0.14 0.00 0.00
#&gt; SIH377     1   0.380      0.492 0.78 0.00 0.00 0.22
#&gt; SIH380     1   0.958     -0.497 0.34 0.32 0.14 0.20
#&gt; SIH385     1   0.441      0.431 0.70 0.00 0.30 0.00
#&gt; SIH389     2   0.978      0.586 0.30 0.32 0.18 0.20
#&gt; SIH391     3   0.713     -0.517 0.00 0.24 0.56 0.20
#&gt; SIH403     4   0.693      0.548 0.14 0.30 0.00 0.56
#&gt; SIH411     2   0.978      0.586 0.30 0.32 0.18 0.20
#&gt; SIH427     1   0.471      0.379 0.64 0.00 0.00 0.36
#&gt; SIH433     3   0.499      0.462 0.00 0.48 0.52 0.00
#&gt; SIH439     1   0.866     -0.203 0.52 0.10 0.18 0.20
#&gt; SIH442     1   0.000      0.620 1.00 0.00 0.00 0.00
#&gt; SIH444     3   0.713     -0.517 0.00 0.24 0.56 0.20
#&gt; SIH452     3   0.989     -0.600 0.24 0.24 0.32 0.20
#&gt; SIH461     3   0.499      0.462 0.00 0.48 0.52 0.00
#&gt; SIH471     1   0.590      0.435 0.70 0.14 0.16 0.00
#&gt; SIH472     4   0.234      0.498 0.00 0.00 0.10 0.90
#&gt; SIH481     1   0.340      0.566 0.82 0.00 0.00 0.18
#&gt; SIH485     4   0.610      0.146 0.00 0.18 0.14 0.68
#&gt; SIH491     2   0.743      0.562 0.00 0.50 0.30 0.20
#&gt; SIH508     4   0.498      0.574 0.00 0.46 0.00 0.54
#&gt; SIH559     1   0.000      0.620 1.00 0.00 0.00 0.00
#&gt; SIH587     1   0.471      0.379 0.64 0.00 0.00 0.36
#&gt; SIH625     1   0.609      0.418 0.64 0.08 0.00 0.28
#&gt; SIH641     1   0.610      0.399 0.68 0.18 0.14 0.00
#&gt; SIH643     4   0.498      0.574 0.00 0.46 0.00 0.54
#&gt; SIH674     1   0.000      0.620 1.00 0.00 0.00 0.00
#&gt; SIH678     1   0.000      0.620 1.00 0.00 0.00 0.00
#&gt; SIH679     4   0.499     -0.123 0.48 0.00 0.00 0.52
#&gt; SIH689     3   0.893     -0.469 0.22 0.10 0.48 0.20
#&gt; SIH694     3   0.499      0.462 0.00 0.48 0.52 0.00
#&gt; SIH721     3   0.499      0.462 0.00 0.48 0.52 0.00
</code></pre>

<script>
$('#tab-CV-mclust-get-classes-3-a').parent().next().next().hide();
$('#tab-CV-mclust-get-classes-3-a').click(function(){
  $('#tab-CV-mclust-get-classes-3-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-CV-mclust-get-classes-4'>
<p><a id='tab-CV-mclust-get-classes-4-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 5), get_membership(res, k = 5))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3   p4   p5
#&gt; SIH013     2   0.413    0.60738 0.00 0.62 0.38 0.00 0.00
#&gt; SIH014     2   0.430    0.54923 0.00 0.52 0.48 0.00 0.00
#&gt; SIH024     1   0.508    0.40095 0.70 0.14 0.00 0.16 0.00
#&gt; SIH028     1   0.618   -0.14449 0.48 0.38 0.14 0.00 0.00
#&gt; SIH031     5   0.679    0.12921 0.30 0.32 0.00 0.00 0.38
#&gt; SIH042     3   0.380    1.00000 0.00 0.00 0.70 0.30 0.00
#&gt; SIH107     3   0.380    1.00000 0.00 0.00 0.70 0.30 0.00
#&gt; SIH114     1   0.418   -0.00358 0.60 0.00 0.00 0.40 0.00
#&gt; SIH116     2   0.650    0.55452 0.00 0.48 0.30 0.00 0.22
#&gt; SIH117     2   0.534    0.60580 0.00 0.62 0.30 0.00 0.08
#&gt; SIH130     2   0.000    0.59479 0.00 1.00 0.00 0.00 0.00
#&gt; SIH134     2   0.000    0.59479 0.00 1.00 0.00 0.00 0.00
#&gt; SIH186     1   0.508    0.40095 0.70 0.14 0.00 0.16 0.00
#&gt; SIH191     1   0.418   -0.00358 0.60 0.00 0.00 0.40 0.00
#&gt; SIH192     1   0.418   -0.00358 0.60 0.00 0.00 0.40 0.00
#&gt; SIH196     4   0.413    0.61777 0.00 0.38 0.00 0.62 0.00
#&gt; SIH214     1   0.618   -0.14449 0.48 0.38 0.14 0.00 0.00
#&gt; SIH218     3   0.380    1.00000 0.00 0.00 0.70 0.30 0.00
#&gt; SIH232     5   0.252    0.70428 0.00 0.14 0.00 0.00 0.86
#&gt; SIH236     4   0.508    0.58417 0.16 0.14 0.00 0.70 0.00
#&gt; SIH238     3   0.380    1.00000 0.00 0.00 0.70 0.30 0.00
#&gt; SIH241     1   0.573    0.25662 0.56 0.34 0.10 0.00 0.00
#&gt; SIH245     2   0.293    0.44851 0.00 0.82 0.00 0.00 0.18
#&gt; SIH260     2   0.252    0.50949 0.00 0.86 0.00 0.00 0.14
#&gt; SIH287     2   0.679    0.30849 0.32 0.38 0.30 0.00 0.00
#&gt; SIH289     3   0.380    1.00000 0.00 0.00 0.70 0.30 0.00
#&gt; SIH290     2   0.430    0.54923 0.00 0.52 0.48 0.00 0.00
#&gt; SIH295     5   0.000    0.65584 0.00 0.00 0.00 0.00 1.00
#&gt; SIH366     5   0.252    0.57465 0.00 0.14 0.00 0.00 0.86
#&gt; SIH377     5   0.417    0.68814 0.00 0.14 0.00 0.08 0.78
#&gt; SIH380     2   0.293    0.44851 0.00 0.82 0.00 0.00 0.18
#&gt; SIH385     5   0.489    0.63373 0.00 0.14 0.14 0.00 0.72
#&gt; SIH389     2   0.000    0.59479 0.00 1.00 0.00 0.00 0.00
#&gt; SIH391     2   0.413    0.60738 0.00 0.62 0.38 0.00 0.00
#&gt; SIH403     1   0.418   -0.00358 0.60 0.00 0.00 0.40 0.00
#&gt; SIH411     2   0.000    0.59479 0.00 1.00 0.00 0.00 0.00
#&gt; SIH427     4   0.615    0.26767 0.00 0.14 0.00 0.50 0.36
#&gt; SIH433     3   0.380    1.00000 0.00 0.00 0.70 0.30 0.00
#&gt; SIH439     2   0.327    0.48018 0.00 0.78 0.00 0.00 0.22
#&gt; SIH442     5   0.417    0.68814 0.00 0.14 0.00 0.08 0.78
#&gt; SIH444     2   0.413    0.60738 0.00 0.62 0.38 0.00 0.00
#&gt; SIH452     2   0.437    0.61082 0.00 0.76 0.16 0.00 0.08
#&gt; SIH461     3   0.380    1.00000 0.00 0.00 0.70 0.30 0.00
#&gt; SIH471     5   0.252    0.62960 0.00 0.00 0.00 0.14 0.86
#&gt; SIH472     1   0.573    0.25662 0.56 0.34 0.10 0.00 0.00
#&gt; SIH481     5   0.604    0.26735 0.00 0.14 0.00 0.32 0.54
#&gt; SIH485     2   0.430   -0.02659 0.48 0.52 0.00 0.00 0.00
#&gt; SIH491     2   0.430    0.54923 0.00 0.52 0.48 0.00 0.00
#&gt; SIH508     1   0.508    0.40095 0.70 0.14 0.00 0.16 0.00
#&gt; SIH559     5   0.417    0.68814 0.00 0.14 0.00 0.08 0.78
#&gt; SIH587     4   0.640    0.54269 0.00 0.30 0.00 0.50 0.20
#&gt; SIH625     4   0.413    0.61777 0.00 0.38 0.00 0.62 0.00
#&gt; SIH641     5   0.430    0.31048 0.00 0.48 0.00 0.00 0.52
#&gt; SIH643     1   0.508    0.40095 0.70 0.14 0.00 0.16 0.00
#&gt; SIH674     5   0.000    0.65584 0.00 0.00 0.00 0.00 1.00
#&gt; SIH678     5   0.252    0.70428 0.00 0.14 0.00 0.00 0.86
#&gt; SIH679     4   0.508    0.58417 0.16 0.14 0.00 0.70 0.00
#&gt; SIH689     2   0.650    0.55452 0.00 0.48 0.30 0.00 0.22
#&gt; SIH694     3   0.380    1.00000 0.00 0.00 0.70 0.30 0.00
#&gt; SIH721     3   0.380    1.00000 0.00 0.00 0.70 0.30 0.00
</code></pre>

<script>
$('#tab-CV-mclust-get-classes-4-a').parent().next().next().hide();
$('#tab-CV-mclust-get-classes-4-a').click(function(){
  $('#tab-CV-mclust-get-classes-4-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-CV-mclust-get-classes-5'>
<p><a id='tab-CV-mclust-get-classes-5-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 6), get_membership(res, k = 6))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3   p4   p5   p6
#&gt; SIH013     2   0.424     0.1640 0.20 0.72 0.00 0.00 0.00 0.08
#&gt; SIH014     2   0.557    -0.0735 0.28 0.54 0.00 0.00 0.00 0.18
#&gt; SIH024     3   0.557     0.6301 0.32 0.00 0.52 0.00 0.00 0.16
#&gt; SIH028     1   0.308     0.8006 0.76 0.24 0.00 0.00 0.00 0.00
#&gt; SIH031     5   0.558    -0.1580 0.40 0.14 0.00 0.00 0.46 0.00
#&gt; SIH042     6   0.000     1.0000 0.00 0.00 0.00 0.00 0.00 1.00
#&gt; SIH107     6   0.000     1.0000 0.00 0.00 0.00 0.00 0.00 1.00
#&gt; SIH114     3   0.156     0.6010 0.00 0.00 0.92 0.08 0.00 0.00
#&gt; SIH116     2   0.226     0.3604 0.00 0.86 0.00 0.00 0.14 0.00
#&gt; SIH117     2   0.279     0.1884 0.20 0.80 0.00 0.00 0.00 0.00
#&gt; SIH130     2   0.657     0.2868 0.24 0.52 0.00 0.16 0.08 0.00
#&gt; SIH134     2   0.557     0.3170 0.32 0.52 0.00 0.16 0.00 0.00
#&gt; SIH186     3   0.557     0.6301 0.32 0.00 0.52 0.00 0.00 0.16
#&gt; SIH191     3   0.156     0.6010 0.00 0.00 0.92 0.08 0.00 0.00
#&gt; SIH192     3   0.156     0.6010 0.00 0.00 0.92 0.08 0.00 0.00
#&gt; SIH196     4   0.156     0.7131 0.08 0.00 0.00 0.92 0.00 0.00
#&gt; SIH214     1   0.308     0.8006 0.76 0.24 0.00 0.00 0.00 0.00
#&gt; SIH218     6   0.000     1.0000 0.00 0.00 0.00 0.00 0.00 1.00
#&gt; SIH232     5   0.720     0.4728 0.00 0.28 0.14 0.16 0.42 0.00
#&gt; SIH236     4   0.245     0.7208 0.16 0.00 0.00 0.84 0.00 0.00
#&gt; SIH238     6   0.000     1.0000 0.00 0.00 0.00 0.00 0.00 1.00
#&gt; SIH241     3   0.508     0.6037 0.32 0.00 0.58 0.00 0.00 0.10
#&gt; SIH245     2   0.535     0.1367 0.00 0.58 0.00 0.16 0.26 0.00
#&gt; SIH260     2   0.708     0.0305 0.24 0.46 0.00 0.16 0.14 0.00
#&gt; SIH287     1   0.376     0.6245 0.60 0.40 0.00 0.00 0.00 0.00
#&gt; SIH289     6   0.000     1.0000 0.00 0.00 0.00 0.00 0.00 1.00
#&gt; SIH290     2   0.557    -0.0735 0.28 0.54 0.00 0.00 0.00 0.18
#&gt; SIH295     5   0.544     0.5389 0.00 0.28 0.00 0.16 0.56 0.00
#&gt; SIH366     5   0.380     0.4658 0.00 0.42 0.00 0.00 0.58 0.00
#&gt; SIH377     5   0.375     0.3853 0.00 0.00 0.14 0.08 0.78 0.00
#&gt; SIH380     2   0.684     0.0356 0.10 0.48 0.00 0.16 0.26 0.00
#&gt; SIH385     5   0.529     0.5323 0.00 0.28 0.00 0.00 0.58 0.14
#&gt; SIH389     2   0.557     0.3170 0.32 0.52 0.00 0.16 0.00 0.00
#&gt; SIH391     2   0.424     0.1640 0.20 0.72 0.00 0.00 0.00 0.08
#&gt; SIH403     3   0.156     0.6010 0.00 0.00 0.92 0.08 0.00 0.00
#&gt; SIH411     2   0.657     0.2868 0.24 0.52 0.00 0.16 0.08 0.00
#&gt; SIH427     4   0.519     0.4895 0.00 0.10 0.00 0.54 0.36 0.00
#&gt; SIH433     6   0.000     1.0000 0.00 0.00 0.00 0.00 0.00 1.00
#&gt; SIH439     2   0.457     0.2325 0.00 0.70 0.00 0.16 0.14 0.00
#&gt; SIH442     5   0.156     0.4624 0.00 0.00 0.00 0.08 0.92 0.00
#&gt; SIH444     2   0.424     0.1640 0.20 0.72 0.00 0.00 0.00 0.08
#&gt; SIH452     2   0.000     0.3922 0.00 1.00 0.00 0.00 0.00 0.00
#&gt; SIH461     6   0.000     1.0000 0.00 0.00 0.00 0.00 0.00 1.00
#&gt; SIH471     5   0.529     0.5390 0.00 0.28 0.00 0.00 0.58 0.14
#&gt; SIH472     3   0.508     0.6037 0.32 0.00 0.58 0.00 0.00 0.10
#&gt; SIH481     5   0.263     0.3563 0.00 0.00 0.00 0.18 0.82 0.00
#&gt; SIH485     1   0.552     0.5995 0.56 0.24 0.00 0.00 0.20 0.00
#&gt; SIH491     2   0.557    -0.0735 0.28 0.54 0.00 0.00 0.00 0.18
#&gt; SIH508     3   0.557     0.6301 0.32 0.00 0.52 0.00 0.00 0.16
#&gt; SIH559     5   0.156     0.4624 0.00 0.00 0.00 0.08 0.92 0.00
#&gt; SIH587     4   0.279     0.6393 0.00 0.00 0.00 0.80 0.20 0.00
#&gt; SIH625     4   0.156     0.7131 0.08 0.00 0.00 0.92 0.00 0.00
#&gt; SIH641     5   0.701     0.1839 0.10 0.34 0.00 0.16 0.40 0.00
#&gt; SIH643     3   0.557     0.6301 0.32 0.00 0.52 0.00 0.00 0.16
#&gt; SIH674     5   0.544     0.5389 0.00 0.28 0.00 0.16 0.56 0.00
#&gt; SIH678     5   0.544     0.5389 0.00 0.28 0.00 0.16 0.56 0.00
#&gt; SIH679     4   0.245     0.7208 0.16 0.00 0.00 0.84 0.00 0.00
#&gt; SIH689     2   0.226     0.3604 0.00 0.86 0.00 0.00 0.14 0.00
#&gt; SIH694     6   0.000     1.0000 0.00 0.00 0.00 0.00 0.00 1.00
#&gt; SIH721     6   0.000     1.0000 0.00 0.00 0.00 0.00 0.00 1.00
</code></pre>

<script>
$('#tab-CV-mclust-get-classes-5-a').parent().next().next().hide();
$('#tab-CV-mclust-get-classes-5-a').click(function(){
  $('#tab-CV-mclust-get-classes-5-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>
</div>

Heatmaps for the consensus matrix. It visualizes the probability of two
samples to be in a same group.




<script>
$( function() {
	$( '#tabs-CV-mclust-consensus-heatmap' ).tabs();
} );
</script>
<div id='tabs-CV-mclust-consensus-heatmap'>
<ul>
<li><a href='#tab-CV-mclust-consensus-heatmap-1'>k = 2</a></li>
<li><a href='#tab-CV-mclust-consensus-heatmap-2'>k = 3</a></li>
<li><a href='#tab-CV-mclust-consensus-heatmap-3'>k = 4</a></li>
<li><a href='#tab-CV-mclust-consensus-heatmap-4'>k = 5</a></li>
<li><a href='#tab-CV-mclust-consensus-heatmap-5'>k = 6</a></li>
</ul>
<div id='tab-CV-mclust-consensus-heatmap-1'>
<pre><code class="language-r">consensus_heatmap(res, k = 2)
</code></pre>
<p><img src="figure_cola/tab-CV-mclust-consensus-heatmap-1-1.png" alt="plot of chunk tab-CV-mclust-consensus-heatmap-1" /></p>

</div>
<div id='tab-CV-mclust-consensus-heatmap-2'>
<pre><code class="language-r">consensus_heatmap(res, k = 3)
</code></pre>
<p><img src="figure_cola/tab-CV-mclust-consensus-heatmap-2-1.png" alt="plot of chunk tab-CV-mclust-consensus-heatmap-2" /></p>

</div>
<div id='tab-CV-mclust-consensus-heatmap-3'>
<pre><code class="language-r">consensus_heatmap(res, k = 4)
</code></pre>
<p><img src="figure_cola/tab-CV-mclust-consensus-heatmap-3-1.png" alt="plot of chunk tab-CV-mclust-consensus-heatmap-3" /></p>

</div>
<div id='tab-CV-mclust-consensus-heatmap-4'>
<pre><code class="language-r">consensus_heatmap(res, k = 5)
</code></pre>
<p><img src="figure_cola/tab-CV-mclust-consensus-heatmap-4-1.png" alt="plot of chunk tab-CV-mclust-consensus-heatmap-4" /></p>

</div>
<div id='tab-CV-mclust-consensus-heatmap-5'>
<pre><code class="language-r">consensus_heatmap(res, k = 6)
</code></pre>
<p><img src="figure_cola/tab-CV-mclust-consensus-heatmap-5-1.png" alt="plot of chunk tab-CV-mclust-consensus-heatmap-5" /></p>

</div>
</div>

Heatmaps for the membership of samples in all partitions to see how consistent they are:





<script>
$( function() {
	$( '#tabs-CV-mclust-membership-heatmap' ).tabs();
} );
</script>
<div id='tabs-CV-mclust-membership-heatmap'>
<ul>
<li><a href='#tab-CV-mclust-membership-heatmap-1'>k = 2</a></li>
<li><a href='#tab-CV-mclust-membership-heatmap-2'>k = 3</a></li>
<li><a href='#tab-CV-mclust-membership-heatmap-3'>k = 4</a></li>
<li><a href='#tab-CV-mclust-membership-heatmap-4'>k = 5</a></li>
<li><a href='#tab-CV-mclust-membership-heatmap-5'>k = 6</a></li>
</ul>
<div id='tab-CV-mclust-membership-heatmap-1'>
<pre><code class="language-r">membership_heatmap(res, k = 2)
</code></pre>
<p><img src="figure_cola/tab-CV-mclust-membership-heatmap-1-1.png" alt="plot of chunk tab-CV-mclust-membership-heatmap-1" /></p>

</div>
<div id='tab-CV-mclust-membership-heatmap-2'>
<pre><code class="language-r">membership_heatmap(res, k = 3)
</code></pre>
<p><img src="figure_cola/tab-CV-mclust-membership-heatmap-2-1.png" alt="plot of chunk tab-CV-mclust-membership-heatmap-2" /></p>

</div>
<div id='tab-CV-mclust-membership-heatmap-3'>
<pre><code class="language-r">membership_heatmap(res, k = 4)
</code></pre>
<p><img src="figure_cola/tab-CV-mclust-membership-heatmap-3-1.png" alt="plot of chunk tab-CV-mclust-membership-heatmap-3" /></p>

</div>
<div id='tab-CV-mclust-membership-heatmap-4'>
<pre><code class="language-r">membership_heatmap(res, k = 5)
</code></pre>
<p><img src="figure_cola/tab-CV-mclust-membership-heatmap-4-1.png" alt="plot of chunk tab-CV-mclust-membership-heatmap-4" /></p>

</div>
<div id='tab-CV-mclust-membership-heatmap-5'>
<pre><code class="language-r">membership_heatmap(res, k = 6)
</code></pre>
<p><img src="figure_cola/tab-CV-mclust-membership-heatmap-5-1.png" alt="plot of chunk tab-CV-mclust-membership-heatmap-5" /></p>

</div>
</div>

As soon as the classes for columns are determined, the signatures
that are significantly different between subgroups can be looked for. 
Following are the heatmaps for signatures.




Signature heatmaps where rows are scaled:



<script>
$( function() {
	$( '#tabs-CV-mclust-get-signatures' ).tabs();
} );
</script>
<div id='tabs-CV-mclust-get-signatures'>
<ul>
<li><a href='#tab-CV-mclust-get-signatures-1'>k = 2</a></li>
<li><a href='#tab-CV-mclust-get-signatures-2'>k = 3</a></li>
<li><a href='#tab-CV-mclust-get-signatures-3'>k = 4</a></li>
<li><a href='#tab-CV-mclust-get-signatures-4'>k = 5</a></li>
<li><a href='#tab-CV-mclust-get-signatures-5'>k = 6</a></li>
</ul>
<div id='tab-CV-mclust-get-signatures-1'>
<pre><code class="language-r">get_signatures(res, k = 2)
</code></pre>
<p><img src="figure_cola/tab-CV-mclust-get-signatures-1-1.png" alt="plot of chunk tab-CV-mclust-get-signatures-1" /></p>

</div>
<div id='tab-CV-mclust-get-signatures-2'>
<pre><code class="language-r">get_signatures(res, k = 3)
</code></pre>
<p><img src="figure_cola/tab-CV-mclust-get-signatures-2-1.png" alt="plot of chunk tab-CV-mclust-get-signatures-2" /></p>

</div>
<div id='tab-CV-mclust-get-signatures-3'>
<pre><code class="language-r">get_signatures(res, k = 4)
</code></pre>
<p><img src="figure_cola/tab-CV-mclust-get-signatures-3-1.png" alt="plot of chunk tab-CV-mclust-get-signatures-3" /></p>

</div>
<div id='tab-CV-mclust-get-signatures-4'>
<pre><code class="language-r">get_signatures(res, k = 5)
</code></pre>
<p><img src="figure_cola/tab-CV-mclust-get-signatures-4-1.png" alt="plot of chunk tab-CV-mclust-get-signatures-4" /></p>

</div>
<div id='tab-CV-mclust-get-signatures-5'>
<pre><code class="language-r">get_signatures(res, k = 6)
</code></pre>
<p><img src="figure_cola/tab-CV-mclust-get-signatures-5-1.png" alt="plot of chunk tab-CV-mclust-get-signatures-5" /></p>

</div>
</div>



Signature heatmaps where rows are not scaled:


<script>
$( function() {
	$( '#tabs-CV-mclust-get-signatures-no-scale' ).tabs();
} );
</script>
<div id='tabs-CV-mclust-get-signatures-no-scale'>
<ul>
<li><a href='#tab-CV-mclust-get-signatures-no-scale-1'>k = 2</a></li>
<li><a href='#tab-CV-mclust-get-signatures-no-scale-2'>k = 3</a></li>
<li><a href='#tab-CV-mclust-get-signatures-no-scale-3'>k = 4</a></li>
<li><a href='#tab-CV-mclust-get-signatures-no-scale-4'>k = 5</a></li>
<li><a href='#tab-CV-mclust-get-signatures-no-scale-5'>k = 6</a></li>
</ul>
<div id='tab-CV-mclust-get-signatures-no-scale-1'>
<pre><code class="language-r">get_signatures(res, k = 2, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-CV-mclust-get-signatures-no-scale-1-1.png" alt="plot of chunk tab-CV-mclust-get-signatures-no-scale-1" /></p>

</div>
<div id='tab-CV-mclust-get-signatures-no-scale-2'>
<pre><code class="language-r">get_signatures(res, k = 3, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-CV-mclust-get-signatures-no-scale-2-1.png" alt="plot of chunk tab-CV-mclust-get-signatures-no-scale-2" /></p>

</div>
<div id='tab-CV-mclust-get-signatures-no-scale-3'>
<pre><code class="language-r">get_signatures(res, k = 4, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-CV-mclust-get-signatures-no-scale-3-1.png" alt="plot of chunk tab-CV-mclust-get-signatures-no-scale-3" /></p>

</div>
<div id='tab-CV-mclust-get-signatures-no-scale-4'>
<pre><code class="language-r">get_signatures(res, k = 5, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-CV-mclust-get-signatures-no-scale-4-1.png" alt="plot of chunk tab-CV-mclust-get-signatures-no-scale-4" /></p>

</div>
<div id='tab-CV-mclust-get-signatures-no-scale-5'>
<pre><code class="language-r">get_signatures(res, k = 6, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-CV-mclust-get-signatures-no-scale-5-1.png" alt="plot of chunk tab-CV-mclust-get-signatures-no-scale-5" /></p>

</div>
</div>



Compare the overlap of signatures from different k:

``` r
compare_signatures(res)
```

![plot of chunk CV-mclust-signature_compare](figure_cola/CV-mclust-signature_compare-1.png)

`get_signature()` returns a data frame invisibly. To get the list of signatures, the function
call should be assigned to a variable explicitly. In following code, if `plot` argument is set
to `FALSE`, no heatmap is plotted while only the differential analysis is performed.

``` r
# code only for demonstration
tb = get_signature(res, k = ..., plot = FALSE)
```

An example of the output of `tb` is:

```
#>   which_row         fdr    mean_1    mean_2 scaled_mean_1 scaled_mean_2 km
#> 1        38 0.042760348  8.373488  9.131774    -0.5533452     0.5164555  1
#> 2        40 0.018707592  7.106213  8.469186    -0.6173731     0.5762149  1
#> 3        55 0.019134737 10.221463 11.207825    -0.6159697     0.5749050  1
#> 4        59 0.006059896  5.921854  7.869574    -0.6899429     0.6439467  1
#> 5        60 0.018055526  8.928898 10.211722    -0.6204761     0.5791110  1
#> 6        98 0.009384629 15.714769 14.887706     0.6635654    -0.6193277  2
...
```

The columns in `tb` are:

1. `which_row`: row indices corresponding to the input matrix.
2. `fdr`: FDR for the differential test. 
3. `mean_x`: The mean value in group x.
4. `scaled_mean_x`: The mean value in group x after rows are scaled.
5. `km`: Row groups if k-means clustering is applied to rows (which is done by automatically selecting number of clusters).

If there are too many signatures, `top_signatures = ...` can be set to only show the 
signatures with the highest FDRs:

``` r
# code only for demonstration
# e.g. to show the top 500 most significant rows
tb = get_signature(res, k = ..., top_signatures = 500)
```

If the signatures are defined as these which are uniquely high in current group, `diff_method` argument
can be set to `"uniquely_high_in_one_group"`:

``` r
# code only for demonstration
tb = get_signature(res, k = ..., diff_method = "uniquely_high_in_one_group")
```




UMAP plot which shows how samples are separated.


<script>
$( function() {
	$( '#tabs-CV-mclust-dimension-reduction' ).tabs();
} );
</script>
<div id='tabs-CV-mclust-dimension-reduction'>
<ul>
<li><a href='#tab-CV-mclust-dimension-reduction-1'>k = 2</a></li>
<li><a href='#tab-CV-mclust-dimension-reduction-2'>k = 3</a></li>
<li><a href='#tab-CV-mclust-dimension-reduction-3'>k = 4</a></li>
<li><a href='#tab-CV-mclust-dimension-reduction-4'>k = 5</a></li>
<li><a href='#tab-CV-mclust-dimension-reduction-5'>k = 6</a></li>
</ul>
<div id='tab-CV-mclust-dimension-reduction-1'>
<pre><code class="language-r">dimension_reduction(res, k = 2, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-CV-mclust-dimension-reduction-1-1.png" alt="plot of chunk tab-CV-mclust-dimension-reduction-1" /></p>

</div>
<div id='tab-CV-mclust-dimension-reduction-2'>
<pre><code class="language-r">dimension_reduction(res, k = 3, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-CV-mclust-dimension-reduction-2-1.png" alt="plot of chunk tab-CV-mclust-dimension-reduction-2" /></p>

</div>
<div id='tab-CV-mclust-dimension-reduction-3'>
<pre><code class="language-r">dimension_reduction(res, k = 4, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-CV-mclust-dimension-reduction-3-1.png" alt="plot of chunk tab-CV-mclust-dimension-reduction-3" /></p>

</div>
<div id='tab-CV-mclust-dimension-reduction-4'>
<pre><code class="language-r">dimension_reduction(res, k = 5, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-CV-mclust-dimension-reduction-4-1.png" alt="plot of chunk tab-CV-mclust-dimension-reduction-4" /></p>

</div>
<div id='tab-CV-mclust-dimension-reduction-5'>
<pre><code class="language-r">dimension_reduction(res, k = 6, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-CV-mclust-dimension-reduction-5-1.png" alt="plot of chunk tab-CV-mclust-dimension-reduction-5" /></p>

</div>
</div>



Following heatmap shows how subgroups are split when increasing `k`:

``` r
collect_classes(res)
```

![plot of chunk CV-mclust-collect-classes](figure_cola/CV-mclust-collect-classes-1.png)



If matrix rows can be associated to genes, consider to use `functional_enrichment(res,
...)` to perform function enrichment for the signature genes. See [this vignette](https://jokergoo.github.io/cola_vignettes/functional_enrichment.html) for more detailed explanations.


 

---------------------------------------------------



### ATC:hclust






The object with results only for a single top-value method and a single partitioning method 
can be extracted as:

``` r
res = res_list["ATC", "hclust"]
# you can also extract it by
# res = res_list["ATC:hclust"]
```

A summary of `res` and all the functions that can be applied to it:

``` r
res
```

```
#> A 'ConsensusPartition' object with k = 2, 3, 4, 5, 6.
#>   On a matrix with 1900 rows and 60 columns.
#>   Top rows (190) are extracted by 'ATC' method.
#>   Subgroups are detected by 'hclust' method.
#>   Performed in total 250 partitions by row resampling.
#>   Best k for subgroups seems to be 2.
#> 
#> Following methods can be applied to this 'ConsensusPartition' object:
#>  [1] "cola_report"             "collect_classes"         "collect_plots"          
#>  [4] "collect_stats"           "colnames"                "compare_partitions"     
#>  [7] "compare_signatures"      "consensus_heatmap"       "dimension_reduction"    
#> [10] "functional_enrichment"   "get_anno_col"            "get_anno"               
#> [13] "get_classes"             "get_consensus"           "get_matrix"             
#> [16] "get_membership"          "get_param"               "get_signatures"         
#> [19] "get_stats"               "is_best_k"               "is_stable_k"            
#> [22] "membership_heatmap"      "ncol"                    "nrow"                   
#> [25] "plot_ecdf"               "predict_classes"         "rownames"               
#> [28] "select_partition_number" "show"                    "suggest_best_k"         
#> [31] "test_to_known_factors"   "top_rows_heatmap"
```

`collect_plots()` function collects all the plots made from `res` for all `k` (number of subgroups)
into one single page to provide an easy and fast comparison between different `k`.

``` r
collect_plots(res)
```

![plot of chunk ATC-hclust-collect-plots](figure_cola/ATC-hclust-collect-plots-1.png)

The plots are:

- The first row: a plot of the eCDF (empirical cumulative distribution
  function) curves of the consensus matrix for each `k` and the heatmap of
  predicted classes for each `k`.
- The second row: heatmaps of the consensus matrix for each `k`.
- The third row: heatmaps of the membership matrix for each `k`.
- The fouth row: heatmaps of the signatures for each `k`.

All the plots in panels can be made by individual functions and they are
plotted later in this section.

`select_partition_number()` produces several plots showing different
statistics for choosing "optimized" `k`. There are following statistics:

- eCDF curves of the consensus matrix for each `k`;
- 1-PAC. [The PAC score](https://en.wikipedia.org/wiki/Consensus_clustering#Over-interpretation_potential_of_consensus_clustering)
  measures the proportion of the ambiguous subgrouping.
- Mean silhouette score.
- Concordance. The mean probability of fiting the consensus subgroup labels in all
  partitions.
- Area increased. Denote $A_k$ as the area under the eCDF curve for current
  `k`, the area increased is defined as $A_k - A_{k-1}$.
- Rand index. The percent of pairs of samples that are both in a same cluster
  or both are not in a same cluster in the partition of k and k-1.
- Jaccard index. The ratio of pairs of samples are both in a same cluster in
  the partition of k and k-1 and the pairs of samples are both in a same
  cluster in the partition k or k-1.

The detailed explanations of these statistics can be found in [the _cola_
vignette](https://jokergoo.github.io/cola_vignettes/cola.html#toc_13).

Generally speaking, higher 1-PAC score, higher mean silhouette score or higher
concordance corresponds to better partition. Rand index and Jaccard index
measure how similar the current partition is compared to partition with `k-1`.
If they are too similar, we won't accept `k` is better than `k-1`.

``` r
select_partition_number(res)
```

![plot of chunk ATC-hclust-select-partition-number](figure_cola/ATC-hclust-select-partition-number-1.png)

The numeric values for all these statistics can be obtained by `get_stats()`.

``` r
get_stats(res)
```

```
#>   k 1-PAC mean_silhouette concordance area_increased  Rand Jaccard
#> 2 2 0.617           0.890       0.937         0.4645 0.519   0.519
#> 3 3 0.524           0.300       0.645         0.3820 0.942   0.889
#> 4 4 0.581           0.701       0.796         0.1188 0.692   0.392
#> 5 5 0.726           0.829       0.867         0.0790 0.922   0.703
#> 6 6 0.733           0.775       0.840         0.0235 0.992   0.958
```

`suggest_best_k()` suggests the best $k$ based on these statistics. The rules are as follows:

- All $k$ with Jaccard index larger than 0.95 are removed because increasing
  $k$ does not provide enough extra information. If all $k$ are removed, it is
  marked as no subgroup is detected.
- For all $k$ with 1-PAC score larger than 0.9, the maximal $k$ is taken as
  the best $k$, and other $k$ are marked as optional $k$.
- If it does not fit the second rule. The $k$ with the maximal vote of the
  highest 1-PAC score, highest mean silhouette, and highest concordance is
  taken as the best $k$.

``` r
suggest_best_k(res)
```

```
#> [1] 2
```


Following is the table of the partitions (You need to click the **show/hide
code output** link to see it). The membership matrix (columns with name `p*`)
is inferred by
[`clue::cl_consensus()`](https://www.rdocumentation.org/link/cl_consensus?package=clue)
function with the `SE` method. Basically the value in the membership matrix
represents the probability to belong to a certain group. The finall subgroup
label for an item is determined with the group with highest probability it
belongs to.

In `get_classes()` function, the entropy is calculated from the membership
matrix and the silhouette score is calculated from the consensus matrix.



<script>
$( function() {
	$( '#tabs-ATC-hclust-get-classes' ).tabs();
} );
</script>
<div id='tabs-ATC-hclust-get-classes'>
<ul>
<li><a href='#tab-ATC-hclust-get-classes-1'>k = 2</a></li>
<li><a href='#tab-ATC-hclust-get-classes-2'>k = 3</a></li>
<li><a href='#tab-ATC-hclust-get-classes-3'>k = 4</a></li>
<li><a href='#tab-ATC-hclust-get-classes-4'>k = 5</a></li>
<li><a href='#tab-ATC-hclust-get-classes-5'>k = 6</a></li>
</ul>

<div id='tab-ATC-hclust-get-classes-1'>
<p><a id='tab-ATC-hclust-get-classes-1-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 2), get_membership(res, k = 2))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2
#&gt; SIH013     2   0.904      0.563 0.32 0.68
#&gt; SIH014     2   0.402      0.907 0.08 0.92
#&gt; SIH024     2   0.402      0.907 0.08 0.92
#&gt; SIH028     2   0.000      0.936 0.00 1.00
#&gt; SIH031     1   0.584      0.877 0.86 0.14
#&gt; SIH042     1   0.634      0.862 0.84 0.16
#&gt; SIH107     2   0.000      0.936 0.00 1.00
#&gt; SIH114     1   0.327      0.904 0.94 0.06
#&gt; SIH116     1   0.680      0.841 0.82 0.18
#&gt; SIH117     2   0.402      0.907 0.08 0.92
#&gt; SIH130     2   0.000      0.936 0.00 1.00
#&gt; SIH134     2   0.000      0.936 0.00 1.00
#&gt; SIH186     2   0.000      0.936 0.00 1.00
#&gt; SIH191     1   0.000      0.913 1.00 0.00
#&gt; SIH192     2   0.327      0.918 0.06 0.94
#&gt; SIH196     2   0.000      0.936 0.00 1.00
#&gt; SIH214     2   0.000      0.936 0.00 1.00
#&gt; SIH218     1   0.827      0.719 0.74 0.26
#&gt; SIH232     1   0.000      0.913 1.00 0.00
#&gt; SIH236     2   0.141      0.933 0.02 0.98
#&gt; SIH238     1   0.680      0.841 0.82 0.18
#&gt; SIH241     2   0.000      0.936 0.00 1.00
#&gt; SIH245     2   0.000      0.936 0.00 1.00
#&gt; SIH260     2   0.529      0.868 0.12 0.88
#&gt; SIH287     2   0.000      0.936 0.00 1.00
#&gt; SIH289     2   0.141      0.933 0.02 0.98
#&gt; SIH290     2   0.000      0.936 0.00 1.00
#&gt; SIH295     1   0.000      0.913 1.00 0.00
#&gt; SIH366     1   0.584      0.876 0.86 0.14
#&gt; SIH377     1   0.000      0.913 1.00 0.00
#&gt; SIH380     2   0.000      0.936 0.00 1.00
#&gt; SIH385     2   0.402      0.907 0.08 0.92
#&gt; SIH389     2   0.000      0.936 0.00 1.00
#&gt; SIH391     2   0.327      0.918 0.06 0.94
#&gt; SIH403     1   0.469      0.893 0.90 0.10
#&gt; SIH411     2   0.000      0.936 0.00 1.00
#&gt; SIH427     1   0.000      0.913 1.00 0.00
#&gt; SIH433     2   0.402      0.907 0.08 0.92
#&gt; SIH439     2   0.141      0.933 0.02 0.98
#&gt; SIH442     1   0.000      0.913 1.00 0.00
#&gt; SIH444     2   0.795      0.719 0.24 0.76
#&gt; SIH452     2   0.000      0.936 0.00 1.00
#&gt; SIH461     2   0.855      0.648 0.28 0.72
#&gt; SIH471     1   0.000      0.913 1.00 0.00
#&gt; SIH472     2   0.000      0.936 0.00 1.00
#&gt; SIH481     1   0.000      0.913 1.00 0.00
#&gt; SIH485     2   0.000      0.936 0.00 1.00
#&gt; SIH491     2   0.000      0.936 0.00 1.00
#&gt; SIH508     1   0.584      0.877 0.86 0.14
#&gt; SIH559     1   0.000      0.913 1.00 0.00
#&gt; SIH587     1   0.000      0.913 1.00 0.00
#&gt; SIH625     2   0.141      0.933 0.02 0.98
#&gt; SIH641     1   0.634      0.862 0.84 0.16
#&gt; SIH643     2   0.855      0.648 0.28 0.72
#&gt; SIH674     1   0.000      0.913 1.00 0.00
#&gt; SIH678     1   0.000      0.913 1.00 0.00
#&gt; SIH679     1   0.680      0.841 0.82 0.18
#&gt; SIH689     2   0.402      0.907 0.08 0.92
#&gt; SIH694     2   0.000      0.936 0.00 1.00
#&gt; SIH721     2   0.634      0.827 0.16 0.84
</code></pre>

<script>
$('#tab-ATC-hclust-get-classes-1-a').parent().next().next().hide();
$('#tab-ATC-hclust-get-classes-1-a').click(function(){
  $('#tab-ATC-hclust-get-classes-1-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-ATC-hclust-get-classes-2'>
<p><a id='tab-ATC-hclust-get-classes-2-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 3), get_membership(res, k = 3))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3
#&gt; SIH013     2   0.795     0.2555 0.06 0.52 0.42
#&gt; SIH014     2   0.540     0.3966 0.00 0.72 0.28
#&gt; SIH024     2   0.502     0.4168 0.00 0.76 0.24
#&gt; SIH028     2   0.556     0.0449 0.00 0.70 0.30
#&gt; SIH031     1   0.709     0.7535 0.64 0.04 0.32
#&gt; SIH042     1   0.776     0.7257 0.58 0.06 0.36
#&gt; SIH107     3   0.619     1.0000 0.00 0.42 0.58
#&gt; SIH114     1   0.522     0.7805 0.74 0.00 0.26
#&gt; SIH116     1   0.814     0.7095 0.56 0.08 0.36
#&gt; SIH117     2   0.502     0.4168 0.00 0.76 0.24
#&gt; SIH130     2   0.624    -0.6040 0.00 0.56 0.44
#&gt; SIH134     2   0.624    -0.6040 0.00 0.56 0.44
#&gt; SIH186     3   0.619     1.0000 0.00 0.42 0.58
#&gt; SIH191     1   0.000     0.8138 1.00 0.00 0.00
#&gt; SIH192     2   0.254     0.3268 0.00 0.92 0.08
#&gt; SIH196     2   0.624    -0.6040 0.00 0.56 0.44
#&gt; SIH214     2   0.624    -0.6040 0.00 0.56 0.44
#&gt; SIH218     1   0.922     0.6127 0.48 0.16 0.36
#&gt; SIH232     1   0.000     0.8138 1.00 0.00 0.00
#&gt; SIH236     2   0.153     0.2867 0.00 0.96 0.04
#&gt; SIH238     1   0.784     0.7119 0.56 0.06 0.38
#&gt; SIH241     2   0.624    -0.5672 0.00 0.56 0.44
#&gt; SIH245     2   0.624    -0.6040 0.00 0.56 0.44
#&gt; SIH260     2   0.680     0.3464 0.04 0.68 0.28
#&gt; SIH287     2   0.619    -0.5900 0.00 0.58 0.42
#&gt; SIH289     2   0.429     0.0971 0.00 0.82 0.18
#&gt; SIH290     2   0.624    -0.6040 0.00 0.56 0.44
#&gt; SIH295     1   0.000     0.8138 1.00 0.00 0.00
#&gt; SIH366     1   0.767     0.7370 0.60 0.06 0.34
#&gt; SIH377     1   0.000     0.8138 1.00 0.00 0.00
#&gt; SIH380     2   0.624    -0.6040 0.00 0.56 0.44
#&gt; SIH385     2   0.502     0.4168 0.00 0.76 0.24
#&gt; SIH389     2   0.624    -0.6040 0.00 0.56 0.44
#&gt; SIH391     2   0.296     0.3410 0.00 0.90 0.10
#&gt; SIH403     1   0.639     0.7676 0.68 0.02 0.30
#&gt; SIH411     2   0.624    -0.6040 0.00 0.56 0.44
#&gt; SIH427     1   0.000     0.8138 1.00 0.00 0.00
#&gt; SIH433     2   0.502     0.4168 0.00 0.76 0.24
#&gt; SIH439     2   0.153     0.2867 0.00 0.96 0.04
#&gt; SIH442     1   0.000     0.8138 1.00 0.00 0.00
#&gt; SIH444     2   0.731     0.3692 0.04 0.60 0.36
#&gt; SIH452     2   0.583    -0.2633 0.00 0.66 0.34
#&gt; SIH461     2   0.698     0.3120 0.02 0.56 0.42
#&gt; SIH471     1   0.000     0.8138 1.00 0.00 0.00
#&gt; SIH472     3   0.619     1.0000 0.00 0.42 0.58
#&gt; SIH481     1   0.000     0.8138 1.00 0.00 0.00
#&gt; SIH485     2   0.624    -0.6040 0.00 0.56 0.44
#&gt; SIH491     2   0.624    -0.6040 0.00 0.56 0.44
#&gt; SIH508     1   0.755     0.7446 0.62 0.06 0.32
#&gt; SIH559     1   0.000     0.8138 1.00 0.00 0.00
#&gt; SIH587     1   0.000     0.8138 1.00 0.00 0.00
#&gt; SIH625     2   0.429     0.0971 0.00 0.82 0.18
#&gt; SIH641     1   0.776     0.7257 0.58 0.06 0.36
#&gt; SIH643     2   0.698     0.3120 0.02 0.56 0.42
#&gt; SIH674     1   0.000     0.8138 1.00 0.00 0.00
#&gt; SIH678     1   0.000     0.8138 1.00 0.00 0.00
#&gt; SIH679     1   0.814     0.7095 0.56 0.08 0.36
#&gt; SIH689     2   0.502     0.4168 0.00 0.76 0.24
#&gt; SIH694     2   0.624    -0.6040 0.00 0.56 0.44
#&gt; SIH721     2   0.571     0.3939 0.00 0.68 0.32
</code></pre>

<script>
$('#tab-ATC-hclust-get-classes-2-a').parent().next().next().hide();
$('#tab-ATC-hclust-get-classes-2-a').click(function(){
  $('#tab-ATC-hclust-get-classes-2-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-ATC-hclust-get-classes-3'>
<p><a id='tab-ATC-hclust-get-classes-3-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 4), get_membership(res, k = 4))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3   p4
#&gt; SIH013     3   0.688    -0.2932 0.02 0.06 0.52 0.40
#&gt; SIH014     4   0.684     0.6562 0.00 0.18 0.22 0.60
#&gt; SIH024     4   0.637     0.7050 0.00 0.10 0.28 0.62
#&gt; SIH028     2   0.683     0.0951 0.00 0.48 0.10 0.42
#&gt; SIH031     3   0.413     0.6942 0.26 0.00 0.74 0.00
#&gt; SIH042     3   0.340     0.7420 0.18 0.00 0.82 0.00
#&gt; SIH107     2   0.241     0.6519 0.00 0.92 0.04 0.04
#&gt; SIH114     3   0.491     0.4619 0.42 0.00 0.58 0.00
#&gt; SIH116     3   0.317     0.7421 0.16 0.00 0.84 0.00
#&gt; SIH117     4   0.637     0.7050 0.00 0.10 0.28 0.62
#&gt; SIH130     2   0.340     0.8712 0.00 0.82 0.00 0.18
#&gt; SIH134     2   0.340     0.8712 0.00 0.82 0.00 0.18
#&gt; SIH186     2   0.241     0.6519 0.00 0.92 0.04 0.04
#&gt; SIH191     1   0.000     0.9953 1.00 0.00 0.00 0.00
#&gt; SIH192     4   0.191     0.6685 0.00 0.04 0.02 0.94
#&gt; SIH196     2   0.340     0.8712 0.00 0.82 0.00 0.18
#&gt; SIH214     2   0.340     0.8712 0.00 0.82 0.00 0.18
#&gt; SIH218     3   0.449     0.6929 0.14 0.00 0.80 0.06
#&gt; SIH232     1   0.000     0.9953 1.00 0.00 0.00 0.00
#&gt; SIH236     4   0.234     0.6428 0.00 0.06 0.02 0.92
#&gt; SIH238     3   0.317     0.7432 0.16 0.00 0.84 0.00
#&gt; SIH241     2   0.398     0.8145 0.00 0.76 0.00 0.24
#&gt; SIH245     2   0.340     0.8712 0.00 0.82 0.00 0.18
#&gt; SIH260     4   0.620     0.4523 0.00 0.08 0.30 0.62
#&gt; SIH287     2   0.361     0.8523 0.00 0.80 0.00 0.20
#&gt; SIH289     4   0.428     0.4576 0.00 0.20 0.02 0.78
#&gt; SIH290     2   0.340     0.8712 0.00 0.82 0.00 0.18
#&gt; SIH295     1   0.000     0.9953 1.00 0.00 0.00 0.00
#&gt; SIH366     3   0.398     0.7143 0.24 0.00 0.76 0.00
#&gt; SIH377     1   0.000     0.9953 1.00 0.00 0.00 0.00
#&gt; SIH380     2   0.340     0.8712 0.00 0.82 0.00 0.18
#&gt; SIH385     4   0.637     0.7050 0.00 0.10 0.28 0.62
#&gt; SIH389     2   0.340     0.8712 0.00 0.82 0.00 0.18
#&gt; SIH391     4   0.320     0.6831 0.00 0.04 0.08 0.88
#&gt; SIH403     3   0.471     0.5820 0.36 0.00 0.64 0.00
#&gt; SIH411     2   0.340     0.8712 0.00 0.82 0.00 0.18
#&gt; SIH427     1   0.121     0.9465 0.96 0.00 0.04 0.00
#&gt; SIH433     4   0.637     0.7050 0.00 0.10 0.28 0.62
#&gt; SIH439     4   0.164     0.6430 0.00 0.06 0.00 0.94
#&gt; SIH442     1   0.000     0.9953 1.00 0.00 0.00 0.00
#&gt; SIH444     4   0.634     0.4501 0.00 0.06 0.46 0.48
#&gt; SIH452     2   0.632     0.1627 0.00 0.50 0.06 0.44
#&gt; SIH461     3   0.630    -0.3689 0.00 0.06 0.52 0.42
#&gt; SIH471     1   0.000     0.9953 1.00 0.00 0.00 0.00
#&gt; SIH472     2   0.241     0.6519 0.00 0.92 0.04 0.04
#&gt; SIH481     1   0.000     0.9953 1.00 0.00 0.00 0.00
#&gt; SIH485     2   0.340     0.8712 0.00 0.82 0.00 0.18
#&gt; SIH491     2   0.361     0.8542 0.00 0.80 0.00 0.20
#&gt; SIH508     3   0.380     0.7229 0.22 0.00 0.78 0.00
#&gt; SIH559     1   0.000     0.9953 1.00 0.00 0.00 0.00
#&gt; SIH587     1   0.000     0.9953 1.00 0.00 0.00 0.00
#&gt; SIH625     4   0.340     0.4946 0.00 0.18 0.00 0.82
#&gt; SIH641     3   0.340     0.7420 0.18 0.00 0.82 0.00
#&gt; SIH643     3   0.630    -0.3689 0.00 0.06 0.52 0.42
#&gt; SIH674     1   0.000     0.9953 1.00 0.00 0.00 0.00
#&gt; SIH678     1   0.000     0.9953 1.00 0.00 0.00 0.00
#&gt; SIH679     3   0.317     0.7421 0.16 0.00 0.84 0.00
#&gt; SIH689     4   0.637     0.7050 0.00 0.10 0.28 0.62
#&gt; SIH694     2   0.340     0.8712 0.00 0.82 0.00 0.18
#&gt; SIH721     4   0.645     0.6096 0.00 0.08 0.36 0.56
</code></pre>

<script>
$('#tab-ATC-hclust-get-classes-3-a').parent().next().next().hide();
$('#tab-ATC-hclust-get-classes-3-a').click(function(){
  $('#tab-ATC-hclust-get-classes-3-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-ATC-hclust-get-classes-4'>
<p><a id='tab-ATC-hclust-get-classes-4-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 5), get_membership(res, k = 5))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3   p4   p5
#&gt; SIH013     3  0.5888      0.687 0.28 0.14 0.58 0.00 0.00
#&gt; SIH014     3  0.3983      0.759 0.00 0.34 0.66 0.00 0.00
#&gt; SIH024     3  0.3561      0.847 0.00 0.26 0.74 0.00 0.00
#&gt; SIH028     2  0.4060      0.115 0.00 0.64 0.36 0.00 0.00
#&gt; SIH031     1  0.3106      0.854 0.84 0.00 0.02 0.00 0.14
#&gt; SIH042     1  0.2438      0.867 0.90 0.00 0.06 0.00 0.04
#&gt; SIH107     2  0.4254      0.664 0.00 0.74 0.22 0.04 0.00
#&gt; SIH114     1  0.3684      0.709 0.72 0.00 0.00 0.00 0.28
#&gt; SIH116     1  0.0000      0.854 1.00 0.00 0.00 0.00 0.00
#&gt; SIH117     3  0.3561      0.847 0.00 0.26 0.74 0.00 0.00
#&gt; SIH130     2  0.0000      0.902 0.00 1.00 0.00 0.00 0.00
#&gt; SIH134     2  0.0000      0.902 0.00 1.00 0.00 0.00 0.00
#&gt; SIH186     2  0.4254      0.664 0.00 0.74 0.22 0.04 0.00
#&gt; SIH191     5  0.0609      0.972 0.02 0.00 0.00 0.00 0.98
#&gt; SIH192     4  0.3561      0.741 0.00 0.00 0.26 0.74 0.00
#&gt; SIH196     2  0.0000      0.902 0.00 1.00 0.00 0.00 0.00
#&gt; SIH214     2  0.0000      0.902 0.00 1.00 0.00 0.00 0.00
#&gt; SIH218     1  0.3513      0.748 0.80 0.00 0.18 0.00 0.02
#&gt; SIH232     5  0.0000      0.990 0.00 0.00 0.00 0.00 1.00
#&gt; SIH236     4  0.2929      0.779 0.00 0.00 0.18 0.82 0.00
#&gt; SIH238     1  0.2754      0.856 0.88 0.00 0.08 0.00 0.04
#&gt; SIH241     2  0.1732      0.823 0.00 0.92 0.08 0.00 0.00
#&gt; SIH245     2  0.0000      0.902 0.00 1.00 0.00 0.00 0.00
#&gt; SIH260     4  0.5092      0.550 0.26 0.02 0.04 0.68 0.00
#&gt; SIH287     2  0.0609      0.888 0.00 0.98 0.00 0.02 0.00
#&gt; SIH289     4  0.0609      0.757 0.00 0.00 0.02 0.98 0.00
#&gt; SIH290     2  0.0000      0.902 0.00 1.00 0.00 0.00 0.00
#&gt; SIH295     5  0.0000      0.990 0.00 0.00 0.00 0.00 1.00
#&gt; SIH366     1  0.2331      0.867 0.90 0.00 0.00 0.02 0.08
#&gt; SIH377     5  0.0000      0.990 0.00 0.00 0.00 0.00 1.00
#&gt; SIH380     2  0.0000      0.902 0.00 1.00 0.00 0.00 0.00
#&gt; SIH385     3  0.3561      0.847 0.00 0.26 0.74 0.00 0.00
#&gt; SIH389     2  0.0000      0.902 0.00 1.00 0.00 0.00 0.00
#&gt; SIH391     4  0.3684      0.713 0.00 0.00 0.28 0.72 0.00
#&gt; SIH403     1  0.3274      0.788 0.78 0.00 0.00 0.00 0.22
#&gt; SIH411     2  0.0000      0.902 0.00 1.00 0.00 0.00 0.00
#&gt; SIH427     5  0.1732      0.903 0.08 0.00 0.00 0.00 0.92
#&gt; SIH433     3  0.3561      0.847 0.00 0.26 0.74 0.00 0.00
#&gt; SIH439     4  0.3109      0.775 0.00 0.00 0.20 0.80 0.00
#&gt; SIH442     5  0.0000      0.990 0.00 0.00 0.00 0.00 1.00
#&gt; SIH444     3  0.5610      0.778 0.18 0.18 0.64 0.00 0.00
#&gt; SIH452     4  0.6338      0.349 0.04 0.32 0.08 0.56 0.00
#&gt; SIH461     3  0.5680      0.735 0.24 0.14 0.62 0.00 0.00
#&gt; SIH471     5  0.0000      0.990 0.00 0.00 0.00 0.00 1.00
#&gt; SIH472     2  0.4254      0.664 0.00 0.74 0.22 0.04 0.00
#&gt; SIH481     5  0.0000      0.990 0.00 0.00 0.00 0.00 1.00
#&gt; SIH485     2  0.0000      0.902 0.00 1.00 0.00 0.00 0.00
#&gt; SIH491     2  0.0609      0.887 0.00 0.98 0.02 0.00 0.00
#&gt; SIH508     1  0.2616      0.872 0.88 0.00 0.02 0.00 0.10
#&gt; SIH559     5  0.0000      0.990 0.00 0.00 0.00 0.00 1.00
#&gt; SIH587     5  0.0000      0.990 0.00 0.00 0.00 0.00 1.00
#&gt; SIH625     4  0.1410      0.769 0.00 0.00 0.06 0.94 0.00
#&gt; SIH641     1  0.1648      0.874 0.94 0.00 0.02 0.00 0.04
#&gt; SIH643     3  0.5680      0.735 0.24 0.14 0.62 0.00 0.00
#&gt; SIH674     5  0.0000      0.990 0.00 0.00 0.00 0.00 1.00
#&gt; SIH678     5  0.0000      0.990 0.00 0.00 0.00 0.00 1.00
#&gt; SIH679     1  0.0000      0.854 1.00 0.00 0.00 0.00 0.00
#&gt; SIH689     3  0.3561      0.847 0.00 0.26 0.74 0.00 0.00
#&gt; SIH694     2  0.0000      0.902 0.00 1.00 0.00 0.00 0.00
#&gt; SIH721     3  0.4876      0.831 0.08 0.22 0.70 0.00 0.00
</code></pre>

<script>
$('#tab-ATC-hclust-get-classes-4-a').parent().next().next().hide();
$('#tab-ATC-hclust-get-classes-4-a').click(function(){
  $('#tab-ATC-hclust-get-classes-4-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-ATC-hclust-get-classes-5'>
<p><a id='tab-ATC-hclust-get-classes-5-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 6), get_membership(res, k = 6))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3   p4   p5   p6
#&gt; SIH013     3  0.5705     0.7127 0.20 0.14 0.62 0.00 0.00 0.04
#&gt; SIH014     3  0.3578     0.7604 0.00 0.34 0.66 0.00 0.00 0.00
#&gt; SIH024     3  0.3198     0.8598 0.00 0.26 0.74 0.00 0.00 0.00
#&gt; SIH028     2  0.3647     0.0864 0.00 0.64 0.36 0.00 0.00 0.00
#&gt; SIH031     1  0.2728     0.8160 0.86 0.00 0.04 0.00 0.10 0.00
#&gt; SIH042     1  0.2512     0.8047 0.88 0.00 0.06 0.00 0.00 0.06
#&gt; SIH107     2  0.5150     0.4691 0.00 0.62 0.22 0.00 0.00 0.16
#&gt; SIH114     1  0.3950     0.6481 0.72 0.00 0.00 0.00 0.24 0.04
#&gt; SIH116     1  0.1267     0.8221 0.94 0.00 0.00 0.00 0.00 0.06
#&gt; SIH117     3  0.3198     0.8598 0.00 0.26 0.74 0.00 0.00 0.00
#&gt; SIH130     2  0.0000     0.8738 0.00 1.00 0.00 0.00 0.00 0.00
#&gt; SIH134     2  0.0000     0.8738 0.00 1.00 0.00 0.00 0.00 0.00
#&gt; SIH186     2  0.5292     0.4404 0.00 0.60 0.22 0.00 0.00 0.18
#&gt; SIH191     5  0.0547     0.9707 0.02 0.00 0.00 0.00 0.98 0.00
#&gt; SIH192     4  0.1814     0.7364 0.00 0.00 0.10 0.90 0.00 0.00
#&gt; SIH196     2  0.0000     0.8738 0.00 1.00 0.00 0.00 0.00 0.00
#&gt; SIH214     2  0.0000     0.8738 0.00 1.00 0.00 0.00 0.00 0.00
#&gt; SIH218     1  0.3315     0.6962 0.78 0.00 0.20 0.00 0.00 0.02
#&gt; SIH232     5  0.0000     0.9871 0.00 0.00 0.00 0.00 1.00 0.00
#&gt; SIH236     4  0.1480     0.7431 0.00 0.00 0.04 0.94 0.00 0.02
#&gt; SIH238     1  0.3600     0.7655 0.82 0.00 0.08 0.02 0.00 0.08
#&gt; SIH241     2  0.1556     0.7978 0.00 0.92 0.08 0.00 0.00 0.00
#&gt; SIH245     2  0.0000     0.8738 0.00 1.00 0.00 0.00 0.00 0.00
#&gt; SIH260     6  0.6231     0.3142 0.22 0.00 0.04 0.20 0.00 0.54
#&gt; SIH287     2  0.1556     0.8336 0.00 0.92 0.00 0.00 0.00 0.08
#&gt; SIH289     6  0.3647     0.1540 0.00 0.00 0.00 0.36 0.00 0.64
#&gt; SIH290     2  0.0000     0.8738 0.00 1.00 0.00 0.00 0.00 0.00
#&gt; SIH295     5  0.0000     0.9871 0.00 0.00 0.00 0.00 1.00 0.00
#&gt; SIH366     1  0.1807     0.8189 0.92 0.00 0.00 0.00 0.02 0.06
#&gt; SIH377     5  0.0000     0.9871 0.00 0.00 0.00 0.00 1.00 0.00
#&gt; SIH380     2  0.0000     0.8738 0.00 1.00 0.00 0.00 0.00 0.00
#&gt; SIH385     3  0.3198     0.8598 0.00 0.26 0.74 0.00 0.00 0.00
#&gt; SIH389     2  0.0937     0.8538 0.00 0.96 0.00 0.00 0.00 0.04
#&gt; SIH391     4  0.3660     0.6601 0.00 0.00 0.16 0.78 0.00 0.06
#&gt; SIH403     1  0.3523     0.7273 0.78 0.00 0.00 0.00 0.18 0.04
#&gt; SIH411     2  0.0000     0.8738 0.00 1.00 0.00 0.00 0.00 0.00
#&gt; SIH427     5  0.1556     0.9007 0.08 0.00 0.00 0.00 0.92 0.00
#&gt; SIH433     3  0.3198     0.8598 0.00 0.26 0.74 0.00 0.00 0.00
#&gt; SIH439     4  0.1865     0.7342 0.00 0.00 0.04 0.92 0.00 0.04
#&gt; SIH442     5  0.0000     0.9871 0.00 0.00 0.00 0.00 1.00 0.00
#&gt; SIH444     3  0.5392     0.7923 0.12 0.18 0.66 0.00 0.00 0.04
#&gt; SIH452     6  0.4754     0.3383 0.00 0.24 0.02 0.06 0.00 0.68
#&gt; SIH461     3  0.5422     0.7517 0.16 0.14 0.66 0.00 0.00 0.04
#&gt; SIH471     5  0.0000     0.9871 0.00 0.00 0.00 0.00 1.00 0.00
#&gt; SIH472     2  0.5150     0.4691 0.00 0.62 0.22 0.00 0.00 0.16
#&gt; SIH481     5  0.0547     0.9730 0.00 0.00 0.00 0.00 0.98 0.02
#&gt; SIH485     2  0.0000     0.8738 0.00 1.00 0.00 0.00 0.00 0.00
#&gt; SIH491     2  0.0547     0.8600 0.00 0.98 0.02 0.00 0.00 0.00
#&gt; SIH508     1  0.2474     0.8277 0.88 0.00 0.04 0.00 0.08 0.00
#&gt; SIH559     5  0.0000     0.9871 0.00 0.00 0.00 0.00 1.00 0.00
#&gt; SIH587     5  0.0000     0.9871 0.00 0.00 0.00 0.00 1.00 0.00
#&gt; SIH625     4  0.3756     0.0765 0.00 0.00 0.00 0.60 0.00 0.40
#&gt; SIH641     1  0.0937     0.8248 0.96 0.00 0.04 0.00 0.00 0.00
#&gt; SIH643     3  0.5422     0.7517 0.16 0.14 0.66 0.00 0.00 0.04
#&gt; SIH674     5  0.0000     0.9871 0.00 0.00 0.00 0.00 1.00 0.00
#&gt; SIH678     5  0.0000     0.9871 0.00 0.00 0.00 0.00 1.00 0.00
#&gt; SIH679     1  0.1267     0.8221 0.94 0.00 0.00 0.00 0.00 0.06
#&gt; SIH689     3  0.3198     0.8598 0.00 0.26 0.74 0.00 0.00 0.00
#&gt; SIH694     2  0.0000     0.8738 0.00 1.00 0.00 0.00 0.00 0.00
#&gt; SIH721     3  0.4690     0.8442 0.04 0.22 0.70 0.00 0.00 0.04
</code></pre>

<script>
$('#tab-ATC-hclust-get-classes-5-a').parent().next().next().hide();
$('#tab-ATC-hclust-get-classes-5-a').click(function(){
  $('#tab-ATC-hclust-get-classes-5-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>
</div>

Heatmaps for the consensus matrix. It visualizes the probability of two
samples to be in a same group.




<script>
$( function() {
	$( '#tabs-ATC-hclust-consensus-heatmap' ).tabs();
} );
</script>
<div id='tabs-ATC-hclust-consensus-heatmap'>
<ul>
<li><a href='#tab-ATC-hclust-consensus-heatmap-1'>k = 2</a></li>
<li><a href='#tab-ATC-hclust-consensus-heatmap-2'>k = 3</a></li>
<li><a href='#tab-ATC-hclust-consensus-heatmap-3'>k = 4</a></li>
<li><a href='#tab-ATC-hclust-consensus-heatmap-4'>k = 5</a></li>
<li><a href='#tab-ATC-hclust-consensus-heatmap-5'>k = 6</a></li>
</ul>
<div id='tab-ATC-hclust-consensus-heatmap-1'>
<pre><code class="language-r">consensus_heatmap(res, k = 2)
</code></pre>
<p><img src="figure_cola/tab-ATC-hclust-consensus-heatmap-1-1.png" alt="plot of chunk tab-ATC-hclust-consensus-heatmap-1" /></p>

</div>
<div id='tab-ATC-hclust-consensus-heatmap-2'>
<pre><code class="language-r">consensus_heatmap(res, k = 3)
</code></pre>
<p><img src="figure_cola/tab-ATC-hclust-consensus-heatmap-2-1.png" alt="plot of chunk tab-ATC-hclust-consensus-heatmap-2" /></p>

</div>
<div id='tab-ATC-hclust-consensus-heatmap-3'>
<pre><code class="language-r">consensus_heatmap(res, k = 4)
</code></pre>
<p><img src="figure_cola/tab-ATC-hclust-consensus-heatmap-3-1.png" alt="plot of chunk tab-ATC-hclust-consensus-heatmap-3" /></p>

</div>
<div id='tab-ATC-hclust-consensus-heatmap-4'>
<pre><code class="language-r">consensus_heatmap(res, k = 5)
</code></pre>
<p><img src="figure_cola/tab-ATC-hclust-consensus-heatmap-4-1.png" alt="plot of chunk tab-ATC-hclust-consensus-heatmap-4" /></p>

</div>
<div id='tab-ATC-hclust-consensus-heatmap-5'>
<pre><code class="language-r">consensus_heatmap(res, k = 6)
</code></pre>
<p><img src="figure_cola/tab-ATC-hclust-consensus-heatmap-5-1.png" alt="plot of chunk tab-ATC-hclust-consensus-heatmap-5" /></p>

</div>
</div>

Heatmaps for the membership of samples in all partitions to see how consistent they are:





<script>
$( function() {
	$( '#tabs-ATC-hclust-membership-heatmap' ).tabs();
} );
</script>
<div id='tabs-ATC-hclust-membership-heatmap'>
<ul>
<li><a href='#tab-ATC-hclust-membership-heatmap-1'>k = 2</a></li>
<li><a href='#tab-ATC-hclust-membership-heatmap-2'>k = 3</a></li>
<li><a href='#tab-ATC-hclust-membership-heatmap-3'>k = 4</a></li>
<li><a href='#tab-ATC-hclust-membership-heatmap-4'>k = 5</a></li>
<li><a href='#tab-ATC-hclust-membership-heatmap-5'>k = 6</a></li>
</ul>
<div id='tab-ATC-hclust-membership-heatmap-1'>
<pre><code class="language-r">membership_heatmap(res, k = 2)
</code></pre>
<p><img src="figure_cola/tab-ATC-hclust-membership-heatmap-1-1.png" alt="plot of chunk tab-ATC-hclust-membership-heatmap-1" /></p>

</div>
<div id='tab-ATC-hclust-membership-heatmap-2'>
<pre><code class="language-r">membership_heatmap(res, k = 3)
</code></pre>
<p><img src="figure_cola/tab-ATC-hclust-membership-heatmap-2-1.png" alt="plot of chunk tab-ATC-hclust-membership-heatmap-2" /></p>

</div>
<div id='tab-ATC-hclust-membership-heatmap-3'>
<pre><code class="language-r">membership_heatmap(res, k = 4)
</code></pre>
<p><img src="figure_cola/tab-ATC-hclust-membership-heatmap-3-1.png" alt="plot of chunk tab-ATC-hclust-membership-heatmap-3" /></p>

</div>
<div id='tab-ATC-hclust-membership-heatmap-4'>
<pre><code class="language-r">membership_heatmap(res, k = 5)
</code></pre>
<p><img src="figure_cola/tab-ATC-hclust-membership-heatmap-4-1.png" alt="plot of chunk tab-ATC-hclust-membership-heatmap-4" /></p>

</div>
<div id='tab-ATC-hclust-membership-heatmap-5'>
<pre><code class="language-r">membership_heatmap(res, k = 6)
</code></pre>
<p><img src="figure_cola/tab-ATC-hclust-membership-heatmap-5-1.png" alt="plot of chunk tab-ATC-hclust-membership-heatmap-5" /></p>

</div>
</div>

As soon as the classes for columns are determined, the signatures
that are significantly different between subgroups can be looked for. 
Following are the heatmaps for signatures.




Signature heatmaps where rows are scaled:



<script>
$( function() {
	$( '#tabs-ATC-hclust-get-signatures' ).tabs();
} );
</script>
<div id='tabs-ATC-hclust-get-signatures'>
<ul>
<li><a href='#tab-ATC-hclust-get-signatures-1'>k = 2</a></li>
<li><a href='#tab-ATC-hclust-get-signatures-2'>k = 3</a></li>
<li><a href='#tab-ATC-hclust-get-signatures-3'>k = 4</a></li>
<li><a href='#tab-ATC-hclust-get-signatures-4'>k = 5</a></li>
<li><a href='#tab-ATC-hclust-get-signatures-5'>k = 6</a></li>
</ul>
<div id='tab-ATC-hclust-get-signatures-1'>
<pre><code class="language-r">get_signatures(res, k = 2)
</code></pre>
<p><img src="figure_cola/tab-ATC-hclust-get-signatures-1-1.png" alt="plot of chunk tab-ATC-hclust-get-signatures-1" /></p>

</div>
<div id='tab-ATC-hclust-get-signatures-2'>
<pre><code class="language-r">get_signatures(res, k = 3)
</code></pre>
<p><img src="figure_cola/tab-ATC-hclust-get-signatures-2-1.png" alt="plot of chunk tab-ATC-hclust-get-signatures-2" /></p>

</div>
<div id='tab-ATC-hclust-get-signatures-3'>
<pre><code class="language-r">get_signatures(res, k = 4)
</code></pre>
<p><img src="figure_cola/tab-ATC-hclust-get-signatures-3-1.png" alt="plot of chunk tab-ATC-hclust-get-signatures-3" /></p>

</div>
<div id='tab-ATC-hclust-get-signatures-4'>
<pre><code class="language-r">get_signatures(res, k = 5)
</code></pre>
<p><img src="figure_cola/tab-ATC-hclust-get-signatures-4-1.png" alt="plot of chunk tab-ATC-hclust-get-signatures-4" /></p>

</div>
<div id='tab-ATC-hclust-get-signatures-5'>
<pre><code class="language-r">get_signatures(res, k = 6)
</code></pre>
<p><img src="figure_cola/tab-ATC-hclust-get-signatures-5-1.png" alt="plot of chunk tab-ATC-hclust-get-signatures-5" /></p>

</div>
</div>



Signature heatmaps where rows are not scaled:


<script>
$( function() {
	$( '#tabs-ATC-hclust-get-signatures-no-scale' ).tabs();
} );
</script>
<div id='tabs-ATC-hclust-get-signatures-no-scale'>
<ul>
<li><a href='#tab-ATC-hclust-get-signatures-no-scale-1'>k = 2</a></li>
<li><a href='#tab-ATC-hclust-get-signatures-no-scale-2'>k = 3</a></li>
<li><a href='#tab-ATC-hclust-get-signatures-no-scale-3'>k = 4</a></li>
<li><a href='#tab-ATC-hclust-get-signatures-no-scale-4'>k = 5</a></li>
<li><a href='#tab-ATC-hclust-get-signatures-no-scale-5'>k = 6</a></li>
</ul>
<div id='tab-ATC-hclust-get-signatures-no-scale-1'>
<pre><code class="language-r">get_signatures(res, k = 2, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-ATC-hclust-get-signatures-no-scale-1-1.png" alt="plot of chunk tab-ATC-hclust-get-signatures-no-scale-1" /></p>

</div>
<div id='tab-ATC-hclust-get-signatures-no-scale-2'>
<pre><code class="language-r">get_signatures(res, k = 3, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-ATC-hclust-get-signatures-no-scale-2-1.png" alt="plot of chunk tab-ATC-hclust-get-signatures-no-scale-2" /></p>

</div>
<div id='tab-ATC-hclust-get-signatures-no-scale-3'>
<pre><code class="language-r">get_signatures(res, k = 4, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-ATC-hclust-get-signatures-no-scale-3-1.png" alt="plot of chunk tab-ATC-hclust-get-signatures-no-scale-3" /></p>

</div>
<div id='tab-ATC-hclust-get-signatures-no-scale-4'>
<pre><code class="language-r">get_signatures(res, k = 5, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-ATC-hclust-get-signatures-no-scale-4-1.png" alt="plot of chunk tab-ATC-hclust-get-signatures-no-scale-4" /></p>

</div>
<div id='tab-ATC-hclust-get-signatures-no-scale-5'>
<pre><code class="language-r">get_signatures(res, k = 6, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-ATC-hclust-get-signatures-no-scale-5-1.png" alt="plot of chunk tab-ATC-hclust-get-signatures-no-scale-5" /></p>

</div>
</div>



Compare the overlap of signatures from different k:

``` r
compare_signatures(res)
```

![plot of chunk ATC-hclust-signature_compare](figure_cola/ATC-hclust-signature_compare-1.png)

`get_signature()` returns a data frame invisibly. To get the list of signatures, the function
call should be assigned to a variable explicitly. In following code, if `plot` argument is set
to `FALSE`, no heatmap is plotted while only the differential analysis is performed.

``` r
# code only for demonstration
tb = get_signature(res, k = ..., plot = FALSE)
```

An example of the output of `tb` is:

```
#>   which_row         fdr    mean_1    mean_2 scaled_mean_1 scaled_mean_2 km
#> 1        38 0.042760348  8.373488  9.131774    -0.5533452     0.5164555  1
#> 2        40 0.018707592  7.106213  8.469186    -0.6173731     0.5762149  1
#> 3        55 0.019134737 10.221463 11.207825    -0.6159697     0.5749050  1
#> 4        59 0.006059896  5.921854  7.869574    -0.6899429     0.6439467  1
#> 5        60 0.018055526  8.928898 10.211722    -0.6204761     0.5791110  1
#> 6        98 0.009384629 15.714769 14.887706     0.6635654    -0.6193277  2
...
```

The columns in `tb` are:

1. `which_row`: row indices corresponding to the input matrix.
2. `fdr`: FDR for the differential test. 
3. `mean_x`: The mean value in group x.
4. `scaled_mean_x`: The mean value in group x after rows are scaled.
5. `km`: Row groups if k-means clustering is applied to rows (which is done by automatically selecting number of clusters).

If there are too many signatures, `top_signatures = ...` can be set to only show the 
signatures with the highest FDRs:

``` r
# code only for demonstration
# e.g. to show the top 500 most significant rows
tb = get_signature(res, k = ..., top_signatures = 500)
```

If the signatures are defined as these which are uniquely high in current group, `diff_method` argument
can be set to `"uniquely_high_in_one_group"`:

``` r
# code only for demonstration
tb = get_signature(res, k = ..., diff_method = "uniquely_high_in_one_group")
```




UMAP plot which shows how samples are separated.


<script>
$( function() {
	$( '#tabs-ATC-hclust-dimension-reduction' ).tabs();
} );
</script>
<div id='tabs-ATC-hclust-dimension-reduction'>
<ul>
<li><a href='#tab-ATC-hclust-dimension-reduction-1'>k = 2</a></li>
<li><a href='#tab-ATC-hclust-dimension-reduction-2'>k = 3</a></li>
<li><a href='#tab-ATC-hclust-dimension-reduction-3'>k = 4</a></li>
<li><a href='#tab-ATC-hclust-dimension-reduction-4'>k = 5</a></li>
<li><a href='#tab-ATC-hclust-dimension-reduction-5'>k = 6</a></li>
</ul>
<div id='tab-ATC-hclust-dimension-reduction-1'>
<pre><code class="language-r">dimension_reduction(res, k = 2, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-ATC-hclust-dimension-reduction-1-1.png" alt="plot of chunk tab-ATC-hclust-dimension-reduction-1" /></p>

</div>
<div id='tab-ATC-hclust-dimension-reduction-2'>
<pre><code class="language-r">dimension_reduction(res, k = 3, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-ATC-hclust-dimension-reduction-2-1.png" alt="plot of chunk tab-ATC-hclust-dimension-reduction-2" /></p>

</div>
<div id='tab-ATC-hclust-dimension-reduction-3'>
<pre><code class="language-r">dimension_reduction(res, k = 4, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-ATC-hclust-dimension-reduction-3-1.png" alt="plot of chunk tab-ATC-hclust-dimension-reduction-3" /></p>

</div>
<div id='tab-ATC-hclust-dimension-reduction-4'>
<pre><code class="language-r">dimension_reduction(res, k = 5, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-ATC-hclust-dimension-reduction-4-1.png" alt="plot of chunk tab-ATC-hclust-dimension-reduction-4" /></p>

</div>
<div id='tab-ATC-hclust-dimension-reduction-5'>
<pre><code class="language-r">dimension_reduction(res, k = 6, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-ATC-hclust-dimension-reduction-5-1.png" alt="plot of chunk tab-ATC-hclust-dimension-reduction-5" /></p>

</div>
</div>



Following heatmap shows how subgroups are split when increasing `k`:

``` r
collect_classes(res)
```

![plot of chunk ATC-hclust-collect-classes](figure_cola/ATC-hclust-collect-classes-1.png)



If matrix rows can be associated to genes, consider to use `functional_enrichment(res,
...)` to perform function enrichment for the signature genes. See [this vignette](https://jokergoo.github.io/cola_vignettes/functional_enrichment.html) for more detailed explanations.


 

---------------------------------------------------



### ATC:kmeans**






The object with results only for a single top-value method and a single partitioning method 
can be extracted as:

``` r
res = res_list["ATC", "kmeans"]
# you can also extract it by
# res = res_list["ATC:kmeans"]
```

A summary of `res` and all the functions that can be applied to it:

``` r
res
```

```
#> A 'ConsensusPartition' object with k = 2, 3, 4, 5, 6.
#>   On a matrix with 1900 rows and 60 columns.
#>   Top rows (190) are extracted by 'ATC' method.
#>   Subgroups are detected by 'kmeans' method.
#>   Performed in total 250 partitions by row resampling.
#>   Best k for subgroups seems to be 2.
#> 
#> Following methods can be applied to this 'ConsensusPartition' object:
#>  [1] "cola_report"             "collect_classes"         "collect_plots"          
#>  [4] "collect_stats"           "colnames"                "compare_partitions"     
#>  [7] "compare_signatures"      "consensus_heatmap"       "dimension_reduction"    
#> [10] "functional_enrichment"   "get_anno_col"            "get_anno"               
#> [13] "get_classes"             "get_consensus"           "get_matrix"             
#> [16] "get_membership"          "get_param"               "get_signatures"         
#> [19] "get_stats"               "is_best_k"               "is_stable_k"            
#> [22] "membership_heatmap"      "ncol"                    "nrow"                   
#> [25] "plot_ecdf"               "predict_classes"         "rownames"               
#> [28] "select_partition_number" "show"                    "suggest_best_k"         
#> [31] "test_to_known_factors"   "top_rows_heatmap"
```

`collect_plots()` function collects all the plots made from `res` for all `k` (number of subgroups)
into one single page to provide an easy and fast comparison between different `k`.

``` r
collect_plots(res)
```

![plot of chunk ATC-kmeans-collect-plots](figure_cola/ATC-kmeans-collect-plots-1.png)

The plots are:

- The first row: a plot of the eCDF (empirical cumulative distribution
  function) curves of the consensus matrix for each `k` and the heatmap of
  predicted classes for each `k`.
- The second row: heatmaps of the consensus matrix for each `k`.
- The third row: heatmaps of the membership matrix for each `k`.
- The fouth row: heatmaps of the signatures for each `k`.

All the plots in panels can be made by individual functions and they are
plotted later in this section.

`select_partition_number()` produces several plots showing different
statistics for choosing "optimized" `k`. There are following statistics:

- eCDF curves of the consensus matrix for each `k`;
- 1-PAC. [The PAC score](https://en.wikipedia.org/wiki/Consensus_clustering#Over-interpretation_potential_of_consensus_clustering)
  measures the proportion of the ambiguous subgrouping.
- Mean silhouette score.
- Concordance. The mean probability of fiting the consensus subgroup labels in all
  partitions.
- Area increased. Denote $A_k$ as the area under the eCDF curve for current
  `k`, the area increased is defined as $A_k - A_{k-1}$.
- Rand index. The percent of pairs of samples that are both in a same cluster
  or both are not in a same cluster in the partition of k and k-1.
- Jaccard index. The ratio of pairs of samples are both in a same cluster in
  the partition of k and k-1 and the pairs of samples are both in a same
  cluster in the partition k or k-1.

The detailed explanations of these statistics can be found in [the _cola_
vignette](https://jokergoo.github.io/cola_vignettes/cola.html#toc_13).

Generally speaking, higher 1-PAC score, higher mean silhouette score or higher
concordance corresponds to better partition. Rand index and Jaccard index
measure how similar the current partition is compared to partition with `k-1`.
If they are too similar, we won't accept `k` is better than `k-1`.

``` r
select_partition_number(res)
```

![plot of chunk ATC-kmeans-select-partition-number](figure_cola/ATC-kmeans-select-partition-number-1.png)

The numeric values for all these statistics can be obtained by `get_stats()`.

``` r
get_stats(res)
```

```
#>   k 1-PAC mean_silhouette concordance area_increased  Rand Jaccard
#> 2 2 1.000           0.982       0.993         0.4674 0.537   0.537
#> 3 3 0.780           0.840       0.928         0.4225 0.702   0.488
#> 4 4 0.701           0.609       0.837         0.1200 0.840   0.571
#> 5 5 0.850           0.885       0.922         0.0702 0.901   0.643
#> 6 6 0.882           0.622       0.846         0.0329 0.951   0.771
```

`suggest_best_k()` suggests the best $k$ based on these statistics. The rules are as follows:

- All $k$ with Jaccard index larger than 0.95 are removed because increasing
  $k$ does not provide enough extra information. If all $k$ are removed, it is
  marked as no subgroup is detected.
- For all $k$ with 1-PAC score larger than 0.9, the maximal $k$ is taken as
  the best $k$, and other $k$ are marked as optional $k$.
- If it does not fit the second rule. The $k$ with the maximal vote of the
  highest 1-PAC score, highest mean silhouette, and highest concordance is
  taken as the best $k$.

``` r
suggest_best_k(res)
```

```
#> [1] 2
```


Following is the table of the partitions (You need to click the **show/hide
code output** link to see it). The membership matrix (columns with name `p*`)
is inferred by
[`clue::cl_consensus()`](https://www.rdocumentation.org/link/cl_consensus?package=clue)
function with the `SE` method. Basically the value in the membership matrix
represents the probability to belong to a certain group. The finall subgroup
label for an item is determined with the group with highest probability it
belongs to.

In `get_classes()` function, the entropy is calculated from the membership
matrix and the silhouette score is calculated from the consensus matrix.



<script>
$( function() {
	$( '#tabs-ATC-kmeans-get-classes' ).tabs();
} );
</script>
<div id='tabs-ATC-kmeans-get-classes'>
<ul>
<li><a href='#tab-ATC-kmeans-get-classes-1'>k = 2</a></li>
<li><a href='#tab-ATC-kmeans-get-classes-2'>k = 3</a></li>
<li><a href='#tab-ATC-kmeans-get-classes-3'>k = 4</a></li>
<li><a href='#tab-ATC-kmeans-get-classes-4'>k = 5</a></li>
<li><a href='#tab-ATC-kmeans-get-classes-5'>k = 6</a></li>
</ul>

<div id='tab-ATC-kmeans-get-classes-1'>
<p><a id='tab-ATC-kmeans-get-classes-1-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 2), get_membership(res, k = 2))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2
#&gt; SIH013     2   0.000      0.988 0.00 1.00
#&gt; SIH014     2   0.000      0.988 0.00 1.00
#&gt; SIH024     2   0.000      0.988 0.00 1.00
#&gt; SIH028     2   0.000      0.988 0.00 1.00
#&gt; SIH031     1   0.000      1.000 1.00 0.00
#&gt; SIH042     1   0.000      1.000 1.00 0.00
#&gt; SIH107     2   0.000      0.988 0.00 1.00
#&gt; SIH114     1   0.000      1.000 1.00 0.00
#&gt; SIH116     2   0.469      0.885 0.10 0.90
#&gt; SIH117     2   0.000      0.988 0.00 1.00
#&gt; SIH130     2   0.000      0.988 0.00 1.00
#&gt; SIH134     2   0.000      0.988 0.00 1.00
#&gt; SIH186     2   0.000      0.988 0.00 1.00
#&gt; SIH191     1   0.000      1.000 1.00 0.00
#&gt; SIH192     2   0.000      0.988 0.00 1.00
#&gt; SIH196     2   0.000      0.988 0.00 1.00
#&gt; SIH214     2   0.000      0.988 0.00 1.00
#&gt; SIH218     2   0.925      0.491 0.34 0.66
#&gt; SIH232     1   0.000      1.000 1.00 0.00
#&gt; SIH236     2   0.000      0.988 0.00 1.00
#&gt; SIH238     1   0.000      1.000 1.00 0.00
#&gt; SIH241     2   0.000      0.988 0.00 1.00
#&gt; SIH245     2   0.000      0.988 0.00 1.00
#&gt; SIH260     2   0.000      0.988 0.00 1.00
#&gt; SIH287     2   0.000      0.988 0.00 1.00
#&gt; SIH289     2   0.000      0.988 0.00 1.00
#&gt; SIH290     2   0.000      0.988 0.00 1.00
#&gt; SIH295     1   0.000      1.000 1.00 0.00
#&gt; SIH366     1   0.000      1.000 1.00 0.00
#&gt; SIH377     1   0.000      1.000 1.00 0.00
#&gt; SIH380     2   0.000      0.988 0.00 1.00
#&gt; SIH385     2   0.000      0.988 0.00 1.00
#&gt; SIH389     2   0.000      0.988 0.00 1.00
#&gt; SIH391     2   0.000      0.988 0.00 1.00
#&gt; SIH403     1   0.000      1.000 1.00 0.00
#&gt; SIH411     2   0.000      0.988 0.00 1.00
#&gt; SIH427     1   0.000      1.000 1.00 0.00
#&gt; SIH433     2   0.000      0.988 0.00 1.00
#&gt; SIH439     2   0.000      0.988 0.00 1.00
#&gt; SIH442     1   0.000      1.000 1.00 0.00
#&gt; SIH444     2   0.000      0.988 0.00 1.00
#&gt; SIH452     2   0.000      0.988 0.00 1.00
#&gt; SIH461     2   0.000      0.988 0.00 1.00
#&gt; SIH471     1   0.000      1.000 1.00 0.00
#&gt; SIH472     2   0.000      0.988 0.00 1.00
#&gt; SIH481     1   0.000      1.000 1.00 0.00
#&gt; SIH485     2   0.000      0.988 0.00 1.00
#&gt; SIH491     2   0.000      0.988 0.00 1.00
#&gt; SIH508     1   0.000      1.000 1.00 0.00
#&gt; SIH559     1   0.000      1.000 1.00 0.00
#&gt; SIH587     1   0.000      1.000 1.00 0.00
#&gt; SIH625     2   0.000      0.988 0.00 1.00
#&gt; SIH641     1   0.000      1.000 1.00 0.00
#&gt; SIH643     2   0.000      0.988 0.00 1.00
#&gt; SIH674     1   0.000      1.000 1.00 0.00
#&gt; SIH678     1   0.000      1.000 1.00 0.00
#&gt; SIH679     1   0.000      1.000 1.00 0.00
#&gt; SIH689     2   0.000      0.988 0.00 1.00
#&gt; SIH694     2   0.000      0.988 0.00 1.00
#&gt; SIH721     2   0.000      0.988 0.00 1.00
</code></pre>

<script>
$('#tab-ATC-kmeans-get-classes-1-a').parent().next().next().hide();
$('#tab-ATC-kmeans-get-classes-1-a').click(function(){
  $('#tab-ATC-kmeans-get-classes-1-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-ATC-kmeans-get-classes-2'>
<p><a id='tab-ATC-kmeans-get-classes-2-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 3), get_membership(res, k = 3))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3
#&gt; SIH013     3  0.2066     0.8771 0.00 0.06 0.94
#&gt; SIH014     2  0.1529     0.9063 0.00 0.96 0.04
#&gt; SIH024     3  0.6192     0.3436 0.00 0.42 0.58
#&gt; SIH028     2  0.4002     0.7812 0.00 0.84 0.16
#&gt; SIH031     1  0.4796     0.7304 0.78 0.00 0.22
#&gt; SIH042     3  0.2066     0.8644 0.06 0.00 0.94
#&gt; SIH107     2  0.2066     0.9003 0.00 0.94 0.06
#&gt; SIH114     1  0.0000     0.9409 1.00 0.00 0.00
#&gt; SIH116     3  0.0000     0.8778 0.00 0.00 1.00
#&gt; SIH117     3  0.6045     0.4423 0.00 0.38 0.62
#&gt; SIH130     2  0.0000     0.9303 0.00 1.00 0.00
#&gt; SIH134     2  0.0000     0.9303 0.00 1.00 0.00
#&gt; SIH186     2  0.2066     0.9003 0.00 0.94 0.06
#&gt; SIH191     1  0.0000     0.9409 1.00 0.00 0.00
#&gt; SIH192     3  0.5706     0.4883 0.00 0.32 0.68
#&gt; SIH196     2  0.0000     0.9303 0.00 1.00 0.00
#&gt; SIH214     2  0.0000     0.9303 0.00 1.00 0.00
#&gt; SIH218     3  0.2414     0.8737 0.04 0.02 0.94
#&gt; SIH232     1  0.0000     0.9409 1.00 0.00 0.00
#&gt; SIH236     3  0.0000     0.8778 0.00 0.00 1.00
#&gt; SIH238     3  0.2066     0.8644 0.06 0.00 0.94
#&gt; SIH241     2  0.0000     0.9303 0.00 1.00 0.00
#&gt; SIH245     2  0.0000     0.9303 0.00 1.00 0.00
#&gt; SIH260     3  0.0000     0.8778 0.00 0.00 1.00
#&gt; SIH287     2  0.2066     0.9003 0.00 0.94 0.06
#&gt; SIH289     3  0.0000     0.8778 0.00 0.00 1.00
#&gt; SIH290     2  0.0000     0.9303 0.00 1.00 0.00
#&gt; SIH295     1  0.0000     0.9409 1.00 0.00 0.00
#&gt; SIH366     3  0.4002     0.7644 0.16 0.00 0.84
#&gt; SIH377     1  0.0000     0.9409 1.00 0.00 0.00
#&gt; SIH380     2  0.0000     0.9303 0.00 1.00 0.00
#&gt; SIH385     2  0.0892     0.9199 0.00 0.98 0.02
#&gt; SIH389     2  0.0000     0.9303 0.00 1.00 0.00
#&gt; SIH391     3  0.0000     0.8778 0.00 0.00 1.00
#&gt; SIH403     1  0.6126     0.3739 0.60 0.00 0.40
#&gt; SIH411     2  0.0000     0.9303 0.00 1.00 0.00
#&gt; SIH427     1  0.0000     0.9409 1.00 0.00 0.00
#&gt; SIH433     2  0.6302    -0.0672 0.00 0.52 0.48
#&gt; SIH439     3  0.0000     0.8778 0.00 0.00 1.00
#&gt; SIH442     1  0.0000     0.9409 1.00 0.00 0.00
#&gt; SIH444     3  0.2066     0.8771 0.00 0.06 0.94
#&gt; SIH452     2  0.4002     0.8165 0.00 0.84 0.16
#&gt; SIH461     3  0.2066     0.8771 0.00 0.06 0.94
#&gt; SIH471     1  0.0000     0.9409 1.00 0.00 0.00
#&gt; SIH472     2  0.2066     0.9003 0.00 0.94 0.06
#&gt; SIH481     1  0.0000     0.9409 1.00 0.00 0.00
#&gt; SIH485     2  0.0000     0.9303 0.00 1.00 0.00
#&gt; SIH491     2  0.0000     0.9303 0.00 1.00 0.00
#&gt; SIH508     1  0.4796     0.7317 0.78 0.00 0.22
#&gt; SIH559     1  0.0000     0.9409 1.00 0.00 0.00
#&gt; SIH587     1  0.0000     0.9409 1.00 0.00 0.00
#&gt; SIH625     3  0.4002     0.7536 0.00 0.16 0.84
#&gt; SIH641     3  0.3686     0.7913 0.14 0.00 0.86
#&gt; SIH643     3  0.2066     0.8771 0.00 0.06 0.94
#&gt; SIH674     1  0.0000     0.9409 1.00 0.00 0.00
#&gt; SIH678     1  0.0000     0.9409 1.00 0.00 0.00
#&gt; SIH679     3  0.2066     0.8644 0.06 0.00 0.94
#&gt; SIH689     2  0.5216     0.6031 0.00 0.74 0.26
#&gt; SIH694     2  0.0000     0.9303 0.00 1.00 0.00
#&gt; SIH721     3  0.2066     0.8771 0.00 0.06 0.94
</code></pre>

<script>
$('#tab-ATC-kmeans-get-classes-2-a').parent().next().next().hide();
$('#tab-ATC-kmeans-get-classes-2-a').click(function(){
  $('#tab-ATC-kmeans-get-classes-2-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-ATC-kmeans-get-classes-3'>
<p><a id='tab-ATC-kmeans-get-classes-3-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 4), get_membership(res, k = 4))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3   p4
#&gt; SIH013     3   0.234     0.4038 0.00 0.00 0.90 0.10
#&gt; SIH014     2   0.659     0.1537 0.00 0.50 0.42 0.08
#&gt; SIH024     3   0.680     0.0292 0.00 0.40 0.50 0.10
#&gt; SIH028     2   0.630     0.3651 0.00 0.60 0.32 0.08
#&gt; SIH031     3   0.599     0.1095 0.44 0.00 0.52 0.04
#&gt; SIH042     3   0.495    -0.0100 0.00 0.00 0.56 0.44
#&gt; SIH107     2   0.265     0.8061 0.00 0.88 0.00 0.12
#&gt; SIH114     1   0.201     0.8993 0.92 0.00 0.08 0.00
#&gt; SIH116     4   0.499     0.0441 0.00 0.00 0.48 0.52
#&gt; SIH117     3   0.680     0.0292 0.00 0.40 0.50 0.10
#&gt; SIH130     2   0.000     0.8807 0.00 1.00 0.00 0.00
#&gt; SIH134     2   0.000     0.8807 0.00 1.00 0.00 0.00
#&gt; SIH186     2   0.265     0.8061 0.00 0.88 0.00 0.12
#&gt; SIH191     1   0.000     0.9922 1.00 0.00 0.00 0.00
#&gt; SIH192     4   0.527     0.3838 0.00 0.02 0.34 0.64
#&gt; SIH196     2   0.000     0.8807 0.00 1.00 0.00 0.00
#&gt; SIH214     2   0.000     0.8807 0.00 1.00 0.00 0.00
#&gt; SIH218     3   0.380     0.3094 0.00 0.00 0.78 0.22
#&gt; SIH232     1   0.000     0.9922 1.00 0.00 0.00 0.00
#&gt; SIH236     4   0.201     0.7170 0.00 0.00 0.08 0.92
#&gt; SIH238     3   0.398     0.2911 0.00 0.00 0.76 0.24
#&gt; SIH241     2   0.121     0.8539 0.00 0.96 0.04 0.00
#&gt; SIH245     2   0.000     0.8807 0.00 1.00 0.00 0.00
#&gt; SIH260     4   0.164     0.7244 0.00 0.00 0.06 0.94
#&gt; SIH287     2   0.265     0.8061 0.00 0.88 0.00 0.12
#&gt; SIH289     4   0.000     0.7257 0.00 0.00 0.00 1.00
#&gt; SIH290     2   0.000     0.8807 0.00 1.00 0.00 0.00
#&gt; SIH295     1   0.000     0.9922 1.00 0.00 0.00 0.00
#&gt; SIH366     3   0.559    -0.0627 0.02 0.00 0.52 0.46
#&gt; SIH377     1   0.000     0.9922 1.00 0.00 0.00 0.00
#&gt; SIH380     2   0.000     0.8807 0.00 1.00 0.00 0.00
#&gt; SIH385     2   0.660     0.1040 0.00 0.48 0.44 0.08
#&gt; SIH389     2   0.000     0.8807 0.00 1.00 0.00 0.00
#&gt; SIH391     4   0.201     0.7330 0.00 0.00 0.08 0.92
#&gt; SIH403     3   0.626     0.1973 0.40 0.00 0.54 0.06
#&gt; SIH411     2   0.000     0.8807 0.00 1.00 0.00 0.00
#&gt; SIH427     1   0.000     0.9922 1.00 0.00 0.00 0.00
#&gt; SIH433     3   0.680     0.0292 0.00 0.40 0.50 0.10
#&gt; SIH439     4   0.361     0.6644 0.00 0.00 0.20 0.80
#&gt; SIH442     1   0.000     0.9922 1.00 0.00 0.00 0.00
#&gt; SIH444     3   0.201     0.4067 0.00 0.00 0.92 0.08
#&gt; SIH452     4   0.413     0.4977 0.00 0.26 0.00 0.74
#&gt; SIH461     3   0.234     0.4038 0.00 0.00 0.90 0.10
#&gt; SIH471     1   0.000     0.9922 1.00 0.00 0.00 0.00
#&gt; SIH472     2   0.265     0.8061 0.00 0.88 0.00 0.12
#&gt; SIH481     1   0.000     0.9922 1.00 0.00 0.00 0.00
#&gt; SIH485     2   0.000     0.8807 0.00 1.00 0.00 0.00
#&gt; SIH491     2   0.000     0.8807 0.00 1.00 0.00 0.00
#&gt; SIH508     3   0.626     0.1973 0.40 0.00 0.54 0.06
#&gt; SIH559     1   0.000     0.9922 1.00 0.00 0.00 0.00
#&gt; SIH587     1   0.000     0.9922 1.00 0.00 0.00 0.00
#&gt; SIH625     4   0.191     0.7166 0.00 0.02 0.04 0.94
#&gt; SIH641     3   0.684     0.2464 0.18 0.00 0.60 0.22
#&gt; SIH643     3   0.234     0.4038 0.00 0.00 0.90 0.10
#&gt; SIH674     1   0.000     0.9922 1.00 0.00 0.00 0.00
#&gt; SIH678     1   0.000     0.9922 1.00 0.00 0.00 0.00
#&gt; SIH679     3   0.499    -0.0971 0.00 0.00 0.52 0.48
#&gt; SIH689     3   0.683    -0.0241 0.00 0.42 0.48 0.10
#&gt; SIH694     2   0.000     0.8807 0.00 1.00 0.00 0.00
#&gt; SIH721     3   0.234     0.4038 0.00 0.00 0.90 0.10
</code></pre>

<script>
$('#tab-ATC-kmeans-get-classes-3-a').parent().next().next().hide();
$('#tab-ATC-kmeans-get-classes-3-a').click(function(){
  $('#tab-ATC-kmeans-get-classes-3-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-ATC-kmeans-get-classes-4'>
<p><a id='tab-ATC-kmeans-get-classes-4-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 5), get_membership(res, k = 5))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3   p4   p5
#&gt; SIH013     3  0.2020      0.851 0.10 0.00 0.90 0.00 0.00
#&gt; SIH014     3  0.2929      0.834 0.00 0.18 0.82 0.00 0.00
#&gt; SIH024     3  0.2020      0.880 0.00 0.10 0.90 0.00 0.00
#&gt; SIH028     3  0.4182      0.511 0.00 0.40 0.60 0.00 0.00
#&gt; SIH031     1  0.2331      0.910 0.90 0.00 0.02 0.00 0.08
#&gt; SIH042     1  0.2438      0.929 0.90 0.00 0.04 0.06 0.00
#&gt; SIH107     2  0.4552      0.817 0.10 0.78 0.10 0.02 0.00
#&gt; SIH114     5  0.4262      0.154 0.44 0.00 0.00 0.00 0.56
#&gt; SIH116     1  0.2516      0.877 0.86 0.00 0.00 0.14 0.00
#&gt; SIH117     3  0.2020      0.880 0.00 0.10 0.90 0.00 0.00
#&gt; SIH130     2  0.0000      0.935 0.00 1.00 0.00 0.00 0.00
#&gt; SIH134     2  0.0000      0.935 0.00 1.00 0.00 0.00 0.00
#&gt; SIH186     2  0.4552      0.817 0.10 0.78 0.10 0.02 0.00
#&gt; SIH191     5  0.0000      0.960 0.00 0.00 0.00 0.00 1.00
#&gt; SIH192     4  0.1732      0.881 0.00 0.00 0.08 0.92 0.00
#&gt; SIH196     2  0.0000      0.935 0.00 1.00 0.00 0.00 0.00
#&gt; SIH214     2  0.0000      0.935 0.00 1.00 0.00 0.00 0.00
#&gt; SIH218     1  0.2020      0.915 0.90 0.00 0.10 0.00 0.00
#&gt; SIH232     5  0.0000      0.960 0.00 0.00 0.00 0.00 1.00
#&gt; SIH236     4  0.0609      0.925 0.00 0.00 0.02 0.98 0.00
#&gt; SIH238     1  0.2020      0.915 0.90 0.00 0.10 0.00 0.00
#&gt; SIH241     2  0.1043      0.900 0.00 0.96 0.04 0.00 0.00
#&gt; SIH245     2  0.0000      0.935 0.00 1.00 0.00 0.00 0.00
#&gt; SIH260     4  0.1043      0.900 0.04 0.00 0.00 0.96 0.00
#&gt; SIH287     2  0.4552      0.817 0.10 0.78 0.10 0.02 0.00
#&gt; SIH289     4  0.0000      0.922 0.00 0.00 0.00 1.00 0.00
#&gt; SIH290     2  0.0000      0.935 0.00 1.00 0.00 0.00 0.00
#&gt; SIH295     5  0.0000      0.960 0.00 0.00 0.00 0.00 1.00
#&gt; SIH366     1  0.2020      0.912 0.90 0.00 0.00 0.10 0.00
#&gt; SIH377     5  0.0000      0.960 0.00 0.00 0.00 0.00 1.00
#&gt; SIH380     2  0.0000      0.935 0.00 1.00 0.00 0.00 0.00
#&gt; SIH385     3  0.3109      0.818 0.00 0.20 0.80 0.00 0.00
#&gt; SIH389     2  0.1043      0.921 0.00 0.96 0.04 0.00 0.00
#&gt; SIH391     4  0.0609      0.925 0.00 0.00 0.02 0.98 0.00
#&gt; SIH403     1  0.2438      0.925 0.90 0.00 0.04 0.00 0.06
#&gt; SIH411     2  0.0000      0.935 0.00 1.00 0.00 0.00 0.00
#&gt; SIH427     5  0.0000      0.960 0.00 0.00 0.00 0.00 1.00
#&gt; SIH433     3  0.2020      0.880 0.00 0.10 0.90 0.00 0.00
#&gt; SIH439     4  0.0609      0.925 0.00 0.00 0.02 0.98 0.00
#&gt; SIH442     5  0.0000      0.960 0.00 0.00 0.00 0.00 1.00
#&gt; SIH444     3  0.2280      0.834 0.12 0.00 0.88 0.00 0.00
#&gt; SIH452     4  0.6212      0.623 0.10 0.16 0.08 0.66 0.00
#&gt; SIH461     3  0.2020      0.851 0.10 0.00 0.90 0.00 0.00
#&gt; SIH471     5  0.0000      0.960 0.00 0.00 0.00 0.00 1.00
#&gt; SIH472     2  0.4552      0.817 0.10 0.78 0.10 0.02 0.00
#&gt; SIH481     5  0.0000      0.960 0.00 0.00 0.00 0.00 1.00
#&gt; SIH485     2  0.0000      0.935 0.00 1.00 0.00 0.00 0.00
#&gt; SIH491     2  0.1732      0.900 0.00 0.92 0.08 0.00 0.00
#&gt; SIH508     1  0.2438      0.925 0.90 0.00 0.04 0.00 0.06
#&gt; SIH559     5  0.0000      0.960 0.00 0.00 0.00 0.00 1.00
#&gt; SIH587     5  0.0000      0.960 0.00 0.00 0.00 0.00 1.00
#&gt; SIH625     4  0.0000      0.922 0.00 0.00 0.00 1.00 0.00
#&gt; SIH641     1  0.2610      0.932 0.90 0.00 0.06 0.02 0.02
#&gt; SIH643     3  0.2020      0.851 0.10 0.00 0.90 0.00 0.00
#&gt; SIH674     5  0.0000      0.960 0.00 0.00 0.00 0.00 1.00
#&gt; SIH678     5  0.0000      0.960 0.00 0.00 0.00 0.00 1.00
#&gt; SIH679     1  0.2020      0.912 0.90 0.00 0.00 0.10 0.00
#&gt; SIH689     3  0.2280      0.871 0.00 0.12 0.88 0.00 0.00
#&gt; SIH694     2  0.0000      0.935 0.00 1.00 0.00 0.00 0.00
#&gt; SIH721     3  0.2331      0.862 0.08 0.02 0.90 0.00 0.00
</code></pre>

<script>
$('#tab-ATC-kmeans-get-classes-4-a').parent().next().next().hide();
$('#tab-ATC-kmeans-get-classes-4-a').click(function(){
  $('#tab-ATC-kmeans-get-classes-4-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-ATC-kmeans-get-classes-5'>
<p><a id='tab-ATC-kmeans-get-classes-5-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 6), get_membership(res, k = 6))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3   p4   p5   p6
#&gt; SIH013     3  0.2956     0.8841 0.04 0.00 0.84 0.00 0.00 0.12
#&gt; SIH014     3  0.0937     0.8989 0.00 0.00 0.96 0.00 0.00 0.04
#&gt; SIH024     3  0.0547     0.9153 0.00 0.00 0.98 0.00 0.00 0.02
#&gt; SIH028     6  0.5432     0.1588 0.00 0.12 0.40 0.00 0.00 0.48
#&gt; SIH031     1  0.1556     0.8196 0.92 0.00 0.00 0.00 0.00 0.08
#&gt; SIH042     1  0.2094     0.8172 0.90 0.00 0.02 0.00 0.00 0.08
#&gt; SIH107     2  0.0000     0.2026 0.00 1.00 0.00 0.00 0.00 0.00
#&gt; SIH114     1  0.5115     0.0629 0.46 0.00 0.00 0.00 0.46 0.08
#&gt; SIH116     1  0.4675     0.6246 0.66 0.00 0.02 0.04 0.00 0.28
#&gt; SIH117     3  0.0547     0.9153 0.00 0.00 0.98 0.00 0.00 0.02
#&gt; SIH130     2  0.4328     0.1435 0.00 0.52 0.02 0.00 0.00 0.46
#&gt; SIH134     2  0.4328     0.1435 0.00 0.52 0.02 0.00 0.00 0.46
#&gt; SIH186     2  0.0000     0.2026 0.00 1.00 0.00 0.00 0.00 0.00
#&gt; SIH191     5  0.0000     0.9965 0.00 0.00 0.00 0.00 1.00 0.00
#&gt; SIH192     4  0.1480     0.8892 0.00 0.02 0.04 0.94 0.00 0.00
#&gt; SIH196     2  0.4328     0.1435 0.00 0.52 0.02 0.00 0.00 0.46
#&gt; SIH214     6  0.4337    -0.3613 0.00 0.48 0.02 0.00 0.00 0.50
#&gt; SIH218     1  0.2350     0.8059 0.88 0.00 0.02 0.00 0.00 0.10
#&gt; SIH232     5  0.0000     0.9965 0.00 0.00 0.00 0.00 1.00 0.00
#&gt; SIH236     4  0.0000     0.9073 0.00 0.00 0.00 1.00 0.00 0.00
#&gt; SIH238     1  0.2581     0.7981 0.86 0.00 0.02 0.00 0.00 0.12
#&gt; SIH241     6  0.5432    -0.0224 0.00 0.40 0.12 0.00 0.00 0.48
#&gt; SIH245     2  0.4328     0.1435 0.00 0.52 0.02 0.00 0.00 0.46
#&gt; SIH260     4  0.4265     0.7192 0.04 0.00 0.00 0.66 0.00 0.30
#&gt; SIH287     2  0.2631     0.1668 0.00 0.82 0.00 0.00 0.00 0.18
#&gt; SIH289     4  0.2631     0.8436 0.00 0.00 0.00 0.82 0.00 0.18
#&gt; SIH290     2  0.4328     0.1435 0.00 0.52 0.02 0.00 0.00 0.46
#&gt; SIH295     5  0.0000     0.9965 0.00 0.00 0.00 0.00 1.00 0.00
#&gt; SIH366     1  0.1092     0.8279 0.96 0.00 0.00 0.02 0.00 0.02
#&gt; SIH377     5  0.0000     0.9965 0.00 0.00 0.00 0.00 1.00 0.00
#&gt; SIH380     2  0.4337     0.0848 0.00 0.50 0.02 0.00 0.00 0.48
#&gt; SIH385     3  0.0547     0.9153 0.00 0.00 0.98 0.00 0.00 0.02
#&gt; SIH389     2  0.3851     0.1425 0.00 0.54 0.00 0.00 0.00 0.46
#&gt; SIH391     4  0.0937     0.9045 0.00 0.00 0.00 0.96 0.00 0.04
#&gt; SIH403     1  0.1556     0.8196 0.92 0.00 0.00 0.00 0.00 0.08
#&gt; SIH411     2  0.4328     0.1435 0.00 0.52 0.02 0.00 0.00 0.46
#&gt; SIH427     5  0.0937     0.9602 0.00 0.00 0.00 0.00 0.96 0.04
#&gt; SIH433     3  0.0547     0.9153 0.00 0.00 0.98 0.00 0.00 0.02
#&gt; SIH439     4  0.0547     0.9043 0.00 0.00 0.02 0.98 0.00 0.00
#&gt; SIH442     5  0.0000     0.9965 0.00 0.00 0.00 0.00 1.00 0.00
#&gt; SIH444     3  0.3544     0.8696 0.08 0.00 0.80 0.00 0.00 0.12
#&gt; SIH452     2  0.5841    -0.4083 0.00 0.48 0.00 0.22 0.00 0.30
#&gt; SIH461     3  0.2956     0.8841 0.04 0.00 0.84 0.00 0.00 0.12
#&gt; SIH471     5  0.0000     0.9965 0.00 0.00 0.00 0.00 1.00 0.00
#&gt; SIH472     2  0.0000     0.2026 0.00 1.00 0.00 0.00 0.00 0.00
#&gt; SIH481     5  0.0000     0.9965 0.00 0.00 0.00 0.00 1.00 0.00
#&gt; SIH485     2  0.4337     0.0848 0.00 0.50 0.02 0.00 0.00 0.48
#&gt; SIH491     2  0.3851     0.0976 0.00 0.54 0.00 0.00 0.00 0.46
#&gt; SIH508     1  0.1807     0.8285 0.92 0.00 0.02 0.00 0.00 0.06
#&gt; SIH559     5  0.0000     0.9965 0.00 0.00 0.00 0.00 1.00 0.00
#&gt; SIH587     5  0.0000     0.9965 0.00 0.00 0.00 0.00 1.00 0.00
#&gt; SIH625     4  0.0547     0.9045 0.00 0.02 0.00 0.98 0.00 0.00
#&gt; SIH641     1  0.0547     0.8281 0.98 0.00 0.02 0.00 0.00 0.00
#&gt; SIH643     3  0.2956     0.8841 0.04 0.00 0.84 0.00 0.00 0.12
#&gt; SIH674     5  0.0000     0.9965 0.00 0.00 0.00 0.00 1.00 0.00
#&gt; SIH678     5  0.0000     0.9965 0.00 0.00 0.00 0.00 1.00 0.00
#&gt; SIH679     1  0.3976     0.7023 0.74 0.00 0.02 0.02 0.00 0.22
#&gt; SIH689     3  0.0547     0.9153 0.00 0.00 0.98 0.00 0.00 0.02
#&gt; SIH694     2  0.4337     0.0848 0.00 0.50 0.02 0.00 0.00 0.48
#&gt; SIH721     3  0.2094     0.8999 0.02 0.00 0.90 0.00 0.00 0.08
</code></pre>

<script>
$('#tab-ATC-kmeans-get-classes-5-a').parent().next().next().hide();
$('#tab-ATC-kmeans-get-classes-5-a').click(function(){
  $('#tab-ATC-kmeans-get-classes-5-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>
</div>

Heatmaps for the consensus matrix. It visualizes the probability of two
samples to be in a same group.




<script>
$( function() {
	$( '#tabs-ATC-kmeans-consensus-heatmap' ).tabs();
} );
</script>
<div id='tabs-ATC-kmeans-consensus-heatmap'>
<ul>
<li><a href='#tab-ATC-kmeans-consensus-heatmap-1'>k = 2</a></li>
<li><a href='#tab-ATC-kmeans-consensus-heatmap-2'>k = 3</a></li>
<li><a href='#tab-ATC-kmeans-consensus-heatmap-3'>k = 4</a></li>
<li><a href='#tab-ATC-kmeans-consensus-heatmap-4'>k = 5</a></li>
<li><a href='#tab-ATC-kmeans-consensus-heatmap-5'>k = 6</a></li>
</ul>
<div id='tab-ATC-kmeans-consensus-heatmap-1'>
<pre><code class="language-r">consensus_heatmap(res, k = 2)
</code></pre>
<p><img src="figure_cola/tab-ATC-kmeans-consensus-heatmap-1-1.png" alt="plot of chunk tab-ATC-kmeans-consensus-heatmap-1" /></p>

</div>
<div id='tab-ATC-kmeans-consensus-heatmap-2'>
<pre><code class="language-r">consensus_heatmap(res, k = 3)
</code></pre>
<p><img src="figure_cola/tab-ATC-kmeans-consensus-heatmap-2-1.png" alt="plot of chunk tab-ATC-kmeans-consensus-heatmap-2" /></p>

</div>
<div id='tab-ATC-kmeans-consensus-heatmap-3'>
<pre><code class="language-r">consensus_heatmap(res, k = 4)
</code></pre>
<p><img src="figure_cola/tab-ATC-kmeans-consensus-heatmap-3-1.png" alt="plot of chunk tab-ATC-kmeans-consensus-heatmap-3" /></p>

</div>
<div id='tab-ATC-kmeans-consensus-heatmap-4'>
<pre><code class="language-r">consensus_heatmap(res, k = 5)
</code></pre>
<p><img src="figure_cola/tab-ATC-kmeans-consensus-heatmap-4-1.png" alt="plot of chunk tab-ATC-kmeans-consensus-heatmap-4" /></p>

</div>
<div id='tab-ATC-kmeans-consensus-heatmap-5'>
<pre><code class="language-r">consensus_heatmap(res, k = 6)
</code></pre>
<p><img src="figure_cola/tab-ATC-kmeans-consensus-heatmap-5-1.png" alt="plot of chunk tab-ATC-kmeans-consensus-heatmap-5" /></p>

</div>
</div>

Heatmaps for the membership of samples in all partitions to see how consistent they are:





<script>
$( function() {
	$( '#tabs-ATC-kmeans-membership-heatmap' ).tabs();
} );
</script>
<div id='tabs-ATC-kmeans-membership-heatmap'>
<ul>
<li><a href='#tab-ATC-kmeans-membership-heatmap-1'>k = 2</a></li>
<li><a href='#tab-ATC-kmeans-membership-heatmap-2'>k = 3</a></li>
<li><a href='#tab-ATC-kmeans-membership-heatmap-3'>k = 4</a></li>
<li><a href='#tab-ATC-kmeans-membership-heatmap-4'>k = 5</a></li>
<li><a href='#tab-ATC-kmeans-membership-heatmap-5'>k = 6</a></li>
</ul>
<div id='tab-ATC-kmeans-membership-heatmap-1'>
<pre><code class="language-r">membership_heatmap(res, k = 2)
</code></pre>
<p><img src="figure_cola/tab-ATC-kmeans-membership-heatmap-1-1.png" alt="plot of chunk tab-ATC-kmeans-membership-heatmap-1" /></p>

</div>
<div id='tab-ATC-kmeans-membership-heatmap-2'>
<pre><code class="language-r">membership_heatmap(res, k = 3)
</code></pre>
<p><img src="figure_cola/tab-ATC-kmeans-membership-heatmap-2-1.png" alt="plot of chunk tab-ATC-kmeans-membership-heatmap-2" /></p>

</div>
<div id='tab-ATC-kmeans-membership-heatmap-3'>
<pre><code class="language-r">membership_heatmap(res, k = 4)
</code></pre>
<p><img src="figure_cola/tab-ATC-kmeans-membership-heatmap-3-1.png" alt="plot of chunk tab-ATC-kmeans-membership-heatmap-3" /></p>

</div>
<div id='tab-ATC-kmeans-membership-heatmap-4'>
<pre><code class="language-r">membership_heatmap(res, k = 5)
</code></pre>
<p><img src="figure_cola/tab-ATC-kmeans-membership-heatmap-4-1.png" alt="plot of chunk tab-ATC-kmeans-membership-heatmap-4" /></p>

</div>
<div id='tab-ATC-kmeans-membership-heatmap-5'>
<pre><code class="language-r">membership_heatmap(res, k = 6)
</code></pre>
<p><img src="figure_cola/tab-ATC-kmeans-membership-heatmap-5-1.png" alt="plot of chunk tab-ATC-kmeans-membership-heatmap-5" /></p>

</div>
</div>

As soon as the classes for columns are determined, the signatures
that are significantly different between subgroups can be looked for. 
Following are the heatmaps for signatures.




Signature heatmaps where rows are scaled:



<script>
$( function() {
	$( '#tabs-ATC-kmeans-get-signatures' ).tabs();
} );
</script>
<div id='tabs-ATC-kmeans-get-signatures'>
<ul>
<li><a href='#tab-ATC-kmeans-get-signatures-1'>k = 2</a></li>
<li><a href='#tab-ATC-kmeans-get-signatures-2'>k = 3</a></li>
<li><a href='#tab-ATC-kmeans-get-signatures-3'>k = 4</a></li>
<li><a href='#tab-ATC-kmeans-get-signatures-4'>k = 5</a></li>
<li><a href='#tab-ATC-kmeans-get-signatures-5'>k = 6</a></li>
</ul>
<div id='tab-ATC-kmeans-get-signatures-1'>
<pre><code class="language-r">get_signatures(res, k = 2)
</code></pre>
<p><img src="figure_cola/tab-ATC-kmeans-get-signatures-1-1.png" alt="plot of chunk tab-ATC-kmeans-get-signatures-1" /></p>

</div>
<div id='tab-ATC-kmeans-get-signatures-2'>
<pre><code class="language-r">get_signatures(res, k = 3)
</code></pre>
<p><img src="figure_cola/tab-ATC-kmeans-get-signatures-2-1.png" alt="plot of chunk tab-ATC-kmeans-get-signatures-2" /></p>

</div>
<div id='tab-ATC-kmeans-get-signatures-3'>
<pre><code class="language-r">get_signatures(res, k = 4)
</code></pre>
<p><img src="figure_cola/tab-ATC-kmeans-get-signatures-3-1.png" alt="plot of chunk tab-ATC-kmeans-get-signatures-3" /></p>

</div>
<div id='tab-ATC-kmeans-get-signatures-4'>
<pre><code class="language-r">get_signatures(res, k = 5)
</code></pre>
<p><img src="figure_cola/tab-ATC-kmeans-get-signatures-4-1.png" alt="plot of chunk tab-ATC-kmeans-get-signatures-4" /></p>

</div>
<div id='tab-ATC-kmeans-get-signatures-5'>
<pre><code class="language-r">get_signatures(res, k = 6)
</code></pre>
<p><img src="figure_cola/tab-ATC-kmeans-get-signatures-5-1.png" alt="plot of chunk tab-ATC-kmeans-get-signatures-5" /></p>

</div>
</div>



Signature heatmaps where rows are not scaled:


<script>
$( function() {
	$( '#tabs-ATC-kmeans-get-signatures-no-scale' ).tabs();
} );
</script>
<div id='tabs-ATC-kmeans-get-signatures-no-scale'>
<ul>
<li><a href='#tab-ATC-kmeans-get-signatures-no-scale-1'>k = 2</a></li>
<li><a href='#tab-ATC-kmeans-get-signatures-no-scale-2'>k = 3</a></li>
<li><a href='#tab-ATC-kmeans-get-signatures-no-scale-3'>k = 4</a></li>
<li><a href='#tab-ATC-kmeans-get-signatures-no-scale-4'>k = 5</a></li>
<li><a href='#tab-ATC-kmeans-get-signatures-no-scale-5'>k = 6</a></li>
</ul>
<div id='tab-ATC-kmeans-get-signatures-no-scale-1'>
<pre><code class="language-r">get_signatures(res, k = 2, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-ATC-kmeans-get-signatures-no-scale-1-1.png" alt="plot of chunk tab-ATC-kmeans-get-signatures-no-scale-1" /></p>

</div>
<div id='tab-ATC-kmeans-get-signatures-no-scale-2'>
<pre><code class="language-r">get_signatures(res, k = 3, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-ATC-kmeans-get-signatures-no-scale-2-1.png" alt="plot of chunk tab-ATC-kmeans-get-signatures-no-scale-2" /></p>

</div>
<div id='tab-ATC-kmeans-get-signatures-no-scale-3'>
<pre><code class="language-r">get_signatures(res, k = 4, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-ATC-kmeans-get-signatures-no-scale-3-1.png" alt="plot of chunk tab-ATC-kmeans-get-signatures-no-scale-3" /></p>

</div>
<div id='tab-ATC-kmeans-get-signatures-no-scale-4'>
<pre><code class="language-r">get_signatures(res, k = 5, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-ATC-kmeans-get-signatures-no-scale-4-1.png" alt="plot of chunk tab-ATC-kmeans-get-signatures-no-scale-4" /></p>

</div>
<div id='tab-ATC-kmeans-get-signatures-no-scale-5'>
<pre><code class="language-r">get_signatures(res, k = 6, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-ATC-kmeans-get-signatures-no-scale-5-1.png" alt="plot of chunk tab-ATC-kmeans-get-signatures-no-scale-5" /></p>

</div>
</div>



Compare the overlap of signatures from different k:

``` r
compare_signatures(res)
```

![plot of chunk ATC-kmeans-signature_compare](figure_cola/ATC-kmeans-signature_compare-1.png)

`get_signature()` returns a data frame invisibly. To get the list of signatures, the function
call should be assigned to a variable explicitly. In following code, if `plot` argument is set
to `FALSE`, no heatmap is plotted while only the differential analysis is performed.

``` r
# code only for demonstration
tb = get_signature(res, k = ..., plot = FALSE)
```

An example of the output of `tb` is:

```
#>   which_row         fdr    mean_1    mean_2 scaled_mean_1 scaled_mean_2 km
#> 1        38 0.042760348  8.373488  9.131774    -0.5533452     0.5164555  1
#> 2        40 0.018707592  7.106213  8.469186    -0.6173731     0.5762149  1
#> 3        55 0.019134737 10.221463 11.207825    -0.6159697     0.5749050  1
#> 4        59 0.006059896  5.921854  7.869574    -0.6899429     0.6439467  1
#> 5        60 0.018055526  8.928898 10.211722    -0.6204761     0.5791110  1
#> 6        98 0.009384629 15.714769 14.887706     0.6635654    -0.6193277  2
...
```

The columns in `tb` are:

1. `which_row`: row indices corresponding to the input matrix.
2. `fdr`: FDR for the differential test. 
3. `mean_x`: The mean value in group x.
4. `scaled_mean_x`: The mean value in group x after rows are scaled.
5. `km`: Row groups if k-means clustering is applied to rows (which is done by automatically selecting number of clusters).

If there are too many signatures, `top_signatures = ...` can be set to only show the 
signatures with the highest FDRs:

``` r
# code only for demonstration
# e.g. to show the top 500 most significant rows
tb = get_signature(res, k = ..., top_signatures = 500)
```

If the signatures are defined as these which are uniquely high in current group, `diff_method` argument
can be set to `"uniquely_high_in_one_group"`:

``` r
# code only for demonstration
tb = get_signature(res, k = ..., diff_method = "uniquely_high_in_one_group")
```




UMAP plot which shows how samples are separated.


<script>
$( function() {
	$( '#tabs-ATC-kmeans-dimension-reduction' ).tabs();
} );
</script>
<div id='tabs-ATC-kmeans-dimension-reduction'>
<ul>
<li><a href='#tab-ATC-kmeans-dimension-reduction-1'>k = 2</a></li>
<li><a href='#tab-ATC-kmeans-dimension-reduction-2'>k = 3</a></li>
<li><a href='#tab-ATC-kmeans-dimension-reduction-3'>k = 4</a></li>
<li><a href='#tab-ATC-kmeans-dimension-reduction-4'>k = 5</a></li>
<li><a href='#tab-ATC-kmeans-dimension-reduction-5'>k = 6</a></li>
</ul>
<div id='tab-ATC-kmeans-dimension-reduction-1'>
<pre><code class="language-r">dimension_reduction(res, k = 2, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-ATC-kmeans-dimension-reduction-1-1.png" alt="plot of chunk tab-ATC-kmeans-dimension-reduction-1" /></p>

</div>
<div id='tab-ATC-kmeans-dimension-reduction-2'>
<pre><code class="language-r">dimension_reduction(res, k = 3, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-ATC-kmeans-dimension-reduction-2-1.png" alt="plot of chunk tab-ATC-kmeans-dimension-reduction-2" /></p>

</div>
<div id='tab-ATC-kmeans-dimension-reduction-3'>
<pre><code class="language-r">dimension_reduction(res, k = 4, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-ATC-kmeans-dimension-reduction-3-1.png" alt="plot of chunk tab-ATC-kmeans-dimension-reduction-3" /></p>

</div>
<div id='tab-ATC-kmeans-dimension-reduction-4'>
<pre><code class="language-r">dimension_reduction(res, k = 5, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-ATC-kmeans-dimension-reduction-4-1.png" alt="plot of chunk tab-ATC-kmeans-dimension-reduction-4" /></p>

</div>
<div id='tab-ATC-kmeans-dimension-reduction-5'>
<pre><code class="language-r">dimension_reduction(res, k = 6, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-ATC-kmeans-dimension-reduction-5-1.png" alt="plot of chunk tab-ATC-kmeans-dimension-reduction-5" /></p>

</div>
</div>



Following heatmap shows how subgroups are split when increasing `k`:

``` r
collect_classes(res)
```

![plot of chunk ATC-kmeans-collect-classes](figure_cola/ATC-kmeans-collect-classes-1.png)



If matrix rows can be associated to genes, consider to use `functional_enrichment(res,
...)` to perform function enrichment for the signature genes. See [this vignette](https://jokergoo.github.io/cola_vignettes/functional_enrichment.html) for more detailed explanations.


 

---------------------------------------------------



### ATC:pam*






The object with results only for a single top-value method and a single partitioning method 
can be extracted as:

``` r
res = res_list["ATC", "pam"]
# you can also extract it by
# res = res_list["ATC:pam"]
```

A summary of `res` and all the functions that can be applied to it:

``` r
res
```

```
#> A 'ConsensusPartition' object with k = 2, 3, 4, 5, 6.
#>   On a matrix with 1900 rows and 60 columns.
#>   Top rows (190) are extracted by 'ATC' method.
#>   Subgroups are detected by 'pam' method.
#>   Performed in total 250 partitions by row resampling.
#>   Best k for subgroups seems to be 3.
#> 
#> Following methods can be applied to this 'ConsensusPartition' object:
#>  [1] "cola_report"             "collect_classes"         "collect_plots"          
#>  [4] "collect_stats"           "colnames"                "compare_partitions"     
#>  [7] "compare_signatures"      "consensus_heatmap"       "dimension_reduction"    
#> [10] "functional_enrichment"   "get_anno_col"            "get_anno"               
#> [13] "get_classes"             "get_consensus"           "get_matrix"             
#> [16] "get_membership"          "get_param"               "get_signatures"         
#> [19] "get_stats"               "is_best_k"               "is_stable_k"            
#> [22] "membership_heatmap"      "ncol"                    "nrow"                   
#> [25] "plot_ecdf"               "predict_classes"         "rownames"               
#> [28] "select_partition_number" "show"                    "suggest_best_k"         
#> [31] "test_to_known_factors"   "top_rows_heatmap"
```

`collect_plots()` function collects all the plots made from `res` for all `k` (number of subgroups)
into one single page to provide an easy and fast comparison between different `k`.

``` r
collect_plots(res)
```

![plot of chunk ATC-pam-collect-plots](figure_cola/ATC-pam-collect-plots-1.png)

The plots are:

- The first row: a plot of the eCDF (empirical cumulative distribution
  function) curves of the consensus matrix for each `k` and the heatmap of
  predicted classes for each `k`.
- The second row: heatmaps of the consensus matrix for each `k`.
- The third row: heatmaps of the membership matrix for each `k`.
- The fouth row: heatmaps of the signatures for each `k`.

All the plots in panels can be made by individual functions and they are
plotted later in this section.

`select_partition_number()` produces several plots showing different
statistics for choosing "optimized" `k`. There are following statistics:

- eCDF curves of the consensus matrix for each `k`;
- 1-PAC. [The PAC score](https://en.wikipedia.org/wiki/Consensus_clustering#Over-interpretation_potential_of_consensus_clustering)
  measures the proportion of the ambiguous subgrouping.
- Mean silhouette score.
- Concordance. The mean probability of fiting the consensus subgroup labels in all
  partitions.
- Area increased. Denote $A_k$ as the area under the eCDF curve for current
  `k`, the area increased is defined as $A_k - A_{k-1}$.
- Rand index. The percent of pairs of samples that are both in a same cluster
  or both are not in a same cluster in the partition of k and k-1.
- Jaccard index. The ratio of pairs of samples are both in a same cluster in
  the partition of k and k-1 and the pairs of samples are both in a same
  cluster in the partition k or k-1.

The detailed explanations of these statistics can be found in [the _cola_
vignette](https://jokergoo.github.io/cola_vignettes/cola.html#toc_13).

Generally speaking, higher 1-PAC score, higher mean silhouette score or higher
concordance corresponds to better partition. Rand index and Jaccard index
measure how similar the current partition is compared to partition with `k-1`.
If they are too similar, we won't accept `k` is better than `k-1`.

``` r
select_partition_number(res)
```

![plot of chunk ATC-pam-select-partition-number](figure_cola/ATC-pam-select-partition-number-1.png)

The numeric values for all these statistics can be obtained by `get_stats()`.

``` r
get_stats(res)
```

```
#>   k 1-PAC mean_silhouette concordance area_increased  Rand Jaccard
#> 2 2 0.930           0.945       0.978         0.4477 0.560   0.560
#> 3 3 0.902           0.952       0.978         0.4644 0.651   0.444
#> 4 4 0.801           0.843       0.909         0.1199 0.927   0.790
#> 5 5 0.863           0.901       0.940         0.0740 0.906   0.676
#> 6 6 0.817           0.761       0.873         0.0336 0.977   0.892
```

`suggest_best_k()` suggests the best $k$ based on these statistics. The rules are as follows:

- All $k$ with Jaccard index larger than 0.95 are removed because increasing
  $k$ does not provide enough extra information. If all $k$ are removed, it is
  marked as no subgroup is detected.
- For all $k$ with 1-PAC score larger than 0.9, the maximal $k$ is taken as
  the best $k$, and other $k$ are marked as optional $k$.
- If it does not fit the second rule. The $k$ with the maximal vote of the
  highest 1-PAC score, highest mean silhouette, and highest concordance is
  taken as the best $k$.

``` r
suggest_best_k(res)
```

```
#> [1] 3
#> attr(,"optional")
#> [1] 2
```

There is also optional best $k$ = 2 that is worth to check.

Following is the table of the partitions (You need to click the **show/hide
code output** link to see it). The membership matrix (columns with name `p*`)
is inferred by
[`clue::cl_consensus()`](https://www.rdocumentation.org/link/cl_consensus?package=clue)
function with the `SE` method. Basically the value in the membership matrix
represents the probability to belong to a certain group. The finall subgroup
label for an item is determined with the group with highest probability it
belongs to.

In `get_classes()` function, the entropy is calculated from the membership
matrix and the silhouette score is calculated from the consensus matrix.



<script>
$( function() {
	$( '#tabs-ATC-pam-get-classes' ).tabs();
} );
</script>
<div id='tabs-ATC-pam-get-classes'>
<ul>
<li><a href='#tab-ATC-pam-get-classes-1'>k = 2</a></li>
<li><a href='#tab-ATC-pam-get-classes-2'>k = 3</a></li>
<li><a href='#tab-ATC-pam-get-classes-3'>k = 4</a></li>
<li><a href='#tab-ATC-pam-get-classes-4'>k = 5</a></li>
<li><a href='#tab-ATC-pam-get-classes-5'>k = 6</a></li>
</ul>

<div id='tab-ATC-pam-get-classes-1'>
<p><a id='tab-ATC-pam-get-classes-1-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 2), get_membership(res, k = 2))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2
#&gt; SIH013     2   0.000      0.974 0.00 1.00
#&gt; SIH014     2   0.000      0.974 0.00 1.00
#&gt; SIH024     2   0.000      0.974 0.00 1.00
#&gt; SIH028     2   0.000      0.974 0.00 1.00
#&gt; SIH031     1   0.000      0.981 1.00 0.00
#&gt; SIH042     2   0.904      0.534 0.32 0.68
#&gt; SIH107     2   0.000      0.974 0.00 1.00
#&gt; SIH114     1   0.000      0.981 1.00 0.00
#&gt; SIH116     2   0.827      0.644 0.26 0.74
#&gt; SIH117     2   0.000      0.974 0.00 1.00
#&gt; SIH130     2   0.000      0.974 0.00 1.00
#&gt; SIH134     2   0.000      0.974 0.00 1.00
#&gt; SIH186     2   0.000      0.974 0.00 1.00
#&gt; SIH191     1   0.000      0.981 1.00 0.00
#&gt; SIH192     2   0.000      0.974 0.00 1.00
#&gt; SIH196     2   0.000      0.974 0.00 1.00
#&gt; SIH214     2   0.000      0.974 0.00 1.00
#&gt; SIH218     2   0.000      0.974 0.00 1.00
#&gt; SIH232     1   0.000      0.981 1.00 0.00
#&gt; SIH236     2   0.000      0.974 0.00 1.00
#&gt; SIH238     2   0.990      0.217 0.44 0.56
#&gt; SIH241     2   0.000      0.974 0.00 1.00
#&gt; SIH245     2   0.000      0.974 0.00 1.00
#&gt; SIH260     2   0.000      0.974 0.00 1.00
#&gt; SIH287     2   0.000      0.974 0.00 1.00
#&gt; SIH289     2   0.000      0.974 0.00 1.00
#&gt; SIH290     2   0.000      0.974 0.00 1.00
#&gt; SIH295     1   0.000      0.981 1.00 0.00
#&gt; SIH366     1   0.000      0.981 1.00 0.00
#&gt; SIH377     1   0.000      0.981 1.00 0.00
#&gt; SIH380     2   0.000      0.974 0.00 1.00
#&gt; SIH385     2   0.000      0.974 0.00 1.00
#&gt; SIH389     2   0.000      0.974 0.00 1.00
#&gt; SIH391     2   0.000      0.974 0.00 1.00
#&gt; SIH403     1   0.000      0.981 1.00 0.00
#&gt; SIH411     2   0.000      0.974 0.00 1.00
#&gt; SIH427     1   0.000      0.981 1.00 0.00
#&gt; SIH433     2   0.000      0.974 0.00 1.00
#&gt; SIH439     2   0.000      0.974 0.00 1.00
#&gt; SIH442     1   0.000      0.981 1.00 0.00
#&gt; SIH444     2   0.000      0.974 0.00 1.00
#&gt; SIH452     2   0.000      0.974 0.00 1.00
#&gt; SIH461     2   0.000      0.974 0.00 1.00
#&gt; SIH471     1   0.000      0.981 1.00 0.00
#&gt; SIH472     2   0.000      0.974 0.00 1.00
#&gt; SIH481     1   0.000      0.981 1.00 0.00
#&gt; SIH485     2   0.000      0.974 0.00 1.00
#&gt; SIH491     2   0.000      0.974 0.00 1.00
#&gt; SIH508     1   0.000      0.981 1.00 0.00
#&gt; SIH559     1   0.000      0.981 1.00 0.00
#&gt; SIH587     1   0.000      0.981 1.00 0.00
#&gt; SIH625     2   0.000      0.974 0.00 1.00
#&gt; SIH641     1   0.469      0.882 0.90 0.10
#&gt; SIH643     2   0.000      0.974 0.00 1.00
#&gt; SIH674     1   0.000      0.981 1.00 0.00
#&gt; SIH678     1   0.000      0.981 1.00 0.00
#&gt; SIH679     1   0.760      0.713 0.78 0.22
#&gt; SIH689     2   0.000      0.974 0.00 1.00
#&gt; SIH694     2   0.000      0.974 0.00 1.00
#&gt; SIH721     2   0.000      0.974 0.00 1.00
</code></pre>

<script>
$('#tab-ATC-pam-get-classes-1-a').parent().next().next().hide();
$('#tab-ATC-pam-get-classes-1-a').click(function(){
  $('#tab-ATC-pam-get-classes-1-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-ATC-pam-get-classes-2'>
<p><a id='tab-ATC-pam-get-classes-2-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 3), get_membership(res, k = 3))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3
#&gt; SIH013     3   0.000      0.963 0.00 0.00 1.00
#&gt; SIH014     2   0.429      0.792 0.00 0.82 0.18
#&gt; SIH024     3   0.000      0.963 0.00 0.00 1.00
#&gt; SIH028     2   0.334      0.862 0.00 0.88 0.12
#&gt; SIH031     3   0.400      0.809 0.16 0.00 0.84
#&gt; SIH042     3   0.000      0.963 0.00 0.00 1.00
#&gt; SIH107     2   0.000      0.974 0.00 1.00 0.00
#&gt; SIH114     1   0.000      1.000 1.00 0.00 0.00
#&gt; SIH116     3   0.000      0.963 0.00 0.00 1.00
#&gt; SIH117     3   0.000      0.963 0.00 0.00 1.00
#&gt; SIH130     2   0.000      0.974 0.00 1.00 0.00
#&gt; SIH134     2   0.000      0.974 0.00 1.00 0.00
#&gt; SIH186     2   0.000      0.974 0.00 1.00 0.00
#&gt; SIH191     1   0.000      1.000 1.00 0.00 0.00
#&gt; SIH192     3   0.571      0.539 0.00 0.32 0.68
#&gt; SIH196     2   0.000      0.974 0.00 1.00 0.00
#&gt; SIH214     2   0.000      0.974 0.00 1.00 0.00
#&gt; SIH218     3   0.000      0.963 0.00 0.00 1.00
#&gt; SIH232     1   0.000      1.000 1.00 0.00 0.00
#&gt; SIH236     3   0.000      0.963 0.00 0.00 1.00
#&gt; SIH238     3   0.000      0.963 0.00 0.00 1.00
#&gt; SIH241     2   0.000      0.974 0.00 1.00 0.00
#&gt; SIH245     2   0.000      0.974 0.00 1.00 0.00
#&gt; SIH260     3   0.000      0.963 0.00 0.00 1.00
#&gt; SIH287     2   0.000      0.974 0.00 1.00 0.00
#&gt; SIH289     3   0.000      0.963 0.00 0.00 1.00
#&gt; SIH290     2   0.000      0.974 0.00 1.00 0.00
#&gt; SIH295     1   0.000      1.000 1.00 0.00 0.00
#&gt; SIH366     3   0.296      0.882 0.10 0.00 0.90
#&gt; SIH377     1   0.000      1.000 1.00 0.00 0.00
#&gt; SIH380     2   0.000      0.974 0.00 1.00 0.00
#&gt; SIH385     2   0.400      0.813 0.00 0.84 0.16
#&gt; SIH389     2   0.000      0.974 0.00 1.00 0.00
#&gt; SIH391     3   0.000      0.963 0.00 0.00 1.00
#&gt; SIH403     3   0.153      0.935 0.04 0.00 0.96
#&gt; SIH411     2   0.000      0.974 0.00 1.00 0.00
#&gt; SIH427     1   0.000      1.000 1.00 0.00 0.00
#&gt; SIH433     3   0.000      0.963 0.00 0.00 1.00
#&gt; SIH439     3   0.000      0.963 0.00 0.00 1.00
#&gt; SIH442     1   0.000      1.000 1.00 0.00 0.00
#&gt; SIH444     3   0.000      0.963 0.00 0.00 1.00
#&gt; SIH452     2   0.000      0.974 0.00 1.00 0.00
#&gt; SIH461     3   0.000      0.963 0.00 0.00 1.00
#&gt; SIH471     1   0.000      1.000 1.00 0.00 0.00
#&gt; SIH472     2   0.000      0.974 0.00 1.00 0.00
#&gt; SIH481     1   0.000      1.000 1.00 0.00 0.00
#&gt; SIH485     2   0.000      0.974 0.00 1.00 0.00
#&gt; SIH491     2   0.000      0.974 0.00 1.00 0.00
#&gt; SIH508     3   0.000      0.963 0.00 0.00 1.00
#&gt; SIH559     1   0.000      1.000 1.00 0.00 0.00
#&gt; SIH587     1   0.000      1.000 1.00 0.00 0.00
#&gt; SIH625     3   0.429      0.785 0.00 0.18 0.82
#&gt; SIH641     3   0.000      0.963 0.00 0.00 1.00
#&gt; SIH643     3   0.000      0.963 0.00 0.00 1.00
#&gt; SIH674     1   0.000      1.000 1.00 0.00 0.00
#&gt; SIH678     1   0.000      1.000 1.00 0.00 0.00
#&gt; SIH679     3   0.000      0.963 0.00 0.00 1.00
#&gt; SIH689     3   0.254      0.900 0.00 0.08 0.92
#&gt; SIH694     2   0.000      0.974 0.00 1.00 0.00
#&gt; SIH721     3   0.000      0.963 0.00 0.00 1.00
</code></pre>

<script>
$('#tab-ATC-pam-get-classes-2-a').parent().next().next().hide();
$('#tab-ATC-pam-get-classes-2-a').click(function(){
  $('#tab-ATC-pam-get-classes-2-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-ATC-pam-get-classes-3'>
<p><a id='tab-ATC-pam-get-classes-3-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 4), get_membership(res, k = 4))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3   p4
#&gt; SIH013     3  0.0000      0.769 0.00 0.00 1.00 0.00
#&gt; SIH014     2  0.6921      0.433 0.00 0.58 0.16 0.26
#&gt; SIH024     3  0.4134      0.762 0.00 0.00 0.74 0.26
#&gt; SIH028     2  0.4491      0.744 0.00 0.80 0.14 0.06
#&gt; SIH031     3  0.3853      0.683 0.16 0.00 0.82 0.02
#&gt; SIH042     3  0.0707      0.760 0.00 0.00 0.98 0.02
#&gt; SIH107     2  0.0000      0.934 0.00 1.00 0.00 0.00
#&gt; SIH114     1  0.0000      1.000 1.00 0.00 0.00 0.00
#&gt; SIH116     4  0.4134      0.899 0.00 0.00 0.26 0.74
#&gt; SIH117     3  0.4134      0.762 0.00 0.00 0.74 0.26
#&gt; SIH130     2  0.0000      0.934 0.00 1.00 0.00 0.00
#&gt; SIH134     2  0.0000      0.934 0.00 1.00 0.00 0.00
#&gt; SIH186     2  0.0000      0.934 0.00 1.00 0.00 0.00
#&gt; SIH191     1  0.0000      1.000 1.00 0.00 0.00 0.00
#&gt; SIH192     3  0.7382      0.527 0.00 0.22 0.52 0.26
#&gt; SIH196     2  0.0000      0.934 0.00 1.00 0.00 0.00
#&gt; SIH214     2  0.0000      0.934 0.00 1.00 0.00 0.00
#&gt; SIH218     3  0.0707      0.760 0.00 0.00 0.98 0.02
#&gt; SIH232     1  0.0000      1.000 1.00 0.00 0.00 0.00
#&gt; SIH236     3  0.4522      0.745 0.00 0.00 0.68 0.32
#&gt; SIH238     3  0.0707      0.760 0.00 0.00 0.98 0.02
#&gt; SIH241     2  0.2706      0.852 0.00 0.90 0.02 0.08
#&gt; SIH245     2  0.0000      0.934 0.00 1.00 0.00 0.00
#&gt; SIH260     4  0.4406      0.857 0.00 0.00 0.30 0.70
#&gt; SIH287     2  0.0000      0.934 0.00 1.00 0.00 0.00
#&gt; SIH289     4  0.4134      0.899 0.00 0.00 0.26 0.74
#&gt; SIH290     2  0.0000      0.934 0.00 1.00 0.00 0.00
#&gt; SIH295     1  0.0000      1.000 1.00 0.00 0.00 0.00
#&gt; SIH366     4  0.4642      0.886 0.02 0.00 0.24 0.74
#&gt; SIH377     1  0.0000      1.000 1.00 0.00 0.00 0.00
#&gt; SIH380     2  0.0000      0.934 0.00 1.00 0.00 0.00
#&gt; SIH385     2  0.6723      0.474 0.00 0.60 0.14 0.26
#&gt; SIH389     2  0.0000      0.934 0.00 1.00 0.00 0.00
#&gt; SIH391     3  0.3172      0.783 0.00 0.00 0.84 0.16
#&gt; SIH403     3  0.1913      0.743 0.04 0.00 0.94 0.02
#&gt; SIH411     2  0.0000      0.934 0.00 1.00 0.00 0.00
#&gt; SIH427     1  0.0000      1.000 1.00 0.00 0.00 0.00
#&gt; SIH433     3  0.4134      0.762 0.00 0.00 0.74 0.26
#&gt; SIH439     3  0.4277      0.764 0.00 0.00 0.72 0.28
#&gt; SIH442     1  0.0000      1.000 1.00 0.00 0.00 0.00
#&gt; SIH444     3  0.4134      0.762 0.00 0.00 0.74 0.26
#&gt; SIH452     4  0.4797      0.573 0.00 0.26 0.02 0.72
#&gt; SIH461     3  0.0000      0.769 0.00 0.00 1.00 0.00
#&gt; SIH471     1  0.0000      1.000 1.00 0.00 0.00 0.00
#&gt; SIH472     2  0.0000      0.934 0.00 1.00 0.00 0.00
#&gt; SIH481     1  0.0000      1.000 1.00 0.00 0.00 0.00
#&gt; SIH485     2  0.0000      0.934 0.00 1.00 0.00 0.00
#&gt; SIH491     2  0.0000      0.934 0.00 1.00 0.00 0.00
#&gt; SIH508     3  0.1211      0.752 0.04 0.00 0.96 0.00
#&gt; SIH559     1  0.0000      1.000 1.00 0.00 0.00 0.00
#&gt; SIH587     1  0.0000      1.000 1.00 0.00 0.00 0.00
#&gt; SIH625     3  0.6843      0.471 0.00 0.10 0.46 0.44
#&gt; SIH641     3  0.3400      0.548 0.00 0.00 0.82 0.18
#&gt; SIH643     3  0.0000      0.769 0.00 0.00 1.00 0.00
#&gt; SIH674     1  0.0000      1.000 1.00 0.00 0.00 0.00
#&gt; SIH678     1  0.0000      1.000 1.00 0.00 0.00 0.00
#&gt; SIH679     4  0.4134      0.899 0.00 0.00 0.26 0.74
#&gt; SIH689     3  0.5962      0.708 0.00 0.08 0.66 0.26
#&gt; SIH694     2  0.0000      0.934 0.00 1.00 0.00 0.00
#&gt; SIH721     3  0.1637      0.782 0.00 0.00 0.94 0.06
</code></pre>

<script>
$('#tab-ATC-pam-get-classes-3-a').parent().next().next().hide();
$('#tab-ATC-pam-get-classes-3-a').click(function(){
  $('#tab-ATC-pam-get-classes-3-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-ATC-pam-get-classes-4'>
<p><a id='tab-ATC-pam-get-classes-4-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 5), get_membership(res, k = 5))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3   p4   p5
#&gt; SIH013     1  0.1410      0.907 0.94 0.00 0.06 0.00 0.00
#&gt; SIH014     3  0.3424      0.661 0.00 0.24 0.76 0.00 0.00
#&gt; SIH024     3  0.3109      0.800 0.20 0.00 0.80 0.00 0.00
#&gt; SIH028     2  0.4725      0.643 0.08 0.72 0.20 0.00 0.00
#&gt; SIH031     1  0.3106      0.767 0.84 0.00 0.00 0.02 0.14
#&gt; SIH042     1  0.0609      0.921 0.98 0.00 0.02 0.00 0.00
#&gt; SIH107     2  0.0000      0.969 0.00 1.00 0.00 0.00 0.00
#&gt; SIH114     5  0.2012      0.935 0.06 0.00 0.00 0.02 0.92
#&gt; SIH116     4  0.0609      0.951 0.02 0.00 0.00 0.98 0.00
#&gt; SIH117     3  0.2732      0.826 0.16 0.00 0.84 0.00 0.00
#&gt; SIH130     2  0.0000      0.969 0.00 1.00 0.00 0.00 0.00
#&gt; SIH134     2  0.0000      0.969 0.00 1.00 0.00 0.00 0.00
#&gt; SIH186     2  0.0000      0.969 0.00 1.00 0.00 0.00 0.00
#&gt; SIH191     5  0.1216      0.970 0.02 0.00 0.00 0.02 0.96
#&gt; SIH192     3  0.0000      0.803 0.00 0.00 1.00 0.00 0.00
#&gt; SIH196     2  0.0000      0.969 0.00 1.00 0.00 0.00 0.00
#&gt; SIH214     2  0.0000      0.969 0.00 1.00 0.00 0.00 0.00
#&gt; SIH218     1  0.0609      0.921 0.98 0.00 0.02 0.00 0.00
#&gt; SIH232     5  0.0000      0.981 0.00 0.00 0.00 0.00 1.00
#&gt; SIH236     3  0.2516      0.779 0.14 0.00 0.86 0.00 0.00
#&gt; SIH238     1  0.0609      0.921 0.98 0.00 0.02 0.00 0.00
#&gt; SIH241     2  0.3274      0.706 0.00 0.78 0.22 0.00 0.00
#&gt; SIH245     2  0.0000      0.969 0.00 1.00 0.00 0.00 0.00
#&gt; SIH260     4  0.2873      0.857 0.12 0.00 0.02 0.86 0.00
#&gt; SIH287     2  0.0000      0.969 0.00 1.00 0.00 0.00 0.00
#&gt; SIH289     4  0.0609      0.951 0.02 0.00 0.00 0.98 0.00
#&gt; SIH290     2  0.0000      0.969 0.00 1.00 0.00 0.00 0.00
#&gt; SIH295     5  0.0000      0.981 0.00 0.00 0.00 0.00 1.00
#&gt; SIH366     4  0.1732      0.901 0.08 0.00 0.00 0.92 0.00
#&gt; SIH377     5  0.1216      0.970 0.02 0.00 0.00 0.02 0.96
#&gt; SIH380     2  0.0000      0.969 0.00 1.00 0.00 0.00 0.00
#&gt; SIH385     3  0.3319      0.745 0.02 0.16 0.82 0.00 0.00
#&gt; SIH389     2  0.0000      0.969 0.00 1.00 0.00 0.00 0.00
#&gt; SIH391     3  0.3274      0.695 0.22 0.00 0.78 0.00 0.00
#&gt; SIH403     1  0.1216      0.896 0.96 0.00 0.00 0.02 0.02
#&gt; SIH411     2  0.0000      0.969 0.00 1.00 0.00 0.00 0.00
#&gt; SIH427     5  0.1216      0.970 0.02 0.00 0.00 0.02 0.96
#&gt; SIH433     3  0.2732      0.826 0.16 0.00 0.84 0.00 0.00
#&gt; SIH439     3  0.2020      0.804 0.10 0.00 0.90 0.00 0.00
#&gt; SIH442     5  0.0000      0.981 0.00 0.00 0.00 0.00 1.00
#&gt; SIH444     3  0.3561      0.749 0.26 0.00 0.74 0.00 0.00
#&gt; SIH452     4  0.0609      0.937 0.00 0.02 0.00 0.98 0.00
#&gt; SIH461     1  0.1043      0.917 0.96 0.00 0.04 0.00 0.00
#&gt; SIH471     5  0.0000      0.981 0.00 0.00 0.00 0.00 1.00
#&gt; SIH472     2  0.0000      0.969 0.00 1.00 0.00 0.00 0.00
#&gt; SIH481     5  0.1216      0.970 0.02 0.00 0.00 0.02 0.96
#&gt; SIH485     2  0.0000      0.969 0.00 1.00 0.00 0.00 0.00
#&gt; SIH491     2  0.0000      0.969 0.00 1.00 0.00 0.00 0.00
#&gt; SIH508     1  0.0609      0.905 0.98 0.00 0.00 0.02 0.00
#&gt; SIH559     5  0.0000      0.981 0.00 0.00 0.00 0.00 1.00
#&gt; SIH587     5  0.0000      0.981 0.00 0.00 0.00 0.00 1.00
#&gt; SIH625     3  0.0609      0.809 0.02 0.00 0.98 0.00 0.00
#&gt; SIH641     1  0.3109      0.705 0.80 0.00 0.00 0.20 0.00
#&gt; SIH643     1  0.1410      0.907 0.94 0.00 0.06 0.00 0.00
#&gt; SIH674     5  0.0000      0.981 0.00 0.00 0.00 0.00 1.00
#&gt; SIH678     5  0.0000      0.981 0.00 0.00 0.00 0.00 1.00
#&gt; SIH679     4  0.0609      0.951 0.02 0.00 0.00 0.98 0.00
#&gt; SIH689     3  0.2732      0.826 0.16 0.00 0.84 0.00 0.00
#&gt; SIH694     2  0.0000      0.969 0.00 1.00 0.00 0.00 0.00
#&gt; SIH721     1  0.1732      0.890 0.92 0.00 0.08 0.00 0.00
</code></pre>

<script>
$('#tab-ATC-pam-get-classes-4-a').parent().next().next().hide();
$('#tab-ATC-pam-get-classes-4-a').click(function(){
  $('#tab-ATC-pam-get-classes-4-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-ATC-pam-get-classes-5'>
<p><a id='tab-ATC-pam-get-classes-5-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 6), get_membership(res, k = 6))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3   p4   p5   p6
#&gt; SIH013     6  0.0000     0.8686 0.00 0.00 0.00 0.00 0.00 1.00
#&gt; SIH014     3  0.2454     0.6829 0.00 0.16 0.84 0.00 0.00 0.00
#&gt; SIH024     3  0.2260     0.7796 0.00 0.00 0.86 0.00 0.00 0.14
#&gt; SIH028     2  0.5012     0.4294 0.00 0.60 0.30 0.00 0.00 0.10
#&gt; SIH031     1  0.4348     0.4627 0.64 0.00 0.00 0.00 0.04 0.32
#&gt; SIH042     6  0.1267     0.8240 0.06 0.00 0.00 0.00 0.00 0.94
#&gt; SIH107     2  0.1267     0.9209 0.06 0.94 0.00 0.00 0.00 0.00
#&gt; SIH114     1  0.3706     0.0184 0.62 0.00 0.00 0.00 0.38 0.00
#&gt; SIH116     4  0.0000     0.9038 0.00 0.00 0.00 1.00 0.00 0.00
#&gt; SIH117     3  0.2260     0.7843 0.00 0.00 0.86 0.00 0.00 0.14
#&gt; SIH130     2  0.0000     0.9425 0.00 1.00 0.00 0.00 0.00 0.00
#&gt; SIH134     2  0.0000     0.9425 0.00 1.00 0.00 0.00 0.00 0.00
#&gt; SIH186     2  0.1267     0.9209 0.06 0.94 0.00 0.00 0.00 0.00
#&gt; SIH191     5  0.2941     0.7310 0.22 0.00 0.00 0.00 0.78 0.00
#&gt; SIH192     3  0.2631     0.7436 0.18 0.00 0.82 0.00 0.00 0.00
#&gt; SIH196     2  0.0000     0.9425 0.00 1.00 0.00 0.00 0.00 0.00
#&gt; SIH214     2  0.0000     0.9425 0.00 1.00 0.00 0.00 0.00 0.00
#&gt; SIH218     6  0.0000     0.8686 0.00 0.00 0.00 0.00 0.00 1.00
#&gt; SIH232     5  0.0000     0.8588 0.00 0.00 0.00 0.00 1.00 0.00
#&gt; SIH236     3  0.4929     0.6566 0.28 0.00 0.62 0.00 0.00 0.10
#&gt; SIH238     6  0.0000     0.8686 0.00 0.00 0.00 0.00 0.00 1.00
#&gt; SIH241     2  0.3409     0.5882 0.00 0.70 0.30 0.00 0.00 0.00
#&gt; SIH245     2  0.0000     0.9425 0.00 1.00 0.00 0.00 0.00 0.00
#&gt; SIH260     4  0.2260     0.7897 0.00 0.00 0.00 0.86 0.00 0.14
#&gt; SIH287     2  0.1267     0.9209 0.06 0.94 0.00 0.00 0.00 0.00
#&gt; SIH289     4  0.2048     0.8505 0.12 0.00 0.00 0.88 0.00 0.00
#&gt; SIH290     2  0.0000     0.9425 0.00 1.00 0.00 0.00 0.00 0.00
#&gt; SIH295     5  0.0000     0.8588 0.00 0.00 0.00 0.00 1.00 0.00
#&gt; SIH366     1  0.4282     0.1221 0.56 0.00 0.00 0.42 0.00 0.02
#&gt; SIH377     5  0.2631     0.7880 0.18 0.00 0.00 0.00 0.82 0.00
#&gt; SIH380     2  0.0000     0.9425 0.00 1.00 0.00 0.00 0.00 0.00
#&gt; SIH385     3  0.2190     0.7652 0.00 0.06 0.90 0.00 0.00 0.04
#&gt; SIH389     2  0.0547     0.9375 0.02 0.98 0.00 0.00 0.00 0.00
#&gt; SIH391     3  0.4926     0.6534 0.12 0.00 0.64 0.00 0.00 0.24
#&gt; SIH403     1  0.3647     0.3858 0.64 0.00 0.00 0.00 0.00 0.36
#&gt; SIH411     2  0.0000     0.9425 0.00 1.00 0.00 0.00 0.00 0.00
#&gt; SIH427     5  0.3864     0.1955 0.48 0.00 0.00 0.00 0.52 0.00
#&gt; SIH433     3  0.2048     0.7881 0.00 0.00 0.88 0.00 0.00 0.12
#&gt; SIH439     3  0.4244     0.7247 0.20 0.00 0.72 0.00 0.00 0.08
#&gt; SIH442     5  0.0000     0.8588 0.00 0.00 0.00 0.00 1.00 0.00
#&gt; SIH444     3  0.3499     0.6267 0.00 0.00 0.68 0.00 0.00 0.32
#&gt; SIH452     4  0.1267     0.8821 0.06 0.00 0.00 0.94 0.00 0.00
#&gt; SIH461     6  0.0000     0.8686 0.00 0.00 0.00 0.00 0.00 1.00
#&gt; SIH471     5  0.2631     0.7768 0.18 0.00 0.00 0.00 0.82 0.00
#&gt; SIH472     2  0.1267     0.9209 0.06 0.94 0.00 0.00 0.00 0.00
#&gt; SIH481     5  0.2793     0.7290 0.20 0.00 0.00 0.00 0.80 0.00
#&gt; SIH485     2  0.0000     0.9425 0.00 1.00 0.00 0.00 0.00 0.00
#&gt; SIH491     2  0.0547     0.9375 0.02 0.98 0.00 0.00 0.00 0.00
#&gt; SIH508     6  0.3756     0.0432 0.40 0.00 0.00 0.00 0.00 0.60
#&gt; SIH559     5  0.0547     0.8559 0.02 0.00 0.00 0.00 0.98 0.00
#&gt; SIH587     5  0.0000     0.8588 0.00 0.00 0.00 0.00 1.00 0.00
#&gt; SIH625     3  0.3647     0.6513 0.36 0.00 0.64 0.00 0.00 0.00
#&gt; SIH641     6  0.4926     0.4047 0.24 0.00 0.00 0.12 0.00 0.64
#&gt; SIH643     6  0.0000     0.8686 0.00 0.00 0.00 0.00 0.00 1.00
#&gt; SIH674     5  0.0000     0.8588 0.00 0.00 0.00 0.00 1.00 0.00
#&gt; SIH678     5  0.1267     0.8452 0.06 0.00 0.00 0.00 0.94 0.00
#&gt; SIH679     4  0.0000     0.9038 0.00 0.00 0.00 1.00 0.00 0.00
#&gt; SIH689     3  0.1814     0.7863 0.00 0.00 0.90 0.00 0.00 0.10
#&gt; SIH694     2  0.0000     0.9425 0.00 1.00 0.00 0.00 0.00 0.00
#&gt; SIH721     6  0.0000     0.8686 0.00 0.00 0.00 0.00 0.00 1.00
</code></pre>

<script>
$('#tab-ATC-pam-get-classes-5-a').parent().next().next().hide();
$('#tab-ATC-pam-get-classes-5-a').click(function(){
  $('#tab-ATC-pam-get-classes-5-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>
</div>

Heatmaps for the consensus matrix. It visualizes the probability of two
samples to be in a same group.




<script>
$( function() {
	$( '#tabs-ATC-pam-consensus-heatmap' ).tabs();
} );
</script>
<div id='tabs-ATC-pam-consensus-heatmap'>
<ul>
<li><a href='#tab-ATC-pam-consensus-heatmap-1'>k = 2</a></li>
<li><a href='#tab-ATC-pam-consensus-heatmap-2'>k = 3</a></li>
<li><a href='#tab-ATC-pam-consensus-heatmap-3'>k = 4</a></li>
<li><a href='#tab-ATC-pam-consensus-heatmap-4'>k = 5</a></li>
<li><a href='#tab-ATC-pam-consensus-heatmap-5'>k = 6</a></li>
</ul>
<div id='tab-ATC-pam-consensus-heatmap-1'>
<pre><code class="language-r">consensus_heatmap(res, k = 2)
</code></pre>
<p><img src="figure_cola/tab-ATC-pam-consensus-heatmap-1-1.png" alt="plot of chunk tab-ATC-pam-consensus-heatmap-1" /></p>

</div>
<div id='tab-ATC-pam-consensus-heatmap-2'>
<pre><code class="language-r">consensus_heatmap(res, k = 3)
</code></pre>
<p><img src="figure_cola/tab-ATC-pam-consensus-heatmap-2-1.png" alt="plot of chunk tab-ATC-pam-consensus-heatmap-2" /></p>

</div>
<div id='tab-ATC-pam-consensus-heatmap-3'>
<pre><code class="language-r">consensus_heatmap(res, k = 4)
</code></pre>
<p><img src="figure_cola/tab-ATC-pam-consensus-heatmap-3-1.png" alt="plot of chunk tab-ATC-pam-consensus-heatmap-3" /></p>

</div>
<div id='tab-ATC-pam-consensus-heatmap-4'>
<pre><code class="language-r">consensus_heatmap(res, k = 5)
</code></pre>
<p><img src="figure_cola/tab-ATC-pam-consensus-heatmap-4-1.png" alt="plot of chunk tab-ATC-pam-consensus-heatmap-4" /></p>

</div>
<div id='tab-ATC-pam-consensus-heatmap-5'>
<pre><code class="language-r">consensus_heatmap(res, k = 6)
</code></pre>
<p><img src="figure_cola/tab-ATC-pam-consensus-heatmap-5-1.png" alt="plot of chunk tab-ATC-pam-consensus-heatmap-5" /></p>

</div>
</div>

Heatmaps for the membership of samples in all partitions to see how consistent they are:





<script>
$( function() {
	$( '#tabs-ATC-pam-membership-heatmap' ).tabs();
} );
</script>
<div id='tabs-ATC-pam-membership-heatmap'>
<ul>
<li><a href='#tab-ATC-pam-membership-heatmap-1'>k = 2</a></li>
<li><a href='#tab-ATC-pam-membership-heatmap-2'>k = 3</a></li>
<li><a href='#tab-ATC-pam-membership-heatmap-3'>k = 4</a></li>
<li><a href='#tab-ATC-pam-membership-heatmap-4'>k = 5</a></li>
<li><a href='#tab-ATC-pam-membership-heatmap-5'>k = 6</a></li>
</ul>
<div id='tab-ATC-pam-membership-heatmap-1'>
<pre><code class="language-r">membership_heatmap(res, k = 2)
</code></pre>
<p><img src="figure_cola/tab-ATC-pam-membership-heatmap-1-1.png" alt="plot of chunk tab-ATC-pam-membership-heatmap-1" /></p>

</div>
<div id='tab-ATC-pam-membership-heatmap-2'>
<pre><code class="language-r">membership_heatmap(res, k = 3)
</code></pre>
<p><img src="figure_cola/tab-ATC-pam-membership-heatmap-2-1.png" alt="plot of chunk tab-ATC-pam-membership-heatmap-2" /></p>

</div>
<div id='tab-ATC-pam-membership-heatmap-3'>
<pre><code class="language-r">membership_heatmap(res, k = 4)
</code></pre>
<p><img src="figure_cola/tab-ATC-pam-membership-heatmap-3-1.png" alt="plot of chunk tab-ATC-pam-membership-heatmap-3" /></p>

</div>
<div id='tab-ATC-pam-membership-heatmap-4'>
<pre><code class="language-r">membership_heatmap(res, k = 5)
</code></pre>
<p><img src="figure_cola/tab-ATC-pam-membership-heatmap-4-1.png" alt="plot of chunk tab-ATC-pam-membership-heatmap-4" /></p>

</div>
<div id='tab-ATC-pam-membership-heatmap-5'>
<pre><code class="language-r">membership_heatmap(res, k = 6)
</code></pre>
<p><img src="figure_cola/tab-ATC-pam-membership-heatmap-5-1.png" alt="plot of chunk tab-ATC-pam-membership-heatmap-5" /></p>

</div>
</div>

As soon as the classes for columns are determined, the signatures
that are significantly different between subgroups can be looked for. 
Following are the heatmaps for signatures.




Signature heatmaps where rows are scaled:



<script>
$( function() {
	$( '#tabs-ATC-pam-get-signatures' ).tabs();
} );
</script>
<div id='tabs-ATC-pam-get-signatures'>
<ul>
<li><a href='#tab-ATC-pam-get-signatures-1'>k = 2</a></li>
<li><a href='#tab-ATC-pam-get-signatures-2'>k = 3</a></li>
<li><a href='#tab-ATC-pam-get-signatures-3'>k = 4</a></li>
<li><a href='#tab-ATC-pam-get-signatures-4'>k = 5</a></li>
<li><a href='#tab-ATC-pam-get-signatures-5'>k = 6</a></li>
</ul>
<div id='tab-ATC-pam-get-signatures-1'>
<pre><code class="language-r">get_signatures(res, k = 2)
</code></pre>
<p><img src="figure_cola/tab-ATC-pam-get-signatures-1-1.png" alt="plot of chunk tab-ATC-pam-get-signatures-1" /></p>

</div>
<div id='tab-ATC-pam-get-signatures-2'>
<pre><code class="language-r">get_signatures(res, k = 3)
</code></pre>
<p><img src="figure_cola/tab-ATC-pam-get-signatures-2-1.png" alt="plot of chunk tab-ATC-pam-get-signatures-2" /></p>

</div>
<div id='tab-ATC-pam-get-signatures-3'>
<pre><code class="language-r">get_signatures(res, k = 4)
</code></pre>
<p><img src="figure_cola/tab-ATC-pam-get-signatures-3-1.png" alt="plot of chunk tab-ATC-pam-get-signatures-3" /></p>

</div>
<div id='tab-ATC-pam-get-signatures-4'>
<pre><code class="language-r">get_signatures(res, k = 5)
</code></pre>
<p><img src="figure_cola/tab-ATC-pam-get-signatures-4-1.png" alt="plot of chunk tab-ATC-pam-get-signatures-4" /></p>

</div>
<div id='tab-ATC-pam-get-signatures-5'>
<pre><code class="language-r">get_signatures(res, k = 6)
</code></pre>
<p><img src="figure_cola/tab-ATC-pam-get-signatures-5-1.png" alt="plot of chunk tab-ATC-pam-get-signatures-5" /></p>

</div>
</div>



Signature heatmaps where rows are not scaled:


<script>
$( function() {
	$( '#tabs-ATC-pam-get-signatures-no-scale' ).tabs();
} );
</script>
<div id='tabs-ATC-pam-get-signatures-no-scale'>
<ul>
<li><a href='#tab-ATC-pam-get-signatures-no-scale-1'>k = 2</a></li>
<li><a href='#tab-ATC-pam-get-signatures-no-scale-2'>k = 3</a></li>
<li><a href='#tab-ATC-pam-get-signatures-no-scale-3'>k = 4</a></li>
<li><a href='#tab-ATC-pam-get-signatures-no-scale-4'>k = 5</a></li>
<li><a href='#tab-ATC-pam-get-signatures-no-scale-5'>k = 6</a></li>
</ul>
<div id='tab-ATC-pam-get-signatures-no-scale-1'>
<pre><code class="language-r">get_signatures(res, k = 2, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-ATC-pam-get-signatures-no-scale-1-1.png" alt="plot of chunk tab-ATC-pam-get-signatures-no-scale-1" /></p>

</div>
<div id='tab-ATC-pam-get-signatures-no-scale-2'>
<pre><code class="language-r">get_signatures(res, k = 3, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-ATC-pam-get-signatures-no-scale-2-1.png" alt="plot of chunk tab-ATC-pam-get-signatures-no-scale-2" /></p>

</div>
<div id='tab-ATC-pam-get-signatures-no-scale-3'>
<pre><code class="language-r">get_signatures(res, k = 4, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-ATC-pam-get-signatures-no-scale-3-1.png" alt="plot of chunk tab-ATC-pam-get-signatures-no-scale-3" /></p>

</div>
<div id='tab-ATC-pam-get-signatures-no-scale-4'>
<pre><code class="language-r">get_signatures(res, k = 5, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-ATC-pam-get-signatures-no-scale-4-1.png" alt="plot of chunk tab-ATC-pam-get-signatures-no-scale-4" /></p>

</div>
<div id='tab-ATC-pam-get-signatures-no-scale-5'>
<pre><code class="language-r">get_signatures(res, k = 6, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-ATC-pam-get-signatures-no-scale-5-1.png" alt="plot of chunk tab-ATC-pam-get-signatures-no-scale-5" /></p>

</div>
</div>



Compare the overlap of signatures from different k:

``` r
compare_signatures(res)
```

![plot of chunk ATC-pam-signature_compare](figure_cola/ATC-pam-signature_compare-1.png)

`get_signature()` returns a data frame invisibly. To get the list of signatures, the function
call should be assigned to a variable explicitly. In following code, if `plot` argument is set
to `FALSE`, no heatmap is plotted while only the differential analysis is performed.

``` r
# code only for demonstration
tb = get_signature(res, k = ..., plot = FALSE)
```

An example of the output of `tb` is:

```
#>   which_row         fdr    mean_1    mean_2 scaled_mean_1 scaled_mean_2 km
#> 1        38 0.042760348  8.373488  9.131774    -0.5533452     0.5164555  1
#> 2        40 0.018707592  7.106213  8.469186    -0.6173731     0.5762149  1
#> 3        55 0.019134737 10.221463 11.207825    -0.6159697     0.5749050  1
#> 4        59 0.006059896  5.921854  7.869574    -0.6899429     0.6439467  1
#> 5        60 0.018055526  8.928898 10.211722    -0.6204761     0.5791110  1
#> 6        98 0.009384629 15.714769 14.887706     0.6635654    -0.6193277  2
...
```

The columns in `tb` are:

1. `which_row`: row indices corresponding to the input matrix.
2. `fdr`: FDR for the differential test. 
3. `mean_x`: The mean value in group x.
4. `scaled_mean_x`: The mean value in group x after rows are scaled.
5. `km`: Row groups if k-means clustering is applied to rows (which is done by automatically selecting number of clusters).

If there are too many signatures, `top_signatures = ...` can be set to only show the 
signatures with the highest FDRs:

``` r
# code only for demonstration
# e.g. to show the top 500 most significant rows
tb = get_signature(res, k = ..., top_signatures = 500)
```

If the signatures are defined as these which are uniquely high in current group, `diff_method` argument
can be set to `"uniquely_high_in_one_group"`:

``` r
# code only for demonstration
tb = get_signature(res, k = ..., diff_method = "uniquely_high_in_one_group")
```




UMAP plot which shows how samples are separated.


<script>
$( function() {
	$( '#tabs-ATC-pam-dimension-reduction' ).tabs();
} );
</script>
<div id='tabs-ATC-pam-dimension-reduction'>
<ul>
<li><a href='#tab-ATC-pam-dimension-reduction-1'>k = 2</a></li>
<li><a href='#tab-ATC-pam-dimension-reduction-2'>k = 3</a></li>
<li><a href='#tab-ATC-pam-dimension-reduction-3'>k = 4</a></li>
<li><a href='#tab-ATC-pam-dimension-reduction-4'>k = 5</a></li>
<li><a href='#tab-ATC-pam-dimension-reduction-5'>k = 6</a></li>
</ul>
<div id='tab-ATC-pam-dimension-reduction-1'>
<pre><code class="language-r">dimension_reduction(res, k = 2, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-ATC-pam-dimension-reduction-1-1.png" alt="plot of chunk tab-ATC-pam-dimension-reduction-1" /></p>

</div>
<div id='tab-ATC-pam-dimension-reduction-2'>
<pre><code class="language-r">dimension_reduction(res, k = 3, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-ATC-pam-dimension-reduction-2-1.png" alt="plot of chunk tab-ATC-pam-dimension-reduction-2" /></p>

</div>
<div id='tab-ATC-pam-dimension-reduction-3'>
<pre><code class="language-r">dimension_reduction(res, k = 4, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-ATC-pam-dimension-reduction-3-1.png" alt="plot of chunk tab-ATC-pam-dimension-reduction-3" /></p>

</div>
<div id='tab-ATC-pam-dimension-reduction-4'>
<pre><code class="language-r">dimension_reduction(res, k = 5, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-ATC-pam-dimension-reduction-4-1.png" alt="plot of chunk tab-ATC-pam-dimension-reduction-4" /></p>

</div>
<div id='tab-ATC-pam-dimension-reduction-5'>
<pre><code class="language-r">dimension_reduction(res, k = 6, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-ATC-pam-dimension-reduction-5-1.png" alt="plot of chunk tab-ATC-pam-dimension-reduction-5" /></p>

</div>
</div>



Following heatmap shows how subgroups are split when increasing `k`:

``` r
collect_classes(res)
```

![plot of chunk ATC-pam-collect-classes](figure_cola/ATC-pam-collect-classes-1.png)



If matrix rows can be associated to genes, consider to use `functional_enrichment(res,
...)` to perform function enrichment for the signature genes. See [this vignette](https://jokergoo.github.io/cola_vignettes/functional_enrichment.html) for more detailed explanations.


 

---------------------------------------------------



### ATC:skmeans*






The object with results only for a single top-value method and a single partitioning method 
can be extracted as:

``` r
res = res_list["ATC", "skmeans"]
# you can also extract it by
# res = res_list["ATC:skmeans"]
```

A summary of `res` and all the functions that can be applied to it:

``` r
res
```

```
#> A 'ConsensusPartition' object with k = 2, 3, 4, 5, 6.
#>   On a matrix with 1900 rows and 60 columns.
#>   Top rows (190) are extracted by 'ATC' method.
#>   Subgroups are detected by 'skmeans' method.
#>   Performed in total 250 partitions by row resampling.
#>   Best k for subgroups seems to be 6.
#> 
#> Following methods can be applied to this 'ConsensusPartition' object:
#>  [1] "cola_report"             "collect_classes"         "collect_plots"          
#>  [4] "collect_stats"           "colnames"                "compare_partitions"     
#>  [7] "compare_signatures"      "consensus_heatmap"       "dimension_reduction"    
#> [10] "functional_enrichment"   "get_anno_col"            "get_anno"               
#> [13] "get_classes"             "get_consensus"           "get_matrix"             
#> [16] "get_membership"          "get_param"               "get_signatures"         
#> [19] "get_stats"               "is_best_k"               "is_stable_k"            
#> [22] "membership_heatmap"      "ncol"                    "nrow"                   
#> [25] "plot_ecdf"               "predict_classes"         "rownames"               
#> [28] "select_partition_number" "show"                    "suggest_best_k"         
#> [31] "test_to_known_factors"   "top_rows_heatmap"
```

`collect_plots()` function collects all the plots made from `res` for all `k` (number of subgroups)
into one single page to provide an easy and fast comparison between different `k`.

``` r
collect_plots(res)
```

![plot of chunk ATC-skmeans-collect-plots](figure_cola/ATC-skmeans-collect-plots-1.png)

The plots are:

- The first row: a plot of the eCDF (empirical cumulative distribution
  function) curves of the consensus matrix for each `k` and the heatmap of
  predicted classes for each `k`.
- The second row: heatmaps of the consensus matrix for each `k`.
- The third row: heatmaps of the membership matrix for each `k`.
- The fouth row: heatmaps of the signatures for each `k`.

All the plots in panels can be made by individual functions and they are
plotted later in this section.

`select_partition_number()` produces several plots showing different
statistics for choosing "optimized" `k`. There are following statistics:

- eCDF curves of the consensus matrix for each `k`;
- 1-PAC. [The PAC score](https://en.wikipedia.org/wiki/Consensus_clustering#Over-interpretation_potential_of_consensus_clustering)
  measures the proportion of the ambiguous subgrouping.
- Mean silhouette score.
- Concordance. The mean probability of fiting the consensus subgroup labels in all
  partitions.
- Area increased. Denote $A_k$ as the area under the eCDF curve for current
  `k`, the area increased is defined as $A_k - A_{k-1}$.
- Rand index. The percent of pairs of samples that are both in a same cluster
  or both are not in a same cluster in the partition of k and k-1.
- Jaccard index. The ratio of pairs of samples are both in a same cluster in
  the partition of k and k-1 and the pairs of samples are both in a same
  cluster in the partition k or k-1.

The detailed explanations of these statistics can be found in [the _cola_
vignette](https://jokergoo.github.io/cola_vignettes/cola.html#toc_13).

Generally speaking, higher 1-PAC score, higher mean silhouette score or higher
concordance corresponds to better partition. Rand index and Jaccard index
measure how similar the current partition is compared to partition with `k-1`.
If they are too similar, we won't accept `k` is better than `k-1`.

``` r
select_partition_number(res)
```

![plot of chunk ATC-skmeans-select-partition-number](figure_cola/ATC-skmeans-select-partition-number-1.png)

The numeric values for all these statistics can be obtained by `get_stats()`.

``` r
get_stats(res)
```

```
#>   k 1-PAC mean_silhouette concordance area_increased  Rand Jaccard
#> 2 2 0.863           0.915       0.965         0.4995 0.497   0.497
#> 3 3 0.816           0.899       0.940         0.3099 0.795   0.611
#> 4 4 0.967           0.926       0.971         0.1099 0.902   0.726
#> 5 5 0.899           0.822       0.928         0.0523 0.947   0.812
#> 6 6 0.902           0.792       0.911         0.0304 0.952   0.807
```

`suggest_best_k()` suggests the best $k$ based on these statistics. The rules are as follows:

- All $k$ with Jaccard index larger than 0.95 are removed because increasing
  $k$ does not provide enough extra information. If all $k$ are removed, it is
  marked as no subgroup is detected.
- For all $k$ with 1-PAC score larger than 0.9, the maximal $k$ is taken as
  the best $k$, and other $k$ are marked as optional $k$.
- If it does not fit the second rule. The $k$ with the maximal vote of the
  highest 1-PAC score, highest mean silhouette, and highest concordance is
  taken as the best $k$.

``` r
suggest_best_k(res)
```

```
#> [1] 6
#> attr(,"optional")
#> [1] 4
```

There is also optional best $k$ = 4 that is worth to check.

Following is the table of the partitions (You need to click the **show/hide
code output** link to see it). The membership matrix (columns with name `p*`)
is inferred by
[`clue::cl_consensus()`](https://www.rdocumentation.org/link/cl_consensus?package=clue)
function with the `SE` method. Basically the value in the membership matrix
represents the probability to belong to a certain group. The finall subgroup
label for an item is determined with the group with highest probability it
belongs to.

In `get_classes()` function, the entropy is calculated from the membership
matrix and the silhouette score is calculated from the consensus matrix.



<script>
$( function() {
	$( '#tabs-ATC-skmeans-get-classes' ).tabs();
} );
</script>
<div id='tabs-ATC-skmeans-get-classes'>
<ul>
<li><a href='#tab-ATC-skmeans-get-classes-1'>k = 2</a></li>
<li><a href='#tab-ATC-skmeans-get-classes-2'>k = 3</a></li>
<li><a href='#tab-ATC-skmeans-get-classes-3'>k = 4</a></li>
<li><a href='#tab-ATC-skmeans-get-classes-4'>k = 5</a></li>
<li><a href='#tab-ATC-skmeans-get-classes-5'>k = 6</a></li>
</ul>

<div id='tab-ATC-skmeans-get-classes-1'>
<p><a id='tab-ATC-skmeans-get-classes-1-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 2), get_membership(res, k = 2))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2
#&gt; SIH013     1   0.925      0.516 0.66 0.34
#&gt; SIH014     2   0.000      0.981 0.00 1.00
#&gt; SIH024     2   0.000      0.981 0.00 1.00
#&gt; SIH028     2   0.000      0.981 0.00 1.00
#&gt; SIH031     1   0.000      0.941 1.00 0.00
#&gt; SIH042     1   0.000      0.941 1.00 0.00
#&gt; SIH107     2   0.000      0.981 0.00 1.00
#&gt; SIH114     1   0.000      0.941 1.00 0.00
#&gt; SIH116     1   0.000      0.941 1.00 0.00
#&gt; SIH117     2   0.000      0.981 0.00 1.00
#&gt; SIH130     2   0.000      0.981 0.00 1.00
#&gt; SIH134     2   0.000      0.981 0.00 1.00
#&gt; SIH186     2   0.000      0.981 0.00 1.00
#&gt; SIH191     1   0.000      0.941 1.00 0.00
#&gt; SIH192     2   0.000      0.981 0.00 1.00
#&gt; SIH196     2   0.000      0.981 0.00 1.00
#&gt; SIH214     2   0.000      0.981 0.00 1.00
#&gt; SIH218     1   0.000      0.941 1.00 0.00
#&gt; SIH232     1   0.000      0.941 1.00 0.00
#&gt; SIH236     1   0.990      0.224 0.56 0.44
#&gt; SIH238     1   0.000      0.941 1.00 0.00
#&gt; SIH241     2   0.000      0.981 0.00 1.00
#&gt; SIH245     2   0.000      0.981 0.00 1.00
#&gt; SIH260     2   0.680      0.772 0.18 0.82
#&gt; SIH287     2   0.000      0.981 0.00 1.00
#&gt; SIH289     2   0.469      0.876 0.10 0.90
#&gt; SIH290     2   0.000      0.981 0.00 1.00
#&gt; SIH295     1   0.000      0.941 1.00 0.00
#&gt; SIH366     1   0.000      0.941 1.00 0.00
#&gt; SIH377     1   0.000      0.941 1.00 0.00
#&gt; SIH380     2   0.000      0.981 0.00 1.00
#&gt; SIH385     2   0.000      0.981 0.00 1.00
#&gt; SIH389     2   0.000      0.981 0.00 1.00
#&gt; SIH391     2   0.000      0.981 0.00 1.00
#&gt; SIH403     1   0.000      0.941 1.00 0.00
#&gt; SIH411     2   0.000      0.981 0.00 1.00
#&gt; SIH427     1   0.000      0.941 1.00 0.00
#&gt; SIH433     2   0.000      0.981 0.00 1.00
#&gt; SIH439     2   0.881      0.551 0.30 0.70
#&gt; SIH442     1   0.000      0.941 1.00 0.00
#&gt; SIH444     1   0.881      0.592 0.70 0.30
#&gt; SIH452     2   0.000      0.981 0.00 1.00
#&gt; SIH461     1   0.981      0.330 0.58 0.42
#&gt; SIH471     1   0.000      0.941 1.00 0.00
#&gt; SIH472     2   0.000      0.981 0.00 1.00
#&gt; SIH481     1   0.000      0.941 1.00 0.00
#&gt; SIH485     2   0.000      0.981 0.00 1.00
#&gt; SIH491     2   0.000      0.981 0.00 1.00
#&gt; SIH508     1   0.000      0.941 1.00 0.00
#&gt; SIH559     1   0.000      0.941 1.00 0.00
#&gt; SIH587     1   0.000      0.941 1.00 0.00
#&gt; SIH625     2   0.000      0.981 0.00 1.00
#&gt; SIH641     1   0.000      0.941 1.00 0.00
#&gt; SIH643     2   0.000      0.981 0.00 1.00
#&gt; SIH674     1   0.000      0.941 1.00 0.00
#&gt; SIH678     1   0.000      0.941 1.00 0.00
#&gt; SIH679     1   0.000      0.941 1.00 0.00
#&gt; SIH689     2   0.000      0.981 0.00 1.00
#&gt; SIH694     2   0.000      0.981 0.00 1.00
#&gt; SIH721     2   0.000      0.981 0.00 1.00
</code></pre>

<script>
$('#tab-ATC-skmeans-get-classes-1-a').parent().next().next().hide();
$('#tab-ATC-skmeans-get-classes-1-a').click(function(){
  $('#tab-ATC-skmeans-get-classes-1-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-ATC-skmeans-get-classes-2'>
<p><a id='tab-ATC-skmeans-get-classes-2-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 3), get_membership(res, k = 3))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3
#&gt; SIH013     3   0.153      0.926 0.04 0.00 0.96
#&gt; SIH014     3   0.296      0.903 0.00 0.10 0.90
#&gt; SIH024     3   0.153      0.959 0.00 0.04 0.96
#&gt; SIH028     2   0.254      0.899 0.00 0.92 0.08
#&gt; SIH031     1   0.000      0.986 1.00 0.00 0.00
#&gt; SIH042     1   0.000      0.986 1.00 0.00 0.00
#&gt; SIH107     2   0.000      0.877 0.00 1.00 0.00
#&gt; SIH114     1   0.000      0.986 1.00 0.00 0.00
#&gt; SIH116     1   0.357      0.891 0.90 0.06 0.04
#&gt; SIH117     3   0.153      0.959 0.00 0.04 0.96
#&gt; SIH130     2   0.254      0.899 0.00 0.92 0.08
#&gt; SIH134     2   0.254      0.899 0.00 0.92 0.08
#&gt; SIH186     2   0.000      0.877 0.00 1.00 0.00
#&gt; SIH191     1   0.000      0.986 1.00 0.00 0.00
#&gt; SIH192     2   0.604      0.370 0.00 0.62 0.38
#&gt; SIH196     2   0.254      0.899 0.00 0.92 0.08
#&gt; SIH214     2   0.254      0.899 0.00 0.92 0.08
#&gt; SIH218     1   0.455      0.751 0.80 0.00 0.20
#&gt; SIH232     1   0.000      0.986 1.00 0.00 0.00
#&gt; SIH236     2   0.916      0.250 0.34 0.50 0.16
#&gt; SIH238     1   0.000      0.986 1.00 0.00 0.00
#&gt; SIH241     2   0.254      0.899 0.00 0.92 0.08
#&gt; SIH245     2   0.254      0.899 0.00 0.92 0.08
#&gt; SIH260     2   0.304      0.831 0.04 0.92 0.04
#&gt; SIH287     2   0.000      0.877 0.00 1.00 0.00
#&gt; SIH289     2   0.153      0.855 0.00 0.96 0.04
#&gt; SIH290     2   0.254      0.899 0.00 0.92 0.08
#&gt; SIH295     1   0.000      0.986 1.00 0.00 0.00
#&gt; SIH366     1   0.000      0.986 1.00 0.00 0.00
#&gt; SIH377     1   0.000      0.986 1.00 0.00 0.00
#&gt; SIH380     2   0.254      0.899 0.00 0.92 0.08
#&gt; SIH385     3   0.153      0.959 0.00 0.04 0.96
#&gt; SIH389     2   0.254      0.899 0.00 0.92 0.08
#&gt; SIH391     2   0.604      0.372 0.00 0.62 0.38
#&gt; SIH403     1   0.000      0.986 1.00 0.00 0.00
#&gt; SIH411     2   0.254      0.899 0.00 0.92 0.08
#&gt; SIH427     1   0.000      0.986 1.00 0.00 0.00
#&gt; SIH433     3   0.153      0.959 0.00 0.04 0.96
#&gt; SIH439     3   0.502      0.687 0.00 0.24 0.76
#&gt; SIH442     1   0.000      0.986 1.00 0.00 0.00
#&gt; SIH444     3   0.178      0.948 0.02 0.02 0.96
#&gt; SIH452     2   0.153      0.855 0.00 0.96 0.04
#&gt; SIH461     3   0.178      0.948 0.02 0.02 0.96
#&gt; SIH471     1   0.000      0.986 1.00 0.00 0.00
#&gt; SIH472     2   0.000      0.877 0.00 1.00 0.00
#&gt; SIH481     1   0.000      0.986 1.00 0.00 0.00
#&gt; SIH485     2   0.254      0.899 0.00 0.92 0.08
#&gt; SIH491     2   0.254      0.899 0.00 0.92 0.08
#&gt; SIH508     1   0.000      0.986 1.00 0.00 0.00
#&gt; SIH559     1   0.000      0.986 1.00 0.00 0.00
#&gt; SIH587     1   0.000      0.986 1.00 0.00 0.00
#&gt; SIH625     2   0.153      0.855 0.00 0.96 0.04
#&gt; SIH641     1   0.000      0.986 1.00 0.00 0.00
#&gt; SIH643     3   0.153      0.959 0.00 0.04 0.96
#&gt; SIH674     1   0.000      0.986 1.00 0.00 0.00
#&gt; SIH678     1   0.000      0.986 1.00 0.00 0.00
#&gt; SIH679     1   0.000      0.986 1.00 0.00 0.00
#&gt; SIH689     3   0.153      0.959 0.00 0.04 0.96
#&gt; SIH694     2   0.254      0.899 0.00 0.92 0.08
#&gt; SIH721     3   0.153      0.959 0.00 0.04 0.96
</code></pre>

<script>
$('#tab-ATC-skmeans-get-classes-2-a').parent().next().next().hide();
$('#tab-ATC-skmeans-get-classes-2-a').click(function(){
  $('#tab-ATC-skmeans-get-classes-2-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-ATC-skmeans-get-classes-3'>
<p><a id='tab-ATC-skmeans-get-classes-3-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 4), get_membership(res, k = 4))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3   p4
#&gt; SIH013     3  0.0000      0.953 0.00 0.00 1.00 0.00
#&gt; SIH014     3  0.4522      0.533 0.00 0.32 0.68 0.00
#&gt; SIH024     3  0.0000      0.953 0.00 0.00 1.00 0.00
#&gt; SIH028     2  0.0000      1.000 0.00 1.00 0.00 0.00
#&gt; SIH031     1  0.0000      0.979 1.00 0.00 0.00 0.00
#&gt; SIH042     1  0.0707      0.961 0.98 0.00 0.00 0.02
#&gt; SIH107     2  0.0000      1.000 0.00 1.00 0.00 0.00
#&gt; SIH114     1  0.0000      0.979 1.00 0.00 0.00 0.00
#&gt; SIH116     4  0.4624      0.452 0.34 0.00 0.00 0.66
#&gt; SIH117     3  0.0000      0.953 0.00 0.00 1.00 0.00
#&gt; SIH130     2  0.0000      1.000 0.00 1.00 0.00 0.00
#&gt; SIH134     2  0.0000      1.000 0.00 1.00 0.00 0.00
#&gt; SIH186     2  0.0000      1.000 0.00 1.00 0.00 0.00
#&gt; SIH191     1  0.0000      0.979 1.00 0.00 0.00 0.00
#&gt; SIH192     4  0.4553      0.689 0.00 0.18 0.04 0.78
#&gt; SIH196     2  0.0000      1.000 0.00 1.00 0.00 0.00
#&gt; SIH214     2  0.0000      1.000 0.00 1.00 0.00 0.00
#&gt; SIH218     1  0.4624      0.493 0.66 0.00 0.34 0.00
#&gt; SIH232     1  0.0000      0.979 1.00 0.00 0.00 0.00
#&gt; SIH236     4  0.0000      0.850 0.00 0.00 0.00 1.00
#&gt; SIH238     1  0.1211      0.942 0.96 0.00 0.04 0.00
#&gt; SIH241     2  0.0000      1.000 0.00 1.00 0.00 0.00
#&gt; SIH245     2  0.0000      1.000 0.00 1.00 0.00 0.00
#&gt; SIH260     4  0.0000      0.850 0.00 0.00 0.00 1.00
#&gt; SIH287     2  0.0000      1.000 0.00 1.00 0.00 0.00
#&gt; SIH289     4  0.0000      0.850 0.00 0.00 0.00 1.00
#&gt; SIH290     2  0.0000      1.000 0.00 1.00 0.00 0.00
#&gt; SIH295     1  0.0000      0.979 1.00 0.00 0.00 0.00
#&gt; SIH366     1  0.0000      0.979 1.00 0.00 0.00 0.00
#&gt; SIH377     1  0.0000      0.979 1.00 0.00 0.00 0.00
#&gt; SIH380     2  0.0000      1.000 0.00 1.00 0.00 0.00
#&gt; SIH385     3  0.1211      0.915 0.00 0.04 0.96 0.00
#&gt; SIH389     2  0.0000      1.000 0.00 1.00 0.00 0.00
#&gt; SIH391     4  0.0000      0.850 0.00 0.00 0.00 1.00
#&gt; SIH403     1  0.0000      0.979 1.00 0.00 0.00 0.00
#&gt; SIH411     2  0.0000      1.000 0.00 1.00 0.00 0.00
#&gt; SIH427     1  0.0000      0.979 1.00 0.00 0.00 0.00
#&gt; SIH433     3  0.0000      0.953 0.00 0.00 1.00 0.00
#&gt; SIH439     4  0.0000      0.850 0.00 0.00 0.00 1.00
#&gt; SIH442     1  0.0000      0.979 1.00 0.00 0.00 0.00
#&gt; SIH444     3  0.0000      0.953 0.00 0.00 1.00 0.00
#&gt; SIH452     4  0.4907      0.293 0.00 0.42 0.00 0.58
#&gt; SIH461     3  0.0000      0.953 0.00 0.00 1.00 0.00
#&gt; SIH471     1  0.0000      0.979 1.00 0.00 0.00 0.00
#&gt; SIH472     2  0.0000      1.000 0.00 1.00 0.00 0.00
#&gt; SIH481     1  0.0000      0.979 1.00 0.00 0.00 0.00
#&gt; SIH485     2  0.0000      1.000 0.00 1.00 0.00 0.00
#&gt; SIH491     2  0.0000      1.000 0.00 1.00 0.00 0.00
#&gt; SIH508     1  0.0000      0.979 1.00 0.00 0.00 0.00
#&gt; SIH559     1  0.0000      0.979 1.00 0.00 0.00 0.00
#&gt; SIH587     1  0.0000      0.979 1.00 0.00 0.00 0.00
#&gt; SIH625     4  0.0000      0.850 0.00 0.00 0.00 1.00
#&gt; SIH641     1  0.0000      0.979 1.00 0.00 0.00 0.00
#&gt; SIH643     3  0.0000      0.953 0.00 0.00 1.00 0.00
#&gt; SIH674     1  0.0000      0.979 1.00 0.00 0.00 0.00
#&gt; SIH678     1  0.0000      0.979 1.00 0.00 0.00 0.00
#&gt; SIH679     1  0.0000      0.979 1.00 0.00 0.00 0.00
#&gt; SIH689     3  0.0000      0.953 0.00 0.00 1.00 0.00
#&gt; SIH694     2  0.0000      1.000 0.00 1.00 0.00 0.00
#&gt; SIH721     3  0.0000      0.953 0.00 0.00 1.00 0.00
</code></pre>

<script>
$('#tab-ATC-skmeans-get-classes-3-a').parent().next().next().hide();
$('#tab-ATC-skmeans-get-classes-3-a').click(function(){
  $('#tab-ATC-skmeans-get-classes-3-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-ATC-skmeans-get-classes-4'>
<p><a id='tab-ATC-skmeans-get-classes-4-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 5), get_membership(res, k = 5))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3   p4   p5
#&gt; SIH013     3  0.2516      0.844 0.00 0.00 0.86 0.00 0.14
#&gt; SIH014     3  0.3895      0.465 0.00 0.32 0.68 0.00 0.00
#&gt; SIH024     3  0.0000      0.908 0.00 0.00 1.00 0.00 0.00
#&gt; SIH028     2  0.0609      0.946 0.00 0.98 0.02 0.00 0.00
#&gt; SIH031     1  0.0000      0.923 1.00 0.00 0.00 0.00 0.00
#&gt; SIH042     1  0.4818     -0.228 0.52 0.00 0.00 0.02 0.46
#&gt; SIH107     2  0.0000      0.965 0.00 1.00 0.00 0.00 0.00
#&gt; SIH114     1  0.0000      0.923 1.00 0.00 0.00 0.00 0.00
#&gt; SIH116     5  0.2732      0.270 0.00 0.00 0.00 0.16 0.84
#&gt; SIH117     3  0.0000      0.908 0.00 0.00 1.00 0.00 0.00
#&gt; SIH130     2  0.0000      0.965 0.00 1.00 0.00 0.00 0.00
#&gt; SIH134     2  0.0000      0.965 0.00 1.00 0.00 0.00 0.00
#&gt; SIH186     2  0.0000      0.965 0.00 1.00 0.00 0.00 0.00
#&gt; SIH191     1  0.0000      0.923 1.00 0.00 0.00 0.00 0.00
#&gt; SIH192     4  0.3037      0.768 0.00 0.04 0.10 0.86 0.00
#&gt; SIH196     2  0.0000      0.965 0.00 1.00 0.00 0.00 0.00
#&gt; SIH214     2  0.0000      0.965 0.00 1.00 0.00 0.00 0.00
#&gt; SIH218     5  0.5854      0.567 0.24 0.00 0.16 0.00 0.60
#&gt; SIH232     1  0.0000      0.923 1.00 0.00 0.00 0.00 0.00
#&gt; SIH236     4  0.0000      0.877 0.00 0.00 0.00 1.00 0.00
#&gt; SIH238     5  0.4227      0.326 0.42 0.00 0.00 0.00 0.58
#&gt; SIH241     2  0.0609      0.947 0.00 0.98 0.02 0.00 0.00
#&gt; SIH245     2  0.0000      0.965 0.00 1.00 0.00 0.00 0.00
#&gt; SIH260     4  0.4182      0.526 0.00 0.00 0.00 0.60 0.40
#&gt; SIH287     2  0.0000      0.965 0.00 1.00 0.00 0.00 0.00
#&gt; SIH289     4  0.2280      0.834 0.00 0.00 0.00 0.88 0.12
#&gt; SIH290     2  0.0000      0.965 0.00 1.00 0.00 0.00 0.00
#&gt; SIH295     1  0.0000      0.923 1.00 0.00 0.00 0.00 0.00
#&gt; SIH366     1  0.3274      0.623 0.78 0.00 0.00 0.00 0.22
#&gt; SIH377     1  0.0000      0.923 1.00 0.00 0.00 0.00 0.00
#&gt; SIH380     2  0.0000      0.965 0.00 1.00 0.00 0.00 0.00
#&gt; SIH385     3  0.0609      0.897 0.00 0.02 0.98 0.00 0.00
#&gt; SIH389     2  0.0000      0.965 0.00 1.00 0.00 0.00 0.00
#&gt; SIH391     4  0.0609      0.878 0.00 0.00 0.00 0.98 0.02
#&gt; SIH403     1  0.0000      0.923 1.00 0.00 0.00 0.00 0.00
#&gt; SIH411     2  0.0000      0.965 0.00 1.00 0.00 0.00 0.00
#&gt; SIH427     1  0.0000      0.923 1.00 0.00 0.00 0.00 0.00
#&gt; SIH433     3  0.0000      0.908 0.00 0.00 1.00 0.00 0.00
#&gt; SIH439     4  0.0609      0.872 0.00 0.00 0.00 0.98 0.02
#&gt; SIH442     1  0.0000      0.923 1.00 0.00 0.00 0.00 0.00
#&gt; SIH444     3  0.1410      0.897 0.00 0.00 0.94 0.00 0.06
#&gt; SIH452     2  0.6705     -0.149 0.00 0.42 0.00 0.32 0.26
#&gt; SIH461     3  0.2020      0.877 0.00 0.00 0.90 0.00 0.10
#&gt; SIH471     1  0.0000      0.923 1.00 0.00 0.00 0.00 0.00
#&gt; SIH472     2  0.0000      0.965 0.00 1.00 0.00 0.00 0.00
#&gt; SIH481     1  0.0000      0.923 1.00 0.00 0.00 0.00 0.00
#&gt; SIH485     2  0.0000      0.965 0.00 1.00 0.00 0.00 0.00
#&gt; SIH491     2  0.0000      0.965 0.00 1.00 0.00 0.00 0.00
#&gt; SIH508     1  0.0000      0.923 1.00 0.00 0.00 0.00 0.00
#&gt; SIH559     1  0.0000      0.923 1.00 0.00 0.00 0.00 0.00
#&gt; SIH587     1  0.0000      0.923 1.00 0.00 0.00 0.00 0.00
#&gt; SIH625     4  0.0609      0.878 0.00 0.00 0.00 0.98 0.02
#&gt; SIH641     1  0.4060      0.213 0.64 0.00 0.00 0.00 0.36
#&gt; SIH643     3  0.2020      0.877 0.00 0.00 0.90 0.00 0.10
#&gt; SIH674     1  0.0000      0.923 1.00 0.00 0.00 0.00 0.00
#&gt; SIH678     1  0.0000      0.923 1.00 0.00 0.00 0.00 0.00
#&gt; SIH679     5  0.3109      0.558 0.20 0.00 0.00 0.00 0.80
#&gt; SIH689     3  0.0000      0.908 0.00 0.00 1.00 0.00 0.00
#&gt; SIH694     2  0.0000      0.965 0.00 1.00 0.00 0.00 0.00
#&gt; SIH721     3  0.0609      0.906 0.00 0.00 0.98 0.00 0.02
</code></pre>

<script>
$('#tab-ATC-skmeans-get-classes-4-a').parent().next().next().hide();
$('#tab-ATC-skmeans-get-classes-4-a').click(function(){
  $('#tab-ATC-skmeans-get-classes-4-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-ATC-skmeans-get-classes-5'>
<p><a id='tab-ATC-skmeans-get-classes-5-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 6), get_membership(res, k = 6))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3   p4   p5   p6
#&gt; SIH013     6  0.3578     0.3499 0.00 0.00 0.34 0.00 0.00 0.66
#&gt; SIH014     3  0.1814     0.7517 0.00 0.10 0.90 0.00 0.00 0.00
#&gt; SIH024     3  0.1092     0.8566 0.00 0.02 0.96 0.00 0.00 0.02
#&gt; SIH028     2  0.0547     0.9456 0.00 0.98 0.02 0.00 0.00 0.00
#&gt; SIH031     5  0.0547     0.9628 0.00 0.00 0.00 0.00 0.98 0.02
#&gt; SIH042     6  0.6331    -0.0585 0.12 0.00 0.00 0.06 0.32 0.50
#&gt; SIH107     2  0.0547     0.9501 0.00 0.98 0.02 0.00 0.00 0.00
#&gt; SIH114     5  0.0000     0.9804 0.00 0.00 0.00 0.00 1.00 0.00
#&gt; SIH116     1  0.0547     0.5617 0.98 0.00 0.00 0.00 0.00 0.02
#&gt; SIH117     3  0.0547     0.8535 0.00 0.02 0.98 0.00 0.00 0.00
#&gt; SIH130     2  0.0000     0.9587 0.00 1.00 0.00 0.00 0.00 0.00
#&gt; SIH134     2  0.0000     0.9587 0.00 1.00 0.00 0.00 0.00 0.00
#&gt; SIH186     2  0.1635     0.9239 0.02 0.94 0.02 0.02 0.00 0.00
#&gt; SIH191     5  0.0000     0.9804 0.00 0.00 0.00 0.00 1.00 0.00
#&gt; SIH192     4  0.0937     0.8934 0.00 0.00 0.04 0.96 0.00 0.00
#&gt; SIH196     2  0.0000     0.9587 0.00 1.00 0.00 0.00 0.00 0.00
#&gt; SIH214     2  0.0000     0.9587 0.00 1.00 0.00 0.00 0.00 0.00
#&gt; SIH218     6  0.3351     0.3264 0.16 0.00 0.00 0.00 0.04 0.80
#&gt; SIH232     5  0.0000     0.9804 0.00 0.00 0.00 0.00 1.00 0.00
#&gt; SIH236     4  0.0547     0.9096 0.00 0.00 0.00 0.98 0.00 0.02
#&gt; SIH238     6  0.3321     0.3561 0.08 0.00 0.00 0.00 0.10 0.82
#&gt; SIH241     2  0.1556     0.8893 0.00 0.92 0.08 0.00 0.00 0.00
#&gt; SIH245     2  0.0000     0.9587 0.00 1.00 0.00 0.00 0.00 0.00
#&gt; SIH260     1  0.4700     0.0482 0.60 0.00 0.00 0.34 0.00 0.06
#&gt; SIH287     2  0.0547     0.9501 0.00 0.98 0.02 0.00 0.00 0.00
#&gt; SIH289     4  0.3679     0.7181 0.20 0.00 0.00 0.76 0.00 0.04
#&gt; SIH290     2  0.0000     0.9587 0.00 1.00 0.00 0.00 0.00 0.00
#&gt; SIH295     5  0.0000     0.9804 0.00 0.00 0.00 0.00 1.00 0.00
#&gt; SIH366     5  0.3315     0.6922 0.20 0.00 0.00 0.00 0.78 0.02
#&gt; SIH377     5  0.0000     0.9804 0.00 0.00 0.00 0.00 1.00 0.00
#&gt; SIH380     2  0.0000     0.9587 0.00 1.00 0.00 0.00 0.00 0.00
#&gt; SIH385     3  0.1092     0.8566 0.00 0.02 0.96 0.00 0.00 0.02
#&gt; SIH389     2  0.0000     0.9587 0.00 1.00 0.00 0.00 0.00 0.00
#&gt; SIH391     4  0.1635     0.8986 0.02 0.00 0.02 0.94 0.00 0.02
#&gt; SIH403     5  0.0000     0.9804 0.00 0.00 0.00 0.00 1.00 0.00
#&gt; SIH411     2  0.0000     0.9587 0.00 1.00 0.00 0.00 0.00 0.00
#&gt; SIH427     5  0.0000     0.9804 0.00 0.00 0.00 0.00 1.00 0.00
#&gt; SIH433     3  0.0547     0.8535 0.00 0.02 0.98 0.00 0.00 0.00
#&gt; SIH439     4  0.0000     0.9094 0.00 0.00 0.00 1.00 0.00 0.00
#&gt; SIH442     5  0.0000     0.9804 0.00 0.00 0.00 0.00 1.00 0.00
#&gt; SIH444     3  0.3578     0.4109 0.00 0.00 0.66 0.00 0.00 0.34
#&gt; SIH452     2  0.6449     0.2376 0.26 0.52 0.02 0.18 0.00 0.02
#&gt; SIH461     6  0.3756     0.2603 0.00 0.00 0.40 0.00 0.00 0.60
#&gt; SIH471     5  0.0000     0.9804 0.00 0.00 0.00 0.00 1.00 0.00
#&gt; SIH472     2  0.1092     0.9391 0.02 0.96 0.02 0.00 0.00 0.00
#&gt; SIH481     5  0.0000     0.9804 0.00 0.00 0.00 0.00 1.00 0.00
#&gt; SIH485     2  0.0000     0.9587 0.00 1.00 0.00 0.00 0.00 0.00
#&gt; SIH491     2  0.0547     0.9501 0.00 0.98 0.02 0.00 0.00 0.00
#&gt; SIH508     5  0.0937     0.9406 0.00 0.00 0.00 0.00 0.96 0.04
#&gt; SIH559     5  0.0000     0.9804 0.00 0.00 0.00 0.00 1.00 0.00
#&gt; SIH587     5  0.0000     0.9804 0.00 0.00 0.00 0.00 1.00 0.00
#&gt; SIH625     4  0.1480     0.8941 0.04 0.00 0.00 0.94 0.00 0.02
#&gt; SIH641     1  0.5371     0.1965 0.52 0.00 0.00 0.00 0.36 0.12
#&gt; SIH643     6  0.3864     0.0546 0.00 0.00 0.48 0.00 0.00 0.52
#&gt; SIH674     5  0.0000     0.9804 0.00 0.00 0.00 0.00 1.00 0.00
#&gt; SIH678     5  0.0000     0.9804 0.00 0.00 0.00 0.00 1.00 0.00
#&gt; SIH679     1  0.1480     0.5613 0.94 0.00 0.00 0.00 0.02 0.04
#&gt; SIH689     3  0.1092     0.8566 0.00 0.02 0.96 0.00 0.00 0.02
#&gt; SIH694     2  0.0000     0.9587 0.00 1.00 0.00 0.00 0.00 0.00
#&gt; SIH721     3  0.3076     0.5639 0.00 0.00 0.76 0.00 0.00 0.24
</code></pre>

<script>
$('#tab-ATC-skmeans-get-classes-5-a').parent().next().next().hide();
$('#tab-ATC-skmeans-get-classes-5-a').click(function(){
  $('#tab-ATC-skmeans-get-classes-5-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>
</div>

Heatmaps for the consensus matrix. It visualizes the probability of two
samples to be in a same group.




<script>
$( function() {
	$( '#tabs-ATC-skmeans-consensus-heatmap' ).tabs();
} );
</script>
<div id='tabs-ATC-skmeans-consensus-heatmap'>
<ul>
<li><a href='#tab-ATC-skmeans-consensus-heatmap-1'>k = 2</a></li>
<li><a href='#tab-ATC-skmeans-consensus-heatmap-2'>k = 3</a></li>
<li><a href='#tab-ATC-skmeans-consensus-heatmap-3'>k = 4</a></li>
<li><a href='#tab-ATC-skmeans-consensus-heatmap-4'>k = 5</a></li>
<li><a href='#tab-ATC-skmeans-consensus-heatmap-5'>k = 6</a></li>
</ul>
<div id='tab-ATC-skmeans-consensus-heatmap-1'>
<pre><code class="language-r">consensus_heatmap(res, k = 2)
</code></pre>
<p><img src="figure_cola/tab-ATC-skmeans-consensus-heatmap-1-1.png" alt="plot of chunk tab-ATC-skmeans-consensus-heatmap-1" /></p>

</div>
<div id='tab-ATC-skmeans-consensus-heatmap-2'>
<pre><code class="language-r">consensus_heatmap(res, k = 3)
</code></pre>
<p><img src="figure_cola/tab-ATC-skmeans-consensus-heatmap-2-1.png" alt="plot of chunk tab-ATC-skmeans-consensus-heatmap-2" /></p>

</div>
<div id='tab-ATC-skmeans-consensus-heatmap-3'>
<pre><code class="language-r">consensus_heatmap(res, k = 4)
</code></pre>
<p><img src="figure_cola/tab-ATC-skmeans-consensus-heatmap-3-1.png" alt="plot of chunk tab-ATC-skmeans-consensus-heatmap-3" /></p>

</div>
<div id='tab-ATC-skmeans-consensus-heatmap-4'>
<pre><code class="language-r">consensus_heatmap(res, k = 5)
</code></pre>
<p><img src="figure_cola/tab-ATC-skmeans-consensus-heatmap-4-1.png" alt="plot of chunk tab-ATC-skmeans-consensus-heatmap-4" /></p>

</div>
<div id='tab-ATC-skmeans-consensus-heatmap-5'>
<pre><code class="language-r">consensus_heatmap(res, k = 6)
</code></pre>
<p><img src="figure_cola/tab-ATC-skmeans-consensus-heatmap-5-1.png" alt="plot of chunk tab-ATC-skmeans-consensus-heatmap-5" /></p>

</div>
</div>

Heatmaps for the membership of samples in all partitions to see how consistent they are:





<script>
$( function() {
	$( '#tabs-ATC-skmeans-membership-heatmap' ).tabs();
} );
</script>
<div id='tabs-ATC-skmeans-membership-heatmap'>
<ul>
<li><a href='#tab-ATC-skmeans-membership-heatmap-1'>k = 2</a></li>
<li><a href='#tab-ATC-skmeans-membership-heatmap-2'>k = 3</a></li>
<li><a href='#tab-ATC-skmeans-membership-heatmap-3'>k = 4</a></li>
<li><a href='#tab-ATC-skmeans-membership-heatmap-4'>k = 5</a></li>
<li><a href='#tab-ATC-skmeans-membership-heatmap-5'>k = 6</a></li>
</ul>
<div id='tab-ATC-skmeans-membership-heatmap-1'>
<pre><code class="language-r">membership_heatmap(res, k = 2)
</code></pre>
<p><img src="figure_cola/tab-ATC-skmeans-membership-heatmap-1-1.png" alt="plot of chunk tab-ATC-skmeans-membership-heatmap-1" /></p>

</div>
<div id='tab-ATC-skmeans-membership-heatmap-2'>
<pre><code class="language-r">membership_heatmap(res, k = 3)
</code></pre>
<p><img src="figure_cola/tab-ATC-skmeans-membership-heatmap-2-1.png" alt="plot of chunk tab-ATC-skmeans-membership-heatmap-2" /></p>

</div>
<div id='tab-ATC-skmeans-membership-heatmap-3'>
<pre><code class="language-r">membership_heatmap(res, k = 4)
</code></pre>
<p><img src="figure_cola/tab-ATC-skmeans-membership-heatmap-3-1.png" alt="plot of chunk tab-ATC-skmeans-membership-heatmap-3" /></p>

</div>
<div id='tab-ATC-skmeans-membership-heatmap-4'>
<pre><code class="language-r">membership_heatmap(res, k = 5)
</code></pre>
<p><img src="figure_cola/tab-ATC-skmeans-membership-heatmap-4-1.png" alt="plot of chunk tab-ATC-skmeans-membership-heatmap-4" /></p>

</div>
<div id='tab-ATC-skmeans-membership-heatmap-5'>
<pre><code class="language-r">membership_heatmap(res, k = 6)
</code></pre>
<p><img src="figure_cola/tab-ATC-skmeans-membership-heatmap-5-1.png" alt="plot of chunk tab-ATC-skmeans-membership-heatmap-5" /></p>

</div>
</div>

As soon as the classes for columns are determined, the signatures
that are significantly different between subgroups can be looked for. 
Following are the heatmaps for signatures.




Signature heatmaps where rows are scaled:



<script>
$( function() {
	$( '#tabs-ATC-skmeans-get-signatures' ).tabs();
} );
</script>
<div id='tabs-ATC-skmeans-get-signatures'>
<ul>
<li><a href='#tab-ATC-skmeans-get-signatures-1'>k = 2</a></li>
<li><a href='#tab-ATC-skmeans-get-signatures-2'>k = 3</a></li>
<li><a href='#tab-ATC-skmeans-get-signatures-3'>k = 4</a></li>
<li><a href='#tab-ATC-skmeans-get-signatures-4'>k = 5</a></li>
<li><a href='#tab-ATC-skmeans-get-signatures-5'>k = 6</a></li>
</ul>
<div id='tab-ATC-skmeans-get-signatures-1'>
<pre><code class="language-r">get_signatures(res, k = 2)
</code></pre>
<p><img src="figure_cola/tab-ATC-skmeans-get-signatures-1-1.png" alt="plot of chunk tab-ATC-skmeans-get-signatures-1" /></p>

</div>
<div id='tab-ATC-skmeans-get-signatures-2'>
<pre><code class="language-r">get_signatures(res, k = 3)
</code></pre>
<p><img src="figure_cola/tab-ATC-skmeans-get-signatures-2-1.png" alt="plot of chunk tab-ATC-skmeans-get-signatures-2" /></p>

</div>
<div id='tab-ATC-skmeans-get-signatures-3'>
<pre><code class="language-r">get_signatures(res, k = 4)
</code></pre>
<p><img src="figure_cola/tab-ATC-skmeans-get-signatures-3-1.png" alt="plot of chunk tab-ATC-skmeans-get-signatures-3" /></p>

</div>
<div id='tab-ATC-skmeans-get-signatures-4'>
<pre><code class="language-r">get_signatures(res, k = 5)
</code></pre>
<p><img src="figure_cola/tab-ATC-skmeans-get-signatures-4-1.png" alt="plot of chunk tab-ATC-skmeans-get-signatures-4" /></p>

</div>
<div id='tab-ATC-skmeans-get-signatures-5'>
<pre><code class="language-r">get_signatures(res, k = 6)
</code></pre>
<p><img src="figure_cola/tab-ATC-skmeans-get-signatures-5-1.png" alt="plot of chunk tab-ATC-skmeans-get-signatures-5" /></p>

</div>
</div>



Signature heatmaps where rows are not scaled:


<script>
$( function() {
	$( '#tabs-ATC-skmeans-get-signatures-no-scale' ).tabs();
} );
</script>
<div id='tabs-ATC-skmeans-get-signatures-no-scale'>
<ul>
<li><a href='#tab-ATC-skmeans-get-signatures-no-scale-1'>k = 2</a></li>
<li><a href='#tab-ATC-skmeans-get-signatures-no-scale-2'>k = 3</a></li>
<li><a href='#tab-ATC-skmeans-get-signatures-no-scale-3'>k = 4</a></li>
<li><a href='#tab-ATC-skmeans-get-signatures-no-scale-4'>k = 5</a></li>
<li><a href='#tab-ATC-skmeans-get-signatures-no-scale-5'>k = 6</a></li>
</ul>
<div id='tab-ATC-skmeans-get-signatures-no-scale-1'>
<pre><code class="language-r">get_signatures(res, k = 2, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-ATC-skmeans-get-signatures-no-scale-1-1.png" alt="plot of chunk tab-ATC-skmeans-get-signatures-no-scale-1" /></p>

</div>
<div id='tab-ATC-skmeans-get-signatures-no-scale-2'>
<pre><code class="language-r">get_signatures(res, k = 3, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-ATC-skmeans-get-signatures-no-scale-2-1.png" alt="plot of chunk tab-ATC-skmeans-get-signatures-no-scale-2" /></p>

</div>
<div id='tab-ATC-skmeans-get-signatures-no-scale-3'>
<pre><code class="language-r">get_signatures(res, k = 4, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-ATC-skmeans-get-signatures-no-scale-3-1.png" alt="plot of chunk tab-ATC-skmeans-get-signatures-no-scale-3" /></p>

</div>
<div id='tab-ATC-skmeans-get-signatures-no-scale-4'>
<pre><code class="language-r">get_signatures(res, k = 5, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-ATC-skmeans-get-signatures-no-scale-4-1.png" alt="plot of chunk tab-ATC-skmeans-get-signatures-no-scale-4" /></p>

</div>
<div id='tab-ATC-skmeans-get-signatures-no-scale-5'>
<pre><code class="language-r">get_signatures(res, k = 6, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-ATC-skmeans-get-signatures-no-scale-5-1.png" alt="plot of chunk tab-ATC-skmeans-get-signatures-no-scale-5" /></p>

</div>
</div>



Compare the overlap of signatures from different k:

``` r
compare_signatures(res)
```

![plot of chunk ATC-skmeans-signature_compare](figure_cola/ATC-skmeans-signature_compare-1.png)

`get_signature()` returns a data frame invisibly. To get the list of signatures, the function
call should be assigned to a variable explicitly. In following code, if `plot` argument is set
to `FALSE`, no heatmap is plotted while only the differential analysis is performed.

``` r
# code only for demonstration
tb = get_signature(res, k = ..., plot = FALSE)
```

An example of the output of `tb` is:

```
#>   which_row         fdr    mean_1    mean_2 scaled_mean_1 scaled_mean_2 km
#> 1        38 0.042760348  8.373488  9.131774    -0.5533452     0.5164555  1
#> 2        40 0.018707592  7.106213  8.469186    -0.6173731     0.5762149  1
#> 3        55 0.019134737 10.221463 11.207825    -0.6159697     0.5749050  1
#> 4        59 0.006059896  5.921854  7.869574    -0.6899429     0.6439467  1
#> 5        60 0.018055526  8.928898 10.211722    -0.6204761     0.5791110  1
#> 6        98 0.009384629 15.714769 14.887706     0.6635654    -0.6193277  2
...
```

The columns in `tb` are:

1. `which_row`: row indices corresponding to the input matrix.
2. `fdr`: FDR for the differential test. 
3. `mean_x`: The mean value in group x.
4. `scaled_mean_x`: The mean value in group x after rows are scaled.
5. `km`: Row groups if k-means clustering is applied to rows (which is done by automatically selecting number of clusters).

If there are too many signatures, `top_signatures = ...` can be set to only show the 
signatures with the highest FDRs:

``` r
# code only for demonstration
# e.g. to show the top 500 most significant rows
tb = get_signature(res, k = ..., top_signatures = 500)
```

If the signatures are defined as these which are uniquely high in current group, `diff_method` argument
can be set to `"uniquely_high_in_one_group"`:

``` r
# code only for demonstration
tb = get_signature(res, k = ..., diff_method = "uniquely_high_in_one_group")
```




UMAP plot which shows how samples are separated.


<script>
$( function() {
	$( '#tabs-ATC-skmeans-dimension-reduction' ).tabs();
} );
</script>
<div id='tabs-ATC-skmeans-dimension-reduction'>
<ul>
<li><a href='#tab-ATC-skmeans-dimension-reduction-1'>k = 2</a></li>
<li><a href='#tab-ATC-skmeans-dimension-reduction-2'>k = 3</a></li>
<li><a href='#tab-ATC-skmeans-dimension-reduction-3'>k = 4</a></li>
<li><a href='#tab-ATC-skmeans-dimension-reduction-4'>k = 5</a></li>
<li><a href='#tab-ATC-skmeans-dimension-reduction-5'>k = 6</a></li>
</ul>
<div id='tab-ATC-skmeans-dimension-reduction-1'>
<pre><code class="language-r">dimension_reduction(res, k = 2, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-ATC-skmeans-dimension-reduction-1-1.png" alt="plot of chunk tab-ATC-skmeans-dimension-reduction-1" /></p>

</div>
<div id='tab-ATC-skmeans-dimension-reduction-2'>
<pre><code class="language-r">dimension_reduction(res, k = 3, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-ATC-skmeans-dimension-reduction-2-1.png" alt="plot of chunk tab-ATC-skmeans-dimension-reduction-2" /></p>

</div>
<div id='tab-ATC-skmeans-dimension-reduction-3'>
<pre><code class="language-r">dimension_reduction(res, k = 4, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-ATC-skmeans-dimension-reduction-3-1.png" alt="plot of chunk tab-ATC-skmeans-dimension-reduction-3" /></p>

</div>
<div id='tab-ATC-skmeans-dimension-reduction-4'>
<pre><code class="language-r">dimension_reduction(res, k = 5, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-ATC-skmeans-dimension-reduction-4-1.png" alt="plot of chunk tab-ATC-skmeans-dimension-reduction-4" /></p>

</div>
<div id='tab-ATC-skmeans-dimension-reduction-5'>
<pre><code class="language-r">dimension_reduction(res, k = 6, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-ATC-skmeans-dimension-reduction-5-1.png" alt="plot of chunk tab-ATC-skmeans-dimension-reduction-5" /></p>

</div>
</div>



Following heatmap shows how subgroups are split when increasing `k`:

``` r
collect_classes(res)
```

![plot of chunk ATC-skmeans-collect-classes](figure_cola/ATC-skmeans-collect-classes-1.png)



If matrix rows can be associated to genes, consider to use `functional_enrichment(res,
...)` to perform function enrichment for the signature genes. See [this vignette](https://jokergoo.github.io/cola_vignettes/functional_enrichment.html) for more detailed explanations.


 

---------------------------------------------------



### ATC:mclust






The object with results only for a single top-value method and a single partitioning method 
can be extracted as:

``` r
res = res_list["ATC", "mclust"]
# you can also extract it by
# res = res_list["ATC:mclust"]
```

A summary of `res` and all the functions that can be applied to it:

``` r
res
```

```
#> A 'ConsensusPartition' object with k = 2, 3, 4, 5, 6.
#>   On a matrix with 1900 rows and 60 columns.
#>   Top rows (190) are extracted by 'ATC' method.
#>   Subgroups are detected by 'mclust' method.
#>   Performed in total 250 partitions by row resampling.
#>   Best k for subgroups seems to be 4.
#> 
#> Following methods can be applied to this 'ConsensusPartition' object:
#>  [1] "cola_report"             "collect_classes"         "collect_plots"          
#>  [4] "collect_stats"           "colnames"                "compare_partitions"     
#>  [7] "compare_signatures"      "consensus_heatmap"       "dimension_reduction"    
#> [10] "functional_enrichment"   "get_anno_col"            "get_anno"               
#> [13] "get_classes"             "get_consensus"           "get_matrix"             
#> [16] "get_membership"          "get_param"               "get_signatures"         
#> [19] "get_stats"               "is_best_k"               "is_stable_k"            
#> [22] "membership_heatmap"      "ncol"                    "nrow"                   
#> [25] "plot_ecdf"               "predict_classes"         "rownames"               
#> [28] "select_partition_number" "show"                    "suggest_best_k"         
#> [31] "test_to_known_factors"   "top_rows_heatmap"
```

`collect_plots()` function collects all the plots made from `res` for all `k` (number of subgroups)
into one single page to provide an easy and fast comparison between different `k`.

``` r
collect_plots(res)
```

![plot of chunk ATC-mclust-collect-plots](figure_cola/ATC-mclust-collect-plots-1.png)

The plots are:

- The first row: a plot of the eCDF (empirical cumulative distribution
  function) curves of the consensus matrix for each `k` and the heatmap of
  predicted classes for each `k`.
- The second row: heatmaps of the consensus matrix for each `k`.
- The third row: heatmaps of the membership matrix for each `k`.
- The fouth row: heatmaps of the signatures for each `k`.

All the plots in panels can be made by individual functions and they are
plotted later in this section.

`select_partition_number()` produces several plots showing different
statistics for choosing "optimized" `k`. There are following statistics:

- eCDF curves of the consensus matrix for each `k`;
- 1-PAC. [The PAC score](https://en.wikipedia.org/wiki/Consensus_clustering#Over-interpretation_potential_of_consensus_clustering)
  measures the proportion of the ambiguous subgrouping.
- Mean silhouette score.
- Concordance. The mean probability of fiting the consensus subgroup labels in all
  partitions.
- Area increased. Denote $A_k$ as the area under the eCDF curve for current
  `k`, the area increased is defined as $A_k - A_{k-1}$.
- Rand index. The percent of pairs of samples that are both in a same cluster
  or both are not in a same cluster in the partition of k and k-1.
- Jaccard index. The ratio of pairs of samples are both in a same cluster in
  the partition of k and k-1 and the pairs of samples are both in a same
  cluster in the partition k or k-1.

The detailed explanations of these statistics can be found in [the _cola_
vignette](https://jokergoo.github.io/cola_vignettes/cola.html#toc_13).

Generally speaking, higher 1-PAC score, higher mean silhouette score or higher
concordance corresponds to better partition. Rand index and Jaccard index
measure how similar the current partition is compared to partition with `k-1`.
If they are too similar, we won't accept `k` is better than `k-1`.

``` r
select_partition_number(res)
```

![plot of chunk ATC-mclust-select-partition-number](figure_cola/ATC-mclust-select-partition-number-1.png)

The numeric values for all these statistics can be obtained by `get_stats()`.

``` r
get_stats(res)
```

```
#>   k 1-PAC mean_silhouette concordance area_increased  Rand Jaccard
#> 2 2 0.296           0.352       0.603         0.3633 0.492   0.492
#> 3 3 0.302           0.422       0.739         0.6029 0.618   0.372
#> 4 4 0.843           0.849       0.919         0.2710 0.750   0.420
#> 5 5 0.756           0.722       0.869         0.0632 0.836   0.481
#> 6 6 0.877           0.722       0.849         0.0496 0.907   0.608
```

`suggest_best_k()` suggests the best $k$ based on these statistics. The rules are as follows:

- All $k$ with Jaccard index larger than 0.95 are removed because increasing
  $k$ does not provide enough extra information. If all $k$ are removed, it is
  marked as no subgroup is detected.
- For all $k$ with 1-PAC score larger than 0.9, the maximal $k$ is taken as
  the best $k$, and other $k$ are marked as optional $k$.
- If it does not fit the second rule. The $k$ with the maximal vote of the
  highest 1-PAC score, highest mean silhouette, and highest concordance is
  taken as the best $k$.

``` r
suggest_best_k(res)
```

```
#> [1] 4
```


Following is the table of the partitions (You need to click the **show/hide
code output** link to see it). The membership matrix (columns with name `p*`)
is inferred by
[`clue::cl_consensus()`](https://www.rdocumentation.org/link/cl_consensus?package=clue)
function with the `SE` method. Basically the value in the membership matrix
represents the probability to belong to a certain group. The finall subgroup
label for an item is determined with the group with highest probability it
belongs to.

In `get_classes()` function, the entropy is calculated from the membership
matrix and the silhouette score is calculated from the consensus matrix.



<script>
$( function() {
	$( '#tabs-ATC-mclust-get-classes' ).tabs();
} );
</script>
<div id='tabs-ATC-mclust-get-classes'>
<ul>
<li><a href='#tab-ATC-mclust-get-classes-1'>k = 2</a></li>
<li><a href='#tab-ATC-mclust-get-classes-2'>k = 3</a></li>
<li><a href='#tab-ATC-mclust-get-classes-3'>k = 4</a></li>
<li><a href='#tab-ATC-mclust-get-classes-4'>k = 5</a></li>
<li><a href='#tab-ATC-mclust-get-classes-5'>k = 6</a></li>
</ul>

<div id='tab-ATC-mclust-get-classes-1'>
<p><a id='tab-ATC-mclust-get-classes-1-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 2), get_membership(res, k = 2))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2
#&gt; SIH013     2   0.990     0.3165 0.44 0.56
#&gt; SIH014     2   0.990     0.3165 0.44 0.56
#&gt; SIH024     2   0.990     0.3165 0.44 0.56
#&gt; SIH028     2   0.943     0.3746 0.36 0.64
#&gt; SIH031     1   0.981     0.2792 0.58 0.42
#&gt; SIH042     1   0.981     0.2792 0.58 0.42
#&gt; SIH107     2   0.995     0.0926 0.46 0.54
#&gt; SIH114     1   0.925     0.3352 0.66 0.34
#&gt; SIH116     1   0.999     0.0973 0.52 0.48
#&gt; SIH117     2   0.990     0.3165 0.44 0.56
#&gt; SIH130     2   0.000     0.5206 0.00 1.00
#&gt; SIH134     2   0.000     0.5206 0.00 1.00
#&gt; SIH186     2   0.995     0.0926 0.46 0.54
#&gt; SIH191     1   0.000     0.5226 1.00 0.00
#&gt; SIH192     1   0.990     0.2445 0.56 0.44
#&gt; SIH196     2   0.000     0.5206 0.00 1.00
#&gt; SIH214     2   0.000     0.5206 0.00 1.00
#&gt; SIH218     1   0.981     0.2792 0.58 0.42
#&gt; SIH232     1   0.000     0.5226 1.00 0.00
#&gt; SIH236     1   0.990     0.2445 0.56 0.44
#&gt; SIH238     1   0.981     0.2792 0.58 0.42
#&gt; SIH241     2   0.981     0.3288 0.42 0.58
#&gt; SIH245     2   0.000     0.5206 0.00 1.00
#&gt; SIH260     2   1.000    -0.0838 0.50 0.50
#&gt; SIH287     2   0.995     0.0926 0.46 0.54
#&gt; SIH289     1   0.990     0.2445 0.56 0.44
#&gt; SIH290     2   0.141     0.5214 0.02 0.98
#&gt; SIH295     1   0.000     0.5226 1.00 0.00
#&gt; SIH366     1   0.981     0.2792 0.58 0.42
#&gt; SIH377     1   0.000     0.5226 1.00 0.00
#&gt; SIH380     2   0.000     0.5206 0.00 1.00
#&gt; SIH385     2   0.990     0.3165 0.44 0.56
#&gt; SIH389     2   0.000     0.5206 0.00 1.00
#&gt; SIH391     1   0.990     0.2445 0.56 0.44
#&gt; SIH403     1   0.981     0.2792 0.58 0.42
#&gt; SIH411     2   0.000     0.5206 0.00 1.00
#&gt; SIH427     1   0.000     0.5226 1.00 0.00
#&gt; SIH433     2   0.990     0.3165 0.44 0.56
#&gt; SIH439     1   0.990     0.2445 0.56 0.44
#&gt; SIH442     1   0.000     0.5226 1.00 0.00
#&gt; SIH444     2   0.990     0.3165 0.44 0.56
#&gt; SIH452     2   0.995     0.0926 0.46 0.54
#&gt; SIH461     2   0.990     0.3165 0.44 0.56
#&gt; SIH471     1   0.000     0.5226 1.00 0.00
#&gt; SIH472     2   0.995     0.0926 0.46 0.54
#&gt; SIH481     1   0.000     0.5226 1.00 0.00
#&gt; SIH485     2   0.000     0.5206 0.00 1.00
#&gt; SIH491     2   0.242     0.5191 0.04 0.96
#&gt; SIH508     1   0.981     0.2792 0.58 0.42
#&gt; SIH559     1   0.000     0.5226 1.00 0.00
#&gt; SIH587     1   0.000     0.5226 1.00 0.00
#&gt; SIH625     1   0.990     0.2445 0.56 0.44
#&gt; SIH641     1   0.999     0.0973 0.52 0.48
#&gt; SIH643     2   0.990     0.3165 0.44 0.56
#&gt; SIH674     1   0.000     0.5226 1.00 0.00
#&gt; SIH678     1   0.000     0.5226 1.00 0.00
#&gt; SIH679     1   0.999     0.0973 0.52 0.48
#&gt; SIH689     2   0.990     0.3165 0.44 0.56
#&gt; SIH694     2   0.242     0.5195 0.04 0.96
#&gt; SIH721     2   0.990     0.3165 0.44 0.56
</code></pre>

<script>
$('#tab-ATC-mclust-get-classes-1-a').parent().next().next().hide();
$('#tab-ATC-mclust-get-classes-1-a').click(function(){
  $('#tab-ATC-mclust-get-classes-1-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-ATC-mclust-get-classes-2'>
<p><a id='tab-ATC-mclust-get-classes-2-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 3), get_membership(res, k = 3))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3
#&gt; SIH013     3  0.5746     0.4272 0.18 0.04 0.78
#&gt; SIH014     3  0.5970     0.4805 0.06 0.16 0.78
#&gt; SIH024     3  0.6176     0.4872 0.10 0.12 0.78
#&gt; SIH028     2  0.9823    -0.4260 0.26 0.42 0.32
#&gt; SIH031     1  0.8291     0.2038 0.58 0.10 0.32
#&gt; SIH042     1  0.8619     0.0382 0.48 0.10 0.42
#&gt; SIH107     1  0.9986    -0.1019 0.36 0.32 0.32
#&gt; SIH114     1  0.7665     0.2288 0.60 0.06 0.34
#&gt; SIH116     3  0.8759     0.1611 0.36 0.12 0.52
#&gt; SIH117     3  0.6176     0.4872 0.10 0.12 0.78
#&gt; SIH130     2  0.0000     0.9228 0.00 1.00 0.00
#&gt; SIH134     2  0.0000     0.9228 0.00 1.00 0.00
#&gt; SIH186     1  0.9974    -0.1189 0.36 0.30 0.34
#&gt; SIH191     1  0.0000     0.5841 1.00 0.00 0.00
#&gt; SIH192     3  0.8817     0.1271 0.38 0.12 0.50
#&gt; SIH196     2  0.0000     0.9228 0.00 1.00 0.00
#&gt; SIH214     2  0.0000     0.9228 0.00 1.00 0.00
#&gt; SIH218     1  0.8390     0.1771 0.56 0.10 0.34
#&gt; SIH232     1  0.0000     0.5841 1.00 0.00 0.00
#&gt; SIH236     3  0.8472     0.1650 0.36 0.10 0.54
#&gt; SIH238     1  0.8271     0.0945 0.52 0.08 0.40
#&gt; SIH241     3  0.9930     0.1707 0.28 0.34 0.38
#&gt; SIH245     2  0.0000     0.9228 0.00 1.00 0.00
#&gt; SIH260     3  0.8759     0.1611 0.36 0.12 0.52
#&gt; SIH287     1  0.9974    -0.0936 0.36 0.34 0.30
#&gt; SIH289     3  0.8472     0.1650 0.36 0.10 0.54
#&gt; SIH290     2  0.0000     0.9228 0.00 1.00 0.00
#&gt; SIH295     1  0.0000     0.5841 1.00 0.00 0.00
#&gt; SIH366     3  0.8619     0.0426 0.42 0.10 0.48
#&gt; SIH377     1  0.0000     0.5841 1.00 0.00 0.00
#&gt; SIH380     2  0.0000     0.9228 0.00 1.00 0.00
#&gt; SIH385     3  0.6109     0.4870 0.08 0.14 0.78
#&gt; SIH389     2  0.0892     0.9026 0.02 0.98 0.00
#&gt; SIH391     3  0.8538     0.1332 0.38 0.10 0.52
#&gt; SIH403     1  0.8291     0.2038 0.58 0.10 0.32
#&gt; SIH411     2  0.0000     0.9228 0.00 1.00 0.00
#&gt; SIH427     1  0.0000     0.5841 1.00 0.00 0.00
#&gt; SIH433     3  0.6109     0.4870 0.08 0.14 0.78
#&gt; SIH439     3  0.8472     0.1650 0.36 0.10 0.54
#&gt; SIH442     1  0.0000     0.5841 1.00 0.00 0.00
#&gt; SIH444     3  0.5970     0.4469 0.16 0.06 0.78
#&gt; SIH452     3  0.9409     0.1158 0.36 0.18 0.46
#&gt; SIH461     3  0.6109     0.4630 0.14 0.08 0.78
#&gt; SIH471     1  0.0000     0.5841 1.00 0.00 0.00
#&gt; SIH472     1  0.9986    -0.1019 0.36 0.32 0.32
#&gt; SIH481     1  0.0000     0.5841 1.00 0.00 0.00
#&gt; SIH485     2  0.0000     0.9228 0.00 1.00 0.00
#&gt; SIH491     2  0.2414     0.8541 0.04 0.94 0.02
#&gt; SIH508     1  0.8291     0.2038 0.58 0.10 0.32
#&gt; SIH559     1  0.0000     0.5841 1.00 0.00 0.00
#&gt; SIH587     1  0.0000     0.5841 1.00 0.00 0.00
#&gt; SIH625     3  0.8472     0.1650 0.36 0.10 0.54
#&gt; SIH641     1  0.8859     0.0414 0.48 0.12 0.40
#&gt; SIH643     3  0.6176     0.4872 0.10 0.12 0.78
#&gt; SIH674     1  0.0000     0.5841 1.00 0.00 0.00
#&gt; SIH678     1  0.0000     0.5841 1.00 0.00 0.00
#&gt; SIH679     3  0.8759     0.1611 0.36 0.12 0.52
#&gt; SIH689     3  0.5970     0.4805 0.06 0.16 0.78
#&gt; SIH694     2  0.0000     0.9228 0.00 1.00 0.00
#&gt; SIH721     3  0.6176     0.4872 0.10 0.12 0.78
</code></pre>

<script>
$('#tab-ATC-mclust-get-classes-2-a').parent().next().next().hide();
$('#tab-ATC-mclust-get-classes-2-a').click(function(){
  $('#tab-ATC-mclust-get-classes-2-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-ATC-mclust-get-classes-3'>
<p><a id='tab-ATC-mclust-get-classes-3-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 4), get_membership(res, k = 4))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3   p4
#&gt; SIH013     3   0.000      1.000 0.00 0.00 1.00 0.00
#&gt; SIH014     3   0.000      1.000 0.00 0.00 1.00 0.00
#&gt; SIH024     3   0.000      1.000 0.00 0.00 1.00 0.00
#&gt; SIH028     4   0.692      0.551 0.00 0.26 0.16 0.58
#&gt; SIH031     4   0.677      0.384 0.38 0.00 0.10 0.52
#&gt; SIH042     4   0.141      0.819 0.02 0.00 0.02 0.96
#&gt; SIH107     4   0.164      0.820 0.00 0.06 0.00 0.94
#&gt; SIH114     1   0.479      0.192 0.62 0.00 0.00 0.38
#&gt; SIH116     4   0.164      0.820 0.00 0.06 0.00 0.94
#&gt; SIH117     3   0.000      1.000 0.00 0.00 1.00 0.00
#&gt; SIH130     2   0.000      0.987 0.00 1.00 0.00 0.00
#&gt; SIH134     2   0.000      0.987 0.00 1.00 0.00 0.00
#&gt; SIH186     4   0.164      0.820 0.00 0.06 0.00 0.94
#&gt; SIH191     1   0.000      0.961 1.00 0.00 0.00 0.00
#&gt; SIH192     4   0.000      0.820 0.00 0.00 0.00 1.00
#&gt; SIH196     2   0.000      0.987 0.00 1.00 0.00 0.00
#&gt; SIH214     2   0.000      0.987 0.00 1.00 0.00 0.00
#&gt; SIH218     4   0.630      0.361 0.06 0.00 0.42 0.52
#&gt; SIH232     1   0.000      0.961 1.00 0.00 0.00 0.00
#&gt; SIH236     4   0.000      0.820 0.00 0.00 0.00 1.00
#&gt; SIH238     4   0.659      0.336 0.08 0.00 0.42 0.50
#&gt; SIH241     4   0.767      0.382 0.00 0.26 0.28 0.46
#&gt; SIH245     2   0.000      0.987 0.00 1.00 0.00 0.00
#&gt; SIH260     4   0.164      0.820 0.00 0.06 0.00 0.94
#&gt; SIH287     4   0.201      0.809 0.00 0.08 0.00 0.92
#&gt; SIH289     4   0.000      0.820 0.00 0.00 0.00 1.00
#&gt; SIH290     2   0.000      0.987 0.00 1.00 0.00 0.00
#&gt; SIH295     1   0.000      0.961 1.00 0.00 0.00 0.00
#&gt; SIH366     4   0.164      0.808 0.06 0.00 0.00 0.94
#&gt; SIH377     1   0.000      0.961 1.00 0.00 0.00 0.00
#&gt; SIH380     2   0.000      0.987 0.00 1.00 0.00 0.00
#&gt; SIH385     3   0.000      1.000 0.00 0.00 1.00 0.00
#&gt; SIH389     2   0.164      0.934 0.00 0.94 0.00 0.06
#&gt; SIH391     4   0.000      0.820 0.00 0.00 0.00 1.00
#&gt; SIH403     4   0.694      0.407 0.36 0.00 0.12 0.52
#&gt; SIH411     2   0.000      0.987 0.00 1.00 0.00 0.00
#&gt; SIH427     1   0.000      0.961 1.00 0.00 0.00 0.00
#&gt; SIH433     3   0.000      1.000 0.00 0.00 1.00 0.00
#&gt; SIH439     4   0.000      0.820 0.00 0.00 0.00 1.00
#&gt; SIH442     1   0.000      0.961 1.00 0.00 0.00 0.00
#&gt; SIH444     3   0.000      1.000 0.00 0.00 1.00 0.00
#&gt; SIH452     4   0.164      0.820 0.00 0.06 0.00 0.94
#&gt; SIH461     3   0.000      1.000 0.00 0.00 1.00 0.00
#&gt; SIH471     1   0.000      0.961 1.00 0.00 0.00 0.00
#&gt; SIH472     4   0.164      0.820 0.00 0.06 0.00 0.94
#&gt; SIH481     1   0.000      0.961 1.00 0.00 0.00 0.00
#&gt; SIH485     2   0.000      0.987 0.00 1.00 0.00 0.00
#&gt; SIH491     2   0.164      0.926 0.00 0.94 0.00 0.06
#&gt; SIH508     4   0.694      0.407 0.36 0.00 0.12 0.52
#&gt; SIH559     1   0.000      0.961 1.00 0.00 0.00 0.00
#&gt; SIH587     1   0.000      0.961 1.00 0.00 0.00 0.00
#&gt; SIH625     4   0.000      0.820 0.00 0.00 0.00 1.00
#&gt; SIH641     4   0.653      0.546 0.30 0.02 0.06 0.62
#&gt; SIH643     3   0.000      1.000 0.00 0.00 1.00 0.00
#&gt; SIH674     1   0.000      0.961 1.00 0.00 0.00 0.00
#&gt; SIH678     1   0.000      0.961 1.00 0.00 0.00 0.00
#&gt; SIH679     4   0.191      0.817 0.04 0.02 0.00 0.94
#&gt; SIH689     3   0.000      1.000 0.00 0.00 1.00 0.00
#&gt; SIH694     2   0.000      0.987 0.00 1.00 0.00 0.00
#&gt; SIH721     3   0.000      1.000 0.00 0.00 1.00 0.00
</code></pre>

<script>
$('#tab-ATC-mclust-get-classes-3-a').parent().next().next().hide();
$('#tab-ATC-mclust-get-classes-3-a').click(function(){
  $('#tab-ATC-mclust-get-classes-3-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-ATC-mclust-get-classes-4'>
<p><a id='tab-ATC-mclust-get-classes-4-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 5), get_membership(res, k = 5))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3   p4   p5
#&gt; SIH013     3  0.2516    0.77983 0.00 0.00 0.86 0.14 0.00
#&gt; SIH014     3  0.0000    0.86267 0.00 0.00 1.00 0.00 0.00
#&gt; SIH024     3  0.0000    0.86267 0.00 0.00 1.00 0.00 0.00
#&gt; SIH028     2  0.7171   -0.00491 0.12 0.42 0.40 0.06 0.00
#&gt; SIH031     5  0.7833    0.25914 0.16 0.00 0.16 0.20 0.48
#&gt; SIH042     4  0.6156    0.50301 0.20 0.00 0.12 0.64 0.04
#&gt; SIH107     1  0.2616    0.66422 0.88 0.02 0.00 0.10 0.00
#&gt; SIH114     5  0.5414    0.47519 0.14 0.00 0.00 0.20 0.66
#&gt; SIH116     1  0.5579    0.49048 0.60 0.00 0.00 0.30 0.10
#&gt; SIH117     3  0.0000    0.86267 0.00 0.00 1.00 0.00 0.00
#&gt; SIH130     2  0.0000    0.93878 0.00 1.00 0.00 0.00 0.00
#&gt; SIH134     2  0.0000    0.93878 0.00 1.00 0.00 0.00 0.00
#&gt; SIH186     1  0.3037    0.66628 0.86 0.04 0.00 0.10 0.00
#&gt; SIH191     5  0.0000    0.84339 0.00 0.00 0.00 0.00 1.00
#&gt; SIH192     4  0.0000    0.80628 0.00 0.00 0.00 1.00 0.00
#&gt; SIH196     2  0.0000    0.93878 0.00 1.00 0.00 0.00 0.00
#&gt; SIH214     2  0.0609    0.92438 0.02 0.98 0.00 0.00 0.00
#&gt; SIH218     3  0.6352    0.51477 0.14 0.00 0.62 0.20 0.04
#&gt; SIH232     5  0.0000    0.84339 0.00 0.00 0.00 0.00 1.00
#&gt; SIH236     4  0.0000    0.80628 0.00 0.00 0.00 1.00 0.00
#&gt; SIH238     3  0.6352    0.51943 0.14 0.00 0.62 0.20 0.04
#&gt; SIH241     3  0.6482    0.43197 0.08 0.28 0.58 0.06 0.00
#&gt; SIH245     2  0.0000    0.93878 0.00 1.00 0.00 0.00 0.00
#&gt; SIH260     1  0.5220    0.44485 0.58 0.02 0.00 0.38 0.02
#&gt; SIH287     1  0.4437    0.64423 0.76 0.10 0.00 0.14 0.00
#&gt; SIH289     4  0.2516    0.71789 0.14 0.00 0.00 0.86 0.00
#&gt; SIH290     2  0.0000    0.93878 0.00 1.00 0.00 0.00 0.00
#&gt; SIH295     5  0.0000    0.84339 0.00 0.00 0.00 0.00 1.00
#&gt; SIH366     4  0.6200    0.22081 0.32 0.00 0.00 0.52 0.16
#&gt; SIH377     5  0.0000    0.84339 0.00 0.00 0.00 0.00 1.00
#&gt; SIH380     2  0.0000    0.93878 0.00 1.00 0.00 0.00 0.00
#&gt; SIH385     3  0.0000    0.86267 0.00 0.00 1.00 0.00 0.00
#&gt; SIH389     2  0.1410    0.89230 0.06 0.94 0.00 0.00 0.00
#&gt; SIH391     4  0.1043    0.80757 0.04 0.00 0.00 0.96 0.00
#&gt; SIH403     5  0.8155    0.17037 0.16 0.00 0.22 0.20 0.42
#&gt; SIH411     2  0.0000    0.93878 0.00 1.00 0.00 0.00 0.00
#&gt; SIH427     5  0.0000    0.84339 0.00 0.00 0.00 0.00 1.00
#&gt; SIH433     3  0.0000    0.86267 0.00 0.00 1.00 0.00 0.00
#&gt; SIH439     4  0.0000    0.80628 0.00 0.00 0.00 1.00 0.00
#&gt; SIH442     5  0.0000    0.84339 0.00 0.00 0.00 0.00 1.00
#&gt; SIH444     3  0.2732    0.75974 0.00 0.00 0.84 0.16 0.00
#&gt; SIH452     1  0.3319    0.66518 0.82 0.02 0.00 0.16 0.00
#&gt; SIH461     3  0.1732    0.82427 0.00 0.00 0.92 0.08 0.00
#&gt; SIH471     5  0.0000    0.84339 0.00 0.00 0.00 0.00 1.00
#&gt; SIH472     1  0.3037    0.66628 0.86 0.04 0.00 0.10 0.00
#&gt; SIH481     5  0.0000    0.84339 0.00 0.00 0.00 0.00 1.00
#&gt; SIH485     2  0.0000    0.93878 0.00 1.00 0.00 0.00 0.00
#&gt; SIH491     2  0.1043    0.90906 0.04 0.96 0.00 0.00 0.00
#&gt; SIH508     5  0.8155    0.17276 0.16 0.00 0.22 0.20 0.42
#&gt; SIH559     5  0.0000    0.84339 0.00 0.00 0.00 0.00 1.00
#&gt; SIH587     5  0.0000    0.84339 0.00 0.00 0.00 0.00 1.00
#&gt; SIH625     4  0.1043    0.80757 0.04 0.00 0.00 0.96 0.00
#&gt; SIH641     1  0.7864    0.11712 0.42 0.02 0.04 0.22 0.30
#&gt; SIH643     3  0.0000    0.86267 0.00 0.00 1.00 0.00 0.00
#&gt; SIH674     5  0.0000    0.84339 0.00 0.00 0.00 0.00 1.00
#&gt; SIH678     5  0.0000    0.84339 0.00 0.00 0.00 0.00 1.00
#&gt; SIH679     1  0.6275    0.40116 0.52 0.00 0.00 0.30 0.18
#&gt; SIH689     3  0.0000    0.86267 0.00 0.00 1.00 0.00 0.00
#&gt; SIH694     2  0.0000    0.93878 0.00 1.00 0.00 0.00 0.00
#&gt; SIH721     3  0.0000    0.86267 0.00 0.00 1.00 0.00 0.00
</code></pre>

<script>
$('#tab-ATC-mclust-get-classes-4-a').parent().next().next().hide();
$('#tab-ATC-mclust-get-classes-4-a').click(function(){
  $('#tab-ATC-mclust-get-classes-4-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>

<div id='tab-ATC-mclust-get-classes-5'>
<p><a id='tab-ATC-mclust-get-classes-5-a' style='color:#0366d6' href='#'>show/hide code output</a></p>
<pre><code class="language-r">cbind(get_classes(res, k = 6), get_membership(res, k = 6))
</code></pre>
<pre><code>#&gt;        class entropy silhouette   p1   p2   p3   p4   p5   p6
#&gt; SIH013     3  0.0000      0.907 0.00 0.00 1.00 0.00 0.00 0.00
#&gt; SIH014     3  0.0547      0.892 0.00 0.00 0.98 0.02 0.00 0.00
#&gt; SIH024     3  0.0000      0.907 0.00 0.00 1.00 0.00 0.00 0.00
#&gt; SIH028     3  0.6305      0.237 0.00 0.30 0.46 0.02 0.00 0.22
#&gt; SIH031     1  0.4534      0.958 0.58 0.00 0.00 0.00 0.04 0.38
#&gt; SIH042     6  0.4282      0.169 0.02 0.00 0.00 0.42 0.00 0.56
#&gt; SIH107     6  0.3756      0.380 0.40 0.00 0.00 0.00 0.00 0.60
#&gt; SIH114     6  0.6077     -0.481 0.30 0.00 0.00 0.00 0.30 0.40
#&gt; SIH116     6  0.2793      0.326 0.00 0.00 0.00 0.20 0.00 0.80
#&gt; SIH117     3  0.0000      0.907 0.00 0.00 1.00 0.00 0.00 0.00
#&gt; SIH130     2  0.0000      0.993 0.00 1.00 0.00 0.00 0.00 0.00
#&gt; SIH134     2  0.0000      0.993 0.00 1.00 0.00 0.00 0.00 0.00
#&gt; SIH186     6  0.3756      0.380 0.40 0.00 0.00 0.00 0.00 0.60
#&gt; SIH191     5  0.1807      0.921 0.02 0.00 0.00 0.00 0.92 0.06
#&gt; SIH192     4  0.0000      0.893 0.00 0.00 0.00 1.00 0.00 0.00
#&gt; SIH196     2  0.0000      0.993 0.00 1.00 0.00 0.00 0.00 0.00
#&gt; SIH214     2  0.0000      0.993 0.00 1.00 0.00 0.00 0.00 0.00
#&gt; SIH218     6  0.7251     -0.442 0.28 0.00 0.20 0.12 0.00 0.40
#&gt; SIH232     5  0.0000      0.975 0.00 0.00 0.00 0.00 1.00 0.00
#&gt; SIH236     4  0.0000      0.893 0.00 0.00 0.00 1.00 0.00 0.00
#&gt; SIH238     6  0.7088     -0.510 0.32 0.00 0.18 0.10 0.00 0.40
#&gt; SIH241     3  0.5288      0.316 0.00 0.38 0.54 0.02 0.00 0.06
#&gt; SIH245     2  0.0000      0.993 0.00 1.00 0.00 0.00 0.00 0.00
#&gt; SIH260     6  0.3076      0.328 0.00 0.00 0.00 0.24 0.00 0.76
#&gt; SIH287     6  0.6088      0.352 0.38 0.06 0.00 0.08 0.00 0.48
#&gt; SIH289     4  0.3198      0.615 0.00 0.00 0.00 0.74 0.00 0.26
#&gt; SIH290     2  0.0000      0.993 0.00 1.00 0.00 0.00 0.00 0.00
#&gt; SIH295     5  0.0000      0.975 0.00 0.00 0.00 0.00 1.00 0.00
#&gt; SIH366     6  0.4002      0.235 0.00 0.00 0.00 0.32 0.02 0.66
#&gt; SIH377     5  0.0000      0.975 0.00 0.00 0.00 0.00 1.00 0.00
#&gt; SIH380     2  0.0000      0.993 0.00 1.00 0.00 0.00 0.00 0.00
#&gt; SIH385     3  0.0000      0.907 0.00 0.00 1.00 0.00 0.00 0.00
#&gt; SIH389     2  0.1556      0.914 0.00 0.92 0.00 0.00 0.00 0.08
#&gt; SIH391     4  0.0937      0.885 0.00 0.00 0.00 0.96 0.00 0.04
#&gt; SIH403     1  0.4246      0.979 0.58 0.00 0.00 0.00 0.02 0.40
#&gt; SIH411     2  0.0000      0.993 0.00 1.00 0.00 0.00 0.00 0.00
#&gt; SIH427     5  0.1807      0.921 0.02 0.00 0.00 0.00 0.92 0.06
#&gt; SIH433     3  0.0000      0.907 0.00 0.00 1.00 0.00 0.00 0.00
#&gt; SIH439     4  0.0000      0.893 0.00 0.00 0.00 1.00 0.00 0.00
#&gt; SIH442     5  0.0000      0.975 0.00 0.00 0.00 0.00 1.00 0.00
#&gt; SIH444     3  0.0547      0.891 0.00 0.00 0.98 0.00 0.00 0.02
#&gt; SIH452     6  0.5555      0.338 0.38 0.00 0.00 0.14 0.00 0.48
#&gt; SIH461     3  0.0000      0.907 0.00 0.00 1.00 0.00 0.00 0.00
#&gt; SIH471     5  0.0547      0.964 0.00 0.00 0.00 0.00 0.98 0.02
#&gt; SIH472     6  0.3756      0.380 0.40 0.00 0.00 0.00 0.00 0.60
#&gt; SIH481     5  0.1480      0.938 0.02 0.00 0.00 0.00 0.94 0.04
#&gt; SIH485     2  0.0000      0.993 0.00 1.00 0.00 0.00 0.00 0.00
#&gt; SIH491     2  0.0000      0.993 0.00 1.00 0.00 0.00 0.00 0.00
#&gt; SIH508     1  0.4246      0.979 0.58 0.00 0.00 0.00 0.02 0.40
#&gt; SIH559     5  0.0000      0.975 0.00 0.00 0.00 0.00 1.00 0.00
#&gt; SIH587     5  0.0000      0.975 0.00 0.00 0.00 0.00 1.00 0.00
#&gt; SIH625     4  0.1814      0.844 0.00 0.00 0.00 0.90 0.00 0.10
#&gt; SIH641     6  0.4574     -0.258 0.26 0.00 0.00 0.02 0.04 0.68
#&gt; SIH643     3  0.0000      0.907 0.00 0.00 1.00 0.00 0.00 0.00
#&gt; SIH674     5  0.0000      0.975 0.00 0.00 0.00 0.00 1.00 0.00
#&gt; SIH678     5  0.0000      0.975 0.00 0.00 0.00 0.00 1.00 0.00
#&gt; SIH679     6  0.3156      0.301 0.02 0.00 0.00 0.18 0.00 0.80
#&gt; SIH689     3  0.0000      0.907 0.00 0.00 1.00 0.00 0.00 0.00
#&gt; SIH694     2  0.0000      0.993 0.00 1.00 0.00 0.00 0.00 0.00
#&gt; SIH721     3  0.0000      0.907 0.00 0.00 1.00 0.00 0.00 0.00
</code></pre>

<script>
$('#tab-ATC-mclust-get-classes-5-a').parent().next().next().hide();
$('#tab-ATC-mclust-get-classes-5-a').click(function(){
  $('#tab-ATC-mclust-get-classes-5-a').parent().next().next().toggle();
  return(false);
});
</script>
</div>
</div>

Heatmaps for the consensus matrix. It visualizes the probability of two
samples to be in a same group.




<script>
$( function() {
	$( '#tabs-ATC-mclust-consensus-heatmap' ).tabs();
} );
</script>
<div id='tabs-ATC-mclust-consensus-heatmap'>
<ul>
<li><a href='#tab-ATC-mclust-consensus-heatmap-1'>k = 2</a></li>
<li><a href='#tab-ATC-mclust-consensus-heatmap-2'>k = 3</a></li>
<li><a href='#tab-ATC-mclust-consensus-heatmap-3'>k = 4</a></li>
<li><a href='#tab-ATC-mclust-consensus-heatmap-4'>k = 5</a></li>
<li><a href='#tab-ATC-mclust-consensus-heatmap-5'>k = 6</a></li>
</ul>
<div id='tab-ATC-mclust-consensus-heatmap-1'>
<pre><code class="language-r">consensus_heatmap(res, k = 2)
</code></pre>
<p><img src="figure_cola/tab-ATC-mclust-consensus-heatmap-1-1.png" alt="plot of chunk tab-ATC-mclust-consensus-heatmap-1" /></p>

</div>
<div id='tab-ATC-mclust-consensus-heatmap-2'>
<pre><code class="language-r">consensus_heatmap(res, k = 3)
</code></pre>
<p><img src="figure_cola/tab-ATC-mclust-consensus-heatmap-2-1.png" alt="plot of chunk tab-ATC-mclust-consensus-heatmap-2" /></p>

</div>
<div id='tab-ATC-mclust-consensus-heatmap-3'>
<pre><code class="language-r">consensus_heatmap(res, k = 4)
</code></pre>
<p><img src="figure_cola/tab-ATC-mclust-consensus-heatmap-3-1.png" alt="plot of chunk tab-ATC-mclust-consensus-heatmap-3" /></p>

</div>
<div id='tab-ATC-mclust-consensus-heatmap-4'>
<pre><code class="language-r">consensus_heatmap(res, k = 5)
</code></pre>
<p><img src="figure_cola/tab-ATC-mclust-consensus-heatmap-4-1.png" alt="plot of chunk tab-ATC-mclust-consensus-heatmap-4" /></p>

</div>
<div id='tab-ATC-mclust-consensus-heatmap-5'>
<pre><code class="language-r">consensus_heatmap(res, k = 6)
</code></pre>
<p><img src="figure_cola/tab-ATC-mclust-consensus-heatmap-5-1.png" alt="plot of chunk tab-ATC-mclust-consensus-heatmap-5" /></p>

</div>
</div>

Heatmaps for the membership of samples in all partitions to see how consistent they are:





<script>
$( function() {
	$( '#tabs-ATC-mclust-membership-heatmap' ).tabs();
} );
</script>
<div id='tabs-ATC-mclust-membership-heatmap'>
<ul>
<li><a href='#tab-ATC-mclust-membership-heatmap-1'>k = 2</a></li>
<li><a href='#tab-ATC-mclust-membership-heatmap-2'>k = 3</a></li>
<li><a href='#tab-ATC-mclust-membership-heatmap-3'>k = 4</a></li>
<li><a href='#tab-ATC-mclust-membership-heatmap-4'>k = 5</a></li>
<li><a href='#tab-ATC-mclust-membership-heatmap-5'>k = 6</a></li>
</ul>
<div id='tab-ATC-mclust-membership-heatmap-1'>
<pre><code class="language-r">membership_heatmap(res, k = 2)
</code></pre>
<p><img src="figure_cola/tab-ATC-mclust-membership-heatmap-1-1.png" alt="plot of chunk tab-ATC-mclust-membership-heatmap-1" /></p>

</div>
<div id='tab-ATC-mclust-membership-heatmap-2'>
<pre><code class="language-r">membership_heatmap(res, k = 3)
</code></pre>
<p><img src="figure_cola/tab-ATC-mclust-membership-heatmap-2-1.png" alt="plot of chunk tab-ATC-mclust-membership-heatmap-2" /></p>

</div>
<div id='tab-ATC-mclust-membership-heatmap-3'>
<pre><code class="language-r">membership_heatmap(res, k = 4)
</code></pre>
<p><img src="figure_cola/tab-ATC-mclust-membership-heatmap-3-1.png" alt="plot of chunk tab-ATC-mclust-membership-heatmap-3" /></p>

</div>
<div id='tab-ATC-mclust-membership-heatmap-4'>
<pre><code class="language-r">membership_heatmap(res, k = 5)
</code></pre>
<p><img src="figure_cola/tab-ATC-mclust-membership-heatmap-4-1.png" alt="plot of chunk tab-ATC-mclust-membership-heatmap-4" /></p>

</div>
<div id='tab-ATC-mclust-membership-heatmap-5'>
<pre><code class="language-r">membership_heatmap(res, k = 6)
</code></pre>
<p><img src="figure_cola/tab-ATC-mclust-membership-heatmap-5-1.png" alt="plot of chunk tab-ATC-mclust-membership-heatmap-5" /></p>

</div>
</div>

As soon as the classes for columns are determined, the signatures
that are significantly different between subgroups can be looked for. 
Following are the heatmaps for signatures.




Signature heatmaps where rows are scaled:



<script>
$( function() {
	$( '#tabs-ATC-mclust-get-signatures' ).tabs();
} );
</script>
<div id='tabs-ATC-mclust-get-signatures'>
<ul>
<li><a href='#tab-ATC-mclust-get-signatures-1'>k = 2</a></li>
<li><a href='#tab-ATC-mclust-get-signatures-2'>k = 3</a></li>
<li><a href='#tab-ATC-mclust-get-signatures-3'>k = 4</a></li>
<li><a href='#tab-ATC-mclust-get-signatures-4'>k = 5</a></li>
<li><a href='#tab-ATC-mclust-get-signatures-5'>k = 6</a></li>
</ul>
<div id='tab-ATC-mclust-get-signatures-1'>
<pre><code class="language-r">get_signatures(res, k = 2)
</code></pre>
<p><img src="figure_cola/tab-ATC-mclust-get-signatures-1-1.png" alt="plot of chunk tab-ATC-mclust-get-signatures-1" /></p>

</div>
<div id='tab-ATC-mclust-get-signatures-2'>
<pre><code class="language-r">get_signatures(res, k = 3)
</code></pre>
<p><img src="figure_cola/tab-ATC-mclust-get-signatures-2-1.png" alt="plot of chunk tab-ATC-mclust-get-signatures-2" /></p>

</div>
<div id='tab-ATC-mclust-get-signatures-3'>
<pre><code class="language-r">get_signatures(res, k = 4)
</code></pre>
<p><img src="figure_cola/tab-ATC-mclust-get-signatures-3-1.png" alt="plot of chunk tab-ATC-mclust-get-signatures-3" /></p>

</div>
<div id='tab-ATC-mclust-get-signatures-4'>
<pre><code class="language-r">get_signatures(res, k = 5)
</code></pre>
<p><img src="figure_cola/tab-ATC-mclust-get-signatures-4-1.png" alt="plot of chunk tab-ATC-mclust-get-signatures-4" /></p>

</div>
<div id='tab-ATC-mclust-get-signatures-5'>
<pre><code class="language-r">get_signatures(res, k = 6)
</code></pre>
<p><img src="figure_cola/tab-ATC-mclust-get-signatures-5-1.png" alt="plot of chunk tab-ATC-mclust-get-signatures-5" /></p>

</div>
</div>



Signature heatmaps where rows are not scaled:


<script>
$( function() {
	$( '#tabs-ATC-mclust-get-signatures-no-scale' ).tabs();
} );
</script>
<div id='tabs-ATC-mclust-get-signatures-no-scale'>
<ul>
<li><a href='#tab-ATC-mclust-get-signatures-no-scale-1'>k = 2</a></li>
<li><a href='#tab-ATC-mclust-get-signatures-no-scale-2'>k = 3</a></li>
<li><a href='#tab-ATC-mclust-get-signatures-no-scale-3'>k = 4</a></li>
<li><a href='#tab-ATC-mclust-get-signatures-no-scale-4'>k = 5</a></li>
<li><a href='#tab-ATC-mclust-get-signatures-no-scale-5'>k = 6</a></li>
</ul>
<div id='tab-ATC-mclust-get-signatures-no-scale-1'>
<pre><code class="language-r">get_signatures(res, k = 2, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-ATC-mclust-get-signatures-no-scale-1-1.png" alt="plot of chunk tab-ATC-mclust-get-signatures-no-scale-1" /></p>

</div>
<div id='tab-ATC-mclust-get-signatures-no-scale-2'>
<pre><code class="language-r">get_signatures(res, k = 3, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-ATC-mclust-get-signatures-no-scale-2-1.png" alt="plot of chunk tab-ATC-mclust-get-signatures-no-scale-2" /></p>

</div>
<div id='tab-ATC-mclust-get-signatures-no-scale-3'>
<pre><code class="language-r">get_signatures(res, k = 4, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-ATC-mclust-get-signatures-no-scale-3-1.png" alt="plot of chunk tab-ATC-mclust-get-signatures-no-scale-3" /></p>

</div>
<div id='tab-ATC-mclust-get-signatures-no-scale-4'>
<pre><code class="language-r">get_signatures(res, k = 5, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-ATC-mclust-get-signatures-no-scale-4-1.png" alt="plot of chunk tab-ATC-mclust-get-signatures-no-scale-4" /></p>

</div>
<div id='tab-ATC-mclust-get-signatures-no-scale-5'>
<pre><code class="language-r">get_signatures(res, k = 6, scale_rows = FALSE)
</code></pre>
<p><img src="figure_cola/tab-ATC-mclust-get-signatures-no-scale-5-1.png" alt="plot of chunk tab-ATC-mclust-get-signatures-no-scale-5" /></p>

</div>
</div>



Compare the overlap of signatures from different k:

``` r
compare_signatures(res)
```

![plot of chunk ATC-mclust-signature_compare](figure_cola/ATC-mclust-signature_compare-1.png)

`get_signature()` returns a data frame invisibly. To get the list of signatures, the function
call should be assigned to a variable explicitly. In following code, if `plot` argument is set
to `FALSE`, no heatmap is plotted while only the differential analysis is performed.

``` r
# code only for demonstration
tb = get_signature(res, k = ..., plot = FALSE)
```

An example of the output of `tb` is:

```
#>   which_row         fdr    mean_1    mean_2 scaled_mean_1 scaled_mean_2 km
#> 1        38 0.042760348  8.373488  9.131774    -0.5533452     0.5164555  1
#> 2        40 0.018707592  7.106213  8.469186    -0.6173731     0.5762149  1
#> 3        55 0.019134737 10.221463 11.207825    -0.6159697     0.5749050  1
#> 4        59 0.006059896  5.921854  7.869574    -0.6899429     0.6439467  1
#> 5        60 0.018055526  8.928898 10.211722    -0.6204761     0.5791110  1
#> 6        98 0.009384629 15.714769 14.887706     0.6635654    -0.6193277  2
...
```

The columns in `tb` are:

1. `which_row`: row indices corresponding to the input matrix.
2. `fdr`: FDR for the differential test. 
3. `mean_x`: The mean value in group x.
4. `scaled_mean_x`: The mean value in group x after rows are scaled.
5. `km`: Row groups if k-means clustering is applied to rows (which is done by automatically selecting number of clusters).

If there are too many signatures, `top_signatures = ...` can be set to only show the 
signatures with the highest FDRs:

``` r
# code only for demonstration
# e.g. to show the top 500 most significant rows
tb = get_signature(res, k = ..., top_signatures = 500)
```

If the signatures are defined as these which are uniquely high in current group, `diff_method` argument
can be set to `"uniquely_high_in_one_group"`:

``` r
# code only for demonstration
tb = get_signature(res, k = ..., diff_method = "uniquely_high_in_one_group")
```




UMAP plot which shows how samples are separated.


<script>
$( function() {
	$( '#tabs-ATC-mclust-dimension-reduction' ).tabs();
} );
</script>
<div id='tabs-ATC-mclust-dimension-reduction'>
<ul>
<li><a href='#tab-ATC-mclust-dimension-reduction-1'>k = 2</a></li>
<li><a href='#tab-ATC-mclust-dimension-reduction-2'>k = 3</a></li>
<li><a href='#tab-ATC-mclust-dimension-reduction-3'>k = 4</a></li>
<li><a href='#tab-ATC-mclust-dimension-reduction-4'>k = 5</a></li>
<li><a href='#tab-ATC-mclust-dimension-reduction-5'>k = 6</a></li>
</ul>
<div id='tab-ATC-mclust-dimension-reduction-1'>
<pre><code class="language-r">dimension_reduction(res, k = 2, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-ATC-mclust-dimension-reduction-1-1.png" alt="plot of chunk tab-ATC-mclust-dimension-reduction-1" /></p>

</div>
<div id='tab-ATC-mclust-dimension-reduction-2'>
<pre><code class="language-r">dimension_reduction(res, k = 3, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-ATC-mclust-dimension-reduction-2-1.png" alt="plot of chunk tab-ATC-mclust-dimension-reduction-2" /></p>

</div>
<div id='tab-ATC-mclust-dimension-reduction-3'>
<pre><code class="language-r">dimension_reduction(res, k = 4, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-ATC-mclust-dimension-reduction-3-1.png" alt="plot of chunk tab-ATC-mclust-dimension-reduction-3" /></p>

</div>
<div id='tab-ATC-mclust-dimension-reduction-4'>
<pre><code class="language-r">dimension_reduction(res, k = 5, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-ATC-mclust-dimension-reduction-4-1.png" alt="plot of chunk tab-ATC-mclust-dimension-reduction-4" /></p>

</div>
<div id='tab-ATC-mclust-dimension-reduction-5'>
<pre><code class="language-r">dimension_reduction(res, k = 6, method = &quot;UMAP&quot;)
</code></pre>
<p><img src="figure_cola/tab-ATC-mclust-dimension-reduction-5-1.png" alt="plot of chunk tab-ATC-mclust-dimension-reduction-5" /></p>

</div>
</div>



Following heatmap shows how subgroups are split when increasing `k`:

``` r
collect_classes(res)
```

![plot of chunk ATC-mclust-collect-classes](figure_cola/ATC-mclust-collect-classes-1.png)



If matrix rows can be associated to genes, consider to use `functional_enrichment(res,
...)` to perform function enrichment for the signature genes. See [this vignette](https://jokergoo.github.io/cola_vignettes/functional_enrichment.html) for more detailed explanations.


 

## Session info


``` r
sessionInfo()
```

```
#> R version 4.5.0 (2025-04-11)
#> Platform: x86_64-pc-linux-gnu
#> Running under: Ubuntu 24.04.3 LTS
#> 
#> Matrix products: default
#> BLAS:   /usr/lib/x86_64-linux-gnu/openblas-pthread/libblas.so.3 
#> LAPACK: /usr/lib/x86_64-linux-gnu/openblas-pthread/libopenblasp-r0.3.26.so;  LAPACK version 3.12.0
#> 
#> Random number generation:
#>  RNG:     L'Ecuyer-CMRG 
#>  Normal:  Inversion 
#>  Sample:  Rejection 
#>  
#> locale:
#>  [1] LC_CTYPE=C.UTF-8       LC_NUMERIC=C           LC_TIME=C.UTF-8        LC_COLLATE=C.UTF-8    
#>  [5] LC_MONETARY=C.UTF-8    LC_MESSAGES=C.UTF-8    LC_PAPER=C.UTF-8       LC_NAME=C             
#>  [9] LC_ADDRESS=C           LC_TELEPHONE=C         LC_MEASUREMENT=C.UTF-8 LC_IDENTIFICATION=C   
#> 
#> time zone: Asia/Shanghai
#> tzcode source: system (glibc)
#> 
#> attached base packages:
#> [1] grid      stats     graphics  grDevices utils     datasets  methods   base     
#> 
#> other attached packages:
#> [1] genefilter_1.90.0     ComplexHeatmap_2.24.1 markdown_2.0          knitr_1.50           
#> [5] doRNG_1.8.6.2         rngtools_1.5.2        foreach_1.5.2         cola_2.14.0          
#> 
#> loaded via a namespace (and not attached):
#>  [1] blob_1.2.4              Biostrings_2.76.0       fastmap_1.2.0           XML_3.99-0.19          
#>  [5] digest_0.6.37           cluster_2.1.8.1         Cairo_1.6-5             survival_3.8-3         
#>  [9] KEGGREST_1.48.1         RSQLite_2.4.3           polylabelr_0.3.0        magrittr_2.0.4         
#> [13] compiler_4.5.0          rlang_1.1.6             tools_4.5.0             askpass_1.2.1          
#> [17] brew_1.0-10             bit_4.6.0               mclust_6.1.1            reticulate_1.43.0      
#> [21] xml2_1.4.0              eulerr_7.0.4            RColorBrewer_1.1-3      BiocGenerics_0.54.0    
#> [25] polyclip_1.10-7         stats4_4.5.0            xtable_1.8-4            colorspace_2.1-2       
#> [29] iterators_1.0.14        cli_3.6.5               crayon_1.5.3            generics_0.1.4         
#> [33] umap_0.2.10.0           RSpectra_0.16-2         httr_1.4.7              rjson_0.2.23           
#> [37] commonmark_2.0.0        DBI_1.2.3               cachem_1.1.0            splines_4.5.0          
#> [41] parallel_4.5.0          AnnotationDbi_1.70.0    impute_1.82.0           BiocManager_1.30.26    
#> [45] XVector_0.48.0          matrixStats_1.5.0       vctrs_0.6.5             Matrix_1.7-4           
#> [49] jsonlite_2.0.0          slam_0.1-55             litedown_0.7            IRanges_2.42.0         
#> [53] GetoptLong_1.0.5        S4Vectors_0.46.0        bit64_4.6.0-1           irlba_2.3.5.1          
#> [57] clue_0.3-66             magick_2.9.0            annotate_1.86.1         codetools_0.2-20       
#> [61] shape_1.4.6.1           GenomeInfoDb_1.44.3     UCSC.utils_1.4.0        openssl_2.3.3          
#> [65] GenomeInfoDbData_1.2.14 circlize_0.4.16         R6_2.6.1                microbenchmark_1.5.0   
#> [69] doParallel_1.0.17       evaluate_1.0.5          lattice_0.22-7          Biobase_2.68.0         
#> [73] png_0.1-8               memoise_2.0.1           Rcpp_1.1.0              xfun_0.53              
#> [77] MatrixGenerics_1.20.0   skmeans_0.2-18          GlobalOptions_0.1.2
```




<script type="text/javascript">
$(function() {
    $("#TOC > ul > li > a").remove();
}); 
</script>
