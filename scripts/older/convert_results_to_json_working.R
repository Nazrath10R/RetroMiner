

library("jsonlite")

# json_copy <- fromJSON("/Users/nazrathnawaz/Dropbox/test2.json")

json_copy <- fromJSON("/Users/nazrathnawaz/Dropbox/test3.json")


table <- read.table("output_table.txt", sep= "")


table$Study <- NA
table$State <- NA

# restructure to put Tissue after Sample
table <- table[c("Dataset","Study","Disease", "Tissue", "Sample", "Replicate", "State","ORF1p","ORF2p", "ORF0","ORF1p_variants","ORF2p_variants","HERV_proteins","PTMs")]
head(table)






# split_dataset <- test_df[test_df$Dataset=="PXD000944",]

split_dataset <- table[table$Dataset=="PXD003414",]

meta <- unique(split_dataset[,1:4])
meta$no_of_samples <- max(split_dataset$Sample)





new_json <- NULL

new_json$Dataset <- as.character(meta$Dataset)
new_json$study <- as.character(meta$Study)
new_json$disease <- as.character(meta$Disease)
new_json$no_of_samples <- meta$no_of_samples

json_narrowed <- json_copy$sample[-(meta$no_of_samples+1:200),]

new_json$sample <- data.frame()
new_json$sample <- json_narrowed



# new_json$sample



for(x in 1:new_json$no_of_samples) {

# for(x in 1:10) {
  
  # x=1
  # print(x)
  
  current_sample <- split_dataset[split_dataset$Sample==x,]
  
  current_sample[,1:3] <- NULL
  
  colnames(current_sample)[2] <- "Snumber"
  
  
  new_json$sample[x,]$Snumber <- current_sample$Snumber
  new_json$sample[x,]$replicate <- current_sample$Replicate
  new_json$sample[x,]$phenotype <- current_sample$State
  new_json$sample[x,]$tissue_type <- current_sample$Tissue
  
  
  
  new_json$sample[x,]$ORF1p$confidence <- current_sample$ORF1p
  new_json$sample[x,]$ORF2p$confidence <- current_sample$ORF2p
  
  
  
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
  
  new_json$sample[x,]$phenotype <- "parsed"
  
  
  # print(toJSON(new_json, pretty = TRUE, na='string', auto_unbox = TRUE))
  
}


toJSON(new_json, pretty = TRUE, na='string', auto_unbox = TRUE)




