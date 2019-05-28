#!/bin/bash

#############################################################
####                  PEPTIDESHAKER                      ####
#############################################################

#                                                            #
#     Protein Inferance and Protein Probability scoring      #
#                                                            #

#============================================================#
# sh PeptideShaker.sh PXD003417 40
#============================================================#

DIR=`find . -name "retrominer_path.txt" -type f -exec cat {} +`
# DIR=/data/SBCS-BessantLab/naz/pride_reanalysis

#------------------------------------------------------------#
#                        Variables                           #
#------------------------------------------------------------#

#### Command Line Arguments ####

PXD=$1
THREADS=$2

# PXD=PXD003417
# THREADS=20

SAMPLE=`awk -F: '{print v $1}' $DIR/inputs/$PXD/samples.txt`
INPUT_FILE="$DIR/inputs/$PXD/"
PARAMETERS="$DIR/parameters/$PXD.par"
EXPERIMENT="$PXD"
OUTPUT_FOLDER="$DIR/outputs/$PXD"
REPLICATE=1


cd $DIR/outputs/$PXD/
unzip searchgui_out.zip


###########################################################
####                 Peptide Shaker                    ####
###########################################################

## Replicates
if [ -f $DIR/inputs/$PXD/replicates.txt ];
  
  then 
  
  cd $DIR/parameters/$PXD/
 
  # number of search engine runs
  RUNS=`ls -1 | wc -l`
  ls | cat > $DIR/inputs/$PXD/runs.txt
  SAM_REP_FILE=$DIR/inputs/$PXD/runs.txt

  ## loop for runs
  for x in $(seq 1 $RUNS); do

  RUN_NAME=`sed "$x q;d" $DIR/inputs/$PXD/runs.txt`
  INPUT_FILE_NAMES=`awk -F= '{ print $1 }' $DIR/parameters/$PXD/$RUN_NAME`

  mkdir "$OUTPUT_FOLDER/run_$x"


    # loop for SearchGUI output files
    for y in $INPUT_FILE_NAMES; do

      XTANDEM_FILE="$DIR/outputs/$PXD/$y.t.xml"
      COMET_FILE="$DIR/outputs/$PXD/$y.comet.pep.xml"

      # group appropriate SearchGUI output files into folders for each run
      mv $XTANDEM_FILE "$OUTPUT_FOLDER/run_$x/"
      mv $COMET_FILE "$OUTPUT_FOLDER/run_$x/"

    done

      SAM_REP_STRING=`sed ''"${x}"'q;d' $SAM_REP_FILE`
      SAMPLE_NUMBER="$(cut -d'_' -f3 <<< $SAM_REP_STRING )"
      REPLICATE_NUMBER="$(cut -d'_' -f5 <<< $SAM_REP_STRING )"


      ## Run PeptideShaker
      echo
      cd $DIR/PeptideShaker.6/
      echo
      nice -n 20 java -Xmx200G -cp PeptideShaker-1.14.6.jar eu.isas.peptideshaker.cmd.PeptideShakerCLI \
      -experiment $EXPERIMENT -sample $SAMPLE_NUMBER -replicate $REPLICATE_NUMBER \
      -identification_files $OUTPUT_FOLDER/run_$x/ \
      -spectrum_files $INPUT_FILE -id_params $PARAMETERS -out $OUTPUT_FOLDER/$x.cpsx \
      -threads $THREADS
      echo

      # check if PeptideShaker's output was produced
      if [ ! -f $OUTPUT_FOLDER/$x.cpsx ];
        then 
        echo "Error: PeptideShaker did not finish running properly"
        echo
        echo "for Run: $x"
      else
        echo
        echo
        echo "PeptideShaker successfully completed for Run: $x" 
        echo
        echo
      fi

  done


## no replicates - group by sample

else

  # loop through samples
  for x in $(seq 1 $SAMPLE); do

    mkdir "$OUTPUT_FOLDER/sample_$x"

    INPUT_FILE_NAMES=`awk -F= '{ print $1 }' $DIR/parameters/$PXD/${PXD}_sample_${x}_rep_0`


    ## loop through SearchGUI output files
    for y in $INPUT_FILE_NAMES; do

      XTANDEM_FILE="$DIR/outputs/$PXD/$y.t.xml"
      COMET_FILE="$DIR/outputs/$PXD/$y.comet.pep.xml"

      # group appropriate SearchGUI output files into folders for each run
      mv $XTANDEM_FILE "$OUTPUT_FOLDER/sample_$x/"
      mv $COMET_FILE "$OUTPUT_FOLDER/sample_$x/"

    done

      ## Run PeptideShaker
      echo
      cd $DIR/PeptideShaker.6/
      echo
      nice -n 20 java -Xmx200G -cp PeptideShaker-1.14.6.jar eu.isas.peptideshaker.cmd.PeptideShakerCLI -experiment $EXPERIMENT -sample $x -replicate $REPLICATE -identification_files $OUTPUT_FOLDER/sample_$x/ -spectrum_files $INPUT_FILE -id_params $PARAMETERS -out $OUTPUT_FOLDER/$x.cpsx -threads $THREADS
      echo

      if [ ! -f $OUTPUT_FOLDER/$x.cpsx ];
      	then echo "Error: PeptideShaker did not finish running properly"
             echo
             echo "Sample: $x"
      else
      	echo
        echo
      	echo "PeptideShaker successfully completed for Sample: $x" 
        echo
        echo
      fi

  done

fi


#                  ~ end of script ~                  #

