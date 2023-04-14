## [forestplot](/advance/forestplot)

- ### Function Introduction

    In addition to meta-analysis, forest mapping is also widely used in observational studies and clinical trials, such as risk analysis / survival analysis.
    
- ### Data Structure

    Two tables needed.
    
    \<1st-table\>: 
    
    \<1st-col\>: (Numeric) mean data. 
    
    \<2nd-col\>: (Numeric) lower data. 
    
    \<3rd-col\>: (Numeric) upper data. 
    
    \<2nd-table\>: (String or Numeric) text table.
    
    

- ### Parameters Details

    **Upload | Download**
    
    Browser: users can read and upload local computer files
    
    Example Download: sample data download
    
    Result Download: the result image or all files are compressed and downloaded
    
    Width: the width of the output image (the default is inches, such as 12 x 7 inch in the standard)
    
    Height: the height of the output image (the default is inches, such as 12 x 7 inch)
    
    DPI: image resolution (300dpi is higher image quality by default)
    
    Format: image format selection, all images provide PDF, PNG and other major scientific research formats
    
    
    **Calculation | drawing**
    
    Title: the title of the image, which can replace the default title of the image
    
    Theme: the theme of the image. Ggplot2 provides a variety of personalized themes
    
    Font family: font (such as time new Roma specified by mainstream journals)
    
    Alpha: transparency of the element (0-1, 0 for transparency, 1 for opacity)
    
    
    Legend position: the position of the legend in the image
    
    Legend direction: arrangement of multiple elements in legend (horizontal or vertical)
    
    Legend Title Size: Legend Main Title Size
    
    Legend text size: the size of the element text in the legend
    
    
    Axis title size: the size of the image axis title
    
    Axis font size: the size of the image axis scale font
    
    Axis text angle: the angle of the image axis text
    
    Axis adjust: image axis text distance (fine tuning)
    
    
    **Special parameters**
    
    Program analysis content parameters: specific algorithm or implementation can refer to the core module official documentation
    
    Refer to the detailed tutorial video of our platform for complex programs online: https://space.bilibili.com/351815613
    
    Main beautification parameters: https://ggplot2.tidyverse.org/reference/
    
    For more special parameters, please refer to: https://ggplot2.tidyverse.org/reference/theme.html
    

- ### Reference Packages

    forestplot: (Maintainer: Max Gordon \<max@gforge.se\>)

