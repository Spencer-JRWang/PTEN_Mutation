library(dplyr)
library(ggplot2)
library(cowplot)
library(ggpubr)

# read data
setwd("/Users/wangjingran/Desktop/Research")
paras <- read.table("data/paras.txt", header = TRUE)
all <- read.table("data/dyn.txt",sep="\t",header=TRUE)

# possess data
site <- paras[,c(1,2)]
site <- site %>% group_by(residue) %>% distinct(Disease, .keep_all = TRUE)
df_dong <- all[site$residue,-1]
data <- cbind(site, df_dong)
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

# Effectiveness
p1 <- ggplot(all, aes(x = residue, y = Effectiveness)) + 
  geom_bar(stat = "identity", 
           color = "transparent",
           fill = "grey") +
  xlab("Residues") + ylab("Effectiveness") + 
  theme_cowplot()
p1 <- p1 + geom_point(data = data, aes(x = residue, y = Effectiveness, color = Disease), position = position_jitterdodge(jitter.width = 0, dodge.width = 1.7),size = 3, pch = 18) + 
  scale_colour_manual(values = c("#82B0D2", "#FFBE7A", "#FA7F6F"), 
                      breaks = c("ASD", "Cancer", "ASD_Cancer")) + 
  theme_cowplot() + theme(legend.position="none")
p1 <- p1 + geom_rect(data = data, aes(xmin = start, xmax = end, ymin = -3.4, ymax = -0.2, fill = Region),color = "transparent")  +
  scale_fill_manual(values = c("PBD" = '#A1A9D0', "PD" = '#F0988C'," " = "transparent", "C2D" = '#B883D4', "CTT" = "#8ECFC9")) +
  geom_segment(aes(x = 185, y = -1.8, xend = 190, yend = -1.8), color = "grey", linetype = "solid", size = 1)+
  theme_minimal()
p1 <- p1 +  theme(axis.line = element_blank(),
                  legend.title = element_text(size = 7), 
                  legend.text = element_text(size = 7),
                  panel.border = element_rect(linetype = 'solid', colour = 'black',fill = NA,size = 0.7),
                  legend.position = c(0.9,0.87),legend.key.size = unit(0.01,"cm"),
                  panel.grid.major = element_blank(),
                  panel.grid.minor = element_blank()) + guides(fill = "none")


# Sensitivity
p2 <- ggplot(all[1:395,],aes(x=residue,y=Sensitivity)) + 
  geom_bar(stat = "identity", 
           color = "transparent", 
           fill = "grey")  +
  xlab("Residues")+ylab('Sensitivity') + theme_cowplot()
p2 <- p2 + geom_point(data=data[data$residue<=395,], aes(x=residue,y=Sensitivity,color=Disease),size=3,pch=18,position = position_jitterdodge(jitter.width = 0, dodge.width = 1.7)) +
    scale_colour_manual(values=c("#82B0D2", "#FFBE7A", "#FA7F6F"),breaks = c("ASD", "Cancer", "ASD_Cancer"))+ theme_cowplot() +  theme(legend.position="none")
p2 <- p2 + geom_rect(data = data, aes(xmin = start, xmax = end, ymin = -0.48, ymax = -0.02, fill = Region),color = "transparent")  +
  scale_fill_manual(values = c("PBD" = '#A1A9D0', "PD" = '#F0988C'," " = "transparent", "C2D" = '#B883D4', "CTT" = "#8ECFC9")) +
  geom_segment(aes(x = 185, y = -0.25, xend = 190, yend = -0.25), color = "grey", linetype = "solid", size = 1)+
  theme_minimal()+ scale_y_continuous(limits = c(-0.5,5.5))
p2 <- p2 +  theme(axis.line = element_blank(),
                  legend.title = element_text(size = 7), 
                  legend.text = element_text(size = 7),
                  legend.position = c(0.9,0.87),legend.key.size = unit(0.01,"cm"),
                  panel.border = element_rect(linetype = 'solid', colour = 'black',fill = NA,size = 0.7),
                  panel.grid.major = element_blank(),
                  panel.grid.minor = element_blank()) + guides(fill = "none")

