## [Calibration Curve](/basic/calibration-curve)

- ### Function Introduction

    The calibration curve is used to evaluate the consistency / calibration, i.e. the difference between the predicted value and the real value
    
- ### Data Structure

    Data frame of multi columns data (Numeric allow NA). i.e the survival data (status with 0 and 1).

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
    
    Model: model calculation method (default is linear fitting model)
    
    Cmmethod: the method to check the model (km algorithm by default)
    
    Method: calibration method (boot method by default)
    
    Time (day): time, support time unit is day (default 365 days)



