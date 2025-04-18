#!/bin/bash
#SBATCH --output=./logs/run_genomad-%a.out
#SBATCH --error=./logs/run_genomad-%a.err
#SBATCH --account=msbarker
#SBATCH --partition=standard
#SBATCH --nodes=1
#SBATCH --ntasks=2
#SBATCH --time=2:00:00
#SBATCH --cpus-per-task=12
#SBATCH --mem-per-cpu=5gb
#SBATCH --array=0-1

pwd; hostname; date
source ./config.sh
names=($(cat ${LIST}))

DB_DIR="./genomad_db"

SAMPLE_ID=${names[${SLURM_ARRAY_TASK_ID}]}

INPUT="${OUTDIR}/${SAMPLE_ID}/final.contigs.fa.gz"
OUTPUT="./genomad_output/${SAMPLE_ID}"

if [[ ! -d "${OUTPUT}" ]]; then
  echo "${OUTPUT} does not exist. Directory created"
  mkdir -p ${OUTPUT}
fi


BIND="--bind $(pwd):/app"

echo "Running Genomad: download-database"

apptainer run ${BIND} "${GENOMAD}" download-database .

# Step 2: Run end-to-end pipeline

echo "Running Genomad: end-to-end"

apptainer run ${BIND} "${GENOMAD}" end-to-end "${INPUT}" "${OUTPUT}" genomad_db
