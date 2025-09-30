library(mixOmics)
data(srbct)
X <- srbct$gene

# 创建结果目录
if (!dir.exists("result")) {
  dir.create("result")
}

# Outcome y that will be internally coded as dummy:
Y <- srbct$class 
dim(X); length(Y)

pca.srbct <- pca(X, ncomp = 3, scale = TRUE)

# 保存PCA样本投影图
pdf("result/pca_plot.pdf", width = 8, height = 6)
plotIndiv(pca.srbct, group = srbct$class, ind.names = FALSE,
          legend = TRUE, 
          title = 'SRBCT, PCA comp 1 - 2')
dev.off()

png("result/pca_plot.png", width = 800, height = 600, res = 150)
plotIndiv(pca.srbct, group = srbct$class, ind.names = FALSE,
          legend = TRUE, 
          title = 'SRBCT, PCA comp 1 - 2')
dev.off()

plsda.srbct <- plsda(X,Y, ncomp = 10)

set.seed(30) # For reproducibility with this handbook, remove otherwise
perf.plsda.srbct <- perf(plsda.srbct, validation = 'Mfold', folds = 3, 
                  progressBar = FALSE,  # Set to TRUE to track progress
                  nrepeat = 10)         # We suggest nrepeat = 50

# 保存性能评估图
pdf("result/perf_plot.pdf", width = 8, height = 6)
plot(perf.plsda.srbct, sd = TRUE, legend.position = 'horizontal')
dev.off()

png("result/perf_plot.png", width = 800, height = 600, res = 150)
plot(perf.plsda.srbct, sd = TRUE, legend.position = 'horizontal')
dev.off()

final.plsda.srbct <- plsda(X,Y, ncomp = 3)

# 保存PLS-DA成分1-2图
pdf("result/plsda_comp1_2.pdf", width = 8, height = 6)
plotIndiv(final.plsda.srbct, ind.names = FALSE, legend=TRUE,
          comp=c(1,2), ellipse = TRUE, 
          title = 'PLS-DA on SRBCT comp 1-2',
          X.label = 'PLS-DA comp 1', Y.label = 'PLS-DA comp 2')
dev.off()

png("result/plsda_comp1_2.png", width = 800, height = 600, res = 150)
plotIndiv(final.plsda.srbct, ind.names = FALSE, legend=TRUE,
          comp=c(1,2), ellipse = TRUE, 
          title = 'PLS-DA on SRBCT comp 1-2',
          X.label = 'PLS-DA comp 1', Y.label = 'PLS-DA comp 2')
dev.off()

# 保存PLS-DA成分2-3图
pdf("result/plsda_comp2_3.pdf", width = 8, height = 6)
plotIndiv(final.plsda.srbct, ind.names = FALSE, legend=TRUE,
          comp=c(2,3), ellipse = TRUE, 
          title = 'PLS-DA on SRBCT comp 2-3',
          X.label = 'PLS-DA comp 2', Y.label = 'PLS-DA comp 3')
dev.off()

png("result/plsda_comp2_3.png", width = 800, height = 600, res = 150)
plotIndiv(final.plsda.srbct, ind.names = FALSE, legend=TRUE,
          comp=c(2,3), ellipse = TRUE, 
          title = 'PLS-DA on SRBCT comp 2-3',
          X.label = 'PLS-DA comp 2', Y.label = 'PLS-DA comp 3')
dev.off()
        
set.seed(30) # For reproducibility with this handbook, remove otherwise
perf.final.plsda.srbct <- perf(final.plsda.srbct, validation = 'Mfold', 
                               folds = 3, 
                               progressBar = FALSE, # TRUE to track progress
                               nrepeat = 10) # we recommend 50 

perf.final.plsda.srbct$error.rate$BER[, 'max.dist']

perf.final.plsda.srbct$error.rate.class$max.dist

background.max <- background.predict(final.plsda.srbct, 
                                     comp.predicted = 2,
                                     dist = 'max.dist') 

# 保存带背景的样本投影图
pdf("result/background_plot.pdf", width = 8, height = 6)
plotIndiv(final.plsda.srbct, comp = 1:2, group = srbct$class,
          ind.names = FALSE, title = 'Maximum distance',
          legend = TRUE,  background = background.max)
dev.off()

png("result/background_plot.png", width = 800, height = 600, res = 150)
plotIndiv(final.plsda.srbct, comp = 1:2, group = srbct$class,
          ind.names = FALSE, title = 'Maximum distance',
          legend = TRUE,  background = background.max)
dev.off()