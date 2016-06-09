#riboswitch_scan takes a multi-fasta file and runs it through CMfinder and Infernal. 
#The output is a .txt table of hits which correspond to matches between the riboswitch motifs 
#found in the fasta and the known riboswitches in the cmdatabase.

#The first step is to enter the filepath from your home directory in aciss to the multi-fasta file. 


filepath=“path/to/fasta/file”


#The script then runs this file through cmfinder twice, once looking for single stem loops and again 
#looking for double. 
#	The number of stem loops it searches for is controlled by the -s tag.
#	The -n tag sets the number of potential stem loops it looks for in the multi-fasta, and is set to 5 
#	based on the recommendation of the cmfinder manual.
#	The -b tag turns off an unnecessary blast search option.
#	Other tags exist and can be found in the cmfinder userguide. However I would recommend using
#	the default parameters for these.

cmfinder.pl -b -s 1 -n 5 $filepath

#Next the stem loops are combined with the CombMotif command. This increases the likelihood of finding a 
#good riboswitch match.

CombMotif.pl $filepath $filepath.motif*

#The various motif files which contain the stem loop information are then catenated in preparation for 
#running infernal.

cat $file >> $filepath.combined_motifs.sto

#Infernal's cmscan command is run using the --tblout tag which produces the output table into a file 
#called cmscan_out.txt. To run this a cmdatabase must have been created using Infernal, which can be 
#done using the build_cmdatabase script. 

cmscan --tblout $filepath.cmsc_out.txt $CM $file

