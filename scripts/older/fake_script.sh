echo
cat logo.txt
echo
echo "Starting Re-Analysis Pipeline..."
echo
echo
echo "Starting Re-Analysis tools..."
echo
echo "Parameter file: $DIR/pride_reanalysis/parameters/$PXD.par"
# echo
# echo "Sample Name: $SAMPLE"
echo
# sleep 2
echo "Please wait for RetroMiner to start..."
echo
sh loading.sh 4
echo
echo -en "\033[34m"
echo "SearchGUI running..."
echo -en "\033[0m"
echo
echo -en "\033[34m"
echo "PeptideShaker running..."
echo -en "\033[0m"
echo
echo "Re-analysis pipeline completed"
echo
echo "$PXD" 
echo "Total Run-time for this Re-Analysis:"
echo "1 day; 14 hours, 38 minutes and 12 seconds"
echo