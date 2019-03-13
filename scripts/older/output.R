
## Create final result table ##
# combine experimental design and filtered reports

# argument
PXD <- "PXD003406"
Samples <- 26


# experimental design table
table <- read.table("/data/SBCS-BessantLab/naz/pride_reanalysis/parameters/experimental_design.txt")

if (! PXD %in% table$Accession_number) {
  print("PXD does not exist")
  quit("no")
}



## Loop
x=3
sample <- (1:Samples)[x]

# nested loop
replicate=1


DIR <- paste("/data/SBCS-BessantLab/naz/pride_reanalysis/results", 
             PXD, sep = "/")

setwd(DIR)


path <- paste("/data/SBCS-BessantLab/naz/pride_reanalysis/reports", 
              PXD, PXD, sep="/")
file_1 <- paste(path, sample, replicate, 
                "custom_protein_report_LINE_filtered.txt", sep = "_")
file_2 <- paste(path, sample, replicate, 
                "custom_protein_report_HERV_filtered.txt", sep = "_")

# could put into a functions
info = file.info(file_1)
empty = rownames(info[info$size == 0, ])

if(length(empty)==0){ result <- read.table(file_1, sep="\t")
} else if(length(empty)!=0) { break }


# could move this to later after LINE is done
info = file.info(file_2)
empty = rownames(info[info$size == 0, ])

if(length(empty)==0){ result_2 <- read.table(file_1, sep="\t")
} else if(length(empty)!=0) { break }



pxd_subset <- table[table$Accession_number==PXD,]


##### create final result table and write it out
# could just append to an existing one
result_table <- matrix(NA, nrow(pxd_subset), 12)

colnames(result_table) <- c("Dataset", "Disease", "Tissue", "Sample", "Replicate", 
                            "ORF1p", "ORF2p", "ORF0", "ORF1p_variants", "ORF2p_variants", 
                            "HERV_proteins", 
                            "PTMs")

# pxd_subset
# result_table
result_table <- as.data.frame(result_table)

result_table$Dataset <- pxd_subset$Accession_number
result_table$Disease <- pxd_subset$Description
# Tissue
result_table$Sample <- pxd_subset$Sample
result_table$Replicate <- pxd_subset$Replicate



#### collating into result_table ####

# change to 90
filtered_result <- result[which(result$V35 > 5),]

# filtered_result[4,]

# remove secondary accessions and protein group
filtered_result$V26 <- NULL
filtered_result$V25 <- NULL


row.names(filtered_result) <- seq(1,nrow(filtered_result))

if(length(which(filtered_result$V2 == "Q9UN81"))!=0) {
  result_table$ORF1p <- max(filtered_result[which(filtered_result$V2 == "Q9UN81"),]$V35)
} else {  result_table$ORF1p <- 0 }



if(length(which(filtered_result$V2 == "O00370"))!=0) {
  result_table$ORF2p <- max(filtered_result[which(filtered_result$V2 == "O00370"),]$V35)
} else {  result_table$ORF2p <- 0 }


list <- strsplit(as.character(filtered_result$V2), split="_")

# orf1p_list <- unlist(list[which(unlist(list)=="ORF1p")/5])

# list[useq(5, length(list),5)]


ranks <- order(filtered_result$V35, decreasing=TRUE)

v_array <- NA

for(x in 1:length(ranks)) {

  compound <- paste(list[[ranks[x]]][5], list[[ranks[x]]][3], list[[ranks[x]]][4], sep = "_")
  v_array[x] <- paste(compound, "_(",round(filtered_result$V35[ranks[x]], 3), ")", sep = "")

}



ORF1p_variants <- v_array[grep("ORF1p", v_array)]
ORF2p_variants <- v_array[grep("ORF2p", v_array)]

result_table$ORF1p_variants <- list(ORF1p_variants)
result_table$ORF2p_variants <- list(ORF2p_variants)


herv_filtered <- result_2[which(result_2$V35 > 5),]


herv_array <- NA

for(x in 1:dim(herv_filtered)[1]) {

  name <- herv_filtered$V2[x]

  herv_array[x] <- paste(name, "_(",round(herv_filtered$V35[x], 3), ")", sep = "")

}

result_table$HERV_proteins <- list(herv_array)



#### write it out


# df = as.matrix(result_table)

# write.table(df, file=paste(PXD, "result_table.txt", sep = "_"), sep="  ")




