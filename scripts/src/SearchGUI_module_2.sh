#!/bin/bash

#############################################################
####               SEARCHGUI MODULE 2                    ####
#############################################################

#                                                            #
#                sm11: MS Amanda and MS-GF+                  #
#                                                            #

#------------------------------------------------------------#
#                        Variables                           #
#------------------------------------------------------------#


DIR=`find . -name "retrominer_path.txt" -type f -exec cat {} +`
# DIR=/data/SBCS-BessantLab/naz/pride_reanalysis

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

cd $DIR/pride_reanalysis/SearchGUI.5/

echo
echo "Using sm11 for MSGF+ and MS_Amanda"
echo
echo
cd $DIR/pride_reanalysis/SearchGUI.5/
echo

{
java -Xmx100G -cp SearchGUI-3.2.5.jar eu.isas.searchgui.cmd.SearchCLI -spectrum_files $INPUT_FILE -output_folder $OUTPUT_FOLDER -id_params $PARAMETERS -msgf 1 -threads $THREADS
java -Xmx100G -cp SearchGUI-3.2.5.jar eu.isas.searchgui.cmd.SearchCLI -spectrum_files $INPUT_FILE -output_folder $OUTPUT_FOLDER -id_params $PARAMETERS -ms_amanda 1 -threads $THREADS
}
echo
echo "MSGF+ and MS_Amanda successful"
echo

#                  ~ end of script ~                  #
