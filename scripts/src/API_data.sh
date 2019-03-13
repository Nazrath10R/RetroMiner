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

DIR=/data/SBCS-BessantLab/naz/pride_reanalysis
SCRIPTS=$DIR/scripts/src

#------------------------------------------------------------#
#         Downloads spectral data for Project PXD            #
#------------------------------------------------------------#

PXD=$1

# -p for pride curated files
# -r for raw files

#------------------------------------------------------------#

# change for User
cd $DIR/inputs

# creates folder for data to be downloaded into
if [ ! -d "$PXD" ]; then
  mkdir $PXD
fi

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
wget -O files.json https://www.ebi.ac.uk:443/pride/ws/archive/file/list/project/$PXD  --no-check-certificate 2> json.out
## extract mgf links using json processor


if [[ ( $2 == "--raw") ||  $2 == "-r" ]] 
then
	echo
	echo "Downloading raw files"
	echo
	jq '.list[] | select(.downloadLink | contains(".raw") ) | .downloadLink ' files.json > links.sh
	jq '.list[] | select(.downloadLink | contains(".RAW") ) | .downloadLink ' files.json >> links.sh
	echo
else
	echo
	echo "Downloading spectral files"
	echo
	jq '.list[] | select(.downloadLink | contains(".mgf") ) | .downloadLink ' files.json > links.sh
	jq '.list[] | select(.downloadLink | contains(".MGF") ) | .downloadLink ' files.json >> links.sh
	echo
fi


if [[ ( $2 == "--tab") ||  $2 == "-t" ]] 
then
	jq '.list[] | select(.downloadLink | contains(".mztab") ) | .downloadLink ' files.json > links.sh
fi


# sed -i -e 's/"//g' links.sh 		# remove quotation marks
sed -i -e 's/^/wget /' links.sh 	# insert wget command
sed -i -e 's/#/%23/' links.sh   # replace hash with percentage 23

echo
echo "Starting file download..."
echo
echo

# sh links.sh 2> download.out

# calculate number of download links
number_of_links=$(wc -l < links.sh)

## run download links
# loading bar (number of links divide by 10)
# sh $SCRIPTS/loading.sh $number_of_links & sh links.sh &> download.out & wait $!
sh links.sh &> download.out & wait $!

echo
echo

# remove unnecessary files
rm json.out
rm download.out
rm *.mzid 2> /dev/null
# rm *.RAW 2> /dev/null
rm links.sh
rm files.json
# rm *.mgf
gunzip *.gz

if (( `ls -1 | wc -l` == $number_of_links ))
  then
  echo
  echo "Retrieving Data via API from PRIDE successful"
  echo
  echo "All spectral files downloaded"  
  Rscript $SCRIPTS/log.R --PXD "$PXD" --IN "downloaded"
  echo
  else 
  echo
  echo -en "\033[31m"
  echo "ERROR: not all files downloaded"
  echo -en "\033[0m"
  echo
fi


if [[ ( $2 == "--pride") ||  $2 == "-p" ]] 
then
	echo
	echo "using duplicate pride files"
	echo
else 
	rm *pride*
fi


#                  ~ end of script ~                  #
