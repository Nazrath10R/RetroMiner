
## Experimemental design table

df <- matrix(NA, 6,5)

colnames(df) <- c("Accession_number", "Description", "File", "Sample", "Replicate")
df


df[,1] <- "PXD000655"
df[,2] <- c("healthy")
df[,3] <- c("PRIDE_Exp_Complete_Ac_33322.pride.mgf")
df[,4] <- c(1)



df[,5] <- c(1)

# df[,5] <- c(1,2,1,2,1,2)

df <- as.data.frame(df)

write.table(df, file="/data/home/btx157/pride_reanalysis/parameters/experimental_design.txt", 
            col.names=TRUE,sep="\t", append=TRUE)


