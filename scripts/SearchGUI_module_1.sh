#!/bin/bash

#############################################################
####               SEARCHGUI MODULE 1                    ####
#############################################################

#                                                            #
#              Frontend 5: X!Tandem and Comet                #
#                                                            #

#------------------------------------------------------------#
#                        Variables                           #
#------------------------------------------------------------#

DIR=/data/SBCS-BessantLab/naz

PXD=$1
INPUT_FILE=$2
PARAMETERS=$3
EXPERIMENT=$4
SAMPLE=$5
ANALYSIS=$6
REPLICATE=$7
OUTPUT_FOLDER=$8
THREADS=$9

#------------------------------------------------------------#

echo
echo "Using X!Tandem and Comet"
echo
echo
cd $DIR/pride_reanalysis/SearchGUI.5/
echo

module load java/1.8.0_121-oracle

{
java -Xmx100G -cp SearchGUI-3.2.5.jar eu.isas.searchgui.cmd.SearchCLI -spectrum_files $INPUT_FILE -output_folder $OUTPUT_FOLDER -id_params $PARAMETERS -xtandem 1 -comet 1 -threads "$THREADS"
# &
}

echo
echo "X!Tandem and Comet successful"
echo

#                  ~ end of script ~                  #

