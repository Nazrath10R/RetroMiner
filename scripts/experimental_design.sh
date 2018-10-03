
#============================================================#
# to run:
# sh experimental_design.sh PXD00xxxx
# sh experimental_design.sh PXD000651
#============================================================#

PXD=$1

############################################################

DIR=/data/SBCS-BessantLab/naz/pride_reanalysis
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


