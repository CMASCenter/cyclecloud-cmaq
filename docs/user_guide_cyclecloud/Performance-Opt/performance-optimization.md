## Performance Optimization for Cycle Cloud

<a href="https://azure.com/e/a5d6f8654d634e8b93973574cbda428d">Azure HBv3-120 Pricing</a>

![Azure HPC HBv3_120pe Pricing](./Azure_HPC_HBv3_Pricing.png)



Table 1. Azure Instance On-Demand versus Spot Pricing (price is subject to change)

| Instance Name	| CPUs |  RAM      |  Memory Bandwidth	| Network Bandwidth | Linux On-Demand Price | Linux Spot Price | 
| ------------  | ----- | --------  | ---------------   | ---------------   | --------------------  | ---------------  |
| HBv3-120	| 120	|  448 GiB   |	 350 Gbps	        | 200 Gbps(Infiniband)          |   $3.6/hour         | $1.4/hour     |



Table 2. Timing Results for CMAQv5.3.3 2 Day CONUS2 Run on Cycle Cloud with D12v2 schedulare node and HBv3-120 Compute Nodes (120 cpu per node) I/O on /shared directory

| CPUs | NodesxCPU | NPCOLxNPROW | Day1 Timing (sec) | Day2 Timing (sec) | TotalTime | CPU Hours/day | SBATCH --exclusive | Data Imported or Copied |  Answers Matched | Equation using Spot Pricing | SpotCost | Equation using On Demand Pricing | OnDemandCost | compiler flag | 
| ------------- | -----------    | -----------   | ----------------     | ---------------      | ------------------- | -----       | ------------------ |  ---------        |   -------- | --------- | ------ | ---------------      | -- | -- |
| 90           |   1x90     |    9x10            |   3153.33            |  2758.12             |   5911.45   | .821 |  no | copied   |  yes    | $1.4/hr * 1 nodes * 1.642 hr = | $2.29             |  $3.6/hr * 1 nodes * 1.642 hr = |  5.911           |  without -march=native compiler flag |
| 120          |   1x120    |    10x12           | 2829.84              |  2516.07             |   5345.91   | .742 |  no | copied   |  yes    |  $1.4/hr * 1 nodes * 1.484 hr = | $2.08           | $3.6/hr * 1 nodes * 1.484 hr = | 5.34                     | without -march=native compiler flag            |
| 180           |  2x90          | 10x18         | 2097.37              | 1809.84              |    3907.21  | .542 |  no | copied   |  yes    | $1.4/hr * 2 nodes * 1.08 hr = | $3.03 | $3.6/hr * 2 nodes * 1.08 hr = |  7.81 | with -march=native compiler flag |
| 180          |   2x90     |    10 x 18         | 1954.20              | 1773.86              |    3728.06  | .518 |  no | copied   |   no    | $1.4/hr * 2 nodes * 1.036 hr = | $2.9 | $3.6/hr * 2 nodes * 1.036 hr = | 7.46 | without -march=native compiler flag |
| 180          |   5x36     |   10x18            | 1749.80              | 1571.50              |    3321.30  |  .461  |  no | copied | yes     | $1.4/hr * 5 nodes * .922 hr = | $6.46 | $3.6/hr * 5 nodes * .922 hr =  | 16.596 | without -march=native compiler flag |
| 240          |   2x120    |   20x12            |  1856.50             | 1667.68              |    3524.18  | .4895  |  no | copied |   yes   |   $1.4/hr * 2 nodes * .97 hr = | $2.716           |  $3.6/hr * 2 nodes * .97 hr = | 6.984   | without -march=native compiler flag |  
| 270           |  3x90          | 15x18         | 1703.19              | 1494.17              |    3197.36  | .444  |  no | copied  |   no | $1.4/hr * 3 nodes * .888hr = | $3.72 | 3.6/hr * 3 nodes * .888 = | 9.59  | with -march=native compiler flag |
| 360           |  3x120     |  20x18             | 1520.29              |  1375.54             |    2895.83 | .402   |  no | copied |  no   | $1.4/hr * 3 nodes * .804 = | $3.38 | 3.6/hr * 3 nodes * .804 = | 8.687 | with -march=native compiler flag | 

Total HBv3-120 compute cost of Running Benchmarking Suite using SPOT pricing = $1.4/hr

Total HBv3-120 compute cost of Running Benchmarking Suite using ONDEMAND pricing = $3.6/hr

Savings is ~ 60% for spot versus  ondemand pricing for HBv3-120 compute nodes.

<a href="https://azure.microsoft.com/en-us/pricing/details/virtual-machines/linux/">Azure Spot and On-Demand Pricing</a>

Table 3. Timing Results for CMAQv5.3.3 2 Day CONUS2 Run on Cycle Cloud with D12v2 schedulare node and HBv3-120 Compute Nodes (120 cpu per node), I/O on mnt/resource/data2 directory

