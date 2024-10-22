
##########################################################################

# Rscript experimental_design_parser.R --PXD "PXD003417"

##########################################################################

# install.packages("argparse")
suppressMessages(library("argparser"))    # Argument passing

##########################################################################

retrominer_path <- list.files(path = "..", pattern = "retrominer_path.txt", 
                   recursive=TRUE, full.names=TRUE, 
                   include.dirs=TRUE)

dir <- paste(readLines(retrominer_path), collapse=" ")

experimental_design_table <- paste(dir, "parameters/experimental_design.txt", sep = "/")


## Experimemental design table parser
table <- read.table(experimental_design_table)

##########################################################################

parser <- arg_parser("This parser contains the input arguments")

parser <- add_argument(parser, "--PXD",
                       help = "PRIDE Accession number")

argv   <- parse_args(parser)

PXD   <- argv$PXD

# PXD="PXD003417"
# PXD=123

## if arg PXD does not exist, exit the script

if (! PXD %in% table$Accession_number) {
  print("PXD does not exist")
  quit("no")
}

## working directory
working_dir <- paste(dir, "/parameters/", paste(PXD, "/", sep=""), sep= "")
dir.create(working_dir)
setwd(working_dir)

##########################################################################

# subset table for PXD
pxd_subset <- table[table$Accession_number==PXD,]

samples <- unique(pxd_subset$Sample) # number of samples

write(as.character(length(samples)), paste(paste(dir, "/inputs/", PXD, sep=""), "/samples.txt", sep=""))

## file name parser
for(x in 1:length(samples)) {

  subset <- pxd_subset[pxd_subset$Sample==x,]

  # no replicates
  if(length(unique(subset$Replicate)) == 1) {

  sample <- as.vector(subset[which(subset$Sample == x),]$File)

  sample_file <- paste(sample, collapse = " ")

  sample_file <- gsub(".mgf|.MGF", "", sample)

  print(sample_file)

  write(sample_file, paste(paste(PXD, x, sep = "_sample_"), "_rep_0", sep=""))

  # replicates
  } else {

    write(TRUE, paste(paste("/data/SBCS-BessantLab/naz/pride_reanalysis/inputs/", PXD, sep=""), "/replicates.txt", sep=""))

    for(y in 1:length(subset$Replicate)) {

    sample_file <- as.vector(subset$File[which(subset$Sample == x & subset$Replicate == y)])
    sample_file <- paste(sample_file, collapse = "  ")
    sample_file <- gsub(".mgf|.MGF", "", sample_file)

    print(sample_file)

    write(sample_file, paste(paste(PXD, x, sep = "_sample_"), y, sep="_rep_"))

    }
  }
}
