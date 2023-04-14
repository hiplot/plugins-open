## [nonegenome-kegg-enrichplot](/advance/nonegenome-kegg-enrichplot)

- ### Function Introduction

    KEGG enrichment and visualization for no-genome species KEGG annotation information and DEGs list.
    
- ### Data Structure

    Two tables.
    
    \<1st-table\>: GO annotation information of all genes.
    
    \<2nd-table\>: Differential expression genes with LogFoldChange value.
    
    
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

    enrichplot: (Maintainer: Guangchuang Yu <guangchuangyu@gmail.com>)

