#!/bin/bash

# java -Xmx200G -cp PeptideShaker-1.14.6.jar eu.isas.peptideshaker.cmd.ReportCLI -in "$DIR/outputs/PXD004624/1.cpsx" -out_reports "$DIR/reports/PXD004624/" -reports 9

DIR=/data/SBCS-BessantLab/naz/pride_reanalysis

# cd $DIR/outputs/

# FOLDERS=$(ls -1)
# FOLDERS=$(cat output_to_convert3.txt)

PXD=$1

cd $DIR/outputs/$PXD

echo
# echo $PXD
echo "Starting custom RT export"
echo

# FILES=$(echo *.cpsx)
FILES=$(find $DIR/outputs/$PXD -type f -name "*.cpsx")

for x in $FILES; do

  #9,10,11,12,13

  # 13 
  nice -n 20 java -Xmx200G -cp $DIR/PeptideShaker.6/PeptideShaker-1.14.6.jar eu.isas.peptideshaker.cmd.ReportCLI \
  -in $x -out_reports $DIR/reports/$PXD/ -reports 13    
  echo "1/5"

  # 11 
  nice -n 20 java -Xmx200G -cp $DIR/PeptideShaker.6/PeptideShaker-1.14.6.jar eu.isas.peptideshaker.cmd.ReportCLI \
  -in $x -out_reports $DIR/reports/$PXD/ -reports 11
  echo "2/5"

  # 12
  nice -n 20 java -Xmx200G -cp $DIR/PeptideShaker.6/PeptideShaker-1.14.6.jar eu.isas.peptideshaker.cmd.ReportCLI \
  -in $x -out_reports $DIR/reports/$PXD/ -reports 12
  echo "3/5"

  # 10
  nice -n 20 java -Xmx200G -cp $DIR/PeptideShaker.6/PeptideShaker-1.14.6.jar eu.isas.peptideshaker.cmd.ReportCLI \
  -in $x -out_reports $DIR/reports/$PXD/ -reports 10
  echo "4/5"

  # 9
  nice -n 20 java -Xmx200G -cp $DIR/PeptideShaker.6/PeptideShaker-1.14.6.jar eu.isas.peptideshaker.cmd.ReportCLI \
  -in $x -out_reports $DIR/reports/$PXD/ -reports 9
  echo "5/5"

#   # java -cp $DIR/PeptideShaker.6/PeptideShaker-1.14.6.jar eu.isas.peptideshaker.cmd.MzidCLI -in $x -output_file $PWD/${x%.cpsx}.mzid -contact_first_name "Nazrath" -contact_last_name "Nawaz" -contact_email "nazrath.nawaz@yahoo.de" -contact_address "Fogg Building" -organization_name "QMUL" -organization_email "m.n.mohamednawaz@qmul.ac.uk" -organization_address  "Mile end road, London"

done
echo
echo "reports produced for $PXD"


cd $DIR/reports/$PXD

echo

FILES2=$(find $DIR/reports/$PXD -type f -name "*_custom_protein_report.txt")

for z in $FILES2; do

  # cd $DIR/reports/$PXD

  awk '/LINE-1|LINE_1/ { print $0 }' $z > ${z%.txt}_LINE_filtered.txt

  awk '/HERV/ { print $0 }' $z > ${z%.txt}_HERV_filtered.txt

done

cd $DIR/results


if [ ! -d "$PXD" ]; then
  mkdir $PXD
fi

find $DIR/reports/$PXD -name \*_filtered.txt -exec cp {} $DIR/results/$PXD \;

echo "reports filtered for $PXD"
echo

cd $DIR/scripts


echo "RT protein information extraction completed"




