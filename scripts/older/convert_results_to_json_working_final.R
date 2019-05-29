#!/usr/bin/Rsript

####################################################################
##   converting RetroMiner's parsed output_table to jSON format   ##
####################################################################

#   This script is to restructure the result parser output         #
#   to suit an example jSON format used to populate a MongoDb      #
#                 ~~ work in progress                              #

########################################################################

rm(list=ls())

#### Libraries #### 
library("jsonlite")   # read / write jSON files in R


#### working directory #### 
setwd("/Users/nazrathnawaz/Dropbox/PhD/retroelement_expression_atlas/data/results/")


#### Input #### 

# load example jSON - CHANGE PATH
json_copy <- fromJSON("./example.json")

# read in RetroMiner output
table <- read.table("./output_table3.txt", sep= "")

# add fields for manual description
table$Study <- NA
table$State <- NA

# restructure table to put Tissue after Sample
table <- table[c("Dataset","Study","Disease", "Tissue", "Sample", "Replicate", "State","ORF1p","ORF2p", "ORF0","ORF1p_variants","ORF2p_variants","HERV_proteins","PTMs")]
# head(table)


## Saved RData table for quicker loading
# save(table, file="table.RData")
# load(file="table.RData")


########################################################################

#### Functions to read and write jSON files #### 

write.json <- function(x, file = "", ...) {
  x.json <- toJSON(x, pretty = TRUE, na='string', auto_unbox = TRUE)
  write(x.json, file=file)
}


print.json <- function(x) {
  x.json <- toJSON(x, pretty = TRUE, na='string', auto_unbox = TRUE)
  print(x.json)
}


########################################################################




########  Conversion function  ######## 

## List of datasets to convert
pxd_list <- as.character(unique(table$Dataset))


# for(y in 1:length(pxd_list)) {


output_to_json_conversion <- function(y) {

  # y=2
  # pxd <- "PXD000944"
  
  pxd <- pxd_list[y]
    
  
  current_dataset <- table[table$Dataset==pxd_list[y],]
    
  
  # extract metadata for dataset
  meta <- unique(current_dataset[,1:4])
  
  meta$no_of_samples <- unique(max(current_dataset$Sample))   # number of samples
  
  
  # meta$no_of_samples <- unique(meta$no_of_samples) 
  
  
  #### set up jSON file to complete ####
  
  new_json <- NULL
  
  new_json$Dataset <- as.character(meta$Dataset[1])
  new_json$study <- as.character(meta$Study[1])
  new_json$disease <- as.character(paste(meta$Disease, collapse = ", "))
  new_json$no_of_samples <- meta$no_of_samples[1]
  
  
  # R doesnt like adding new arrays to jSON. 
  # Dumb solution of using a massive jSON and deleting fields to suit the given number of samples
  
  json_narrowed <- json_copy$sample[-(meta$no_of_samples[1]+1:200),]
  
  # set up internal dataframe based on example files
  new_json$sample <- data.frame()
  new_json$sample <- json_narrowed
  
  
  
  
  ## Loop for the number of samples
  for(x in 1:new_json$no_of_samples) {
    
    # for(x in 1:10) {
    
    # x=1
    # print(x)
    
    # data for sample x
    current_sample <- current_dataset[current_dataset$Sample==x,]
    
    # remove metadata
    current_sample[,1:3] <- NULL
    
    # changes Sample to Snumber
    colnames(current_sample)[2] <- "Snumber"
    
    
    if(nrow(current_sample)>1) {current_sample <- current_sample[1,]}
    
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
      new_json$sample[x,]$ORF1p_variants$confidence <- list(as.numeric(confidences))
    }
    
    if(current_sample$ORF2p_variants!=0){
      z <- unlist(strsplit(as.character(current_sample$ORF2p_variants), split="_\\(|\\),|\\)"))
      names <- z[seq(1,(length(z)),2)]
      confidences <- z[seq(2,(length(z)),2)]
      new_json$sample[x,]$ORF2p_variants$name <- list(names)
      new_json$sample[x,]$ORF2p_variants$confidence <- list(as.numeric(confidences))
    }
    
    # using spare field to check loop iterations
    new_json$sample[x,]$phenotype <- "parsed"
    
    # print(toJSON(new_json, pretty = TRUE, na='string', auto_unbox = TRUE))
    
  }
  
  
  
  ## print jSON
  # toJSON(new_json, pretty = TRUE, na='string', auto_unbox = TRUE)
  # print.json(new_json)
  
  
  ## write jSON out
  write.json(new_json, paste(pxd, ".jSON", sep = ""))

}



#### Run for all datasets ####

for(z in 1:length(pxd_list)) {
  
  output_to_json_conversion(z)
  
}




