#!/bin/bash

# --- CONFIGURATION ---
# Directory containing your sorted and indexed BAM files (Relative Path)
BAM_INPUT_DIR="/pub59/jingk/02_Avariegatum/03_cameroonticks/data/all_cam_renamed/02_bam_Ra"

# Directory for mosdepth output files (Relative Path)
MOSDEPTH_OUTPUT_DIR="./01_mosdepth_coverage_1kb"

# Directory for mosdepth log files (Relative Path)
MOSDEPTH_LOG_DIR="./mosdepth_logs_1kb"

# Number of threads for mosdepth for EACH individual job (CPU bound)
MOSDEPTH_THREADS=4

# Window size for coverage calculation (in base pairs). 
COVERAGE_WINDOW_SIZE=1000

# --- SCRIPT START ---
echo "--- Step 3: Running Mosdepth for Windowed Coverage Calculation ---"
echo "Window size: ${COVERAGE_WINDOW_SIZE} bp"
echo "Threads per job: ${MOSDEPTH_THREADS}"

# Find all sorted BAM files, which results in relative paths starting from the script's CWD
BAM_FILES=$(find "${BAM_INPUT_DIR}" -maxdepth 1 -name "*_Ra_sort.bam" | sort)

# Initialize a counter for jobs and an array to track PIDS
JOB_COUNT=0
PIDS=()

echo "Found the following BAM files to process:"

# Loop through each BAM file and launch mosdepth in the background
for BAM_FILE in ${BAM_FILES}; do

    SAMPLE_NAME=$(basename "${BAM_FILE}" _Ra_sort.bam)
    MOSDEPTH_PREFIX="${MOSDEPTH_OUTPUT_DIR}/${SAMPLE_NAME}"
    SAMPLE_LOG="${MOSDEPTH_LOG_DIR}/${SAMPLE_NAME}.mosdepth.log"
    
    echo "  - Launching ${SAMPLE_NAME}"

    # CRITICAL FIX: Symlinks .csi to .bai if needed before running mosdepth
    # This check relies on the index file being next to the BAM file, which works with relative paths.
    if [ ! -f "${BAM_FILE}.bai" ] && [ -f "${BAM_FILE%.bam}.csi" ]; then
        # mosdepth looks for an index next to the BAM file
        echo "    * Index fix: Symlinking ${BAM_FILE%.bam}.csi to ${BAM_FILE}.bai"
        ln -s "${BAM_FILE%.bam}.csi" "${BAM_FILE}.bai"
    fi

    # Execute mosdepth, redirecting all output (stdout and stderr) to the log file.
    
    mosdepth -t "${MOSDEPTH_THREADS}" -b "${COVERAGE_WINDOW_SIZE}" --chrom NC_012633.1 -Q 10 -x "${MOSDEPTH_PREFIX}" "${BAM_FILE}" > "${SAMPLE_LOG}" 2>&1 &
    
    # Store the PID and increment the count
    PIDS+=($!)
    JOB_COUNT=$((JOB_COUNT + 1))
done

echo ""
echo "Total ${JOB_COUNT} mosdepth jobs launched in the background."
echo "Waiting for all jobs to complete..."

# Wait for all background jobs to complete
wait

echo "--- All mosdepth jobs have completed. ---"


