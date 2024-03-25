# Script was a kind gift of Karen Funderburk

#!/bin/sh 

set -e 

fastq=$1
tag=$2
prefix=$3

mkdir -p $prefix

cd $prefix

cat ../$tag | awk 'BEGIN{m=1;}{print ">Tag"m; print $0;m++;}' > Tag.fasta

seqkit split -p 1000 Tag.fasta; 

ls Tag.fasta.split/* | awk -v fastq=$fastq '{key=$1;gsub(".*part","part",key);gsub("\\..*","",key); print "zcat ../"fastq" | seqkit locate -i -j 4 -f "$1,">"key".tsv"}' > cmdfile 

swarm -f cmdfile -g 2 -t 4 --job-name seqkit_$prefix --logdir logs --time 40:00:00

