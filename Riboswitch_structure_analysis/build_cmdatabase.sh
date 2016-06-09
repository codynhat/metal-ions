#!/bin/bash
#PBS -q generic 
#PBS -l nodes=1:ppn=12
#PBS -m abe
#PBS -M *Your email*
#PBS -N build_cmdatabase

module load infernal/1.1.1

filepath=~/Folder_containing_sto_files

cat $filepath/* >> $filepath/combined_riboswitches.sto

mkdir cmdatabase

cmbuild cmdatabase/cmdatabase.cm $filepath/combined_riboswitches.sto

cmcalibrate cmdatabase/cmdatabase.cm

cmpress cmdatabase/cmdatabase.cm