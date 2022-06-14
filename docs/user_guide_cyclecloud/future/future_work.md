# List of ideas for future work

<b>Azure Cycle Cloud</b>

1. Test creation of Cycle Cloud on new account to verify instructions for user account permission settings and cycle cloud options to login, build and run CMAQ.
2. Figure out how to install slurm scheduler on AlmaLinux Virtual machine for HBv120. Determine if there is an overhead cost or penalty for running jobs within slurm versus interactively.
3. Figure out how to streamline install scripts and have them load while the Virtual Machine or Cycle Cloud instance is procurred using cloud-init.
4. Figure out how to save the machine image with the software installed and re-use for the creation of a new Virtual Machine.
5. Learn how to set alarms or alerts or automatic shut-down of Virtual Machine if costs exceed budget.
6. Learn how to use spot instances for running CMAQ for both a single Virtual Machine and also for the compute nodes in Cycle Cloud. I ran into difficulty using a spot node machine for the Cycle Cloud VM Application Server. (it may make it difficult to terminate the Cycle Cloud)
7. Look into the Azure Open Data Program. Is there any reason to save the input data for the benchmark there in addition to on the AWs S3 Bucket?

<b>Documentation</b>

1. Finalize documentation and implement a version for the documentation in github.
2. Learn how to use the Cost Explorer in Azure and create screenshots showing costs for the single Virtual Machine HBv120 benchmarks and also for the Azure Cycle Cloud.
3. Document the screenshot that shows the Cycle Cloud VM that is the Application Server.  This VM has a public IP address from which you can see the Cycle Cloud and on the left column see all of the Clusters that have been created, and in the center panel, see the status of those clusters.  Note, that even if all of the clusters listed in the Cycle Cloud Application Server have been terminated, you can restart them, and have access to the input data and software.
4. I think it is a best practice to leave the Application Server running, but terminate the Cycle-Cloud Clusters.  I don't know what happens if you "Stop" the Application Server, Can you later restart the Application Server? It would likely use a new IP address, but would it allow you to see all of the Cycle-Cloud Clusters again?


