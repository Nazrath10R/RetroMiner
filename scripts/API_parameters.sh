#!/bin/bash

#############################################################
####              PRIDE PARAMETERS API                   ####
#############################################################

#                                                            #
#   Extracting Search Engine parameters for PRIDE datasets   #
#                                                            #

#============================================================#
# sh API_parameters.sh PXD003271
#============================================================#

DIR=/data/SBCS-BessantLab/naz

PXD=$1

#------------------------------------------------------------#

cd $DIR/pride_reanalysis/inputs
mkdir $PXD
cd $PXD


#######################################################
####                    PRIDE API                  ####
#######################################################

#### Search PRIDE datasets for project of interest ####

# Find Projects matching PXD
echo
echo "Fetching Data from PRIDE through RESTful API"
echo
echo "Project: $PXD"
echo
echo

## File API
wget -O files.json https://www.ebi.ac.uk:443/pride/ws/archive/file/list/project/$PXD 2> files.out

# ## extract mzid links using json processor
# jq '.list[] | select(.downloadLink | contains(".mzid") ) | .downloadLink ' $PXD > links.sh
jq '.list[] | select(.downloadLink | contains(".mzid") ) | .downloadLink ' files.json > links.sh


## Project API
wget -O metadata.json https://www.ebi.ac.uk:443/pride/ws/archive/project/$PXD 2> metadata.out

Pub_date=$(jq '.submissionDate' metadata.json | sed 's/ /_/g')
Sample_Protocol=$(jq '.sampleProcessingProtocol' metadata.json | sed 's/ /_/g')
Data_Protocol=$(jq '.dataProcessingProtocol' metadata.json | sed 's/ /_/g')
Experiment_type=$(jq '.experimentTypes[]' metadata.json | sed 's/ /_/g')
Quantification_Method=$(jq '.quantificationMethods[]' metadata.json | sed 's/ /_/g')

if [ ${#Sample_Protocol} > 20 ]; then
	Sample_Protocol="too_long"
fi

if [ ${#Data_Protocol} > 20 ]; then
	Data_Protocol="too_long"
fi


## Assay API

wget -O assay.json https://www.ebi.ac.uk:443/pride/ws/archive/assay/list/project/$PXD 2> assay.out

# jq '.list[0].diseases[]' assay.json
# jq '.list[0].species[]' assay.json
# jq '.list[0].ptmNames[]' assay.json
# jq '.list[0].experimentalFactor' assay.json
# jq '.list[0].softwares' assay.json

Diseases=$(jq '.list[0].diseases[]' assay.json | sed 's/ /_/g')
Species=$(jq '.list[0].species[]' assay.json | sed 's/ /_/g')
PTM=$(jq '.list[0].ptmNames[]' assay.json | paste -s -d, -)
Experimental_factor=$(jq '.list[0].experimentalFactor' assay.json | sed 's/ /_/g')
Softwares=$(jq '.list[0].softwares' assay.json | sed 's/ /_/g')

# sed -i -e 's/"//g' links.sh 		# remove quotation marks
sed -i -e 's/^/wget /' links.sh 	# insert wget command

echo
echo "Project metadata download successful"
echo
echo "Downloading files..."

# extract first 4 download links
sed -n -e '1,4p' links.sh > links2.sh
# sh links.sh
sh links2.sh &> download.out & wait $!
echo
echo
rm *.mgf 2> /dev/null
rm *.MGF 2> /dev/null
gunzip *.gz 2> /dev/null
echo "all files downloaded"
echo

#### extract parameters
echo
echo "Starting R parameter parsing"
echo
echo
# module load R/3.3.1_with_lib
module load R/3.3.2
Rscript $DIR/pride_reanalysis/pride_parameters/mzid_parameters_v2.R
echo
echo
echo "parameter parsed"

# add accession number
echo
echo
sed -ie 's/^"[0-9]"/'$PXD'/' parameters.txt
sed -ie 's/NA/'$Pub_date'/' parameters.txt
sed -ie 's/NA/'$Sample_Protocol'/' parameters.txt
sed -ie 's/NA/'$Data_Protocol'/' parameters.txt
sed -ie 's/NA/'$Experiment_type'/' parameters.txt
sed -ie 's/NA/'$Quantification_Method'/' parameters.txt
sed -ie 's/NA/'$Diseases'/' parameters.txt
sed -ie 's/NA/'$Species'/' parameters.txt
sed -ie 's/NA/'$PTM'/' parameters.txt
sed -ie 's/NA/'$Experimental_factor'/' parameters.txt
sed -ie 's/NA/'$Softwares'/' parameters.txt

mv parameters.txt $PXD.parameters.txt

echo
echo
# cat parameters.txt >> final_table.txt

echo
echo

# remove unnecessary files
rm 20
rm files.json 2> /dev/null
rm files.out
rm metadata.out
rm assay.out
rm download.out
rm assay.json
rm files.json
rm metadata.json
rm links.sh 2> /dev/null
rm links2.sh 2> /dev/null
rm links2.sh-e 2> /dev/null
rm *.mzid
rm *.gz 2> /dev/null
# rm *.mgf 2> /dev/null
# rm parameters.txt
rm parameters.txte 2> /dev/null


#                  ~ end of script ~                  #