# MSF
p3 <- ggplot(all,aes(x=residue,y=MSF)) + 
  geom_bar(stat = "identity", 
           color = "transparent", 
           fill = "grey") +
  xlab("Residues")+ylab('MSF') + theme_cowplot()
p3 <- p3 + geom_point(data=data,aes(x=residue,y=MSF,color=Disease),size=3,pch=18,position = position_jitterdodge(jitter.width = 0, dodge.width = 1.7)) + 
    scale_colour_manual(values=c("#82B0D2", "#FFBE7A", "#FA7F6F"),breaks = c("ASD", "Cancer", "ASD_Cancer"))+ theme_cowplot() + theme(legend.position="none")+ theme(legend.position="none")
p3 <- p3 + geom_rect(data = data, aes(xmin = start, xmax = end, ymin = -0.12, ymax = -0.01, fill = Region),color = "transparent")  +
  scale_fill_manual(values = c("PBD" = '#A1A9D0', "PD" = '#F0988C'," " = "transparent", "C2D" = '#B883D4', "CTT" = "#8ECFC9")) +
  geom_segment(aes(x = 185, y = -0.065, xend = 190, yend = -0.065), color = "grey", linetype = "solid", size = 1)+
  theme_minimal()
p3 <- p3 +  theme(axis.line = element_blank(),
                  legend.title = element_text(size = 7), 
                  legend.text = element_text(size = 7),
                  legend.position = c(0.8,0.87),legend.key.size = unit(0.01,"cm"),
                  panel.border = element_rect(linetype = 'solid', colour = 'black',fill = NA,size = 0.7),
                  panel.grid.major = element_blank(),
                  panel.grid.minor = element_blank())+ guides(fill = "none")

# DFI
p4 <- ggplot(all,aes(x=residue,y=DFI)) + 
  geom_bar(stat = "identity", 
           color = "transparent", 
           fill = "grey") +
  xlab("Residues")+ylab('DFI') + theme_cowplot()
p4 <- p4 + geom_point(data=data,aes(x=residue,y=DFI,color=Disease),size=3,pch=18,position = position_jitterdodge(jitter.width = 0, dodge.width = 1.7)) + 
    scale_colour_manual(values=c("#82B0D2", "#FFBE7A", "#FA7F6F"),breaks = c("ASD", "Cancer", "ASD_Cancer"))+ theme_cowplot()+ theme(legend.position="none")

p4 <- p4 + geom_rect(data = data, aes(xmin = start, xmax = end, ymin = -0.0012, ymax = -0.00008, fill = Region),color = "transparent")  +
  scale_fill_manual(values = c("PBD" = '#A1A9D0', "PD" = '#F0988C'," " = "transparent", "C2D" = '#B883D4', "CTT" = "#8ECFC9")) +
  geom_segment(aes(x = 185, y = -0.00064, xend = 190, yend = -0.00064), color = "grey", linetype = "solid", size = 1)+
  theme_minimal()

p4 <- p4 +  theme(axis.line = element_blank(),
                  legend.title = element_text(size = 7), 
                  legend.text = element_text(size = 7),
                  legend.position = c(0.9,0.87),legend.key.size = unit(0.01,"cm"),
                  panel.border = element_rect(linetype = 'solid', colour = 'black',fill = NA,size = 0.7),
                  panel.grid.major = element_blank(),
                  panel.grid.minor = element_blank()) + guides(fill = "none")

# Stiffness
p5 <- ggplot(all,aes(x=residue,y=Stiffness)) + 
  geom_bar(stat = "identity", 
           color = "transparent", 
           fill = "grey") +
  xlab("Residues")+ylab('Stiffness') + theme_cowplot()
p5 <- p5 + geom_point(data=data,aes(x=residue,y=Stiffness,color=Disease),size=3,pch=18,position = position_jitterdodge(jitter.width = 0, dodge.width = 1.7)) + 
    scale_colour_manual(values=c("#82B0D2", "#FFBE7A", "#FA7F6F"),breaks = c("ASD", "Cancer", "ASD_Cancer"))+ theme_cowplot()+ theme(legend.position="none")
