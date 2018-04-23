#!/bin/bash

# java -Xmx200G -cp PeptideShaker-1.14.6.jar eu.isas.peptideshaker.cmd.ReportCLI -in "$DIR/pride_reanalysis/outputs/PXD004624/1.cpsx" -out_reports "$DIR/pride_reanalysis/reports/PXD004624/" -reports 9

DIR=/data/SBCS-BessantLab/naz/

cd /data/SBCS-BessantLab/naz/pride_reanalysis/outputs/

# FOLDERS=$(ls -1)
FOLDERS=$(cat output_to_convert2.txt)
COUNTER=21
# COUNTER=$(ls -1 | wc -l)

for y in $FOLDERS; do

  cd $DIR/pride_reanalysis/outputs/$y

  echo -en "\033[34m"
  COUNTER=$[$COUNTER -1]
  echo $(($COUNTER))
  echo $y
  echo -en "\033[0m"
  # FILES=$(echo *.cpsx)
  FILES=$(find $DIR/pride_reanalysis/outputs/$y -type f -name "*.cpsx")

  for x in $FILES; do

    #9,10,11,12,13

    # 13 done
    # 11 now
    java -Xmx200G -cp /data/SBCS-BessantLab/naz/pride_reanalysis/PeptideShaker.6/PeptideShaker-1.14.6.jar eu.isas.peptideshaker.cmd.ReportCLI -in $x -out_reports $DIR/pride_reanalysis/reports/$y/ -reports 11
    # 12
    java -Xmx200G -cp /data/SBCS-BessantLab/naz/pride_reanalysis/PeptideShaker.6/PeptideShaker-1.14.6.jar eu.isas.peptideshaker.cmd.ReportCLI -in $x -out_reports $DIR/pride_reanalysis/reports/$y/ -reports 12
    # 10
    java -Xmx200G -cp /data/SBCS-BessantLab/naz/pride_reanalysis/PeptideShaker.6/PeptideShaker-1.14.6.jar eu.isas.peptideshaker.cmd.ReportCLI -in $x -out_reports $DIR/pride_reanalysis/reports/$y/ -reports 10
    # 9
    java -Xmx200G -cp /data/SBCS-BessantLab/naz/pride_reanalysis/PeptideShaker.6/PeptideShaker-1.14.6.jar eu.isas.peptideshaker.cmd.ReportCLI -in $x -out_reports $DIR/pride_reanalysis/reports/$y/ -reports 9

    # java -cp /data/SBCS-BessantLab/naz/pride_reanalysis/PeptideShaker.6/PeptideShaker-1.14.6.jar eu.isas.peptideshaker.cmd.MzidCLI -in $x -output_file $PWD/${x%.cpsx}.mzid -contact_first_name "Nazrath" -contact_last_name "Nawaz" -contact_email "nazrath.nawaz@yahoo.de" -contact_address "Fogg Building" -organization_name "QMUL" -organization_email "m.n.mohamednawaz@qmul.ac.uk" -organization_address  "Mile end road, London"
  
  done

  echo "reports produced for $y"

  # cd $DIR/pride_reanalysis/reports/$y
  
  # echo

  # FILES2=$(find $DIR/pride_reanalysis/reports/$y -type f -name "*_custom_protein_report.txt")

  # for z in $FILES2; do

  #   # cd $DIR/pride_reanalysis/reports/$y

  #   awk '/LINE-1|LINE_1/ { print $0 }' $z > ${z%.txt}_LINE_filtered.txt

  #   awk '/HERV/ { print $0 }' $z > ${z%.txt}_HERV_filtered.txt

  # done

  #   cd $DIR/pride_reanalysis/results
  #   mkdir $y  
  #   find $DIR/pride_reanalysis/reports/$y -name \*_filtered.txt -exec cp {} /data/SBCS-BessantLab/naz/pride_reanalysis/results/$y \;

  # echo "reports filtered"

  # cd ../..

done





mail -s "Apocrita run completed" nazrath.nawaz@yahoo.de <<< "exported protein results (13) and filtered"


