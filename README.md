# RetroMiner

A pipeline to reanalyse public PRIDE datasets

----------------
## Background

[PRIDE](https://www.ebi.ac.uk/pride/archive) (PRoteomics IDEntifications) is a data repository for mass spectrometry derived proteomics data

Using the existing proteomics tools SearchGUI and PeptideShaker,
this pipeline utilises a generic, reusable workflow in order to reanalyse PRIDE datasets and identify proteins.

## Requirements


### Softwares 

* SearchGUI - http://compomics.github.io/projects/searchgui.html
* PeptideShaker - http://compomics.github.io/projects/peptide-shaker.html

| **Platform** | **Languages** | **others**           |
|----------|-----------|------------------|
| Linux    | bash      | jq for bash      |
| Mac      | R         | ssh keys for HPC |


----------------
## How to install

### create an installation script

1. clone repository
2. create folder and subfolders
3. installs packages
4. performs checks

----------------
# How to use RetroMiner

<!-- ![alt text](https://github.com/Nazrath10R/RetroMiner_to_RTPEA/blob/master/images/RetroMiner%20to%20RTPEA.png)
 -->

flowchart

In images/reanalysis_log.txt there is a file that records checkpoints of the ongoing reanalysis process.

This record is printed at every stage and can be used as a guide of what the step to run next.

An example is shown below: 

| pxd       | downloaded | parametered | exp_designed | retromined | converted | populated | reason              | info         |
|-----------|------------|-------------|--------------|------------|-----------|-----------|---------------------|--------------|
| PXD00xxxx | y          | y           | y            | y          | n         | n         | interesting dataset | Study et al. |


### Prerequisite

<span style="color:blue">Search Database</span>

- download proteome of species to analyse
- add any protein sequences of interest
- generate reverse sequences through searchgui


### 1. Download dataset from PRIDE

<!-- <span style="color:blue">Apocrita</span> -->

Using the PRIDE Accession (in the format PXD00xxxx) of the dataset, run:

```
sh data_setup.sh PXD00xxxx
```

This script will download the spectral files (.mgf) from the input dataset with this PRIDE accession number.
Only works for public datasets (see private PRIDE data ref)

A new folder with the accession number will be created in input and all .mgf files (with the exception of PRIDE curated ones which 
have the word "pride" in them) will be downloaded. 

Also, mzid files are downloaded for parameter retrieval using the 'mzid' R package and then deleted. A series of temporary jSON files
are downloaded and deleted.

A template of the experimental design table is added to the parameters/experimental_design.txt file to fill in for the next section.

----------------
### 2. Fill experimental design

<!-- <span style="color:blue">Apocrita</span> -->

Open the experimental_design.txt table and fill out the sample and replicate numbers for each spectral file.
Use replicate number 1 if there are no replicates.

Then run the script to set up the files for analysis appropriately:

```
sh experimental_design.sh PXD00xxxx
```

----------------
### 3. Add MS parameters

Identify all the MS parameters needed for the analysis such as fragment tolerance, parent tolerance, fixed and variable modifications etc.

Open the parameters.sh file and fill these into the appropriate lines. Make sure to use SearchGUI's spelling for these parameters.
For help, see the SearchGUI page (ref) or open the modification table on the GUI. There are examples provided in the file as well.

Then run the script to create a parameter file:

```
sh parameters.sh PXD00xxxx
```

----------------
### 4. Run RetroMiner

<span style="color:blue"><!-- DropBox --></span>

To run RetroMiner the only command needed is:

```
sh retrominer.sh [PXD00xxxx] [ANALYSIS] [THREADS]
```

where ANALYSIS = 1 (frontend5) ; 2 (frontend6) ; 3 (sm11)

and THREADS = number of cpu cores to use

Please be considerate when using shared nodes and use htop to monitor other users and jobs.

If no arguments are input, the usage is displayed in the terminal (or -h is used)
Using -i, loads up the interactive version guiding you through the input arguments

All proteomic outputs are stored in outputs/PXD00xxxx/ and protein tables in reports/PXD00xxxx/

Also find any filtered protein outputs in results/PXD00xxxx/ 

All console output is written into log files (see logs/PXD00xxxx/) 

Please use RetroMiner_to_RTPEA (ref) for downstream conversion into jSON files and database population
as well as creating Rdata tables for easier visualisations.


