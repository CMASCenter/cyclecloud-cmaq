## Resources from Azure for diagnosing issues with running the Cycle Cloud 

### Issues

Please open a GitHub issue for any feedback or issues: 

There is also an active community driven Q&A site that may be helpful: 

<a href="https://github.com/Azure?q=cyclecloud">All Git Repositories matching CycleCloud</a>

CycleCloud itself is installed as an application server on a Virtual Machine (VM) in Azure that requires outbound access to Azure Resource Provider APIs. CycleCloud then starts and manages VMs that form the High Performance Computing (HPC) systems — these typically consist of the HPC scheduler head node(s) and compute nodes.

<a href="https://docs.microsoft.com/en-us/azure/cyclecloud/?view=cyclecloud-8">Azure CycleCloud Documentation</a>

Create an Virtual Machine for the CycleCloud 8.2 Image and then from that VM configure a cycle cloud host instance which will create a Cycle Cloud Scheduler. Use your credentials to ssh into the scheduler.

Follow these quickstart instructions to create CycleCloud.

<a href="https://docs.microsoft.com/en-us/azure/cyclecloud/qs-install-marketplace?view=cyclecloud-8">Quickstart CycleCloud from Marketplace VM</a>

Set up and use Managed Identities

<a href="https://docs.microsoft.com/en-us/azure/cyclecloud/how-to/managed-identities?view=cyclecloud-8">Set up and use Managed Identities</a>

List of error messages encountered on Cycle Cloud

<a href="https://docs.microsoft.com/en-us/azure/cyclecloud/error_messages?view=cyclecloud-8">List of error message one encounters on Cycle Cloud.</a>

