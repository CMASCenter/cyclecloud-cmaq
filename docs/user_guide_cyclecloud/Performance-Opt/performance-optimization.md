Performance Optimization for Cycle Cloud

## Right-sizing Compute Nodes for the CycleCloud

Selection of the compute nodes depends on the domain size and resolution for the CMAQ case, and what your model run time requirements are.
Larger hardware and memory configurations may also be required for instrumented versions of CMAQ incuding CMAQ-ISAM and CMAQ-DDM3D.
The CycleCloud allows you to run the compute nodes only as long as the job requires, and you can also update the compute nodes as needed for your domain.

## An explanation of why a scaling analysis is required for Multinode or Parallel MPI Codes

Quote from the following link.

"IMPORTANT: The optimal value of --nodes and --ntasks for a parallel code must be determined empirically by conducting a scaling analysis. As these quantities increase, the parallel efficiency tends to decrease. The parallel efficiency is the serial execution time divided by the product of the parallel execution time and the number of tasks. If multiple nodes are used then in most cases one should try to use all of the CPU-cores on each node."

```{note}
For the scaling analysis that was performed with CMAQ, the parallel efficiency was determined as the runtime for the smallest number of CPUs divided by the product of the parallel execution time and the number of additional cpus used. If smallest NPCOLxNPROW configuration was 18 cpus, the run time for that case was used, and then the parallel efficiency for the case where 36 cpus were used would be parallel efficiency = runtime_18cpu/(runtime_36cpu*2)*100
```

```{seealso}
<a href="https://researchcomputing.princeton.edu/support/knowledge-base/scaling-analysis">Scaling Analysis - see section on Multinode or Parallel MPI Codes</a>

<a href="https://researchcomputing.princeton.edu/support/knowledge-base/slurm#multinode">Example Slurm script for Multinode Runs</a>
```

## Slurm Compute Node Provisioning

Azure CycleCloud relies on SLURM to make the job allocation and scaling decisions. The jobs are launched, terminated, and resources maintained according to the Slurm instructions in the CMAQ run script. The CycleCloud Web Interface is used to set the identity of the head node and the compute node, and the maximum number of compute nodes that can be submitted to the queue. 

Number of compute nodes dispatched by the slurm scheduler is specified in the run script using #SBATCH --nodes=XX #SBATCH --ntasks-per-node=YY where the maximum value of tasks per node or YY limited by many CPUs are on the compute node.

As an example:

For HC44rs, there are 44 CPUs/node, so maximum value of YY is 44 or --ntask-per-node=44.
For many of the runs that were done, we set --ntask-per-node=36 so that we could compare to the c5n.9xlarge on Parallel Cluster

If running a job with 180 processors, this would require the --nodes=XX or XX to be set to 5 compute nodes, as 36x5=180.

The setting for NPCOLxNPROW must also be a maximum of 180, ie. 18 x 10 or 10 x 18 to use all of the CPUs in the parallel cluster.

For HBv120, there are 120 CPUS/node, so maximum value of YY is 120 or --ntask-per-node=120.

If running a job with 240 processors, this would require the --nodes=XX or XX to be set to 2 compute nodes, as 120x2=240.

<a href="https://azure.com/e/a5d6f8654d634e8b93973574cbda428d">Azure HBv3-120 Pricing</a>

![Azure HPC HBv3_120pe Pricing](./Azure_HPC_HBv3_Pricing.png)


Table 1. Azure Instance On-Demand versus Spot Pricing (price is subject to change)

| Instance Name	| CPUs |  RAM      |  Memory Bandwidth	| Network Bandwidth | Linux On-Demand Price | Linux Spot Price | 
| ------------  | ----- | --------  | ---------------   | ---------------   | --------------------  | ---------------  |
| HBv3-120	| 120	|  448 GiB   |	 350 Gbps	        | 200 Gbps(Infiniband)          |   $3.6/hour         | $1.4/hour     |



Table 2. Timing Results for CMAQv5.3.3 2 Day CONUS2 Run on Cycle Cloud with D12v2 schedulare node and HBv3-120 Compute Nodes (120 cpu per node) I/O on /shared directory

Note, two different CPUs were used, 

Old CPU (logs between Feb. 16 - March 21, 2022)
Vendor ID:             AuthenticAMD
CPU family:            25
Model:                 1
Model name:            AMD EPYC 7V13 64-Core Processor
Stepping:              0
CPU MHz:               2445.405
BogoMIPS:              4890.81