| CPUs | NodesxCPU | NPCOLxNPROW | Day1 Timing (sec) | Day2 Timing (sec) | TotalTime | CPU Hours/day | SBATCH --exclusive | Data Imported or Copied |  Answers Matched | Equation using Spot Pricing | SpotCost | Equation using On Demand Pricing | OnDemandCost | compiler flag | i/o dir | cpu old/new |
| ------------- | -----------    | -----------   | ----------------     | ---------------      | ------------------- | -----       | ------------------ |  ---------        |   -------- | --------- | ------ | ---------------      | --- |  --  | -- | -- |
| 18        |   1x16     |   3x6              | 10571.20         | 9567.43      | 20138.63  | 2.80  | no   | copied | yes          | $1.4/hr * 1 nodes * 5.59 hr = |  $7.83 |  $3.6/hr * 1 nodes * 5.59 hr = | 20.12  |  without -march=native compiler flag | /data/output | new | 
| 36        |   1x36     |    6x6             | 5933.48              | 5230.05  | 11163.53  | 1.55  |   no | copied |  yes         | $1.4/hr * 1 nodes * 3.1 hr = |  $4.34  | $3.6/hr * 1 nodes * 3.1 hr = | 11.2     | without -march=native compiler flag |  /data/output | new |
| 36        |   1x36     |    6x6             | 5841.81              | 5153.47  | 10995.28  | 1.52  |  no  | copied |  yes         | $1.4/hr * 1 nodes * 3.0 hr = | $4.26   | $3.6/hr * 1 nodes * 3.0 hr = | 10.8    | without -march=native compiler flag | /mnt/resource/data2/ | new |
| 120           |   1x120     |    10x12            |  2781.89       |  2465.87 | 5247.76   | .729 |  no | copied   |  yes          | $1.4/hr * 1 nodes * 1.642 hr = | $2.29 |  $3.6/hr * 1 nodes * 1.642 hr = | 5.911 |  without -march=native compiler flag | /data/output       | new |
| 120          |   1x120    |    10x12           | 3031.81         |  2378.64   | 5410.45   | .751 |  no | copied   |  yes           | $1.4/hr * 1 nodes * 1.484 hr = | $2.08 | $3.6/hr * 1 nodes * 1.484 hr = | 5.34  | without -march=native compiler flag   | /mnt/resource/data2       | new |
| 120          | 1x120      |  10x20             | 2691.40         | 2380.51    | 5071.91   | .704  | no | copied   | yes            | $1.4/hr * 1 nodes * 1.408 hr = | 1.97   | $3.6/hr * 1 nodes * 1.408 = |  5.07 |   without -march=native compiler flag | i: /mnt/resource/data2 o: /data/output/ | new |
| 180          |   5x36      |  10x18            | 1749.80      | 1571.50        | 3321.30  | .461  | no | copied   | yes            | $1.4/hr * 5 nodes * .923 = | 6.45  |  $3.6/hr * 5 nodes * .923 hr = | 16.614 | without -march=native compiler flag | /shared/data | new |         
| 180           |  2x90          | 10x18         |  2097.37    | 1809.84     | 3907.21    | .543  |  no | copied   |  yes          | $1.4/hr * 2 nodes * 1.08 hr = | $3.03 | $3.6/hr * 2 nodes * 1.08 hr = | 7.81 | with -march=native compiler flag |    |  |
| 180          |   2x90     |    10 x 18         |  1954.20      |  1773.86      | 3728.06 | .5177 |  no | copied   |   no    | $1.4/hr * 2 nodes * 1.036 hr = |  $2.9 | $3.6/hr * 2 nodes * 1.036 hr = | 7.46 | without -march=native compiler flag |     |   |
| 240          |   2x120    |   20x12            | 1856.50       |  1667.68      | 3524.18 |  .489  |  no | copied |   yes   |   $1.4/hr * 2 nodes * .97 hr = | $2.716 |  $3.6/hr * 2 nodes * .97 hr = | 6.984   | without -march=native compiler flag | /shared/data   | old   |
| 270           |  3x90          | 15x18         |  1703.19     | 1494.17     | 3197.36 | .444   |  no | copied  |   no | $1.4/hr * 3 nodes * .888hr = | $3.72 | 3.6/hr * 3 nodes * .888 = | 9.59  | with -march=native compiler flag |     |        |
| 360           |  3x120     |  20x18             | 1520.29    | 1375.54      | 2895.83 | .402   |  no | copied |  no   | $1.4/hr * 3 nodes * .804 = | $3.38 | 3.6/hr * 3 nodes * .804 = | 8.687 | with -march=native compiler flag | /shared/data   | old       | 
| 360           |  3x120     | 20x18             | 1512.33     | 1349.54      | 2861.87 | .397   | no  | copied  | no   |  $1.4/hr * 3 nodes * .795 = | $3.339 | 3.6/hr * 3 nodes * .795 = | 8.586 |      with -march=native compiler flag | /shared/data/ | new | 
| 960           |  8x120     | 30x32             | 1223.52              |  1126.19             |    2349.71  | .326   |  no | copied |  no   | $1.4/hr * 8 nodes * .653 = | $7.31 | 3.6/hr * 8 nodes * .653 = | 18.8   | with -march=native compiler flag | /data/ouput  |  old | 
| 960           |  8x120    | 30x32              | 1189.21              |  1065.73             |   2254.94   | .313   |  no | copied | no    | $1.4/hr * 8 nodes * .626 = | 7.01  | 3.6/hr * 8 nodes * .626 = | 18.0   | with -march=native compiler flag | /data/output | new  |


