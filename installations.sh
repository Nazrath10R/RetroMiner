
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


echo -en "\033[34m"
echo "Downloading SearchGUI"
echo -en "\033[0m"
# wget http://genesis.ugent.be/maven2/eu/isas/searchgui/SearchGUI/3.2.5/SearchGUI-3.2.5-mac_and_linux.tar.gz
# tar -xvzf SearchGUI-3.2.5-mac_and_linux.tar.gz
# mv SearchGUI-3.2.5 SearchGUI.5 
# chmod -R 770 SearchGUI.5


echo -en "\033[34m"
echo "Downloading PeptideShaker"
echo -en "\033[0m"
# wget http://genesis.ugent.be/maven2/eu/isas/peptideshaker/PeptideShaker/1.14.6/PeptideShaker-1.14.6.zip
# unzip PeptideShaker-1.16.4.zip
# mv PeptideShaker-1.14.6 PeptideShaker.6 
# chmod -R 770 PeptideShaker.6

echo "moved config file"
# cp .peptideshaker $HOME/

echo -en "\033[34m"
echo "Downloading Human reference proteome"
echo -en "\033[0m"
wget "https://www.uniprot.org/uniprot/?include=false&format=fasta&force=true&query=proteome:UP000005640" > human_proteome/human_proteome.fasta

echo -en "\033[34m"
echo "Setting up search space"
echo -en "\033[0m"

sh scripts/src/search_space.sh


echo -en "\033[34m"
echo "Installing R packages"
echo -en "\033[0m"

Rscript scripts/src/r_installations.R

cd ..

echo 
echo
echo -en "\033[34m"
echo "Final chekcks..."
echo -en "\033[0m"
echo
echo "RetroMiner is set up!"
echo


