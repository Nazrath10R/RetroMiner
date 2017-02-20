#!/bin/bash 

# #######################################################
# ####              Data filtering                   ####
# #######################################################

cd /data/home/bt12048/pride_reanalysis/PeptideShaker.6/

## convert PeptideShaker results to .mzidML file
echo "converting PeptideShaker output to mzIdentML files"
echo
java -Xmx100G -cp PeptideShaker-1.14.6.jar eu.isas.peptideshaker.cmd.MzidCLI -in /data/home/bt12048/pride_reanalysis/outputs/inflammation_dataset_cyt_con_2a.cpsx -output_file /data/home/bt12048/pride_reanalysis/outputs/inflammation_dataset_cyt_con_2a.mzid -contact_first_name "Nazrath" -contact_last_name "Nawaz" -contact_email "nazrath.nawaz@yahoo.de" -contact_address "Fogg Building, London" -organization_name "QMUL" -organization_email "m.n.mohamednawaz@se12.qmul.ac.uk" -organization_address "Mile End Road, London"

# -spectrum_files /data/home/bt12048/pride_reanalysis/inputs/
echo
echo "conversion to mzIdentML successful"
echo
# #### PeptideShaker Report
tmux new-session -d -s report
tmux send-keys 'java -Xmx100G -cp PeptideShaker-1.14.6.jar eu.isas.peptideshaker.cmd.ReportCLI -in /data/home/bt12048/pride_reanalysis/outputs/inflammation_dataset_cyt_con_2a.cpsx -out_reports /data/home/bt12048/pride_reanalysis/outputs/ -reports 9'
tmux detach

# cannot be parallelised on the same file
java -Xmx100G -cp PeptideShaker-1.14.6.jar eu.isas.peptideshaker.cmd.ReportCLI -in /data/home/bt12048/pride_reanalysis/outputs/inflammation_dataset_cyt_con_2a.cpsx -out_reports /data/home/bt12048/pride_reanalysis/outputs/ -reports 1


grep $PROTEIN inflammation_inflammation_dataset_cyt_con_2a_1_Extended_PSM_Report.txt

# # #### PeptideShaker follow up
# java -Xmx100G -cp PeptideShaker-1.14.6.jar eu.isas.peptideshaker.cmd.FollowUpCLI -in /data/home/bt12048/pride_reanalysis/outputs/inflammation_dataset_cyt_con_2a.cpsx -recalibration_folder /data/home/bt12048/pride_reanalysis/outputs/recalibration

