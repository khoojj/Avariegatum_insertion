#!/bin/bash


# --- CONFIGURATION ---
# Set the main directory where all sample folders reside
main_directory="/pub59/jingk/02_Avariegatum/03_cameroonticks/data/all_cam_renamed"
export BOWTIE2_INDEXES=/pub59/jingk/02_Avariegatum/03_cameroonticks/ncbi_dataset/GCF_000023005.1
NUM_JOBS=5 # The number of concurrent jobs for GNU Parallel 5 * (8+8) = 80 threads max)

# --- CONSOLIDATION FUNCTION (Executed by GNU Parallel) ---

# This function takes the FULL_PATH_R1 as its argument
process_sample() {
    FULL_PATH_R1=$1
    
    # Extract paths and prefix
    DIR_NAME=$(dirname "$FULL_PATH_R1")
    FILENAME=$(basename "$FULL_PATH_R1")
    prefix="${FILENAME%_R1.fq.gz}"
    
    # Define file paths based on the full directory path
    R1_FILE="$FULL_PATH_R1"
    R2_FILE="${DIR_NAME}/${prefix}_R2.fq.gz"
    
    # Define the final output BAM file
    FINAL_BAM="${DIR_NAME}/${prefix}_Ra_sort.bam"
    LOG_FILE="${DIR_NAME}/${prefix}_Ra_mito.log" # Changed from .nohup
    
    echo "--- Starting alignment for $prefix ---"

    # Bowtie2 -> Samtools View (to BAM) -> Samtools Sort
    # 1. bowtie2: Output streamed to stdout (pipe)
    # 2. samtools view: Converts SAM stream to BAM stream and filters:
    #    -b: BAM output
    #    -f 0x2: Keep only properly paired reads
    #    -F 0xC: Exclude unmapped reads (0x4) and their unmapped mates (0x8)
    # 3. samtools sort: Sorts the BAM stream and writes the final indexed file
    
    bowtie2 -x Ra_mito -p 8 -1 "$R1_FILE" -2 "$R2_FILE" 2> "$LOG_FILE" | \
    samtools view -b -f 0x2 -F 0xC - | \
    samtools sort -@ 8 -o "$FINAL_BAM" -

    # Create the BAM index
    samtools index "$FINAL_BAM"

    echo "--- Finished $prefix. Output: $FINAL_BAM ---"
}

# Export the function and variables for GNU Parallel
export -f process_sample
export TARGET_DIR main_directory NUM_JOBS

# --- MAIN EXECUTION ---

echo "Starting Bowtie2/Samtools pipeline with $NUM_JOBS concurrent jobs."

# Find all R1 files recursively and feed the full path to the function via parallel
find "$main_directory" -type f -name '*_R1.fq.gz' -print | \
    parallel --jobs "$NUM_JOBS" process_sample {}

echo "All alignment jobs complete."


