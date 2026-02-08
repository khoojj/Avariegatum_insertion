This repository contains the scripts and analysis files used to generate the figures for an upcoming publication on *Rickettsia africae* infection in *Amblyomma variegatum* ticks.
The repository includes:
Bash scripts used for read mapping, variant calling, and PCA preparation
R Markdown files used for statistical analysis and figure generation
The code reflects how the analyses were performed for this study and is intended for transparency rather than general reuse.

## Figures and directories

### Tick screening for *Rickettsia africae* (qPCR, scatter plot)
**Scatter plot** of sca12 and gltA copy numbers in field-collected ticks.  
Directory: `/Avariegatum_seq/qPCR/251030_scatterplot_R/`  
- [Complete analysis in R markdown](https://khoojj.github.io/Avariegatum_insertion/251030_scatter.html)

### Variant profile PCA of *Rickettsia africae* infected and uninfected ticks
**Principal component analysis** of SNPs from tick and cell line reads mapped to *R. africae* ESF-5 chromosome.  
Directory: `/Avariegatum_seq/03_cameroonticks/14_Ra_snp/`  

**Contents:**
Upstream processing scripts (mapping → BAM processing → variant calling → PLINK):
`/Avariegatum_seq/03_cameroonticks/14_Ra_snp/scripts/`
Downstream PCA analysis (R Markdown):
`/variegatum_seq/03_cameroonticks/14_Ra_snp/251017_pca/`
High-level analysis path:
Mapping → BAM processing/duplicate marking → FreeBayes variant calling → VCF filtering/contig selection → PLINK2 PCA → visualisation in R

- [Visualisation in R markdown](https://khoojj.github.io/Avariegatum_insertion/251017_pca.html)

### Coverage of *Rickettsia africae* infected and uninfected ticks
**Coverage plot** for reads from ticks and cell lines mapped to *R. africae* ESF-5 chromosome.  
Directory: `/Avariegatum_seq/03_cameroonticks/15_Ra_coverage/`

### Notes
Paths and parameters in Bash scripts are intentionally hard-coded to reflect the original analysis environment.
Scripts are provided to document the analysis steps rather than as reusable pipelines.
