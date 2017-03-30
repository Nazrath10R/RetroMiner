#!/bin/bash 

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

cd /data/home/btx157/pride_reanalysis/SearchGUI.5/

echo
echo
echo "Using sm11 for msgfs+"
echo
echo
cd /data/home/btx157/pride_reanalysis/SearchGUI.5/
echo

{
java -Xmx100G -cp SearchGUI-3.2.5.jar eu.isas.searchgui.cmd.SearchCLI -spectrum_files $INPUT_FILE -output_folder $OUTPUT_FOLDER -id_params $PARAMETERS -msgf 1 -threads $THREADS &
} &> /dev/null

echo
echo "msgfs+ successful"
echo