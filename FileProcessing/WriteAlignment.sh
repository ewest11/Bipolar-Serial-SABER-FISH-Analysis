#This function must be given a single argument: the directory of one development for making alignment functions
# >> sbatch WriteAlignment.sh /PATHTO/NewImages_dev2/

cd $1

##### Go into each subdirectory and make executable files
declare -a dirs     # declare array for subdirectories
i=1
for d in */
do
    dirs[i++]="${d%/}"
done

##### Write script to execute alignment to dev1 for each directory/image region
for((i=0;i<=36;i++)) # 36 = number of positions in this folder
do
    echo $i "${dirs[i]}"
        echo $1/${dirs[i]}
cd $1/${dirs[i]}
        mapped="${dirs[i]##*_}"
        echo $mapped
        OUT="$1/${dirs[i]}/${dirs[i]}_align.sh"

# This is the script to be written. It will live in the region directory
        echo "#!/bin/bash"  >> $OUT
        echo "#SBATCH -n 3 # Request one core"  >> $OUT
        echo "#SBATCH -t 0-08:00"  >> $OUT
        echo "#SBATCH -p short" >> $OUT
        echo "#SBATCH --mem=100000"  >> $OUT
               echo "" >> $OUT
        echo    "# $1 = fixed image" >> $OUT
        echo    "# $2 = moving image" >> $OUT
        echo    "# $3 = output image" >> $OUT
               echo "" >> $OUT

        echo "/PATHTO/ANTs/antsRegistrationSyNQuick.sh -d 3 -f /PATHTOIMAGES/NewImages_dev1_${mapped}/NewImages_dev1_${mapped}_C0.tiff -m $1/${dirs[i]}/${dirs[i]}_C0.tiff -o $1/${dirs[i]}/${dirs[i]}-aligned -j 1"  >> $OUT

chmod u+x $OUT

################################################################

sbatch $OUT #Submit script to run alignment

cd ..
done