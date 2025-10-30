library(mixOmics)
data(liver.toxicity)
X <- liver.toxicity$gene
Y <- liver.toxicity$clinic
dim(Y)

# 创建结果目录
if (!dir.exists("result")) {
  dir.create("result")
}

tune.pls2.liver <- pls(X = X, Y = Y, ncomp = 5, mode = 'regression')

set.seed(33)
Q2.pls2.liver <- perf(tune.pls2.liver, validation = 'Mfold', folds = 10, 
                      nrepeat = 5)

# 保存Q2图
pdf("result/Q2_total_plot.pdf", width = 8, height = 6)
plot(Q2.pls2.liver, criterion = 'Q2.total')
dev.off()

png("result/Q2_total_plot.png", width = 800, height = 600, res = 150)
plot(Q2.pls2.liver, criterion = 'Q2.total')
dev.off()

# This code may take several min to run, parallelisation option is possible
list.keepX <- c(seq(5, 50, 5))
list.keepY <- c(3:10)

set.seed(33)
tune.spls.liver <- tune.spls(X, Y, test.keepX = list.keepX, 
                             test.keepY = list.keepY, ncomp = 2, 
                             nrepeat = 1, folds = 10, mode = 'regression', 
                             measure = 'cor')

# 保存调优图
pdf("result/tune_spls_liver.pdf", width = 8, height = 6)
plot(tune.spls.liver)
dev.off()

png("result/tune_spls_liver.png", width = 800, height = 600, res = 150)
plot(tune.spls.liver)
dev.off()

#Optimal parameters
choice.keepX <- tune.spls.liver$choice.keepX
choice.keepY <- tune.spls.liver$choice.keepY
choice.ncomp <- length(choice.keepX)

spls2.liver <- spls(X, Y, ncomp = choice.ncomp, 
                   keepX = choice.keepX,
                   keepY = choice.keepY,
                   mode = "regression")

spls2.liver$prop_expl_var
selectVar(spls2.liver, comp = 1)$X$value
vip.spls2.liver <- vip(spls2.liver)
# just a head
head(vip.spls2.liver[selectVar(spls2.liver, comp = 1)$X$name,1])
perf.spls2.liver <- perf(spls2.liver, validation = 'Mfold', folds = 10, nrepeat = 5)
# Extract stability
stab.spls2.liver.comp1 <- perf.spls2.liver$features$stability.X$comp1
# Averaged stability of the X selected features across CV runs, as shown in Table
stab.spls2.liver.comp1[1:choice.keepX[1]]

# We extract the stability measures of only the variables selected in spls2.liver
extr.stab.spls2.liver.comp1 <- stab.spls2.liver.comp1[selectVar(spls2.liver, 
                                                                  comp =1)$X$name]

# 保存样本投影图
pdf("result/plotIndiv_spls2.pdf", width = 8, height = 6)
plotIndiv(spls2.liver, ind.names = FALSE, 
          group = liver.toxicity$treatment$Time.Group, 
          pch = as.factor(liver.toxicity$treatment$Dose.Group), 
          col.per.group = color.mixo(1:4),
          legend = TRUE, legend.title = 'Time', 
          legend.title.pch = 'Dose')
dev.off()

png("result/plotIndiv_spls2.png", width = 800, height = 600, res = 150)
plotIndiv(spls2.liver, ind.names = FALSE, 
          group = liver.toxicity$treatment$Time.Group, 
          pch = as.factor(liver.toxicity$treatment$Dose.Group), 
          col.per.group = color.mixo(1:4),
          legend = TRUE, legend.title = 'Time', 
          legend.title.pch = 'Dose')
dev.off()

# 保存箭头图
pdf("result/plotArrow_spls2.pdf", width = 8, height = 6)
plotArrow(spls2.liver, ind.names = FALSE, 
          group = liver.toxicity$treatment$Time.Group,
          col.per.group = color.mixo(1:4),
          legend.title = 'Time.Group')
dev.off()

png("result/plotArrow_spls2.png", width = 800, height = 600, res = 150)
plotArrow(spls2.liver, ind.names = FALSE, 
          group = liver.toxicity$treatment$Time.Group,
          col.per.group = color.mixo(1:4),
          legend.title = 'Time.Group')
dev.off()

