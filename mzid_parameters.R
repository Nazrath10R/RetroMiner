
####################################################################
##   extracting parameters from mzid files and storing in table   ##
####################################################################

# source("https://bioconductor.org/biocLite.R")
# biocLite("mzID")

library("mzID")

mzid_files <- list.files(pattern = '*.mzid', full.names = TRUE)

# mzResult <- mzID(mzid_files[1]) # Check first file.
# showClass("mzID")
# parameters(mzResult)
# names(parameters(mzResult))

## Pride Metdata table
pride_metdadata <- matrix(NA,length(mzid_files),15)
colnames(pride_metdadata) <- c("acession_number", "publication_date", "disease", "tissue_type", "protocol", "assays", "fixed_modifications", "variable_modifications", "enzyme", "threshold_name", "threshold", "parent_tolerance", "parent_tolerance_unit","fragment_tolerance", "fragment_tolerance_unit")
pride_metdadata <- as.data.frame(pride_metdadata)


########################################################################

for(mzid in 1:length(mzid_files)) {

	# load mzid files
	mzResult <- mzID(mzid_files[mzid])

	# extract parameters
	enzymes <- parameters(mzResult)$enzymes 
	fragment_tolerance <- parameters(mzResult)$FragmentTolerance
	parent_tolerance <- parameters(mzResult)$ParentTolerance
	protocol <- parameters(mzResult)$searchType


	### fill pride_metdadata table

	## enzyme
	if(nrow(parameters(mzResult)$enzymes) != 0) { pride_metdadata$enzyme[mzid] <- enzymes }

	## fragment_tolerance and parent_tolerance

	if(fragment_tolerance$value[1]==fragment_tolerance$value[2]) {
		pride_metdadata$fragment_tolerance[mzid] <- fragment_tolerance$value[1]
	}

	if(fragment_tolerance$unitName[1]==fragment_tolerance$unitName[2]) {
		pride_metdadata$fragment_tolerance_unit[mzid] <- fragment_tolerance$unitName[1]
	}

	if(parent_tolerance$value[1]==parent_tolerance$value[2]) {
		pride_metdadata$parent_tolerance[mzid] <- parent_tolerance$value[1]
	}

	if(parent_tolerance$unitName[1]==parent_tolerance$unitName[2]) {
		pride_metdadata$parent_tolerance_unit[mzid] <- parent_tolerance$unitName[1]
	}


	## protocol
	pride_metdadata$protocol[mzid] <- protocol

	## FDR
	pride_metdadata$threshold[mzid] <- parameters(mzResult)$threshold$value
	pride_metdadata$threshold_name[mzid] <- parameters(mzResult)$threshold$name


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
	variable_modifications <- paste(variable_modifications, collapse=", ")ß

	pride_metdadata$fixed_modifications[mzid] <- fixed_modifications
	pride_metdadata$variable_modifications[mzid] <- variable_modifications


}

print(pride_metdadata)



















