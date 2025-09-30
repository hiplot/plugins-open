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

summary(Y)

# Grid of possible keepX values that will be tested for each comp
list.keepX <- c(1:10, seq(20, 100, 10))
list.keepX

# This chunk takes ~ 2 min to run
# Some convergence issues may arise but it is ok as this is run on CV folds
tune.splsda.srbct <- tune.splsda(X, Y, ncomp = 4, validation = 'Mfold', 
                                 folds = 5, dist = 'max.dist', 
                                 test.keepX = list.keepX, nrepeat = 10)

# 保存调优图
pdf("result/tune_splsda.pdf", width = 8, height = 6)
plot(tune.splsda.srbct, sd = TRUE)
dev.off()

png("result/tune_splsda.png", width = 800, height = 600, res = 150)
plot(tune.splsda.srbct, sd = TRUE)
dev.off()

# The optimal number of components according to our one-sided t-tests
tune.splsda.srbct$choice.ncomp$ncomp

# The optimal keepX parameter according to minimal error rate
tune.splsda.srbct$choice.keepX

# Optimal number of components based on t-tests on the error rate
ncomp <- tune.splsda.srbct$choice.ncomp$ncomp 
ncomp

# Optimal number of variables to select
select.keepX <- tune.splsda.srbct$choice.keepX[1:ncomp]  
select.keepX

splsda.srbct <- splsda(X, Y, ncomp = ncomp, keepX = select.keepX) 

set.seed(34)  # For reproducibility with this handbook, remove otherwise

perf.splsda.srbct <- perf(splsda.srbct, folds = 5, validation = "Mfold", 
                  dist = "max.dist", progressBar = FALSE, nrepeat = 10)

# perf.splsda.srbct  # Lists the different outputs
perf.splsda.srbct$error.rate

perf.splsda.srbct$error.rate.class

# 保存特征稳定性图 - 成分1
pdf("result/stability_comp1.pdf", width = 8, height = 6)
stable.comp1 <- perf.splsda.srbct$features$stable$comp1
barplot(stable.comp1, xlab = 'variables selected across CV folds', 
        ylab = 'Stability frequency',
        main = 'Feature stability for comp = 1')
dev.off()

png("result/stability_comp1.png", width = 800, height = 600, res = 150)
barplot(stable.comp1, xlab = 'variables selected across CV folds', 
        ylab = 'Stability frequency',
        main = 'Feature stability for comp = 1')
dev.off()

# 保存特征稳定性图 - 成分2
pdf("result/stability_comp2.pdf", width = 8, height = 6)
stable.comp2 <- perf.splsda.srbct$features$stable$comp2
barplot(stable.comp2, xlab = 'variables selected across CV folds', 
        ylab = 'Stability frequency',
        main = 'Feature stability for comp = 2')
dev.off()

png("result/stability_comp2.png", width = 800, height = 600, res = 150)
barplot(stable.comp2, xlab = 'variables selected across CV folds', 
        ylab = 'Stability frequency',
        main = 'Feature stability for comp = 2')
dev.off()

# First extract the name of selected var:
select.name <- selectVar(splsda.srbct, comp = 1)$name

# Then extract the stability values from perf:
stability <- perf.splsda.srbct$features$stable$comp1[select.name]

# Just the head of the stability of the selected var:
head(cbind(selectVar(splsda.srbct, comp = 1)$value, stability))

# 保存样本投影图1-2
pdf("result/plotIndiv_comp1_2.pdf", width = 8, height = 6)
plotIndiv(splsda.srbct, comp = c(1,2),
          ind.names = FALSE,
          ellipse = TRUE, legend = TRUE,
          star = TRUE,
          title = 'SRBCT, sPLS-DA comp 1 - 2')
dev.off()

png("result/plotIndiv_comp1_2.png", width = 800, height = 600, res = 150)
plotIndiv(splsda.srbct, comp = c(1,2),
          ind.names = FALSE,
          ellipse = TRUE, legend = TRUE,
          star = TRUE,
          title = 'SRBCT, sPLS-DA comp 1 - 2')
dev.off()

# 保存样本投影图2-3
pdf("result/plotIndiv_comp2_3.pdf", width = 8, height = 6)
plotIndiv(splsda.srbct, comp = c(2,3),
          ind.names = FALSE,
          ellipse = TRUE, legend = TRUE,
          star = TRUE,
          title = 'SRBCT, sPLS-DA comp 2 - 3')
dev.off()

png("result/plotIndiv_comp2_3.png", width = 800, height = 600, res = 150)
plotIndiv(splsda.srbct, comp = c(2,3),
          ind.names = FALSE,
          ellipse = TRUE, legend = TRUE,
          star = TRUE,
          title = 'SRBCT, sPLS-DA comp 2 - 3')
dev.off()

var.name.short <- substr(srbct$gene.name[, 2], 1, 10)

# 保存变量图
pdf("result/plotVar.pdf", width = 8, height = 6)
plotVar(splsda.srbct, comp = c(1,2), 
        var.names = list(var.name.short), cex = 3)
dev.off()

png("result/plotVar.png", width = 800, height = 600, res = 150)
plotVar(splsda.srbct, comp = c(1,2), 
        var.names = list(var.name.short), cex = 3)
dev.off()

# 保存载荷图
pdf("result/plotLoadings.pdf", width = 10, height = 8)
plotLoadings(splsda.srbct, comp = 1, method = 'mean', contrib = 'max', 
             name.var = var.name.short)
dev.off()

png("result/plotLoadings.png", width = 1000, height = 800, res = 150)
plotLoadings(splsda.srbct, comp = 1, method = 'mean', contrib = 'max', 
             name.var = var.name.short)
dev.off()

# 保存聚类热图
pdf("result/cim.pdf", width = 10, height = 8)
cim(splsda.srbct, row.sideColors = color.mixo(Y))
dev.off()

png("result/cim.png", width = 1000, height = 800, res = 150)
cim(splsda.srbct, row.sideColors = color.mixo(Y))
dev.off()

