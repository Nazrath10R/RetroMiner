#!/bin/bash 

# sh test.sh "Q9UN81" "PXD003406" '/data/home/btx157/pride_reanalysis/inputs/HUVEC_cyt_con_2a.mgf' '/data/home/btx157/pride_reanalysis/parameters/inflammation.par' "inflammation" "inflammation_dataset_cyt_con_2a" 2 1 "/data/home/btx157/pride_reanalysis/outputs/test" 2

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
NODES=${11}


cd /data/home/btx157/pride_reanalysis/SearchGUI.5/

echo $NODES

if [ "$NODES" -eq 2 ]; then
	echo
	echo "Using frontend5 and 6..."
	echo

	echo
	echo
	cd /data/home/btx157/pride_reanalysis/SearchGUI.5/
	echo
	
	{
	java -Xmx100G -cp SearchGUI-3.2.5.jar eu.isas.searchgui.cmd.SearchCLI -spectrum_files $INPUT_FILE -output_folder $OUTPUT_FOLDER -id_params $PARAMETERS -msgf 1 & > /dev/null
	java -Xmx100G -cp SearchGUI-3.2.5.jar eu.isas.searchgui.cmd.SearchCLI -spectrum_files $INPUT_FILE -output_folder $OUTPUT_FOLDER -id_params $PARAMETERS -comet 1 & > /dev/null
	java -Xmx100G -cp SearchGUI-3.2.5.jar eu.isas.searchgui.cmd.SearchCLI -spectrum_files $INPUT_FILE -output_folder $OUTPUT_FOLDER -id_params $PARAMETERS -ms_amanda 1 & > /dev/null
	} &> /dev/null

	# echo
	# ssh apoc6
	# echo
	# cd /data/home/btx157/pride_reanalysis/SearchGUI.5/
	# echo
	# java -Xmx100G -cp SearchGUI-3.2.5.jar eu.isas.searchgui.cmd.SearchCLI -spectrum_files $INPUT_FILE -output_folder $OUTPUT_FOLDER -id_params $PARAMETERS -xtandem 1 -ommsa 1
	# echo
fi


# if [ "$NODES" -eq 3 ]; then
# 	echo
# 	echo "Using sm11, frontend5 and 6..."
# 	echo
# 	echo $(( $THREADS/2))
# 	echo

# fi



# sh SearchGUI.sh "Q9UN81" "PXD003406" '/data/home/btx157/pride_reanalysis/inputs/HUVEC_cyt_con_2a.mgf' '/data/home/btx157/pride_reanalysis/parameters/inflammation.par' "inflammation" "inflammation_dataset_cyt_con_2a" 2 1 "/data/home/btx157/pride_reanalysis/outputs/test" 36

# ssh apoc6 'sh /data/home/btx157/pride_reanalysis/scripts/SearchGUI.sh "Q9UN81" "PXD003406" "/data/home/btx157/pride_reanalysis/inputs/HUVEC_cyt_con_2a.mgf" "/data/home/btx157/pride_reanalysis/parameters/inflammation.par" "inflammation" "inflammation_dataset_cyt_con_2a" 2 1 "/data/home/btx157/pride_reanalysis/outputs/test" 36'
# ssh apoc6 'sh /data/home/btx157/pride_reanalysis/scripts/SearchGUI.sh "Q9UN81" "PXD003406" "/data/home/btx157/pride_reanalysis/inputs/HUVEC_cyt_con_2a.mgf" "/data/home/btx157/pride_reanalysis/parameters/inflammation.par" "inflammation" "inflammation_dataset_cyt_con_2a" 2 1 "/data/home/btx157/pride_reanalysis/outputs/test" 36'


# java -Xmx100G -cp SearchGUI-3.2.5.jar eu.isas.searchgui.cmd.SearchCLI -spectrum_files '$INPUT_FILE' -output_folder '$OUTPUT_FOLDER' -id_params '$PARAMETERS' -xtandem 1 -threads '$THREADS'
# java -Xmx100G -cp SearchGUI-3.2.5.jar eu.isas.searchgui.cmd.SearchCLI -spectrum_files '$INPUT_FILE' -output_folder '$OUTPUT_FOLDER' -id_params '$PARAMETERS' -ommsa 1 -threads '$THREADS'






