#!/bin/bash

#############################################################
####                    SEARCHGUI                        ####
#############################################################

#                                                            #
#     protein and peptide identification search engines      #
#                                                            #

#============================================================#
# sh SearchGUI.sh PXD003417 1 36
#============================================================#

DIR=/data/SBCS-BessantLab/naz

# par $DIR/pride_reanalysis/parameters/PXD003417.par

#------------------------------------------------------------#
#                        Variables                           #
#------------------------------------------------------------#

#### Command Line Arguments ####

PXD=$1
ANALYSIS=$2
THREADS=$3

# PXD=PXD003417
# ANALYSIS=1
# THREADS=60

# PXD=PXD000655
# ANALYSIS=2
# THREADS=60

SAMPLE="1"
REPLICATE=1

INPUT_FILE="$DIR/pride_reanalysis/inputs/$PXD/"
PARAMETERS="$DIR/pride_reanalysis/parameters/$PXD.par"
EXPERIMENT="$PXD"

echo "Creating Output folder"
echo
mkdir $DIR/pride_reanalysis/outputs/$PXD/
OUTPUT_FOLDER="$DIR/pride_reanalysis/outputs/$PXD/"
echo

#------------------------------------------------------------#


#######################################################
####                  Search GUI                   ####
#######################################################

cd $DIR/pride_reanalysis/SearchGUI.5/

if [ "$ANALYSIS" -eq 1 ]; then
	echo
	echo "Using 1 node: frontend5"
	echo
	echo "Starting SearchGUI for X!Tandem and Comet..."
	echo
	ssh apoc5 "cd $DIR/pride_reanalysis/scripts/ ;
	sh SearchGUI_module_1.sh '$PXD' '$INPUT_FILE' '$PARAMETERS' '$EXPERIMENT' '$SAMPLE' '$ANALYSIS' '$REPLICATE' '$OUTPUT_FOLDER' '$THREADS'"

fi


if [ "$ANALYSIS" -eq 2 ]; then
	echo
	echo "Using 1 nodes frontend6"
	echo
	echo "Starting SearchGUI for Top4"
	echo
	# echo
	# echo
	# echo
	# echo "SearchGUI Parallelisation"
	# echo

  ssh apoc6 "cd $DIR/pride_reanalysis/scripts/ ;
  sh SearchGUI_module_1.sh '$PXD' '$INPUT_FILE' '$PARAMETERS' '$EXPERIMENT' '$SAMPLE' '$ANALYSIS' '$REPLICATE' '$OUTPUT_FOLDER' '$THREADS'"

  # # cd $DIR/pride_reanalysis/scripts/
  # # sh SearchGUI_module_1.sh $PXD $INPUT_FILE $PARAMETERS $EXPERIMENT $SAMPLE $ANALYSIS $REPLICATE $OUTPUT_FOLDER $THREADS

  # ssh apoc6 "cd $DIR/pride_reanalysis/scripts/ ;
  # sh SearchGUI_module_1.sh '$PXD' '$INPUT_FILE' '$PARAMETERS' '$EXPERIMENT' '$SAMPLE' '$ANALYSIS' '$REPLICATE' '$OUTPUT_FOLDER' '$THREADS'"

	# ssh apoc5 "cd $DIR/pride_reanalysis/scripts/ ;
	# sh SearchGUI_module_1.sh '$PXD' '$INPUT_FILE' '$PARAMETERS' '$EXPERIMENT' '$SAMPLE' '$ANALYSIS' '$REPLICATE' '$OUTPUT_FOLDER' '$THREADS' &"

	# ssh sm11 "cd $DIR/pride_reanalysis/scripts/ ;
	# sh SearchGUI_module_2.sh '$PXD' '$INPUT_FILE' '$PARAMETERS' '$EXPERIMENT' '$SAMPLE' '$ANALYSIS' '$REPLICATE' '$OUTPUT_FOLDER' '$THREADS' &"
	echo
	echo
	# echo
	# echo
	# echo "SearchGUI successfully completed"
	echo
	echo

fi


if [ "$ANALYSIS" -eq 3 ]; then
  echo
  echo "Using 1 node: sm11"
  echo
  echo "Starting SearchGUI for X!Tandem and Comet..."
  echo
  ssh sm11 "cd $DIR/pride_reanalysis/scripts/ ;
  sh SearchGUI_module_1.sh '$PXD' '$INPUT_FILE' '$PARAMETERS' '$EXPERIMENT' '$SAMPLE' '$ANALYSIS' '$REPLICATE' '$OUTPUT_FOLDER' '$THREADS'"
  echo
  echo
  echo
fi




# check if output was produced
if [ ! -f $DIR/pride_reanalysis/outputs/$PXD/searchgui_out.zip ];
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


#                  ~ end of script ~                  #
