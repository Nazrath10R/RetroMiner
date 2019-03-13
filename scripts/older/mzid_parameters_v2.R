#!/usr/bin/Rscript

####################################################################
##   extracting parameters from mzid files and storing in table   ##
####################################################################

#                                                            #
#   Extracting Search Engine parameters for PRIDE datasets   #
#                                                            #

########################################################################

## Package Bioconductor "mzID"
# source("https://bioconducstor.org/biocLite.R")
# source("http://bioconductor.org/biocLite.R")
# biocLite("mzID")

library("mzID")

########################################################################

mzid_files <- list.files(pattern = '*.mzid', full.names = TRUE)

# mzResult <- mzID(mzid_files[1]) # Check first file.

# showClass("mzID")
# parameters(mzResult)
# names(parameters(mzResult))

########################################################################

## Pride Metdata table
df <- matrix(NA,length(mzid_files),21)
# colnames(df) <- c("Acession_number", "Pub_year", "Disease", "Tissue_type", "Protocol","file", "fixed_modifications", "variable_modifications", "enzyme", "threshold_name", "threshold", "parent_tolerance", "parent_tolerance_unit","fragment_tolerance", "fragment_tolerance_unit")

colnames(df) <- c("Acession_number", "Pub_date", "Sample_Protocol", "Data_Protocol", "Experiment_type", "Quantification_Method", "Diseases", "Species", "PTM", "Experimental_factor", "Softwares", "file", "fixed_modifications", "variable_modifications", "enzyme", "threshold_name", "threshold", "parent_tolerance", "parent_tolerance_unit", "fragment_tolerance", "fragment_tolerance_unit")

df <- as.data.frame(df)
new.df <- NULL

########################################################################

# extracting_PRIDE_parameters <- function(directory) {

# 	setwd(directory)

	mzid_files <- list.files(pattern = '*.mzid', full.names = TRUE)

	for(mzid in 1:length(mzid_files)) {

		# load mzid files
		mzResult <- mzID(mzid_files[mzid])

		# extract parameters
		file <-	mzid_files[mzid]
		enzymes <- parameters(mzResult)$enzymes
		fragment_tolerance <- parameters(mzResult)$FragmentTolerance
		parent_tolerance <- parameters(mzResult)$ParentTolerance
		protocol <- parameters(mzResult)$searchType


		### fill df table
		df$file[mzid] <- file

		## enzyme
		if(nrow(parameters(mzResult)$enzymes) != 0) { df$enzyme[mzid] <- enzymes }

		## fragment_tolerance and parent_tolerance

		if(fragment_tolerance$value[1]==fragment_tolerance$value[2]) {
			df$fragment_tolerance[mzid] <- fragment_tolerance$value[1]
		}

		if(fragment_tolerance$unitName[1]==fragment_tolerance$unitName[2]) {
			df$fragment_tolerance_unit[mzid] <- fragment_tolerance$unitName[1]
		}

		if(parent_tolerance$value[1]==parent_tolerance$value[2]) {
			df$parent_tolerance[mzid] <- parent_tolerance$value[1]
		}

		if(parent_tolerance$unitName[1]==parent_tolerance$unitName[2]) {
			df$parent_tolerance_unit[mzid] <- parent_tolerance$unitName[1]
		}


		## protocol
		df$Protocol[mzid] <- protocol

		## FDR

		if(is.null(parameters(mzResult)$threshold$value)==FALSE) {
			df$threshold[mzid] <- parameters(mzResult)$threshold$value[grep("[0-9]", parameters(mzResult)$threshold$value)]
			}

		if(is.null(parameters(mzResult)$threshold$name)==FALSE) {
		df$threshold_name[mzid] <- parameters(mzResult)$threshold$name[1]
		}


		## fixed and variable modifications
		modifications <- parameters(mzResult)$ModificationRules

		fixed_modifications <- NULL
		variable_modifications <- NULL

		# loop through all modifications
		for(x in 1:nrow(modifications)) {

			# fixed
			if(modifications$fixedMod[x]==TRUE) {

				if(modifications[x,]$Specificity=="any") {
					mod_name <-	paste(modifications[x,]$name, " of ", modifications[x,]$residues)
				} else {
					mod_name <-	paste(modifications[x,]$name, " on ", modifications[x,]$Specificity)
				}

				fixed_modifications <- append(fixed_modifications,mod_name)

				}

			# variable
			if(modifications$fixedMod[x]==FALSE) {

				if(modifications[x,]$Specificity=="any") {
					mod_name <-	paste(modifications[x,]$name, " of ", modifications[x,]$residues)
				} else {
					mod_name <-	paste(modifications[x,]$name, " on ", modifications[x,]$Specificity)
				}

				variable_modifications <- append(variable_modifications, mod_name)

			}
		}

		fixed_modifications <- paste(fixed_modifications, collapse=", ")
		variable_modifications <- paste(variable_modifications, collapse=", ")

		df$fixed_modifications[mzid] <- fixed_modifications
		df$variable_modifications[mzid] <- variable_modifications

	}

	duplicates <- length(which(duplicated(df[,13:21])==TRUE))

	new.df <- unique(df[,13:21])
	new.df <- new.df[rowSums(is.na(new.df)) != ncol(new.df),]
	new.df[rowSums(is.na(new.df)) != ncol(new.df),]
	pride_metadata <- matrix(NA, 1, 20)
	pride_metadata <- as.data.frame(pride_metadata)
	pride_metadata[,1:11] <- df[,1:11]
	pride_metadata[,13:21] <- new.df[,1:9]
	colnames(pride_metadata) <- c("Acession_number", "Pub_date", "Sample_Protocol", "Data_Protocol", "Experiment_type", "Quantification_Method", "Diseases", "Species", "PTM", "Experimental_factor", "Softwares", "fixed_modifications", "variable_modifications", "enzyme", "threshold_name", "threshold", "parent_tolerance", "parent_tolerance_unit", "fragment_tolerance", "fragment_tolerance_unit")

	pride_metadata$enzyme <- unlist(pride_metadata$enzyme)

	# print(pride_metadata)
	write.table(pride_metadata, file="parameters.txt", col.names=FALSE,sep="\t", append=TRUE)

# }

#                  ~ end of script ~                  #

###########

# extracting_PRIDE_parameters("/Users/nazrathnawaz/Dropbox/PhD/PRIDE")


#######################################################

# for Protein identification comparison
# mzResult

# flatResults <- flatten(mzResult)
# names(flatResults)
# nrow(flatResults)

# length(mzResult)

# which(flatResults$accession == "Q9UN81")

#######################################################

