# Guide to Running CRISPR SURF Deconvolution
# This guide explains how to deconvolve sgRNA summary data using CRISPR SURF, focusing on a specific example.

# Step 1: Pre-requisites
# Ensure you have Singularity installed on your system. CRISPR SURF is run within a Singularity container, allowing for consistent execution environments across different computing platforms.

# Step 2: Load Singularity Module
# If you're working on a system that uses environment modules, load Singularity as follows:

module load singularity

# For systems without environment modules, ensure Singularity is installed and available in your PATH.

# Step 3: Set Singularity Environment (Optional)
# The script includes sourcing a Singularity configuration file. This step is specific to certain setups and may involve custom bind paths for Singularity containers.

. /usr/local/current/singularity/app_conf/sing_binds

# Adjust this step based on your system's configuration or omit it if not needed.

# Step 4: Run CRISPR SURF Deconvolution
# Execute the CRISPR SURF deconvolution command within a Singularity container by running the following command:

singularity run docker://pinellolab/crisprsurf SURF_deconvolution -f sgRNAs_summary_table.csv -genome hg38 -out_dir PANC1_virus_VS_T2 -pert crispri

# Here:
# - `docker://pinellolab/crisprsurf` specifies the Docker image to be used by Singularity.
# - `SURF_deconvolution` is the CRISPR SURF command for deconvolution analysis.
# - `-f sgRNAs_summary_table.csv` points to the input file, which should be a CSV containing the sgRNA summary table.
# - `-genome hg38` indicates the genome assembly used for analysis (e.g., hg38).
# - `-out_dir PANC1_virus_VS_T2` sets the output directory where results will be saved.
# - `-pert crispri` specifies the perturbation type, which can be either "crispra" (activation) or "crispri" (interference).

# Step 5: Review the Output
# After running the command, the output directory (specified by `-out_dir`) will contain the results of the CRISPR SURF deconvolution. This includes detailed information on the deconvolved sgRNA effects and potentially additional analyses performed by CRISPR SURF.

# Note: This guide is based on the provided script and assumes familiarity with command-line interfaces and Singularity containers. Adjust the script according to your specific setup and analysis needs.
