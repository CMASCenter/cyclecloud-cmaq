Introductory Tutorial

## Create an Azure Account

Create an account and configure your azure cyclecloud credentials.
<a href="https://azure.microsoft.com/en-us/free/">Create Free Azure Account</a>

## Introduction to CycleCloud.  

CycleCloud itself is installed as an application server on a Virtual Machine (VM) in Azure that requires outbound access to Azure Resource Provider APIs. CycleCloud then starts and manages VMs that form the High Performance Computing (HPC) systems — these typically consist of the HPC scheduler head node(s) and compute nodes.

<a href="https://docs.microsoft.com/en-us/azure/cyclecloud/?view=cyclecloud-8">Azure CycleCloud Documentation</a>

Create an Virtual Machine for the CycleCloud 8.2 Image and then from that VM configure a cycle cloud instance which will create a Cycle Cloud Scheduler. Use your credentials to ssh into the scheduler. 

Follow these quickstart instructions to create CycleCloud.

<a href="https://docs.microsoft.com/en-us/azure/cyclecloud/qs-install-marketplace?view=cyclecloud-8">Quickstart CycleCloud from Marketplace VM</a>

The goal is for users to get started and make sure they can spin up a node, launch the CycleCloud and terminate it.

Follow the instructions provided in the following link to create a managed identity.  This is the recommended practice versus using an application ID.

<a href="https://docs.microsoft.com/en-us/azure/cyclecloud/how-to/managed-identities?view=cyclecloud-8">Set up and use Managed Identities</a>

### Follow the instructions in the link below to increase your vCPU quota before attempting to run large-scale workloads.

<a href="https://docs.microsoft.com/en-us/azure/virtual-machines/linux/quotas">Azure VM Quotas</a>

### Request access to virtual machines that are not available by default.

HB-120 are not available by default, but you can request them. This tutorial was developed using UNC's enterprise account.  It is unknown if Azure will grant access to these virtual machines on a credit card account.

