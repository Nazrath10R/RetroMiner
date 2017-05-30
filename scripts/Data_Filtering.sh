#!/bin/bash

#############################################################
####               DATA FILTERING API                    ####
#############################################################

#                                                            #
#     Report Generation and Input/Output File deletion       #
#                                                            #

#============================================================#
# sh Data_Filtering.sh PXD003417 1
#============================================================#

#------------------------------------------------------------#
#                        Variables                           #
#------------------------------------------------------------#

#### Command Line Arguments ####

PXD=$1
SAMPLE=$2

mkdir /data/home/btx157/pride_reanalysis/reports/$PXD/

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
echo
java -Xmx100G -cp PeptideShaker-1.14.6.jar eu.isas.peptideshaker.cmd.ReportCLI -in $OUTPUT_FOLDER/$SAMPLE.cpsx -out_reports /data/home/btx157/pride_reanalysis/reports/$PXD -reports 1,3,5,6,7,8
echo
echo "Reports created!"

# remove unnecessary files
rm -r /data/home/btx157/pride_reanalysis/inputs/$PXD    # Input folder
rm -r /data/home/btx157/pride_reanalysis/outputs/$PXD   # Output folder
echo
echo "Input / Output files deleted"
echo

#                  ~ end of script ~                  #
