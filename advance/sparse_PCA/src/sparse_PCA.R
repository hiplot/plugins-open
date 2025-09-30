library(mixOmics)
data(multidrug)
X <- multidrug$ABC.trans
dim(X) # Check dimensions of data

# 创建结果目录
if (!dir.exists("result")) {
  dir.create("result")
}

grid.keepX <- c(seq(5, 30, 5))
set.seed(30)
tune.spca.result <- tune.spca(X, ncomp = 3, 
                              folds = 5, 
                              test.keepX = grid.keepX, nrepeat = 10) 

# 保存参数调优结果图形
pdf("result/tune_spca_plot.pdf", width = 8, height = 6)
plot(tune.spca.result)
dev.off()

png("result/tune_spca_plot.png", width = 800, height = 600, res = 150)
plot(tune.spca.result)
dev.off()

tune.spca.result$choice.keepX

# 运行最终模型
keepX.select <- tune.spca.result$choice.keepX[1:2]
final.spca.multi <- spca(X, ncomp = 2, keepX = keepX.select)

# 保存样本投影图
pdf("result/sample_plot.pdf", width = 8, height = 6)
plotIndiv(final.spca.multi,
          comp = c(1, 2),
          ind.names = TRUE,
          group = multidrug$cell.line$Class,
          title = 'ABC transporters, sPCA comp 1 - 2',
          legend = TRUE, legend.title = 'Cell line')
dev.off()

png("result/sample_plot.png", width = 800, height = 600, res = 150)
plotIndiv(final.spca.multi,
          comp = c(1, 2),
          ind.names = TRUE,
          group = multidrug$cell.line$Class,
          title = 'ABC transporters, sPCA comp 1 - 2',
          legend = TRUE, legend.title = 'Cell line')
dev.off()

# 保存双标图
pdf("result/biplot.pdf", width = 8, height = 6)
biplot(final.spca.multi, group = multidrug$cell.line$Class, legend = FALSE)
dev.off()

png("result/biplot.png", width = 800, height = 600, res = 150)
biplot(final.spca.multi, group = multidrug$cell.line$Class, legend = FALSE)
dev.off()

# 保存变量图
pdf("result/variable_plot.pdf", width = 8, height = 6)
plotVar(final.spca.multi, comp = c(1, 2), var.names = TRUE, 
        cex = 3,
        title = 'Multidrug transporter, sPCA comp 1 - 2')
dev.off()

png("result/variable_plot.png", width = 800, height = 600, res = 150)
plotVar(final.spca.multi, comp = c(1, 2), var.names = TRUE, 
        cex = 3,
        title = 'Multidrug transporter, sPCA comp 1 - 2')
dev.off()

# 保存载荷图
pdf("result/loadings_plot.pdf", width = 8, height = 6)
plotLoadings(final.spca.multi, comp = 2)
dev.off()

png("result/loadings_plot.png", width = 800, height = 600, res = 150)
plotLoadings(final.spca.multi, comp = 2)
dev.off()

# 显示解释方差比例
final.spca.multi$prop_expl_var$X
