#!/bin/bash

##############################################################
#######    Re-Analysis Pipeline for PRIDE datasets    ########
##############################################################

#                                                            #
#      re-analyses spectral data for PRIDE Project PXD       #
#       runs SearchGUI and PeptideShaker on Apocrita         #
#                                                            #

#============================================================#
# to run:
# sh reanalysis.sh PXD00xxxx SAMPLE ANALYSIS THREADS
# sh reanalysis.sh PXD003417 1 1 70
#============================================================#

#------------------------------------------------------------#
#                        Parameters                          #
#------------------------------------------------------------#

PXD=$1
SAMPLE=$2
ANALYSIS=$3
THREADS=$4

#------------------------------------------------------------#


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

echo
echo "Starting Re-Analysis Pipeline..."
echo
echo "Creating Output folder"
echo
echo
mkdir /data/home/btx157/pride_reanalysis/outputs/$PXD/
echo

#######################################################
####                    PRIDE API                  ####
#######################################################

# sh API_data.sh $PXD

############################################################

echo
echo "Starting Re-Analysis tools..."
echo
echo "Input data file: $INPUT_FILE"
echo
echo "Parameter file: /data/home/btx157/pride_reanalysis/parameters/$PXD.par"
echo
echo "Sample Name: $SAMPLE"
echo

#######################################################
####                  Search GUI                   ####
#######################################################

sh SearchGUI.sh $PXD $SAMPLE $ANALYSIS $THREADS

#######################################################
####              Peptide Shaker                   ####
#######################################################

sh PeptideShaker.sh $PXD $SAMPLE $ANALYSIS $THREADS

#######################################################
####              Data filtering                   ####
#######################################################

sh Data_Filtering.sh $PXD $SAMPLE $ANALYSIS $THREADS

#######################################################

## Print Analysis time
echo
echo "Re-analysis pipeline completed"
echo
echo "Total Run-time for this Re-Analysis:"
print_time $START
echo

## e-mail notification
mail -s "Apocrita run completed" nazrath.nawaz@yahoo.de <<< "Dataset re-analysed: $PXD

Sample: $SAMPLE

Total Run-time for this Re-Analysis: $START"

echo "email notification sent!"
echo

#######################################################

#                  ~ end of script ~                  #
