#!/bin/bash

BLAST_TEMP_PATH='./blast_results'
OUTPUT_PATH='./pipeline_results'
INPUT_FILE='test1.txt'
CLUSTER_SIZE=23

python blast_pipeline.py $BLAST_TEMP_PATH $OUTPUT_PATH $CLUSTER_SIZE < $INPUT_FILE
