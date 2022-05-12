## Run CMAQ from HBv120 Compute Node

Provide instructions to build and install CMAQ on HBv120 compute node installed from HPC AlmaLinux 8.5 HPC-Gen2 Image that provides modules for git, openmpi and gcc.
The compute node does not have a SLURM scheduler on it, so jobs are run interactively from the command line. 

Instructions to install data and CMAQ libraries and model are provided along with sample run scripts to run CMAQ on 16, 36, 90, and 120 processors on a single HBv120 instance.

This will provide users with Azure Portal to create a Virtual Machine, select AlmaLinux 8.5 HPC - Gen2 as the image, select the size of the VM as HB120rs_v2 - 120 vcpus, 456 GiB memory, using an SSH public key to login and install and run CMAQ.

Using this method, the user needs to be careful to start and stop the Virtual Machine and only have it run while doing the intial installation, and while running CMAQ.
The full HBv120 instance will incurr charges as long as it is on, even if a job isn't running on it.

This is different than the Azure Cycle-Cloud, where if CMAQ is not running in the queue, then the HBv120 Compute nodes are down, and not incurring costs.

