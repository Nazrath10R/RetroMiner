# RetroMiner

This Pipeline serves to reanalyse publicly available PRIDE datasets

## PRIDE

PRIDE (PRoteomics IDEntifications) is a public data repository for proteomics data
commonly used for Protein and Peptide Identifications

https://www.ebi.ac.uk/pride/archive

<!-- ![alt text](https://github.com/Nazrath10R/RetroMiner_to_RTPEA/blob/master/images/RetroMiner%20to%20RTPEA.png)
 -->

Using the existing proteomics tools SearchGUI and PeptideShaker,
this pipeline utilises a generic, reusable workflow in order to reanalyse PRIDE datasets

## SearchGUI

http://compomics.github.io/projects/searchgui.html


## PeptideShaker

http://compomics.github.io/projects/peptide-shaker.html



### Get RT data out - create_results_table.sh (working)

<span style="color:blue">Apocrita</span>

```
sh custom_report2.sh
```

this script runs the modified data export for PeptideShaker and outputs .txt files
loop requires a list of PXDs in a text file. write a way to automatically find the ones not parsed. 
(maybe using reanalysis log) 

run second part of the script for the filtration
awk commands filter RT protein lines out super fast and create LINE and HERV .txt files 

### Create output table 

<span style="color:blue">Apocrita</span>

creates one output table with all results

```
Rscript parser_argumented.R --PXD "PXD00xxxx"
```

makes new folder called final
move all filtered files into final folder


### collate output table 

<span style="color:blue">Apocrita</span>


```
Rscript make_output_table.R
```

## visualise results 

<span style="color:blue">Apocrita</span>

```
Rscript result_interpretation.R
```


## Table Data

<span style="color:blue">DropBox</span>

Table data

```
/data/results/
```

### add metadata

<span style="color:blue">DropBox</span>

```
Rscript adding_consequence_to_output_table.R
````

### convert results to json

<span style="color:blue">DropBox</span>

using example.json

```
Rscript convert_results_to_json_working_final.R
```

move all json files to new folder and put this script in there

```
python Fix_Json_ORF.py
```

move them out of the newly generated folder back out and delete generated folder 



## ProtVista data

<span style="color:blue">DropBox</span>

/variants/

using visualise_example_new.json

```
Rscript conversion_4.R
```

need to add a newly compiled PXD list


### merge into one file per protein 

<span style="color:blue">Apocrita</span>

/ProtVista/results/

```
sh combine_protvista_json_files.sh
```

## ideogram data

<span style="color:blue">DropBox</span>

in data/variants/

using sequences from data/variants/sequences

```
Rscript ideogram.R
```


## bar chart data 

<span style="color:blue">Apocrita</span>

on Apocrita /outputs/

```
du -sh *
```
use this to write all files into one file and call it sizes.txt

move to dropbox

make a matrix with sizes and PXDs
```
Rscript sizes.R
```

