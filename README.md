This repository contains the scripts and analysis files used to generate the figures for an upcoming publication on *Rickettsia africae* infection in *Amblyomma variegatum* ticks.  

The repository includes:
Bash scripts used for read mapping, variant calling, and PCA preparation.  
R Markdown files used for statistical analysis and figure generation.  
The code reflects how the analyses were performed for this study and is intended for transparency rather than general reuse.  

## Figures and directories

### Tick screening for *Rickettsia africae* (qPCR, scatter plot)
**Scatter plot** of sca12 and gltA copy numbers in field-collected ticks.  

**Aim:** 
Screening for *Rickettsia africae* infection in *Amblyomma variegatum* ticks based on a qPCR assay for the plasmid sca12 gene, which should only be present in live bacteria, and the standard gltA qPCR assay.

**Hypothesis:** sca12 is detected in ticks with actual infection even though gltA could be detected in all ticks regardless of infection status. 

**Approach:** qPCR assays targeting sca12 and gltA were performed. Target copy numbers were normalized to a tick housekeeping gene. A scatter plot of normalized sca12 vs gltA values was generated in R to assess co-detection across samples. The results were used as sample-level metadata for downstream variant calling and coverage analyses (see the following section).

Directory: `/Avariegatum_seq/qPCR/251030_scatterplot_R/`  
- [Visualisation in R markdown](https://khoojj.github.io/Avariegatum_insertion/251030_scatter.html)

### Variant profile PCA of *Rickettsia africae* infected and uninfected ticks
**Principal component analysis** of SNPs from tick and cell line reads mapped to *R. africae* ESF-5 chromosome.  

**Aim:** 
Identify *Amblyomma variegatum* tick populations with true *Rickettsia africae* infection based on variant (SNP) profiles.  

**Hypothesis:** Insertion-sequence–derived reads show SNP patterns that differ from reads originating from true *R. africae* infection.  

**Approach:** Illumina reads from *A. variegatum* ticks previously assayed as having high (n = 15) or low (n = 23) copy numbers of the plasmid gene sca12 were mapped to the *R. africae* ESF-5 chromosome sequence. Read groups were added and duplicate reads were marked using Picard. Variant calling was performed with FreeBayes, followed by filtering and restriction to the mitochondrial contig. Principal component analysis (PCA) was performed using PLINK2, with downstream visualisation and interpretation in R.  

Directory: `/Avariegatum_seq/03_cameroonticks/14_Ra_snp/`  

**Files and directories:** 

PCA analysis (R Markdown):  
`/Avariegatum_seq/03_cameroonticks/14_Ra_snp/251017_pca/`  

Upstream scripts and command log (generate inputs for PCA):    
`/Avariegatum_seq/03_cameroonticks/14_Ra_snp/scripts/`  
Mapping: map_Ra_v1.3.sh  
BAM processing (add read groups, mark duplicates with Picard): process_bam_v1.sh  
Variant calling: run_freebayes_v2.sh  
VCF filtering + PLINK2 PCA command log: vcf_filter_and_plink_commands.txt  

**High-level analysis path**  
Map reads to *R. africae* reference → sorted BAM  
Add read groups and mark duplicates using Picard  
Call SNPs with FreeBayes  
Filter variants (bcftools/vcftools) and restrict to target contig (NC_012633.1)  
Perform PCA using PLINK2 and visualise results in R (251017_pca/)  

- [Visualisation in R markdown](https://khoojj.github.io/Avariegatum_insertion/251017_pca.html)

### Coverage of *Rickettsia africae* infected and uninfected ticks
**Coverage plot** for reads from ticks and cell lines mapped to *R. africae* ESF-5 chromosome.  
Directory: `/Avariegatum_seq/03_cameroonticks/15_Ra_coverage/`

### Notes
Paths and parameters in Bash scripts are intentionally hard-coded to reflect the original analysis environment.  
Scripts are provided to document the analysis steps rather than as reusable pipelines.  
