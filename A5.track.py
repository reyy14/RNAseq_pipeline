#!/usr/bin/python

import sys 
from string import *
import os
import os.path
sys.path.append("/home/won/WON/")
import Util
import math
from multiprocessing import Pool

DATA = Util.GetDirList("Tophat/*/accepted_hits.bam",DIR=1)
#DATA = [x+"/accepted_hits.bam" for x in DATA]
print DATA
#for infile in DATA:
def Job(infile):
	cmdindex = "samtools index %s"%(infile)
	#os.system(cmdindex)
	
	direc = infile.replace("/accepted_hits.bam","")
	#forfile = direc+"/forward.bam"
	#backfile = direc+"/backward.bam"
	#cmdbackward = "samtools view -h %s | awk '{if (NF<7) print $0}; {if ($2==99|| $2==147) print $0}' | samtools view -bS -> %s"%(infile,backfile)
	#os.system(cmdbackward)
	#cmdforward = "samtools view -h %s  | awk '{if (NF<7) print $0}; {if ($2==83|| $2==163) print $0}' | samtools view -bS -> %s"%(infile,forfile)
	#os.system(cmdforward)


	scale = 1
	fname = infile.split("/")[-2]
	track="%s"%(fname); 
	outfile = direc+".bedGraph"
	#cmdf = "genomeCoverageBed -bg -split -trackline -trackopts 'name=\"%s\" ' -scale %d -ibam %s  > %s"%(track,scale, infile,outfile)
	cmdf = "genomeCoverageBed -bg -split  -scale %d -ibam %s  > %s"%(scale, infile,outfile)
	print cmdf
	os.system(cmdf)

	#scale = -1
	#track="%s.b"%(fname) 
	#outfile = direc+"/backward.bedgraph.gz"
	#cmdb = "genomeCoverageBed -bg -split -trackline -trackopts 'name=\"%s\" ' -scale %d -ibam %s | gawk '{if ($1==\"track\") print $0;  else if ($1==\"MT\") print \"chrM\\t\"$2\"\\t\"$3\"\\t\"$4;  else print \"chr\"$0}'| gzip > %s"%(track,scale, backfile,outfile)
	#os.system(cmdb)
	return

if __name__=='__main__':
	pool = Pool(processes =8)
	pool.map(Job,DATA)
	

