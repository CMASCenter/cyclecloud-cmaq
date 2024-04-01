# CMAQv5.4+ Benchmark on HBv3_120 compute nodes and beeond

Run CMAQv5.4+ on a using pre-loaded software and input data on Beeond using HBv3_120 Cycle Cloud.
Running using the Beeond fileystem, which uses the /nvme or fast file systems on each compute node is free, and gives performance that is almost as good as running on lustre.
In addition, the beeond fileystem is created and destroyed as part of the run script.
For the lustre managed filesystem, we did not have a way to create the filesystem when the job was started and stop it when it stopped, so we incurred costs for leaving it on for months.


Note about Lustre managed filesystem, the cost varies by performance and has a minimum size that varies by performance type, for the benchmarks run, we used a 250MB/s Lustre filesystems that was 20 TB in size?.

Lustre 250 MB/s for provisioned for 20 TiB our account was charged $3,386 / month


Due to these significant costs, we do not recommend using Lustre, but instead recommend the Beeond filesystem, that is free.

```{toctree}
cmaqv54+_hbv3_120_beeond.md
run-cmaq-desid-hbv3_120_beeond.md

