#!/usr/bin/python
import sys
import os
sys.path.append("/home/won/WON/")
import Util
from multiprocessing import Pool
import math

All = Util.ReadList("Gene.norm.txt")
Uplist = Util.GetDirList("Results/*.up.txt",DIR=1)
Dnlist = Util.GetDirList("Results/*.dn.txt",DIR=1)
mList = Uplist + Dnlist
mGene = []
for i in xrange(len(mList)):
	M = Util.ReadList(mList[i])
	M = [x[0] for x in M]
	mGene = mGene + M
mList = list(set(mGene))

dAll = Util.List2Dict(All[1:],[0],range(1,len(All[1])))
array = Util.ReadDict("../micro.txt",[0],[2,3])

Select = []
fout = open("SelectGene.txt","w")
fout.write("\t".join(All[0])+"\tFC\n")

for i in xrange(len(mList)):
	gene = mList[i]
	try:
		O = dAll[gene]
	except:   continue
	try:
		pval,A = array[gene]
		if float(pval)>0.05: A=0
		print math.fabs(float(A))
		if math.fabs(float(A))<1.5: A=0
	except: A=0	
	mO = [gene]+list(O)+[A]
	mO = map(str,mO)
	fout.write("\t".join(mO)+"\n")
fout.close()
#print array

sys.exit(1)



