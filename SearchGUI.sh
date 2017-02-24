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
####                  Search GUI                   ####
#######################################################

cd /data/home/btx157/pride_reanalysis/SearchGUI.5/

if [ "$ANALYSIS" -eq 1 ]; then
	echo
	echo "Starting SearchGUI for MS-GF+ only..."
	echo
	bash loading.sh
	java -Xmx100G -cp SearchGUI-3.2.5.jar eu.isas.searchgui.cmd.SearchCLI -spectrum_files $INPUT_FILE -output_folder $OUTPUT_FOLDER -id_params $PARAMETERS -xtandem 0 -myrimatch 0 -ms_amanda 0 -msgf 1 -omssa 0 -comet 0 -tide 0 -andromeda 0 -threads $THREADS
fi

if [ "$ANALYSIS" -eq 2 ]; then
	echo
	echo "Starting SearchGUI for multiple Search Engines..."
	echo
	echo "MS-GF+"
	echo "X! Tandem"
	echo "MyriMatch"
	echo "MS Amanda"
	echo "OMSSA"
	echo "Comet"
	# echo "Andromeda"
	echo
	bash loading.sh
	echo

	cd /data/home/btx157/pride_reanalysis/SearchGUI.5/


	ssh apoc5 'cd /data/home/btx157/pride_reanalysis/scripts/ ;
	sh SearchGUI_module_1.sh "Q9UN81" "PXD003406" "/data/home/btx157/pride_reanalysis/inputs/HUVEC_cyt_con_2a.mgf" "/data/home/btx157/pride_reanalysis/parameters/inflammation.par" "inflammation" "inflammation_dataset_cyt_con_2a" 2 1 "/data/home/btx157/pride_reanalysis/outputs/test" 40' & 
	
	ssh apoc6 'cd /data/home/btx157/pride_reanalysis/scripts/ ;
	sh SearchGUI_module_2.sh "Q9UN81" "PXD003406" "/data/home/btx157/pride_reanalysis/inputs/HUVEC_cyt_con_2a.mgf" "/data/home/btx157/pride_reanalysis/parameters/inflammation.par" "inflammation" "inflammation_dataset_cyt_con_2a" 2 1 "/data/home/btx157/pride_reanalysis/outputs/test" 30' & 
	
	ssh sm11 'cd /data/home/btx157/pride_reanalysis/scripts/ ;
	sh SearchGUI_module_3.sh "Q9UN81" "PXD003406" "/data/home/btx157/pride_reanalysis/inputs/HUVEC_cyt_con_2a.mgf" "/data/home/btx157/pride_reanalysis/parameters/inflammation.par" "inflammation" "inflammation_dataset_cyt_con_2a" 2 1 "/data/home/btx157/pride_reanalysis/outputs/test" 4' & 


	## working 








fi

	# ssh apoc6 'cd /data/home/btx157/pride_reanalysis/scripts/ ;
	# sh test.sh "Q9UN81" "PXD003406" "/data/home/btx157/pride_reanalysis/inputs/HUVEC_cyt_con_2a.mgf" "/data/home/btx157/pride_reanalysis/parameters/inflammation.par" "inflammation" "inflammation_dataset_cyt_con_2a" 2 1 "/data/home/btx157/pride_reanalysis/outputs/test" 40 2'
	
	# ssh apoc6 'cd /data/home/btx157/pride_reanalysis/scripts/ ;
	# sh test.sh "$PROTEIN" "$PXD" "$INPUT_FILE" "$PARAMETERS" "$EXPERIMENT" "$SAMPLE" "$ANALYSIS" "$REPLICATE" "$OUTPUT_FOLDER" "$NODES"'


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

