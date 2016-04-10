library(gplots)
#library(ggplot2)
library(reshape2)
library(pvclust)
library(RColorBrewer);

flagArrangeColumn = 0
Files = c("SelectGene.txt")
colorL=c("red","purple","blue","yellow","green","orange","brown","gray","black","coral","beige","cyan","pink","khaki","magenta")
for (ff in 1:length(Files)){
	fname = Files[ff]
	E = read.delim(fname,row.names=1,header=T)

	mExp = E[,c("WT_1","WT_2","WT.GS_1","WT.GS_2","KO_1","KO_2","KO.GS_1","KO.GS_2")]
	mlabel = E[,c("FC","FC")]#mExp = E[,]
	mlabel[mlabel[,1]<0,1] <-  0
	mlabel[mlabel[,2]>0,2] <-  0
	maxval = 2
	minval = -2
	my = mExp
	my = my[apply(my,1,function(x) sd(x)!=0),]
	my <- t(scale(t(my)))

	cluster=vector(mode="character",length=nrow(mExp))

	d=as.dist(1-cor(t(my)))
	h=hclust(d, method="ward")
	dend = as.dendrogram(h)
	lownum = 1126+1144+176 #(orange, purple, red)
	wGreen = lownum+1097
	myorder = c((wGreen+1):4998, (lownum+1):wGreen,1:lownum)
	myorder = c((wGreen+1):4998, 1:lownum,  (lownum+1):wGreen)
	dend <- reorder(dend,myorder,agglo.FUN=mean)
	#dend <- reorder(dend,1:4998)

	d2 =as.dist(1-cor((my)))
	h2 = hclust(d2,method="ward")
	dend2 = as.dendrogram(h2)
	
	bk <- seq(-2, 2, by=0.1)
	data.mat=as.matrix(my)

	pngnamedist = paste("Results/",fname,".dist.png",sep="")
	png(pngnamedist,width=500,height=500)
	par(cex=1.2)
	plot(h2,main="transcripts",cex.main=1)
	dev.off()

	pngname=paste("Results/",fname,".Dendro.png",sep="") ; N.cluster=6; title="8"
	png(pngname,width=1000,height=800)
	#par(mfrow=c(1,3))
	par(mar=c(15,1,5,1))

	rowColor=vector(mode="character",length=nrow(my))
	cluster=vector(mode="character",length=nrow(my))
	unlink("Results/Cluster*.txt")
	for(j in 1:N.cluster){
		sub.tf=cutree(h,k=N.cluster)==j
		rowColor[sub.tf]=colorL[j]
		clustername = paste("Results/Cluster",fname,".",title,".",colorL[j],".",j,".txt",sep="")
		print(clustername)
		write.table(names(sub.tf[sub.tf==TRUE]),clustername,quote=F,col.names=F,row.names=F)
		#write.table(names(sub.tf[sub.tf==TRUE]),clustername,col.names=F,row.names=F)
		cluster[sub.tf]=j
	}
	cluster <- as.matrix(cluster)
	rownames(cluster)<-rownames(my)
	imgDat = t(my[h$labels[h$order],])
	P <- mlabel[h$labels[h$order],]
	#if (cl==2)	
	if (flagArrangeColumn ==1) imgDat = imgDat[h2$labels[h2$order],]	# cluster column as well
	#P =      mlabel[h$labels[h$order],]
	imgDat[imgDat>maxval]=maxval
	imgDat[imgDat<minval]=minval

	#color code
	#par(mar=c(10,33,5,0))
	mycol = colorL[1:N.cluster]
	cluster = cluster[h$labels[h$order],]
	#image(t(as.matrix(as.numeric(cluster))),col=mycol,  axes=FALSE)
	#box()
	#par(mar=c(10,1,5,1))
							    
	#image(imgDat, col=bluered(length(bk)-1),axes=FALSE )
	#axis(1, at=seq(0,1,1/(ncol(mExp)-1)), labels=colnames(mExp), las=2, tick=FALSE,cex.axis=2)
	#axis(1, at=seq(0,1,1/(ncol(mExp)-1)), labels=rownames(imgDat), las=2, tick=FALSE,cex.axis=2)
	#box()
	#par(mar=c(10,1,5,14))
	    heatmap.2(as.matrix(my), Rowv=dend, Colv=F, scale="row",trace="none",dendrogram="row",labRow=F,
		 col=colorpanel(length(bk)-1,"blue","white","red"), key=T,keysize=0.7, RowSideColors=rowColor,
		 cexCol=2,margins=c(12,12) )

	#P[ (P>-3)&(P< -1) ] = 0
	#P[ (P<3)&(P> 1) ] = 0
	P[P< -1]<- -1										    
	P[P> 1]<- 1										    
    #image(as.matrix(t(P)), col=colorRampPalette(c("blue","white","red"))(100), axes=FALSE )
    #axis(1, at=seq(0,1,1/(ncol(P)-1)), labels=colnames(P), las=2, tick=FALSE,cex.axis=2)
    #box()
	dev.off()

	png("Results/SelectGene.txt.Dendro2.png",width=1000,height=800)
	    heatmap.2(as.matrix(my), Rowv=dend, Colv=F, scale="row",trace="none",dendrogram="row",labRow=F,
		 col=colorpanel(length(bk)-1,"blue","white","red"), key=T,keysize=0.7, #RowSideColors=F,
		 cexCol=2,margins=c(12,12) )
	dev.off()

}
stop("ddd")

