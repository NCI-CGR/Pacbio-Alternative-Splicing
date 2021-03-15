# Alternative Splicing Analysis Using PACBIO Targed Long-Reads Sequencing Data
## Description
This snakemake pipeline is for alternative splicing analysis using PACBIO targed long-reads sequencing data. The pipeline may be run on an HPC or in a local environment.

Major steps in the workflow include:
1) General data processing using [ISOSEQ3](https://github.com/PacificBiosciences/IsoSeq)
2) Alignment and splicing analysis of non-collaplsed reads using [GMAP](http://research-pub.gene.com/gmap/) and [SQANTI3](https://github.com/ConesaLab/SQANTI3)
3) Further QC filtering and splicing analysis of collapsed reads using [cDNA_cupcake](https://github.com/Magdoll/cDNA_Cupcake) and SQANTI3
4) Generateing customozied [tappAS](https://tappas.org/) annotation file with sample merged data using SQANTI3

Expected results include:
* Detection and quantification of transcripts in targed regions with non-collapsed reads
* The concise version of detection of transcripts in targed regions with collapsed reads
* Customozied tappAS annotation file

## Software Requirements
* [Conda](https://conda.io/projects/conda/en/latest/user-guide/install/index.html)
* [Snakemake](https://snakemake.readthedocs.io/en/stable/)
* [samtools](http://www.htslib.org/)
