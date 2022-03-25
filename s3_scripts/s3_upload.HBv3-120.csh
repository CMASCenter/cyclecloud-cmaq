#!/bin/csh -f
# Script to upload output data to S3 bucket
# NOTE: a new bucket needs to be created to store each set of cluster runs

cd /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts
cp run*.log /fsx/data/output
cp run*.csh /fsx/data/output

aws s3 mb s3://hbv3-120-compute-conus-output
aws s3 cp --recursive /shared/data/output/ s3://hbv3-120-compute-conus-output/
aws s3 cp --recursive /shared/data/POST s3://hbv3-120-compute-conus-output/
