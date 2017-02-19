#!/bin/bash 

##############################################################
#######    Re-Analysis Pipeline for PRIDE datasets    ########
##############################################################

## Human proteome contains fasta file with all three ORF proteins
# Seperate analysis for projects that contain reshakable files vs
# non reshakable files

######## Variables ########

PROTEIN="Q9UN81"
PXD="PXD003406"
INPUT_FILE='/data/home/bt12048/pride_reanalysis/inputs/HUVEC_cyt_con_2a.mgf'
PARAMETERS='/data/home/bt12048/pride_reanalysis/parameters/inflammation.par'
EXPERIMENT="inflammation"
SAMPLE="inflammation_dataset_cyt_con_2a" 
ANALYSIS=2
REPLICATE=1
OUTPUT_FOLDER="/data/home/bt12048/pride_reanalysis/outputs/test"
THREADS=70


#######################################################
####                PRIDE Reshake                  ####
#######################################################

# PRIDE Reshake works for mzIdentML or PRIDE XML files

## Pride Reshake
# requires ssh -X for interactivity
# java -jar PeptideShaker-1.14.6.jar -pxAccession "PXD003411"


#######################################################
####					PRIDE API				   ####
#######################################################

## PRIDE - https://www.ebi.ac.uk/pride/archive/
## PRIDE API - https://www.ebi.ac.uk/pride/ws/archive/ 
##### Proteins of Interest: Q9UN81 (ORF1p), O00370 (ORF2p), Q9UN82 (ORF0)
## Example dataset PXD003411


#### Search PRIDE datasets for protein of interest ####

## Find Projects matching Protein of Interest
echo
echo "Starting Re-Analysis Pipeline..."
echo
echo "Creating Output folder"
echo
sleep 3

function check_if_file_exists {
  if [ -s $OUTPUT_FOLDER/$SAMPLE ]; then 
    echo "*** File Created: $1"
  else
    echo "*** ERROR: File Does Not exist: $1"
    exit 1
  fi
}

mkdir $OUTPUT_FOLDER/$SAMPLE
echo
echo "Fetching Data from PRIDE through RESTful API"
echo
echo "Retrieving all Projects containing Protein: $PROTEIN"
echo
sleep 6

## protein Q9UN81
## Search all Projects containing protein: Q9UN81
cd /data/home/bt12048/pride_reanalysis/inputs
echo
echo "Identifiying Projects..."
echo
wget https://www.ebi.ac.uk:443/pride/ws/archive/project/list?query=Q9UN81&order=desc
echo
echo
echo
echo
echo "Projects containing Q9UN81 identified"
echo
echo "Project Accession numbers:"
echo
grep -o "PXD[0-9][0-9][0-9][0-9][0-9][0-9]" list?query=Q9UN81
echo
grep -o "PXD[0-9][0-9][0-9][0-9][0-9][0-9]" list?query=Q9UN81 > pxd_list.txt
sleep 8

## Identify Array for Project 1
echo
echo "Retrieving protein identification assay for project 1 and protein: Q9UN81"
echo 
wget http://www.ebi.ac.uk:80/pride/ws/archive/protein/list/project/PXD003406/protein/Q9UN81
echo
echo
echo
sleep 8

## Retrieve Array Acession number
echo "Identifying Arrays..."
echo
grep -o "assayAccession.:.[0-9]*" Q9UN81 > assay_accession.txt
sed -i -e 's/assayAccession.:.//g' assay_accession.txt
echo
echo "Arrays identified"
echo
echo Array Accession number: "$(cat assay_accession.txt)"
echo
echo
sleep 8

## Identify Array data files

# Retrieve all data files for Project 1
# echo "Project 1 and Array 1"
# echo
# wget http://www.ebi.ac.uk:80/pride/ws/archive/file/list/project/PXD003411
# echo

## Download Data files for Array 60693
echo
echo "Starting to Download Data files for Array 1"
echo
echo
wget https://www.ebi.ac.uk:443/pride/ws/archive/file/list/assay/60693

echo
echo
echo
grep -o "mgf...downloadLink...ftp.*mgf" 60693 > downloadLink.sh
sed -i -e 's/mgf","downloadLink":"/wget /g' downloadLink.sh
sh downloadLink.sh
echo
echo
echo "Download successful"
echo

# remove unnecessary files
echo "removing temp files..."
rm Q9UN81
# rm PXD003411
rm 60693
rm list?query=Q9UN81
rm assay_accession.txt
rm downloadLink.sh
rm pxd_list.txt

echo
echo "Files Downloaded:"
echo
ls
echo
sleep 8


## Search PRIDE datasets for project of interest
## Search PRIDE datasets for biomarker of interest
echo
echo
echo "Retrieving Data from PRIDE successful"
echo
echo "Starting Re-Analysis tools..."
sleep 10

############################################################

echo
echo "Input data file:"
echo "$INPUT_FILE"
echo
echo "Parameter file:"
echo "PARAMETERS"
echo
echo "Sample Name:"
echo "$SAMPLE"
echo
echo "Replicates: $REPLICATE"
echo

