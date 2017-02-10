#!/bin/bash 

##############################################################
#######                Set Parameters                 ########
##############################################################

## Path settings (temp and log files)
# java -cp PeptideShaker-X.Y.Z.jar eu.isas.peptideshaker.cmd.PathSettingsCLI -temp_folder /data/home/bt12048/pride_reanalysis/temp -log /data/home/bt12048/pride_reanalysis/logs


######## Variables ########

SAMPLE="inflammation_dataset_cyt_con_2a" 
DATABASE=/data/home/bt12048/pride_reanalysis/human_proteome/human_proteome_2_concatenated_target_decoy.fasta 
PRECURSOR_TOLERANCE=25 
PREC_UNIT=1
FRAGMENT_TOLERANCE=20
FRAG_UNIT=1
DIGESTION=0
ENZYME='Trypsin' 
SPECIFICITY=0 
MAX_MISSED_CLEAVAGES=2 
FIXED_MODIFICATIONS="Carbamidomethylation of C"
VARIABLE_MODIFICATIONS="Oxidation of M, Acetylation of protein N-term"
OUTPUT_FOLDER=/data/home/bt12048/pride_reanalysis/parameters/

#######################################################

cd /data/home/bt12048/pride_reanalysis/SearchGUI.5/

## Create Parameter file
java -cp SearchGUI-3.2.5.jar eu.isas.searchgui.cmd.IdentificationParametersCLI -out $OUTPUT_FOLDER/$SAMPLE.par -db $DATABASE -prec_tol $PRECURSOR_TOLERANCE -prec_ppm $PREC_UNIT -frag_tol $FRAGMENT_TOLERANCE -frag_ppm $FRAG_UNIT-digestion $DIGESTION -enzyme $ENZYME -specificity $SPECIFICITY -mc $MAX_MISSED_CLEAVAGES -fixed_mods $FIXED_MODIFICATIONS -variable_mods $VARIABLE_MODIFICATIONS

## optional
# -min_charge -max_charge -fi -ri -min_isotope -max_isotope
# -id_params  An identification parameters file to modify (optional).
# -mods


