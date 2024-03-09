## Copy Output Data and Run script logs to S3 Bucket

Note, you will need permissions to copy to a S3 Bucket.
see <a href="<https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-access-control.html">S3 Access Control</a>

Currently, the bucket listed below has ACL turned off
see <a href="https://docs.aws.amazon.com/AmazonS3/latest/userguide/about-object-ownership.html">S3 disable ACL</a>

See example of sharing bucket across accounts.
see <a href="https://docs.aws.amazon.com/AmazonS3/latest/userguide/example-walkthroughs-managing-access-example2.html">Bucket owner granting cross-account permissions</a>

### Copy scripts and logs to /shared

The CTM_LOG files do not contain any information about the compute nodes that the jobs were run on.
Note, it is important to keep a record of the NPCOL, NPROW setting and the number of nodes and tasks used as specified in the run script: #SBATCH --nodes=16 #SBATCH --ntasks-per-node=8
It is also important to know what volume was used to read and write the input and output data, so it is recommended to save a copy of the standard out and error logs, and a copy of the run scripts to the OUTPUT directory for each benchmark.

```
cd /shared/build/openmpi_gcc/CMAQ_v54/CCTM/scripts
cp run*.log /shared/data/output
cp run*.csh /shared/data/output
```
### Examine the output files

```
cd /shared/data/output/output_v54_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_3x96
ls -lrt
```

output:

```
-rw-rw-r--. 1 lizadams lizadams   14839992 Mar  8 00:27 CCTM_BSOILOUT_v54_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_3x96_20171222.nc
-rw-rw-r--. 1 lizadams lizadams   52713180 Mar  8 00:27 CCTM_MEDIA_CONC_v54_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_3x96_20171222.nc
-rw-rw-r--. 1 lizadams lizadams 2253034072 Mar  8 00:27 CCTM_DRYDEP_v54_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_3x96_20171222.nc
-rw-rw-r--. 1 lizadams lizadams 1831415812 Mar  8 00:27 CCTM_WETDEP1_v54_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_3x96_20171222.nc
-rw-rw-r--. 1 lizadams lizadams  178430048 Mar  8 00:27 CCTM_CONC_v54_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_3x96_20171222.nc
-rw-rw-r--. 1 lizadams lizadams 2924988384 Mar  8 00:27 CCTM_ACONC_v54_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_3x96_20171222.nc
-rw-rw-r--. 1 lizadams lizadams 1989523012 Mar  8 00:27 CCTM_AELMO_v54_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_3x96_20171222.nc
-rw-rw-r--. 1 lizadams lizadams 4323159700 Mar  8 00:27 CCTM_CGRID_v54_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_3x96_20171222.nc
-rw-rw-r--. 1 lizadams lizadams    2378548 Mar  8 00:27 CCTM_BUDGET_v54_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_3x96_20171222.txt
drwxrwxrwx. 2 lizadams lizadams      24576 Mar  8 00:29 LOGS
-rw-rw-r--. 1 lizadams lizadams   14839992 Mar  8 00:57 CCTM_BSOILOUT_v54_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_3x96_20171223.nc
-rw-rw-r--. 1 lizadams lizadams   52713180 Mar  8 00:57 CCTM_MEDIA_CONC_v54_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_3x96_20171223.nc
-rw-rw-r--. 1 lizadams lizadams 2253034072 Mar  8 00:57 CCTM_DRYDEP_v54_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_3x96_20171223.nc
-rw-rw-r--. 1 lizadams lizadams 1831415812 Mar  8 00:57 CCTM_WETDEP1_v54_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_3x96_20171223.nc
-rw-rw-r--. 1 lizadams lizadams  178430048 Mar  8 00:57 CCTM_CONC_v54_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_3x96_20171223.nc
-rw-rw-r--. 1 lizadams lizadams 2924988384 Mar  8 00:57 CCTM_ACONC_v54_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_3x96_20171223.nc
-rw-rw-r--. 1 lizadams lizadams 1989523012 Mar  8 00:57 CCTM_AELMO_v54_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_3x96_20171223.nc
-rw-rw-r--. 1 lizadams lizadams 4323159700 Mar  8 00:57 CCTM_CGRID_v54_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_3x96_20171223.nc
-rw-rw-r--. 1 lizadams lizadams    2378548 Mar  8 00:57 CCTM_BUDGET_v54_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_3x96_20171223.txt
```

Check disk space

```
 du -sh
```

Output
```
26G
```

### Copy the output to an S3 Bucket

Examine the example script

```
cd s3_scripts
cat s3_upload.HBv3-120_v54.csh 

```

output:

```
#!/bin/csh -f
# Script to upload output data to S3 bucket
# NOTE: a new bucket needs to be created to store each set of cluster runs

cd /shared/build/openmpi_gcc/CMAQ_v54/CCTM/scripts
cp run*.log /shared/data/output
cp run*.csh /shared/data/output

aws s3 mb s3://hbv3-120-v54-compute-conus-output
aws s3 cp --recursive /shared/data/output/ s3://hbv3-120-v54-compute-conus-output/

```

If you do not have permissions to write to the s3 bucket listed above, you will need to edit the script to specify the s3 bucket that you have permissions to write to.
In addition, edit the script to include a new date stamp, then run the script to copy all of the CMAQ output and logs to the S3 bucket.

```
./s3_upload.HBv3-120_v54.csh
```
