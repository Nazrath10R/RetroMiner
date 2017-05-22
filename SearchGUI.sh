#!/bin/bash 

#------------------------------------------------------------#
#                        Variables                           #
#------------------------------------------------------------#
## 	sh SearchGUI.sh "Q9UN81" "PXD003406" "/data/home/btx157/pride_reanalysis/inputs/HUVEC_cyt_con_2a.mgf" "/data/home/btx157/pride_reanalysis/parameters/inflammation.par" "inflammation" "inflammation_dataset_cyt_con_2a" 2 1 "/data/home/btx157/pride_reanalysis/outputs/test" 40' & 

#### Command Line Arguments ####

PXD=$1
INPUT_FILE=$2
PARAMETERS=$3
EXPERIMENT=$4
SAMPLE=$5
ANALYSIS=$6
REPLICATE=$7
OUTPUT_FOLDER=$8
THREADS=$9


PXD=PXD003406
INPUT_FILE="/data/home/btx157/pride_reanalysis/inputs/HUVEC_cyt_con_2a.mgf"
PARAMETERS="/data/home/btx157/pride_reanalysis/parameters/inflammation.par"
EXPERIMENT="bla"
SAMPLE="bla"
ANALYSIS="blabla"
REPLICATE="blablabla"
OUTPUT_FOLDER="here init"
THREADS="one init"


#######################################################
####                  Search GUI                   ####
#######################################################

cd /data/home/btx157/pride_reanalysis/SearchGUI.5/

if [ "$ANALYSIS" -eq 1 ]; then
	echo
	echo "Using 1 node: frontend6"
	echo
	echo "Starting SearchGUI for X!Tandem and Comet..."
	echo
	bash loading.sh
	echo
	ssh apoc5 'cd /data/home/btx157/pride_reanalysis/scripts/ ;
	sh SearchGUI_module_1.sh '$PXD' '$INPUT_FILE' '$PARAMETERS' '$EXPERIMENT' '$SAMPLE' '$ANALYSIS' '$REPLICATE' '$OUTPUT_FOLDER' '$THREADS'' & 
fi

if [ "$ANALYSIS" -eq 2 ]; then
	echo
	echo "Using 2 nodes: frontend5 and frontend6"
	echo
	echo "Starting SearchGUI for Top4"
	echo
	echo
	bash loading.sh
	echo

	cd /data/home/btx157/pride_reanalysis/SearchGUI.5/

	echo
	echo
	echo "SearchGUI Parallelisation"
	echo
	echo
	echo

	ssh apoc5 'cd /data/home/btx157/pride_reanalysis/scripts/ ;
	sh SearchGUI_module_1.sh '$PXD' '$INPUT_FILE' '$PARAMETERS' '$EXPERIMENT' '$SAMPLE' '$ANALYSIS' '$REPLICATE' '$OUTPUT_FOLDER' '$THREADS'' & 
	
	ssh sm11 'cd /data/home/btx157/pride_reanalysis/scripts/ ;
	sh SearchGUI_module_2.sh '$PXD' '$INPUT_FILE' '$PARAMETERS' '$EXPERIMENT' '$SAMPLE' '$ANALYSIS' '$REPLICATE' '$OUTPUT_FOLDER' '$THREADS'' & 
	
	echo
	echo
	echo
	echo
	echo "SearchGUI successfully completed"
	echo
	echo

fi

# #######################################################

# need to wait for all outputs to be produced before starting PeptideShaker

# #######################################################


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

