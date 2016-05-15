#!/bin/bash

module load blast
module load python

cd /home1/chatfiel/metal-ions
python blast_pipeline.py < test.txt > blast.out
