library(cowplot)
library(ggplot2)
library(ggpubr)
setwd("/Users/wangjingran/Desktop/PTEN_Mutation")
data <- read.table("data/AAN.txt",sep="\t",header=TRUE)

betweenness <- data[,c(1,2,7)]
p1 <- ggplot(betweenness,aes(x=POSITION,y=Betweenness,fill=Disease),alpha = 0.7) + 
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

# Violin
betweenness <- data[,c(1,2,7)]
closeness <- data[,c(1,3,7)]
degree <- data[,c(1,4,7)]
evcent <- data[,c(1,5,7)]
transitivity <- data[,c(1,6,7)]

my_comparisons <- list(c("Cancer", "ASD"), c('Cancer', 'ASD_Cancer'), c("ASD", "ASD_Cancer"))

pv6 <- ggplot(betweenness, aes(x=factor(Disease, levels=c("Cancer", "ASD","ASD_Cancer")), y=Betweenness, fill = Disease, color = Disease)) +
  geom_violin(trim=FALSE) +
  geom_boxplot(width=0.2, fill="white", color="black") +
  scale_fill_manual(values=c("#8ECFC9", "#FFBE7A", "#FA7F6F", "#82B0D2"),limits=c("Cancer", "ASD", 'ASD_Cancer')) +
  scale_color_manual(values=c("#8ECFC9", "#FFBE7A", "#FA7F6F", "#82B0D2"),limits=c("Cancer", "ASD", 'ASD_Cancer')) +
  labs(x="Disease", y="delta Betweenness", fill="Disease") +
  theme_minimal()
#pv6 <- pv6 + scale_y_continuous(limits = c(-15,29))
pv6 <- pv6 + theme(legend.position = "none",panel.grid = element_blank())
pv6 <- pv6 + stat_compare_means(comparisons = my_comparisons,
                       label.y = c(300,350,300),
                       method = "wilcox.test")
pv6 <- pv6 + theme(axis.line = element_blank(),
                  panel.border = element_rect(linetype = 'solid', colour = 'black',fill = NA,size = 0.7),
                  panel.grid.major = element_blank(),
                  panel.grid.minor = element_blank())



pv7 <- ggplot(closeness, aes(x=factor(Disease, levels=c("Cancer", "ASD", "ASD_Cancer")), y=Closeness, fill = Disease, color = Disease)) +
  geom_violin(trim=FALSE) +
  geom_boxplot(width=0.2, fill="white", color="black") +
  scale_fill_manual(values=c("#FFBE7A", "#82B0D2", "#FA7F6F"),limits=c("Cancer", "ASD",'ASD_Cancer')) +
  scale_color_manual(values=c("#FFBE7A", "#82B0D2", "#FA7F6F"),limits=c("Cancer", "ASD",'ASD_Cancer')) +
  labs(x="Disease", y="delta Closeness", fill="Disease") +
  theme_minimal()
#pv7 <- pv7 + scale_y_continuous(limits = c(-2.3e-06,7e-06))
pv7 <- pv7 + theme(legend.position = "none",panel.grid = element_blank())
pv7 <- pv7 + stat_compare_means(comparisons = my_comparisons,
                       label.y = c(0.83e-06,1e-06,0.83e-06),
                       method = "wilcox.test")
pv7 <- pv7 + theme(axis.line = element_blank(),
                  panel.border = element_rect(linetype = 'solid', colour = 'black',fill = NA,size = 0.7),
                  panel.grid.major = element_blank(),
                  panel.grid.minor = element_blank())


pv8 <- ggplot(degree, aes(x=factor(Disease, levels=c("Cancer", "ASD", "ASD_Cancer")), y=Degree, fill = Disease, color = Disease)) +
  geom_violin(trim=FALSE) +
  geom_boxplot(width=0.2, fill="white", color="black") +
  scale_fill_manual(values=c("#FFBE7A", "#82B0D2", "#FA7F6F"),limits=c("Cancer", "ASD",'ASD_Cancer')) +
  scale_color_manual(values=c("#FFBE7A", "#82B0D2", "#FA7F6F"),limits=c("Cancer", "ASD",'ASD_Cancer')) +
  labs(x="Disease", y="delta Degree", fill="Disease") +
  theme_minimal()

