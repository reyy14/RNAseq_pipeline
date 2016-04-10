#!/usr/bin/python
import sys
import os
import os.path
sys.path.append("/home/won/WON/")
import Util


BowtieIndex="/home/won/Local/mm9/Sequence/Bowtie2Index/genome"
GTFFile = "/home/won/Local/mm9/Annotation/Genes/genes.gtf"


Data = Util.GetDirList("data/*R1_001.fastq",DIR=1)
numproc = 20 
try:
	os.mkdir("Tophat")
except: pass

for dat in Data:
	fq1 = dat
	fq2 = dat.replace("R1_","R2_") 
	print fq1, fq2
	fname = dat.split("/")[-1].split("_")[0] 
	outfile = "Tophat/%s"%fname
	cmd = "tophat2 -G %s  --library-type fr-unstranded  -p %d -o %s %s %s %s\n"%(GTFFile,numproc,outfile,BowtieIndex,fq1,fq2)
	print cmd
	os.system(cmd)

