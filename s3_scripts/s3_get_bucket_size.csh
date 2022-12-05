#!/bin/csh -f
# Script to list files and get size of all data in bucket

aws s3 ls --summarize --human-readable --recursive s3://cmas-cmaq-conus2-benchmark
