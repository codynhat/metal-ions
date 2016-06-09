# Full Pipeline

## Quick Start
## To run full pipeline:

Here are the necessary steps to get started.

1. Create `BLAST_TEMP_PATH` and `OUTPUT_PATH` directories (see below).
2. Set `INPUT_FILE` in `run.sh` to appropriate input file. This file should be a text file with a list of accession numbers. One accession number on each line. See `test.txt` for an example.
3. Set variables in run.sh. Variables to be set are 'BLAST_TEMP_PATH', 'OUTPUT_PATH', 'CM', 'INPUT_FILE', and 'CLUSTER_SIZE'. Each of these is explained below in 'Setup'.
4. Start the script on ACISS by running:
```
qsub -q generic run.sh
```

## Requirements

This script is meant to be run on ACISS with standalone BLAST. The path to the local BLAST database is hardcoded in the script, but can be modified to be loaded manually
This script also requires CMfinder, infernal, Python/2.7, and clustal-omega. These are all currently set to be loaded on aciss within the script, however if one was to attempt to use this elsewhere these programs would need to be installed.

## Setup

Before executing the script, a few paths need to be set. There is one directory where BLAST will output temporary XML files to be used by Entrez. This is the `BLAST_TEMP_PATH` in the `run.sh` script. The another path is the location of the final FASTA output. This is `OUTPUT_PATH` in `run.sh`. Set these paths as needed, or keep them as the default. The default is your root directory. Make sure the folders are created before running the script.
INPUT_PATH needs to be set to your list of accession numbers. CM should be set to your pre-compiled CM database. If you do not have a CM database and do not wish to use the provided riboswitch CM database, see readme_build_cmdatabase.txt
Lastly, CLUSTER_SIZE can be modified to adjust the size of the clusters made.

## Usage

The file `test.txt` is an example of input that is accepted by the script. Each line is a separate accession number to run through the pipeline. To start a new pipeline, create a new file with a list of one or more accession numbers and set the environment variable `INPUT_FILE` in the `run.sh` script, appropriately.

To run the script on aciss:

```
qsub -q generic run.sh

##When running more than 1 accession number, qsub -q fatnodes run.sh is recommended

```

## Output

The output of the BLAST pipeline will create a new directory in `OUTPUT_PATH` for each accession number. Each directory will contain a multi-FASTA file of matched results from the BLAST pipeline. The directory also contains .fasta files for the clusters (see Cluster function below for more details).
Motif files will also be produced for each cluster. These will be collapsed into stockholm files for each cluster. Lastly, an alignment file will be output for each cluster. This alignment file will show the sequences retrieved from the blast search grouped into similar sequences/structures, then mapped against known RNA structures as annotated in the provided CM database

### Example Output Format

```
ABC93653.1/
  ABC93653.1.fasta

CAC83722.1/

P69380.1/
  P69380.1.aux              
  P69380.1_cluster_1.fasta
  P69380.1_cluster_3.fasta  
  P69380.1_cluster_5.fasta  
  P69380.1_cluster_7.fasta  
  P69380.1_cluster_9.fasta
  P69380.1_cluster_0.fasta  
  P69380.1_cluster_2.fasta  
  P69380.1_cluster_4.fasta  
  P69380.1_cluster_6.fasta
  P69380.1_cluster_8.fasta  
  P69380.1.fasta

ZP_00593836.1/
  ZP_00593836.1.fasta

```

Note: Not all accession numbers will have results. Some do not find any BLAST results (`CAC83722.1`), and some do not find enough results to make clusters (`ABC93653.1`, `ZP_00593836.1`). See the `aciss.sh` logs in your home directory for error messages.

## Notes

Each query is run on separate processes, using the `multiprocessing` python library. Most of the time is spent waiting for the BLAST queries to complete. Since this uses local, standalone BLAST, executing the script on a node with multiple cores should speed up the process.   

To use multiple cores on ACISS, a few arguments should be added to the command line call. The following command will run the script using 4 cores:

```
qsub -q generic -l nodes=1:ppn=4 aciss.sh
```

Multiple nodes may also be used for large queries. THe maximum number of nodes currently available on the University of Oregon's aciss is 12 nodes (2016-06-07)
