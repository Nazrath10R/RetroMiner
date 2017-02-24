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

	## SearchGUI Parallelisation 

	cd /data/home/bt12048/pride_reanalysis/SearchGUI.5/

# tmux new -s msgf 'sh pride_reanalysis_4.sh'

# tmux new-session -d -s msgf
# tmux send-keys 'sh pride_reanalysis_4.sh' C-m
# tmux detach -s msgf


# tmux send -t msgf ls ENTER

	# tmux new-session -d -s msgf
	# tmux send-keys 'java -Xmx100G -cp SearchGUI-3.2.5.jar eu.isas.searchgui.cmd.SearchCLI -spectrum_files '$INPUT_FILE' -output_folder '$OUTPUT_FOLDER' -id_params '$PARAMETERS' -msgf 1 -threads 36' C-m
	# tmux detach -s msgf

	# # java -Xmx100G -cp SearchGUI-3.2.5.jar eu.isas.searchgui.cmd.SearchCLI -spectrum_files $INPUT_FILE -output_folder $OUTPUT_FOLDER -id_params $PARAMETERS -omssa 1 -threads $THREADS

	# tmux new-session -d -s xtandem
	# tmux send-keys 'java -Xmx100G -cp SearchGUI-3.2.5.jar eu.isas.searchgui.cmd.SearchCLI -spectrum_files '$INPUT_FILE' -output_folder '$OUTPUT_FOLDER' -id_params '$PARAMETERS' -xtandem 1 -threads 19' C-m
	# tmux detach -s xtandem

	# java -Xmx100G -cp SearchGUI-3.2.5.jar eu.isas.searchgui.cmd.SearchCLI -spectrum_files $INPUT_FILE -output_folder $OUTPUT_FOLDER -id_params $PARAMETERS -xtandem 1 -threads 19

	# tmux new-session -d -s myrimatch
	# tmux send-keys 'java -Xmx100G -cp SearchGUI-3.2.5.jar eu.isas.searchgui.cmd.SearchCLI -spectrum_files '$INPUT_FILE' -output_folder '$OUTPUT_FOLDER' -id_params '$PARAMETERS' -myrimatch 1 -threads '$THREADS'' C-m
	# tmux detach

	# tmux new-session -d -s omssa
	# tmux send-keys 'java -Xmx100G -cp SearchGUI-3.2.5.jar eu.isas.searchgui.cmd.SearchCLI -spectrum_files '$INPUT_FILE' -output_folder '$OUTPUT_FOLDER' -id_params '$PARAMETERS' -omssa 1 -threads 25' C-m
	# tmux detach

	# tmux new-session -d -s comet
	# tmux send-keys 'java -Xmx100G -cp SearchGUI-3.2.5.jar eu.isas.searchgui.cmd.SearchCLI -spectrum_files '$INPUT_FILE' -output_folder '$OUTPUT_FOLDER' -id_params '$PARAMETERS' -comet 1 -threads 25' C-m
	# tmux detach

 # 	# -tide 0 -andromeda 0

fi

# tmux new -s myname
# tmux a -t myname

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

