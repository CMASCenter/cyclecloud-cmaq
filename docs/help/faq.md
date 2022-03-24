Q. How do you figure out why a job isn't successfully running in the slurm queue

A. Check the logs available in the following link

<a href="https://docs.microsoft.com/en-us/azure/cyclecloud/slurm?view=cyclecloud-8">Slurm on CycleCloud</a>

`vi /var/log/slurmctld/resume.log`

If the resume step is failing, there will also be a 
`vi /var/log/slurmctld/resume_fail.log`

Q. Is there a tutorial on how to use SLURM?

A. Yes

<a href="https://hpc.llnl.gov/banks-jobs/running-jobs/slurm">Surm Tutorial</a> 
