# RetroMiner

This Pipeline serves to reanalyse public available PRIDE datasets

## Background

[PRIDE](https://www.ebi.ac.uk/pride/archive) (PRoteomics IDEntifications) is a public data repository for proteomics data

Using the existing proteomics tools SearchGUI and PeptideShaker,
this pipeline utilises a generic, reusable workflow in order to reanalyse PRIDE datasets

## Requirements

### Softwares 

* SearchGUI - http://compomics.github.io/projects/searchgui.html
* PeptideShaker - http://compomics.github.io/projects/peptide-shaker.html

### Platform
- Linux
- Mac

### Languages
- bash
- R

### others
- jq for bash
- ssh keys for HPC


# How to install

- create installation script

# How to use RetroMiner

<!-- ![alt text](https://github.com/Nazrath10R/RetroMiner_to_RTPEA/blob/master/images/RetroMiner%20to%20RTPEA.png)
 -->
flowchart


### 1. Download dataset from PRIDE

<!-- <span style="color:blue">Apocrita</span> -->

```
sh data_setup.sh PXD00xxxx
```

This script will download the spectral files from the input dataset with PRIDE acesssion number (in the format PXD00xxxx).
A new folder with the accession number will be created in input and all .mgf files (with the exception of PRIDE curated ones which 
have the word "pride" in them) will be downloaded. Also mzid files are downloaded for parameter retrieval using the 'mzid' R package
and then deleted. A template of the experimental design table is added to the parameters/experimental_design.txt file to fill in the next section.


### 2. Fill experimental design

<!-- <span style="color:blue">Apocrita</span> -->

Open the experimental_design.txt file and fill out the sample and replicate numbers for each spectral file.
Use replicate number 1 if there are no replicates. Then run the script to set up the files for analysis appropriately.

```
sh experimental_design.sh PXD00xxxx
```

### 3. Add MS parameters

Identify all the MS parameters needed for the analysis such as fragment tolerane, parent tolderance, fixed and variable modifications etc.

open the parameters.sh file and fill these into the appropriate lines. Make sure to use SearchGUI's spelling for these paramaters.
For help, see the SearchGUI page (ref) or open the modification table on the GUI. There are examples provided in the file as well.
Then run the script to create a parameter file.

```
sh parameters.sh PXD00xxxx
```


### 4. Run RetroMiner

<span style="color:blue"><!-- DropBox --></span>

To run RetroMiner the only command needed is:

```
sh retrominer.sh [PXD00xxxx] [ANALYSIS] [THREADS]
```

where ANALYSIS = 1 (frontend5) ; 2 (frontend6) ; 3 (sm11)
and THREADS = number of cpu cores to use

If no arguments are input, the usage is displayed in the terminal.
Using -i, loads up the interactive version and -h also prints the usage.























