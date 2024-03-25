#!/bin/bash

# PLINK Regression Script for Analyzing VNTR Data

# Define PLINK executable location (modify this path based on your PLINK installation)
PLINK_EXEC="/path/to/plink2"

# Define working directory (modify this path to your working directory)
WORK_DIR="/gpfs/gsfs12/users/obriena2/VNTR/Feb24/March24/200324/P12"

# Change to working directory
cd "$WORK_DIR"

# Execute PLINK command with specified options
$PLINK_EXEC \
  --1 \
  --ci 0.95 \
  --condition LS_VNTR2_50 \
  --covar PS12_covar.txt \
  --glm hide-covar cols=+a1freq \
  --out P12_plink2_200324_LS_VNTR2_50 \
  --pfile P12_all_plink2 \
  --pheno P12_pheno.txt

# Note: 
# - --1 specifies that individuals with missing phenotype data are ignored.
# - --ci 0.95 sets the confidence interval to 95% for the regression.
# - --condition LS_VNTR2_50 performs a conditional analysis on the specified variant.
# - --covar PS12_covar.txt points to a file containing covariate data.
# - --glm hide-covar cols=+a1freq performs a logistic regression with specified column formatting.
# - --out P12_plink2_200324_LS_VNTR2_50 names the output files.
# - --pfile P12_all_plink2 specifies the input file prefix for PLINK binary files.
# - --pheno P12_pheno.txt indicates the file containing phenotype information.

# After running, the results are written to P12_plink2_200324_LS_VNTR2_50.STATUS_CASE.glm.logistic.hybrid
# indicating logistic-Firth hybrid regression analysis was completed successfully.

echo "PLINK regression analysis completed. Check the output files in $WORK_DIR"
