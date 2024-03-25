args <- commandArgs(trailingOnly=TRUE)

suppressMessages(library(tidyverse))

tags <- read_delim('../Tags.txt',delim = "\t",col_names = F)%>% pull(X1)
totaltags <- length(tags)
## here, totaltags = 243936 lines (library size)

for (i in args){
  
  data1 <- read_delim(paste0(i, '.tsv'), delim = "\t",col_names = T,na = c("","NA"))
  
## data sorting
data1 <- data1 %>% filter(!(pattern %in% tags))
## this is to filter the data1 (currently a random mix) based on the pattern that are matching those in tags

#tibble(undetected_tag=tags[!(tags %in% data1$pattern)])
## this is to locate the tag sequences that were not found in data1 sequencing file

data1 <- data1 %>% count(pattern,strand)
## this is to organize data1 based on the count of each pattern by strand (now three columns: pattern, strand, n)
## most of the pattern should be detected in minus strand in Illumina read 1 by design

data1 <- bind_rows(data1, data1 %>% group_by(pattern) %>% summarise(n=sum(n)) %>% ungroup() %>% mutate(strand="+/-")) %>% arrange(pattern,strand) %>% rename(Tag=pattern,Depth=n)
## this is to summarize the stats from the filtering and sortinng above
## now you can type data1, and you will see the columns are renamed (Tag; strand; Depth), 
## and -, +, & +/- strands (sum of - and + strand matches) are listed next to each other

#data1 %>% arrange(desc(Depth)) %>% print(n=50)
## now this will sort the data1 file by Depth in descending order and show the top 50 on the bottom panel
## this gives you some idea of the read counts for the most frequent mRNA tags


## stats tables
result1 <- data1 %>% group_by(strand) %>% summarise(Mean=mean(Depth),Median=median(Depth),TagNum=n_distinct(Tag), TotalCount=sum(Depth)) %>% mutate(Percentage=100*TagNum/totaltags) %>% mutate(Set="Depth_1")
## now this will display a summary table showing stats by three strand groups for their mean & median Depth
## TagNum shows the number of distinct tags in each group
## Percentage shows % of originally designed tags that were detected in the mRNA in this transfection and sequencing

result2 <- data1 %>% filter(Depth>5) %>% group_by(strand) %>% summarise(Mean=mean(Depth),Median=median(Depth),TagNum=n_distinct(Tag), TotalCount=sum(Depth)) %>% mutate(Percentage=100*TagNum/totaltags) %>% mutate(Set="Depth_5")
## this will display the same stats when considering only those tags with Depth > 5

##Subsetting for minus strand only to calculate TPM
minStrand <- subset(data1, strand=="-")
minStrand$TotalCount <- sum(minStrand$Depth)
## this is a preparation for the step calculating TPM
##TZ multiplied by 1000000 (dividing each tag count by (the total number of sequence-matching tag counts divided by a million))
minStrand$TPM <- 1000000*minStrand$Depth/minStrand$TotalCount

write_tsv(minStrand, paste0(i, '_TPM_minStrand.txt'))
#saving TPM results for minus strand


result3 <- minStrand %>% group_by(strand) %>% summarise(Mean=mean(TPM),Median=median(TPM),TagNum=n_distinct(Tag), TotalCount=sum(Depth)) %>% mutate(Percentage=100*TagNum/totaltags)%>% mutate(Set="TPM_Depth_1")
## this is showing the minus strand stats with TPM instead of Depth

result4 <- rbind(result1,result2,result3)
result4$source <- i

#write_tsv(result4, paste0(i,"_TPM.txt"))

## to plot on biowulf; open another biowulf window to check the results pdf files without exiting R
pdf(paste(i, ".pdf", sep=""))
minStrand %>% ggplot(aes(log2(Depth)))+geom_histogram(bins = 100, col="white")+facet_wrap(~strand,ncol=1,scales="free")+xlab("log2(Read_Count)")+ylab("Number of Tags")
dev.off()

if (exists("final_result") == F){
  
  final_result <- result4

} else {
  
  final_result <- rbind(final_result, result4)
  
}

}

write_tsv(final_result, "SC_TPM_all.txt")

