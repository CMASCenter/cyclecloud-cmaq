#!/bin/bash
## usage sbatch run_rscript_batch.csh
#SBATCH --job-name=compare.job
#SBATCH --output=compare.out.%J.%N
#SBATCH --error=compare.err.%J.%N
#SBATCH --partition=htc

curr_wd<-getwd()
setwd(curr_wd)
Rscript ../qa_scripts/compare_EQUATES_benchmark_output_CMAS_pcluster.r

