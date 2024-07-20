library(dplyr)
library(ggplot2)
library(cowplot)
library(ggpubr)

# Read data
Score_ASD <- read.table("/Users/wangjingran/Desktop/PTEN mutation/Research-main/data/Score_new_new/ASD_AC_Stacking_new4.txt", header = T, sep = "\t")
for (i in 1:nrow(Score_ASD)){
  if (Score_ASD[i,1] == 'ASD_Cancer'){
    Score_ASD[i,1] <- 'ASD_Cancer_1'
  }
}
Score_Cancer <- read.table("/Users/wangjingran/Desktop/LightGBM_Cancer vs ASD_Cancer.txt", header = T, sep = "\t")
for (i in 1:nrow(Score_Cancer)){
  if (Score_Cancer[i,1] == '1'){
    Score_Cancer[i,1] <- 'ASD_Cancer_2'
  }
  else{
    Score_Cancer[i,1] <- 'Cancer'
  }
}
Score <- rbind(Score_ASD, Score_Cancer)
Score_ASD_1 <- Score[Score$Disease == "ASD"|Score$Disease == "ASD_Cancer_1",]
Score_Cancer_1 <- Score[Score$Disease == "Cancer"|Score$Disease == "ASD_Cancer_2",]
Score_ASD_1$Disease <- factor(Score_ASD_1$Disease,levels = c("ASD","ASD_Cancer_1"))
Score_Cancer_1$Disease <- factor(Score_Cancer_1$Disease,levels = c("Cancer","ASD_Cancer_2"))
opar <- par()

pdf("figure/Score.pdf",height = 8,width = 8)
par(cex.axis = 0.8, cex.lab = 0.8,mfrow = c(1,2))
boxplot(IntegratedScore~Disease, data = Score_ASD_1, main = "IntegratedScore",xlab = "Disease", ylab = "Score",outline = FALSE,
        col = c('#A1A9D0','#c2acda'))
stripchart(IntegratedScore~Disease,data = Score_ASD_1 ,method = "jitter", vertical = TRUE, add = TRUE, pch = 19, col = rgb(45, 67, 121, 107, maxColorValue = 255))
abline(h = 0.5,lty = 2)
legend(0.43,0.97,
       c("ASD", "ASD_Cancer"),
       pch = 15,
       col = c('#A1A9D0','#FA7F6F'),
       bty = "n",
       cex = 0.8)
boxplot(IntegratedScore~Disease, data = Score_Cancer_1, main = "IntegratedScore",xlab = "Disease", ylab = "Score",outline = FALSE,
        col = c('#F0988C','#FA7F6F'))
stripchart(IntegratedScore~Disease,data = Score_Cancer_1, method = "jitter", vertical = TRUE, add = TRUE, pch = 19, col = rgb(45, 67, 121, 107, maxColorValue = 255))
abline(h = 0.5,lty = 2)
legend(0.43,0.98,
       c("Cancer", "ASD_Cancer"),
       pch = 15,
       col = c('#F0988C','#c2acda'),
       bty = "n",
       cex = 0.8)
dev.off()
par(opar)