pv8 <- pv8 + theme(legend.position = "none",panel.grid = element_blank())
pv8 <- pv8 + stat_compare_means(comparisons = my_comparisons,
                       label.y = c(0.15,0.17,0.15),
                       method = "wilcox.test")
pv8 <- pv8 + theme(axis.line = element_blank(),
                  panel.border = element_rect(linetype = 'solid', colour = 'black',fill = NA,size = 0.7),
                  panel.grid.major = element_blank(),
                  panel.grid.minor = element_blank())


pv9 <- ggplot(evcent, aes(x=factor(Disease, levels=c("Cancer", "ASD", "ASD_Cancer")), y=Eigenvector, fill = Disease, color = Disease)) +
  geom_violin(trim=FALSE) +
  geom_boxplot(width=0.2, fill="white", color="black") +
  scale_fill_manual(values=c("#FFBE7A", "#82B0D2", "#FA7F6F"),limits=c("Cancer", "ASD",'ASD_Cancer')) +
  scale_color_manual(values=c("#FFBE7A", "#82B0D2", "#FA7F6F"),limits=c("Cancer", "ASD",'ASD_Cancer')) +
  labs(x="Disease", y="delta Eigenvector", fill="Disease") +
  theme_minimal()

pv9 <- pv9 + theme(legend.position = "none",panel.grid = element_blank())
pv9 <- pv9 + stat_compare_means(comparisons = my_comparisons,
                       label.y = c(0.37,0.42,0.37),
                       method = "wilcox.test")
pv9 <- pv9 + theme(axis.line = element_blank(),
                  panel.border = element_rect(linetype = 'solid', colour = 'black',fill = NA,size = 0.7),
                 panel.grid.major = element_blank(),
                 panel.grid.minor = element_blank())

pv10 <- ggplot(transitivity, aes(x=factor(Disease, levels=c("Cancer", "ASD", "ASD_Cancer")), y=Clustering_coefficient, fill = Disease, color = Disease)) +
  geom_violin(trim=FALSE) +
  geom_boxplot(width=0.2, fill="white", color="black") +
  scale_fill_manual(values=c("#FFBE7A", "#82B0D2", "#FA7F6F"),limits=c("Cancer", "ASD",'ASD_Cancer')) +
  scale_color_manual(values=c("#FFBE7A", "#82B0D2", "#FA7F6F"),limits=c("Cancer", "ASD",'ASD_Cancer')) +
  labs(x="Disease", y="delta Clustering Coefficient", fill="Disease") +
  theme_minimal()

pv10 <- pv10 + theme(legend.position = "none",panel.grid = element_blank())
pv10 <- pv10 + stat_compare_means(comparisons = my_comparisons,
                       label.y = c(0.4,0.47,0.4),
                       method = "wilcox.test")
pv10 <- pv10 + theme(axis.line = element_blank(),
                  panel.border = element_rect(linetype = 'solid', colour = 'black',fill = NA,size = 0.7),
                  panel.grid.major = element_blank(),
                  panel.grid.minor = element_blank())


ggsave <- ggsave(pv6,filename = "figure/betweenness_violin.pdf",width = 4,height = 4)
ggsave <- ggsave(pv7,filename = "figure/closeness_violin.pdf",width = 4,height = 4)
ggsave <- ggsave(pv8,filename = "figure/degree_violin.pdf",width = 4,height = 4)
ggsave <- ggsave(pv9,filename = "figure/eigenvector_violin.pdf",width = 4,height = 4)
ggsave <- ggsave(pv10,filename = "figure/clustering_coefficient_violin.pdf",width = 4,height = 4)