New CPU (logs after March 22, 2022)
Vendor ID:             AuthenticAMD
CPU family:            25
Model:                 1
Model name:            AMD EPYC 7V73X 64-Core Processor
Stepping:              2
CPU MHz:               1846.530
BogoMIPS:              3693.06


| CPUs | Nodes | NodesxCPU | COLROW | Day1 Timing (sec) | Day2 Timing (sec) | TotalTime | CPU Hours/day | SBATCHexclusive |   Equation using Spot Pricing | SpotCost | Equation using On Demand Pricing | OnDemandCost | compiler flag | InputData | cpuMhz |
| -----| ---- | -----------    | -----------   | ----------------     | ---------------      | ------------------- |  ------------------ |  ---------        |   -------- | --------- | ---------------      | -- | -- | -- | -- |
| 90   | 1 |  1x90     |    9x10            |   3153.33            |  2758.12             |   5911.45   | .821 |  no | $1.4/hr * 1 nodes * 1.642 hr = | $2.29             |  $3.6/hr * 1 nodes * 1.642 hr = |  5.911           |  without -march=native compiler flag | shared | 2445.402 |
| 120  | 1 |   1x120    |    10x12           | 2829.84              |  2516.07             |   5345.91   | .742 |  no | $1.4/hr * 1 nodes * 1.484 hr = | $2.08           | $3.6/hr * 1 nodes * 1.484 hr = | 5.34                     | without -march=native compiler flag | shared | 2445.400 | 
| 180  | 2 |   2x90          | 10x18         | 2097.37              | 1809.84              |    3907.21  | .542 |  no | $1.4/hr * 2 nodes * 1.08 hr = | $3.03 | $3.6/hr * 2 nodes * 1.08 hr = |  7.81 | with -march=native compiler flag | shared | 2445.395 | 
| 180  | 2 |   2x90     |    10 x 18         | 1954.20              | 1773.86              |    3728.06  | .518 |  no | $1.4/hr * 2 nodes * 1.036 hr = | $2.9 | $3.6/hr * 2 nodes * 1.036 hr = | 7.46 | without -march=native compiler flag | shared | 2445.405 | 
| 180  | 5 |  5x36     |   10x18            | 1749.80              | 1571.50              |    3321.30  |  .461  | no | $1.4/hr * 5 nodes * .922 hr = | $6.46 | $3.6/hr * 5 nodes * .922 hr =  | 16.596 | without -march=native compiler flag | shared | 1846.529 | 
| 240  | 2 |   2x120    |   20x12            |  1856.50             | 1667.68              |    3524.18  | .4895 | no | $1.4/hr * 2 nodes * .97 hr = | $2.716           |  $3.6/hr * 2 nodes * .97 hr = | 6.984   | without -march=native compiler flag | shared | 2445.409 | 
| 270  | 3 |  3x90          | 15x18         | 1703.19              | 1494.17              |    3197.36  | .444  |  no | $1.4/hr * 3 nodes * .888hr = | $3.72 | 3.6/hr * 3 nodes * .888 = | 9.59  | with -march=native compiler flag | shared | 2445.400 |
| 360  | 3 |  3x120     |  20x18             | 1520.29              |  1375.54             |    2895.83 | .402   | no | $1.4/hr * 3 nodes * .804 = | $3.38 | 3.6/hr * 3 nodes * .804 = | 8.687 | with -march=native compiler flag | shared | 2445.399 |
| 360  |  3    |  3x120     | 20x18         | 1512.33               | 1349.54              | 2861.87 | .397   | no  | $1.4/hr * 3 nodes * .795 = | $3.339 | 3.6/hr * 3 nodes * .795 = | 8.586 |      with -march=native compiler flag | shared | 1846.530 |

Total HBv3-120 compute cost of Running Benchmarking Suite using SPOT pricing = $1.4/hr

Total HBv3-120 compute cost of Running Benchmarking Suite using ONDEMAND pricing = $3.6/hr

Savings is ~ 60% for spot versus  ondemand pricing for HBv3-120 compute nodes.

<a href="https://azure.microsoft.com/en-us/pricing/details/virtual-machines/linux/">Azure Spot and On-Demand Pricing</a>

Table 3. Timing Results for CMAQv5.3.3 2 Day CONUS2 Run on Cycle Cloud with D12v2 schedulare node and HBv3-120 Compute Nodes (120 cpu per node), I/O on mnt/resource/data2 directory

