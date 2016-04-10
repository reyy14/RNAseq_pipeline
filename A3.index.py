#!/usr/bin/python
import sys
import os
import os.path
sys.path.append("/home/won/WON")
import Util
from multiprocessing import Pool

"""
	This is after running 
		gtf2bed.pl merged.gtf > merged.bed
"""


mRNA=Util.GetDirList("Tophat/*/accepted_hits.bam",DIR=1)

L = mRNA
def Job(dat):
	cmd = "samtools index %s"%dat
	print cmd
	os.system(cmd)
	return

if __name__=='__main__':
	pool = Pool(processes =4)
	pool.map(Job,L)

