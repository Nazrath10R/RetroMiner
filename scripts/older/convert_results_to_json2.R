
library("jsonlite")
library(rlist)

# change for Apocrita

DIR <- "/Users/nazrathawaz/bessantlab/naz/pride_reanalysis/results/final/"

setwd(DIR)

table <- read.table(paste(DIR, "output_table.txt", sep = ""))
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
list1 <- list(sample_1[,5:14])[[1]]


sample_2 <- test_df_subset[test_df_subset$Sample==2,]
list2 <- list(sample_2[,5:14])[[1]]


####

json2 <- fromJSON("/Users/nazrathnawaz/Dropbox/test2.json")

json_copy <- json2


# 
# json_copy$Dataset <- meta$Dataset
# json_copy$study <- as.character(meta$Study)
# json_copy$disease <- as.character(meta$Disease)
# 
# 
# sample_1[,5:13]
# json_copy$sample[1,]
# 
# 
# # sample_number <- 1
# 
# json_copy$sample[1,]$Snumber <- sample_1$Sample
# json_copy$sample[1,]$replicate <- sample_1$Replicate
# json_copy$sample[1,]$State <- sample_1$phenotype
# json_copy$sample[1,]$tissue_type <- meta$Tissue
# 
# 
# json_copy$sample[1,]$ORF1p$confidence <- sample_1$ORF1p
# json_copy$sample[1,]$ORF2p$confidence <- sample_1$ORF2p
# json_copy$sample[1,]$ORF0$confidence <- sample_1$ORF0
# 
# 
# json_copy$sample[1,]$ORF1p_variants$confidence <- as.character(sample_1$ORF1p_variants)
# json_copy$sample[1,]$ORF2p_variants$confidence <- as.character(sample_1$ORF2p_variants)
# 
# 
# json_copy$sample[1,]$HERV$confidence <- as.character(sample_1$HERV_proteins)
# 
# 
# 
# 
# 
# json_copy$sample[1,]$ORF1p_variants
# 
# 
# 
# str(json_copy$sample[1,])

# json_copy$sample[1,]$new_variant <- 


# json_copy$sample[1,]$ORF1p_variants
# 
# 
# str(json_copy$sample[1,]$new_variant)
# 
# 
# 
# str(json_copy$sample[1,])



# temp <- json_copy$sample[1,]
# 
# 
# str(temp)
# 
# temp$new <- temp$ORF1p_variants
# 
# temp
# 
# 
# str(json_copy)
# 
# 
# new_json$Dataset <- json_copy$Dataset
# new_json$study <- json_copy$study
# new_json$disease <- json_copy$disease
# new_json$sample <- temp
# str(new_json)
# 
# 





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

new_json$sample <- json_copy$sample[1,]

new_json$sample[1,] <- sample_1


new_json$sample[1,]$Snumber <- sample_1$Sample
new_json$sample[1,]$replicate <- sample_1$Replicate
new_json$sample[1,]$phenotype <- sample_1$State
new_json$sample[1,]$tissue_type <- sample_1$Tissue

new_json$sample[1,]$ORF1p$confidence <- sample_1$ORF1p
new_json$sample[1,]$ORF2p$confidence <- sample_1$ORF2p


new_json$sample[1,]$ORF2p_variants$confidence <- as.character(sample_1$ORF2p_variants)
new_json$sample[1,]$new_variant <- NULL
new_json$sample[1,]$new_variant <- "NULL"




z <- new_json$sample[1,]

z$new_variant <- NULL

z$new_variant <- json_copy$sample[1,]$ORF1p_variants

z[,1:10] <- NULL

str(z)



new_json$sample[1,] <- z

new_thing <- cbind(new_json$sample[1,], z)



str(new_thing)





str(json_copy)

fresh_json <- list()
fresh_json$Dataset <- new_json$Dataset
fresh_json$study <- new_json$study
fresh_json$disease <- new_json$disease

fresh_json$sample <- new_thing










toJSON(fresh_json, pretty = TRUE, auto_unbox = TRUE)






str(new_json$sample)



# new_json$sample[1,]$Snumber <- sample_1$Sample



# json_copy$sample[1,]$replicate <- sample_1$Replicate
# json_copy$sample[1,]$State <- sample_1$phenotype
# json_copy$sample[1,]$tissue_type <- meta$Tissue
# 
# 
# json_copy$sample[1,]$ORF1p$confidence <- sample_1$ORF1p
# json_copy$sample[1,]$ORF2p$confidence <- sample_1$ORF2p
# json_copy$sample[1,]$ORF0$confidence <- sample_1$ORF0

# json_copy$sample[1,]$HERV$confidence <- as.character(sample_1$HERV_proteins)





str(json_copy$sample[1,]$ORF1p_variants)


toJSON(new_json, pretty = TRUE, na='string', auto_unbox=TRUE)

toJSON(json_copy, pretty = TRUE, na='string', auto_unbox=TRUE)





x <- new_json$sample$ORF2p_variants$confidence


unlist(strsplit(x, split="_\\(|\\),|\\)"))






















