library(dplyr)
library(ggplot2)
library(cowplot)
library(ggpubr)

# read data
setwd("/Users/wangjingran/Desktop/PTEN_Mutation")
paras <- read.table("data/paras.txt", header = TRUE)
all_co <- read.table("data/MI.csv",sep = ',',header = T)
data <- paras[c(1,2,3)]
colnames(data)[3] <- "coevolution"
data <- data %>% group_by(residue) %>% distinct(Disease, .keep_all = TRUE)
breaks <- c(0, 15, 184, 189, 350, 403)
Region <- cut(data$residue, breaks, 
                   labels = c("PBD", "PD", " ", "C2D", "CTT"), 
                   include.lowest = TRUE)
data$Region <- Region

# Region
start <- c(0, 16, 185, 190, 351)
end <- c(16, 185, 190, 351, 403)
for (i in 1:nrow(data)) {
  if (data$Region[i] == "PBD") {
    data$start[i] <- start[1]
    data$end[i] <- end[1]
  } else if (data$Region[i] == "PD") {
    data$start[i] <- start[2]
    data$end[i]<-  end[2]
  }else if (data$Region[i] == " ") {
    data$start[i] <- start[3]
    data$end[i]<-  end[3]
  } else if (data$Region[i] == "C2D") {
    data$start[i] <- start[4]
    data$end[i] <- end[4]
  } else if (data$Region[i] == "CTT") {
    data$start[i] <- start[5]
    data$end[i] <- end[5]
  }
}

# coevolution
p_co <- ggplot(all_co, aes(x = residue, y = coevolution)) + 
 geom_bar(stat = "identity",
           color = "transparent", 
           fill = "grey",
          width = 0.9)+
  
  labs(x="Residues", y="M(i)", color="Diseases", shape="Diseases") + 
  theme_bw()

p_co <- p_co + geom_point(data=data,aes(x=residue,y=coevolution,color=Disease), position = position_jitterdodge(jitter.width = 0, dodge.width = 1.7),size=3,pch=18) + scale_colour_manual(values=c("#FFBE7A", "#82B0D2",  "#FA7F6F"),breaks = c("Cancer","ASD", "ASD_Cancer"))

p_co <- p_co + scale_x_continuous(limits = c(0,410)) + scale_y_continuous(limits = c(-0.1,0.75))
p_co <- p_co + geom_rect(data = data, aes(xmin = start, xmax = end, ymin = -0.09, ymax = -0.018, fill = Region),color = "transparent")  +
  scale_fill_manual(values =  c("PBD" = '#A1A9D0', "PD" = '#F0988C'," " = "transparent", "C2D" = '#B883D4', "CTT" = "#8ECFC9")) +
  #geom_text(aes(x = start + (end - start)/2, y = -0.22, label = Region), vjust = 0, color = 'black',size = 5) +
  geom_segment(aes(x = 185, y = -0.054, xend = 190, yend = -0.054), color = "grey", linetype = "solid", size = 1)+
  theme_minimal()
p_co <- p_co + theme(panel.border = element_rect(linetype = 'solid', colour = 'black',fill = NA,size = 0.7),
                 panel.grid.major = element_blank(),
                 panel.grid.minor = element_blank())
p_co <- p_co + theme(legend.title = element_text(size = 7), 
                  legend.text = element_text(size = 7),
                  legend.position = c(0.93,0.87),legend.key.size = unit(0.01,"cm"),panel.grid = element_blank(),
                legend.key.height = unit(0.1,"cm")) + guides(fill = "none")
ggsave(p_co, file="figure/Coevolution.pdf", width = 9, height=4)

# violin
p2 <- ggplot(data, aes(x=factor(Disease, levels=c("Cancer", "ASD", "ASD_Cancer")), y=coevolution, fill=Disease, color = Disease)) +
  geom_violin(trim=FALSE) +
  geom_boxplot(width=0.2, fill="white", color="black") +
  scale_fill_manual(values=c( "#FFBE7A", "#82B0D2","#FA7F6F"),limits=c("Cancer", "ASD", 'ASD_Cancer')) +
  scale_color_manual(values=c( "#FFBE7A", "#82B0D2","#FA7F6F"),limits=c("Cancer", "ASD", 'ASD_Cancer')) +
  labs(x="Disease", y="MI", fill="Disease") +
  theme_minimal()
p2 <- p2 + theme(legend.position = "none",panel.grid = element_blank())
p2 <- p2 + stat_compare_means(comparisons = my_comparisons,
                       label.y = c(0.82,0.89,0.82),
                       method = "wilcox.test")
p2 <- p2 + theme(panel.border = element_rect(linetype = 'solid', colour = 'black',fill = NA,size = 0.7),
                 panel.grid.major = element_blank(),
                 panel.grid.minor = element_blank())
ggsave(p2, file="figure/CoevolutionV.pdf", width = 4, height=4)