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

DIR=`find .. -name "retrominer_path.txt" -type f -exec cat {} +`
# DIR=/data/SBCS-BessantLab/naz/pride_reanalysis

#------------------------------------------------------------#
#                        Variables                           #
#------------------------------------------------------------#

#### Command Line Arguments ####

PXD=$1

if [ ! -d "$DIR/reports/$PXD/" ]; then
  mkdir $DIR/reports/$PXD/
fi

SAMPLE=`awk -F: '{print v $1}' $DIR/inputs/$PXD/samples.txt`
INPUT_FILE="$DIR/inputs/$PXD/"
PARAMETERS="$DIR/parameters/$PXD.par"
EXPERIMENT="$PXD"
OUTPUT_FOLDER="$DIR/outputs/$PXD/"
REPLICATE=1

#------------------------------------------------------------#


#######################################################
####              Data filtering                   ####
#######################################################

echo
echo "Starting Report Generation..."
cd $DIR/PeptideShaker.6/

for x in $(seq 1 $SAMPLE); do
  mkdir $DIR/reports/$PXD/$x
  # mkdir /data/scratch/btx157/$PXD/$x
  # cd /data/scratch/btx157
  echo
  java -Xmx200G -cp PeptideShaker-1.14.6.jar eu.isas.peptideshaker.cmd.ReportCLI -in $OUTPUT_FOLDER/$x.cpsx -out_reports $DIR/reports/$PXD/$x -reports 7,8
  # java -Xmx200G -cp PeptideShaker-1.14.6.jar eu.isas.peptideshaker.cmd.ReportCLI -in $OUTPUT_FOLDER/$x.cpsx -out_reports /data/scratch/btx157/$PXD/$x -reports 7,8
  # 1,3,5,6,7,8
  echo
  echo "Reports created for Sample $x"
  echo
done

# remove unnecessary files (all input and output)
# rm -r $DIR/inputs/$PXD    # Input folder
# rm -r $DIR/outputs/$PXD   # Output folder

echo
# cd $DIR/outputs/$PXD/
# cp *.cpsx /data/SBCS-BessantLab/naz/cpsx_files/$PXD/
# echo "Backed up cpsx files to SBCS-BessantLab"
# echo "Input / Output files deleted"
echo

## File size
du -sh $INPUT_FILE > $OUTPUT_FOLDER/${PXD}_size.txt


## Output checking

RESULT_FOLDERS=`find /$DIR/reports/$PXD/ -maxdepth 1 -type d -print| wc -l`

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
