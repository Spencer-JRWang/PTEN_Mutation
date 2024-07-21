library(dplyr)
library(ggplot2)
library(cowplot)
library(ggpubr)

# read data
setwd("/Users/wangjingran/Desktop/PTEN_Mutation")
paras <- read.csv("data/Entropy.csv", header = TRUE)
all_en <- read.table("data/Si.csv",sep = ',',header = T)
colnames(all_en) <- c("residue","Entropy")
data <- paras[c(1,2,3)]
data <- data %>% group_by(residue) %>% distinct(Disease, .keep_all = TRUE)
breaks <- c(0, 15, 184, 189, 350, 403)
Region <- cut(data$residue, breaks, 
                   labels = c("PBD", "PD", " ", "C2D", "CTT"), 
                   include.lowest = TRUE)
data$Region <- Region

# region
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

# Entropy
p_en <- ggplot(all_en, aes(x = residue, y = Entropy)) + 
 geom_bar(stat = "identity",
           color = "transparent", 
           fill = "grey",
          width = 0.9)+
  
  labs(x="Residues", y="S(i)", color="Diseases", shape="Diseases") + 
  theme_bw()
p_en <- p_en + geom_point(data=data,aes(x=residue,y=Entropy,color=Disease), position = position_jitterdodge(jitter.width = 0, dodge.width = 1.7),size=3.5,pch=18) + 
  scale_colour_manual(values=c("#FFBE7A","#82B0D2", "#FA7F6F"),breaks = c("Cancer","ASD", "ASD_Cancer"))
p_en <- p_en + scale_x_continuous(limits = c(0,410)) + scale_y_continuous(limits = c(-0.3,2.6))
p_en <- p_en + geom_rect(data = data, aes(xmin = start, xmax = end, ymin = -0.3, ymax = -0.06, fill = Region),color = "transparent")  +
  scale_fill_manual(values = c("PBD" = '#A1A9D0', "PD" = '#F0988C'," " = "transparent", "C2D" = '#B883D4', "CTT" = "#8ECFC9")) +
  geom_segment(aes(x = 185, y = -0.18, xend = 190, yend = -0.18), color = "grey", linetype = "solid", size = 1)+
  theme_minimal()
p_en <- p_en + theme(panel.border = element_rect(linetype = 'solid', colour = 'black',fill = NA,size = 0.7),
                 panel.grid.major = element_blank(),
                 panel.grid.minor = element_blank())
p_en <- p_en + theme(legend.title = element_text(size = 7), 
                  legend.text = element_text(size = 7),
                  legend.position = c(0.93,0.87),legend.key.size = unit(0.01,"cm"),panel.grid = element_blank()) + guides(fill = "none")
ggsave(p_en, file="figure/Entropy.pdf", width = 9, height=4)

# Violin
p1 <- ggplot(data, aes(x=factor(Disease, levels=c("Cancer","ASD", "ASD_Cancer")), y=Entropy, fill=Disease, color = Disease)) +
  geom_violin(trim=FALSE) +
  theme(legend.position = "none") +
  theme(panel.border = element_blank()) +
  geom_boxplot(width=0.2, fill="white", color="black") +
  scale_fill_manual(values=c("#FFBE7A","#82B0D2", "#FA7F6F"),limits=c("Cancer","ASD", "ASD_Cancer")) +
  scale_color_manual(values=c("#FFBE7A", "#82B0D2", "#FA7F6F"),limits=c("Cancer","ASD", "ASD_Cancer")) +
  labs(x="Disease", y="S(i)", fill="Disease") +
  theme_classic()
my_comparisons <- list(c("Cancer","ASD"), c("Cancer","ASD_Cancer"), c("ASD","ASD_Cancer"))
p1 <- p1 + stat_compare_means(comparisons = my_comparisons,
                       label.y = c(3.3,3.55,3.3),
                       method = "wilcox.test")
p1 <- p1 + theme(legend.position = "none",panel.grid = element_blank())
p1 <- p1 + theme(axis.line = element_blank(),
                 panel.border = element_rect(linetype = 'solid', colour = 'black',fill = NA,size = 0.7),
                 panel.grid.major = element_blank(),
                 panel.grid.minor = element_blank())
ggsave(p1, file="figure/EntoryV.pdf", width = 4, height = 4)