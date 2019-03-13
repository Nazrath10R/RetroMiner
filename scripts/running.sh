#!/bin/bash


# finish up

sh src/PeptideShaker.sh PXD000948 80
sh src/Data_filtering.sh PXD000948
sh src/Custom_Report.sh PXD000948
Rscript src/log.R --PXD "PXD000948" --IN "retromined"


## to do 

sh retrominer.sh PXD004131 1 80

sh retrominer.sh PXD002104 1 80

sh retrominer.sh PXD008465 1 80

## bigger one
sh retrominer.sh PXD000066 1 80

sh retrominer.sh PXD001833 1 80

sh retrominer.sh PXD000119 1 80

sh retrominer.sh PXD008723 1 80

sh retrominer.sh PXD001435 1 80

sh retrominer.sh PXD006901 1 80

sh retrominer.sh PXD008553 1 80

sh retrominer.sh PXD006482 1 80

sh retrominer.sh PXD000335 1 80





