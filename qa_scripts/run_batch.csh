#!/bin/bash
#SBATCH --job-name=compare.job
#SBATCH --output=compare.out
#SBATCH --error=compare.err
#SBATCH --partition=htc
mkdir /shared/cyclecloud-cmaq/qa_scripts/qa_plots
Rscript /shared/cyclecloud-cmaq/qa_scripts/compare_EQUATES_benchmark_output_CMAS_pcluster.r