p5 <- p5 + geom_rect(data = data, aes(xmin = start, xmax = end, ymin = -1.6, ymax = -0.1, fill = Region),color = "transparent")  +
  scale_fill_manual(values = c("PBD" = '#A1A9D0', "PD" = '#F0988C'," " = "transparent", "C2D" = '#B883D4', "CTT" = "#8ECFC9")) +
  geom_segment(aes(x = 185, y = -0.85, xend = 190, yend = -0.85), color = "grey", linetype = "solid", size = 1)+
  theme_minimal()
p5 <- p5 +  theme(axis.line = element_blank(),
                  legend.title = element_text(size = 7), 
                  legend.text = element_text(size = 7),
                  legend.position = c(0.9,0.87),legend.key.size = unit(0.01,"cm"),
                  panel.border = element_rect(linetype = 'solid', colour = 'black',fill = NA,size = 0.7),
                  panel.grid.major = element_blank(),
                  panel.grid.minor = element_blank()) + guides(fill = "none")

# Save
ggsave(p1, file="figure/Effectiveness.pdf", 
       width = 9, height= 4)
ggsave(p2, file="figure/Sensitivity.pdf", 
       width = 9, height = 4)
ggsave(p3, file="figure/MSF.pdf", 
       width = 9, height = 4)
ggsave(p4, file="figure/DFI.pdf", 
       width = 9, height=4)
ggsave(p5, file="figure/Stiffness.pdf", 
       width = 9, height = 4)

# Violin
pv1 <- ggplot(data, aes(x=factor(Disease, levels=c("ASD", "Cancer", "ASD_Cancer")), y=Effectiveness, fill = Disease, color = Disease)) +
  geom_violin(trim=FALSE) +
  geom_boxplot(width=0.2, fill="white", color="black") +
  scale_fill_manual(values=c("#82B0D2", "#FFBE7A", "#FA7F6F"),limits=c("ASD", "Cancer", 'ASD_Cancer')) +
  scale_color_manual(values=c("#82B0D2", "#FFBE7A", "#FA7F6F"),limits=c("ASD", "Cancer", 'ASD_Cancer')) +
  labs(x="Disease", y="Effectiveness", fill="Disease") +
  theme_minimal()
my_comparisons <- list(c("ASD", "Cancer"), c('ASD', 'ASD_Cancer'), c( 'Cancer','ASD_Cancer'))
pv1 <- pv1 + scale_y_continuous(limits = c(-5,54))
pv1 <- pv1 + theme(legend.position = "none",panel.grid = element_blank())
pv1 <- pv1 + stat_compare_means(comparisons = my_comparisons,
                       label.y = c(48,52,48),
                       method = "wilcox.test")
pv1 <- pv1 + theme(axis.line = element_blank(),
                  panel.border = element_rect(linetype = 'solid', colour = 'black',fill = NA,size = 0.7),
                  panel.grid.major = element_blank(),
                  panel.grid.minor = element_blank())

pv2 <- ggplot(data, aes(x=factor(Disease, levels=c("ASD", "Cancer", "ASD_Cancer")), y = Sensitivity, fill = Disease, color = Disease)) +
  geom_violin(trim=FALSE) +
  geom_boxplot(width=0.2, fill="white", color="black") +
  scale_fill_manual(values=c("#82B0D2", "#FFBE7A", "#FA7F6F"),limits=c("ASD", "Cancer", 'ASD_Cancer')) +
  scale_color_manual(values=c("#82B0D2", "#FFBE7A", "#FA7F6F"),limits=c("ASD", "Cancer", 'ASD_Cancer')) +
  labs(x="Disease", y="Sensitivity", fill="Disease") +
  theme_minimal()
#pv2 <- pv2 + scale_y_continuous(limits = c(-0.007,0.073))
pv2 <- pv2 + theme(legend.position = "none",panel.grid = element_blank())
pv2 <- pv2 + stat_compare_means(comparisons = my_comparisons,
                       label.y = c(120,130,120),
                       method = "wilcox.test")
pv2 <- pv2 + theme(axis.line = element_blank(),
                  panel.border = element_rect(linetype = 'solid', colour = 'black',fill = NA,size = 0.7),
                  panel.grid.major = element_blank(),
                  panel.grid.minor = element_blank())

