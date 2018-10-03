#!/bin/bash 

#############################################################
####                  PEPTIDESHAKER                      ####
#############################################################

#============================================================#
# sh test.sh PXD003417 1 16
#============================================================#

#------------------------------------------------------------#
#                        Variables                           #
#------------------------------------------------------------#

#### Command Line Arguments ####

PXD=$1
SAMPLE=$2
THREADS=$4


echo
if [ ! -f 2.cpsx ]; 
  then echo "Error: PeptideShaker did not finish running properly"
  exit 1
else
  echo
  echo "PeptideShaker successfully completed"
  echo
fi
