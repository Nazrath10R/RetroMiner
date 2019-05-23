
## download repository - change to download of released version
git clone https://github.com/Nazrath10R/RetroMiner

cd RetroMiner
cat images/logo.txt

# create folders
mkdir human_proteome
# add proteome
mkdir inputs
mkdir logs
mkdir outputs
mkdir parameters
mkdir reports
mkdir results
mkdir sizes

echo
echo "folders created"
echo
sleep 2

echo
echo -en "\033[34m"
echo "Downloading SearchGUI"
echo -en "\033[0m"
echo
sleep 3

wget http://genesis.ugent.be/maven2/eu/isas/searchgui/SearchGUI/3.2.5/SearchGUI-3.2.5-mac_and_linux.tar.gz
tar -xvzf SearchGUI-3.2.5-mac_and_linux.tar.gz
mv SearchGUI-3.2.5 SearchGUI.5 
chmod -R 770 SearchGUI.5
rm SearchGUI-3.2.5-mac_and_linux.tar.gz

echo
echo -en "\033[34m"
echo "Downloading PeptideShaker"
echo -en "\033[0m"
echo
sleep 3

wget http://genesis.ugent.be/maven2/eu/isas/peptideshaker/PeptideShaker/1.14.6/PeptideShaker-1.14.6.zip
unzip PeptideShaker-1.14.6.zip
mv PeptideShaker-1.14.6 PeptideShaker.6 
chmod -R 770 PeptideShaker.6
rm PeptideShaker-1.14.6.zip

echo
echo "moved config file"
# cp .peptideshaker $HOME/

echo
echo -en "\033[34m"
echo "Downloading Human reference proteome"
echo -en "\033[0m"
echo
sleep 3
wget "https://www.uniprot.org/uniprot/?include=false&format=fasta&force=true&query=proteome:UP000005640" > human_proteome/human_proteome.fasta

echo
echo -en "\033[34m"
echo "Setting up search space"
echo -en "\033[0m"
echo
sleep 3

sh scripts/src/search_space.sh


echo
echo -en "\033[34m"
echo "Installing R packages"
echo -en "\033[0m"
echo
sleep 3

Rscript scripts/src/r_installations.R

cd ..

echo 
echo -en "\033[34m"
echo "Final checks..."
# need a check script
echo -en "\033[0m"
echo
sleep 2
echo "RetroMiner is set up!"
echo