# 保存变量图1
pdf("result/plotVar1_spls2.pdf", width = 8, height = 6)
plotVar(spls2.liver, cex = c(3,4), var.names = c(FALSE, TRUE))
dev.off()

png("result/plotVar1_spls2.png", width = 800, height = 600, res = 150)
plotVar(spls2.liver, cex = c(3,4), var.names = c(FALSE, TRUE))
dev.off()

# 保存变量图2
pdf("result/plotVar2_spls2.pdf", width = 8, height = 6)
plotVar(spls2.liver,
        var.names = list(X.label = liver.toxicity$gene.ID[,'geneBank'],
        Y.label = TRUE), cex = c(3,4))
dev.off()

png("result/plotVar2_spls2.png", width = 800, height = 600, res = 150)
plotVar(spls2.liver,
        var.names = list(X.label = liver.toxicity$gene.ID[,'geneBank'],
        Y.label = TRUE), cex = c(3,4))
dev.off()

# Define red and green colours for the edges
color.edge <- color.GreenRed(50)

# 保存网络图
pdf("result/network_spls2.pdf", width = 10, height = 8)
network(spls2.liver, comp = 1:2,
        cutoff = 0.7,
        shape.node = c("rectangle", "circle"),
        color.node = c("cyan", "pink"),
        color.edge = color.edge)
dev.off()

png("result/network_spls2.png", width = 1000, height = 800, res = 150)
network(spls2.liver, comp = 1:2,
        cutoff = 0.7,
        shape.node = c("rectangle", "circle"),
        color.node = c("cyan", "pink"),
        color.edge = color.edge)
dev.off()

# 保存聚类热图
pdf("result/cim_spls2.pdf", width = 10, height = 8)
cim(spls2.liver, comp = 1:2, xlab = "clinic", ylab = "genes")
dev.off()

png("result/cim_spls2.png", width = 1000, height = 800, res = 150)
cim(spls2.liver, comp = 1:2, xlab = "clinic", ylab = "genes")
dev.off()

# Comparisons of final models (PLS, sPLS)

## PLS
pls.liver <- pls(X, Y, mode = 'regression', ncomp = 2)
perf.pls.liver <-  perf(pls.liver, validation = 'Mfold', folds = 10, 
                        nrepeat = 5)

## Performance for the sPLS model ran earlier
perf.spls.liver <-  perf(spls2.liver, validation = 'Mfold', folds = 10, 
                         nrepeat = 5)

# 保存性能比较图
pdf("result/performance_comparison.pdf", width = 8, height = 6)
plot(c(1,2), perf.pls.liver$measures$cor.upred$summary$mean, 
     col = 'blue', pch = 16, 
     ylim = c(0.6,1), xaxt = 'n',
     xlab = 'Component', ylab = 't or u Cor', 
     main = 's/PLS performance based on Correlation')
axis(1, 1:2)
points(perf.pls.liver$measures$cor.tpred$summary$mean, col = 'red', pch = 16)
points(perf.spls.liver$measures$cor.upred$summary$mean, col = 'blue', pch = 17)
points(perf.spls.liver$measures$cor.tpred$summary$mean, col = 'red', pch = 17)
legend('bottomleft', col = c('blue', 'red', 'blue', 'red'), 
       pch = c(16, 16, 17, 17), c('u PLS', 't PLS', 'u sPLS', 't sPLS'))
dev.off()

png("result/performance_comparison.png", width = 800, height = 600, res = 150)
plot(c(1,2), perf.pls.liver$measures$cor.upred$summary$mean, 
     col = 'blue', pch = 16, 
     ylim = c(0.6,1), xaxt = 'n',
     xlab = 'Component', ylab = 't or u Cor', 
     main = 's/PLS performance based on Correlation')
axis(1, 1:2)
points(perf.pls.liver$measures$cor.tpred$summary$mean, col = 'red', pch = 16)
points(perf.spls.liver$measures$cor.upred$summary$mean, col = 'blue', pch = 17)
points(perf.spls.liver$measures$cor.tpred$summary$mean, col = 'red', pch = 17)
legend('bottomleft', col = c('blue', 'red', 'blue', 'red'), 
       pch = c(16, 16, 17, 17), c('u PLS', 't PLS', 'u sPLS', 't sPLS'))
dev.off()