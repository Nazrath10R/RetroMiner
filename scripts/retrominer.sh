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
# sh retrominer.sh PXD00xxxx ANALYSIS THREADS 
# sh retrominer.sh PXD000651 1 20
#============================================================#

DIR=/data/SBCS-BessantLab/naz/pride_reanalysis
SCRIPTS=$DIR/scripts/src

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
echo "Parameter file: $DIR/parameters/$PXD.par"
# echo
# echo "Sample Name: $SAMPLE"
echo
# sleep 2
echo "Please wait for RetroMiner to start..."
echo
sh $SCRIPTS/loading.sh 4
echo

#######################################################
####                  Search GUI                   ####
#######################################################

echo -en "\033[34m"
echo "SearchGUI running..."
echo -en "\033[0m"
echo
# nice -n 10 sh SearchGUI.sh $PXD $ANALYSIS $THREADS > $DIR/logs/$PXD/${PXD}_sg_log.txt
nice -n 20 sh $SCRIPTS/SearchGUI.sh $PXD $ANALYSIS $THREADS |& tee $DIR/logs/$PXD/${PXD}_sg_log.txt
echo


if ls $DIR/outputs/$PXD/*xml 1> /dev/null 2>&1; then
    echo "SG check passed"
else
    echo "SG check failed"
    exit 1
fi

#######################################################
####              Peptide Shaker                   ####
#######################################################

echo -en "\033[34m"
echo "PeptideShaker running..."
echo -en "\033[0m"
# nice -n 10 sh PeptideShaker.sh $PXD $THREADS > $DIR/logs/$PXD/${PXD}_ps_log.txt
nice -n 20 sh $SCRIPTS/PeptideShaker.sh $PXD $THREADS |& tee $DIR/logs/$PXD/${PXD}_ps_log.txt
echo

if ls $DIR/outputs/$PXD/*cpsx 1> /dev/null 2>&1; then
    echo "PS check passed"
else
    echo "PS check failed"
    exit 1
fi


#######################################################
####              Data filtering                   ####
#######################################################

echo -en "\033[34m"
echo "Data filtering running..."
echo -en "\033[0m"
# nice -n 10 sh Data_Filtering.sh $PXD > $DIR/logs/$PXD/${PXD}_df_log.txt
nice -n 20 sh $SCRIPTS/Data_Filtering.sh $PXD |& tee $DIR/logs/$PXD/${PXD}_df_log.txt
echo


#######################################################
####               Custom Export                   ####
#######################################################

echo -en "\033[34m"
echo "Custom RT protein result extraction..."
echo -en "\033[0m"
sh $SCRIPTS/Custom_Report.sh $PXD
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
Rscript $SCRIPTS/log.R --PXD "$PXD" --IN "retromined"

## e-mail notification
mail -s "Apocrita run completed" nazrath.nawaz@yahoo.de <<< "Dataset re-analysed: $PXD

Total Run-time for this Re-Analysis: $TIME"

echo "email notification sent!"
echo

#######################################################

#                  ~ end of script ~                  #
