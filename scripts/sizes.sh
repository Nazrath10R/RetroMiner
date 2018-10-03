#!/bin/bash

cd /data/SBCS-BessantLab/naz/pride_reanalysis/outputs
ls -1 > sizes.txt

# PXD=PXD002211

cd /data/SBCS-BessantLab/naz/pride_reanalysis/sizes

# output_to_convert2.txt

FOLDERS=$(cat /data/SBCS-BessantLab/naz/pride_reanalysis/outputs/sizes.txt)
COUNTER=40
# COUNTER=6

for y in $FOLDERS; do
  
  echo $y >> sizes.txt
  echo -en "\033[34m"
  COUNTER=$[$COUNTER -1]
  echo $(($COUNTER))
  echo $y
  echo -en "\033[0m"

  wget -O ${y}_files.json https://www.ebi.ac.uk:443/pride/ws/archive/file/list/project/$y --no-check-certificate 2> files.out
  # jq '.list[] | select(.fileName | contains(".mgf") ) | .fileSize ' ${y}_files.json >> sizes.txt
  jq '.list[] | select(.fileName | contains(".mgf"| ".MGF") ) | .fileSize ' ${y}_files.json >> ${y}_size.txt
  rm ${y}_files.json
done


# move all to 
# /Users/nazrathnawaz/Dropbox/PhD/retroelement_expression_atlas/data/sizes























