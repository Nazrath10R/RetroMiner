

table <- read.table("/data/SBCS-BessantLab/naz/pride_reanalysis/parameters/experimental_design.txt")


# do for both 2

PXD_list <- read.table("/data/SBCS-BessantLab/naz/pride_reanalysis/outputs/output_to_convert.txt")
# PXD_list <- read.table("/data/SBCS-BessantLab/naz/pride_reanalysis/outputs/output_to_convert2.txt")

str(PXD_list)

samples_counter <- 0

for(x in 1:nrow(PXD_list)) {

  PXD <- as.character(PXD_list[x,])

  pxd_subset <- table[table$Accession_number==PXD,]

  samples <- unique(pxd_subset$Sample)

  samples_counter <- samples_counter + length(samples)
  
}






