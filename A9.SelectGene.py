#!/usr/bin/python
import sys
import os
sys.path.append("/home/won/WON/")
import Util
from multiprocessing import Pool

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

Select = []
fout = open("SelectGene.txt","w")
fout.write("\t".join(All[0])+"\n")

for i in xrange(len(mList)):
	gene = mList[i]
	try:
		O = dAll[gene]
	except: print gene; continue
	mO = [gene]+list(O)
	fout.write("\t".join(mO)+"\n")
fout.close()


sys.exit(1)



