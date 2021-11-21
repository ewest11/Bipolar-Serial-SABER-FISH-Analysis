# Bipolar-Serial-SABER-FISH-Analysis

## File Processing
This will walk through the import and processing of multichannel images of SABER-FISH data. The pipeline requires functions from [BioFormats](https://www.openmicroscopy.org/bio-formats/) for file processing, [ANTS](https://github.com/ANTsX/ANTs) for image registration, [ACME](https://github.com/krm15/ACME) for cell segmentation, and [PD3D](https://github.com/ewest11/PD3D) for SABER-FISH puncta detection.

Image files were stored on OMERO (https://www.openmicroscopy.org/omero/) and on Harvard Medical School's O2 cluster. The BASH scripts will need to be customized based on your cluster environment. 

The files were acquired using Nikon's Elements software as multipoint, multichannel Z-stack images. Each contains WGA as the first channel, and 2-3 additional channels of SABER-FISH markers or EdU/BrdU. To import these ND2 files to O2, we create a directory named NewImages and import the data from OMERO with the OMERO Dataset ID: 9526.

```bash
mkdir NewImages
cd NewImages
sbatch ./OMEROtoO2.sh NewImages_dev1 9526
```

The files then need to be split into individual fluorescent channels, renamed, and sorted based on their position. This is done by calling SplitandRenameChannels.sh.

```bash
sbatch SplitandRenameChannels.sh /FULLPATH/NewImages_dev1
```

Each image session now must be aligned to the first image session (dev1). This is done by using Advanced Normalization Tools to create a mapping between the WGA images from each session (dev2-dev7) to session 1 (dev1). 

First, use a BASH script to write a function that will align each position:

```bash
sbatch WriteAlignment.sh /PATHTO/NewImages_dev2/
```

Now, there will be a file within each position subfolder in the dev2 parent folder that reads (example for position 1):
```bash

#!/bin/bash
#SBATCH -n 3 # Request one core
#SBATCH -t 0-08:00
#SBATCH -p short
#SBATCH --mem=100000

/PATHTOANTS/ANTs/antsRegistrationSyNQuick.sh -d 3 -f /PATHTODEV1/NewImages_dev1/NewImages_dev1_1/image_1_C0.tiff -m /PATHTODEV2/NewImages_dev2/NewImages_dev2_1/image_dev2_1_C0.tiff -o /PATHTODEV2/NewImages_dev2/NewImages_dev2_1/image_dev2_1-aligned -j 1
```

This script should be executed within each position subfolder, creating multiple output files therein:
```
-alignedto1Warped.nii.gz: The Warped image is the remapped WGA file, which should match the WGA file from dev1
-alignedto11Warp.nii.gz and -alignedto10GenericAffine.mat: Define the transform to map points in the dev2 WGA image onto the dev1 WGA image. 
```

Now that the deformation mapping between dev2 and dev1 WGA coordinates has been defined, we must apply it to all channels of the dev2 image. This should be run within the dev2 parent directory /NewImages_dev2/. num_positions should be replaced with the number of positions imaged.
```bash
for((i=1;i<=num_positions;i++)); do sbatch alignallchans.sh /PATHTODEV2/NewImages_dev2_${i} /PATHTODEV1/NewImages_dev1/NewImages_dev1_${i}_C0.tiff;done
```

Now, each position subfolder will contain "deformed" files for each channel, corresponding to the dev2 files mapped onto the same coordinates as dev1. The alignment should be checked for each position by overlaying the WGA channel after deformation with the WGA channel from dev1. 

## Cell Segmentation
Once all images have been aligned to the first session, the cells are segmented in 3-D based on the WGA stain from dev1. To segment the WGA stain from dev1, the ACMESEG.sh function was run as outlined in the PD3D package (https://github.com/ewest11/PD3D) from (Kishi et al., 2019). 

# Citations

Kishi, J. Y., Lapan, S. W., Beliveau, B. J., West, E. R., Zhu, A., Sasaki, H. M., Saka, S. K., Wang, Y., Cepko, C. L. & Yin, P. SABER amplifies FISH: enhanced multiplexed imaging of RNA and DNA in cells and tissues. Nat Methods 16, 533-544 (2019).

Kishore R Mosaliganti, Ramil R Noche, Fengzhu Xiong, Ian A Swinburne, and Sean G Megason. Acme: automated cell morphology extractor for comprehensive reconstruction of cell membranes. PLoS computational biology, 8(12):e1002780, 2012.
