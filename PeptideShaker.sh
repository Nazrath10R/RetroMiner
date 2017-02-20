#!/bin/bash 

#------------------------------------------------------------#
#                        Variables                           #
#------------------------------------------------------------#

#### Command Line Arguments ####

PROTEIN=$1
PXD=$2
INPUT_FILE=$3
PARAMETERS=$4
EXPERIMENT=$5
SAMPLE=$6
ANALYSIS=$7
REPLICATE=$8
OUTPUT_FOLDER=$9
THREADS=${10}


#######################################################
####              Peptide Shaker                   ####
#######################################################

cd /data/home/bt12048/pride_reanalysis/PeptideShaker.6/

## Run PeptideShaker
echo
java -Xmx100G -cp PeptideShaker-1.14.6.jar eu.isas.peptideshaker.cmd.PeptideShakerCLI -experiment $EXPERIMENT -sample $SAMPLE -replicate $REPLICATE -identification_files $OUTPUT_FOLDER -spectrum_files $INPUT_FILE -id_params $PARAMETERS -out $OUTPUT_FOLDER/$SAMPLE.cpsx -threads $THREADS

# java -Xmx100G -cp PeptideShaker-1.14.6.jar eu.isas.peptideshaker.cmd.PeptideShakerCLI -experiment inflammation -sample inflammation_dataset_cyt_con_2a -replicate 1 -identification_files /data/home/bt12048/pride_reanalysis/outputs/searchgui_out -spectrum_files /data/home/bt12048/pride_reanalysis/inputs/HUVEC_cyt_con_2a.mgf -id_params /data/home/bt12048/pride_reanalysis/parameters/inflammation.par -out /data/home/bt12048/pride_reanalysis/outputs/inflammation_dataset_cyt_con_2a.cpsx -threads 18

if [ ! -f $OUTPUT_FOLDER/$SAMPLE.cpsx ]; 
	then echo "Error: PeptideShaker did not finish running properly"
else
	echo
	echo "PeptideShaker successfully completed"
	echo
fi

# #######################################################

## convert PeptideShaker results to .mzidML file
echo "converting PeptideShaker output to mzIdentML files"
echo
java -Xmx100G -cp PeptideShaker-1.14.6.jar eu.isas.peptideshaker.cmd.MzidCLI -in /data/home/bt12048/pride_reanalysis/outputs/inflammation_dataset_cyt_con_2a.cpsx -output_file /data/home/bt12048/pride_reanalysis/outputs/inflammation_dataset_cyt_con_2a.mzid -contact_first_name "Nazrath" -contact_last_name "Nawaz" -contact_email "nazrath.nawaz@yahoo.de" -contact_address "Fogg Building, London" -organization_name "QMUL" -organization_email "m.n.mohamednawaz@se12.qmul.ac.uk" -organization_address "Mile End Road, London"

# -spectrum_files /data/home/bt12048/pride_reanalysis/inputs/
echo
echo "conversion to mzIdentML successful"
echo
