#!/bin/bash

module load blast
module load python

DIR='/home1/chatfiel/metal-ions'
BLAST_TEMP_PATH='./blast_results'
OUTPUT_PATH='./blast.fasta'
INPUT_FILE='test.txt'

cd $DIR
python blast_pipeline.py $BLAST_TEMP_PATH $OUTPUT_PATH < $INPUT_FILE
