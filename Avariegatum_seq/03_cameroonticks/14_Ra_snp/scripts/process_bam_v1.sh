#!/bin/bash

# Define the processing function
process_bam() {
  local bam_file="$1"
  # Get the base name of the BAM file (without path and extension)
  local base_name=$(basename "$bam_file" _Ra_sort.bam)

  # Set the Read Group Sample Name (RGSM)
  local RGSM="$base_name"

  # --- Step 1: Add Read Groups ---
  local rg_bam="${base_name}_withRG.bam"
  
  picard AddOrReplaceReadGroups \
    I="$bam_file" \
    O="$rg_bam" \
    RGID="$base_name" \
    RGLB="lib1" \
    RGPL="illumina" \
    RGPU="unit1" \
    RGSM="$RGSM" \
    CREATE_INDEX=false # Indexing will be done after MarkDuplicates
  
  echo "✅ Added Read Groups to $bam_file, outputting to $rg_bam"

  # --- Step 2: Mark Duplicates ---
  local dup_bam="${base_name}_ready.bam"
  local metrics_file="${base_name}_dup_metrics.txt"
  
  picard MarkDuplicates \
    I="$rg_bam" \
    O="$dup_bam" \
    M="$metrics_file" \
    CREATE_INDEX=true # Create the index now for the final BAM

  echo "✅ Marked Duplicates for $base_name, final BAM is $dup_bam"

  # --- Step 3: Cleanup Intermediate File ---
  # Remove the intermediate BAM file that only has Read Groups added
  rm "$rg_bam"
  
  echo "🧹 Cleaned up intermediate file $rg_bam"
}

# Export the function so GNU Parallel can use it
export -f process_bam

# Find all BAM files and feed them to GNU Parallel
# Use -j 10 to limit to 10 parallel jobs
find . -maxdepth 1 -name '*_Ra_sort.bam' -print0 | parallel -0 -j 10 process_bam
