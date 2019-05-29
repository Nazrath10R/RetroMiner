
DIR=`find .. -name "retrominer_path.txt" -type f -exec cat {} +`

Rscript $DIR/scripts/src/counter.R

COUNT=`Rscript $DIR/scripts/src/counter.R`

# awk '{print $1}' $COUNT

# echo ${COUNT[0]}

# echo $COUNT
# mail -s "Mining status: $COUNT" nazrath.nawaz@yahoo.de <<< ""


