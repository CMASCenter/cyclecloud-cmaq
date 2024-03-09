# CMAQv5.4+ Benchmark on HBv3_120 compute nodes and beeond

Run CMAQv5.4+ on a using pre-loaded software and input data on Beeond using HBv3_120 Cycle Cloud.
Running using the Beeond fileystem, which uses the /nvme or fast file systems on each compute node is free, and gives performance that is almost as good as running on lustre.
In addition, the beeond fileystem is created and destroyed as part of the run script.
For the lustre managed filesystem, we did not have a way to create the filesystem when the job was started and stop it when it stopped, so we incurred costs for leaving it on for months.


Note about Lustre managed filesystem, the cost varies by performance and has a minimum size that varies by performance type, for the benchmarks run, we used a 250MB/s Lustre filesystems that was 10 TB in size?.

Lustre 250 MB/s for provisioned for ? TiB our account was charged $3,386 / month


According to the Azure calculators:

Standard tier delivers 125 MB/s for provisioned TiB. Under this tier, storage capacity is available in multiples of 16,000 GiB.

16000 GiB (17 TB) x 730 Hours x 0.000198Per GiB/hour = $2312 / month

Premium tier delivers 250 MB/s for provisioned TiB. Under this tier, storage capacity is available in multiples of 8,000 GiB.

8000 GiB (9 TB)  x 730 Hours x $0.000287 Per GiB/hour = $1676 / month

Ultra tier delivers 500 MB/s for provisioned TiB. Under this tier, storage capacity is available in multiples of 4,000 GiB.

4000 GiB (4.3 TB) x 730 Hours x 0.000466Per GiB/hour = $1361 / month 


Due to these significant costs, we do not recommend using Lustre, but instead recommend the Beeond filesystem, that is free.

```{toctree}
cmaqv54+_hbv3_120_beeond.md

