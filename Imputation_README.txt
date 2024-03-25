# Step 1: Download high coverage 1KGP EUR VCF
wget ftp.1000genomes.ebi.ac.uk/vol1/ftp/data_collections/1000G_2504_high_coverage/working/20220422_3202_phased_SNV_INDEL_SV/1kGP_high_coverage_Illumina.chr5.filtered.SNV_INDEL_SV_phased_panel.vcf.gz

# Step 2: Filter the VCF to the first 6 Mb and retain only SNPs
# Replace [input_dataset] with your VCF file name, and [sample_list.txt] with your sample list. Specify the output dataset name in [output_dataset].
plink --vcf [input_dataset] --chr 5 --from-mb 0 --to-mb 6 --snps-only --keep [sample_list.txt] --recode vcf --out [output_dataset] --keep-allele-order

# Step 3: Add phase set indicator to VCF header to maintain within-sample phase
# Note: This should be done manually using a text editor like BBEdit, ensuring the following line is added to the VCF header:
# Manually integrate VNTR genotypes into VCF file, assigning unique pseudo-coordinates and alleles

##FORMAT=<ID=PS,Number=1,Type=Integer,Description="Phase set identifier">

# Resultant VCF file should be sorted and compressed with bcftools, then indexed with tabix, it will error if formatting is wrong


# Step 4: Phasing VNTR genotypes to SNPs with Shapeit4.2
# Make sure phase sets are assigned to maintain PacBio genotype phasing. Replace the input and output file names as necessary.
shapeit4.2 --input chr5_6Mb_SNPs_only_with_VNTRs_sorted.vcf.gz --map shapeit_maps/chr5.b38.gmap.gz --region 5 --output chr5_6Mb_SNPs_only_with_VNTRs_sorted_phased.vcf --use-PS 0.0001

# Note: VNTR genotypes are assigned arbitrary coordinates within the hg38 reference sequence that do not overlap with any variants in 1KGP.

# Step 5: Ensure VCF files are consistent with reference VCF chr formatting and liftover to hg38 if needed.
# For VCFs from PS12, 3, and PC4:

# Recode as a PLINK format VCF:
plink --vcf <VCF> --recode vcf --double-id --out <out_vcf> --keep-allele-order

# Liftover to hg38 using CrossMap if needed, VNTR genotypes were formatted for hg38 (adjust file paths as needed):
crossmap vcf ../hg19ToHg38.over.chain.gz 5.plink.vcf ../hg38.fa.gz 5.hg38.vcf

# Note: GTEx v8 data is already in hg38, so liftover is not required.

# Step 6: Perform imputation with Beagle5.4
# Replace $BEAGLE_JAR with the path to your Beagle jar file, $SLURM_CPUS_PER_TASK with the number of threads, and adjust file paths as needed.
java -jar $BEAGLE_JAR nthreads=$SLURM_CPUS_PER_TASK gt=P12/5.vcf.gz ref=EUR_ref/chr5_6Mb_SNPs_only_with_VNTRs_sorted_phased.vcf impute=true map=beagle_maps/plink.chr5.GRCh38.map out=chr5_P12_imputed


