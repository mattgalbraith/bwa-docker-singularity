[![Docker Image CI](https://github.com/mattgalbraith/bwa-docker-singularity/actions/workflows/docker-image.yml/badge.svg)](https://github.com/mattgalbraith/bwa-docker-singularity/actions/workflows/docker-image.yml)

# bwa-docker-singularity

## Build Docker container for BWA and (optionally) convert to Apptainer/Singularity.  

BWA is a software package for mapping DNA sequences against a large reference genome, such as the human genome.  
https://bio-bwa.sourceforge.net/bwa.shtml  
  
#### Requirements:
To building: build-essential zlib1g-dev  

  
## Build docker container:  

### 1. For BWA installation instructions:  
https://github.com/lh3/bwa  


### 2. Build the Docker Image

#### To build image from the command line:  
``` bash
# Assumes current working directory is the top-level bwa-docker-singularity directory
docker build -t bwa:0.7.17 . # tag should match software version
```
* Can do this on [Google shell](https://shell.cloud.google.com)

#### To test this tool from the command line:
``` bash
docker run --rm -it bwa:0.7.17 bwa 
```

## Optional: Conversion of Docker image to Singularity  

### 3. Build a Docker image to run Singularity  
(skip if this image is already on your system)  
https://github.com/mattgalbraith/singularity-docker

### 4. Save Docker image as tar and convert to sif (using singularity run from Docker container)  
``` bash
docker images
docker save <Image_ID> -o bwa0.7.17-docker.tar && gzip bwa0.7.17-docker.tar # = IMAGE_ID of <tool> image
docker run -v "$PWD":/data --rm -it singularity:1.1.5 bash -c "singularity build /data/bwa0.7.17.sif docker-archive:///data/bwa0.7.17-docker.tar.gz"
```
NB: On Apple M1/M2 machines ensure Singularity image is built with x86_64 architecture or sif may get built with arm64  

Next, transfer the bwa0.7.17.sif file to the system on which you want to run BWA from the Singularity container  

### 5. Test singularity container on (HPC) system with Singularity/Apptainer available  
``` bash
# set up path to the Singularity container
BWA_SIF=path/to/bwa0.7.17.sif

# Test that <tool> can run from Singularity container
singularity run $BWA_SIF bwa # depending on system/version, singularity may be called apptainer
```