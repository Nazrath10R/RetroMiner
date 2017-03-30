#!/bin/bash 

#------------------------------------------------------------#
#                        Variables                           #
#------------------------------------------------------------#

#### Command Line Arguments ####

PROTEIN=$1
PXD=$2
INPUT_FILE=$3
PARAMETERS=$4
EXPERIMENT=$5
SAMPLE=$6
ANALYSIS=$7
REPLICATE=$8
OUTPUT_FOLDER=$9
THREADS=${10}


# #######################################################
# ####              Data filtering                   ####
# #######################################################

cd /data/home/btx157/pride_reanalysis/PeptideShaker.6/

#### convert PeptideShaker results to .mzidML file
echo "converting PeptideShaker output to mzIdentML files"
echo
java -Xmx100G -cp PeptideShaker-1.14.6.jar eu.isas.peptideshaker.cmd.MzidCLI -in /data/home/btx157/pride_reanalysis/outputs/inflammation_dataset_cyt_con_2a.cpsx -output_file /data/home/btx157/pride_reanalysis/outputs/inflammation_dataset_cyt_con_2a.mzid -contact_first_name "Nazrath" -contact_last_name "Nawaz" -contact_email "nazrath.nawaz@yahoo.de" -contact_address "Fogg Building, London" -organization_name "QMUL" -organization_email "m.n.mohamednawaz@se12.qmul.ac.uk" -organization_address "Mile End Road, London"
echo
echo "conversion to mzIdentML successful"
echo

#### PeptideShaker Report
tmux new-session -d -s report
tmux send-keys 'java -Xmx100G -cp PeptideShaker-1.14.6.jar eu.isas.peptideshaker.cmd.ReportCLI -in /data/home/btx157/pride_reanalysis/outputs/inflammation_dataset_cyt_con_2a.cpsx -out_reports /data/home/btx157/pride_reanalysis/outputs/ -reports 9'
tmux detach

# cannot be parallelised on the same file
java -Xmx100G -cp PeptideShaker-1.14.6.jar eu.isas.peptideshaker.cmd.ReportCLI -in /data/home/btx157/pride_reanalysis/outputs/inflammation_dataset_cyt_con_2a.cpsx -out_reports /data/home/btx157/pride_reanalysis/outputs/ -reports 1

# display record for protein of interest
cd /data/home/btx157/pride_reanalysis/outputs/
grep $PROTEIN inflammation_inflammation_dataset_cyt_con_2a_1_Extended_PSM_Report.txt > ${PROTEIN}_PSM_report.txt

# grep -E "(Q9UN81)|(Q9UN82)|(O00370)" inflammation_inflammation_dataset_cyt_con_2a_1_Extended_PSM_Report.txt > Results.txt

#### PeptideShaker follow up
# java -Xmx100G -cp PeptideShaker-1.14.6.jar eu.isas.peptideshaker.cmd.FollowUpCLI -in /data/home/btx157/pride_reanalysis/outputs/inflammation_dataset_cyt_con_2a.cpsx -recalibration_folder /data/home/btx157/pride_reanalysis/outputs/recalibration

