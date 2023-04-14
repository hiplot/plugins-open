## [Matrix Bubble](/basic/matrix-bubble)

- ### Function Introduction

    The color matrix bubble  is used to visualize the expression matrix data of multiple genes (rows) in various cells (columns).
    
- ### Data Structure

    \<1st-col\>: (String) cell sample name as X axis, 
    
    \<2nd-col\>: (String) gene name as the Y axis, 
    
    \<3rd-col\>: (Numeric) Gene expression, 
    
    [4th-col]: (String) groups.


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
    
    
    Panel space: the distance between groups in the image when the cells are divided into multiple groups (default 0)
    


