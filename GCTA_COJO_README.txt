# Genome-wide Complex Trait Analysis (GCTA) Guide Script
# Version: 1.93.0 beta Mac
# Author: The University of Queensland
# Contact: Jian Yang <jian.yang@uq.edu.au>
# (C) 2010-2019, The University of Queensland
# Analysis Timestamp: Thu Mar 26 23:21:10 EDT 2020
# Hostname: NCI-02134594-ML

# Start of the GCTA-COJO analysis script

# Step 1: Set your working directory to where your files are located.
# cd /path/to/your/directory

# Step 2: Run GCTA with the --cojo-file, --bfile, --out, and --cojo-slct options.
gcta64 --cojo-file chr5.1KGP.COJO.260320.txt \
       --bfile /Users/obriena2/Documents/gwas.loci/chr5/genotypes/1KGP/chr5.plink.26.03.20 \
       --out chr5.1KGP.COJO.out \
       --cojo-slct

# Note:
# - --cojo-file specifies the GWAS summary statistics file.
# - --bfile points to the binary genotype files in PLINK format (without the extension).
# - --out defines the output file prefix.
# - --cojo-slct enables stepwise model selection to identify independent association signals.

# After running the command, GCTA will perform the following steps:
# 1. Read genotype data from the specified PLINK files.
# 2. Include individuals and SNPs based on the .fam and .bim file contents.
# 3. Read GWAS summary statistics from the specified file.
# 4. Match GWAS summary statistics to genotype data, calculate allele frequencies, and perform quality checks.
# 5. Execute conditional and joint (COJO) analysis, including stepwise model selection.

# The output will consist of:
# - A list of SNPs selected for their association signals.
# - The LD structure and conditional analysis results of remaining SNPs.
# - Information on SNPs with large allele frequency differences between GWAS summary data and reference sample.

# The analysis concludes with the saving of selected signals and relevant data to specified output files.
# Overall computational time is also reported at the end of the script.

# End of GCTA-COJO analysis guide script
