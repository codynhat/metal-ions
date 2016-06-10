#!/bin/bash

BLAST_TEMP_PATH='/home7/ereister/Bioinformatics_Spring2016/blast_results'
OUTPUT_PATH='/home7/ereister/Bioinformatics_Spring2016/pipeline_results'
INPUT_FILE='/home7/ereister/Bioinformatics_Spring2016/raw_data/test.txt'
CLUSTER_SIZE=23
CM='/home7/ereister/Bioinformatics_Spring2016/motifs/cmdatabase.cm'

module load python
module load blast

python blast_and_clustering/blast_pipeline.py $BLAST_TEMP_PATH $OUTPUT_PATH $CLUSTER_SIZE < $INPUT_FILE

module load CMfinder
module load infernal/1.1.1

##Run first round of CMfinder, searching for single stem loops

cd $OUTPUT_PATH
for file in **/*.fasta
do
    cmfinder.pl -b -s 1 -n 5 $file
    wait
    cmfinder.pl -b -s 2 -n 5 $file
    wait
    CombMotif.pl $file $file.motif*
done

##For each cluster set, combine their stockholm files into one
cd $OUTPUT_PATH
for file in **/*cluster_0*motif*
do
    cat $file >> $file.combined_motifs.sto
done

for file in **/*cluster_1*motif*
do
    cat $file >> $file.combined_motifs.sto
done
for file in **/*cluster_2*motif*
do
    cat $file >> $file.combined_motifs.sto
done
for file in **/*cluster_3*motif*
do
    cat $file >> $file.combined_motifs.sto
done
for file in **/*cluster_4*motif*
do
    cat $file >> $file.combined_motifs.sto
done
for file in **/*cluster_5*motif*
do
    cat $file >> $file.combined_motifs.sto
done
for file in **/*cluster_6*motif*
do
    cat $file >> $file.combined_motifs.sto
done
for file in **/*cluster_7*motif*
do
    cat $file >> $file.combined_motifs.sto
done
for file in **/*cluster_8*motif*
do
    cat $file >> $file.combined_motifs.sto
done
for file in **/*cluster_9*motif*
do
    cat $file >> $file.combined_motifs.sto
done

#Run stockholm files into cmscan
cd $OUTPUT_PATH
for file in **/**.sto
do
    cmscan --tblout $file.cmsc_out.txt $CM $file
done

##Remove all leftover  cm files
cd $OUTPUT_PATH
for file in **/*cm*
do
    rm $file
done
