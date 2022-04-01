## System Requirements for Cycle Cloud

### Please set up a alarm on Azure 
Set alarm to receive an email alert if you exceed $100 per month (or what ever monthly spending limit you need).
It may be possible to set up daily or weekly spending alarms as well.

### Software Requirements for CMAQ on CycleCloud

Tier 1: Native OS and associated system libraries, compilers

* Tcsh shell
* Centos7  (tried ubuntu but the module command did not provide updated compilers and openmpi)
* Git
* Compilers (C, C++, and Fortran) - GNU compilers version ≥ 9.2
* MPI (Message Passing Interface) -  OpenMPI ≥ 4.1.0
* NetCDF (with C, C++, and Fortran support)
* I/O API
* Slurm Scheduler

Tier 2: additional libraries required for installing CMAQ

* NetCDF (with C, C++, and Fortran support)
* I/O API

Tier 3: Software distributed thru the CMAS Center

* CMAQv533
* CMAQv533 Post Processors

Tier 4: R packages and Scripts

* R QA Scripts

### Hardware Requirements

#### Recommended Minimum Requirements

The size of hardware depends on the domain size and resolution for  your CMAQ case, and how quickly your turn-around requirements are.
Larger hardware and memory configurations are also required for instrumented versions of CMAQ incuding CMAQ-ISAM and CMAQ-DDM3D.


### Azure CycleCloud

Azure CycleCloud Provides the simplest way to manage HPC workloads using any scheduler (like Slurm, Grid Engine, HPC Pack, HTCondor, LSF, PBS Pro, or Symphony), on Azure

CycleCloud allows you to:

* Deploy full clusters and other resources, including scheduler, compute VMs, storage, networking, and cache
* Orchestrate job, data, and cloud workflows
* Give admins full control over which users can run jobs, as well as where and at what cost
* Customize and optimize clusters through advanced policy and governance features, including cost controls, Active Directory integration, monitoring, and reporting
* Use your current job scheduler and applications without modification
* Take advantage of built-in autoscaling and battle-tested reference architectures for a wide range of HPC workloads and industries


<a href="https://docs.microsoft.com/en-us/azure/architecture/topics/high-performance-computing#azure-cyclecloud">High Performance Computing on Azure CycleCloud</a>

<a href="https://docs.microsoft.com/en-us/azure/cyclecloud/?view=cyclecloud-8">Azure CycleCloud</a>

### Ensure your vCPU quota has been increased before attempting to run large-scale workloads.

<a href="https://docs.microsoft.com/en-us/azure/virtual-machines/linux/quotas">Azure VM Quotas</a>

#### Recommended Cycle Cloud Configuration for CONUS Domain 12US2

```
GRIDDESC
'12US2'
'12CONUS'     -2412000.0 -1620000.0 12000.0 12000.0 396 246 1
```
![CMAQ Domain](../qa_plots/tileplots/CMAQ_ACONC_12US2_Benchmark_Tileplot.png)


Scheduler node:

* D12v2

Compute Node for HTC Queue - used for Post-Processing (combine, etc):

* F2sV2

Compute Node for HPC Queue - used to run CMAQ:

*  HBv3-120 instance running Centos7 

<a href="https://docs.microsoft.com/en-us/azure/virtual-machines/workloads/hpc/hbv3-series-overview#software-specifications">HBv3-series Software Specification</a>

448 GB of RAM, and no hyperthreading with 350 GB/sec of memory bandwidth, up to 32 MB of L3 cache per core, up to 7 GB/s of block device SSD performance, and clock frequencies up to 3.675 GHz.

