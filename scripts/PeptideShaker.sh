#!/bin/bash

#############################################################
####                  PEPTIDESHAKER                      ####
#############################################################

#                                                            #
#     Protein Inferance and Protein Probability scoring      #
#                                                            #

#============================================================#
# sh PeptideShaker.sh PXD003417 1 16
#============================================================#

#------------------------------------------------------------#
#                        Variables                           #
#------------------------------------------------------------#

#### Command Line Arguments ####

PXD=$1
SAMPLE=$2
THREADS=$4

INPUT_FILE="/data/home/btx157/pride_reanalysis/inputs/$PXD/"
PARAMETERS="/data/home/btx157/pride_reanalysis/parameters/$PXD.par"
EXPERIMENT="$PXD"
OUTPUT_FOLDER="/data/home/btx157/pride_reanalysis/outputs/$PXD/"
REPLICATE=1

#------------------------------------------------------------#


#######################################################
####              Peptide Shaker                   ####
#######################################################

cd /data/home/btx157/pride_reanalysis/PeptideShaker.6/

## Run PeptideShaker
echo
java -Xmx100G -cp PeptideShaker-1.14.6.jar eu.isas.peptideshaker.cmd.PeptideShakerCLI -experiment $EXPERIMENT -sample $SAMPLE -replicate $REPLICATE -identification_files $OUTPUT_FOLDER -spectrum_files $INPUT_FILE -id_params $PARAMETERS -out $OUTPUT_FOLDER/$SAMPLE.cpsx -threads $THREADS

echo
if [ ! -f $OUTPUT_FOLDER/$SAMPLE.cpsx ];
	then echo "Error: PeptideShaker did not finish running properly"
  exit 1
else
	echo
	echo "PeptideShaker successfully completed"
	echo
fi

#                  ~ end of script ~                  #

