#!/usr/bin/python
import sys
from string import *
import os
import os.path
sys.path.append("/home/won/WON/")
import Util
import math
#import Sequtil

config = Util.ReadColumn("/home/skw/Desktop/REy/KKJW-SingleCellT2D/AAA-StudyInfo.txt",[6,12,13,14],delim="\t")
Cell = []
direc = "/home/skw/Desktop/REy/KKJW-SingleCellT2D/basic/Fastq/"


for i in xrange(len(config)):
	if config[i][1]!="FGC1246": continue
	name = config[i][1]+"_s_"+config[i][2]+"_"+config[i][3]+".fastq"
	label = direc+config[i][1]+"_s_"+config[i][2]+"_"+config[i][3]+".fastq"
	cmd = "ln -s "+label+" "+"fastq/"+name
	print cmd
	os.system(cmd)

