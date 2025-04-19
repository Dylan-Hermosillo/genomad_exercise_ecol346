#!/bin/bash
#SBATCH --output=./logs/run_genomad_db-%a.out
#SBATCH --account=msbarker
#SBATCH --partition=standard
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=1:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1gb
#SBATCH --array=0

source ./config.sh

# set genomad db directory to be downloaded by apptainer run
DB_DIR="./genomad_db"

# set bind for apptainer/docker image
BIND="--bind $(pwd):/app"
# Step 1: Download database
echo "Running Genomad: download-database"

apptainer run ${BIND} "${GENOMAD}" download-database .
