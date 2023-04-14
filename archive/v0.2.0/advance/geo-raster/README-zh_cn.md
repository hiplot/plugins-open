## [GEO-Raster](/advance/geo-raster)

地理学数据分析应用。

计算栅格变异系数（Coefficient of Variation, CV）

分析原理：

变异系数是衡量观测序列值变异程度的一个统计量， 可以很好地反映空间数据在时间序列上变化的差异程度， 评价数据时间序列的稳定性。

计算公式为： CV=σ/μ

式中：σ 为标准差，μ 为算术平均值。CV越大，数据波动越大。

使用方法：

上传多波段 TIFF 栅格数据即可。

实验数据
实验数据来源于国家地球系统科学数据中心全球2.5分分辨率2001-2005年累积降水量栅格数据集

GeoData: http://www.geodata.cn

- http://www.geodata.cn/data/datadetails.html?dataguid=10390875210275&docId=953
- http://www.geodata.cn/data/datadetails.html?dataguid=100550828975571&docId=952
- http://www.geodata.cn/data/datadetails.html?dataguid=173118596865792&docId=951
- http://www.geodata.cn/data/datadetails.html?dataguid=122541062157237&docId=950
- http://www.geodata.cn/data/datadetails.html?dataguid=201705899659362&docId=949

使用ENVI进行波段合成，合成为多波段影像，即可进行变异系数计算。

Copyright: Hiplot and GeoData

