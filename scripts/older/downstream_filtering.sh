
#### the individual scripts for the filtering

# add PXD ids to the txt file in /outputs/

sh custom_report2.sh

# run twice with different bits

Rscript parser_argumented.R --PXD "PXD00xxxx"

# for each
# cd PXDxxx
find . -name 'PXD*_parsed.txt' -exec mv -it ../final {} +


# result_interpretation.R script to visualise final table

Rscript make_output_table.R

# conversion script needs tidying up with consequence table

Rscript convert_results_to_json_working_final.R






























