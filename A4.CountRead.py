#!/usr/bin/python
import sys
import os
import os.path
sys.path.append("/home/won/WON")
import Util
from multiprocessing import Pool

mRNA=Util.GetDirList("Tophat/*/accepted_hits.bam",DIR=1)

L = mRNA
def Job(dat):
	out = dat+".count"
	option=""
	if dat.find("total")>0: option = "-s"  # strand
	cmd = "bedtools multicov -split -D %s  -bams "%option
	cmd += " %s -bed  /home/won/Local/mm9/Annotation/Genes/genes.bed | cut -f 4,13 > %s"%(dat,out)
	print cmd
	os.system(cmd)
	return

if __name__=='__main__':
	pool = Pool(processes =23)
	pool.map(Job,L)

