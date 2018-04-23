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
# sh retrominer.sh PXD00xxxx ANALYSIS THREADS NICE
# sh retrominer.sh PXD003417 1 20 10
#============================================================#

DIR=/data/SBCS-BessantLab/naz

#------------------------------------------------------------#
#                        Parameters                          #
#------------------------------------------------------------#

PXD=$1
ANALYSIS=$2
THREADS=$3

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
cat logo.txt
echo
echo "Starting Re-Analysis Pipeline..."
echo
echo
echo "Starting Re-Analysis tools..."
echo
echo "Parameter file: $DIR/pride_reanalysis/parameters/$PXD.par"
# echo
# echo "Sample Name: $SAMPLE"
echo
# sleep 2
echo "Please wait for RetroMiner to start..."
echo
sh loading.sh 4
echo
# touch 
# touch 
# touch 
#######################################################
####                  Search GUI                   ####
#######################################################

echo -en "\033[34m"
echo "SearchGUI running..."
echo -en "\033[0m"
echo
# nice -n 10 sh SearchGUI.sh $PXD $ANALYSIS $THREADS > $DIR/pride_reanalysis/logs/$PXD/${PXD}_sg_log.txt
nice -n 20 sh SearchGUI.sh $PXD $ANALYSIS $THREADS |& tee $DIR/pride_reanalysis/logs/$PXD/${PXD}_sg_log.txt
echo

#######################################################
####              Peptide Shaker                   ####
#######################################################

echo -en "\033[34m"
echo "PeptideShaker running..."
echo -en "\033[0m"
# nice -n 10 sh PeptideShaker.sh $PXD $THREADS > $DIR/pride_reanalysis/logs/$PXD/${PXD}_ps_log.txt
nice -n 20 sh PeptideShaker.sh $PXD $THREADS |& tee $DIR/pride_reanalysis/logs/$PXD/${PXD}_ps_log.txt
echo

#######################################################
####              Data filtering                   ####
#######################################################

echo -en "\033[34m"
echo "Data filtering running..."
echo -en "\033[0m"
# nice -n 10 sh Data_Filtering.sh $PXD > $DIR/pride_reanalysis/logs/$PXD/${PXD}_df_log.txt
nice -n 20 sh Data_Filtering.sh $PXD |& tee $DIR/pride_reanalysis/logs/$PXD/${PXD}_df_log.txt
echo

#######################################################

## Print Analysis time
echo
echo "Re-analysis pipeline completed"
echo
echo "$PXD" 
echo
TIME=`print_time $START`
echo "Total Run-time for this Re-Analysis:"
echo $TIME
echo

## e-mail notification
mail -s "Apocrita run completed" nazrath.nawaz@yahoo.de <<< "Dataset re-analysed: $PXD

Total Run-time for this Re-Analysis: $TIME"

echo "email notification sent!"
echo

#######################################################

#                  ~ end of script ~                  #