Table 4. Timing Results for CMAQv5.3.3 2 Day CONUS2 Run on Cycle Cloud with D12v2 schedular node and HC44RS Compute Nodes (44 cpus per node)

| CPUs | NodesxCPU | NPCOLxNPROW | Day1 Timing (sec) | Day2 Timing (sec) | TotalTime | CPU Hours/day | SBATCH --exclusive | Data Imported or Copied |  Answers Matched | Equation using Spot Pricing | SpotCost | Equation using On Demand Pricing | OnDemandCost | compiler flag | i/o dir |
| -----------    | -----------   | ----------------     | ---------------      | ----------- | -----      | ------------------ | --------------          | ---------                              |   -------- | --------- | ------ | ---------------      | --- | ---- | ---- |
| 18          |   1x18     |    3x6        | 13525.66       | 12107.02  |   25632.68  | 3.56  |  no  | copied |    yes   | $.3168/hr * 1 nodes * 7.12 = | $2.26 | 3.186/hr * 1 nodes * 7.12 = | 22.68   | with -march=native compiler flag | shared/data |
| 36           |  1x36     | 6x6            |  7349.06      | 6486.37   |   13835.43  |  1.92 | no  | copied    |   yes   | $.3168/hr * 1 nodes * 3.84 = | $1.22 | 3.186/hr * 1 nodes * 3.84 = | 12.23   | with -march=native compiler flag | /shared/data |
| 40           | 1x40      | 4x10           | 6685.74       | 5935.01   | 12620.75    |  1.75 | no  | copied    |   yes   | $.3168/hr * 1 nodes * 3.5 = | $1.11 | 3.168/hr * 1 nodes * 3.5 = | 11 | with -march=native compiler flag | /shared/data |
| 72           |  2x36     | 8x9            |  4090.80      | 3549.60  | 7640.40      |  1.06 | no  | copied    |   yes   | $.3168/hr * 2 nodes * 2.12 = | $1.34 | 3.168/hr * 2 nodes * 2.12 = | 13.4   | with -march=native compiler flag | /shared/data |
| 108          |  3x36     | 9x12           | 2912.59       | 2551.08  | 5463.67      |  .758 | no  | copied   |   yes    | $.3168/hr * 3 nodes * 1.517 = | $1.44 | 3.168/hr * 3 nodes * 1.517 = |  14.41 | with -march=native compiler flag | /shared/data | 
| 126          | 7x18      |  9x14          | 2646.52       | 2374.21  | 5020.73      | .69   | no  | copied   |   yes   | $.3168/hr * 7 nodes * 1.517 = | $3.36 | 3.168/hr * 7 nodes * 1.517 = | 33.64 | with -march=native compiler flag | /shared/data |
| 144          |  4x36     |  12x12         | 2449.39       | 2177.28  | 4626.67      |  .64  | no  | copied   |   yes   | $.3168/hr * 4 nodes * 1.285 = | $1.63 | 3.168/hr * 4 nodes * 1.285 = | 16.28 | with -march=native compiler flag | /shared/data |
| 180           |  5x36     | 10x18            |  2077.22   |   1851.77   | 3928.99   |  .545 | no | copied    |   yes   | $.3168/hr * 5 nodes * 1.09 = | $1.72 | 3.168/hr * 5 nodes * 1.09 = | 17.26   | with -march=native compiler flag | /shared/data |
| 216           |  6x36     | 18x12            |  1908.15   | 1722.07    | 3630.22    |  .504 | no   | copied  |  yes    | $.3168/hr * 6 nodes * 1.01 = | $1.92 |  3.168/hr * 6 nodes * 1.01 = | 19.16 | with -march=native compiler flag  | /shared/data |
| 288           |  8x36     | 16x18            |  1750.36   |  1593.29    |   3343.65 |  .464 | no | copied    |   yes   | $.3168/hr * 8 nodes * .928 = | $2.35 | 3.168/hr * 8 nodes * .928 = | 39.54   | with -march=native compiler flag | /shared/data | 



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

