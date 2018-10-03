#!/usr/bin/Rsript

## Create final result table ##
# combine experimental design and filtered reports

# rm(list=ls())

setwd("/data/SBCS-BessantLab/naz/pride_reanalysis/results/")

# argument
# PXD <- "PXD002212"
# Samples <- 3

# PXD <- "PXD003407"
# Samples <- 26

# PXD <- "PXD004626"
PXD <- "PXD001694"


# experimental design table
table <- read.table("/data/SBCS-BessantLab/naz/pride_reanalysis/parameters/experimental_design.txt")

if (! PXD %in% table$Accession_number) {
  print("PXD does not exist")
  quit("no")
}

pxd_subset <- table[table$Accession_number==PXD,]

Samples <- length(unique(pxd_subset$Sample)) # number of samples


################################################################################################


##### create final result table and write it out
# could just append to an existing one

pxd_subset <- table[table$Accession_number==PXD,]

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


################################################################################################

## check if file is empty
empty_file_check <- function(input_file) {

  # could put into a functions
  info = file.info(input_file)
  empty = rownames(info[info$size == 0, ])

  return(length(empty))

}

################################################################################################

# # nested loop
replicate=1


for(sample in 1:Samples) {

  print(sample)
  # # sample=1

  path <- paste("/data/SBCS-BessantLab/naz/pride_reanalysis/results", 
                PXD, PXD, sep="/")
  file_1 <- paste(path, sample, replicate, 
                  "custom_protein_report_LINE_filtered.txt", sep = "_")
  file_2 <- paste(path, sample, replicate, 
                  "custom_protein_report_HERV_filtered.txt", sep = "_")


  ## if results file is empty
  if(empty_file_check(file_1)!=0) { 
    # print(paste("check", 1))
    # set all identifications to 0
    result_table[result_table$Sample==sample,][,6:10] <- 0

  ## if results file has no identifications
  }  else if(empty_file_check(file_1)==0) {
    # print(paste("check", 2))

    # read LINE-1 results
    result <- read.table(file_1, sep="\t")

    # set all identifications to 0
    if(sum(result$V31)==0) { 
    # print(paste("check", 3))

      for(i in 6:10) {
      result_table[result_table$Sample==sample,][,i] <- rep(0, length(result_table[result_table$Sample==sample,][,i]))
      }


  ## else we have results

    } else {
    # print(paste("check", 4))

    # filter very low values?
    # filtered_result <- result[which(result$V31 > 5),]

    filtered_result <- result[which(result$V31 > 0),]    
    row.names(filtered_result) <- seq(1,nrow(filtered_result))

    # consensus protein results
    cons_proteins <- c("Q9UN81", "O00370", "Q9UN82")

    for(i in 1:length(cons_proteins)) {
    
        if(length(which(filtered_result$V2 == cons_proteins[i]))!=0) { 
        result_table[result_table$Sample==sample,][5+i] <- max(filtered_result[which(filtered_result$V2 == cons_proteins[i]),]$V31)
      } else {  
        # result_table[result_table$Sample==sample,][5+i] <- 0  
       
##############
        result_table[i,5+i] <- 0
        }

    }


    ## filter for variants 

      # are there consensus proteins?
      if(length(intersect(filtered_result$V2, cons_proteins))!=0) {
      # print(paste("check", 5))

      # remove consensus proteins
      variant_filtered_result <- filtered_result[-which(filtered_result$V2==intersect(filtered_result$V2, cons_proteins)),]
      
        # case of there's no variants after removing consensus
        if(nrow(variant_filtered_result)==0) {
          result_table[result_table$Sample==sample,]$ORF1p_variants <- 0
          result_table[result_table$Sample==sample,]$ORF2p_variants <- 0
          # print(paste("check", 5.5))

        } else if(nrow(variant_filtered_result)!=0) {
            # print(paste("check", 6))

            list <- strsplit(as.character(variant_filtered_result$V2), split="_")
            ranks <- order(variant_filtered_result$V31, decreasing=TRUE)

            v_array <- NA

            for(x in 1:length(ranks)) {
              compound <- paste(list[[ranks[x]]][5], list[[ranks[x]]][3], list[[ranks[x]]][4], sep = "_")
              v_array[x] <- paste(compound, "_(",round(variant_filtered_result$V31[ranks[x]], 3), ")", sep = "")
            }

            # seperate variants
            ORF1p_variants <- v_array[grep("ORF1p", v_array)]
            ORF2p_variants <- v_array[grep("ORF2p", v_array)]

            if(length(ORF1p_variants) == 0) {ORF1p_variants <- 0}
            if(length(ORF2p_variants) == 0) {ORF2p_variants <- 0}


            # result_table[result_table$Sample==sample,]$ORF1p_variants <- list(ORF1p_variants)
            # result_table[result_table$Sample==sample,]$ORF2p_variants <- list(ORF2p_variants)

            result_table[result_table$Sample==sample,]$ORF1p_variants <- paste(ORF1p_variants, collapse = ",")
            result_table[result_table$Sample==sample,]$ORF2p_variants <- paste(ORF2p_variants, collapse = ",")

        }
        # end new

      # no consensus proteins - everything is a variant
      } else if(length(intersect(filtered_result$V2, cons_proteins))==0) {     
          # print(paste("check", 7))
          variant_filtered_result <- filtered_result
        # }


          list <- strsplit(as.character(variant_filtered_result$V2), split="_")
          ranks <- order(variant_filtered_result$V31, decreasing=TRUE)

          v_array <- NA

          for(x in 1:length(ranks)) {

            compound <- paste(list[[ranks[x]]][5], list[[ranks[x]]][3], list[[ranks[x]]][4], sep = "_")
            v_array[x] <- paste(compound, "_(",round(variant_filtered_result$V31[ranks[x]], 3), ")", sep = "")

          }

          # seperate variants
          ORF1p_variants <- v_array[grep("ORF1p", v_array)]
          ORF2p_variants <- v_array[grep("ORF2p", v_array)]

          if(length(ORF1p_variants) == 0) {ORF1p_variants <- 0}
          if(length(ORF2p_variants) == 0) {ORF2p_variants <- 0}


          # result_table[result_table$Sample==sample,]$ORF1p_variants <- list(ORF1p_variants)
          # result_table[result_table$Sample==sample,]$ORF2p_variants <- list(ORF2p_variants)

          result_table[result_table$Sample==sample,]$ORF1p_variants <- paste(ORF1p_variants, collapse = ",")
          result_table[result_table$Sample==sample,]$ORF2p_variants <- paste(ORF2p_variants, collapse = ",")
        }

      }

    }

  # }


  #### HERV #### 

  # could move this to later after LINE is done

  if(empty_file_check(file_2)!=0) { 

    result_table[result_table$Sample==sample,]$HERV_proteins <- 0

  } else if(empty_file_check(file_2)==0) {

    result_2 <- read.table(file_2, sep="\t")

    if(sum(result_2$V31)==0) { 

      result_table[result_table$Sample==sample,]$HERV_proteins <- 
      rep(0, length(result_table[result_table$Sample==sample,]$HERV_proteins))

    } else {

      # herv_filtered <- result_2[which(result_2$V31 > 5),]
      herv_filtered <- result_2[which(result_2$V31 > 0),]

      herv_list <- strsplit(as.character(herv_filtered$V2), split="_")

      herv_ranks <- order(herv_filtered$V31, decreasing=TRUE)

      herv_array <- NA

      for(x in 1:length(herv_ranks)) {

        herv_array[x] <- paste(herv_list[[herv_ranks[x]]],"_(",round(herv_filtered$V31[herv_ranks[x]], 3), ")", sep = "")

      }

      result_table[result_table$Sample==sample,]$HERV_proteins <- list(herv_array)

    }

  }

}




print(result_table)

df = as.matrix(result_table)

filename <- paste("/data/SBCS-BessantLab/naz/pride_reanalysis/results", 
                PXD, "parsed.txt",sep="/")

# write.table(df, filename, sep = "\t", row.names=FALSE, quote=FALSE)
