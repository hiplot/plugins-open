## [Fishplot](/basic/fishplot)

Detail: https://github.com/chrisamiller/fishplot

- Data Table

  timepoints: specifying the timepoints for each column of the matrix

  parents: specifying parental relationships between clones

  samplename: samplename (support multiple samples)

  other: a numeric matrix containing tumor fraction estimates for all clones at all timepoints

- General parameters

  Color Palette: control background colors

  Color Palette2: control clone colors

- Extra parameters

  Shape: the type of shape to construct the plot out of

  Background Type: a string giving the background type

  Time Unit: time unit added to vline axis

  Border Width: a numeric width for the border line around this polygon

  Padding Pecent: the amount of "ramp-up" to the left of the first timepoint. Given as a fraction of the total plot width. Default 0.2

  Vline: add timepoints vline

  Clone Label: add clone name 

  Fix Missing: whether to "correct" clones that have zero values at timepoints between non-zero values. (the clone must still have been present if it came back)

  Vline of Color: Color of timepoints vline

  Border of Color: Color of border