pv3 <- ggplot(data, aes(x=factor(Disease, levels=c("ASD", "Cancer", "ASD_Cancer")), y = MSF, fill = Disease, color = Disease)) +
  geom_violin(trim=FALSE) +
  geom_boxplot(width=0.2, fill="white", color="black") +
  scale_fill_manual(values=c("#82B0D2", "#FFBE7A", "#FA7F6F"),limits=c("ASD", "Cancer", 'ASD_Cancer')) +
  scale_color_manual(values=c("#82B0D2", "#FFBE7A", "#FA7F6F"),limits=c("ASD", "Cancer", 'ASD_Cancer')) +
  labs(x="Disease", y="MSF", fill="Disease") +
  theme_minimal()
pv3 <- pv3 + theme(legend.position = "none",panel.grid = element_blank())
pv3 <- pv3 + stat_compare_means(comparisons = my_comparisons,
                      label.y = c(1,1.1,1),
                       method = "wilcox.test")
pv3 <- pv3 + theme(axis.line = element_blank(),
                  panel.border = element_rect(linetype = 'solid', colour = 'black',fill = NA,size = 0.7),
                  panel.grid.major = element_blank(),
                  panel.grid.minor = element_blank())

pv4 <- ggplot(data, aes(x=factor(Disease, levels=c("ASD", "Cancer", "ASD_Cancer", "Control")), y = DFI, fill = Disease, color = Disease)) +
  geom_violin(trim=FALSE) +
  geom_boxplot(width=0.2, fill="white", color="black") +
  scale_fill_manual(values=c("#82B0D2", "#FFBE7A", "#FA7F6F"),limits=c("ASD", "Cancer", 'ASD_Cancer')) +
  scale_color_manual(values=c("#82B0D2", "#FFBE7A", "#FA7F6F"),limits=c("ASD", "Cancer", 'ASD_Cancer')) +
  labs(x="Disease", y="DFI", fill="Disease") +
  theme_minimal()

#pv4 <- pv4 + scale_y_continuous(limits = c(-0.0005,0.0097))
pv4 <- pv4 + theme(legend.position = "none",panel.grid = element_blank())
pv4 <- pv4 + stat_compare_means(comparisons = my_comparisons,
                      label.y = c(0.017,0.019,0.017),
                       method = "wilcox.test")
pv4 <- pv4 + theme(axis.line = element_blank(),
                  panel.border = element_rect(linetype = 'solid', colour = 'black',fill = NA,size = 0.7),
                  panel.grid.major = element_blank(),
                  panel.grid.minor = element_blank())

pv5 <- ggplot(data, aes(x=factor(Disease, levels=c("ASD", "Cancer", "ASD_Cancer", "Control")), y = Stiffness, fill = Disease, color = Disease)) +
  geom_violin(trim=FALSE) +
  geom_boxplot(width=0.2, fill="white", color="black") +
  scale_fill_manual(values=c("#82B0D2", "#FFBE7A", "#FA7F6F"),limits=c("ASD", "Cancer", 'ASD_Cancer')) +
  scale_color_manual(values=c("#82B0D2", "#FFBE7A", "#FA7F6F"),limits=c("ASD", "Cancer", 'ASD_Cancer')) +
  labs(x="Disease", y="Stiffness", fill="Disease") +
  theme_minimal()

#pv5 <- pv5 + scale_y_continuous(limits = c(9,25.5))
pv5 <- pv5 + theme(legend.position = "none",panel.grid = element_blank())
pv5 <- pv5 + stat_compare_means(comparisons = my_comparisons,
                      label.y = c(20,21.5,20),
                       method = "wilcox.test")
pv5 <- pv5 + theme(axis.line = element_blank(),
                  panel.border = element_rect(linetype = 'solid', colour = 'black',fill = NA,size = 0.7),
                  panel.grid.major = element_blank(),
                  panel.grid.minor = element_blank())

ggsave(pv1, file="figure/EffectivenessV.pdf", 
       width = 4, height = 4)
ggsave(pv2, file="figure/SensitivityV.pdf", 
       width = 4, height = 4)
ggsave(pv3, file="figure/MSFV.pdf", 
       width = 4, height = 4)
ggsave(pv4, file="figure/DFIV.pdf", 
       width = 4, height = 4)
ggsave(pv5, file="figure/StiffnessV.pdf", 
       width = 4, height = 4)
