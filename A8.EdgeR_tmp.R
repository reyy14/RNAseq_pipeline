library("edgeR")
#tbl = read.table("gene.count",sep="\t",row.names=1,header=T)
counts = read.table("gene.count",sep="\t",row.names=1,header=T)

#group<-factor( c(rep("Liver",5), rep("eWAT",5), rep("iWAT",4), rep("BAT",5) ) ) 
configure = read.table("Tophat/configure.list",sep="\t",header=F)
group <- configure[,2]
#select = c(3,4,5,6,7,8,9,10,11)	#gene,H1,H2,H3, H4,H5,   H7,H8,H9, H10
#countS = counts[,2:dim(counts)[2]]
countS = counts[,2:dim(counts)[2]]

y = DGEList(counts=counts[,2:dim(counts)[2]] ,gene=counts[,1])
#y = DGEList(counts=countS,gene=rownames(countS))
o<-order(rowSums(y$counts),decreasing=TRUE)  # remove duplicates
y<-y[o,]
d<-duplicated(y$genes)
y<-y[!d,]
y$samples$lib.size <- colSums(y$counts)
rownames(y$counts) <- t(y$gene)				# exchange ID
y<-calcNormFactors(y)
data.frame(Sample=colnames(y),group)
design<- model.matrix(~0+group)
y<-estimateGLMCommonDisp(y,design)
y<-estimateGLMTrendedDisp(y,design)
y<-estimateGLMTagwiseDisp(y,design)

# save the whole table
keep<-rowSums(cpm(y)>0.0)>=1  # remove low val.. 
y_save<-y[keep,]
write.table(cpm(y_save),"Gene.norm.txt",sep="\t",quote=FALSE)

fit<-glmFit(y,design)
#lrt<-glmLRT(fit,coef=2:length(unique(group))); mymain="Anova" # removing S6 for this
#pdat<-topTags(lrt, n=dim(lrt$table)[1],sort.by=NULL)
#degene<-y[rownames(y)[(pdat$table$FDR<1e-5)],]
#keep2 <- rowSums(cpm(degene)>1.0)>=1
#degene_save <- degene[keep2,]
#write.table(cpm(degene_save),"Results/Anova.txt",sep="\t",quote=FALSE,row.names=T,col.names=T)

png("Results/CPM.mRNA.png",width=1000,height=1000)
par(mfrow=c(2,2),oma=c(4,4,1,1),mar=c(5,5,2,2))
for (i in 1:4){
	print (i)
	#  rule: the first one shoule uddse coeff. 
	if (i==1) {lrt<-glmLRT(fit,contrast=c(-1,1,0,0)); mymain="KO vs KO-GS" }
	if (i==2) {lrt<-glmLRT(fit,contrast=c(0,0,-1,1)); mymain="WT vs WT-GS" }
	if (i==3) {lrt<-glmLRT(fit,contrast=c(1,0,-1,0)); mymain="WT vs KO" }
	if (i==4) {lrt<-glmLRT(fit,contrast=c(0,1,0,-1)); mymain="WT-GS vs KO-GS" }


	cut = 1
	summary(de<-decideTestsDGE(lrt),)
	de<-decideTestsDGE(lrt,adjust.method="BH",p.value=1.e-5)
	detags<-rownames(y)[as.logical(de)]
	plotSmear(lrt,de.tags=detags,main=mymain,cex.main=2,cex.lab=2,cex.axis=1.5)
	abline(h=c(-cut,cut),col="blue")
	num_upgene = sum(as.logical(de)&(lrt$table$logFC>cut))
	num_dngene = sum(as.logical(de)&(lrt$table$logFC< -cut))
	upgenes = rownames(y)[as.logical(de)&(lrt$table$logFC>cut) ]
	dngenes = rownames(y)[as.logical(de)&(lrt$table$logFC< -cut) ]
	fupgene = gsub(" ","_",paste("Results/",mymain,".up.tmp.txt",sep=""))
	fdngene = gsub(" ","_",paste("Results/",mymain,".dn.tmp.txt",sep=""))
	write.table(upgenes,fupgene,sep="\t",quote=FALSE,row.names=F,col.names=F)
	write.table(dngenes,fdngene,sep="\t",quote=FALSE,row.names=F,col.names=F)
	
	mtext(paste("Up:",num_upgene,sep=""), line=-2)
	mtext(paste("Down:",num_dngene,sep=""), line=-4)
}

dev.off()



#lrt_total<-glmLRT(fit,coef=2:10)  #ANOVA Test
#FDR <- p.adjust(lrt_total$table$PValue, method="BH")

stop("11")




