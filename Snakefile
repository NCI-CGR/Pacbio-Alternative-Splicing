### This pipeline is using Pacbio long reads sequencing data for:
#1) Detection and quantification of splicing junctions
#2) Generation of universal transcript annotation file for tappAS
 
## start with lima demulplexed subreads data

#vim:ft=python
import sys
import os
import glob
import itertools
import pysam

shell.prefix("set -eo pipefail; ")
configfile:"config/config.yaml"
localrules: all

# path to subread
subread = config["subread"] 
# output directory
out = config.get("out","")

# define wildcards
def parse_sampleID(fname):
    return fname.split('/')[-1].split('.bam')[0]

file = sorted(glob.glob(subread + '*.bam'), key=parse_sampleID)
m = subread + 'merged.bam'
while m in file:file.remove(m)

d = {}
for key, value in itertools.groupby(file, parse_sampleID):
    d[key] = list(value)
samples = d.keys()

# path to apps
tofu = config["tofu"]
sqanti3 = config["sqanti3"]

#pythonimport = config["pythonimport"]

# reference
ref = config["ref"]
genome = config["genome"]
gtf = config["gtf"]
gref = config["gmap_ref"]
gff3 = config["gff3"]
tappas_gff3 = config["tappas_gff3"]

cn = ""
st = 0
targeted = config["targeted"]
if targeted != "":
   cn = targeted.split(":")[0]
   st = int(targeted.split(":")[1].split("-")[0])
   ed = int(targeted.split(":")[1].split("-")[1])

include: "modules/Snakefile_gen"
include: "modules/Snakefile_annot"

rule all:
    input:
          expand(out + "sqanti_r2/{sample}_sqanti_r2_filter_complete.txt",sample=samples),
          out + "kallisto_index/complete.txt"          
