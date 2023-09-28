- [Circular Bar Chart](/basic/circular-bar-plot)

## Introduction

A circular bar chart is a visual representation of data in the form of circular bars.

- Case Study Data Analysis

​		The case study data is based on the `mpg` dataset from the ggplot2 package. It represents the relationship between the `class` (car types) on the x-axis and `drv` (drive types) on the y-axis.

- Interpretation of the Chart

​		The example chart is sorted, with suv having the highest data count positioned on the outermost ring and decreasing towards the center. It can be observed from the chart that suv have a higher proportion of four-wheel drive, while compact and midsize cars are predominantly front-wheel drive.

- Special Parameters

  `x_size`: Font size for x-axis labels.

  `overflow`: Overflow ratio to prevent data from completely filling the circle and obstructing x-axis labels. Recommended values are between 1.1 and 1.2.

  `sort`: Whether to enable sorting of the bars.

