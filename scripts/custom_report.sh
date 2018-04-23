#!/bin/bash

# java -Xmx200G -cp PeptideShaker-1.14.6.jar eu.isas.peptideshaker.cmd.ReportCLI -in "$DIR/pride_reanalysis/outputs/PXD004624/1.cpsx" -out_reports "$DIR/pride_reanalysis/reports/PXD004624/" -reports 9


DIR=/data/SBCS-BessantLab/naz/

cd /data/SBCS-BessantLab/naz/pride_reanalysis/outputs/

# FOLDERS=$(ls -1)
FOLDERS=$(cat output_to_convert.txt)
COUNTER=21
# COUNTER=$(ls -1 | wc -l)

for y in $FOLDERS; do

  cd $y

  echo -en "\033[34m"
  COUNTER=$[$COUNTER -1]
  echo $(($COUNTER))
  echo $y
  echo -en "\033[0m"

  # FILES=$(echo *.cpsx)
  FILES=$(find $DIR/pride_reanalysis/outputs/$y -type f -name "*.cpsx")

  for x in $FILES; do

    java -Xmx200G -cp /data/SBCS-BessantLab/naz/pride_reanalysis/PeptideShaker.6/PeptideShaker-1.14.6.jar eu.isas.peptideshaker.cmd.ReportCLI -in $x -out_reports $DIR/pride_reanalysis/reports/$y/ -reports 9,10,11,12,13

    # java -cp /data/SBCS-BessantLab/naz/pride_reanalysis/PeptideShaker.6/PeptideShaker-1.14.6.jar eu.isas.peptideshaker.cmd.MzidCLI -in $x -output_file $PWD/${x%.cpsx}.mzid -contact_first_name "Nazrath" -contact_last_name "Nawaz" -contact_email "nazrath.nawaz@yahoo.de" -contact_address "Fogg Building" -organization_name "QMUL" -organization_email "m.n.mohamednawaz@qmul.ac.uk" -organization_address  "Mile end road, London"
  
  done

  cd ..

done



cd /data/SBCS-BessantLab/naz/pride_reanalysis/reports/

FOLDERS=$(cat to_filter.txt)
COUNTER=21


for y in $FOLDERS; do

  cd $y
  echo -en "\033[34m"
  COUNTER=$[$COUNTER -1]
  echo $(($COUNTER))
  echo $y
  echo -en "\033[0m"

  FILES=$(find $DIR/pride_reanalysis/reports/$y -type f -name "*_custom_protein_report.txt")

  # FILES=$(echo *_custom_protein_report.txt)

  for x in $FILES; do


    awk '/LINE-1|LINE_1/ { print $0 }' $x > ${x%.txt}_LINE_filtered.txt

    awk '/HERV/ { print $0 }' $x > ${x%.txt}_HERV_filtered.txt

    done

    cd ..

done



mail -s "Apocrita run completed" nazrath.nawaz@yahoo.de <<< "exported and filtered"
