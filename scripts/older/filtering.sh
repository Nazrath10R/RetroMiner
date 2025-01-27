#!/bin/bash


cd /data/SBCS-BessantLab/naz/pride_reanalysis/reports/

FOLDERS=$(cat to_filter2.txt)
COUNTER="$(cat to_filter2.txt | wc -l)"


for y in $FOLDERS; do

  cd $y
  echo -en "\033[34m"
  COUNTER=$[$COUNTER -1]
  echo $(($COUNTER))
  echo $y
  echo -en "\033[0m"


  FILES=$(echo *_custom_protein_report.txt)

  for x in $FILES; do


    awk '/LINE-1|LINE_1/ { print $0 }' $x > ${x%.txt}_LINE_filtered.txt

    awk '/HERV/ { print $0 }' $x > ${x%.txt}_HERV_filtered.txt

    done

    cd ..

done




# for all _LINE_filtered files
# parse experimental design
# make output single file


