
#============================================================#
# to run:
# sh experimental_design.sh PXD00xxxx
# sh experimental_design.sh PXD000651
#============================================================#

PXD=$1

############################################################

#------------------------------------------------------------#

display_usage() {
  echo  
  echo -e "Run:\nexperimental_design.sh [PXD00xxxx]"
  echo
  echo -e "PXD00xxxx = PRIDE Dataset identifier"
  echo
} 
 
# check whether user had supplied -h or --help . If yes display usage 
if [[ ( $1 == "--help") ||  $1 == "-h" ]] 
then 
  display_usage
  exit 0
fi 

# if less than three arguments supplied, display usage 
if [[ ( $1 != "--help") &&  $1 != "-h" && ( $1 != "--interactive") && 
  $1 != "-i" && $# -le 0 ]] 
then 
  display_usage
  exit 1
fi 

#------------------------------------------------------------#


DIR=`find .. -name "retrominer_path.txt" -type f -exec cat {} +`
# DIR=/data/SBCS-BessantLab/naz/pride_reanalysis

SCRIPTS=$DIR/scripts/src

#------------------------------------------------------------#
#                design experimental set up                  #
#------------------------------------------------------------#

Rscript $SCRIPTS/experimental_design_parser.R --PXD "$PXD"

############################################################

if [ -z "$(ls -A $DIR/parameters/$PXD)" ]; then
  echo "experimental design failed"
else
  echo
  Rscript $SCRIPTS/log.R --PXD "$PXD" --IN "exp_designed"
  echo "experimental design parsed"
  echo
fi

# need error catch 


