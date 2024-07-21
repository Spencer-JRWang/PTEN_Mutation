library(dplyr)
library(ggplot2)
library(cowplot)
library(ggpubr)

# read data
setwd("/Users/wangjingran/Desktop/PTEN_Mutation")
paras <- read.table("data/paras.txt", header = TRUE)
data <- paras[,c(1,2)]
asd <- data[data$Disease == "ASD",2]
cancer <- data[data$Disease == "Cancer",2]
ac <- data[data$Disease == "ASD_Cancer",2]

# Cancer
breaks <- c(0, 10, 20, 30, 40, 403)
Region <- cut(cancer, breaks, 
                   labels = c("PBD", "PD", " ", "C2D", "CTT"), 
                   include.lowest = TRUE)

Cancer <- data.frame(cancer,Region)
Cancer <- Cancer %>% 
  group_by(cancer) %>% 
  summarise(count = n(), Region = first(Region))
Cancer <- na.omit(Cancer)
start <- c(0, 16, 185, 190, 351)
end <- c(16, 185, 190, 351, 403)
for (i in 1:nrow(Cancer)) {
  if (Cancer$Region[i] == "PBD") {
    Cancer$start[i] <- start[1]
    Cancer$end[i] <- end[1]
  } else if (Cancer$Region[i] == "PD") {
    Cancer$start[i] <- start[2]
    Cancer$end[i] <- end[2]
  } else if (Cancer$Region[i] == " ") {
    Cancer$start[i] <- start[3]
    Cancer$end[i] <- end[3]
  } else if (Cancer$Region[i] == "C2D") {
    Cancer$start[i] <- start[4]
    Cancer$end[i] <- end[4]
  } else if (Cancer$Region[i] == "CTT") {
    Cancer$start[i] <- start[5]
    Cancer$end[i] <- end[5]
  }
}

# ASD
Region <- cut(asd, breaks, 
                   labels = c("PBD", "PD", " ", "C2D", "CTT"), 
                   include.lowest = TRUE)

ASD <- data.frame(asd,Region)
ASD <- ASD %>% 
  group_by(asd) %>% 
  summarise(count = n(), Region = first(Region))
ASD <- na.omit(ASD)
start <- c(0, 16, 185, 190, 351)
end <- c(16, 185, 190, 351, 403)
for (i in 1:nrow(ASD)) {
  if (ASD$Region[i] == "PBD") {
    ASD$start[i] <- start[1]
    ASD$end[i] <- end[1]
  } else if (ASD$Region[i] == "PD") {
    ASD$start[i] <- start[2]
    ASD$end[i] <- end[2]
  } else if (ASD$Region[i] == " ") {
    ASD$start[i] <- start[3]
    ASD$end[i] <- end[3]
  } else if (ASD$Region[i] == "C2D") {
    ASD$start[i] <- start[4]
    ASD$end[i] <- end[4]
  } else if (ASD$Region[i] == "CTT") {
    ASD$start[i] <- start[5]
    ASD$end[i] <- end[5]
  }
}

# ASD_Cancer
breaks <- c(20,40, 76,90,180 ,403)
Region <- cut(ac, breaks, 
                   labels = c("PBD", "PD", " ", "C2D", "CTT"), 
                   include.lowest = TRUE)

AC <- data.frame(ac,Region)
AC <- AC %>% 
  group_by(ac) %>% 
  summarise(count = n(), Region = first(Region))
AC <- na.omit(AC)
start <- c(0, 16, 185, 190, 351)
end <- c(16, 185, 190, 351, 403)
for (i in 1:nrow(AC)) {
  if (AC$Region[i] == "PBD") {
    AC$start[i] <- start[1]
    AC$end[i] <- end[1]
  } else if (AC$Region[i] == "PD") {
    AC$start[i] <- start[2]
    AC$end[i] <- end[2]
  } else if (AC$Region[i] == " ") {
    AC$start[i] <- start[3]
    AC$end[i] <- end[3]
  } else if (AC$Region[i] == "C2D") {
    AC$start[i] <- start[4]
    AC$end[i] <- end[4]
  } else if (AC$Region[i] == "CTT") {
    AC$start[i] <- start[5]
    AC$end[i] <- end[5]
  }
}

# Cancer
p_1 <- ggplot(Cancer, aes(x=cancer, y=count, group=Region, color=Region)) + 
  geom_segment(aes(xend=cancer, yend=0), linewidth=0.6) +
  geom_segment(aes(xend=cancer, yend=count), linewidth=0.6) +
  geom_point(size=2) + 
  #scale_shape_manual(values=shape_palette, drop = FALSE) + 
  scale_color_manual(values=c(rep("#FFBE7A",5)), drop = FALSE) +
  labs(x = NULL, y="Cancer", color="Region", shape="Region") + 
  theme(plot.title = element_text(hjust = 0.5)) + 
  theme_bw()
