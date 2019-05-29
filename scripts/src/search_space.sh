#!/bin/bash

#============================================================#
#                                                            #
#     	 combines user provided fasta with sequences to      #
#     	  search space and generate decoys						       #
#                                                            #
#============================================================#

echo
echo "#============================================================#"
echo "Do you wish to add your own sequences to the search space?"
echo "Enter y or n"
read new_sequences
echo "#============================================================#"

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
		echo "combining fasta files"
		new_fasta=`find . -type f \( -iname "*.fasta" ! -iname "human_proteome.fasta" \)`
		# echo $new_fasta

		# combine fasta files
		awk '{print}' human_proteome.fasta $new_fasta > human_variants_proteome.fasta
		echo "search space expanded to include $new_fasta"
		echo
		echo "generating reversed sequences for target-decoy approach..."
		echo
		sleep 1
		
		# reversed sequence generation through SG
		java -cp ../SearchGUI.5/SearchGUI-3.2.5.jar eu.isas.searchgui.cmd.FastaCLI \
		-in human_variants_proteome.fasta -decoy 
		
		# check if database was generated
		if ls human_variants_proteome.fasta 1> /dev/null 2>&1; then

			echo
			echo "#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
			echo "search database generated: human_variants_proteome_concatenated_target_decoy.fasta"
			echo "#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
			echo
			sleep 3

		else
			echo "search database failed"
		fi

		echo
 		echo
	 fi

## no sequences to be added
elif [[ ( $new_sequences == "n") ||  $new_sequences == "N" ]]
	then
	
	cd human_proteome

	echo "no new sequences"

		mv human_proteome.fasta human_variants_proteome.fasta

		# reversed sequence generation through SG
		java -cp ../SearchGUI.5/SearchGUI-3.2.5.jar eu.isas.searchgui.cmd.FastaCLI \
		-in human_variants_proteome.fasta -decoy 
		# -decoy_suffix "target-decoy.fasta"

		# check if database was generated
		if ls human_variants_proteome.fasta 1> /dev/null 2>&1; then
			echo
			echo "#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
			echo "search database generated: human_variants_proteome_concatenated_target_decoy.fasta"
			echo "#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
			echo
			sleep 3
fi 

else 
	echo "input not identified"
	echo
	sleep 1
	echo "please re-enter [y|n]"
	echo
	exit 0
fi
