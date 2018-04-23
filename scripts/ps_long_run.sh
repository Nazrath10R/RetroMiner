#!/bin/sh
#$ -cwd           # Set the working directory for the job to the current directory
#$ -pe smp 10      # Request 1 core
#$ -l h_rt=72:0:0 # Request 24 hour runtime
#$ -l h_vmem=2G   # Request 1GB RAM

cd /data/SBCS-BessantLab/naz/pride_reanalysis/scripts
sh PeptideShaker.sh PXD002117 8 > log.txt


