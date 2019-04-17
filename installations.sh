
git clone https://github.com/Nazrath10R/RetroMiner

cd RetroMiner

mkdir human_proteome
# add proteome
mkdir inputs
mkdir logs
mkdir outputs
mkdir parameters
mkdir reports
mkdir results
mkdir sizes

# wget https://www.uniprot.org/proteomes/UP000005640

Rscript scripts/src/r_installations.R

cd ..


echo
echo "Please download the REFERENCE PROTEOME"
echo "of the species of interest into the proteome folder"
echo "and change the path in parameters"
echo "e.g. Human - https://www.uniprot.org/proteomes/UP000005640"
echo 



