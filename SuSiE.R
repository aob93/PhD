# Step 1: Extract SNPs of Interest
# Use PLINK to process the BCF file. Adjust for the desired chromosome and reference (1KGP/HRC).
plink --bcf <bcf file> --recode A  --make-bed --extract <path to plain text file with list of rsIDs> --out chr<>.1KGP.plink 

# Step 2: Preparing Data in R
# Read in GWAS summary statistics. Ensure allele order matches PLINK file order.
gwas <- read.table(file="", header=TRUE, stringsAsFactors=FALSE)
bim <- read.table(file="*.bim", header=FALSE, stringsAsFactors=FALSE)

# Merge GWAS and BIM data, maintaining SNP order.
gwas.bim <- merge(gwas, bim, by.x="rsnum", by.y="V2", sort=FALSE)

# Step 3: Data Quality Check
# Identify allele mismatches.
mismatch_count <- length(which(gwas.bim$V5 != gwas.bim$ref))

# Recalculate effect sizes for mismatches.
mismatches <- which(gwas.bim$V5 != gwas.bim$ref)
gwas.bim$effect[mismatches] <- -gwas.bim$effect[mismatches]
gwas.bim$OR <- round(exp(gwas.bim$effect), 2)
gwas.bim$ci95lower <- round(exp(gwas.bim$effect - (1.96 * gwas.bim$se)), 2)
gwas.bim$ci95upper <- round(exp(gwas.bim$effect + (1.96 * gwas.bim$se)), 2)
gwas.bim$z.score <- gwas.bim$effect / gwas.bim$se
chr<>.zscores <- c(gwas.bim$z.score)
chr<>.pos <- c(gwas.bim$pos)

# Step 4: Creating an LD Matrix
# Load PLINK output for LD matrix computation.
chr<>.plink <- read.table(file="<>.raw", header=TRUE)
N <- dim(chr<>.plink)[1]
X <- as.matrix(chr<>.plink[, -c(1:6)])
X <- scale(X, center = TRUE, scale = TRUE)

# Verify matrix scaling.
mean(X[, 1]) # Should be 0 or very close.
sd(X[, 1]) # Should be 1.

# Calculate LD matrix.
ld <- t(X) %*% X / N
