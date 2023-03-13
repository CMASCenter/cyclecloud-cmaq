#!/bin/csh -f
#Script to download enough data to run START_DATE 20171222 and END_DATE 20171223 for CONUS1 Domain
#Requires installing aws command line interface
#https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html#cliv2-linux-install
#Total storage required is 44 G
# test using --dryrun option, example aws --no-sign-request s3 cp --dryrun ...
# Assumes you have a /lustre directory to copy the files to /lustre/data.

setenv AWS_REGION "us-east-1"
mkdir -p /lustre/data
setenv DISK lustre/data
aws --no-sign-request s3 cp  --recursive --exclude "*" --include "*20171222*" --include "*20171223*" s3://cmas-cmaq-modeling-platform-2018/2018_12US1/met/WRFv4.3.3_LTNG_MCIP5.3.3_compressed /$DISK/CMAQ_Modeling_Platform_2018/2018_12US1/met/WRFv4.3.3_LTNG_MCIP5.3.3_compressed
aws --no-sign-request s3 cp --recursive --exclude "*" --include "*20171222*" --include "*20171223*" --include "*20181208*" --include "*20181209*" --include "*20181222*" --include "*20181204*" --include "smk_merge_dates_201712_for2018spinup.txt" s3://cmas-cmaq-modeling-platform-2018/2018_12US1/emis/WR705_2018gc2_cracmmv1 /$DISK/CMAQ_Modeling_Platform_2018/2018_12US1/emis/WR705_2018gc2_cracmmv1
aws --no-sign-request s3 cp --recursive --exclude "*" --include "*stack_groups*20171222*" --include "*stack_groups*20171223*" --include  "*stack_groups_*_20181222*" --include "*stack_groups_ptegu*" --include "*stack_groups_cmv*" --include "*stack_groups_othpt*" --include "*stack_groups_pt_oilgas*" --include "*stack_groups_ptnonipm*"  s3://cmas-cmaq-modeling-platform-2018/2018_12US1/emis/WR705_2018gc2_cracmmv1 /$DISK/CMAQ_Modeling_Platform_2018/2018_12US1/emis/WR705_2018gc2_cracmmv1
aws --no-sign-request s3 cp --recursive  s3://cmas-cmaq-modeling-platform-2018/2018_12US1/emis/emis_dates /$DISK/CMAQ_Modeling_Platform_2018/2018_12US1/emis/emis_dates
aws --no-sign-request s3 cp --recursive --exclude "*" --include "*beld4_12US1_2011.nc4*" --include "*beis4_beld6_norm_emis.12US1*" --include "*2017r1_EPIC0509_12US1_soil.nc4*"  --recursive s3://cmas-cmaq-modeling-platform-2018/2018_12US1/epic /$DISK/CMAQ_Modeling_Platform_2018/2018_12US1/epic
aws --no-sign-request s3 cp  --recursive s3://cmas-cmaq-modeling-platform-2018/2018_12US1/surface /$DISK/CMAQ_Modeling_Platform_2018/2018_12US1/surface
aws --no-sign-request s3 cp --recursive s3://cmas-cmaq-modeling-platform-2018/2018_12US1/misc /$DISK/CMAQ_Modeling_Platform_2018/2018_12US1/misc
aws --no-sign-request s3 cp  --recursive --exclude "*" --include "*cracmm1*" --include "*BCON_CONC_12US1_CMAQv54_2018_108NHEMI_CRACCM1_FROM_CB6R5M_M3DRY_regrid_201712.nc*" s3://cmas-cmaq-modeling-platform-2018/2018_12US1/icbc /$DISK/CMAQ_Modeling_Platform_2018/2018_12US1/icbc
aws --no-sign-request s3 cp  --recursive --exclude "*" --include "*GRIDDESC*" s3://cmas-cmaq-modeling-platform-2018/2018_12US1/ /$DISK/CMAQ_Modeling_Platform_2018/2018_12US1
aws --no-sign-request s3 cp --recursive --exclude "*" --include "*run_cctm_2018*" s3://cmas-cmaq-modeling-platform-2018/2018_12US1/ /$DISK/CMAQ_Modeling_Platform_2018/2018_12US1
