#!/bin/bash 

#------------------------------------------------------------#
#                        	CLI                              #
#------------------------------------------------------------#

## use PXD id
# sh full_project_API.sh PXD001694 /Users/nazrathnawaz/apocrita/pride_reanalysis/inputs


#------------------------------------------------------------#
#                        Variables                           #
#------------------------------------------------------------#

#### Command Line Arguments ####

PXD=$1
OUTPUT_FOLDER=$2


#######################################################
####                    PRIDE API                  ####
#######################################################

#### Search PRIDE datasets for project of interest ####

mkdir $OUTPUT_FOLDER/$PXD
cd $OUTPUT_FOLDER/$PXD

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
grep -E -o "(ftp:\/)\/[a-z.\/A-Z0-9._]+.mgf" $PXD > links.sh
grep -E -o "(ftp:\/)\/[a-z.\/A-Z0-9._]+.mgf.gz" $PXD >> links.sh

# insert wget command
sed -i -e 's/^/wget /' links.sh

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
cat links.sh
echo
echo

echo
echo
echo "Start downloading files:"
echo
echo
# download all mgf files
sh links.sh
echo
echo
echo "All files downloaded"

# remove unnecessary files
# echo "removing temp files..."
rm $PXD
rm links.sh
rm links-e.sh



