#!/usr/bin/python
import sys
import os
sys.path.append("/home/won/WON/")
import Util
from multiprocessing import Pool

F = Util.ReadColumn("Tophat/configure.list",[0,1])
Title= ["Tophat/%s/accepted_hits.bam.count"%x[0] for x in F]
Column = [x[1] for x in F]
note = 0
pre = ""
for i in xrange(len(Column)):
	if Column[i]!=pre: 
		note = 1
	pre = Column[i]
	Column[i] = Column[i]+"_%d"%note; note+=1
	
cmd = "paste "
for mlist in Title:
	cmd+="%s "%mlist

cmd += "| cut -f 1"
for i in xrange(1,100):
	cmd += ",%d"%(2*i)
cmd += " > gene.tmp"
os.system(cmd)

L = Util.ReadList("gene.tmp")
Ens2Gene = Util.ReadDict("mm9.Trans2Gene.dat",[0],[1])
fout = open("gene.count","w")
fout.write("transcript\tgene\t")
fout.write("\t".join(Column)+"\n")
for i in xrange(len(L)):
	try:
		symbol = Ens2Gene[L[i][0]]
	except: symbol="__"#continue
	O = [L[i][0],symbol]+L[i][1:]
	fout.write("\t".join(O)+"\n")
fout.close()



