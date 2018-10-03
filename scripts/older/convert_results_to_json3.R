
library("jsonlite")
library(rlist)

rm(list=ls())

DIR <- "/Users/nazrathawaz/bessantlab/naz/pride_reanalysis/results/final/"


setwd(DIR)

# table <- read.table(paste(DIR, "output_table.txt", sep = ""))

table <- read.table("output_table.txt", sep= "")


table$Study <- NA
table$State <- NA

# restructure to put Tissue after Sample
table <- table[c("Dataset","Study","Disease", "Tissue", "Sample", "Replicate", "State","ORF1p","ORF2p", "ORF0","ORF1p_variants","ORF2p_variants","HERV_proteins","PTMs")]
head(table)




test_df <- table[1:8,]

test_df

test_df$Dataset <- as.character(test_df$Dataset)
test_df$Dataset[5:8] <- "PXD001234"
test_df$Sample[5:8] <- seq(1,4,1)


test_df_subset <- test_df[test_df$Dataset=="PXD000944",]

meta <- unique(test_df_subset[,1:4])
meta$no_of_samples <- max(test_df_subset$Sample)


sample_1 <- test_df_subset[test_df_subset$Sample==1,]
# list1 <- list(sample_1[,5:14])[[1]]


sample_2 <- test_df_subset[test_df_subset$Sample==2,]
# list2 <- list(sample_2[,5:14])[[1]]



json2 <- fromJSON("/Users/nazrathnawaz/Dropbox/test2.json")

json_copy <- json2






sample_1[,1:3] <- NULL
sample_2[,1:3] <- NULL

# colnames(sample_1)[1] <- "Snumber"
# colnames(sample_2)[1] <- "Snumber"
# 
# sample_1$Snumber <- 1
# sample_2$Snumber <- 2

colnames(sample_1)[2] <- "Snumber"
colnames(sample_2)[2] <- "Snumber"


sample_2







new_json <- NULL

new_json$Dataset <- meta$Dataset
new_json$study <- as.character(meta$Study)
new_json$disease <- as.character(meta$Disease)
new_json$no_of_samples <- meta$no_of_samples

new_json$sample <- data.frame()

new_json$sample <- json_copy$sample

new_json$sample[1,]$Snumber <- sample_1$Snumber

new_json$sample[1,]$replicate <- sample_1$Replicate
new_json$sample[1,]$phenotype <- sample_1$State
new_json$sample[1,]$tissue_type <- sample_1$Tissue



new_json$sample[1,]$ORF1p$confidence <- sample_1$ORF1p
new_json$sample[1,]$ORF2p$confidence <- sample_1$ORF2p


# new_json$sample[1,]$ORF1p_variants$confidence <- as.character(sample_1$ORF1p_variants)
# new_json$sample[1,]$ORF2p_variants$confidence <- as.character(sample_1$ORF2p_variants)



if(sample_1$ORF1p_variants!=0){
  y <- unlist(strsplit(as.character(sample_1$ORF1p_variants), split="_\\(|\\),|\\)"))
  names <- y[seq(1,(length(y)),2)]
  confidences <- y[seq(2,(length(y)-1),2)]
  new_json$sample[1,]$ORF1p_variants$name <- list(names)
  new_json$sample[1,]$ORF1p_variants$confidence <- list(confidences)
}


if(sample_1$ORF2p_variants!=0){
  z <- unlist(strsplit(as.character(sample_1$ORF2p_variants), split="_\\(|\\),|\\)"))
  names <- z[seq(1,(length(z)),2)]
  confidences <- z[seq(2,(length(z)-1),2)]
  new_json$sample[1,]$ORF2p_variants$name <- list(names)
  new_json$sample[1,]$ORF2p_variants$confidence <- list(confidences)
}


toJSON(new_json, pretty = TRUE, na='string', auto_unbox = TRUE)







new_json$sample[2,]$Snumber <- sample_2$Snumber

new_json$sample[2,]$replicate <- sample_2$Replicate
new_json$sample[2,]$phenotype <- sample_2$State
new_json$sample[2,]$tissue_type <- sample_2$Tissue



new_json$sample[2,]$ORF1p$confidence <- sample_2$ORF1p
new_json$sample[2,]$ORF2p$confidence <- sample_2$ORF2p



if(sample_2$ORF1p_variants!=0){
  y <- unlist(strsplit(as.character(sample_2$ORF1p_variants), split="_\\(|\\),|\\)"))
  names <- y[seq(1,(length(y)),2)]
  confidences <- y[seq(2,(length(y)-1),2)]
  new_json$sample[2,]$ORF1p_variants$name <- list(names)
  new_json$sample[2,]$ORF1p_variants$confidence <- list(confidences)
}


if(sample_2$ORF2p_variants!=0){
  z <- unlist(strsplit(as.character(sample_2$ORF2p_variants), split="_\\(|\\),|\\)"))
  names <- z[seq(1,(length(z)),2)]
  confidences <- z[seq(2,(length(z)-1),2)]
  new_json$sample[2,]$ORF2p_variants$name <- list(names)
  new_json$sample[2,]$ORF2p_variants$confidence <- list(confidences)
}






toJSON(new_json, pretty = TRUE, na='string', auto_unbox = TRUE)























