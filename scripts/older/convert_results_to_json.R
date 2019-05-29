
####### script to convert parsed output table to jSON format to populate Mongodb #######

library("jsonlite")
library(rlist)

# change for Apocrita

DIR <- "/Users/nazrathnawaz/bessantlab/naz/pride_reanalysis/results/final/"

setwd(DIR)

table <- read.table(paste(DIR, "output_table.txt", sep = ""))
table$Study <- NA
table$State <- NA

# restructure to put Tissue after Sample
table <- table[c("Dataset","Study","Disease", "Tissue", "Sample", "Replicate", "State","ORF1p","ORF2p", "ORF0","ORF1p_variants","ORF2p_variants","HERV_proteins","PTMs")]
head(table)


# test_df <- data.frame(matrix(seq(1,50,1), 5,10))
# colnames(test_df) <- c("Dataset","Disease", "Tissue", "Sample", "Replicate", "ORF1p", "ORF2p", "ORF0", "ORF1p_variants","ORF2p_variants")
# test_df$ORF0 <- NA
# toJSON(test_df, pretty = TRUE, na='string')


#  
# toJSON(test_df, pretty = TRUE, na='string')
# 
# 


# structure
# mylist <- list(Dataset="PXD000944", Disease="breast_cancer_or_breast_cancer_cell_line", Tissue="NA",
#                Sample=list(
#                  "1"= list( 
#                    Replicate=1, ORF1p=0,
#                    ORF2p=0, ORF0=0, 
#                    ORF1p_variants=0, 
#                    ORF2p_variants="ORF2p_PA2_17_(64.436),ORF2p_HS_112_(18.315),ORF2p_HS_111_(6.821),ORF2p_PA2_14_(6.517)", 
#                    HERV_proteins="0",
#                    PTMs="NA"
#                   ),
#                  "2"= list( 
#                    Replicate=1, ORF1p=0,
#                    ORF2p=0, ORF0=0, 
#                    ORF1p_variants=0, 
#                    ORF2p_variants="abc", 
#                    HERV_proteins="0",
#                    PTMs="NA"
#                  )
#                 )
#               )
# 
# 
# json <- toJSON(mylist, pretty = TRUE, na='string', auto_unbox=TRUE)
# 
# json
# 
# validate(json)





# toJSON(list1, pretty = TRUE, na='string', auto_unbox=TRUE)

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
# new_list <- list(meta,
#                  Sample=
#                    list(
#                     list1,
#                     list2)
#                 )
#                  
# 
# 
# x <- toJSON(new_list, pretty = TRUE, na='string', auto_unbox=TRUE)
# 
# write_json(x, pretty=TRUE, path=paste(DIR,"naz_json.jSON", sep="/"))
# 
# 
# 



## best attempt

# new_list <- c(meta,
#                  Sample=list(
#                      list1,
#                      list2)
# )
# 
# 
# 
# toJSON(new_list, pretty = TRUE, na='string', auto_unbox=TRUE, flatten=TRUE)
# 
# 
# 

##########################################################################################

# import the example json itself and the manipulate to make it fit

##########################################################################################


json <- fromJSON("/Users/nazrathnawaz/Dropbox/test.json")

str(json)
str(json$sample)


# toJSON(json, pretty = TRUE, na='string', auto_unbox=TRUE)

json_copy <- json

# meta
# sample_1
# sample_2


json_copy$Dataset <- meta$Dataset
json_copy$study <- as.character(meta$Study)
json_copy$disease <- as.character(meta$Disease)


sample_1[,5:13]
json_copy$sample[1,]


# sample_number <- 1

json_copy$sample[1,]$Snumber <- sample_1$Sample
json_copy$sample[1,]$replicate <- sample_1$Replicate
json_copy$sample[1,]$State <- sample_1$phenotype
json_copy$sample[1,]$tissue_type <- meta$Tissue


json_copy$sample[1,]$ORF1p <- sample_1$ORF1p
json_copy$sample[1,]$ORF2p <- sample_1$ORF2p
json_copy$sample[1,]$ORF0 <- sample_1$ORF0


json_copy$sample[1,]$ORF1p_variants <- as.character(sample_1$ORF1p_variants)
json_copy$sample[1,]$ORF2p_variants <- as.character(sample_1$ORF2p_variants)


json_copy$sample[1,]$HERV <- as.character(sample_1$HERV_proteins)


  
  

toJSON(json_copy, pretty = TRUE, na='string', auto_unbox=TRUE)





##########################################################################################





json2 <- fromJSON("/Users/nazrathnawaz/Dropbox/test2.json")


toJSON(json2, pretty = TRUE, na='string', auto_unbox=TRUE)


str(json2)

json2$sample[1,]$ORF1p$confidence




json_copy <- json2

# meta
# sample_1
# sample_2


json_copy$Dataset <- meta$Dataset
json_copy$study <- as.character(meta$Study)
json_copy$disease <- as.character(meta$Disease)


sample_1[,5:13]
json_copy$sample[1,]


# sample_number <- 1

json_copy$sample[1,]$Snumber <- sample_1$Sample
json_copy$sample[1,]$replicate <- sample_1$Replicate
json_copy$sample[1,]$State <- sample_1$phenotype
json_copy$sample[1,]$tissue_type <- meta$Tissue


json_copy$sample[1,]$ORF1p$confidence <- sample_1$ORF1p
json_copy$sample[1,]$ORF2p$confidence <- sample_1$ORF2p
json_copy$sample[1,]$ORF0$confidence <- sample_1$ORF0


json_copy$sample[1,]$ORF1p_variants$confidence <- as.character(sample_1$ORF1p_variants)
json_copy$sample[1,]$ORF2p_variants$confidence <- as.character(sample_1$ORF2p_variants)


json_copy$sample[1,]$HERV$confidence <- as.character(sample_1$HERV_proteins)





json_copy$sample[1,]$ORF1p_variants



str(json_copy$sample[1,])

# json_copy$sample[1,]$new_variant <- 


json_copy$sample[1,]$ORF1p_variants


str(json_copy$sample[1,]$new_variant)



str(json_copy$sample[1,])



temp <- json_copy$sample[1,]


str(temp)

temp$new <- temp$ORF1p_variants

temp


str(json_copy)


new_json$Dataset <- json_copy$Dataset
new_json$study <- json_copy$study
new_json$disease <- json_copy$disease
new_json$sample <- temp
str(new_json)












str(json_copy$sample[1,]$ORF1p_variants)


toJSON(json_copy, pretty = TRUE, na='string', auto_unbox=TRUE)






















