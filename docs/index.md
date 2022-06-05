% cyclecloud-cmaq documentation master file, created by
%   sphinx-quickstart on Tue Jan 11 11:07:40 2022.
%   You can adapt this file completely to your liking, but it should at least
%   contain the root `toctree` directive.

```{warning}
This documentation is under continuous development
```

## Overview

This document provides tutorials and information on using Microsoft Azure Online Portal to create either a single Virtual Machine or a Cycle Cloud Cluster to run CMAQ. The tutorials are aimed at users with cloud computing experience that are already familiar with Azure.  For those with no cloud computing experience we recommend reviewing the Additional Resources listed in [chapter 12](user_guide_cyclecloud/help/index.md) of this document.



## Format of this documentation

This document provides three hands-on tutorials that are designed to be read in order.  The Introductory Tutorial will walk you through creating a demo CycleCloud by following the instructions provided by Microsoft.  You will learn how to set up your Azure Resource ID, configure and create a demo cluster, and exit and delete the cluster.  The Intermediate Tutorial steps you through running a CMAQ test case on a single Virtual Machine with instructions to install CMAQ and libraries.  The Advanced Tutorial explains how to create a CycleCloud (High Performance Cluster) for larger compute jobs and install CMAQ and required libraries from scratch on the cloud.  The remaining sections provide instructions on post-processing CMAQ output, comparing output and runtimes from multiple simulations, and copying output from CycleCloud to an Amazon Web Services (AWS) Simple Storage Service (S3) bucket.

## Azure Subscriptions 

The ability to use resources available in the Microsoft Azure Cloud is limited by quotas that are set at the subscription level. This tutorial was developed using UNC Chapel Hill's Enterprise account. Additional effort is being made to identify how to use a pay-as-you-go account, but these instructions have not been finalized. There may also be differences in how managed identies and user level permissions are set by the administrator of your enterprise level account that are not covered in this tutorial.

## Why might I need to use Azure Virtual Machine or CycleCloud?

An Azure Virtual Machine may be configured to run code compile with Message Passing Interface (MPI) on a single high performance compute node. The intermediate tutorial demonstrates how to run CMAQ interactively on a single node.

The Azure CycleCloud may be configured to be the equivalent of a High Performance Computing (HPC) environment, including using job schedulers such as Slurm, running on multiple nodes using code compiled with Message Passing Interface (MPI), and reading and writing output to a high performance, low latency shared disk.  The advantage of using the slurm scheduler is that the number of compute nodes that will be provisioned can be adjusted to meet requirements of a given simulation. In addition, the user can reduce costs by using Spot instances rather than On-Demand for the compute nodes. CycleCloud also supports submitting multiple jobs to the job submission queue.

Our goal is make this user guide to running CMAQ on either a single Virtual Machine or the CycleCloud Cluster as helpful and user-friendly as possible. Any feedback is both welcome and appreciated.


Additional information on Azure CycleCloud:

<a href="https://techcommunity.microsoft.com/t5/azure-compute-blog/performance-amp-scalability-of-hbv3-vms-with-milan-x-cpus/ba-p/2939814">CycleCloud HPC Scalabilty</a>

<a href="https://azure.microsoft.com/en-gb/features/azure-cyclecloud/">Azure CycleCloud</a>


```{toctree}
   :numbered: 3
:caption: 'Contents:'
:maxdepth: 2

user_guide_cyclecloud/demo/index.md
user_guide_cyclecloud/System-Req/index.md
user_guide_cyclecloud/cmaq-vm/index.md
user_guide_cyclecloud/install/index.md
user_guide_cyclecloud/post/index.md
user_guide_cyclecloud/r-packages/index.md
user_guide_cyclecloud/qa/index.md
user_guide_cyclecloud/timing/index.md
user_guide_cyclecloud/output/index.md
user_guide_cyclecloud/logout/index.md
user_guide_cyclecloud/Performance-Opt/index.md
user_guide_cyclecloud/help/index.md
user_guide_cyclecloud/future/index.md
user_guide_cyclecloud/contribute/index.md
```
