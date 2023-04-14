## [分组小提琴图](/basic/violin-group)

- ### 功能介绍

    T检验分组数据的小提琴图和盒图。

- ### 数据结构

    数据帧
    
    \<1st col\>：（数字）值数据，
    
    \<2nd col\>：（String）第1列组，
    
    \<3rd col\>：（字符串）第2列组。
    

- ### 参数详解
    
    **主要参数**
    
    Title: 图像的主标题（部分图像可替换默认标题）
    
    Theme: 图像主题（由ggplot2提供的主题）
    
    Color Palette: 图像配色（由ggsci提供的主流期刊优秀配色）
    
    Font Family: 字体（如主流期刊规定的Time New Romas）
    
    Width: 输出图像的宽度（默认为英寸如标准为12 x 7 inch）
    
    Height: 输出图像的高度（默认为英寸如标准为12 x 7 inch）
    
    Alpha: 元素的透明度（0-1，0表示透明，1表示不透明）
    
    
    **重要参数**
    
    Legend Position: 图例在图像中的位置
    
    Legend Direction: 图例中多个元素的排列方式（横向或纵向）
    
    Legend Title Size: 图例主标题大小
    
    Legend Text Size: 图例中元素文本的大小
    
    
    Axis Title Size: 图像坐标轴标题的大小
    
    Axis Font Size: 图像坐标轴刻度字体的大小
    
    Axis Text Angle: 图像坐标轴文本的角度
    
    Axis Adjust: 图像坐标轴文本的距离（微调）
    
    
    **特殊参数**
    
    Add Geom: 在小提琴图上添加箱线图展示更加丰富的信息
    
    Stat Method: 置信度统计的方法（默认为T-test）
    
    

