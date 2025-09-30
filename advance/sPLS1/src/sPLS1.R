library(mixOmics)
data(liver.toxicity)
X <- liver.toxicity$gene
Y <- liver.toxicity$clinic

y <- liver.toxicity$clinic[, "ALB.g.dL."]

# 创建结果目录
if (!dir.exists("result")) {
  dir.create("result")
}

tune.pls1.liver <- pls(X = X, Y = y, ncomp = 4, mode = 'regression')
set.seed(33)  # For reproducibility with this handbook, remove otherwise
Q2.pls1.liver <- perf(tune.pls1.liver, validation = 'Mfold', 
                      folds = 10, nrepeat = 5)

# 保存Q2图
pdf("result/Q2_plot.pdf", width = 8, height = 6)
plot(Q2.pls1.liver, criterion = 'Q2')
dev.off()

png("result/Q2_plot.png", width = 800, height = 600, res = 150)
plot(Q2.pls1.liver, criterion = 'Q2')
dev.off()

# Set up a grid of values: 
list.keepX <- c(5:10, seq(15, 50, 5))     

# list.keepX  # Inspect the keepX grid
set.seed(33)  # For reproducibility with this handbook, remove otherwise
tune.spls1.MAE <- tune.spls(X, y, ncomp= 2, 
                            test.keepX = list.keepX, 
                            validation = 'Mfold', 
                            folds = 10,
                            nrepeat = 5, 
                            progressBar = FALSE, 
                            measure = 'MAE')

# 保存调优图
pdf("result/tune_spls1_MAE.pdf", width = 8, height = 6)
plot(tune.spls1.MAE)
dev.off()

png("result/tune_spls1_MAE.png", width = 800, height = 600, res = 150)
plot(tune.spls1.MAE)
dev.off()

choice.ncomp <- tune.spls1.MAE$choice.ncomp$ncomp
# Optimal number of variables to select in X based on the MAE criterion
# We stop at choice.ncomp
choice.keepX <- tune.spls1.MAE$choice.keepX[1:choice.ncomp]  

choice.ncomp
choice.keepX

spls1.liver <- spls(X, y, ncomp = choice.ncomp, keepX = choice.keepX, 
                    mode = "regression")
selectVar(spls1.liver, comp = 1)$X$name
spls1.liver$prop_expl_var$X
tune.pls1.liver$prop_expl_var$X

spls1.liver.c2 <- spls(X, y, ncomp = 2, keepX = c(rep(choice.keepX, 2)), 
                   mode = "regression")

# 保存样本投影图
pdf("result/spls_sample_plot.pdf", width = 8, height = 6)
plotIndiv(spls1.liver.c2,
          group = liver.toxicity$treatment$Time.Group,
          pch = as.factor(liver.toxicity$treatment$Dose.Group),
          legend = TRUE, legend.title = 'Time', legend.title.pch = 'Dose')
dev.off()

png("result/spls_sample_plot.png", width = 800, height = 600, res = 150)
plotIndiv(spls1.liver.c2,
          group = liver.toxicity$treatment$Time.Group,
          pch = as.factor(liver.toxicity$treatment$Dose.Group),
          legend = TRUE, legend.title = 'Time', legend.title.pch = 'Dose')
dev.off()

# Define factors for colours matching plotIndiv above
time.liver <- factor(liver.toxicity$treatment$Time.Group, 
                     levels = c('18', '24', '48', '6'))
dose.liver <- factor(liver.toxicity$treatment$Dose.Group, 
                     levels = c('50', '150', '1500', '2000'))
# Set up colours and symbols
col.liver <- color.mixo(time.liver)
pch.liver <- as.numeric(dose.liver)

# 保存变量散点图
pdf("result/variates_scatter_plot.pdf", width = 8, height = 6)
plot(spls1.liver$variates$X, spls1.liver$variates$Y,
     xlab = 'X component', ylab = 'y component / scaled y',
     col = col.liver, pch = pch.liver)
legend('topleft', col = color.mixo(1:4), legend = levels(time.liver),
       lty = 1, title = 'Time')
legend('bottomright', legend = levels(dose.liver), pch = 1:4,
       title = 'Dose')
dev.off()

png("result/variates_scatter_plot.png", width = 800, height = 600, res = 150)
plot(spls1.liver$variates$X, spls1.liver$variates$Y,
     xlab = 'X component', ylab = 'y component / scaled y',
     col = col.liver, pch = pch.liver)
legend('topleft', col = color.mixo(1:4), legend = levels(time.liver),
       lty = 1, title = 'Time')
legend('bottomright', legend = levels(dose.liver), pch = 1:4,
       title = 'Dose')
dev.off()

cor(spls1.liver$variates$X, spls1.liver$variates$Y)

set.seed(33)  # For reproducibility with this handbook, remove otherwise

# PLS1 model and performance
pls1.liver <- pls(X, y, ncomp = choice.ncomp, mode = "regression")
perf.pls1.liver <- perf(pls1.liver, validation = "Mfold", folds =10, 
                   nrepeat = 5, progressBar = FALSE)
perf.pls1.liver$measures$MSEP$summary

# To extract values across all repeats:
# perf.pls1.liver$measures$MSEP$values

# sPLS1 performance
perf.spls1.liver <- perf(spls1.liver, validation = "Mfold", folds = 10, 
                   nrepeat = 5, progressBar = FALSE)
perf.spls1.liver$measures$MSEP$summary