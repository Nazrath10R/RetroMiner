#!/usr/bin/Rsript

setwd("/data/SBCS-BessantLab/naz/pride_reanalysis/results/final/")

input_files <-  list.files(path = ".", pattern = "*_parsed.txt")

# example <- input_files[1]

# example_table <- read.table(example, sep="\t", header=TRUE)
# second_table <- read.table(input_files[2], sep="\t", header=TRUE)

# rbind(example_table, second_table)

# create empty table
table <- matrix(NA, 1, 12)
table <- as.data.frame(table)

colnames(table) <- c("Dataset","Disease","Tissue","Sample","Replicate","ORF1p","ORF2p","ORF0","ORF1p_variants","ORF2p_variants","HERV_proteins","PTMs")


for(i in 1:length(input_files)) {
  tab <- read.table(input_files[i], sep="\t", header=TRUE)
  table <- rbind(table, tab)
}

table <- table[-1,]

write.table(table, "output_table3.txt", sep="\t")

print("Output table re-generated")
