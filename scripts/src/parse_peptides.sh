

DIR=`find .. -name "retrominer_path.txt" -type f -exec cat {} +`
# DIR=/data/SBCS-BessantLab/naz/pride_reanalysis

cd $DIR/reports/

TOTAL=`ls -d PXD*/ | wc -l`
COUNTER=0


for PXD in PXD*; do
  
  # echo $PXD
	cd $PXD
	echo

	FILES2=$(find $DIR/reports/$PXD -type f -name "*_custom_peptide_report.txt")

	for z in $FILES2; do

	  awk '/LINE-1|LINE_1/ { print $0 }' $z > ${z%.txt}_LINE_peptide_filtered.txt

	  awk '/HERV/ { print $0 }' $z > ${z%.txt}_HERV_peptide_filtered.txt

	done

	cd $DIR/results/peptide_level


	if [ ! -d "$PXD" ]; then
	  mkdir $PXD
	fi

	find $DIR/reports/$PXD -name \*_peptide_filtered.txt -exec cp {} $DIR/results/peptide_level/$PXD \;

	echo "reports filtered for $PXD"
	echo
	# echo "RT peptude information extraction completed"


	cd $DIR/reports/

  COUNTER=$(($COUNTER + 1 ))
  echo "$COUNTER of $TOTAL"
  echo

done








