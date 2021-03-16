# Alternative Splicing Analysis Using PACBIO Targeted Long-Reads Sequencing Data
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
* Customized tappAS annotation file

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
* Create conda environment using the provided yaml file and activate it after installation:
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
![dag](https://github.com/NCI-CGR/Pacbio-Alternative-Splicing/blob/master/pacbioAS.png)


### IV. Example output
```bash
.  user/defined/output_dir
├── ccs_bam # ccs reads
│   ├── {sample_A}_ccs.bam
│   ├── {sample_A}_ccs.bam.pbi
│   ├── {sample_A}_ccs.other_files
│   ├── {sample_B}_ccs.bam
│   ├── {sample_B}_ccs.bam.pbi
│   ├── {sample_B}_ccs.other_files
│   └── merged_ccs.bam
├── cluster # clusted unpolished reads
│   ├── {sample_A}.unpolished.bam
│   ├── {sample_A}.unpolished.bam.pbi
│   ├── {sample_A}.unpolished.cluster_report.csv
│   ├── {sample_A}.unpolished.fasta.gz
│   ├── {sample_A}.unpolished.other_files
│   ├── {sample_B}.unpolished.bam
│   ├── {sample_B}.unpolished.bam.pbi
│   ├── {sample_B}.unpolished.cluster_report.csv
│   ├── {sample_B}.unpolished.fasta.gz
│   ├── {sample_B}.unpolished.other_files
│   ├── merged.unpolished.bam
│   ├── merged.unpolished.bam.pbi
│   ├── merged.unpolished.cluster_report.csv
│   ├── merged.unpolished.fasta.gz
│   └── merged.unpolished.other_files
├── collapsed # collapsed reads
│   ├── {sample_A}.collapsed.abundance.txt
│   ├── {sample_A}.collapsed.fasta
│   ├── {sample_A}.collapsed.filtered.abundance.txt
│   ├── {sample_A}.collapsed.filtered.rep.fasta
│   ├── {sample_A}.collapsed.filtered.rep.fq
│   ├── {sample_A}.collapsed.filtered.other_files
│   ├── {sample_A}.collapsed.rep.fq
│   ├── {sample_A}.collapsed.other_files
│   ├── {sample_B}.collapsed.abundance.txt
│   ├── {sample_B}.collapsed.fasta
│   ├── {sample_B}.collapsed.filtered.abundance.txt
│   ├── {sample_B}.collapsed.filtered.rep.fasta
│   ├── {sample_B}.collapsed.filtered.rep.fq
│   ├── {sample_B}.collapsed.filtered.other_files
│   ├── {sample_B}.collapsed.rep.fq
│   ├── {sample_B}.collapsed.other_files
│   ├── merged.collapsed.abundance.txt
│   ├── merged.collapsed.fasta
│   ├── merged.collapsed.filtered.abundance.txt
│   ├── merged.collapsed.filtered.rep.fasta
│   ├── merged.collapsed.filtered.rep.fq
│   ├── merged.collapsed.filtered.other_files
│   ├── merged.collapsed.rep.fq
│   └── merged.collapsed.other_files
├── kallisto_index
│   ├── complete.txt
│   └── index
├── polished # clustered polished reads
│   ├── {sample_A}.polished.bam
│   ├── {sample_A}.polished.bam.pbi
│   ├── {sample_A}.polished.cluster_report.csv
│   ├── {sample_A}.polished.hq.fasta
│   ├── {sample_A}.polished.hq.fastq
│   ├── {sample_A}.polished.hq.fastq.gz
│   ├── {sample_A}.polished.other_files
│   ├── {sample_B}.polished.bam
│   ├── {sample_B}.polished.bam.pbi
│   ├── {sample_B}.polished.cluster_report.csv
│   ├── {sample_B}.polished.hq.fasta
│   ├── {sample_B}.polished.hq.fastq
│   ├── {sample_B}.polished.other_files
│   ├── merged.polished.bam
│   ├── merged.polished.bam.pbi
│   ├── merged.polished.cluster_report.csv
│   ├── merged.polished.hq.fasta
│   ├── merged.polished.hq.fastq
│   └── merged.polished.other_files
├── sqanti # splicing analysis with non-collpased reads
│   ├── GMST
│   ├── {sample_A}.polished.hq_classification.txt
│   ├── {sample_A}.polished.hq_corrected.fasta
│   ├── {sample_A}.polished.hq_corrected.gtf
│   ├── {sample_A}.polished.hq_corrected_sorted.sam
│   ├── {sample_A}.polished.hq_junctions.txt
│   ├── {sample_A}.polished.hq_sqanti_report.pdf
│   ├── {sample_A}.polished.hq_other_files
│   ├── {sample_B}.polished.hq_classification.txt
│   ├── {sample_B}.polished.hq_corrected.fasta
│   ├── {sample_B}.polished.hq_corrected.gtf
│   ├── {sample_B}.polished.hq_corrected_sorted.sam
│   ├── {sample_B}.polished.hq_junctions.txt
│   ├── {sample_B}.polished.hq_sqanti_report.pdf
│   ├── {sample_B}.polished.hq_other_files
│   ├── merged.polished.hq_classification.txt
│   ├── merged.polished.hq_corrected.fasta
│   ├── merged.polished.hq_corrected.gtf
│   ├── merged.polished.hq_corrected.sorted.sam
│   ├── merged.polished.hq_junctions.txt
│   ├── merged.polished.hq_sqanti_report.pdf
│   ├── merged.polished.hq_other_files
│   └── other_files
├── sqanti_r2 # splicing analysis with collapsed
│   ├── GMST
│   ├── {sample_A}.collapsed.filtered.rep_classification.filtered_lite_classification.txt
│   ├── {sample_A}.collapsed.filtered.rep_classification.filtered_lite.fasta
│   ├── {sample_A}.collapsed.filtered.rep_classification.filtered_lite.gtf
│   ├── {sample_A}.collapsed.filtered.rep_classification.filtered_lite_junctions.txt
│   ├── {sample_A}.collapsed.filtered.rep_classification.filtered_lite_reasons.txt
│   ├── {sample_A}.collapsed.filtered.rep_classification.filtered_lite_sqanti_report.pdf
│   ├── {sample_A}.collapsed.filtered.rep_classification.txt
│   ├── {sample_A}.collapsed.filtered.rep_corrected.fasta
│   ├── {sample_A}.collapsed.filtered.rep_corrected.gtf
│   ├── {sample_A}.collapsed.filtered.rep_corrected_sorted.sam
│   ├── {sample_A}.collapsed.filtered.rep_junctions.txt
│   ├── {sample_A}.collapsed.filtered.rep_sqanti_report.pdf
│   ├── {sample_A}.collapsed.filtered.rep_other_files
│   ├── {sample_B}.collapsed.filtered.rep_classification.filtered_lite_classification.txt
│   ├── {sample_B}.collapsed.filtered.rep_classification.filtered_lite.fasta
│   ├── {sample_B}.collapsed.filtered.rep_classification.filtered_lite.gtf
│   ├── {sample_B}.collapsed.filtered.rep_classification.filtered_lite_junctions.txt
│   ├── {sample_B}.collapsed.filtered.rep_classification.filtered_lite_reasons.txt
│   ├── {sample_B}.collapsed.filtered.rep_classification.filtered_lite_sqanti_report.pdf
│   ├── {sample_B}.collapsed.filtered.rep_classification.txt
│   ├── {sample_B}.collapsed.filtered.rep_corrected.fasta
│   ├── {sample_B}.collapsed.filtered.rep_corrected.gtf
│   ├── {sample_B}.collapsed.filtered.rep_corrected_sorted.sam
│   ├── {sample_B}.collapsed.filtered.rep_junctions.txt
│   ├── {sample_B}.collapsed.filtered.rep_sqanti_report.pdf
│   ├── {sample_B}.collapsed.filtered.rep_other_files
│   ├── merged.collapsed.filtered.rep_classification.txt
│   ├── merged.collapsed.filtered.rep_corrected.fasta
│   ├── merged.collapsed.filtered.rep_corrected.gtf
│   ├── merged.collapsed.filtered.rep_corrected.sorted.sam
│   ├── merged.collapsed.filtered.rep_junctions.txt
│   ├── merged.collapsed.filtered.rep_sqanti_report.pdf
│   ├── merged.collapsed.filtered.rep_tappAS_annot_from_SQANTI3.gff3
│   ├── merged.collapsed.filtered.rep_other_files
│   └── other_files
├── subread
│   ├── {sample_A}.bam
│   ├── {sample_A}.bam.pbi
│   ├── {sample_A}.subreadset.xml
│   ├── {sample_B}.bam
│   ├── {sample_B}.bam.pbi
│   ├── {sample_B}.subreadset.xml
│   ├── merged.bam
│   └── merged.bam.pbi
└── targeted # targeted non-collapsed reads
    ├── {sample_A}.polished.hq_corrected_sorted_targeted.sam
    ├── {sample_B}.polished.hq_corrected_sorted_targeted.sam
    └── merged.polished.hq_corrected.sorted.targeted.sam
```

