#!/bin/csh -f
#Script to download enough data to run START_DATE 20171222 and END_DATE 20171223 for CONUS Domain for the cb6r3_ae6_20200131_MYR mechanism
#https://dataverse.unc.edu/dataset.xhtml?persistentId=doi:10.15139/S3/LDTWKH
#Requires installing aws command line interface
#https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html#cliv2-linux-install
#Total storage required is 41 G
# test using --dryrun option, example aws --no-sign-request s3 cp --dryrun ...
# Assumes you have a /shared directory to copy the files to /shared/data.

setenv AWS_REGION "us-east-1"
mkdir -p /shared/data
setenv DISK shared/data
aws s3 --no-sign-request --region=us-east-1 cp --recursive s3://cmas-cmaq/CMAQv5.4_2018_12US1_Benchmark_2Day_Input /shared/data/
