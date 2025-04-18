#!/bin/bash
#SBATCH --output=./logs/run_genomad-%a.out
#SBATCH --error=./logs/run_genomad-%a.err
#SBATCH --account=msbarker
#SBATCH --partition=standard
#SBATCH --nodes=1
#SBATCH --ntasks=2
#SBATCH --time=24:00:00
#SBATCH --cpus-per-task=12
#SBATCH --mem-per-cpu=5gb
#SBATCH --array=0-1

pwd; hostname; date
source ./config.sh
names=($(cat ${LIST}))

# set genomad db directory to be downloaded by apptainer run
DB_DIR="./genomad_db"
# array for sample_ids 
SAMPLE_ID=${names[${SLURM_ARRAY_TASK_ID}]}
# set i/o
INPUT="${OUTDIR}/${SAMPLE_ID}/final.contigs.fa.gz"
OUTPUT="./genomad_output/${SAMPLE_ID}"
# make output dir if it doesn't exist
if [[ ! -d "${OUTPUT}" ]]; then
  echo "${OUTPUT} does not exist. Directory created"
  mkdir -p ${OUTPUT}
fi

# set bind for apptainer/docker image
BIND="--bind $(pwd):/app"
# Step 1: Download database
echo "Running Genomad: download-database"

apptainer run ${BIND} "${GENOMAD}" download-database .

# Step 2: Run end-to-end pipeline

echo "Running Genomad: end-to-end"

apptainer run ${BIND} "${GENOMAD}" end-to-end "${INPUT}" "${OUTPUT}" genomad_db
