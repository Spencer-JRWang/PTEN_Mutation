library(dplyr)
library(ggplot2)
library(cowplot)
library(ggpubr)

# read data
setwd("/Users/wangjingran/Desktop/PTEN_Mutation")
paras <- read.table("data/paras.txt", header = TRUE)
data <- paras[,c(1,2,8)]

# region
data <- data %>% group_by(residue) %>% distinct(Disease, .keep_all = TRUE)
data$ddG <- scale(data$ddG)
breaks <- c(0, 15, 184, 189, 350, 403)
Region <- cut(data$residue, breaks, 
                   labels = c("PBD", "PD", " ", "C2D", "CTT"), 
                   include.lowest = TRUE)
data$Region <- Region
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

# ddG histogram plot
p_tt <- ggplot(data,aes(x=residue,y=ddG,fill=Disease)) + 
geom_bar(stat = 'identity',width = 2) +
xlab("Residue")+ylab("ddG") +
theme_cowplot()+ 
theme(axis.line = element_blank(),panel.border = element_rect(linetype = 'solid', colour = 'black',fill = NA,size = 1),legend.position="none") + 
scale_fill_manual(values=c( "#FFBE7A","#82B0D2", "#FA7F6F"),limits = c("Cancer", "ASD",  'ASD_Cancer')) + theme_minimal() +
  theme(panel.border = element_rect(linetype = 'solid', colour = 'black',fill = NA,size = 0.7),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())+
  theme(legend.position = c(0.9,0.85),panel.grid = element_blank(),legend.key.width  = unit(0.3, "cm"),legend.key.height = unit(0.3,"cm"))
ggsave(p_tt, file="figure/ddG.pdf", width = 9, height = 4)

# ddG violin plot
p_ttv <- ggplot(data, aes(x=factor(Disease, levels=c("Cancer","ASD","ASD_Cancer")), y=ddG, fill=Disease, color = Disease)) +
  geom_violin(trim=FALSE) +
  geom_boxplot(width=0.2, fill="white", color="black") +
  scale_fill_manual(values=c("#FFBE7A","#82B0D2", "#FA7F6F"),limits=c("Cancer","ASD","ASD_Cancer")) +
  scale_color_manual(values=c("#FFBE7A","#82B0D2", "#FA7F6F"),limits=c("Cancer","ASD","ASD_Cancer")) +
  labs(x="Disease", y="Total_Energy", fill="Disease") +
  theme_minimal()
my_comparisons <- list(c("Cancer","ASD"), c("Cancer","ASD_Cancer"), c("ASD","ASD_Cancer"))
#p_ttv <- p_ttv + scale_y_continuous(limits = c(4,12.75))
p_ttv <- p_ttv + theme(legend.position = "none",panel.grid = element_blank())
p_ttv <- p_ttv + stat_compare_means(comparisons = my_comparisons,
                       label.y = c(10,11,10),
                       method = "wilcox.test")
p_ttv <- p_ttv  + theme(panel.border = element_rect(linetype = 'solid', colour = 'black',fill = NA,size = 0.7),
                 panel.grid.major = element_blank(),
                 panel.grid.minor = element_blank())
ggsave(p_ttv, file="figure/ddGV.pdf", width = 4, height = 4)
