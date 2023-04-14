## [GEO-Raster](/advance/geo-raster)

Geographical data analysis application.

Calculate the grid coefficient of variation (Coefficient of Variation, CV)

Analysis principle:

The coefficient of variation is a statistic that measures the degree of variation of the observed sequence value. It can well reflect the degree of difference in spatial data changes in the time series, and evaluate the stability of the data time series.

The calculation formula is: CV=σ/μ

In the formula: σ is the standard deviation and μ is the arithmetic mean. The greater the CV, the greater the data fluctuation.

Instructions:

Just upload multi-band TIFF raster data.

Experimental data
The experimental data comes from the global 2.5-minute resolution grid dataset of cumulative precipitation from 2001 to 2005 of the National Earth System Science Data Center

GeoData: http://www.geodata.cn

- http://www.geodata.cn/data/datadetails.html?dataguid=10390875210275&docId=953
- http://www.geodata.cn/data/datadetails.html?dataguid=100550828975571&docId=952
- http://www.geodata.cn/data/datadetails.html?dataguid=173118596865792&docId=951
- http://www.geodata.cn/data/datadetails.html?dataguid=122541062157237&docId=950
- http://www.geodata.cn/data/datadetails.html?dataguid=201705899659362&docId=949

Use ENVI for band synthesis and synthesize into a multi-band image, then the coefficient of variation can be calculated.

Copyright: Hiplot and GeoData
