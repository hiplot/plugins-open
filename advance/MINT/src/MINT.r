library(mixOmics)
data(stemcells)

# 创建结果目录
if (!dir.exists("result")) {
  dir.create("result")
}

# The combined data set X
X <- stemcells$gene
dim(X)

# The outcome vector Y:  
Y <- stemcells$celltype 
length(Y) 

study <- stemcells$study

# Number of samples per study:
summary(study)

# Experimental design
table(Y,study)

mint.plsda.stem <- mint.plsda(X = X, Y = Y, study = study, ncomp = 5)

set.seed(2543) # For reproducible results here, remove for your own analyses
perf.mint.plsda.stem <- perf(mint.plsda.stem) 

# 保存性能评估图
pdf("result/perf_mint_plsda.pdf", width = 8, height = 6)
plot(perf.mint.plsda.stem)
dev.off()

png("result/perf_mint_plsda.png", width = 800, height = 600, res = 150)
plot(perf.mint.plsda.stem)
dev.off()

perf.mint.plsda.stem$global.error$BER
# Type also:
# perf.mint.plsda.stem$global.error

final.mint.plsda.stem <- mint.plsda(X = X, Y = Y, study = study, ncomp = 2)

#final.mint.plsda.stem # Lists the different functions

# 保存MINT PLS-DA样本投影图
pdf("result/mint_plsda_indiv.pdf", width = 8, height = 6)
plotIndiv(final.mint.plsda.stem, legend = TRUE, title = 'MINT PLS-DA', 
          subtitle = 'stem cell study', ellipse = T)
dev.off()

png("result/mint_plsda_indiv.png", width = 800, height = 600, res = 150)
plotIndiv(final.mint.plsda.stem, legend = TRUE, title = 'MINT PLS-DA', 
          subtitle = 'stem cell study', ellipse = T)
dev.off()

plsda.stem <- plsda(X = X, Y = Y, ncomp = 2)

# 保存经典PLS-DA样本投影图
pdf("result/classic_plsda_indiv.pdf", width = 8, height = 6)
plotIndiv(plsda.stem, pch = study,
          legend = TRUE, title = 'Classic PLS-DA',
          legend.title = 'Cell type', legend.title.pch = 'Study')
dev.off()

png("result/classic_plsda_indiv.png", width = 800, height = 600, res = 150)
plotIndiv(plsda.stem, pch = study,
          legend = TRUE, title = 'Classic PLS-DA',
          legend.title = 'Cell type', legend.title.pch = 'Study')
dev.off()

set.seed(2543)  # For a reproducible result here, remove for your own analyses
tune.mint.splsda.stem <- tune(X = X, Y = Y, study = study, 
                 ncomp = 2, test.keepX = seq(1, 100, 1),
                 method = 'mint.splsda', #Specify the method
                 measure = 'BER',
                 dist = "centroids.dist",
                 nrepeat = 3)

#tune.mint.splsda.stem # Lists the different types of outputs

# Mean error rate per component and per tested keepX value:
#tune.mint.splsda.stem$error.rate[1:5,]

tune.mint.splsda.stem$choice.keepX

# 保存参数调优图
pdf("result/tune_mint_splsda.pdf", width = 8, height = 6)
plot(tune.mint.splsda.stem)
dev.off()

png("result/tune_mint_splsda.png", width = 800, height = 600, res = 150)
plot(tune.mint.splsda.stem)
dev.off()

final.mint.splsda.stem <- mint.splsda(X = X, Y = Y, study = study, ncomp = 2,  
                              keepX = tune.mint.splsda.stem$choice.keepX)

#mint.splsda.stem.final # Lists useful functions that can be used with a MINT object

# 保存全局样本投影图
pdf("result/mint_splsda_global.pdf", width = 8, height = 6)
plotIndiv(final.mint.splsda.stem, study = 'global', legend = TRUE, 
          title = 'Stem cells, MINT sPLS-DA', 
          subtitle = 'Global', ellipse = T)
dev.off()

png("result/mint_splsda_global.png", width = 800, height = 600, res = 150)
plotIndiv(final.mint.splsda.stem, study = 'global', legend = TRUE, 
          title = 'Stem cells, MINT sPLS-DA', 
          subtitle = 'Global', ellipse = T)
dev.off()

# 保存分研究样本投影图
pdf("result/mint_splsda_partial.pdf", width = 10, height = 8)
plotIndiv(final.mint.splsda.stem, study = 'all.partial', legend = TRUE, 
          title = 'Stem cells, MINT sPLS-DA', 
          subtitle = paste("Study",1:4))
dev.off()

png("result/mint_splsda_partial.png", width = 1000, height = 800, res = 150)
plotIndiv(final.mint.splsda.stem, study = 'all.partial', legend = TRUE, 
          title = 'Stem cells, MINT sPLS-DA', 
          subtitle = paste("Study",1:4))
dev.off()

# 保存变量图
pdf("result/mint_splsda_var.pdf", width = 8, height = 6)
plotVar(final.mint.splsda.stem)
dev.off()

png("result/mint_splsda_var.png", width = 800, height = 600, res = 150)
plotVar(final.mint.splsda.stem)
dev.off()

# 保存聚类热图
pdf("result/mint_splsda_cim.pdf", width = 10, height = 8)
cim(final.mint.splsda.stem, comp = 1, margins=c(10,5), 
    row.sideColors = color.mixo(as.numeric(Y)), row.names = FALSE,
    title = "MINT sPLS-DA, component 1")
dev.off()

png("result/mint_splsda_cim.png", width = 1000, height = 800, res = 150)
cim(final.mint.splsda.stem, comp = 1, margins=c(10,5), 
    row.sideColors = color.mixo(as.numeric(Y)), row.names = FALSE,
    title = "MINT sPLS-DA, component 1")
dev.off()

# 保存网络图
pdf("result/mint_splsda_network.pdf", width = 10, height = 8)
network(final.mint.splsda.stem, comp = 1,
        color.node = c(color.mixo(1), color.mixo(2)), 
        shape.node = c("rectangle", "circle"))
dev.off()

png("result/mint_splsda_network.png", width = 1000, height = 800, res = 150)
network(final.mint.splsda.stem, comp = 1,
        color.node = c(color.mixo(1), color.mixo(2)), 
        shape.node = c("rectangle", "circle"))
dev.off()

# 保存载荷图
pdf("result/mint_splsda_loadings.pdf", width = 10, height = 8)
plotLoadings(final.mint.splsda.stem, contrib = "max", method = 'mean', comp=1, 
             study="all.partial", title="Contribution on comp 1", 
             subtitle = paste("Study",1:4))
dev.off()

png("result/mint_splsda_loadings.png", width = 1000, height = 800, res = 150)
plotLoadings(final.mint.splsda.stem, contrib = "max", method = 'mean', comp=1, 
             study="all.partial", title="Contribution on comp 1", 
             subtitle = paste("Study",1:4))
dev.off()