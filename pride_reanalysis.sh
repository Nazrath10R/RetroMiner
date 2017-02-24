#!/bin/bash 

##############################################################
#######    Re-Analysis Pipeline for PRIDE datasets    ########
##############################################################

#============================================================#
# sh pride_reanalysis.sh "Q9UN81" "PXD003406" '/data/home/btx157/pride_reanalysis/inputs/HUVEC_cyt_con_2a.mgf' '/data/home/btx157/pride_reanalysis/parameters/inflammation.par' "inflammation" "inflammation_dataset_cyt_con_2a" 2 1 "/data/home/btx157/pride_reanalysis/outputs/test" 70
#============================================================#


#------------------------------------------------------------#
#                        Variables                           #
#------------------------------------------------------------#

#### Hard-coded Arguments ####

# PROTEIN="Q9UN81"
# PXD="PXD003406"
# INPUT_FILE='/data/home/btx157/pride_reanalysis/inputs/HUVEC_cyt_con_2a.mgf'
# PARAMETERS='/data/home/btx157/pride_reanalysis/parameters/inflammation.par'
# EXPERIMENT="inflammation"
# SAMPLE="inflammation_dataset_cyt_con_2a" 
# ANALYSIS=2
# REPLICATE=1
# OUTPUT_FOLDER="/data/home/btx157/pride_reanalysis/outputs/test"
# THREADS=70


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

echo
echo
echo Protein: $PROTEIN
echo
echo PXD: $PXD
echo
echo INPUT_FILE: $INPUT_FILE
echo
echo PARAMETERS: $PARAMETERS
echo
echo EXPERIMENT: $EXPERIMENT
echo
echo SAMPLE: $SAMPLE
echo
echo ANALYSIS: $ANALYSIS
echo
echo REPLICATE: $REPLICATE
echo
echo OUTPUT_FOLDER: $OUTPUT_FOLDER
echo
echo THREADS: $THREADS
echo


function check_if_file_exists {
  if [ -s $OUTPUT_FOLDER/$SAMPLE ]; then 
    echo "*** File Created: $1"
  else
    echo "*** ERROR: File Does Not exist: $1"
    exit 1
  fi
}

echo
echo "Starting Re-Analysis Pipeline..."
echo
echo "Creating Output folder"
echo
mkdir $OUTPUT_FOLDER/$SAMPLE
echo

############################################################

#### Calculate Total runtime ####

function print_time {
  END=$(date +%s)
  DIFF=$(( $END - $1 ))
  dd=$(echo "$DIFF/86400" | bc)
  dt2=$(echo "$DIFF-86400*$dd" | bc)
  dh=$(echo "$dt2/3600" | bc)
  dt3=$(echo "$dt2-3600*$dh" | bc)
  dm=$(echo "$dt3/60" | bc)
  ds=$(echo "$dt3-60*$dm" | bc)
  if [ $dd -gt 0 ]; then
    echo " ${dd} days and ${dh} hours."
  elif [ $dh -gt 0 ]; then
    echo " ${dh} hours and ${dm} minutes."
  elif [ $dm -gt 0 ]; then
    echo " ${dm} minutes and ${ds} seconds."
  else
    echo " ${ds} seconds."
  fi
}

## Start clock time
START=$(date +%s)

############################################################

# sh test.sh "Q9UN81" "PXD003406" '/data/home/btx157/pride_reanalysis/inputs/HUVEC_cyt_con_2a.mgf' '/data/home/btx157/pride_reanalysis/parameters/inflammation.par' "inflammation" "inflammation_dataset_cyt_con_2a" 2 1 "/data/home/btx157/pride_reanalysis/outputs/test" 70

#######################################################
####                    PRIDE API                  ####
#######################################################


sh API.sh "Q9UN81" "PXD003406" '/data/home/btx157/pride_reanalysis/inputs/HUVEC_cyt_con_2a.mgf' '/data/home/btx157/pride_reanalysis/parameters/inflammation.par' "inflammation" "inflammation_dataset_cyt_con_2a" 2 1 "/data/home/btx157/pride_reanalysis/outputs/test" 70


#######################################################
####                PRIDE Reshake                  ####
#######################################################

# PRIDE Reshake works for mzIdentML or PRIDE XML files

## Pride Reshake
# requires ssh -X for interactivity
# java -jar PeptideShaker-1.14.6.jar -pxAccession "PXD003411"


#######################################################
####                  Search GUI                   ####
#######################################################

# node parallelisation

sh SearchGUI.sh "Q9UN81" "PXD003406" '/data/home/btx157/pride_reanalysis/inputs/HUVEC_cyt_con_2a.mgf' '/data/home/btx157/pride_reanalysis/parameters/inflammation.par' "inflammation" "inflammation_dataset_cyt_con_2a" 2 1 "/data/home/btx157/pride_reanalysis/outputs/test" 40

# need to wait for all outputs to be produced before starting PeptideShaker

#######################################################
####              Peptide Shaker                   ####
#######################################################

sh PeptideShaker.sh "Q9UN81" "PXD003406" '/data/home/btx157/pride_reanalysis/inputs/HUVEC_cyt_con_2a.mgf' '/data/home/btx157/pride_reanalysis/parameters/inflammation.par' "inflammation" "inflammation_dataset_cyt_con_2a" 2 1 "/data/home/btx157/pride_reanalysis/outputs/test" 70

#######################################################
####              Data filtering                   ####
#######################################################

sh Data_Filtering.sh "Q9UN81" "PXD003406" '/data/home/btx157/pride_reanalysis/inputs/HUVEC_cyt_con_2a.mgf' '/data/home/btx157/pride_reanalysis/parameters/inflammation.par' "inflammation" "inflammation_dataset_cyt_con_2a" 2 1 "/data/home/btx157/pride_reanalysis/outputs/test" 70

#######################################################
####              Finish Analysis                  ####
#######################################################

## Print Analysis time
echo
echo "Total Run-time for this Re-Analysis was:"
print_time $START
echo

## e-mail notification
mail -s "Apocrita run completed" nazrath.nawaz@yahoo.de <<< "File: $INPUT_FILE"

########################################################

