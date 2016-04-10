#!/usr/bin/python
import sys
import os
sys.path.append("/home/won/WON/")
import Util
from multiprocessing import Pool
import numpy as np
import scipy
import scipy.stats


L = Util.ReadList("/home/won/Local/mm9/Annotation/Genes/genes.gtf",delim="\t")
AnnD = {}
for i in xrange(len(L)): #ml in L:
	Ann = L[i][1]
	ltype = L[i][2]
	expr = L[i][8]
	category = expr.split(";")

	ens = [x.split()[1] for x in category if x.find("transcript_id")>=0][0].replace('"','')
	try:	
		gene = [x.split()[1] for x in category if x.find("gene_name")>=0][0].replace('"','')
	except:
		gene = ens 

	#print Ann, ltype,ens, gene, biotype
	AnnD[(ens)]=gene

fout = open("mm9.Trans2Gene.dat","w")
for ky, itm in AnnD.items():
	fout.write("%s\t%s\n"%(ky,itm))
	#fout.write("\t".join( list(ky))+"\n")
fout.close()



