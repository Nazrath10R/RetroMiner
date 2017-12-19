#!/bin/bash

#############################################################
####                    SEARCHGUI                        ####
#############################################################

#                                                            #
#     protein and peptide identification search engines      #
#                                                            #

#============================================================#
# sh SearchGUI.sh PXD003417 1 16
#============================================================#

# par /data/home/btx157/pride_reanalysis/parameters/PXD003417.par

#------------------------------------------------------------#
#                        Variables                           #
#------------------------------------------------------------#

#### Command Line Arguments ####

PXD=$1
ANALYSIS=$3
THREADS=$4

INPUT_FILE="/data/home/btx157/pride_reanalysis/inputs/$PXD/"
PARAMETERS="/data/home/btx157/pride_reanalysis/parameters/$PXD.par"
EXPERIMENT="$PXD"
OUTPUT_FOLDER="/data/home/btx157/pride_reanalysis/outputs/$PXD/"
SAMPLE="1"
REPLICATE=1

#------------------------------------------------------------#


#######################################################
####                  Search GUI                   ####
#######################################################

cd /data/home/btx157/pride_reanalysis/SearchGUI.5/

if [ "$ANALYSIS" -eq 1 ]; then
	echo
	echo "Using 1 node: frontend5"
	echo
	echo "Starting SearchGUI for X!Tandem and Comet..."
	# bash loading.sh
	echo
  cd /data/home/btx157/pride_reanalysis/scripts/
  
	sh SearchGUI_module_1.sh $PXD $INPUT_FILE $PARAMETERS $EXPERIMENT $SAMPLE $ANALYSIS $REPLICATE $OUTPUT_FOLDER $THREADS
  
fi


if [ "$ANALYSIS" -eq 2 ]; then
	echo
	echo "Using 2 nodes: frontend5 and frontend6"
	echo
	echo "Starting SearchGUI for Top4"
	echo
	echo
	cd /data/home/btx157/pride_reanalysis/SearchGUI.5/
	echo
	echo
	echo "SearchGUI Parallelisation"
	echo

	ssh apoc5 "cd /data/home/btx157/pride_reanalysis/scripts/ ;
	sh SearchGUI_module_1.sh $PXD' '$INPUT_FILE' '$PARAMETERS' '$EXPERIMENT' '$SAMPLE' '$ANALYSIS' '$REPLICATE' '$OUTPUT_FOLDER' '$THREADS' &"

	ssh sm11 "cd /data/home/btx157/pride_reanalysis/scripts/ ;
	sh SearchGUI_module_2.sh '$PXD' '$INPUT_FILE' '$PARAMETERS' '$EXPERIMENT' '$SAMPLE' '$ANALYSIS' '$REPLICATE' '$OUTPUT_FOLDER' '$THREADS' &"

	echo
	echo
	echo
	echo
	echo "SearchGUI successfully completed"
	echo
	echo

fi


## check if output was produced
# if [ ! -f /data/home/btx157/pride_reanalysis/outputs/searchgui_out.zip ];
# 	then echo "Error: SearchGUI did not finish running properly"
# else
# 	echo
# 	echo "SearchGUI completed successfully"
# 	echo
# 	echo "Starting PeptideShaker..."
# 	echo
# 	bash loading.sh
# 	echo
# fi


#                  ~ end of script ~                  #
