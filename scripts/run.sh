 #!/bin/bash

PXD=PXD002117

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



nice -n 10 sh SearchGUI.sh PXD002117 1 20
nice -n 10 sh PeptideShaker.sh PXD002117 20
nice -n 10 sh Data_Filtering.sh PXD002117



## Print Analysis time
echo
echo "Re-analysis pipeline completed"
echo
TIME=`print_time $START`
echo "Total Run-time for this Re-Analysis:"
echo $TIME
echo

## e-mail notification
mail -s "Apocrita run completed" nazrath.nawaz@yahoo.de <<< "Dataset re-analysed: $PXD
