# BLAST Pipeline

## Quick Start

Here are the necessary steps to get started.

1. Create `BLAST_TEMP_PATH` and `OUTPUT_PATH` directories (see below).
2. Set `INPUT_FILE` in `run.sh` to appropriate input file. This file should be a text file with a list of accession numbers. One accession number on each line. See `test.txt` for an example.
3. Set the `DIR` variable in `aciss.sh` to the location of this repo.
4. Start the script on ACISS by running:
```
qsub -q generic aciss.sh
```
When complete, the results will appear in `OUTPUT_PATH`.

## Requirements

This script is meant to be run on ACISS with standalone BLAST. The path to the local BLAST database is hardcoded in the script.

## Setup

Before executing the script, a few paths need to be set. There is one directory where BLAST will output temporary XML files to be used by Entrez. This is the `BLAST_TEMP_PATH` in the `run.sh` script. The another path is the location of the final FASTA output. This is `OUTPUT_PATH` in `run.sh`. Set these paths as needed, or keep them as the default. Make sure the folders are created before running the script.

## Usage

The script, `aciss.sh` can be used to run the pipeline on aciss. The file `test.txt` is an example of input that is accepted by the script. Each line is a separate accession number to run through the pipeline. To start a new pipeline, create a new file with a list of accession numbers and set the environment variable `INPUT_FILE` in the `run.sh` script, appropriately. This path can be absolute, or relative to the directory where `aciss.sh` is located.

To run the script on aciss:

```
qsub -q generic aciss.sh
```

## Output

The output of the BLAST pipeline will create a new directory in `OUTPUT_PATH` for each accession number. Each directory will contain a multi-FASTA file of matched results from the BLAST pipeline. The directory also contains .fasta files for the clusters (see Cluster function below for more details).

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

Multiple nodes may also be used for large queries.


# Clustering function

## Requirements
The clustering function requires BioPython, stand-alone Clustal Omega, and argtable2.

## Usage
This function was designed to cluster the upstream 500-bp sequences of homologous cation efflux pump genes, given a multi-FASTA file `fasta_in` containing sequences and a desired cluster size `cluster_size`. It has been integrated into the `blast_pipeline.py` script. To use the clustering function alone:

```
cluster_BLAST_output(fasta_in, cluster_size)
```
The multi-FASTA clusters that the function writes and outputs will be delivered to the working directory when using the stand-alone clustering function.

## Notes
We ran in to that trouble when the BLAST pipeline multi-FASTA output had too few sequences to cluster when the desired cluster size was too large. It should give clusters for inputs that are large enough to generate clusters of the size recommended for CMfinder. When you ask Clustal Omega to cluster a multi-FASTA input containing, say, 3 sequences into clusters containing 23 sequences each, Clustal won’t cluster them, nor produce an auxiliary clustering file, which is what is used as a reference to write the clustered multi-FASTAs. This would then cause an IO exception.
