#!/usr/bin/Rscript

####################################################################
#                                                                  #
#                   add experimental design                        #
#                                                                  #
####################################################################

retrominer_path <- list.files(path = "..", pattern = "retrominer_path.txt", 
                   recursive=TRUE, full.names=TRUE, 
                   include.dirs=TRUE)

dir <- paste(readLines(retrominer_path), collapse=" ")

####################################################################

suppressMessages(library("argparser"))    # Argument passing

parser <- arg_parser("This parser contains the input arguments")

parser <- add_argument(parser, "--PXD",
                       help = "PRIDE Accession number")

argv   <- parse_args(parser)


PXD <- argv$PXD
# PXD <- "PXD006114" 

####################################################################

input_dir <- paste(dir, "inputs", PXD, sep = "/")

# mgf files under PXD input directory
files <- list.files(input_dir, pattern = ".mgf|.MGF")
input_spectral_files <- files[!grepl("cui", files)]

if(length(input_spectral_files)==0) {
	print("")
	print("no spectral files downloaded")
	print("")
	break
}

# experimental table
exp_design_table <- read.table(paste(dir, 
                                     "parameters/experimental_design.txt", 
                                     sep = "/"))

exp_design_table$Sample <- as.factor(exp_design_table$Sample)

# using the last line
exp_design_template <- tail(exp_design_table, 1)

# get numbers for new row numbers
start_num   <- as.numeric(rownames(exp_design_template)) + 1
no_of_files <- 	length(input_spectral_files)

# create new dataset exp design
new_dataset <- matrix(NA, no_of_files, ncol(exp_design_template))
new_dataset <- as.data.frame(new_dataset)
colnames(new_dataset) <- colnames(exp_design_template)

# add information
new_dataset$Accession_number <- rep(PXD, no_of_files)
new_dataset$Description      <- rep("to_fill", no_of_files)
new_dataset$File             <- input_spectral_files
new_dataset$Sample           <- seq(1, no_of_files, 1)
new_dataset$Replicate        <- rep(1, no_of_files)

# continue rownumber
rownames(new_dataset) <- seq(start_num, start_num + no_of_files - 1, 1)

# update table
updated_exp_design_table <-	rbind(exp_design_table, new_dataset)
# updated_exp_design_table$Sample <- as.character()

## write appended experimental design out
write.table(updated_exp_design_table, 
            paste(dir, "parameters/experimental_design.txt", 
                  sep = "/"))
