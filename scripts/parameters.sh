#!/bin/bash

##############################################################
#######                  PARAMETERS                   ########
##############################################################

#                                                            #
#                 Search engine Parameters                   #
#                                                            #

#============================================================#
# sh parameters.sh PXD003417
#============================================================#


DIR=`find .. -name "retrominer_path.txt" -type f -exec cat {} +`
# DIR=/data/SBCS-BessantLab/naz/pride_reanalysis

SCRIPTS=$DIR/scripts/src

#------------------------------------------------------------#
#                        Variables                           #
#------------------------------------------------------------#

# mouse - human_and_mouse_concatenated_target_decoy.fasta 
# SAMPLE=$1     #PXD
# DATABASE=/data/home/btx157/pride_reanalysis/human_proteome/human_variants_proteome_concatenated_target_decoy.fasta
# PRECURSOR_TOLERANCE=25
# PREC_UNIT=1
# FRAGMENT_TOLERANCE=20
# FRAG_UNIT=1
# DIGESTION=0
# ENZYME='Trypsin'
# SPECIFICITY=0
# MAX_MISSED_CLEAVAGES=2
# FIXED_MODIFICATIONS="Carbamidomethylation of C"
# VARIABLE_MODIFICATIONS="Oxidation of M, Acetylation of protein N-term"
# OUTPUT_FOLDER=/data/SBCS-BessantLab/naz/pride_reanalysis/parameters/
# 1 ppm, 0 Da
# VARIABLE_MODIFICATIONS="Oxidation of M, Lysine 13C(6) 15N(2), Arginine 13C(6) 15N(4)"
# VARIABLE_MODIFICATIONS="Acetylation of peptide N-term, Acetylation of K, 
# Deamidation of N, Deamidation of Q, Amidation of the protein C-term, Pyrolidone from Q, 
# Phosphorylation of S, Phosphorylation of T, Phosphorylation of Y
# Propionamide of C, Carbamilation of K, Carbamilation of protein N-term, iTRAQ 4-plex of K, Methylthio of C"

#------------------------------------------------------------#

SAMPLE=$1 	#PXD
DATABASE=$DIR/human_proteome/human_variants_proteome_concatenated_target_decoy.fasta
PRECURSOR_TOLERANCE=10
PREC_UNIT=1
FRAGMENT_TOLERANCE=0.5
FRAG_UNIT=0
DIGESTION=0
ENZYME='Trypsin'
SPECIFICITY=0
MAX_MISSED_CLEAVAGES=2
FIXED_MODIFICATIONS="Carbamidomethylation of C, Oxidation of M, Acetylation of K"
VARIABLE_MODIFICATIONS="Acetylation of peptide N-term, Pyrolidone from Q"
OUTPUT_FOLDER=$DIR/parameters/

#------------------------------------------------------------#


cd $DIR/SearchGUI.5/

## Create Parameter file
java -cp SearchGUI-3.2.5.jar eu.isas.searchgui.cmd.IdentificationParametersCLI -out $OUTPUT_FOLDER/$SAMPLE.par -db $DATABASE \
-prec_tol $PRECURSOR_TOLERANCE -prec_ppm $PREC_UNIT -frag_tol $FRAGMENT_TOLERANCE -frag_ppm $FRAG_UNIT \
-digestion $DIGESTION -enzyme $ENZYME -specificity $SPECIFICITY -mc $MAX_MISSED_CLEAVAGES \
-fixed_mods "$FIXED_MODIFICATIONS" -variable_mods "$VARIABLE_MODIFICATIONS"


## optional
# -min_charge -max_charge -fi -ri -min_isotope -max_isotope
# -id_params  An identification parameters file to modify (optional).
# -mods

Rscript $SCRIPTS/log.R --PXD "$SAMPLE" --IN "parametered"


#                  ~ end of script ~                  #

