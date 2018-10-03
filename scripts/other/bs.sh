############################################################
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
sh loading.sh 20
echo
# touch 
# touch 
# touch 
#######################################################
####                  Search GUI                   ####
#######################################################

echo -en "\033[34m"
echo "SearchGUI running..."
echo -en "\033[0m"
echo