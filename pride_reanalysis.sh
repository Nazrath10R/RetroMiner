#!/bin/bash 

##############################################################
#######    Re-Analysis Pipeline for PRIDE datasets    ########
##############################################################

## Human proteome contains fasta file with all three ORF proteins


######## Variables ########

PROTEIN="Q9UN81"
INPUT_FILE='/data/home/bt12048/pride_reanalysis/inputs/HUVEC_cyt_con_1a_2.mgf'
PARAMETERS='/data/home/bt12048/pride_reanalysis/parameters/inflammation.par'
EXPERIMENT="inflammation" 
SAMPLE="inflammation_dataset_1" 
ANALYSIS=2
REPLICATE=1
OUTPUT_FOLDER="/data/home/bt12048/pride_reanalysis/outputs"
THREADS=76


#######################################################
####					PRIDE API				   ####
#######################################################

## PRIDE - https://www.ebi.ac.uk/pride/archive/
## PRIDE API - https://www.ebi.ac.uk/pride/ws/archive/ 
##### Proteins of Interest: Q9UN81 (ORF1p), O00370 (ORF2p), Q9UN82 (ORF0)
## Example dataset PXD003411


#### Search PRIDE datasets for protein of interest ####

## Find Projects matching Protein of Interest
echo
echo "Starting Re-Analysis Pipeline..."
echo
echo "Fetching Data from PRIDE through RESTful API"
echo
echo "Retrieving all Projects containing Protein: $PROTEIN"
echo


## protein Q9UN81
##
wget https://www.ebi.ac.uk:443/pride/ws/archive/project/list?query=Q9UN81&order=desc

echo "Identifiying Projects..."
echo
echo "Project Accession numbers:"
echo
grep -o "PXD[0-9][0-9][0-9][0-9][0-9][0-9]" list
echo
grep -o "PXD[0-9][0-9][0-9][0-9][0-9][0-9]" list > list2.txt


## Identify Assay for Project 1
echo
echo "Retrieving protein identifications for project 1 and protein: Q9UN81"
echo 
wget http://www.ebi.ac.uk:80/pride/ws/archive/protein/list/project/PXD003411/protein/Q9UN81
echo

## Retrieve Array Acession number
grep -o "assayAccession.:.[0-9]*" Q9UN81 > array_accession.txt
sed -i -e 's/assayAccession.:.//g' array_accession.txt
echo

## Identify Array data files
echo "Project 1 and Array 1"
echo
wget http://www.ebi.ac.uk:80/pride/ws/archive/file/list/project/PXD003411
echo

## Download Data files for Array 60796
echo "Download Data files for Array 1"
wget https://www.ebi.ac.uk:443/pride/ws/archive/file/list/assay/60796
echo
grep -o "mgf...downloadLink...ftp.*mgf" 60796 > downloadLink.sh
sed -i -e 's/mgf","downloadLink":"/wget /g' downloadLink.sh
sh downloadLink.sh

## Search PRIDE datasets for project of interest
## Search PRIDE datasets for biomarker of interest

echo "Retrieving Data from PRIDE successfull"
echo
echo "Starting Re-Analysis tools"

############################################################

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
echo "Creating Output folder"
echo

function check_if_file_exists {
  if [ -s $OUTPUT_FOLDER/$SAMPLE ]; then 
    echo "*** File Created: $1"
  else
    echo "*** ERROR: File Does Not exist: $1"
    exit 1
  fi
}

mkdir $OUTPUT_FOLDER/$SAMPLE

############################################################

#### Calculate Total runtime ####

function print_time {
  END=$(date +%s)
  DIFF=$(( $END - $1 ))
  dd=$(echo "$DIFF/86400" | bc)
  dt2=$(echo "$DIFF-86400*$dd" | bc)
  dh=$(echo "$dt2/3600" | bc)
  dt3=$(echo "$dt2-3600*$dh" | bc)
  dm=$(echo "$dt3/60" | bc)
  ds=$(echo "$dt3-60*$dm" | bc)
  if [ $dd -gt 0 ]; then
    echo " ${dd} days and ${dh} hours."
  elif [ $dh -gt 0 ]; then
    echo " ${dh} hours and ${dm} minutes."
  elif [ $dm -gt 0 ]; then
    echo " ${dm} minutes and ${ds} seconds."
  else
    echo " ${ds} seconds."
  fi
}

## Start clock time
START=$(date +%s)


#######################################################
####					Search GUI					 ####
#######################################################


cd /data/home/bt12048/pride_reanalysis/SearchGUI.5/

if [ "$ANALYSIS" -eq 1 ]; then
	echo
	echo "Starting SearchGUI for MS-GF+ only..."
	echo
	bash loading.sh
	java -cp SearchGUI-3.2.5.jar eu.isas.searchgui.cmd.SearchCLI -spectrum_files $INPUT_FILE -output_folder $OUTPUT_FOLDER/$SAMPLE -id_params $PARAMETERS -xtandem 0 -myrimatch 0 -ms_amanda 0 -msgf 1 -omssa 0 -comet 0 -tide 0 -andromeda 0 -threads $THREADS
fi

if [ "$ANALYSIS" -eq 2 ]; then
	echo
	echo "Starting SearchGUI for multiple Search Engines..."
	echo
	echo "X! Tandem"
	echo "MyriMatch"
	echo "MS Amanda"
	echo "MS-GF+"
	echo "OMSSA"
	echo "Comet"
	# echo "Andromeda"
	echo
	bash loading.sh
	echo
	java -cp SearchGUI-3.2.5.jar eu.isas.searchgui.cmd.SearchCLI -spectrum_files $INPUT_FILE -output_folder $OUTPUT_FOLDER -id_params $PARAMETERS -xtandem 1 -myrimatch 1 -ms_amanda 0 -msgf 1 -omssa 1 -comet 1 -tide 0 -andromeda 0 -threads $THREADS
fi

## check if output was produced
if [ ! -f /data/home/bt12048/pride_reanalysis/outputs/searchgui_out.zip ]; 
	then echo "Error: SearchGUI did not finish running properly"
else
	echo
	echo "SearchGUI completed successfully"
	echo
	echo "Starting PeptideShaker..."
	echo
	bash loading.sh
	echo
fi


#######################################################
#### 				Peptide Shaker 				   ####
#######################################################

cd /data/home/bt12048/pride_reanalysis/PeptideShaker.6/

java -cp PeptideShaker-1.14.6.jar eu.isas.peptideshaker.cmd.PeptideShakerCLI -experiment $EXPERIMENT -sample $SAMPLE -replicate $REPLICATE -identification_files $OUTPUT_FOLDER -spectrum_files $INPUT_FILE -id_params $PARAMETERS -out $OUTPUT_FOLDER/$SAMPLE.cpsx -threads $THREADS


## Print Analysis time
echo
echo "Total Run-time for this Re-Analysis was:"
print_time $START
echo

## e-mail notification
mail -s "Apocrita run completed" nazrath.nawaz@yahoo.de <<< "File: $INPUT_FILE"


#######################################################