| CPUs | Nodes | NodesxCPU | COLROW | Day1 Timing (sec) | Day2 Timing (sec) | TotalTime | CPU Hours/day | SBATCHexclusive |    Equation using Spot Pricing | SpotCost | Equation using On Demand Pricing | OnDemandCost | compiler flag | InputData | cpuMhz |
| ------ | ---- | -----------    | -----------   | ----------------     | ---------------      | ------------------- |  ------------------ |    -------- | --------- | ------ | ---------------      | --- |  --  | -- | -- |
| 18  |  1 |   1x16     |   3x6              | 10571.20         | 9567.43      | 20138.63  | 2.80  | no   | $1.4/hr * 1 nodes * 5.59 hr = |  $7.83 |  $3.6/hr * 1 nodes * 5.59 hr = | 20.12  |  without -march=native compiler flag | /data | 1846.533 | 
| 36  |  1 |   1x36     |    6x6             | 5933.48              | 5230.05  | 11163.53  | 1.55  |   no | $1.4/hr * 1 nodes * 3.1 hr = |  $4.34  | $3.6/hr * 1 nodes * 3.1 hr = | 11.2     | without -march=native compiler flag |  /data | 1846.533 |
| 36  | 1 |   1x36     |    6x6             | 5841.81              | 5153.47  | 10995.28  | 1.52  |  no  | $1.4/hr * 1 nodes * 3.0 hr = | $4.26   | $3.6/hr * 1 nodes * 3.0 hr = | 10.8    | without -march=native compiler flag | /mnt/resource/data2/ | 1846.533 |
| 120  |  1  |   1x120     |    10x12            |  2781.89       |  2465.87 | 5247.76   | .729 |  no |  $1.4/hr * 1 nodes * 1.642 hr = | $2.29 |  $3.6/hr * 1 nodes * 1.642 hr = | 5.911 |  without -march=native compiler flag | /data       | 1846.533 |
| 120 | 1  |   1x120    |    10x12           | 3031.81         |  2378.64   | 5410.45   | .751 |  no |  $1.4/hr * 1 nodes * 1.484 hr = | $2.08 | $3.6/hr * 1 nodes * 1.484 hr = | 5.34  | without -march=native compiler flag   | /mnt/resource/data2       | 1846.533 |
| 120 |  1 | 1x120      |  10x20             | 2691.40         | 2380.51    | 5071.91   | .704  | no |  $1.4/hr * 1 nodes * 1.408 hr = | 1.97   | $3.6/hr * 1 nodes * 1.408 = |  5.07 |   without -march=native compiler flag | i: /mnt/resource/data2 o: /data | 1846.533 |
| 180 | 5   |   5x36      |  10x18            | 1749.80      | 1571.50        | 3321.30  | .461  | no |  $1.4/hr * 5 nodes * .923 = | 6.45  |  $3.6/hr * 5 nodes * .923 hr = | 16.614 | without -march=native compiler flag | /shared | 1846.533 |         
| 960 | 8   |  8x120     | 30x32             | 1223.52              |  1126.19             |    2349.71  | .326   |  no | $1.4/hr * 8 nodes * .653 = | $7.31 | 3.6/hr * 8 nodes * .653 = | 18.8   | with -march=native compiler flag | /data  |  2445.399 | 
| 960 |  8  |  8x120    | 30x32              | 1189.21              |  1065.73             |   2254.94   | .313   |  no | $1.4/hr * 8 nodes * .626 = | 7.01  | 3.6/hr * 8 nodes * .626 = | 18.0   | with -march=native compiler flag | /data | 1846.533  |


Table 4. Timing Results for CMAQv5.3.3 2 Day CONUS2 Run on Cycle Cloud with D12v2 schedular node and HC44RS Compute Nodes (44 cpus per node)

Note, the CPU Mhz values are reported in the table below.

```
Vendor ID:             GenuineIntel
CPU family:            6
Model:                 85
Model name:            Intel(R) Xeon(R) Platinum 8168 CPU @ 2.70GHz
Stepping:              4
CPU MHz:               2693.763
BogoMIPS:              5387.52
```


