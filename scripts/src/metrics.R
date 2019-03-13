

log_table <- read.table("/data/SBCS-BessantLab/naz/pride_reanalysis/images/reanalysis_log.txt",
 												sep = "\t", header = TRUE)


# downloaded parametered exp_designed retromined

counter <- length(which(log_table$downloaded=="y" &
      									log_table$parametered=="y" &
      									log_table$exp_designed=="y" &
      									log_table$retromined=="y"))


cat(counter,"\n")


##

head(log_table)

pxd_list <- log_table[which(log_table$retromined=="y"),]$pxd



table <- read.table("/data/SBCS-BessantLab/naz/pride_reanalysis/parameters/experimental_design.txt")



total_samples <- 0
total_replicates <- 0
total_files <- 0


for(x in 1:length(pxd_list)) {
	
	total_samples <- total_samples +
	max(table[which(table$Accession_number == as.character(pxd_list[x])),]$Sample)

	total_replicates <- total_replicates + 
	length(which(table[which(table$Accession_number == as.character(pxd_list[x])),]$Replicate != 1))

	total_files <- total_files +
	nrow(table[which(table$Accession_number == as.character(pxd_list[x])),])

}

total_samples
total_replicates
total_files



input_size <- read.table("/data/SBCS-BessantLab/naz/pride_reanalysis/images/input_sizes.txt")
sum(input_size$V1)/1024

output_size <- read.table("/data/SBCS-BessantLab/naz/pride_reanalysis/images/output_sizes.txt")
sum(output_size$V1)/1024
































