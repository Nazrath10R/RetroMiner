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

DIR=/data/SBCS-BessantLab/naz

#------------------------------------------------------------#
#                        Variables                           #
#------------------------------------------------------------#

#### Command Line Arguments ####

PXD=$1

mkdir $DIR/pride_reanalysis/reports/$PXD/

SAMPLE=`awk -F: '{print v $1}' $DIR/pride_reanalysis/inputs/$PXD/samples.txt`
INPUT_FILE="$DIR/pride_reanalysis/inputs/$PXD/"
PARAMETERS="$DIR/pride_reanalysis/parameters/$PXD.par"
EXPERIMENT="$PXD"
OUTPUT_FOLDER="$DIR/pride_reanalysis/outputs/$PXD/"
REPLICATE=1

#------------------------------------------------------------#


#######################################################
####              Data filtering                   ####
#######################################################

echo
echo "Starting Report Generation..."
cd $DIR/pride_reanalysis/PeptideShaker.6/

for x in $(seq 1 $SAMPLE); do
  mkdir $DIR/pride_reanalysis/reports/$PXD/$x
  # mkdir /data/scratch/btx157/$PXD/$x
  # cd /data/scratch/btx157
  echo
  java -Xmx200G -cp PeptideShaker-1.14.6.jar eu.isas.peptideshaker.cmd.ReportCLI -in $OUTPUT_FOLDER/$x.cpsx -out_reports $DIR/pride_reanalysis/reports/$PXD/$x -reports 7,8
  # java -Xmx200G -cp PeptideShaker-1.14.6.jar eu.isas.peptideshaker.cmd.ReportCLI -in $OUTPUT_FOLDER/$x.cpsx -out_reports /data/scratch/btx157/$PXD/$x -reports 7,8
  # 1,3,5,6,7,8
  echo
  echo "Reports created for Sample $x"
  echo
done

# remove unnecessary files (all input and output)
# rm -r $DIR/pride_reanalysis/inputs/$PXD    # Input folder
# rm -r $DIR/pride_reanalysis/outputs/$PXD   # Output folder

echo
# cd $DIR/pride_reanalysis/outputs/$PXD/
# cp *.cpsx /data/SBCS-BessantLab/naz/cpsx_files/$PXD/
# echo "Backed up cpsx files to SBCS-BessantLab"
# echo "Input / Output files deleted"
echo

## Output checking

RESULT_FOLDERS=`find /$DIR/pride_reanalysis/reports/$PXD/ -maxdepth 1 -type d -print| wc -l`

if [ "$(($RESULT_FOLDERS-1))" == "$SAMPLE" ]; then
  echo
  echo -en "\033[34m"
  echo "Results produced"
  echo -en "\033[0m"
  echo
else
  echo
  echo -en "\033[31m" 
  echo "ERROR"
  echo -en "\033[0m"
  echo
fi 

echo

#                  ~ end of script ~                  #
