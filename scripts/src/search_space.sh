#!/bin/bash

#============================================================#
#                                                            #
#     	 combines user provided fasta with sequences to      #
#     	  search space and generate decoys						       #
#                                                            #
#============================================================#

echo
echo "Do you wish to add your own sequences to the search space?"
echo "Enter y or n"

read new_sequences

## if there are sequences to be added
if [[ ( $new_sequences == "y") ||  $new_sequences == "Y" ]] 
then
	cd human_proteome
	echo
	echo "please add a fasta file with your sequences to the human_proteome folder"
	echo "enter y when ready"
	read new_fasta

	# wait for user to move fasta over
 if [[ ( $new_fasta == "y") ||  $new_fasta == "Y" ]] 
 	then
		echo
		new_fasta=`find . -type f \( -iname "*.fasta" ! -iname "human_proteome.fasta" \)`
		# echo $new_fasta

		# combine fasta files
		awk '{print}' human_proteome.fasta $new_fasta > human_variants_proteome.fasta
		echo "search space expanded to include $new_fasta"
		echo
		echo "generating reversed sequences for target-decoy approach"
		echo
		
		# reversed sequence generation through SG
		java -cp SearchGUI-3.2.5.jar eu.isas.searchgui.cmd.FastaCLI \
		-in human_variants_proteome.fasta -decoy

		# check if database was generated
		if ls human_proteome/human_variants_proteome.fasta 1> /dev/null 2>&1; then
			echo "search database generated: human_variants_proteome.fasta"
		else
			echo "search database failed"
		fi

		echo
 		echo
	 fi

## no sequences to be added
elif [[ ( $new_sequences == "n") ||  $new_sequences == "N" ]]
	then
	echo "no new sequences"
else 
	echo "?"
fi
