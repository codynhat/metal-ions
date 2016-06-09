#!/bin/bash

BLAST_TEMP_PATH='./blast_results'
OUTPUT_PATH='./pipeline_results'
INPUT_FILE='./test.txt'
CLUSTER_SIZE=23
CM='/home7/ereister/Bioinformatics_Spring2016/motifs/cmdatabase.cm'

module load python
module load blast
module load CMfinder
module load infernal/1.1.1

python blast_and_clustering/blast_pipeline.py $BLAST_TEMP_PATH $OUTPUT_PATH $CLUSTER_SIZE < $INPUT_FILE

##Run first round of CMfinder
cd $OUTPUT_PATH
for file in **/**/*
do
    cmfinder.pl -b -s 1 -n 5 $file
done
##Make a directory "motif" in each accession number's folder

shopt -s globstar
for dir in $OUTPUT_PATH/*/
do
mkdir -- "$dir/motif"
done

##move all "motif" and "cm" files to motif folder so next CMfinder doesn't run on them as well as the original fasta

for i in $OUTPUT_PATH/**/*motif*
do
    mv $i */motif
done

for x in $OUTPUT_PATH/**/*cm*
do
    mv $x */motif
done

##Run second round of cmfinder

for file in $OUTPUT_PATH/**/*
do
    cmfinder.pl -b -s 2 -n 5 $file
done

#move items from motif folder back into main folder for next step
for file in $OUTPUT_PATH/**/motif/*
do
    mv $file
done

##Run Combmotif on each file set
for file in $OUTPUT_PATH/**/*
do
    CombMotif.pl $file $file.motif*
done

##For each cluster set, combine their stockholm files into one

for file in $OUTPUT_PATH/**/*cluster_0*motif*
do
    cat $file >> $file.combined_motifs.sto
done
for file in $OUTPUT_PATH/**/*cluster_1*motif*
do
    cat $file >> $file.combined_motifs.sto
done
for file in $OUTPUT_PATH/**/*cluster_2*motif*
do
    cat $file >> $file.combined_motifs.sto
done
for file in $OUTPUT_PATH/**/*cluster_3*motif*
do
    cat $file >> $file.combined_motifs.sto
done
for file in $OUTPUT_PATH/**/*cluster_4*motif*
do
    cat $file >> $file.combined_motifs.sto
done
for file in $OUTPUT_PATH/**/*cluster_5*motif*
do
    cat $file >> $file.combined_motifs.sto
done
for file in $OUTPUT_PATH/**/*cluster_6*motif*
do
    cat $file >> $file.combined_motifs.sto
done
for file in $OUTPUT_PATH/**/*cluster_7*motif*
do
    cat $file >> $file.combined_motifs.sto
done
for file in $OUTPUT_PATH/**/*cluster_8*motif*
do
    cat $file >> $file.combined_motifs.sto
done
for file in $OUTPUT_PATH/**/*cluster_9*motif*
do
    cat $file >> $file.combined_motifs.sto
done

#Run stockholm files into cmscan

for file in $OUTPUT_PATH/**/**.sto
do
    cmscan --tblout $file.cmsc_out.txt $CM $file
done

##Remove all leftover  cm files

for file in $OUTPUT_PATH/**/*cm
do
    rm $file
done
