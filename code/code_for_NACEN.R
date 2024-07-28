#!/usr/bin/Rscript
############################
library('bio3d')
library('NACEN')
library('igraph')
############################

############################
# route to dssp
dsspfile <- "/usr/bin/mkdssp"
data <- "/home/wangjingran/APMA/data/pten.pdb"
MT_betweeness <- c()
MT_closeness <- c()
MT_eigenvector <- c()
MT_degree <- c()
MT_clustering <- c()
############################

# Cancer
############################
# Wild Type
Net <- suppressMessages(NACENConstructor(PDBFile=data,WeightType = "Polarity",exefile = dsspfile,plotflag=F))
NetP <- suppressMessages(NACENAnalyzer(Net$AM,Net$NodeWeights))
net <- NetP$Edgelist
network <- c(net[,1],net[,2])
network <- graph(network)
result <- NetP$NetP
WT_betweeness <- result$B
WT_closeness <- result$C
WT_eigenvector <- suppressWarnings(evcent(network,scale=F)$vector)
WT_degree <- result$K
WT_clustering <- suppressWarnings(transitivity(network,type="localundirected"))
WT_clustering[is.na(clustering)] <- 0
############################

############################
for(i in 1:409){
	data <- paste(c("/home/wangjingran/APMA/FoldX/Cancer_",i,".pdb"),collapse="")

    # Use NACEN to calculate nodewights based on Polarity and Hydrophobicity
	Net <- suppressMessages(NACENConstructor(PDBFile=data,WeightType = "Polarity",exefile = dsspfile,plotflag=F))

    # Calculate graph centrality
	NetP <- suppressMessages(NACENAnalyzer(Net$AM,Net$NodeWeights))
	net <- NetP$Edgelist
	result <- NetP$NetP
    
    # Degree
	degree <- result$K
    MT_degree <- cbind(MT_degree,degree)

    # Calculate betweenness
	betweeness <- result$B
    MT_betweeness <- cbind(MT_betweeness,betweeness)

    # Calculate closeness
	closeness <- result$C
	MT_closeness <- cbind(MT_closeness,closeness)
	
    # Calculate eigenvetor
	network <- c(net[,1],net[,2])
    network <- graph(network)
    ev <- suppressWarnings(evcent(network,scale=F)$vector)
    MT_eigenvector <- cbind(MT_eigenvector,ev)

    tr <- suppressWarnings(transitivity(network,type="localundirected"))
    tr[is.nan(tr)] <- 0
    pg <- suppressWarnings(page_rank(g, damping = 0.999)$vector)
    MT_clustering <- cbind(MT_clustering,tr)
    MT_pagerank <- cbind(MT_pagerank, pg)
}
############################

############################
# Mean graph centrality
MT_betweeness <- rowMeans(MT_betweeness)
MT_closeness <- rowMeans(MT_closeness)
MT_eigenvector <- rowMeans(MT_eigenvector)
MT_degree <- rowMeans(MT_degree)
MT_clustering <- rowMeans(MT_clustering)

Betweeness <- MT_betweeness - WT_betweeness
Closeness <- MT_closeness - WT_closeness
Eigenvector <- MT_eigenvector - WT_eigenvector
Degree <- MT_degree - WT_degree
Clustering_coefficient <- MT_clustering - WT_clustering

AA_web <- cbind(Betweeness, Closeness)
AA_web <- cbind(AA_web, Eigenvector)
AA_web <- cbind(AA_web, Degree)
AA_web <- cbind(AA_web, Clustering_coefficient)

write.table(AA_web,"../data/Cancer_NACEN.txt",sep="\t",row.names = FALSE)
############################

