#!/bin/bash

# the following script reformats GTEx phenotype BED files and reindexes them

# Directory containing your .bed.gz files
DIRECTORY="/path/to/your/directory"

# Loop over each .bed.gz file in the directory
for file in $DIRECTORY/*.bed.gz
do
    # Remove 'chr' prefix and create a new intermediate file
    zcat "$file" | awk '{ sub(/^chr/, "", $1); print }' | bgzip > "${file%.bed.gz}.mod.bed.gz"

    # Sort the modified file according to BED format
    zcat "${file%.bed.gz}.mod.bed.gz" | sort -k1,1 -k2,2n | bgzip > "${file%.bed.gz}.sorted.mod.bed.gz"

    # Remove intermediate unsorted file
    rm "${file%.bed.gz}.mod.bed.gz"

    # Index the sorted file with tabix
    tabix -p bed "${file%.bed.gz}.sorted.mod.bed.gz"
done
