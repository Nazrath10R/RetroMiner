#!/bin/bash


cd /data/SBCS-BessantLab/naz/pride_reanalysis/outputs/

# FOLDERS=$(ls -1)
FOLDERS=$(cat output_to_convert.txt)
COUNTER=13
# COUNTER=$(ls -1 | wc -l)

for y in $FOLDERS; do

  cd $y

  echo -en "\033[34m"
  echo $(($COUNTER-1))
  echo $y
  echo -en "\033[0m"

  FILES=$(echo *.cpsx)

  for x in $FILES; do

    java -cp /data/SBCS-BessantLab/naz/pride_reanalysis/PeptideShaker.6/PeptideShaker-1.14.6.jar eu.isas.peptideshaker.cmd.MzidCLI -in $x -output_file $PWD/${x%.cpsx}.mzid -contact_first_name "Nazrath" -contact_last_name "Nawaz" -contact_email "nazrath.nawaz@yahoo.de" -contact_address "Fogg Building" -organization_name "QMUL" -organization_email "m.n.mohamednawaz@qmul.ac.uk" -organization_address  "Mile end road, London"
  
  done

  cd ..

done


    # java -cp /data/SBCS-BessantLab/naz/pride_reanalysis/PeptideShaker.6/PeptideShaker-1.14.6.jar eu.isas.peptideshaker.cmd.MzidCLI -in 1.cpsx -output_file $PWD/1.mzid -contact_first_name "Nazrath" -contact_last_name "Nawaz" -contact_email "nazrath.nawaz@yahoo.de" -contact_address "Fogg Building" -organization_name "QMUL" -organization_email "m.n.mohamednawaz@qmul.ac.uk" -organization_address "Mile end road, London"