# ASD
############################
for(i in 1:79){
	data <- paste(c("/home/wangjingran/APMA/FoldX/Cancer_",i,".pdb"),collapse="")

    # Use NACEN to calculate nodewights based on Polarity and Hydrophobicity
	Net <- suppressMessages(NACENConstructor(PDBFile=data,WeightType = "Polarity",exefile = dsspfile,plotflag=F))

    # Calculate graph centrality
	NetP <- suppressMessages(NACENAnalyzer(Net$AM,Net$NodeWeights))
	net <- NetP$Edgelist
	result <- NetP$NetP
    
    # Degree
	degree <- result$K
    MT_degree <- cbind(MT_degree,degree)

    # Calculate betweenness
	betweeness <- result$B
    MT_betweeness <- cbind(MT_betweeness,betweeness)

    # Calculate closeness
	closeness <- result$C
	MT_closeness <- cbind(MT_closeness,closeness)
	
    # Calculate eigenvetor
	network <- c(net[,1],net[,2])
    network <- graph(network)
    ev <- suppressWarnings(evcent(network,scale=F)$vector)
    MT_eigenvector <- cbind(MT_eigenvector,ev)

    tr <- suppressWarnings(transitivity(network,type="localundirected"))
    tr[is.nan(tr)] <- 0
    pg <- suppressWarnings(page_rank(g, damping = 0.999)$vector)
    MT_clustering <- cbind(MT_clustering,tr)
    MT_pagerank <- cbind(MT_pagerank, pg)
}
############################

############################
# Mean graph centrality
MT_betweeness <- rowMeans(MT_betweeness)
MT_closeness <- rowMeans(MT_closeness)
MT_eigenvector <- rowMeans(MT_eigenvector)
MT_degree <- rowMeans(MT_degree)
MT_clustering <- rowMeans(MT_clustering)

Betweeness <- MT_betweeness - WT_betweeness
Closeness <- MT_closeness - WT_closeness
Eigenvector <- MT_eigenvector - WT_eigenvector
Degree <- MT_degree - WT_degree
Clustering_coefficient <- MT_clustering - WT_clustering

AA_web <- cbind(Betweeness, Closeness)
AA_web <- cbind(AA_web, Eigenvector)
AA_web <- cbind(AA_web, Degree)
AA_web <- cbind(AA_web, Clustering_coefficient)

write.table(AA_web,"../data/ASD_NACEN.txt",sep="\t",row.names = FALSE)
############################

# ASD_Cancer
############################
for(i in 1:53){
	data <- paste(c("/home/wangjingran/APMA/FoldX/ASD_Cancer_",i,".pdb"),collapse="")

    # Use NACEN to calculate nodewights based on Polarity and Hydrophobicity
	Net <- suppressMessages(NACENConstructor(PDBFile=data,WeightType = "Polarity",exefile = dsspfile,plotflag=F))

    # Calculate graph centrality
	NetP <- suppressMessages(NACENAnalyzer(Net$AM,Net$NodeWeights))
	net <- NetP$Edgelist
	result <- NetP$NetP
    
    # Degree
	degree <- result$K
    MT_degree <- cbind(MT_degree,degree)

    # Calculate betweenness
	betweeness <- result$B
    MT_betweeness <- cbind(MT_betweeness,betweeness)

    # Calculate closeness
	closeness <- result$C
	MT_closeness <- cbind(MT_closeness,closeness)
	
    # Calculate eigenvetor
	network <- c(net[,1],net[,2])
    network <- graph(network)
    ev <- suppressWarnings(evcent(network,scale=F)$vector)
    MT_eigenvector <- cbind(MT_eigenvector,ev)

    tr <- suppressWarnings(transitivity(network,type="localundirected"))
    tr[is.nan(tr)] <- 0
    pg <- suppressWarnings(page_rank(g, damping = 0.999)$vector)
    MT_clustering <- cbind(MT_clustering,tr)
    MT_pagerank <- cbind(MT_pagerank, pg)
}
############################

############################
# Mean graph centrality
MT_betweeness <- rowMeans(MT_betweeness)
MT_closeness <- rowMeans(MT_closeness)
MT_eigenvector <- rowMeans(MT_eigenvector)
MT_degree <- rowMeans(MT_degree)
MT_clustering <- rowMeans(MT_clustering)

Betweeness <- MT_betweeness - WT_betweeness
Closeness <- MT_closeness - WT_closeness
Eigenvector <- MT_eigenvector - WT_eigenvector
Degree <- MT_degree - WT_degree
Clustering_coefficient <- MT_clustering - WT_clustering

AA_web <- cbind(Betweeness, Closeness)
AA_web <- cbind(AA_web, Eigenvector)
AA_web <- cbind(AA_web, Degree)
AA_web <- cbind(AA_web, Clustering_coefficient)

write.table(AA_web,"../ASD_Cancer_NACEN.txt",sep="\t",row.names = FALSE)
############################
