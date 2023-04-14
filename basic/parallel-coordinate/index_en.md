### App Documentation

---

#### APP Name

Parallel Cooradinate Plot



#### One sentence Introduction

Display high-dimensional multivariate data



#### Detailed Information

Parallel coordinate plot is a common visualization method for the visualization of high-dimensional geometry and multivariate data.

In order to represent a point set in a high-dimensional space, under the background of N parallel lines (generally these N lines are vertical and equidistant), a point in the high-dimensional space is represented as an inflection point in N lines The position of the polyline parallel to the coordinate axis on the Kth coordinate axis represents the value of this point in the Kth dimension.

A significant advantage of the parallel coordinate diagram is that it has a good mathematical foundation, and its projective geometric interpretation and duality characteristics make it very suitable for visual data analysis.



#### How to use 

---

- Import Data

  Like the example demo data, the imported data is divided into __three__ types of columns. Please note that the first column must be the name of the observation; the last column is the grouping information (if there is no grouping, please add the same grouping information, it is mandatory. ); the data columns in the middle are unlimited, you can enter as many data columns as you want, however it is not recommended to import too many columns (less than 10 columns). The details are shown in the following diagram:

  ![image-20201009210331134](https://s1.ax1x.com/2020/10/09/0ryhJe.png)

- Parameter settings

  - General parameters

     Including the title, the theme of the graphics, the color theme, and the format of the exported picture, I won't do too much interpretation here. Please refer to

  [Hiplot official instructions]: https://hiplot-academic.com/docs/

  - Extra parameters
    - Scale method:

      This is a __very important__ parameter. It determines which method shoud be applied to scale the data of different groups. This parameter determines the coordinates of the Y-axis and the difference in value between different groups, 

      There are several  methods include `std`,` globalminmax`, etc., which respectively indicate that standard deviation or range is used for scaling, and different scale methods can be selected to control the graph.

    - Add box plot:

      Indicates whether to add a box plot in the parallel coordinate graph to highlight the graph distribution

    - Add scatter points:

      Data in parallel coordinate plot are commonly illustrated as multiple lines. Click this option to add scatter points to the lines.

    - Faceted:

      If there are too many groups, in order to display the parallel coordinate graphs of different groups separately, a facet method can be used.

  

- Graphic interpretation

  The parallel coordinate diagram drawn using the example data is shown in the following figure:

  ![img](https://s1.ax1x.com/2020/10/09/0rc3Bq.png)

  - The colors in the picture indicate different groups. Of course, different colors can be adjusted at will.
  - The X axis corresponds to the middle columns in the input data, which are arranged according to the data columns from left to right in the data table.
  - The Y axis of the above example plot corresponds to the actual data in the imported data table. Please note: The data showed on the Y axis  is determined by the scale normalization method. It may be the actual input value, or it may be normalized according to the scale method. 



#### Development Information

---

> Version number: v 0.1.1
>
> Maintainer: Hiplot core team
>
> Release Date: 2020-10-08
>
> Update Date: 2020-10-09
