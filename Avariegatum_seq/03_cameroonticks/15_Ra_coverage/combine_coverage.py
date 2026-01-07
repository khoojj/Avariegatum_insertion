import pandas as pd
import os
import glob

# Configuration
input_dir = "./01_mosdepth_coverage_1kb"
output_file = "r_africae_1kb_coverage.xlsx"
target_chrom = "NC_012633.1"

# Find all regions files
files = glob.glob(os.path.join(input_dir, "*.regions.bed.gz"))

main_df = None

print(f"Processing {len(files)} samples...")

for f in sorted(files):
    sample_name = os.path.basename(f).replace(".regions.bed.gz", "")
    
    # Read the bed file
    # Columns: chrom, start, end, coverage
    df = pd.read_csv(f, sep='\t', names=['chrom', 'start', 'end', sample_name], compression='gzip')
    
    # Filter for Rickettsia only (just in case)
    df = df[df['chrom'] == target_chrom]
    
    if main_df is None:
        main_df = df
    else:
        # Merge on coordinates to ensure windows align perfectly
        main_df = pd.merge(main_df, df[['start', 'end', sample_name]], on=['start', 'end'])

# Save to Excel
main_df.to_excel(output_file, index=False)
print(f"Success! Saved coverage matrix to {output_file}")