| CPUs | Nodes | NodesxCPU | COLROW | Day1 Timing (sec) | Day2 Timing (sec) | TotalTime | CPU Hours/day | SBATCHexclusive |  Equation using Spot Pricing | SpotCost | Equation using On Demand Pricing | OnDemandCost | compiler flag | InputData |
| ---- | ----  | -----------   | ----------------     | ---------------      | ----------- | -----      | --------------          | ---------                              | --------- | ------ | ---------------      | --- | ---- | ---- |
| 18  | 1   |   1x18     |    3x6        | 13525.66       | 12107.02  |   25632.68  | 3.56  |  no  |     $.3168/hr * 1 nodes * 7.12 = | $2.26 | 3.186/hr * 1 nodes * 7.12 = | 22.68   | with -march=native compiler flag | shared |
| 36  |   1     |  1x36     | 6x6            |  7349.06      | 6486.37   |   13835.43  |  1.92 | no  |   $.3168/hr * 1 nodes * 3.84 = | $1.22 | 3.186/hr * 1 nodes * 3.84 = | 12.23   | with -march=native compiler flag | /shared |
| 40  |   1     | 1x40      | 4x10           | 6685.74       | 5935.01   | 12620.75    |  1.75 | no  |   $.3168/hr * 1 nodes * 3.5 = | $1.11 | 3.168/hr * 1 nodes * 3.5 = | 11 | with -march=native compiler flag | /shared |
| 72  |  2  |  2x36     | 8x9            |  4090.80      | 3549.60  | 7640.40      |  1.06 | no  |   $.3168/hr * 2 nodes * 2.12 = | $1.34 | 3.168/hr * 2 nodes * 2.12 = | 13.4   | with -march=native compiler flag | /shared |
| 108 |  3  |  3x36     | 9x12           | 2912.59       | 2551.08  | 5463.67      |  .758 | no  |    $.3168/hr * 3 nodes * 1.517 = | $1.44 | 3.168/hr * 3 nodes * 1.517 = |  14.41 | with -march=native compiler flag | /shared | 
| 126 |   7  | 7x18      |  9x14          | 2646.52       | 2374.21  | 5020.73      | .69   | no  |    $.3168/hr * 7 nodes * 1.517 = | $3.36 | 3.168/hr * 7 nodes * 1.517 = | 33.64 | with -march=native compiler flag | /shared |
| 144  | 4 |  4x36     |  12x12         | 2449.39       | 2177.28  | 4626.67      |  .64  | no  |    $.3168/hr * 4 nodes * 1.285 = | $1.63 | 3.168/hr * 4 nodes * 1.285 = | 16.28 | with -march=native compiler flag | /shared |
| 180 |  5 |  5x36     | 10x18            |  2077.22   |   1851.77   | 3928.99   |  .545 | no |   $.3168/hr * 5 nodes * 1.09 = | $1.72 | 3.168/hr * 5 nodes * 1.09 = | 17.26   | with -march=native compiler flag | /shared |
| 216 |  6  |  6x36     | 18x12            |  1908.15   | 1722.07    | 3630.22    |  .504 | no   |  $.3168/hr * 6 nodes * 1.01 = | $1.92 |  3.168/hr * 6 nodes * 1.01 = | 19.16 | with -march=native compiler flag  | /shared |
| 288 |  8  |  8x36     | 16x18            |  1750.36   |  1593.29    |   3343.65 |  .464 | no |   $.3168/hr * 8 nodes * .928 = | $2.35 | 3.168/hr * 8 nodes * .928 = | 39.54   | with -march=native compiler flag | /shared | 

# Benchmark Scaling Plots

## Benchmark Scaling Plot for HC44rs

Figure 1. Scaling per Node on HC44rs Compute Nodes (44 cpu/node)

![Scaling per Node for HC44rs Compute Nodes (44cpu/node)](../../qa_plots/scaling_plots/hc44rs_Scaling_Node.png)

Figure 2. Scaling per CPU on HC44rs Compute Nodes (44 cpu/node)

