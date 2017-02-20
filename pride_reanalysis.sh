#!/bin/bash 

##############################################################
#######    Re-Analysis Pipeline for PRIDE datasets    ########
##############################################################

## Human proteome contains fasta file with all three ORF proteins
# Seperate analysis for projects that contain reshakable files vs
# non reshakable files


######## Variables ########
PROTEIN="Q9UN81"
PXD="PXD003406"
INPUT_FILE='/data/home/bt12048/pride_reanalysis/inputs/HUVEC_cyt_con_2a.mgf'
PARAMETERS='/data/home/bt12048/pride_reanalysis/parameters/inflammation.par'
EXPERIMENT="inflammation"
SAMPLE="inflammation_dataset_cyt_con_2a" 
ANALYSIS=2
REPLICATE=1
OUTPUT_FOLDER="/data/home/bt12048/pride_reanalysis/outputs/test"
THREADS=70


#######################################################
####                PRIDE Reshake                  ####
#######################################################

# PRIDE Reshake works for mzIdentML or PRIDE XML files

## Pride Reshake
# requires ssh -X for interactivity
# java -jar PeptideShaker-1.14.6.jar -pxAccession "PXD003411"


#######################################################
####                    PRIDE API                  ####
#######################################################



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


#######################################################
####                  Search GUI                   ####
#######################################################


#######################################################
####              Peptide Shaker                   ####
#######################################################



# #######################################################
# ####              Data filtering                   ####
# #######################################################


# #######################################################
# ####              Finish Analysis                  ####
# #######################################################


## Print Analysis time
echo
echo "Total Run-time for this Re-Analysis was:"
print_time $START
echo

## e-mail notification
mail -s "Apocrita run completed" nazrath.nawaz@yahoo.de <<< "File: $INPUT_FILE"

# #######################################################


# ## To Do:
# # come up with a way to filter results for protein of interest
# # use ProViewer to vizualise
# # automate parameters
# # Final results table


