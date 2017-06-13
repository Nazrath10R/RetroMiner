
## Experimemental design table

df <- matrix(NA, 6,5)

colnames(df) <- c("Accession_number", "Description", "File", "Sample", "Replicate")
df


df[,1] <- "PXD003417"
df[,2] <- c("healthy", "healthy", "adjacent", "adjacent", "disease", "disease")
df[,3] <- c("NHDF_sn_stim_1a.mgf","NHDF_sn_stim_1b.mgf","NHDF_sn_stim_2a.mgf","NHDF_sn_stim_2b.mgf","NHDF_sn_stim_3a.mgf","NHDF_sn_stim_3b.mgf")
df[,4] <- c(1,1,2,2,3,3)



df[,5] <- c(1,2,1,2,1,2)

df[,5] <- c(1,2,1,2,1,2)

df <- as.data.frame(df)

write.table(df, file="/data/home/btx157/pride_reanalysis/parameters/experimental_design.txt", col.names=TRUE,sep="\t", append=FALSE)


