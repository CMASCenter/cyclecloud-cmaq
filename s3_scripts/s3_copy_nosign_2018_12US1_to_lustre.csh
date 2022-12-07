#!/bin/csh -f
#Script to download enough data for 2018_12US1
#Requires installing aws command line interface
#https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html#cliv2-linux-install
#Total storage required is ??

setenv AWS_REGION "us-east-1"
#mkdir -p /lustre/data/CMAQ_Modeling_Platform_2018
setenv DISK lustre
aws s3 cp --recursive s3://cmas-cmaq-modeling-platform-2018 /$DISK/data/CMAQ_Modeling_Platform_2018