![Scaling per CPU for HC44rs Comput Nodes (44cpu/node)]((../../qa_plots/scaling_plots/hc44rs_Scaling_CPUs.png)

Figure 3.  Scaling per Node on HBv120 Compute Nodes (120 cpu/node)

![Scaling per Node for HBv120 Compute Nodes (120cpu/node](../../qa_plots/scaling_plots/hbv120_Scaling_Node.png)

Figure 4. Scaling per CPU on HBv120 Compute Node (120 cpu/node)

![Scaling per CPU for HBv120 Compute Nodes (120cpu/node](../../qa_plots/scaling_plots/hbv120_Scaling_CPUs.png)



HC44RS SPOT Pricing $.3168

HC44RS ONDEMAND pricing $3.168

Savings is ~ 90% for spot versus ondemand pricing for HC44RS compute nodes.

Figure 2. Scaling Plot Comparison of Parallel Cluster and Cycle Cloud

![Scaling Plot Comparison of Parallel Cluster and Cycle Cloud](../../qa_plots/scaling_plots/Scaling_Parallel_Cluster_vs_Cycle_Cloud.png)

Note CMAQ scales well up to ~ 200 processors for the CONUS domain.  As more processors are added beyond 200 processors, the CMAQ gets less efficient at using all of them.
The Cycle Cloud HC44RS performance is similar to the c5n.18xlarge using 36 cpus/node on 8 nodes, or 288 cpus.
cost is $39.54 for Cycle Cloud compared to $19.46  for Parallel Cluster for the 2-Day 12US2 CONUS Benchmark.

Figure 3. Plot of Total Time and On Demand Cost versus CPUs for HC44RS.

![Plot of Total Time and On Demand Cost versus CPUs for HC44RS](../../qa_plots/scaling_plots/HC44rs_Time_Cost_CPUs.png)

Figures: todo - need screenshots of Azure Pricing from Rob Zelt

Fost by Instance Type - update for Azure 

![Azure Cost Management Console - Cost by Instance Type](../../qa_plots/cost_plots/Azure_Bench_Cost.png)


Figure 3. Cost by Usage Type - Azure Console

![Azure Cost Management Console - Cost by Usage Type](../../qa_plots/cost_plots/Azure_Bench_Usage_Type_Cost.png)

Figure 4. Cost by Service Type - Azure Console

![Azure Cost Management Console - Cost by Service Type](../../qa_plots/cost_plots/Azure_Bench_Service_Type_Cost.png)

Scheduler node D12v2 compute cost = entire time that the parallel cluster is running ( creation to deletion) = 6 hours * $0.?/hr = $ ? using spot pricing, 6 hours * $?/hr = $? using on demand pricing.


Using 360 cpus on the Cycle Cloud Cluster, it would take ~6.11 days to run a full year, using 3 HBv3-120 compute nodes.

Table 5. Extrapolated Cost of HBv3-120 used for CMAQv5.3.3 Annual Simulation based on 2 day CONUS benchmark

| Benchmark Case | Number of PES | Compute Nodes | Number of HBv3-120 Nodes | Pricing    |   Cost per node | Time to completion (hour)   | Extrapolate Cost for Annual Simulation                 |  
| -------------  | ------------  |  -------      | --------------- | -------    |  -------------- | ------------------          |  --------------------------------------------------    |
| 2 day CONUS    |  360          |  HBv3-120  |        3       |    SPOT    |    1.4/hour |     2895.83/3600 = .8044  |    .8044/2 * 365 = 147 hours/node * 3 nodes = 441 * $1.4 = $617.4 |
| 2 day CONUS    |  360          |  HBv3-120  |        3       |  ONDEMAND  |    3.6/hour   | 2895.83/3600 = .8044  |    .8044/2 * 365 = 147 hours/node * 3 nodes = 441 * $3.6 = $1,587.6 |
| 2 day CONUS    |  180          |  HC44RS    |        5       |    SPOT    |    .3168/hour |     3928.99/3600 = 1.09  |    1.09/2 * 365 = 190 hours/node * 5 nodes = 950 * $.3168  = $301 |
| 2 day CONUS    |  180          |  HC44RS    |        5       |  ONDEMAND  |    3.168/hour   | 3928.99/3600 = 1.09  |    1.09/2 * 365 = 190 hours/node * 5 nodes = 950 * $3.168 = $3,009 |

(note, this assumes using 3 nodes versus 8 nodes)


<a href="https://docs.microsoft.com/en-us/azure/virtual-machines/disks-shared">Azure SSD Disk Pricing</a>
<a href="https://azure.microsoft.com/en-us/pricing/details/managed-disks/">Azure SSD Disk Pricing</a>


Table 6. Shared SSD File System Pricing

| Storage Type | Storage options   | 	Max IOPS (Max IOPS w/ bursting)	| Pricing (monthly)  |  Pricing | Price per mount per month (Shared Disk) |
| --------     | ----------------  |   ------------------------------------    | -----------------  |  ---------------  | ------  |
| Persistant 1TB  | 200 MB/s/TB       | 	5,000 (30,000)                                  |	$122.88/month |  $6.57                 |



Table 7. Extrapolated Cost of File system for CMAQv5.3.3 Annual Simulation based on 2 day CONUS benchmark


Need to create table


Also need estimate for Archive Storage cost for storing an annual simulation


### Recommended Workflow

Post-process monthly save output and/or post-processed outputs to archive storage at the end of each month.

Goal is to develop a reproducable workflow that does the post processing after every month, and then copies what is required to archive storage, so that only 1 month of output is stored at a time on the /shared/data scratch file system.
This workflow will help with preserving the data in case the cluster or scratch file system gets pre-empted.

