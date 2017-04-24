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

	echo
	echo "Project metadata download successful"
	echo
	echo
	echo
	echo "Number of files in $PXD"
	wc -l links.sh
	echo
	echo
	echo "file download links"
	# display links
	# cat links.sh
	echo
	echo

	echo
	echo
	echo "Start downloading files:"
	echo
	echo
	
	# extract first 4 download links
	sed -n -e '1,4p' links.sh > links2.sh
	# sh links.sh
	sh links2.sh
	echo
	echo
	rm *.mgf
	rm *.MGF
	echo "All files downloaded"

	#### extract parameters
	echo
	echo
	echo "Starting R parameter parsing"
	echo
	echo
	module load R/3.3.1_with_lib
	echo
	echo
	Rscript mzid_parameters.R
	echo
	echo
	echo "parameter parsed"

	# add accession number
	echo
	echo
	sed -ie 's/^"[0-9]"/'$PXD'/' parameters.txt
	echo
	echo
	cat parameters.txt >> final_table.txt
	# cat parameters.txt >> krisi_projects_table.txt
	echo
	echo

	# head test.parameters.txt

	# remove unnecessary files
	rm $PXD
	rm links.sh
	rm links2.sh
	rm links2.sh-e
	rm *.mzid
	rm *.gz
	rm *.mgf
	rm parameters.txt
	rm parameters.txte

# done <krisi_projects.txt
done <Q9UN81.txt



