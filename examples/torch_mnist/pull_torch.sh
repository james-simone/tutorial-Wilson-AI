#! /bin/bash

# my WC project's name
export WCPROJECT=simone

# NGC tag for the Torch version we want
NGC_TAG=23.02-py3

# load Apptainer
module load apptainer

# Use Lustre for Apptainer cache rather than home directory
export APPTAINER_CACHEDIR=/wclustre/${WCPROJECT}/apptainer/.apptainer/cache
mkdir -p $APPTAINER_CACHEDIR

# Repository for my project's containers
export CONT_DIR=/wclustre/${WCPROJECT}/containers/

SIF=pytorch-${NGC_TAG}.sif # output image
SRC=nvcr.io/nvidia/pytorch:${NGC_TAG} # from https://catalog.ngc.nvidia.com/orgs/nvidia/containers/pytorch/tags

# Pull the container
apptainer pull ${CONT_DIR}/${SIF} docker://${SRC}

# force cleaning of the build cache
#apptainer cache clean --force

