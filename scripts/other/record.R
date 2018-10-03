#!/usr/bin/Rsript

## script to update log table about the state of PRIDE re-analysis

setwd("~/bessantlab/naz/pride_reanalysis")

reanalysis_log_table <- read.table("reanalysis_log.txt", sep="\t", header=TRUE)
reanalysis_log_table <- data.frame(lapply(reanalysis_log_table, as.character), stringsAsFactors=FALSE)

reanalysis_log_table[reanalysis_log_table$pxd=="PXD003410_old",]$pxd <- "PXD003410"


reports <- list.dirs(path="./reports", recursive = FALSE)
reports <- unlist(strsplit(reports, split = "./reports/"))
reports <- reports[seq(2,length(reports),2)]


outputs <- list.dirs(path="./outputs", recursive = FALSE)
outputs <- unlist(strsplit(outputs, split = "./outputs/"))
outputs <- outputs[seq(2,length(outputs),2)]

setdiff(outputs, reports)

# get a list of pxds 
# loop through them


new_dataset <- "PXD009445"

new_line <- c(new_dataset, "n", "n","n", "n","n", NA, "")


reanalysis_log_table <- rbind(reanalysis_log_table, new_line)


t <- reanalysis_log_table$pxd

sort(t)

n <- unlist(strsplit(t, split = "PXD"))
n <- as.numeric(n[seq(2,length(n),2)])

























