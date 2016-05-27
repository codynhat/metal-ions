## Requirements

This script is meant to be run on ACISS with standalone BLAST. The path to the local BLAST database is hardcoded in the script.

## Setup

Before executing the script, a few paths need to be set. There is one directory where BLAST will output temporary XML files to be used by Entrez. This is the `BLAST_TEMP_PATH` in the `aciss.sh` script. The another path is the location of the final FASTA output. This is `OUTPUT_PATH` in `aciss.sh`. Set these paths as needed, or keep them as the default.

## Usage

The script, `aciss.sh` can be used to run the pipeline on aciss. The file `test.txt` is an example of input that is accepted by the script. Each line is a separate accession number to run through the pipeline. To start a new pipeline, create a new file with a list of accession numbers and set the envornment variable `INPUT_FILE` in the `aciss.sh` script, appropriately. This path can be absolute, or relative to the directory where `aciss.sh` is located.

To run the script on aciss:

```
qsub -q generic aciss.sh
```

## Notes

Each query is run on separate processes, using the `multiprocessing` python library. Most of the time is spent waiting for the BLAST queries to complete. Since this uses local, standalone BLAST, executing the script on a node with multiple cores should speed up the process.   

To use multiple cores on ACISS, a few arguments should be added to the command line call. The following command will run the script using 4 cores:

```
qsub -q generic -l nodes=1:ppn=4 aciss.sh
```

Multiple nodes may also be used for large queries.
