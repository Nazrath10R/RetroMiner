#!/bin/bash

#############################################################
####               DATA FILTERING API                    ####
#############################################################

#                                                            #
#     Report Generation and Input/Output File deletion       #
#                                                            #

#============================================================#
# sh Data_Filtering.sh PXD003417
#============================================================#

#------------------------------------------------------------#
#                        Variables                           #
#------------------------------------------------------------#

#### Command Line Arguments ####

PXD=$1

mkdir /data/home/btx157/pride_reanalysis/reports/$PXD/

SAMPLE=`awk -F: '{print v $1}' /data/home/btx157/pride_reanalysis/inputs/$PXD/samples.txt`
INPUT_FILE="/data/home/btx157/pride_reanalysis/inputs/$PXD/"
PARAMETERS="/data/home/btx157/pride_reanalysis/parameters/$PXD.par"
EXPERIMENT="$PXD"
OUTPUT_FOLDER="/data/home/btx157/pride_reanalysis/outputs/$PXD/"
REPLICATE=1

#------------------------------------------------------------#


#######################################################
####              Data filtering                   ####
#######################################################

echo
echo "Starting Report Generation..."
cd /data/home/btx157/pride_reanalysis/PeptideShaker.6/

for x in $(seq 1 $SAMPLE); do
  mkdir /data/home/btx157/pride_reanalysis/reports/$PXD/$x
  echo
  java -Xmx100G -cp PeptideShaker-1.14.6.jar eu.isas.peptideshaker.cmd.ReportCLI -in $OUTPUT_FOLDER/$x.cpsx -out_reports /data/home/btx157/pride_reanalysis/reports/$PXD/$x -reports 1,3,5,6,7,8
  echo
  echo "Reports created for Sample $x"
  echo
done

# remove unnecessary files (all input and output)
# rm -r /data/home/btx157/pride_reanalysis/inputs/$PXD    # Input folder
# rm -r /data/home/btx157/pride_reanalysis/outputs/$PXD   # Output folder
echo
echo "Input / Output files deleted"
echo

#                  ~ end of script ~                  #
