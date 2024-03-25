# mpraDesignTools package usage script for processing VCF files
# This script demonstrates how to prepare data for massively parallel reporter assays (MPRA) using mpraDesignTools.

# Step 1: Load the mpraDesignTools package.
# If the package is not installed, you can install it using install.packages("mpraDesignTools") or an equivalent method for bioconductor packages.
library(mpraDesignTools)

# Step 2: Define the path to your VCF file and other parameters for the processVCF function.
# Here, we're working with a VCF file named '5p15.33.controls.fwd.rev.vcf'.

# Step 3: Execute the processVCF function with the specified parameters.
chr5p15.33.final <- processVCF(
  vcf = '5p15.33.controls.fwd.rev.vcf',  # Path to the VCF file.
  nper = 80,                             # Number of permutations for SNP combinations.
  upstreamContextRange = 72,             # Number of nucleotides upstream of the SNP to include.
  downstreamContextRange = 72,           # Number of nucleotides downstream of the SNP to include.
  outPath = '5p15.33.mpra.design.output.tsv',  # Output path for the resulting TSV file.
  fwprimer = 'ACTGGCCGCTTCACTG',              # Sequence of the forward primer.
  revprimer = 'AGATCGGAAGAGCGTCG',            # Sequence of the reverse primer.
  alter_aberrant = TRUE,                      # Whether to modify aberrant base pairs.
  extra_elements = FALSE,                     # Whether to include extra elements in the output.
  max_construct_size = 230,                   # Maximum size of the MPRA construct.
  barcode_set = barcodes.jiyeon$V1,           # Set of barcodes to use.
  ensure_all_4_nuc = TRUE                     # Ensure all four nucleotides are represented in each construct.
)

# This function call will process the given VCF file to generate a design for MPRA experiments.
# The output will be saved in the specified TSV file, ready for further analysis or experimental use.

# Important Notes:
# - Ensure that the `barcodes.jiyeon` dataset is correctly loaded and available in your R session.
# - Adjust the primer sequences (`fwprimer` and `revprimer`), construct size (`max_construct_size`), and other parameters as needed for your specific experimental design.

# End of the mpraDesignTools package usage script
