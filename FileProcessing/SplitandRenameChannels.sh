#!/bin/bash

#SBATCH -n 3 # Request one core
#SBATCH -t 0-100:00
#SBATCH -p medium
#SBATCH --mem=10000
#SBATCH --mail-type=ALL # Type of email notification- BEGIN,END,FAIL,ALL

# Input to this function is a folder path containing the imaage files imported from OMERO. This function will split each file into individual channels,
# rename each file according to the image position, and convert to a TIFF format. Then, it will create a folder for each position and move
# all corresponding images into the subfolder.
# The function enters the folder path, splits all OME-TIFF files into individual channels, converts them to TIFF format, and renames them in ascending numerical order starting from 0. 
# This requires bftools, available at https://docs.openmicroscopy.org/bio-formats/5.7.1/users/comlinetools/index.html


module load java #Java is needed for BFTOOLS package
cd $1

parent="${PWD##*/}" # Write parent directory name as variable (without file path)
$parent


# Create array containing all of the base filenames in the folder
for files in *.ome.tiff
do
f[i++]="${files%.ome.tiff}"
done

echo $f
# Iterate through the file list and rename each to the file index (range = 0-#files)


# Iterate through OME-TIFF files and split them into individual channels with bfconvert function of bftools
for filename in *.ome.tiff; do
     str=${filename%.ome.tiff}
     PATHTOBFTOOLS/bftools/bfconvert $filename ${str}_C%c.ome.tiff
 done

# Convert each channel to TIFF format using Bioformats
for OMETIFFfile in *.ome.tiff; do
        basename=${OMETIFFfile%.ome.tiff}

        cp $OMETIFFfile ${basename}.tiff
done


# Make a directory for each region imaged with position index. Theis example is for "dev7", referencing the 7th image session.
for((i=0;i<=${#f[@]};i++))
        do
        mkdir ${parent}_${i}
        for FILES in `find . -type f  -name "*_dev7_${i}_*"`
        do
                        echo $FILES

            mv $FILES ${parent}_${i}/
        done
done



cd ..
