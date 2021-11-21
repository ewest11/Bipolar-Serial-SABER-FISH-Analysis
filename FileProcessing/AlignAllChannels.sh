#!/bin/bash
#SBATCH -n 1 # Request one core
#SBATCH -t 0-04:00
#SBATCH -p short
#SBATCH --mem=50000

module load java

# Enter directory 
cd $1

# Align all channels based on the calculated transformations
#for filename in `ls *[[:digit:]].tiff*`; # Iterate through all files containing the pattern #.tiff
for filename in `ls *[[:digit:]].tiff*`;
do
str=${filename%.tiff} # set base name
echo ${str: -1}
inde=${str: -1}
tform=$(find . -name *1Warp.* -print)
affine=$(find . -name *GenericAffine* -print)
        /PATHTOANTS/ANTs/antsApplyTransforms -d 3 -i ${filename} -o ${str}_deformed.nii.gz -r $2 -t ${tform} -t ${affine}
 done

# Unzip deformed output files in the folder
gunzip *_deformed.nii.gz
