#!/bin/bash

#############################################################
####                  PRIDE DATA API                     ####
#############################################################

#                                                            #
#            Download Spectral Data via PRIDE API            #
#                                                            #

#============================================================#
# sh API_data.sh PXDxxxxxx
# sh API_data.sh PXD003417
#============================================================#

DIR=/data/SBCS-BessantLab/naz

#------------------------------------------------------------#
#         Downloads spectral data for Project PXD            #
#------------------------------------------------------------#

PXD=$1

#------------------------------------------------------------#

# change for User
cd $DIR/pride_reanalysis/inputs

# creates folder for data to be downloaded into
mkdir $PXD
cd $PXD
echo
echo "Folder for download created"
echo

#### Search PRIDE datasets for project of interest ####

# Find Projects matching PXD
echo
echo "Fetching Data from PRIDE through RESTful API"
echo
echo
echo "Project: $PXD"
echo

## File API
wget -O files.json https://www.ebi.ac.uk:443/pride/ws/archive/file/list/project/$PXD 2> json.out
## extract mgf links using json processor
jq '.list[] | select(.downloadLink | contains(".mgf") ) | .downloadLink ' files.json > links.sh
jq '.list[] | select(.downloadLink | contains(".MGF") ) | .downloadLink ' files.json >> links.sh
# sed -i -e 's/"//g' links.sh 		# remove quotation marks
sed -i -e 's/^/wget /' links.sh 	# insert wget command

echo
echo "Starting file download..."
echo
echo

# sh links.sh 2> download.out

# calculate number of download links
number_of_links=$(wc -l < links.sh)

## run download links
# loading bar (number of links divide by 10)
sh ../../loading.sh $number_of_links & sh links.sh &> download.out & wait $!

echo
echo

# remove unnecessary files
rm json.out
rm download.out
rm *.mzid 2> /dev/null
rm *.RAW 2> /dev/null
rm links.sh
rm files.json
# rm *.mgf
gunzip *.gz

echo "Retrieving Data via API from PRIDE successful"
echo
echo "All spectral files downloaded"
echo

#                  ~ end of script ~                  #
