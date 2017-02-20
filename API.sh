#!/bin/bash 

##############################################################
#######    Re-Analysis Pipeline for PRIDE datasets    ########
##############################################################

## Human proteome contains fasta file with all three ORF proteins
# Seperate analysis for projects that contain reshakable files vs
# non reshakable files

 # tmux detach
######## Variables ########

PROTEIN="Q9UN81"
PXD="PXD003406"
INPUT_FILE='/data/home/bt12048/pride_reanalysis/inputs/HUVEC_cyt_con_2a.mgf'
PARAMETERS='/data/home/bt12048/pride_reanalysis/parameters/inflammation.par'
EXPERIMENT="inflammation"
SAMPLE="inflammation_dataset_cyt_con_2a" 
ANALYSIS=2
REPLICATE=1
OUTPUT_FOLDER="/data/home/bt12048/pride_reanalysis/outputs/test"
THREADS=70


#######################################################
####                PRIDE Reshake                  ####
#######################################################

# PRIDE Reshake works for mzIdentML or PRIDE XML files

## Pride Reshake
# requires ssh -X for interactivity
# java -jar PeptideShaker-1.14.6.jar -pxAccession "PXD003411"


#######################################################
####                    PRIDE API                  ####
#######################################################

## PRIDE - https://www.ebi.ac.uk/pride/archive/
## PRIDE API - https://www.ebi.ac.uk/pride/ws/archive/ 
##### Proteins of Interest: Q9UN81 (ORF1p), O00370 (ORF2p), Q9UN82 (ORF0)
## Example dataset PXD003411


#### Search PRIDE datasets for protein of interest ####

## Find Projects matching Protein of Interest
# echo
# echo "Starting Re-Analysis Pipeline..."
# echo
# echo "Creating Output folder"
# echo
# # sleep 3

# function check_if_file_exists {
#   if [ -s $OUTPUT_FOLDER/$SAMPLE ]; then 
#     echo "*** File Created: $1"
#   else
#     echo "*** ERROR: File Does Not exist: $1"
#     exit 1
#   fi
# }

mkdir $OUTPUT_FOLDER/$SAMPLE
# echo
# echo "Fetching Data from PRIDE through RESTful API"
# echo
# echo "Retrieving all Projects containing Protein: $PROTEIN"
# echo
# sleep 6

# ## protein Q9UN81
# ## Search all Projects containing protein: Q9UN81
# cd /data/home/bt12048/pride_reanalysis/inputs
# echo
# echo "Identifiying Projects..."
# echo
# wget https://www.ebi.ac.uk:443/pride/ws/archive/project/list?query=Q9UN81&order=desc
# echo
# echo
# echo
# echo
# echo "Projects containing Q9UN81 identified"
# echo
# echo "Project Accession numbers:"
# echo
# grep -o "PXD[0-9][0-9][0-9][0-9][0-9][0-9]" list?query=Q9UN81
# echo
# grep -o "PXD[0-9][0-9][0-9][0-9][0-9][0-9]" list?query=Q9UN81 > pxd_list.txt
# sleep 8

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

# ## Identify Array data files

# # Retrieve all data files for Project 1
# # echo "Project 1 and Array 1"
# # echo
# # wget http://www.ebi.ac.uk:80/pride/ws/archive/file/list/project/PXD003411
# # echo

# ## Download Data files for Array 60693
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

# # remove unnecessary files
# echo "removing temp files..."
# rm Q9UN81
# # rm PXD003411
# rm 60693
# rm list?query=Q9UN81
# rm assay_accession.txt
# rm downloadLink.sh
# rm pxd_list.txt

# echo
# echo "Files Downloaded:"
# echo
# ls
# echo
# sleep 8


# ## Search PRIDE datasets for project of interest
# ## Search PRIDE datasets for biomarker of interest
echo
echo
echo "Retrieving Data from PRIDE successful"
echo
echo "Starting Re-Analysis tools..."
echo
echo "Input data file:"
echo "$INPUT_FILE"
echo
echo "Parameter file:"
echo "PARAMETERS"
echo
echo "Sample Name:"
echo "$SAMPLE"
echo
echo "Replicates: $REPLICATE"
echo

