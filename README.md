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
![dag]()


### IV. Example output
```bash
.  user/defined/output_dir
├── ccs_bam # ccs reads
│   ├── {sample_A}_ccs.bam
│   ├── {sample_A}_ccs.bam.pbi
│   ├── {sample_A}_ccs.ccs_report.txt
│   ├── {sample_A}_ccs.zmw_metrics.json.gz
│   ├── {sample_B}_ccs.bam
│   ├── {sample_B}_ccs.bam.pbi
│   ├── {sample_B}_ccs.ccs_report.txt
│   ├── {sample_B}_ccs.zmw_metrics.json.gz
│   └── merged_ccs.bam
├── cluster # clusted unpolished reads
│   ├── {sample_A}.unpolished.bam
│   ├── {sample_A}.unpolished.bam.pbi
│   ├── {sample_A}.unpolished.cluster
│   ├── {sample_A}.unpolished.cluster_report.csv
│   ├── {sample_A}.unpolished.fasta.gz
│   ├── {sample_A}.unpolished.transcriptset.xml
│   ├── {sample_B}.unpolished.bam
│   ├── {sample_B}.unpolished.bam.pbi
│   ├── {sample_B}.unpolished.cluster
│   ├── {sample_B}.unpolished.cluster_report.csv
│   ├── {sample_B}.unpolished.fasta.gz
│   ├── {sample_B}.unpolished.transcriptset.xml
│   ├── merged.unpolished.bam
│   ├── merged.unpolished.bam.pbi
│   ├── merged.unpolished.cluster
│   ├── merged.unpolished.cluster_report.csv
│   ├── merged.unpolished.fasta.gz
│   └── merged.unpolished.transcriptset.xml
├── collapsed # collapsed reads
│   ├── {sample_A}.collapsed.abundance.txt
│   ├── {sample_A}.collapsed.fasta
│   ├── {sample_A}.collapsed.filtered.abundance.txt
│   ├── {sample_A}.collapsed.filtered.gff
│   ├── {sample_A}.collapsed.filtered.rep.fasta
│   ├── {sample_A}.collapsed.filtered.rep.fq
│   ├── {sample_A}.collapsed.filtered.rep.renamed.fasta
│   ├── {sample_A}.collapsed.gff
│   ├── {sample_A}.collapsed.gff.unfuzzy
│   ├── {sample_A}.collapsed.group.txt
│   ├── {sample_A}.collapsed.group.txt.unfuzzy
│   ├── {sample_A}.collapsed.read_stat.txt
│   ├── {sample_A}.collapsed.rep.fq
│   ├── {sample_A}.complete.txt
│   ├── {sample_A}.ignored_ids.txt
│   ├── {sample_B}.collapsed.abundance.txt
│   ├── {sample_B}.collapsed.fasta
│   ├── {sample_B}.collapsed.filtered.abundance.txt
│   ├── {sample_B}.collapsed.filtered.gff
│   ├── {sample_B}.collapsed.filtered.rep.fasta
│   ├── {sample_B}.collapsed.filtered.rep.fq
│   ├── {sample_B}.collapsed.filtered.rep.renamed.fasta
│   ├── {sample_B}.collapsed.gff
│   ├── {sample_B}.collapsed.gff.unfuzzy
│   ├── {sample_B}.collapsed.group.txt
│   ├── {sample_B}.collapsed.group.txt.unfuzzy
│   ├── {sample_B}.collapsed.read_stat.txt
│   ├── {sample_B}.collapsed.rep.fq
│   ├── {sample_B}.complete.txt
│   ├── {sample_B}.ignored_ids.txt
│   ├── merged.collapsed.abundance.txt
│   ├── merged.collapsed.fasta
│   ├── merged.collapsed.filtered.abundance.txt
│   ├── merged.collapsed.filtered.gff
│   ├── merged.collapsed.filtered.rep.fasta
│   ├── merged.collapsed.filtered.rep.fq
│   ├── merged.collapsed.filtered.rep.renamed.fasta
│   ├── merged.collapsed.gff
│   ├── merged.collapsed.gff.unfuzzy
│   ├── merged.collapsed.group.txt
│   ├── merged.collapsed.group.txt.unfuzzy
│   ├── merged.collapsed.read_stat.txt
│   ├── merged.collapsed.rep.fq
│   └── merged.ignored_ids.txt
├── kallisto_index
│   ├── complete.txt
│   └── index
├── polished # clustered polished reads
│   ├── {sample_A}.polished.bam
│   ├── {sample_A}.polished.bam.pbi
│   ├── {sample_A}.polished.cluster_report.csv
│   ├── {sample_A}.polished.hq.fasta
│   ├── {sample_A}.polished.hq.fasta.gz
│   ├── {sample_A}.polished.hq.fastq
│   ├── {sample_A}.polished.hq.fastq.gz
│   ├── {sample_A}.polished.hq.renamed.fasta
│   ├── {sample_A}.polished.lq.fasta.gz
│   ├── {sample_A}.polished.lq.fastq.gz
│   ├── {sample_A}.polished.transcriptset.xml
│   ├── {sample_B}.polished.bam
│   ├── {sample_B}.polished.bam.pbi
│   ├── {sample_B}.polished.cluster_report.csv
│   ├── {sample_B}.polished.hq.fasta
│   ├── {sample_B}.polished.hq.fasta.gz
│   ├── {sample_B}.polished.hq.fastq
│   ├── {sample_B}.polished.hq.fastq.gz
│   ├── {sample_B}.polished.hq.renamed.fasta
│   ├── {sample_B}.polished.lq.fasta.gz
│   ├── {sample_B}.polished.lq.fastq.gz
│   ├── {sample_B}.polished.transcriptset.xml
│   ├── merged.polished.bam
│   ├── merged.polished.bam.pbi
│   ├── merged.polished.cluster_report.csv
│   ├── merged.polished.hq.fasta
│   ├── merged.polished.hq.fasta.gz
│   ├── merged.polished.hq.fastq
│   ├── merged.polished.hq.fastq.gz
│   ├── merged.polished.hq.renamed.fasta
│   ├── merged.polished.lq.fasta.gz
│   ├── merged.polished.lq.fastq.gz
│   └── merged.polished.transcriptset.xml
├── sqanti # splicing analysis with non-collpased reads
│   ├── GMST
│   ├── lima_output.lbc73--lbc73.polished.hq_classification.txt
│   ├── lima_output.lbc73--lbc73.polished.hq_corrected.fasta
│   ├── lima_output.lbc73--lbc73.polished.hq_corrected.genePred
│   ├── lima_output.lbc73--lbc73.polished.hq_corrected.gtf
│   ├── lima_output.lbc73--lbc73.polished.hq_corrected.gtf.cds.gff
│   ├── lima_output.lbc73--lbc73.polished.hq_corrected.gtf.tmp
│   ├── lima_output.lbc73--lbc73.polished.hq_corrected_indels.txt
│   ├── lima_output.lbc73--lbc73.polished.hq_corrected.sam
│   ├── lima_output.lbc73--lbc73.polished.hq_corrected_sorted.sam
│   ├── lima_output.lbc73--lbc73.polished.hq_junctions.txt
│   ├── lima_output.lbc73--lbc73.polished.hq.params.txt
│   ├── lima_output.lbc73--lbc73.polished.hq_sqanti_report.pdf
│   ├── lima_output.lbc74--lbc74.polished.hq_classification.txt
│   ├── lima_output.lbc74--lbc74.polished.hq_corrected.fasta
│   ├── lima_output.lbc74--lbc74.polished.hq_corrected.genePred
│   ├── lima_output.lbc74--lbc74.polished.hq_corrected.gtf
│   ├── lima_output.lbc74--lbc74.polished.hq_corrected.gtf.cds.gff
│   ├── lima_output.lbc74--lbc74.polished.hq_corrected.gtf.tmp
│   ├── lima_output.lbc74--lbc74.polished.hq_corrected_indels.txt
│   ├── lima_output.lbc74--lbc74.polished.hq_corrected.sam
│   ├── lima_output.lbc74--lbc74.polished.hq_corrected_sorted.sam
│   ├── lima_output.lbc74--lbc74.polished.hq_junctions.txt
│   ├── lima_output.lbc74--lbc74.polished.hq.params.txt
│   ├── lima_output.lbc74--lbc74.polished.hq_sqanti_report.pdf
│   ├── merged.polished.hq_classification.txt
│   ├── merged.polished.hq_corrected.fasta
│   ├── merged.polished.hq_corrected.genePred
│   ├── merged.polished.hq_corrected.gtf
│   ├── merged.polished.hq_corrected.gtf.cds.gff
│   ├── merged.polished.hq_corrected.gtf.tmp
│   ├── merged.polished.hq_corrected_indels.txt
│   ├── merged.polished.hq_corrected.sam
│   ├── merged.polished.hq_corrected.sorted.sam
│   ├── merged.polished.hq_junctions.txt
│   ├── merged.polished.hq.params.txt
│   ├── merged.polished.hq_sqanti_report.pdf
│   ├── refAnnotation_lima_output.lbc73--lbc73.polished.hq.genePred
│   ├── refAnnotation_lima_output.lbc74--lbc74.polished.hq.genePred
│   ├── refAnnotation_merged.polished.hq.genePred
│   └── RTS
│       └── sj.rts.results.tsv
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
│   ├── {sample_A}.collapsed.filtered.rep_corrected.genePred
│   ├── {sample_A}.collapsed.filtered.rep_corrected.gtf
│   ├── {sample_A}.collapsed.filtered.rep_corrected.gtf.cds.gff
│   ├── {sample_A}.collapsed.filtered.rep_corrected.gtf.tmp
│   ├── {sample_A}.collapsed.filtered.rep_corrected_indels.txt
│   ├── {sample_A}.collapsed.filtered.rep_corrected.sam
│   ├── {sample_A}.collapsed.filtered.rep_corrected_sorted.sam
│   ├── {sample_A}.collapsed.filtered.rep_junctions.txt
│   ├── {sample_A}.collapsed.filtered.rep.params.txt
│   ├── {sample_A}.collapsed.filtered.rep_sqanti_report.pdf
│   ├── {sample_A}_sqanti_r2_filter_complete.txt
│   ├── {sample_B}.collapsed.filtered.rep_classification.filtered_lite_classification.txt
│   ├── {sample_B}.collapsed.filtered.rep_classification.filtered_lite.fasta
│   ├── {sample_B}.collapsed.filtered.rep_classification.filtered_lite.gtf
│   ├── {sample_B}.collapsed.filtered.rep_classification.filtered_lite_junctions.txt
│   ├── {sample_B}.collapsed.filtered.rep_classification.filtered_lite_reasons.txt
│   ├── {sample_B}.collapsed.filtered.rep_classification.filtered_lite_sqanti_report.pdf
│   ├── {sample_B}.collapsed.filtered.rep_classification.txt
│   ├── {sample_B}.collapsed.filtered.rep_corrected.fasta
│   ├── {sample_B}.collapsed.filtered.rep_corrected.genePred
│   ├── {sample_B}.collapsed.filtered.rep_corrected.gtf
│   ├── {sample_B}.collapsed.filtered.rep_corrected.gtf.cds.gff
│   ├── {sample_B}.collapsed.filtered.rep_corrected.gtf.tmp
│   ├── {sample_B}.collapsed.filtered.rep_corrected_indels.txt
│   ├── {sample_B}.collapsed.filtered.rep_corrected.sam
│   ├── {sample_B}.collapsed.filtered.rep_corrected_sorted.sam
│   ├── {sample_B}.collapsed.filtered.rep_junctions.txt
│   ├── {sample_B}.collapsed.filtered.rep.params.txt
│   ├── {sample_B}.collapsed.filtered.rep_sqanti_report.pdf
│   ├── {sample_B}_sqanti_r2_filter_complete.txt
│   ├── merged.collapsed.filtered.rep_classification.txt
│   ├── merged.collapsed.filtered.rep_corrected.fasta
│   ├── merged.collapsed.filtered.rep_corrected.genePred
│   ├── merged.collapsed.filtered.rep_corrected.gtf
│   ├── merged.collapsed.filtered.rep_corrected.gtf.cds.gff
│   ├── merged.collapsed.filtered.rep_corrected.gtf.tmp
│   ├── merged.collapsed.filtered.rep_corrected_indels.txt
│   ├── merged.collapsed.filtered.rep_corrected.sam
│   ├── merged.collapsed.filtered.rep_corrected.sorted.sam
│   ├── merged.collapsed.filtered.rep_junctions.txt
│   ├── merged.collapsed.filtered.rep.params.txt
│   ├── merged.collapsed.filtered.rep_sqanti_report.pdf
│   ├── merged.collapsed.filtered.rep_tappAS_annot_from_SQANTI3.gff3
│   ├── merged_sqanti_r2_complete.txt
│   ├── refAnnotation_{sample_A}.collapsed.filtered.rep.genePred
│   ├── refAnnotation_{sample_B}.collapsed.filtered.rep.genePred
│   ├── refAnnotation_merged.collapsed.filtered.rep.genePred
│   └── RTS
│       └── sj.rts.results.tsv
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

