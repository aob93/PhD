#!/bin/bash

# Navigate to the Analysis directory and create a subdirectory for the HapMap Project (Nov 23)
cd Analysis/
mkdir -p HapMap_PB_Nov23/fasta
cd HapMap_PB_Nov23/fasta

# Copy all fasta files from the source directory to the current directory
cp /Volumes/ifs/DCEG/Projects/DataDelivery/laufey/RP0325-008_chr5p15.33_PacBio/str1/pbaa/*fasta .

# Concatenate all fasta files into a single file
cat *fasta > all.fasta

# Remove white spaces from IDs in the concatenated fasta file
sed -i '' 's/ /_/g' all.fasta

# Run Tandem Repeats Finder (TRF) on the concatenated fasta file
/Users/obriena2/trf409.macosx all.fasta 2 7 7 80 10 50 500 -f -d -m -h

# Convert TRF .dat output to a text file for easier handling
# This python code was from https://github.com/hdashnow/TandemRepeatFinder_scripts/
python3 /Users/obriena2/TRFdat_to_txt.py --dat all.fasta.2.7.7.80.10.50.500.dat --txt all.fasta.2.7.7.80.10.50.500.txt

# Create a table of the fasta sequences for further analysis
/Users/obriena2/seqkit fx2tab all.fasta > all_fasta.tab

# Note: For a more hands-on look at the data, you can open the resulting .tab file in Excel or any other spreadsheet software
# This is not part of the script, but a manual step:
# Open the 'all_fasta.tab' file in Excel for analysis

echo "Process completed. Check 'all_fasta.tab' for results."
