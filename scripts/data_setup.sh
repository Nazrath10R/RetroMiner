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

DIR=/data/SBCS-BessantLab/naz/pride_reanalysis
SCRIPTS=$DIR/pride_reanalysis/scripts/src

#============================================================#

PXD=$1

#------------------------------------------------------------#
#                                                            #
#                 Data and Parameters Set Up                 # 
#                                                            #
#------------------------------------------------------------#

#######################################################
####          PRIDE parameters extraction          ####
#######################################################

sh $SCRIPTS/API_parameters.sh $PXD


#######################################################
####            PRIDE API Data download            ####
#######################################################

sh $SCRIPTS/API_data.sh $PXD

#######################################################
####          Experimental Design parsing          ####
#######################################################

## EDIT TABLE 
# module load R/3.3.2
# Rscript experimental_design_parser.R --PXD "$PXD"
# Rscript experimental_design_parser.R --PXD "PXD001694"

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
