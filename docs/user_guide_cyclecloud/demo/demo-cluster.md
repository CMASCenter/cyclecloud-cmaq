Introductory Tutorial

## Step by Step Instructions to Build a Demo CycleCloud.  

CycleCloud itself is installed as an application server on a VM in Azure that requires outbound access to Azure Resource Provider APIs. CycleCloud then starts and manages VMs that form the HPC systems — these typically consist of the HPC scheduler head node(s) and compute nodes.

Follow these quickstart instructions to create CycleCloud.
<a href="https://docs.microsoft.com/en-us/azure/cyclecloud/qs-install-marketplace?view=cyclecloud-8">Quickstart CycleCloud from Marketplace VM</a> 

Note, I could not get the above instructions to work. I had to follow the isnstructions from Rob, which was to create a VM and then from that VM create a cycle cloud instance.
I need to review both sets of instructions again to see if I can figure out the disconnect.

<a href="https://github.com/Azure/cyclecloud-slurm">Git Repo to set up Auto-scaling Slurm CycleCloud Cluster</a>

The goal is for users to get started and make sure they can spin up a node, launch the CycleCloud and terminate it.


