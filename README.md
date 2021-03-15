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
* [SQANTI3](https://github.com/ConesaLab/SQANTI3)
* [cDNA_cupcake](https://github.com/Magdoll/cDNA_Cupcake)
* [Samtools](http://www.htslib.org/)

## User's guide
### I. Input requirements
* Edited config/config.yaml
* Indexed bam files of demultiplexed subreads data
* Reference genome file and annotation files

### II. Editing the config.yaml
Basic parameters:
* subread: Path to subread data stored directory
* targeted: Genomic coordinates of the targed region; chromosome:start_position-end_position
* ref: hg38, hg19, mm10, etc
* genome: Path to referece genome fasta file
* gtf: Path to reference annotation gtf file
* gff3: Path to reference annotation gff3 file
* tappas_gff3: Path to standard tappAS reference annotation gff3 file
* tofu: Path to the directory where the tool tofu in cDNA_cupcake package is located
* sqanti3: Path to the directory where the SQANTI3 package is located

Optional parameters:
* out: Path to desired directory to store output files, defalut: working directory
* gmap_ref: Path to GMAP index directory if available

### III. To run
* Clone the repository to your working directory
```bash
git clone https://github.com/NCI-CGR/Pacbio-Alternative-Splicing.git
```
* Install required software
* Create conda environment using the provide yaml file and activate it after installation:
```bash
conda env create -f pacbioAS_env.yaml
conda activate pacbioAS
```
* Edit and save config/config.yaml 
* To run on an HPC using slurm job scheduler: 
  Edit config/cluster_config.yaml according to your HPC information
  Run run.sh to initiate running of the pipeline 
* To run in a local environment:
  ```bash
  export PYTHONPATH=$PYTHONPATH:{PATH}/cDNA_Cupcake/sequence/:{PATH}/conda/envs/sqanti3/lib/python3.7/site-packages/
  snakemake -p --cores 16 --keep-going --rerun-incomplete --jobs 300 --latency-wait 120 all
  ```
* Look in log directory for logs for each rule
* To view the snakemkae rule graph:
```bash
snakemake --rulegraph | dot -T png > pacbioAS.png
```
![dag]()


### IV. Example output
```bash

```
