% pcluster-cmaq documentation master file, created by
%   sphinx-quickstart on Tue Jan 11 11:07:40 2022.
%   You can adapt this file completely to your liking, but it should at least
%   contain the root `toctree` directive.

```{include} ../README.md
:relative-images:
```
```{warning}
This documentation is under continuous development
```

## Overview

This document provides tutorials and information on using the ParallelCluster on Amazon Web Service (AWS). The tutorials are aimed at users with cloud computing experience that are already familiar with Amazon Web Service (AWS).  For those with no cloud computing experience we recommend reviewing the Additional Resources listed in [chapter 12](user_guide_pcluster/help/index.md) of this document.



## Format of this documentation

This document provides three hands-on tutorials that are designed to be read in order.  The Introductory Tutorial will walk you through creating a demo ParallelCluster.  You will learn how to set up your AWS Identity and Access Management Roles, configure and create a demo cluster, and exit and delete the cluster.  The Intermediate Tutorial steps you through running a CMAQ test case on ParallelCluster using pre-loaded software and input data.  The Advanced Tutorial explains how to scale the ParallelCluster for larger compute jobs and install CMAQ and required libraries from scratch on the cloud.  The remaining sections provide instructions on post-processing CMAQ output, comparing output and runtimes from multiple simulations, and copying output from ParallelCluster to an AWS Simple Storage Service (S3) bucket.



## Why might I need to use CycleCloud?

The Azure CycleCloud may be configured to be the equivalent of a High Performance Computing (HPC) environment, including using job schedulers such as Slurm, running on multiple nodes using code compiled with Message Passing Interface (MPI), and reading and writing output to a high performance, low latency shared disk.  The advantage of using the Azure CycleCloud command line interface is that the compute nodes can be easily scaled up or down to match the compute requirements of a given simulation. In addition, the user can reduce costs by using Spot instances rather than On-Demand for the compute nodes. ParallelCluster also supports submitting multiple jobs to the job submission queue.

Our goal is make this user guide to running CMAQ on a CycleCloud as helpful and user-friendly as possible. Any feedback is both welcome and appreciated.


Additional information on Azure CycleCloud:

<a href="https://techcommunity.microsoft.com/t5/azure-compute-blog/performance-amp-scalability-of-hbv3-vms-with-milan-x-cpus/ba-p/2939814">CycleCloud HPC Scalabilty</a>

<a href="https://azure.microsoft.com/en-gb/features/azure-cyclecloud/">Azure CycleCloud</a>


```{toctree}
   :numbered: 3
:caption: 'Contents:'
:maxdepth: 2

user_guide_cyclecloud/demo/index.md
user_guide_cyclecloud/System-Req/index.md
user_guide_cyclecloud/cmaq-cluster/index.md
user_guide_cyclecloud/install/index.md
user_guide_cyclecloud/post/index.md
user_guide_cyclecloud/r-packages/index.md
user_guide_cyclecloud/qa/index.md
user_guide_cyclecloud/timing/index.md
user_guide_cyclecloud/output/index.md
user_guide_cyclecloud/logout/index.md
user_guide_pcluster/Performance-Opt/index.md
user_guide_pcluster/help/index.md
user_guide_pcluster/future/index.md
user_guide_pcluster/contribute/index.md