############################################################

#### Calculate Total runtime ####

function print_time {
  END=$(date +%s)
  DIFF=$(( $END - $1 ))
  dd=$(echo "$DIFF/86400" | bc)
  dt2=$(echo "$DIFF-86400*$dd" | bc)
  dh=$(echo "$dt2/3600" | bc)
  dt3=$(echo "$dt2-3600*$dh" | bc)
  dm=$(echo "$dt3/60" | bc)
  ds=$(echo "$dt3-60*$dm" | bc)
  if [ $dd -gt 0 ]; then
    echo " ${dd} days and ${dh} hours."
  elif [ $dh -gt 0 ]; then
    echo " ${dh} hours and ${dm} minutes."
  elif [ $dm -gt 0 ]; then
    echo " ${dm} minutes and ${ds} seconds."
  else
    echo " ${ds} seconds."
  fi
}

## Start clock time
START=$(date +%s)


#######################################################
####					Search GUI				   ####
#######################################################


cd /data/home/bt12048/pride_reanalysis/SearchGUI.5/

if [ "$ANALYSIS" -eq 1 ]; then
	echo
	echo "Starting SearchGUI for MS-GF+ only..."
	echo
	bash loading.sh
	java -Xmx100G -cp SearchGUI-3.2.5.jar eu.isas.searchgui.cmd.SearchCLI -spectrum_files $INPUT_FILE -output_folder $OUTPUT_FOLDER -id_params $PARAMETERS -xtandem 0 -myrimatch 0 -ms_amanda 0 -msgf 1 -omssa 0 -comet 0 -tide 0 -andromeda 0 -threads $THREADS
fi

if [ "$ANALYSIS" -eq 2 ]; then
	echo
	echo "Starting SearchGUI for multiple Search Engines..."
	echo
	echo "X! Tandem"
	echo "MyriMatch"
	echo "MS Amanda"
	echo "MS-GF+"
	echo "OMSSA"
	echo "Comet"
	# echo "Andromeda"
	echo
	bash loading.sh
	echo

	## SearchGUI Parallelisation 

	cd /data/home/bt12048/pride_reanalysis/SearchGUI.5/

# tmux new -s msgf 'sh pride_reanalysis_4.sh'

# tmux new-session -d -s msgf
# tmux send-keys 'sh pride_reanalysis_4.sh' C-m
# tmux detach -s msgf


# tmux send -t msgf ls ENTER

	tmux new-session -d -s msgf
	tmux send-keys 'java -Xmx100G -cp SearchGUI-3.2.5.jar eu.isas.searchgui.cmd.SearchCLI -spectrum_files '$INPUT_FILE' -output_folder '$OUTPUT_FOLDER' -id_params '$PARAMETERS' -msgf 1 -threads 36' C-m
	tmux detach -s msgf

	# java -Xmx100G -cp SearchGUI-3.2.5.jar eu.isas.searchgui.cmd.SearchCLI -spectrum_files $INPUT_FILE -output_folder $OUTPUT_FOLDER -id_params $PARAMETERS -omssa 1 -threads $THREADS

	tmux new-session -d -s xtandem
	tmux send-keys 'java -Xmx100G -cp SearchGUI-3.2.5.jar eu.isas.searchgui.cmd.SearchCLI -spectrum_files '$INPUT_FILE' -output_folder '$OUTPUT_FOLDER' -id_params '$PARAMETERS' -xtandem 1 -threads 19' C-m
	tmux detach -s xtandem

	# java -Xmx100G -cp SearchGUI-3.2.5.jar eu.isas.searchgui.cmd.SearchCLI -spectrum_files $INPUT_FILE -output_folder $OUTPUT_FOLDER -id_params $PARAMETERS -xtandem 1 -threads 19

	tmux new-session -d -s myrimatch
	tmux send-keys 'java -Xmx100G -cp SearchGUI-3.2.5.jar eu.isas.searchgui.cmd.SearchCLI -spectrum_files '$INPUT_FILE' -output_folder '$OUTPUT_FOLDER' -id_params '$PARAMETERS' -myrimatch 1 -threads '$THREADS'' C-m
	tmux detach

	tmux new-session -d -s omssa
	tmux send-keys 'java -Xmx100G -cp SearchGUI-3.2.5.jar eu.isas.searchgui.cmd.SearchCLI -spectrum_files '$INPUT_FILE' -output_folder '$OUTPUT_FOLDER' -id_params '$PARAMETERS' -omssa 1 -threads 25' C-m
	tmux detach

	tmux new-session -d -s comet
	tmux send-keys 'java -Xmx100G -cp SearchGUI-3.2.5.jar eu.isas.searchgui.cmd.SearchCLI -spectrum_files '$INPUT_FILE' -output_folder '$OUTPUT_FOLDER' -id_params '$PARAMETERS' -comet 1 -threads 25' C-m
	tmux detach

 # 	# -tide 0 -andromeda 0

