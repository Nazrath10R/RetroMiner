#!/usr/bin/Rsript

####################################################################
##   converting RetroMiner's parsed output_table to jSON format   ##
####################################################################

#   This script is to restructure the result parser output         #
#   to suit an example jSON format used to populate a MongoDb      #
#                 ~~ work in progress                              #

########################################################################

#### Libraries #### 
library("jsonlite")   # read / write jSON files in R

#### Input #### 

# load example jSON - CHANGE PATH
json_copy <- fromJSON("/Users/nazrathnawaz/Dropbox/test3.json")

# read in RetroMiner output
table <- read.table("output_table.txt", sep= "")

# add fields for manual description
table$Study <- NA
table$State <- NA

# restructure table to put Tissue after Sample
table <- table[c("Dataset","Study","Disease", "Tissue", "Sample", "Replicate", "State","ORF1p","ORF2p", "ORF0","ORF1p_variants","ORF2p_variants","HERV_proteins","PTMs")]
# head(table)

########################################################################


#### example dataset #### 

split_dataset <- table[table$Dataset=="PXD003414",]

# extract metadata for dataset
meta <- unique(split_dataset[,1:4])
meta$no_of_samples <- max(split_dataset$Sample)   # number of samples



#### set up jSON file to complete ####

new_json <- NULL

new_json$Dataset <- as.character(meta$Dataset)
new_json$study <- as.character(meta$Study)
new_json$disease <- as.character(meta$Disease)
new_json$no_of_samples <- meta$no_of_samples


# R doesnt like adding new arrays to jSON. 
# Dumb solution of using a massive jSON and deleting fields to suit the given number of samples

json_narrowed <- json_copy$sample[-(meta$no_of_samples+1:200),]

# set up internal dataframe based on example files
new_json$sample <- data.frame()
new_json$sample <- json_narrowed




## Loop for the number of samples
for(x in 1:new_json$no_of_samples) {

# for(x in 1:10) {
  
  # x=1
  # print(x)
  
  # data for sample x
  current_sample <- split_dataset[split_dataset$Sample==x,]
  
  # remove metadata
  current_sample[,1:3] <- NULL
  
  # changes Sample to Snumber
  colnames(current_sample)[2] <- "Snumber"
  
  # fill in information from current sample to jSON 
  new_json$sample[x,]$Snumber <- current_sample$Snumber
  new_json$sample[x,]$replicate <- current_sample$Replicate
  new_json$sample[x,]$phenotype <- current_sample$State
  new_json$sample[x,]$tissue_type <- current_sample$Tissue    # moved inside now
  
  # LINE-1 consensus proteins
  new_json$sample[x,]$ORF1p$confidence <- current_sample$ORF1p
  new_json$sample[x,]$ORF2p$confidence <- current_sample$ORF2p
  
  
  ## Given Sample can express several variants

  # if Variants are present, add as a list - change this! 
  if(current_sample$ORF1p_variants!=0){
    y <- unlist(strsplit(as.character(current_sample$ORF1p_variants), split="_\\(|\\),|\\)"))
    names <- y[seq(1,(length(y)),2)]
    confidences <- y[seq(2,(length(y)),2)]
    new_json$sample[x,]$ORF1p_variants$name <- list(names)
    new_json$sample[x,]$ORF1p_variants$confidence <- list(confidences)
  }
  
  if(current_sample$ORF2p_variants!=0){
    z <- unlist(strsplit(as.character(current_sample$ORF2p_variants), split="_\\(|\\),|\\)"))
    names <- z[seq(1,(length(z)),2)]
    confidences <- z[seq(2,(length(z)),2)]
    new_json$sample[x,]$ORF2p_variants$name <- list(names)
    new_json$sample[x,]$ORF2p_variants$confidence <- list(confidences)
  }
  
  # using spare field to check loop iterations
  new_json$sample[x,]$phenotype <- "parsed"
  
  # print(toJSON(new_json, pretty = TRUE, na='string', auto_unbox = TRUE))
  
}

# print jSON
toJSON(new_json, pretty = TRUE, na='string', auto_unbox = TRUE)




