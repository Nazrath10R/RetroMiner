#!/bin/bash 

PROTEIN=$1
PXD=$2
INPUT_FILE=$3
PARAMETERS=$4
EXPERIMENT=$5
SAMPLE=$6
ANALYSIS=$7
REPLICATE=$8
OUTPUT_FOLDER=$9
NODES=${10}


ssh apoc6 'cd /data/home/btx157/pride_reanalysis/scripts/ ;
sh test.sh "Q9UN81" "PXD003406" "/data/home/btx157/pride_reanalysis/inputs/HUVEC_cyt_con_2a.mgf" "/data/home/btx157/pride_reanalysis/parameters/inflammation.par" "inflammation" "inflammation_dataset_cyt_con_2a" 2 1 "/data/home/btx157/pride_reanalysis/outputs/test" 2'







