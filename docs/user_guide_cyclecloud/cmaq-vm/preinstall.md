## Run CMAQ from HBv120 Compute Node

Provide instructions to build and install CMAQ on HBv120 compute node installed from HPC Alma Linux Image that uses module load to obtain git, openmpi and gcc.
The compute node does not have a SLURM scheduler on it, so jobs are run interactively. 

Instructions to install data and CMAQ libraries and model along with sample run scripts to run CMAQ on 16, 36, 90, and 120 processors on a single HBv120 instance.

Provide users with familiarity of creating their account and using the Azure Web Interface to create a Virtual Machine and install and run CMAQ.

Using this method, the user needs to be careful to start and stop the Virtual Machine when they have completed running CMAQ.
The full HBv120 instance will incurr charges as long as it is on, even if a job isn't running on it.  

This is different than the Azure Cycle-Cloud.
When the CMAQ model isn't running in the queue then the HBv120 Compute nodes are down, and not incurring costs.


