## Overview
This repository contains scripts for an exploratory analysis for an upcoming publication to distinguish between true *Rickettsia africae* infection and potential genome integration signals in *Amblyomma variegatum* ticks.  

## Work performed
- qPCR screening to identify putatively infected and uninfected tick populations.   
- Variant and coverage analysis using NGS data from putatively infected and uninfected populations.   

## Repository contents
- **Bash scripts** for read mapping, variant calling, and PCA input preparation    
- **R Markdown** files for statistical analysis and figure generation  

## Notes on scope
The code reflects how the analyses were performed for this study and is provided for transparency and traceability rather than as a general-purpose, reusable pipeline.  

## Figures and directories
- Tick screening for *R. africae* (qPCR; sca12 vs gltA)  
- Variant-profile PCA (SNPs mapped to *R. africae* reference)  
- Coverage profiles across the *R. africae* reference genome  


### Tick screening for *Rickettsia africae* (qPCR, scatter plot)
**Scatter plot** of sca12 and gltA copy numbers in field-collected ticks.  

**Aim:** 
Screening for *R. africae* infection in *A. variegatum* ticks to identify putatively infected and uninfected tick populations.  

**Hypothesis:** Plasmid sca12 gene is detected in ticks with actual infection, while gltA could be detected in all ticks regardless of infection status as it is integrated into the tick genome.  

**Approach:** qPCR assays targeting sca12 and gltA were performed. Target copy numbers were normalized to a tick housekeeping gene. A scatter plot of normalized sca12 vs gltA values was generated in R to assess co-detection across samples. The results were used as sample-level metadata for downstream variant calling and coverage analyses (see the following section).  

**Directory:** `/Avariegatum_seq/qPCR/251030_scatterplot_R/`  
- [Visualisation in R markdown](https://khoojj.github.io/Avariegatum_insertion/251030_scatter.html)

### Variant profile PCA of *Rickettsia africae* infected and uninfected ticks
**Principal component analysis** of SNPs from tick and cell line reads mapped to *R. africae* ESF-5 chromosome.  

**Aim:** 
Identify *A. variegatum* tick populations with actual *R. africae* infection based on variant (SNP) profiles.  

**Hypothesis:**  SNP patterns differ between putatively infected and uninfected tick populations.

**Approach:** Illumina reads from putatively infected and uninfected ticks were mapped to the *R. africae* ESF-5 chromosome sequence. Read groups were added and duplicate reads were marked using Picard. Variant calling was performed with FreeBayes, followed by filtering and restriction to the mitochondrial contig. Principal component analysis (PCA) was performed using PLINK2, with downstream visualisation and interpretation in R.  

**Files and directories:** 
- PCA analysis (R Markdown): `/Avariegatum_seq/03_cameroonticks/14_Ra_snp/251017_pca/`
- Upstream scripts / command log: `/Avariegatum_seq/03_cameroonticks/14_Ra_snp/scripts/`
  - Mapping: `map_Ra_v1.3.sh`
  - BAM processing (add read groups, mark duplicates): `process_bam_v1.sh`
  - Variant calling: `run_freebayes_v2.sh`
  - VCF filtering + PLINK2 PCA command log: `vcf_filter_and_plink_commands.txt`

**High-level analysis path**  
Map reads to *R. africae* reference → sorted BAM  
Add read groups and mark duplicates using Picard  
Call SNPs with FreeBayes  
Filter variants (bcftools/vcftools) and restrict to target contig (NC_012633.1)  
Perform PCA using PLINK2 and visualise results in R (251017_pca/)  

- [Visualisation in R markdown](https://khoojj.github.io/Avariegatum_insertion/251017_pca.html)

### Coverage of *Rickettsia africae* infected and uninfected ticks
**Coverage plot** for reads from ticks and cell lines mapped to *R. africae* ESF-5 chromosome.  

**Aim:** 
Identify *A. variegatum* tick populations with actual *R. africae* infection based on coverage profiles.  

**Hypothesis:** Putatively infected ticks have even coverage across the *R. africae* genome while uninfected ticks have uneven coverage due to missing regions in the tick-genome-integrated sequence.   

**Approach:** Mapping bam files from the variant analysis were used to generate coverage profile across the *R. africae* genome in 1kb windows using Mosdepth, with downstream statistical analysis and visualisation in R.  

**Files and directories:** 
- Coverage analysis (R Markdown): `/Avariegatum_seq/03_cameroonticks/15_Ra_coverage/250107_coverage/`
- Upstream scripts / utilities: `/Avariegatum_seq/03_cameroonticks/15_Ra_coverage/scripts/`
  - Coverage (Mosdepth): `run_mosdepth_1kb.sh`
  - Combine region files: `combine_coverage.py` 

- [Visualisation in R markdown](https://khoojj.github.io/Avariegatum_insertion/250107_covplot.html)

### Notes
Paths and parameters in Bash scripts are intentionally hard-coded to reflect the original analysis environment.  
Scripts are provided to document the analysis steps rather than as reusable pipelines.  
