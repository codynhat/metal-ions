#build_cmdatabase will create the database of known riboswitches needed to run #riboswitch_scan.

#To use it you first must create a folder which contains the Stockholm alignment #files of all of the 
#riboswitches that you want in the database.


filepath=~/Folder_containing_sto_files
cat $filepath/* >> $filepath/combined_riboswitches.sto


#You should edit the script to add the path to this folder. 

#You can then run this script and it will first make a new directory for the #database, then combine all of the stockholm files and run them through infernal
#to create the database. This process can be time consuming.

mkdir cmdatabase
cmbuild cmdatabase/cmdatabase.cm $filepath/combined_riboswitches.sto
cmcalibrate cmdatabase/cmdatabase.cm
cmpress cmdatabase/cmdatabase.cm