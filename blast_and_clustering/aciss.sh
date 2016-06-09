#!/bin/bash

module load blast
module load python
module load clustal-omega/1.2.1

DIR='/home1/chatfiel/metal-ions'

cd $DIR
./run.sh
