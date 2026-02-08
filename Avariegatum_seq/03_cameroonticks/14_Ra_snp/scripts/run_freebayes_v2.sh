#!/bin/bash

# Directory containing your processed BAM files
BAM_DIR="."

# Reference genome (MANDATORY: must be the FASTA file used for alignment)
REFERENCE="/pub59/jingk/02_Avariegatum/03_cameroonticks/ncbi_dataset/GCF_000023005.1/Ra_mito.fa"

# Create an output file for the variants
OUTPUT_VCF="freebayes_output_haploid_raw_v2.vcf"

# 1. Find all final, processed BAM files with the "_ready.bam" suffix
BAM_FILES=$(find "$BAM_DIR" -maxdepth 1 -name '*_ready.bam' | xargs)

# Check if any BAM files were found
if [ -z "$BAM_FILES" ]; then
    echo "ERROR: No BAM files ending with '_ready.bam' were found in $BAM_DIR."
    exit 1
fi

# 2. Run Freebayes on the selected BAM files
# This process is single-threaded (per region) by default.
freebayes \
  -f "$REFERENCE" \
  --ploidy 1 \
  -m 20 \
  --min-alternate-fraction 0.05 \
  -b $BAM_FILES \
  > "$OUTPUT_VCF"

echo "✅ Freebayes completed. Raw VCF output written to $OUTPUT_VCF"
