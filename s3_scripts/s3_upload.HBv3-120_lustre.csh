#!/bin/csh -f
# Script to upload output data to S3 bucket
# NOTE: a new bucket needs to be created to store each set of cluster runs

cd /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts
cp run*.log /lustre/data/output/logs
cp run*.csh /lustre/data/output/scripts

aws s3 mb s3://cyclecloud-hbv3-120-compute-conus-lustre-output
aws s3 cp --recursive /lustre/data/output/ s3://cyclecloud-hbv3-120-compute-conus-lustre-output/
