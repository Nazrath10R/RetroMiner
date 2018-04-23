#!/bin/bash

# PXD=PXD002211

cd /data/SBCS-BessantLab/naz/pride_reanalysis/sizes

# output_to_convert2.txt

FOLDERS=$(cat /data/SBCS-BessantLab/naz/pride_reanalysis/outputs/output_to_convert.txt)
COUNTER=21
# COUNTER=6

for y in $FOLDERS; do
  
  echo -en "\033[34m"
  COUNTER=$[$COUNTER -1]
  echo $(($COUNTER))
  echo $y
  echo -en "\033[0m"

  wget -O ${y}_files.json https://www.ebi.ac.uk:443/pride/ws/archive/file/list/project/$y 2> files.out
  jq '.list[] | select(.fileName | contains(".mgf") ) | .fileSize ' ${y}_files.json >> sizes.txt

done
































