#!/bin/bash 

#============================================================#
# sh API_project_mzid.sh PXD003406
#============================================================#

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
# grep -E -o "(ftp:\/)\/[a-z.\/A-Z0-9._]+.mgf" $PXD > links.sh
# grep -E -o "(ftp:\/)\/[a-z.\/A-Z0-9._]+.mgf.gz" $PXD >> links.sh

grep -E -o "(ftp:\/)\/[a-z.\/A-Z0-9._]+.mzid" $PXD > links.sh
grep -E -o "(ftp:\/)\/[a-z.\/A-Z0-9._]+.mzid.gz" $PXD >> links.sh

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
# cat links.sh
echo
echo

echo
echo
echo "Start downloading files:"
echo
echo
# download all mgf files
sed -n -e '1,4p' links.sh > links2.sh
# sh links.sh
sh links2.sh
echo
echo
echo "All files downloaded"

# remove unnecessary files
rm $PXD
rm links.sh
rm links2.sh
rm links2.sh-e


#### extract parameters
Rscript mzid_parameters.R

# add accession number
sed -ie 's/^"[0-9]"/'$PXD'/' parameters.txt

cat parameters.txt >> final_table.txt

# head test.parameters.txt

# remove mzid files
rm *.mzid
rm *.mzid.gz
rm parameters.txt




