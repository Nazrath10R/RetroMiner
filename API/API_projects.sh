#!/bin/bash 

#============================================================#
# sh API_projects.sh
#============================================================#

#------------------------------------------------------------#
#                        Variables                           #
#------------------------------------------------------------#

#### Command Line Arguments ####

while read p; do
  # echo $p
	PXD=$p
	# PXD=PXD005733
	# OUTPUT_FOLDER=$2

	#######################################################
	####                    PRIDE API                  ####
	#######################################################

	#### Search PRIDE datasets for project of interest ####

	# mkdir $OUTPUT_FOLDER/$PXD
	# cd $OUTPUT_FOLDER/$PXD

	# Find Projects matching PXD
	echo
	echo "Fetching Data from PRIDE through RESTful API"
	echo
	echo
	echo "Project:"
	echo "$PXD"
	echo
	echo
	wget https://www.ebi.ac.uk:443/pride/ws/archive/file/list/project/$PXD
	echo
	echo

	# extract download links
	# grep -E -o "(ftp:\/)\/[a-z.\/A-Z0-9._]+.mgf" $PXD > links.sh
	# grep -E -o "(ftp:\/)\/[a-z.\/A-Z0-9._]+.mgf.gz" $PXD >> links.sh


	# grep -E -o "(ftp:\/)\/[a-z.\/A-Z0-9\.\_\(\)\- ]+(\.mzid\.gz\")" $PXD > links.sh

	# # pretty print json file
	# jq '.' PXD005733 

	# # to iterate over the list array            
	# jq '.list[]' PXD005733

	# # to get the downloadLink from each element in list[]                        
	# jq '.list[] | .downloadLink' PXD005733                       

	## extract mzid links using jason processor                  
	jq '.list[] | select(.downloadLink | contains("mzid") ) | .downloadLink ' $PXD > links.sh

	# sed -i -e 's/"//g' links.sh 		# remove quotation marks
	sed -i -e 's/^/wget /' links.sh 	# insert wget command

