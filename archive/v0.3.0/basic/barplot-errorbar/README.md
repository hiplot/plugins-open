## [Barplot Errorbar](/basic/barplot-errorbar)

- ### Function Introduction

    Bar plot with error-lines and groups.
    
- ### Data Structure

    Data frame. 
    
    \<1st-col\>: (Numeric) values as Y-axis. 
    
    \<2nd-col\>: (Numeric or String) classes as X-axis. 
    
    \<3rd-col\>: (String) groups as colors and legend.
    

- ### Parameter details

    **Main parameters**
    
    Title: the main title of the image (some images can replace the default title)
    
    Theme: image theme (provided by ggplot2)
    
    Color palette: image matching
    
    Font family: font (such as time new Roma specified by mainstream journals)
    
    Width: the width of the output image (the default is inches, such as 12 x 7 inch in the standard)
    
    Height: the height of the output image (the default is inches, such as 12 x 7 inch)
    
    Alpha: transparency of the element (0-1, 0 for transparency, 1 for opacity)
    
    
    **Important parameters**
    
    Legend position: the position of the legend in the image
    
    Legend direction: arrangement of multiple elements in legend (horizontal or vertical)
    
    Legend Title Size: Legend Main Title Size
    
    Legend text size: the size of the element text in the legend
    
    
    Axis title size: the size of the image axis title
    
    Axis font size: the size of the image axis scale font
    
    Axis text angle: the angle of the image axis text
    
    Axis adjust: image axis text distance (fine tuning)
    
    
    **Special parameters**
    
    Errorbar width: error bar width
    
    Bar border color: error bar border color
    
    **Other notes**

    P-values for two columns of data are calculated by comparison with all samples

    P-values for three columns of data are whether there is a difference within the group

