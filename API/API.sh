#!/bin/bash

#============================================================#
# sh API.sh "Q9UN81"
#============================================================#

#------------------------------------------------------------#
#                        Variables                           #
#------------------------------------------------------------#

#### Command Line Arguments ####

PROTEIN=$1
# PXD=$2
# INPUT_FILE=$3
# PARAMETERS=$4
# EXPERIMENT=$5
# SAMPLE=$6
# ANALYSIS=$7
# REPLICATE=$8
# OUTPUT_FOLDER=$9
# THREADS=${10}


#######################################################
####                    PRIDE API                  ####
#######################################################

#### Search PRIDE datasets for protein of interest ####

# Find Projects matching Protein of Interest

echo
echo "Fetching Data from PRIDE through RESTful API"
echo
echo "Retrieving all Projects containing Protein: $PROTEIN"
echo

## protein Q9UN81
## Search all Projects containing protein: Q9UN81
cd /data/home/btx157/pride_reanalysis/inputs

echo
echo "Identifiying Projects..."
echo
wget https://www.ebi.ac.uk:443/pride/ws/archive/project/list?query=$PROTEIN
echo
echo
echo
echo
echo "Projects containing $PROTEIN identified"
echo
echo "Project Accession numbers:"
echo
grep -o "PXD[0-9][0-9][0-9][0-9][0-9][0-9]" list?query=$PROTEIN
echo
grep -o "PXD[0-9][0-9][0-9][0-9][0-9][0-9]" list?query=$PROTEIN > pxd_list.txt
echo
echo

while read line; 

do sh project_API.sh "$line" /Users/nazrathnawaz/apocrita/pride_reanalysis/inputs; 

done < pxd_list.txt

echo
echo "Files Downloaded:"
echo
ls
echo


# ## Identify Array for Project 1
# echo
# echo "Retrieving protein identification assay for project 1 and protein: Q9UN81"
# echo 
# wget http://www.ebi.ac.uk:80/pride/ws/archive/protein/list/project/PXD003406/protein/Q9UN81
# echo
# echo
# echo
# sleep 8

# ## Retrieve Array Acession number
# echo "Identifying Arrays..."
# echo
# grep -o "assayAccession.:.[0-9]*" Q9UN81 > assay_accession.txt
# sed -i -e 's/assayAccession.:.//g' assay_accession.txt
# echo
# echo "Arrays identified"
# echo
# echo Array Accession number: "$(cat assay_accession.txt)"
# echo
# echo
# sleep 8

## Identify Array data files

# Retrieve all data files for Project 1
# echo "Project 1 and Array 1"
# echo
# wget http://www.ebi.ac.uk:80/pride/ws/archive/file/list/project/PXD003411
# echo

## Download Data files for Array 60693
# echo
# echo "Starting to Download Data files for Array 1"
# echo
# echo
# wget https://www.ebi.ac.uk:443/pride/ws/archive/file/list/assay/60693

# echo
# echo
# echo
# grep -o "mgf...downloadLink...ftp.*mgf" 60693 > downloadLink.sh
# sed -i -e 's/mgf","downloadLink":"/wget /g' downloadLink.sh
# sh downloadLink.sh
# echo
# echo
# echo "Download successful"
# echo


# sh full_project_API.sh PXD001694 /Users/nazrathnawaz/apocrita/pride_reanalysis/inputs



# remove unnecessary files
# echo "removing temp files..."
# rm Q9UN81
# # rm PXD003411
# rm 60693
rm list?query=Q9UN81
# rm assay_accession.txt
# rm downloadLink.sh
rm pxd_list.txt



