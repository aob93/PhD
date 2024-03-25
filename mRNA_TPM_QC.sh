#!/bin/sh

#sbatch --cpus-per-task=6 --mem=75g --mail-type=END,FAIL --time=24:00:00 mRNA_TPM_QC.sh

module load R/3.5.0

Rscript mRNA_TPM_QC.R SC728400 SC728401 SC728402 SC728403 SC728404 SC728405

