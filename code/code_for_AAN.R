library(cowplot)
library(ggplot2)
setwd("/Users/wangjingran/Desktop/PTEN_Mutation")
data <- read.table("data/AAN.txt",sep="\t",header=TRUE)

betweenness <- data[,c(1,2,7)]
p1 <- ggplot(betweenness,aes(x=POSITION,y=scale(Betweenness),fill=Disease),alpha = 0.7) + 
  geom_bar(stat = 'identity',width = 2)+
  xlab("Residues")+
  ylab("delta Betweenness")+ 
  theme_cowplot() + theme(axis.line = element_blank(),
  panel.border = element_rect(linetype = 'solid', 
  colour = 'black',fill = NA,size = 1),legend.position="none") + 
  scale_fill_manual(values=c("#FFBE7A", "#82B0D2", "#FA7F6F"),
  breaks = c("Cancer", "ASD", "ASD_Cancer")) + 
  theme(axis.line = element_blank(),
                  legend.title = element_text(size = 7), 
                  legend.text = element_text(size = 7),
                  legend.position = c(0.9,0.87),legend.key.size = unit(0.25,"cm"),
                  panel.border = element_rect(linetype = 'solid', colour = 'black',fill = NA,size = 0.7),
                  panel.grid.major = element_blank(),
                  panel.grid.minor = element_blank())

closeness <- data[,c(1,3,7)]
p2 <- ggplot(closeness,aes(x=POSITION,y=Closeness,fill=Disease),alpha = 0.7) + 
geom_bar(stat = 'identity',width = 2)+
xlab("Residues")+
ylab("delta Closeness")+ 
theme_cowplot() + 
theme(axis.line = element_blank(),panel.border = element_rect(linetype = 'solid', colour = 'black',fill = NA,size = 1),legend.position="none") + 
scale_fill_manual(values=c("#FFBE7A", "#82B0D2", "#FA7F6F"),breaks = c("Cancer", "ASD", "ASD_Cancer")) + 
theme(axis.line = element_blank(),
                  legend.title = element_text(size = 7), 
                  legend.text = element_text(size = 7),
                  legend.position = c(0.9,0.87),legend.key.size = unit(0.25,"cm"),
                  panel.border = element_rect(linetype = 'solid', colour = 'black',fill = NA,size = 0.7),
                  panel.grid.major = element_blank(),
                  panel.grid.minor = element_blank())


degree <- data[,c(1,4,7)]
p3 <- ggplot(degree,aes(x=POSITION,y=Degree,fill=Disease),alpha = 0.7) + 
geom_bar(stat = 'identity',width = 2)+xlab("Residues")+
ylab("delta Degree")+ theme_cowplot() + 
theme(axis.line = element_blank(),panel.border = element_rect(linetype = 'solid', colour = 'black',fill = NA,size = 1),legend.position="none") + 
scale_fill_manual(values=c("#FFBE7A", "#82B0D2", "#FA7F6F"),breaks = c("Cancer", "ASD", "ASD_Cancer")) + 
theme(axis.line = element_blank(),
                  legend.title = element_text(size = 7), 
                  legend.text = element_text(size = 7),
                  legend.position = c(0.9,0.87),legend.key.size = unit(0.25,"cm"),
                  panel.border = element_rect(linetype = 'solid', colour = 'black',fill = NA,size = 0.7),
                  panel.grid.major = element_blank(),
                  panel.grid.minor = element_blank())


evcent <- data[,c(1,5,7)]
p4 <- ggplot(evcent,aes(x=POSITION,y=Eigenvector,fill=Disease),alpha = 0.7) + 
geom_bar(stat = 'identity',width = 2)+
xlab("Residues")+
ylab("delta Eigenvector")+ 
theme_cowplot() + theme(axis.line = element_blank(),panel.border = element_rect(linetype = 'solid', colour = 'black',fill = NA,size = 1),legend.position="none") + 
scale_fill_manual(values=c("#FFBE7A", "#82B0D2", "#FA7F6F"),breaks = c("Cancer", "ASD", "ASD_Cancer")) + 
theme(axis.line = element_blank(),
                  legend.title = element_text(size = 7), 
                  legend.text = element_text(size = 7),
                  legend.position = c(0.9,0.87),legend.key.size = unit(0.25,"cm"),
                  panel.border = element_rect(linetype = 'solid', colour = 'black',fill = NA,size = 0.7),
                  panel.grid.major = element_blank(),
                  panel.grid.minor = element_blank())


transitivity <- data[,c(1,6,7)]
p5 <- ggplot(transitivity,aes(x=POSITION,y=Clustering_coefficient,fill=Disease),alpha = 0.7) + 
geom_bar(stat = 'identity',width = 2)+
xlab("Residues")+
ylab("delta Clustering coefficient")+ 
theme_cowplot() + 
theme(axis.line = element_blank(),panel.border = element_rect(linetype = 'solid', colour = 'black',fill = NA,size = 1),legend.position="none") + 
scale_fill_manual(values=c("#FFBE7A", "#82B0D2", "#FA7F6F"),breaks = c("Cancer", "ASD", "ASD_Cancer")) + 
theme(axis.line = element_blank(),
                  legend.title = element_text(size = 7), 
                  legend.text = element_text(size = 7),
                  legend.position = c(0.9,0.87),legend.key.size = unit(0.25,"cm"),
                  panel.border = element_rect(linetype = 'solid', colour = 'black',fill = NA,size = 0.7),
                  panel.grid.major = element_blank(),
                  panel.grid.minor = element_blank())

ggsave(p1, file="figure/betweenness.pdf", 
       width = 9, height=4)
ggsave(p2, file="figure/closeness.pdf", 
       width = 9, height=4)
ggsave(p3, file="figure/degree.pdf", 
       width = 9, height=4)
ggsave(p4, file="figure/eigenvector.pdf", 
       width = 9, height=4)
ggsave(p5, file="figure/clustering.pdf", 
       width = 9, height=4)