fi

## check if output was produced
if [ ! -f /data/home/bt12048/pride_reanalysis/outputs/searchgui_out.zip ]; 
	then echo "Error: SearchGUI did not finish running properly"
else
	echo
	echo "SearchGUI completed successfully"
	echo
	echo "Starting PeptideShaker..."
	echo
	bash loading.sh
	echo
fi


#######################################################
#### 				Peptide Shaker 				   ####
#######################################################

cd /data/home/bt12048/pride_reanalysis/PeptideShaker.6/

## Run PeptideShaker
echo
java -Xmx100G -cp PeptideShaker-1.14.6.jar eu.isas.peptideshaker.cmd.PeptideShakerCLI -experiment $EXPERIMENT -sample $SAMPLE -replicate $REPLICATE -identification_files $OUTPUT_FOLDER -spectrum_files $INPUT_FILE -id_params $PARAMETERS -out $OUTPUT_FOLDER/$SAMPLE.cpsx -threads $THREADS

# java -Xmx100G -cp PeptideShaker-1.14.6.jar eu.isas.peptideshaker.cmd.PeptideShakerCLI -experiment inflammation -sample inflammation_dataset_cyt_con_2a -replicate 1 -identification_files /data/home/bt12048/pride_reanalysis/outputs/searchgui_out -spectrum_files /data/home/bt12048/pride_reanalysis/inputs/HUVEC_cyt_con_2a.mgf -id_params /data/home/bt12048/pride_reanalysis/parameters/inflammation.par -out /data/home/bt12048/pride_reanalysis/outputs/inflammation_dataset_cyt_con_2a.cpsx -threads 18

if [ ! -f $OUTPUT_FOLDER/$SAMPLE.cpsx ]; 
	then echo "Error: PeptideShaker did not finish running properly"
else
	echo
	echo "PeptideShaker successfully completed"
	echo
fi

# #######################################################

## convert PeptideShaker results to .mzidML file
echo "converting PeptideShaker output to mzIdentML files"
echo
java -Xmx100G -cp PeptideShaker-1.14.6.jar eu.isas.peptideshaker.cmd.MzidCLI -in /data/home/bt12048/pride_reanalysis/outputs/inflammation_dataset_cyt_con_2a.cpsx -output_file /data/home/bt12048/pride_reanalysis/outputs/inflammation_dataset_cyt_con_2a.mzid -contact_first_name "Nazrath" -contact_last_name "Nawaz" -contact_email "nazrath.nawaz@yahoo.de" -contact_address "Fogg Building, London" -organization_name "QMUL" -organization_email "m.n.mohamednawaz@se12.qmul.ac.uk" -organization_address "Mile End Road, London"

# -spectrum_files /data/home/bt12048/pride_reanalysis/inputs/
echo
echo "conversion to mzIdentML successful"
echo

# #######################################################
# ####              Data filtering                   ####
# #######################################################

# #### PeptideShaker Report
tmux new-session -d -s report
tmux send-keys 'java -Xmx100G -cp PeptideShaker-1.14.6.jar eu.isas.peptideshaker.cmd.ReportCLI -in /data/home/bt12048/pride_reanalysis/outputs/inflammation_dataset_cyt_con_2a.cpsx -out_reports /data/home/bt12048/pride_reanalysis/outputs/ -reports 9'
tmux detach

# cannot be parallelised on the same file
java -Xmx100G -cp PeptideShaker-1.14.6.jar eu.isas.peptideshaker.cmd.ReportCLI -in /data/home/bt12048/pride_reanalysis/outputs/inflammation_dataset_cyt_con_2a.cpsx -out_reports /data/home/bt12048/pride_reanalysis/outputs/ -reports 1


grep $PROTEIN inflammation_inflammation_dataset_cyt_con_2a_1_Extended_PSM_Report.txt

## Print Analysis time
echo
echo "Total Run-time for this Re-Analysis was:"
print_time $START
echo

## e-mail notification
mail -s "Apocrita run completed" nazrath.nawaz@yahoo.de <<< "File: $INPUT_FILE"

# #######################################################

# # ## convert PeptideShaker results to .mzidML file
# # java -cp PeptideShaker-1.14.6.jar eu.isas.peptideshaker.cmd.MzidCLI 
# # -in /data/home/bt12048/pride_reanalysis/outputs/result.cpsx -output_file results 
# # -contact_first_name "Nazrath" -contact_last_name "Nawaz" -contact_email "nazrath.nawaz@yahoo.de" 
# # -contact_address "Fogg Building, London" -organization_name "QMUL" -organization_email "m.n.mohamednawaz@se12.qmul.ac.uk" -organization_address "Mile End Road, London" 
# # -spectrum_files /data/home/bt12048/pride_reanalysis/inputs/

# #######################################################

# ## To Do:
# # come up with a way to filter results for protein of interest
# # convert output to mzid
# # use ProViewer to vizualise
# # automate parameters
# # Final results table

