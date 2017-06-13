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

#------------------------------------------------------------#
#                        Variables                           #
#------------------------------------------------------------#

#### Command Line Arguments ####

PXD=$1
THREADS=$2

# PXD=PXD003417
# THREADS=20

SAMPLE=`awk -F: '{print v $1}' /data/home/btx157/pride_reanalysis/inputs/$PXD/samples.txt`
INPUT_FILE="/data/home/btx157/pride_reanalysis/inputs/$PXD/"
PARAMETERS="/data/home/btx157/pride_reanalysis/parameters/$PXD.par"
EXPERIMENT="$PXD"
OUTPUT_FOLDER="/data/home/btx157/pride_reanalysis/outputs/$PXD"
REPLICATE=1


# cd /data/home/btx157/pride_reanalysis/outputs/$PXD/
# unzip searchgui_out.zip


###########################################################
####                 Peptide Shaker                    ####
###########################################################

## Replicates
if [ -f /data/home/btx157/pride_reanalysis/inputs/$PXD/replicates.txt ];
  
  then 
  
  cd /data/home/btx157/pride_reanalysis/parameters/$PXD/
 
  # number of search engine runs
  RUNS=`ls -1 | wc -l`
  ls | cat > /data/home/btx157/pride_reanalysis/inputs/$PXD/runs.txt

  ## loop for runs
  for x in $(seq 1 $RUNS); do

  RUN_NAME=`sed "$x q;d" /data/home/btx157/pride_reanalysis/inputs/$PXD/runs.txt`
  INPUT_FILE_NAMES=`awk -F= '{ print $1 }' $RUN_NAME`

  mkdir "$OUTPUT_FOLDER/run_$x"


    # loop for SearchGUI output files
    for y in $INPUT_FILE_NAMES; do

      XTANDEM_FILE="/data/home/btx157/pride_reanalysis/outputs/$PXD/$y.t.xml"
      COMET_FILE="/data/home/btx157/pride_reanalysis/outputs/$PXD/$y.comet.pep.xml"

      # group appropriate SearchGUI output files into folders for each run
      mv $XTANDEM_FILE "$OUTPUT_FOLDER/run_$x/"
      mv $COMET_FILE "$OUTPUT_FOLDER/run_$x/"

    done

      ## Run PeptideShaker
      echo
      cd /data/home/btx157/pride_reanalysis/PeptideShaker.6/
      echo
      java -Xmx100G -cp PeptideShaker-1.14.6.jar eu.isas.peptideshaker.cmd.PeptideShakerCLI -experiment $EXPERIMENT -sample $x -replicate $REPLICATE -identification_files $OUTPUT_FOLDER/run_$x/ -spectrum_files $INPUT_FILE -id_params $PARAMETERS -out $OUTPUT_FOLDER/$x.cpsx -threads $THREADS
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

    INPUT_FILE_NAMES=`awk -F= '{ print $1 }' /data/home/btx157/pride_reanalysis/parameters/$PXD/${PXD}_sample_${x}_rep_0`


    ## loop through SearchGUI output files
    for y in $INPUT_FILE_NAMES; do

      XTANDEM_FILE="/data/home/btx157/pride_reanalysis/outputs/$PXD/$y.t.xml"
      COMET_FILE="/data/home/btx157/pride_reanalysis/outputs/$PXD/$y.comet.pep.xml"

      # group appropriate SearchGUI output files into folders for each run
      mv $XTANDEM_FILE "$OUTPUT_FOLDER/sample_$x/"
      mv $COMET_FILE "$OUTPUT_FOLDER/sample_$x/"

    done

      ## Run PeptideShaker
      echo
      cd /data/home/btx157/pride_reanalysis/PeptideShaker.6/
      echo
      java -Xmx100G -cp PeptideShaker-1.14.6.jar eu.isas.peptideshaker.cmd.PeptideShakerCLI -experiment $EXPERIMENT -sample $x -replicate $REPLICATE -identification_files $OUTPUT_FOLDER/sample_$x/ -spectrum_files $INPUT_FILE -id_params $PARAMETERS -out $OUTPUT_FOLDER/$x.cpsx -threads $THREADS
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

