#!/bin/bash

#SBATCH -n 3 # Request one core
#SBATCH -t 0-12:00
#SBATCH -p short
#SBATCH --mem=10000
#SBATCH --mail-type=ALL # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=email

module load java
module load omero

# $1 = output directory name
# $2 = OMERO dataset id 

omero -u ECOMMONSID -w ECOMMONS_PASSWORD export --file $1 --iterate Dataset:$2
