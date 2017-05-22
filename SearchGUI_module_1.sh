#!/bin/bash 

PXD=$1
INPUT_FILE=$2
PARAMETERS=$3
EXPERIMENT=$4
SAMPLE=$5
ANALYSIS=$6
REPLICATE=$7
OUTPUT_FOLDER=$8
THREADS=$9

cd /data/home/btx157/pride_reanalysis/SearchGUI.5/

echo
echo
echo "Using frontend5 for X!Tandem and Comet"
echo
echo
cd /data/home/btx157/pride_reanalysis/SearchGUI.5/
echo

{
java -Xmx100G -cp SearchGUI-3.2.5.jar eu.isas.searchgui.cmd.SearchCLI -spectrum_files $INPUT_FILE -output_folder $OUTPUT_FOLDER -id_params $PARAMETERS -xtandem 1 -comet 1 -threads $THREADS &
} &> /dev/null

echo
echo "X!Tandem and Comet successful"
echo
