
echo
echo "Do you wish to add your own sequences to the search space?"
echo "Enter y or n"

read new_sequences

if [[ ( $new_sequences == "y") ||  $new_sequences == "Y" ]] 
then
	cd human_proteome
	echo
	echo "please add a fasta file of your sequences to the human_proteome folder"
	echo "enter y when ready"
	read new_fasta

	 if [[ ( $new_fasta == "y") ||  $new_fasta == "Y" ]] 
	 	then
	 		echo
			new_fasta=`find . -type f \( -iname "*.fasta" ! -iname "human_proteome.fasta" \)`
			# echo $new_fasta
	 		awk '{print}' human_proteome.fasta $new_fasta > human_variants_proteome.fasta
	 		echo "search space expanded to include $new_fasta"
	 fi


elif [[ ( $new_sequences == "n") ||  $new_sequences == "N" ]]
	then
	echo "no new sequences"
else 
	echo "?"
fi
