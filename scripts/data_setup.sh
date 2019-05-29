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
# sh data_setup.sh PXD00xxxx
# sh data_setup.sh PXD003417
#============================================================#

DIR=`find .. -name "retrominer_path.txt" -type f -exec cat {} +`
# DIR=/data/SBCS-BessantLab/naz/pride_reanalysis

SCRIPTS=$DIR/scripts/src
ARCHIVE=$DIR/z_archive

#============================================================#

PXD=$1
# --pride or -p for pride.mgf files


#------------------------------------------------------------#

#### Display Usage ####

display_usage() {
  echo  
  echo -e "Run:\nsh data_setup.sh [PXD00xxxx]"
  echo
  echo -e "PXD00xxxx = PRIDE Dataset identifier"
  echo
  echo -e "optional download arguments:"
  echo
  echo -e "--pride or -p for curated pride.mgf files\n   --raw   or -r for RAW files\n \
  --tab   or -t for mztab files"
  echo
} 
 
# check whether user had supplied -h or --help . If yes display usage 
if [[ ( $1 == "--help") ||  $1 == "-h" ]] 
then 
  display_usage
  exit 0
fi 

# if less than two arguments supplied, display usage 
if [[ ( $1 != "--help") &&  $1 != "-h" && ( $1 != "--interactive") && 
  $1 != "-i" && $# -le 0 ]] 
then 
  display_usage
  exit 1
fi 

#------------------------------------------------------------#


#------------------------------------------------------------#
#                                                            #
#                 Data and Parameters Set Up                 # 
#                                                            #
#------------------------------------------------------------#

#######################################################
####          PRIDE parameters extraction          ####
#######################################################

# sh $SCRIPTS/API_parameters.sh $PXD


#######################################################
####            PRIDE API Data download            ####
#######################################################

sh $SCRIPTS/API_data.sh $PXD $2

#######################################################
####          Experimental Design parsing          ####
#######################################################

## EDIT TABLE 
# module load R/3.3.2
# Rscript experimental_design_parser.R --PXD "$PXD"
# Rscript experimental_design_parser.R --PXD "PXD001694"

cp $DIR/parameters/experimental_design.txt $ARCHIVE/exp_design/
mv $ARCHIVE/exp_design/experimental_design.txt "$ARCHIVE/exp_design/experimental_design.txt.$(date)"

echo
Rscript $SCRIPTS/add_exp_design.R --PXD "$PXD"
echo
echo "Experimental design template added"
echo

#######################################################
####                Create log files               ####
#######################################################

cd $DIR/logs
mkdir $PXD
cd $PXD

touch ${PXD}_sg_log.txt
touch ${PXD}_ps_log.txt
touch ${PXD}_df_log.txt

cd $DIR/scripts


#------------------------------------------------------------#

#                  ~ end of script ~                  #
