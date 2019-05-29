
retrominer_path <- list.files(path = "..", pattern = "retrominer_path.txt", 
                   recursive=TRUE, full.names=TRUE, 
                   include.dirs=TRUE)

dir <- paste(readLines(retrominer_path), collapse=" ")

reanalysis_log_table <- paste(dir, "images/reanalysis_log.txt", sep = "/")

log_table <- read.table(reanalysis_log_table,
 												sep = "\t", header = TRUE)


# downloaded parametered exp_designed retromined

counter <- length(which(log_table$downloaded=="y" &
      									log_table$parametered=="y" &
      									log_table$exp_designed=="y" &
      									log_table$retromined=="y"))


cat(counter,"\n")