p_1 <- p_1 + scale_x_continuous(limits = c(0,410)) + scale_y_continuous(limits = c(-1.5,5))
# df_filter <- filter(Cancer, !is.na(cancer_region) & !is.na(start) & !is.na(end))
p_1 <- p_1 + geom_rect(data = Cancer, aes(xmin = start, xmax = end, ymin = -1.5, ymax = 0, fill = Region),color = 'transparent') +
  scale_fill_manual(values = c("PBD" = '#A1A9D0', "PD" ='#F0988C'," " = "transparent" ,"C2D" = '#B883D4', "CTT" = "#8ECFC9")) +
  #geom_text(aes(x = start + (end - start)/2, y = -1.5, label = Region), vjust = 0, color = 'black',size = 5) +
  theme_minimal() +
  geom_segment(aes(x = 185, y = -0.75, xend = 190, yend = -0.75), color = "grey", linetype = "solid", size = 1)
p_1 <- p_1 + theme(panel.border = element_rect(linetype = 'solid', colour = 'black',fill = NA,size = 0.7),
                 panel.grid.major = element_blank(),
                 panel.grid.minor = element_blank())
p_1 <- p_1 + theme(legend.position = "none",panel.grid = element_blank())
p_1 <- p_1 + theme(axis.text.x = element_blank())

# ASD
p_2 <- ggplot(ASD, aes(x=asd, y=count, group=Region, color=Region)) + 
  geom_segment(aes(xend=asd, yend=0), linewidth=0.6) +
  geom_segment(aes(xend=asd, yend=count), linewidth=0.6) +
  geom_point(size=2) + 
  #scale_shape_manual(values=shape_palette, drop = FALSE) + 
  scale_color_manual(values=c(rep("#82B0D2",5)), drop = FALSE) +
  labs(x = NULL,y="ASD", color="Region", shape="Region") + 
  theme(plot.title = element_text(hjust = 0.5)) + 
  theme_bw()
p_2 <- p_2 + scale_x_continuous(limits = c(0,410))+ scale_y_continuous(limits = c(-1.5,5))
# df_filter <- filter(Cancer, !is.na(cancer_region) & !is.na(start) & !is.na(end))
p_2 <- p_2 + geom_rect(data = ASD, aes(xmin = start, xmax = end, ymin = -1.5, ymax = 0, fill = Region),color = 'transparent') +
  scale_fill_manual(values = c("PBD" = '#A1A9D0', "PD" ='#F0988C'," " = "transparent" ,"C2D" = '#B883D4', "CTT" = "#8ECFC9")) +
 #geom_text(aes(x = start + (end - start)/2, y = -1.5, label = Region), vjust = 0, color = 'black',size = 5) +
  theme_minimal()+
  geom_segment(aes(x = 185, y = -0.75, xend = 190, yend = -0.75), color = "grey", linetype = "solid", size = 1)
p_2 <- p_2 + theme(panel.border = element_rect(linetype = 'solid', colour = 'black',fill = NA,size = 0.7),
                 panel.grid.major = element_blank(),
                 panel.grid.minor = element_blank())
p_2 <- p_2 + theme(legend.position = "none",panel.grid = element_blank())
p_2 <- p_2 + theme(axis.text.x = element_blank())

# ASD_Cancer
p_3 <- ggplot(AC, aes(x=ac, y=count, group=Region, color=Region)) + 
  geom_segment(aes(xend=ac, yend=0), linewidth=0.6) +
  geom_segment(aes(xend=ac, yend=count), linewidth=0.6) +
  geom_point(size=2) + 
  #scale_shape_manual(values=shape_palette, drop = FALSE) + 
  scale_color_manual(values=c(rep("#FA7F6F",5)), drop = FALSE) +
  labs(x = NULL,y="ASD_Cancer", color="Region", shape="Region") + 
  theme(plot.title = element_text(hjust = 0.5)) + 
  theme_bw()
p_3 <- p_3 + scale_x_continuous(limits = c(0,410)) + scale_y_continuous(limits = c(-1.5,5))
# df_filter <- filter(Cancer, !is.na(cancer_region) & !is.na(start) & !is.na(end))
p_3 <- p_3 + geom_rect(data = AC, aes(xmin = start, xmax = end, ymin = -1.5, ymax = 0, fill = Region),color = 'transparent') +
  scale_fill_manual(values = c("PBD" = '#A1A9D0', "PD" ='#F0988C'," " = "transparent" ,"C2D" = '#B883D4', "CTT" = "#8ECFC9")) +
  #geom_text(aes(x = start + (end - start)/2, y = -1.5, label = Region), vjust = 0, color = 'black',size = 5) +
  theme_minimal()+
  geom_segment(aes(x = 185, y = -0.75, xend = 190, yend = -0.75), color = "grey", linetype = "solid", size = 1)
p_3 <- p_3 + theme(panel.border = element_rect(linetype = 'solid', colour = 'black',fill = NA,size = 0.7),
                 panel.grid.major = element_blank(),
                 panel.grid.minor = element_blank())
p_3 <- p_3 + theme(legend.position = "none",panel.grid = element_blank())
p_3 <- p_3 + theme(axis.text.x = element_blank())

# combine the plots
library(patchwork)
p <-  p_1/ p_2/ p_3
ggsave(p, file="figure/mutation_distribution.pdf", width = 9, height=4)