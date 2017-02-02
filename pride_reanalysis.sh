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
# #######################################################
# ####					Search GUI					 ####
# #######################################################
# 	java -cp SearchGUI-3.2.5.jar eu.isas.searchgui.cmd.SearchCLI -spectrum_files $INPUT_FILE -output_folder $OUTPUT_FOLDER/$SAMPLE -id_params $PARAMETERS -xtandem 0 -myrimatch 0 -ms_amanda 0 -msgf 1 -omssa 0 -comet 0 -tide 0 -andromeda 0 -threads $THREADS
# 	java -cp SearchGUI-3.2.5.jar eu.isas.searchgui.cmd.SearchCLI -spectrum_files $INPUT_FILE -output_folder $OUTPUT_FOLDER -id_params $PARAMETERS -xtandem 1 -myrimatch 1 -ms_amanda 0 -msgf 1 -omssa 1 -comet 1 -tide 0 -andromeda 0 -threads $THREADS
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
