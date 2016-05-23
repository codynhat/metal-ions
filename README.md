## Requirements

This script is meant to be run on ACISS with standalone BLAST. The path to the local BLAST database is hardcoded in the script.

## Setup

Before executing the script, a few directories need to be created. These can be created by executing the following:

```
mkdir -v blast_results
mkdir -v pipeline_results
```

The directory `blast_results` is where the results for blast queries are stored as XML documents. The directory `pipeline_results` contains the final output as multi FASTA files. Each file is named after the original query accession number.

## Usage

The script, `aciss.sh` can be used to run the pipeline on aciss. The file `test.txt` is an example of input that is accepted by the script. Each line is a separate accession number to run through the pipeline. To start a new pipeline, create a new file with a list of accession numbers and replace the reference to `test.txt` in the `aciss.sh` script.

To run the script on aciss:

```
qsub -q generic aciss.sh
```

The final output will be located in `pipeline_results/`. Any logging output is redirected to `./blast.out`.

## Notes

Each query is run on separate processes, using the `multiprocessing` python library. Most of the time is spent waiting for the BLAST queries to complete. Since this uses local, standalone BLAST, executing the script on a node with multiple cores should speed up the process.   

To use multiple cores on ACISS, a few arguments should be added to the command line call. The following command will run the script using 4 cores:

```
qsub -q generic -l nodes=1:ppn=4 aciss.sh
```

Multiple nodes may also be used for large queries.
