#!/bin/bash 

##############################################################
#######    Re-Analysis Pipeline for PRIDE datasets    ########
##############################################################

## PRIDE - https://www.ebi.ac.uk/pride/archive/
## PRIDE API - https://www.ebi.ac.uk/pride/ws/archive/ 
## Proteins of Interest: Q9UN81 (ORF1p), O00370 (ORF2p), Q9UN82 (ORF0)
## Human proteome contains fasta file with all three ORF proteins


######## Variables ########

INPUT_FILE='/data/home/bt12048/pride_reanalysis/inputs/HUVEC_cyt_con_1a_2.mgf'
PARAMETERS='/data/home/bt12048/pride_reanalysis/parameters/inflammation.par'
EXPERIMENT="inflammation" 
SAMPLE="inflammation_dataset_1" 
ANALYSIS=2
REPLICATE=1
OUTPUT_FOLDER="/data/home/bt12048/pride_reanalysis/outputs"
THREADS=36

############################################################

echo
echo "Starting Re-Analysis Pipeline"
echo
echo "Input data file:"
echo "$INPUT_FILE"
echo
echo "Parameter file:"
echo "PARAMETERS"
echo
echo "Sample Name:"
echo "$SAMPLE"
echo
echo "Replicates: $REPLICATE"
echo
echo "Creating Output folder"
echo

function check_if_file_exists {
  if [ -s $OUTPUT_FOLDER/$SAMPLE ]; then 
    echo "*** File Created: $1"
  else
    echo "*** ERROR: File Does Not exist: $1"
    exit 1
  fi
}

mkdir $OUTPUT_FOLDER/$SAMPLE
# #######################################################
# ####					Search GUI					 ####
# #######################################################


# cd /data/home/bt12048/pride_reanalysis/SearchGUI.5/

# if [ "$ANALYSIS" -eq 1 ]; then
# 	echo
# 	echo "Starting SearchGUI for MS-GF+ only..."
# 	echo
# 	bash loading.sh
# 	java -cp SearchGUI-3.2.5.jar eu.isas.searchgui.cmd.SearchCLI -spectrum_files $INPUT_FILE -output_folder $OUTPUT_FOLDER/$SAMPLE -id_params $PARAMETERS -xtandem 0 -myrimatch 0 -ms_amanda 0 -msgf 1 -omssa 0 -comet 0 -tide 0 -andromeda 0 -threads $THREADS
# fi

# if [ "$ANALYSIS" -eq 2 ]; then
# 	echo
# 	echo "Starting SearchGUI for multiple Search Engines..."
# 	echo
# 	echo "X! Tandem"
# 	echo "MyriMatch"
# 	echo "MS Amanda"
# 	echo "MS-GF+"
# 	echo "OMSSA"
# 	echo "Comet"
# 	# echo "Andromeda"
# 	echo
# 	bash loading.sh
# 	echo
# 	java -cp SearchGUI-3.2.5.jar eu.isas.searchgui.cmd.SearchCLI -spectrum_files $INPUT_FILE -output_folder $OUTPUT_FOLDER -id_params $PARAMETERS -xtandem 1 -myrimatch 1 -ms_amanda 0 -msgf 1 -omssa 1 -comet 1 -tide 0 -andromeda 0 -threads $THREADS
# fi

# ## check if output was produced
# if [ ! -f /data/home/bt12048/pride_reanalysis/outputs/searchgui_out.zip ]; 
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


# #######################################################
# #### 				Peptide Shaker 				   ####
# #######################################################

# cd /data/home/bt12048/pride_reanalysis/PeptideShaker.6/

#  java -cp ./PeptideShaker-1.14.6/PeptideShaker-1.14.6.jar eu.isas.peptideshaker.cmd.PeptideShakerCLI 
#  -experiment $EXPERIMENT -sample $SAMPLE -replicate $REPLICATE
#  -identification_files $OUTPUT_FOLDER 
#  -spectrum_files $OUTPUT_FOLDER 
#  -id_params $PARAMETERS 
#  -out $OUTPUT_FOLDER/$SAMPLE.cpsx
#  -threads $THREADS


## Print Analysis time
echo
echo "Total Run-time for this Re-Analysis was:"
print_time $START
echo





#######################################################

#### Redundant Code

# #### Search GUI ####

#  java -cp SearchGUI-3.2.5.jar eu.isas.searchgui.cmd.SearchCLI 
#  -spectrum_files ./mgf/before_last_batch/NHDF_ne_stim_1a_4.mgf -
#  output_folder ./output/before_last_batch -id_params inflammation.par 
#  -xtandem 1 -myrimatch 1 -ms_amanda 0 -msgf 1 -omssa 1 -comet 1 -andromeda 0 
#  -threads 76

# #### Peptide Shaker ####

#  java -cp PeptideShaker-1.14.6.jar eu.isas.peptideshaker.cmd.PeptideShakerCLI 
#  -experiment inflammation -sample before_last_batch -replicate 1 
#  -identification_files "/data/home/bt12048/search_gui/SearchGUI-3.2 2.5/output/before_last_batch/" 
#  -spectrum_files "/data/home/bt12048/search_gui/SearchGUI-3.2 2.5/mgf/before_last_batch" 
#  -id_params "/data/home/bt12048/search_gui/SearchGUI-3.2 2.5/inflammation.par" 
#  -out "/data/home/bt12048/search_gui/SearchGUI-3.2 2.5/output/results.cpsx"
#  -threads 74















