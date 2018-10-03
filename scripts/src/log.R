#!/usr/bin/Rscript

####################################################################
##         keeping log of RetroMiners' mining statuses            ##
####################################################################

#                                                            #
#                   update the log file                      #
#                                                            #

########################################################################

dir <- "/data/SBCS-BessantLab/naz/pride_reanalysis"

##########################################################################

suppressMessages(library("argparser"))    # Argument passing

parser <- arg_parser("This parser contains the input arguments")

parser <- add_argument(parser, "--PXD",
                       help = "PRIDE Accession number")

parser <- add_argument(parser, "--IN",
                       help = "input")

argv   <- parse_args(parser)

PXD <- argv$PXD
IN  <- argv$IN

##########################################################################

#### add PXD

# PXD <- "BLA"

log_table <- read.table(paste(dir, "/reanalysis_log.txt", sep = ""), header = TRUE, row.names = NULL, sep= "\t")


# add new PXD row
if(PXD %in% log_table$pxd == FALSE) {
  empty_array <- rep(NA, ncol(log_table))
  log_table <- rbind(log_table, empty_array)
  log_table <- as.data.frame(log_table)
  log_table$pxd <- as.character(log_table$pxd)
  log_table[nrow(log_table),]$pxd <- PXD
}


##########################################################################

# downloaded
# parametered
# exp_design
# retromined
# converted
# populated

if(IN=="downloaded") { log_table[log_table$pxd==PXD,]$downloaded <- "y" }
if(IN=="parametered") { log_table[log_table$pxd==PXD,]$parametered <- "y" }
if(IN=="exp_designed") { log_table[log_table$pxd==PXD,]$exp_design <- "y" }
if(IN=="retromined") { log_table[log_table$pxd==PXD,]$retromined <- "y" }
if(IN=="converted") { log_table[log_table$pxd==PXD,]$converted <- "y" }
if(IN=="populated") { log_table[log_table$pxd==PXD,]$populated <- "y" }

print(log_table)

write.table(log_table, paste(dir, "/reanalysis_log.txt", sep = ""), header = TRUE, row.names = NULL, sep= "\t")









