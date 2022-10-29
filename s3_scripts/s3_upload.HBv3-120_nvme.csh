#!/bin/csh -f
# Script to upload output data to S3 bucket
# NOTE: a new bucket needs to be created to store each set of cluster runs

cd /mnt/nvme/build/openmpi_gcc/CMAQ_v533/CCTM/scripts
cp run*.log /mnt/nvme/data/output
cp run*.csh /mnt/nvme/data/output

aws s3 mb s3://hbv3-120-compute-conus-nvme-output
aws s3 cp --recursive /mnt/nvme/data/output/ s3://hbv3-120-compute-conus-nvme-output/
# aws s3 cp --recursive /mnt/nvme/data/POST s3://hbv3-120-compute-conus-nvme-output/
