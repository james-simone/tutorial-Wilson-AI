#! /bin/bash

#SBATCH --job-name=MNIST
#SBATCH --mail-type=NONE
#SBATCH --output=job_%x_%A.out
#SBATCH --partition=gpu_gce
#SBATCH --nodes=1
#SBATCH --gres=gpu:v100:1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --time=00:30:00

module load apptainer

export WCPROJECT=simone

# Repository for my project's containers
export CONT_DIR=/wclustre/${WCPROJECT}/containers/

# Torch container
TORCH=${CONT_DIR}/pytorch-23.02-py3.sif

# Check that GPUs are visible by executing nvidia-smi from within the container
apptainer exec --home=/work1/${WCPROJECT} --nv ${TORCH} /usr/bin/nvidia-smi

# Run MNIST training; the python script is in the directory where the batch job was submitted.
apptainer exec --home=/work1/${WCPROJECT} --nv ${TORCH} /usr/bin/python ./mnist_main.py

