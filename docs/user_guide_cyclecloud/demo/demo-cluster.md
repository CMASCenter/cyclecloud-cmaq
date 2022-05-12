Introductory Tutorial

## Create an Azure Account

Create an account and configure your azure cyclecloud credentials.

## Introduction to CycleCloud.  

CycleCloud itself is installed as an application server on a VM in Azure that requires outbound access to Azure Resource Provider APIs. CycleCloud then starts and manages VMs that form the HPC systems — these typically consist of the HPC scheduler head node(s) and compute nodes.

<a href="https://docs.microsoft.com/en-us/azure/cyclecloud/?view=cyclecloud-8">Azure CycleCloud Documentation</a>

Create an Virtual Machine for the CycleCloud 8.2 Image and then from that VM configure a cycle cloud instance which will create a Cycle Cloud Scheduler use your credentials to ssh into the scheduler. 
Follow these quickstart instructions to create CycleCloud.

<a href="https://docs.microsoft.com/en-us/azure/cyclecloud/qs-install-marketplace?view=cyclecloud-8">Quickstart CycleCloud from Marketplace VM</a>

The goal is for users to get started and make sure they can spin up a node, launch the CycleCloud and terminate it.

Need to add information about how to set up and use Managed Identities.

https://docs.microsoft.com/en-us/azure/cyclecloud/how-to/managed-identities?view=cyclecloud-8


