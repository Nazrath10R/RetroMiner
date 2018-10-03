#!/bin/bash

DIR=/data/SBCS-BessantLab/naz
cd $DIR/pride_reanalysis/PeptideShaker.6/


java -cp PeptideShaker-1.14.6.jar eu.isas.peptideshaker.cmd.FollowUpCLI -in "/data/SBCS-BessantLab/naz/pride_reanalysis/outputs/PXD004624/1.cpsx" -accessions_file "/data/SBCS-BessantLab/naz/pride_reanalysis/reports/PXD004624/1_proteins.txt" -accessions_type 2
