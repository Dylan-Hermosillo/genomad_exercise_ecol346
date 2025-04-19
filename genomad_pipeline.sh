#!/bin/bash

# 01A get database -- no dependencies
job1=$(sbatch run_genomad_db.sh)
jid1=$(echo $job1 | sed 's/^Submitted batch job //')
echo $jid1

# 01B run genomad -- depends on jid1
job2=$(sbatch --dependency=afterok:$jid1 run_genomad.sh)
jid2=$(echo $job2 | sed 's/^Submitted batch job //')
echo $jid
