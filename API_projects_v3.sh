#!/bin/bash 

#============================================================#
# sh API_projects_v3.sh PXD003271
#============================================================#

#------------------------------------------------------------#
#                        Variables                           #
#------------------------------------------------------------#


cd /data/home/btx157/pride_reanalysis/inputs

PXD=$1
mkdir $PXD
cd $PXD

PXD=PXD003271

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

## File API
wget -O files.json https://www.ebi.ac.uk:443/pride/ws/archive/file/list/project/$PXD             

# ## extract mzid links using json processor                  
# jq '.list[] | select(.downloadLink | contains(".mzid") ) | .downloadLink ' $PXD > links.sh

## extract mgf links using json processor                  
jq '.list[] | select(.downloadLink | contains(".mgf") ) | .downloadLink ' files.json > links.sh



## Project API
wget -O metadata.json https://www.ebi.ac.uk:443/pride/ws/archive/project/$PXD

jq '.submissionDate' metadata.json
jq '.sampleProcessingProtocol' metadata.json
jq '.dataProcessingProtocol' metadata.json
jq '.experimentTypes' metadata.json
jq '.quantificationMethods' metadata.json

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

wget -O assay.json https://www.ebi.ac.uk:443/pride/ws/archive/assay/list/project/$PXD

jq '.list[0].diseases[]' assay.json
jq '.list[0].species[]' assay.json
jq '.list[0].ptmNames[]' assay.json
jq '.list[0].experimentalFactor' assay.json
jq '.list[0].softwares' assay.json

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
echo "Number of files in $PXD"
# wc -l links.sh
echo
echo
echo "file download links"
# display links
# cat links.sh
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
# rm *.mgf
# rm *.MGF
gunzip *.gz
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
Rscript /data/home/btx157/pride_reanalysis/pride_parameters/mzid_parameters_v2.R
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
# cat parameters.txt >> krisi_table.txt

# cat $PXD.parameters.txt >> /data/home/btx157/pride_reanalysis/pride_parameters/krisi_table.txt

echo
echo

# remove unnecessary files
rm $PXD
rm links.sh
rm links2.sh
rm links2.sh-e
rm *.mzid
rm *.gz
# rm *.mgf
# rm parameters.txt
rm parameters.txte

# done <Q9UN81.txt


# tmux new-session -d -s 12
# tmux send-keys 'sh API_projects_v2.sh' C-m
# tmux detach -s 12

# while read p; do

# 	cd /data/home/btx157/pride_reanalysis/pride_parameters/outputs
# 	PXD=$p
# 	cd $PXD

# 	cat $PXD.parameters.txt >> /data/home/btx157/pride_reanalysis/pride_parameters/krisi_table.txt

# done < /data/home/btx157/pride_reanalysis/pride_parameters/krisi_projects.txt





