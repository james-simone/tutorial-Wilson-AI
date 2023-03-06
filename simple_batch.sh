#! /bin/bash

#SBATCH --job-name=simple
#SBATCH --mail-type=NONE
#SBATCH --output=job_%x_%A.out
#SBATCH --partition=gpu_gce
#SBATCH --nodes=1
#SBATCH --gres=gpu:p100:1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=2
#SBATCH --time=00:05:00


nvidia-smi