Figure 1. Cycle Cloud Recommended Cluster Configuration (Number of compute nodes depends on setting for NPCOLxNPROW and #SBATCH --nodes=XX #SBATCH --ntasks-per-node=YY )

![Azure Minimum Viable Product Configuration](../diagrams/microsoft_azure_minimum_viable_product.png)

#### Azure CycleCloud specifies what resource to use for disks, scheduler node, and compute nodes. 
Cycle Cloud simply tries to schedule the job according to the slurm scheduler instructions. Slurm controls the launch, terminate, and maintain resources.
If you try to allocate more nodes than are available in the Cycle Cloud Configuration, then you will need to 
edit the HPC config in the cyclecloud web interface to set the CPUs to 480 or more and then run the following on the scheduler node the changes should get picked up:

`cd /opt/cycle/slurm`

`sudo ./cyclecloud_slurm.sh scale`

Number of compute nodes dispatched by the slurm scheduler is specified in the run script using #SBATCH --nodes=XX #SBATCH --ntasks-per-node=YY where the maximum value of tasks per node or YY limited by many CPUs are on the compute node.  

For HBv3-120, there are 120 CPUs, so maximum value of YY is 120 or --ntask-per-node=120.  

If running a job with 180 processors, this would require the --nodes=XX or XX to be set to 2 compute nodes, as 90x2=180.  

The setting for NPCOLxNPROW must also be a maximum of 180, ie. 18 x 10 or 10 x 18 to use all of the CPUs in the parallel cluster.


<a href="https://docs.microsoft.com/en-us/azure/virtual-machines/hbv3-series">HBv3-120 instance </a>


Software: 

* Centos7
* Spot or OnDemand Pricing 
* /shared/build volume install software from git repo
* 1. TB Shared file system 
* Slurm Placement Group enabled
* Elastic Fabric Adapter Enabled on HBv3-120


<a href="https://azure.com/e/a5d6f8654d634e8b93973574cbda428d">Azure HBv3-120 Pricing</a>

![Azure HPC HBv3_120pe Pricing](./Azure_HPC_HBv3_Pricing.png)



Table 1. Azure Instance On-Demand versus Spot Pricing (price is subject to change)

| Instance Name	| CPUs |  RAM      |  Memory Bandwidth	| Network Bandwidth | Linux On-Demand Price | Linux Spot Price | 
| ------------  | ----- | --------  | ---------------   | ---------------   | --------------------  | ---------------  |
| HBv3-120	| 120	|  448 GiB   |	 350 Gbps	        | 200 Gbps(Infiniband)          |   $3.6/hour         | $1.4/hour     |



Table 2. Timing Results for CMAQv5.3.3 2 Day CONUS2 Run on Cycle Cloud with D12v2 schedulare node and HBv3-120 Compute Nodes (120 cpu per node) I/O on /shared directory

| Number of PEs | #Nodesx#CPU | NPCOLxNPROW | Day1 Timing (sec) | Day2 Timing (sec) | Total Time(2days)(sec) | CPU Hours/day | SBATCH --exclusive | Data Imported or Copied |  Answers Matched | Cost using Spot Pricing | Cost using On Demand Pricing | compiler flag | 
| ------------- | -----------    | -----------   | ----------------     | ---------------      | ------------------- | -----       | ------------------ |  ---------        |   -------- | --------- | ------ | ---------------      |
| 90           |   1x90     |    9x10            |   3153.33            |  2758.12             |   5911.45   | .821 |  no | copied   |  yes          | $1.4/hr * 1 nodes * 1.642 hr = $2.29             |  $3.6/hr * 1 nodes * 1.642 hr = $ $5.911           |  without -march=native compiler flag |
| 120          |   1x120    |    10x12           | 2829.84              |  2516.07             |   5345.91   | .742 |  no | copied   |  yes           | $1.4/hr * 1 nodes * 1.484 hr = $2.08           | $3.6/hr * 1 nodes * 1.484 hr = $5.34                     | without -march=native compiler flag            |
| 180           |  2x90          | 10x18         | 2097.37              | 1809.84              |    3907.21  | .542 |  no | copied   |  yes          | $1.4/hr * 2 nodes * 1.08 hr = $3.03 | $3.6/hr * 2 nodes * 1.08 hr = $7.81 | with -march=native compiler flag |
| 180          |   2x90     |    10 x 18         | 1954.20              | 1773.86              |    3728.06  | .518 |  no | copied   |   no    | $1.4/hr * 2 nodes * 1.036 hr = $2.9 | $3.6/hr * 2 nodes * 1.036 hr = $7.46 | without -march=native compiler flag |
| 180          |   5x36     |   10x18            | 1749.80              | 1571.50              |    3321.30  |  .461  |  no | copied | yes     |                                     |           |                                        | without -march=native compiler flag |
| 240          |   2x120    |   20x12            |  1856.50             | 1667.68              |    3524.18  | .4895  |  no | copied |   yes   |   $1.4/hr * 2 nodes * .97 hr = $2.716           |  $3.6/hr * 2 nodes * .97 hr = $6.984   | without -march=native compiler flag |  
| 270           |  3x90          | 15x18         | 1703.19              | 1494.17              |    3197.36  | .444  |  no | copied  |   no | $1.4/hr * 3 nodes * .888hr = $3.72 | 3.6/hr * 3 nodes * .888 = $9.59  | with -march=native compiler flag |
| 360           |  3x120     |  20x18             | 1520.29              |  1375.54             |    2895.83 | .402   |  no | copied |  no   | $1.4/hr * 3 nodes * .804 = $3.38 | 3.6/hr * 3 nodes * .804 = $8.687 | with -march=native compiler flag | 

Total HBv3-120 compute cost of Running Benchmarking Suite using SPOT pricing = $1.4/hr

Total HBv3-120 compute cost of Running Benchmarking Suite using ONDEMAND pricing = $3.6/hr

Savings is ~ 60% for spot versus  ondemand pricing for HBv3-120 compute nodes.

<a href="https://azure.microsoft.com/en-us/pricing/details/virtual-machines/linux/">Azure Spot and On-Demand Pricing</a>

Table 3. Timing Results for CMAQv5.3.3 2 Day CONUS2 Run on Cycle Cloud with D12v2 schedulare node and HBv3-120 Compute Nodes (120 cpu per node), I/O on mnt/resource/data2 directory

| Number of PEs | #Nodesx#CPU | NPCOLxNPROW | Day1 Timing (sec) | Day2 Timing (sec) | Total Time(2days)(sec) | CPU Hours/day | SBATCH --exclusive | Data Imported or Copied |  Answers Matched | Cost using Spot Pricing | Cost using On Demand Pricing | compiler flag | i/o dir | cpu old/new |
| ------------- | -----------    | -----------   | ----------------     | ---------------      | ------------------- | -----       | ------------------ |  ---------        |   -------- | --------- | ------ | ---------------      | --- |  --  |
| 36        |   1x36     |    6x6             | 5933.48              | 5230.05             |   11163.53      | 1.55  |   no | copied |  yes         | $1.4/hr * 1 nodes * 3.1 hr = $4.34                    | $3.6/hr * 1 nodes * 3.1 hr = $11.2                        | without -march=native compiler flag |  /data/output | new |
| 36        |   1x36     |    6x6             | 5841.81              | 5153.47             |   10995.28      | 1.52  |  no  | copied |  yes         |                                                       |                                                           | without -march=native compiler flag | /mnt/resource/data2/ | new |
| 120           |   1x120     |    10x12            |  2781.89       |  2465.87    | 5247.76    | .729 |  no | copied   |  yes          | $1.4/hr * 1 nodes * 1.642 hr = $2.29             |  $3.6/hr * 1 nodes * 1.642 hr = $ $5.911           |  without -march=native compiler flag | /data/output       | new |
| 120          |   1x120    |    10x12           | 3031.81         |  2378.64   | 5410.45    | .751 |  no | copied   |  yes           | $1.4/hr * 1 nodes * 1.484 hr = $2.08           | $3.6/hr * 1 nodes * 1.484 hr = $5.34                     | without -march=native compiler flag   | /mnt/resource/data2       | new |
| 120          | 1x120      |  10x20             | 2691.40         | 2380.51    | 5071.91    | .704  | no | copied   | yes            |                                                |                                                          |  without -march=native compiler flag | i: /mnt/resource/data2 o: /data/output/ | new |
| 180           |  2x90          | 10x18         |               |               |     |  |  no | copied   |  yes          | $1.4/hr * 2 nodes * 1.08 hr = $3.03 | $3.6/hr * 2 nodes * 1.08 hr = $7.81 | with -march=native compiler flag |    |  |
| 180          |   2x90     |    10 x 18         |               |               |      |  |  no | copied   |   no    | $1.4/hr * 2 nodes * 1.036 hr = $2.9 | $3.6/hr * 2 nodes * 1.036 hr = $7.46 | without -march=native compiler flag |     |   |
| 240          |   2x120    |   20x12            |               |               |      |   |  no | copied |   yes   |   $1.4/hr * 2 nodes * .97 hr = $2.716           |  $3.6/hr * 2 nodes * .97 hr = $6.984   | without -march=native compiler flag |    |    |
| 270           |  3x90          | 15x18         |               |               |      |   |  no | copied  |   no | $1.4/hr * 3 nodes * .888hr = $3.72 | 3.6/hr * 3 nodes * .888 = $9.59  | with -march=native compiler flag |     |        |
| 360           |  3x120     |  20x18             |              |              |     |    |  no | copied |  no   | $1.4/hr * 3 nodes * .804 = $3.38 | 3.6/hr * 3 nodes * .804 = $8.687 | with -march=native compiler flag |        |        | 
| 960           |  8x120     | 30x32             | 1223.52              |  1126.19             |    2349.71  | .326   |  no | copied |  no   | $1.4/hr * 8 nodes * .653 = $7.31 | 3.6/hr * 8 nodes * .653 = $18.8   | with -march=native compiler flag | /data/ouput  |  old | 
| 960           |  8x120    | 30x32              | 1189.21              |  1065.73             |   2254.94   | .313   |  no | copied | no    |                                  |                                   | with -march=native compiler flag | /data/output | new  |


Table 4. Timing Results for CMAQv5.3.3 2 Day CONUS2 Run on Cycle Cloud with D12v2 schedular node and HC44RS Compute Nodes (44 cpus per node)

| Number of PEs | #Nodesx#CPU | NPCOLxNPROW | Day1 Timing (sec) | Day2 Timing (sec) | Total Time(2days)(sec) | CPU Hours/day | SBATCH --exclusive | Data Imported or Copied |  Answers Matched | Cost using Spot Pricing | Cost using On Demand Pricing | compiler flag |
| -----------    | -----------   | ----------------     | ---------------      | ----------- | -----      | ------------------ | --------------          | ---------                              |   -------- | --------- | ------ | ---------------      |
| 18           |  1x18     |                |               |           |             |      | no   | copied    |   yes   |                                    |                                      |                                  |
| 36           |  1x36     | 6x6            |  7349.06      | 6486.37   |   13835.43  |  1.92 | no  | copied    |   yes   | $.3168/hr * 1 nodes * 3.84 = $1.22 | 3.186/hr * 1 nodes * 3.84 = $12.23   | with -march=native compiler flag |
| 40           | 1x40      | 4x10           | 6685.74       | 5935.01   | 12620.75    |  1.75 | no  | copied    |   yes   | $.3168/hr * 1 nodes * 3.5 = $1.11 | 3.168/hr * 1 nodes * 3.5 = $11 | with -march=native compiler flag |
| 72           |  2x36     | 8x9            |  4090.80      | 3549.60  | 7640.40      |  1.06 | no  | copied    |   yes   | $.3168/hr * 2 nodes * 2.12 = $1.34 | 3.168/hr * 2 nodes * 2.12 = $13.4   | with -march=native compiler flag |
| 108          |  3x36     | 9x12           | 2912.59       | 2551.08  | 5463.67      |  .758 | no  | copied   |   yes    | $.3168/hr * 3 nodes * 1.517 = $1.44 | 3.168/hr * 3 nodes * 1.517 = $14.41 | with -march=native compiler flag |
| 126          | 7x18      |  9x14          | 2646.52       | 2374.21  | 5020.73      | .69   | no  | copied   |   yes   | $.3168/hr * 7 nodes * 1.517 = $3.36 | 3.168/hr * 7 nodes * 1.517 = $33.64 | with -march=native compiler flag |
| 144          |  4x36     |  12x12         | 2449.39       | 2177.28  | 4626.67      |  .64  | no  | copied   |   yes   | $.3168/hr * 4 nodes * 1.285 = $1.63 | 3.168/hr * 4 nodes * 1.285 = $16.28 | with -march=native compiler flag |
| 180           |  5x36     | 10x18            |  2077.22   |   1851.77   | 3928.99   |  .545 | no | copied    |   yes   | $.3168/hr * 5 nodes * 1.09 = $1.72 | 3.168/hr * 5 nodes * 1.09 = $17.26   | with -march=native compiler flag |
| 288           |  8x36     | 16x18            |  1750.36   |  1593.29    |   3343.65 |  .464 | no | copied    |   yes   | $.3168/hr * 8 nodes * .928 = $2.35 | 3.168/hr * 8 nodes * .928 = $39.54   | with -march=native compiler flag |



HC44RS SPOT Pricing $.3168

HC44RS ONDEMAND pricing $3.168

Savings is ~ 90% for spot versus ondemand pricing for HC44RS compute nodes.

Figure 2. Scaling Plot Comparison of Parallel Cluster and Cycle Cloud

![Scaling Plot Comparison of Parallel Cluster and Cycle Cloud](../qa_plots/scaling_plots/Scaling_Parallel_Cluster_vs_Cycle_Cloud.png)

Note CMAQ scales well up to ~ 200 processors for the CONUS domain.  As more processors are added beyond 200 processors, the CMAQ gets less efficient at using all of them.
The Cycle Cloud HC44RS performance is similar to the c5n.18xlarge using 36 cpus/node on 8 nodes, or 288 cpus.
cost is $39.54 for Cycle Cloud compared to $19.46  for Parallel Cluster for the 2-Day 12US2 CONUS Benchmark.

Figures: todo - need screenshots of Azure Pricing from Rob Zelt

Fost by Instance Type - update for Azure 

![Azure Cost Management Console - Cost by Instance Type](../qa_plots/cost_plots/Azure_Bench_Cost.png)


Figure 3. Cost by Usage Type - Azure Console

![Azure Cost Management Console - Cost by Usage Type](../qa_plots/cost_plots/Azure_Bench_Usage_Type_Cost.png)

Figure 4. Cost by Service Type - Azure Console

![Azure Cost Management Console - Cost by Service Type](../qa_plots/cost_plots/Azure_Bench_Service_Type_Cost.png)

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

