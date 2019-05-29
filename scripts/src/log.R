#!/usr/bin/Rscript

####################################################################
##         keeping log of RetroMiners' mining statuses            ##
####################################################################

#                                                                  #
#                      update the log file                         #
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

parser <- add_argument(parser, "--IN",
                       help = "input")

argv   <- parse_args(parser)

PXD <- argv$PXD
IN  <- argv$IN

#####################################################################

## complete previous column
# for(x in 1:nrow(log_table)) {

#   if(log_table$retromined[x]=="y" | log_table$retromined[x]=="c") {
#     log_table[x,2:4] <- rep("y", 3)
#   }
# }

#####################################################################

#### add PXD

# PXD <- "BLA"

log_table <- read.table(paste(dir, "/images/reanalysis_log.txt", sep = ""), 
                        header = TRUE, row.names = NULL, sep= "\t") 

log_table[] <- lapply(log_table, as.character)

# add new PXD row
if(PXD %in% log_table$pxd == FALSE) {
  
  empty_array <- rep(NA, ncol(log_table))
  log_table <- rbind(log_table, empty_array)
  
  log_table <- as.data.frame(log_table)
  log_table$pxd <- as.character(log_table$pxd)
  
  log_table[nrow(log_table),]$pxd <- PXD

}

#####################################################################

if(IN=="converted" & log_table[log_table$pxd==PXD,]$converted=="y") {
  quit(status=1) 
}

#####################################################################

if(IN=="downloaded"  ) { log_table[log_table$pxd==PXD,]$downloaded    <- "y" }
if(IN=="parametered" ) { log_table[log_table$pxd==PXD,]$parametered   <- "y" }
if(IN=="exp_designed") { log_table[log_table$pxd==PXD,]$exp_designed  <- "y" }
if(IN=="retromined"  ) { log_table[log_table$pxd==PXD,]$retromined    <- "y" }
if(IN=="converted"   ) { log_table[log_table$pxd==PXD,]$converted     <- "y" }
if(IN=="populated"   ) { log_table[log_table$pxd==PXD,]$populated     <- "y" }
if(IN=="running"     ) { log_table[log_table$pxd==PXD,]$retromined    <- "r" }

#####################################################################

## print status
cat("\n")
print(
      log_table[log_table$pxd==PXD,][,1:7]
      )
cat("\n")

## running


## overwrite table
write.table(log_table, paste(dir, "/images/reanalysis_log.txt", sep = ""), sep= "\t", row.names = FALSE)

