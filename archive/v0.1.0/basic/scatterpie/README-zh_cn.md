## [散点饼图](/basic/scatterpie)

散点饼图用于可视化不同空间坐标中数据分类值的比例情况。

目前，这个插件实现了 R 包 [scatterpie](https://cran.r-project.org/web/packages/scatterpie/vignettes/scatterpie.html) 的一个简单接口。

输入的数据表格至少需要 3 列。前面两列对应这平面坐标值，而其他更多的列则用于表示不同分类下的数据值。如果你了解长宽格式，你也可以设定输入长格式的数据（默认识别为宽格式）。
