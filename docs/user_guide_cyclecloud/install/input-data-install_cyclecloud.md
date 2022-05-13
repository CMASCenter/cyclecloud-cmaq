# Instructions for choosing filesystem or disk for fast I/O Performance and obtaining input data

## Install AWS CLI to obtain data from AWS S3 Bucket

see https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

`cd /shared/build`

`curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"`

`unzip awscliv2.zip`

`sudo ./aws/install`

## edit .cshrc file to add /usr/local/bin to path

`vi ~/.cshrc`

add /usr/local/bin to the set path line

Run csh at the command line 

### Verify you can run the aws command

` aws --help`

If not, you may need to logout and back in.

Set up your credentials for using s3 copy (you can skip this if you do not have credentials)

`aws configure`


## Azure Cyclecloud install input on the /shared/data directory

`mkdir /shared/data`

`ls /shared/data`

`df -h`

Output:

`/dev/mapper/vg_cyclecloud_builtinshared-lv0 1000G   66G  935G   7% /shared `


## Use the S3 script to copy the CONUS input data from the CMAS s3 bucket
Modify the script if you want to change where the data is saved to.  Script currently uses /shared/data 

`/shared/cyclecloud-cmaq/s3_scripts/s3_copy_nosign_conus_cmas_opendata_to_shared.csh`


check that the resulting directory structure matches the run script

Note, this input data requires 44 GB of disk space  (if you use the yaml file to import the data to the lustre file system rather than copying the data you save this space)

`cd /shared/data/CMAQ_Modeling_Platform_2016/CONUS/12US2`

`du -sh`

output:

```
44G     .
```

CMAQ Cycle Cloud is configured to have 1 Terrabytes of space on the /shared filesystem, to allow multiple output runs to be stored.
