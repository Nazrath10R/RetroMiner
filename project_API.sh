#!/bin/bash 

#------------------------------------------------------------#
#                        	CLI                              #
#------------------------------------------------------------#

## use PXD id
# sh API.sh PXD001694


#------------------------------------------------------------#
#                        Variables                           #
#------------------------------------------------------------#

#### Command Line Arguments ####

PXD=$1
# OUTPUT_FOLDER=$2


#######################################################
####                    PRIDE API                  ####
#######################################################

#### Search PRIDE datasets for project of interest ####

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
grep -E -o "(ftp:\/)\/[a-z.\/A-Z0-9._]+.mgf" $PXD > links.txt
grep -E -o "(ftp:\/)\/[a-z.\/A-Z0-9._]+.mgf.gz" $PXD >> links.txt

# sed -i -e 's/mgf","downloadLink":"/wget /g' downloadLink.sh

echo
echo "Download successful"
echo
echo

# display links
cat links.txt

echo
echo

# remove unnecessary files
# echo "removing temp files..."
# rm $PXD
# rm links.txt

# sleep 8



