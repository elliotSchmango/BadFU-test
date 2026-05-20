#!/bin/bash
#SBATCH -A <your_allocation>
#SBATCH -p gpu
#SBATCH --gres=gpu:1
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 4
#SBATCH --mem=32G
#SBATCH -t 04:00:00
#SBATCH -o logs/BadFU-%j.out
#SBATCH -J BadFU

# UVA Rivanna requires loading the apptainer module alongside the container-backed pytorch module
module purge
module load apptainer pytorch/2.4.1

# Ensure logs directory exists
mkdir -p logs

echo "[INFO] Running data preparation..."
# Run the preparation script inside the container to ensure python calls have access to the pytorch environment
apptainer run --nv $CONTAINERDIR/pytorch-2.4.1.simg bash prepare_data.sh

echo "[INFO] Starting BadFU experiment..."
# Run the main experiment
apptainer run --nv $CONTAINERDIR/pytorch-2.4.1.simg python badfu.py

echo "[INFO] Job completed."
