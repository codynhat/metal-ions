#!/bin/bash
#PBS -q generic 
#PBS -l nodes=1:ppn=12
#PBS -m abe
#PBS -M jgillies@uoregon.edu
#PBS -N riboswitch_alignment

module load CMfinder
module load infernal/1.1.1

filepath=~/riboswitch_scan/NiCo_env01_env11.fasta

cmfinder.pl -b -s 1 -n 5 $filepath
cmfinder.pl -b -s 2 -n 5 $filepath

CombMotif.pl $filepath $filepath.motif

cat $filepath.motif* >> $filepath.combined_motifs.sto

cmscan --tblout cmscan_out.txt cmdatabase/cmdatabase.cm $filepath.combined_motifs.sto


