#!/bin/csh -f
# Script to upload output data to S3 bucket
# NOTE: a new bucket needs to be created to store each set of cluster runs

cd /shared/build/openmpi_gcc/CMAQ_v54/CCTM/scripts
cp run*.log /shared/data/output
cp run*.csh /shared/data/output

aws s3 mb s3://hbv3-120-v54-compute-conus-output
aws s3 cp --recursive /shared/data/output/ s3://hbv3-120-v54-compute-conus-output/
