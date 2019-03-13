
log_table <- read.table("/data/SBCS-BessantLab/naz/pride_reanalysis/images/reanalysis_log.txt",
 												sep = "\t", header = TRUE)


# downloaded parametered exp_designed retromined

counter <- length(which(log_table$downloaded=="y" &
      									log_table$parametered=="y" &
      									log_table$exp_designed=="y" &
      									log_table$retromined=="y"))


cat(counter,"\n")

