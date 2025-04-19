#!/bin/bash
#SBATCH --output=./logs/run_genomad-%a.out
#SBATCH --error=./logs/run_genomad-%a.err
#SBATCH --account=msbarker
#SBATCH --partition=standard
#SBATCH --nodes=1
#SBATCH --ntasks=2
#SBATCH --time=2:00:00
#SBATCH --cpus-per-task=12
#SBATCH --mem-per-cpu=6gb
#SBATCH --array=0-1

pwd; hostname; date
source ./config.sh
names=($(cat ${LIST}))

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

# Run end-to-end pipeline, skipping nn-classification for exercise brevity

echo "Running Genomad: end-to-end"

apptainer run ${BIND} "${GENOMAD}" end-to-end \
 --min-score 0.7 \
 --disable-nn-classification \
 "${INPUT}" "${OUTPUT}" genomad_db
