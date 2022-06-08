# Create Cyclecloud CMAQ Cluster

Documentation for Azure
<a href="https://docs.microsoft.com/en-us/azure/cyclecloud/?view=cyclecloud-8">CycleCloud Documentation</a>

## Configure the Cycle Cloud Cluster using the Azure Portal

Log into the [Azure Portal](https://ms.portal.azure.com/)

In the search bar, enter "Marketplace", Click on Marketplace Icon.

In the Marketplace search bar, enter "CycleCloud".

Click on the heart in the Azure CycleCloud box to add this as a favorite resource.

Use the Create pulldown menu to select `Azure CycleCloud 8.2` 

## Customize Host Virtual Machine for CycleCloud

1. Choose your Subscription
2. Select or create a new Resource Group that your CycleCloud instance will run in
3. Name your CycleCloud instance using Virtual Machine name 
4. Select Region
5. Verify Image is Azure CycleCloud 8.2 - Gen 1
6. Select Size, click on see all sizes, enter D4s into the search button and select Standard_D4s_v3- 4cpus, 16GiB memory ($140.16/month)
7. Select Authentication Type `SSH public key`
5. Create the Username that you will use to log into the instance
6. SSH public key source - select `Generate new key pair`
7. Select the Management tab and enable `System assigned managed identity`
8. Click on the `Review` button and then the `Create` button




Figure 1. Create a virtual Machine - Customize Host Virtual Machine
Note: this virtual machine will be used to create the Cycle Cloud Cluster from it's Web located at: UI https://IP-address/home

![Azure Create a Virtual Machine Console](../../azure_web_interface_images/Create_Virtual_Machine.png)

Figure 2. Select Disks for the Azure Virtual Machine - use default options

![Select Disks for the Azure Virutal Machine](../../azure_web_interface_images/Create_VM_Select_DIsks.png)

Figure 3. Select Network Interface for the Azure Virtual Machine - use default options

![Select Network Interface for the Azure Virutal Machine](../../azure_web_interface_images/Create_VM_Select_Network_Interface.png)

Figure 4. Select System assigned Managed Identity

![Select Network Interface for the Azure Virutal Machine](../../azure_web_interface_images/Create_VM_Management_Identity.png)


Figure 5. Create a Virtual Machine

![Create the Virtual Machine](../../azure_web_interface_images/Create_VM.png)


Next, add Contributor Role to Virtual Machine

Click on the Identity Menu on the left side of the newly created virtual machine.
Make sure you select the System Assigned Tab at the top of the window.
Click on the button `Azure Role Assignments`
For the following figures, additional instructions are needed, as it is unclear where users go to add the contributor role. 

Figure 6. Add Contributor Role to Virtual Machine

![Add Contributor Role to Virtual Machine](../../azure_web_interface_images/VM_Add_Role_Assignment_Contributor.png)

Figure 7. Add Role Assignment - Management Identity
![Add Contributor Role to Virtual Machine](../../azure_web_interface_images/VM_Add_Role_Assignment_Members_Managed_Identity.png)

Figure 8. Add Role Assignment

1. Click Identity Icon under Settings on the left side menu 
2. Click Azure role assignments
3. Click Add role assignment  

Note, many of the screen shots below don't show how to get to that menu. When I tried to reproduce these steps, I was getting permission issues.

![Add Role Assignment](../../azure_web_interface_images/VM_Add_Role_Assignment.png)

Figure 9. Add Reader Role to Virtual Machine

![Add Reader Role to Virtual Machine](../../azure_web_interface_images/VM_Add_Role_Assignment_Reader.png)

Figure 10. Review Reader Role on Virtual Machine

![Review Reader Role to Virtual Machine](../../azure_web_interface_images/VM_Add_Role_Assignment_Reader_Review.png)

Figure 11. Azure Create Storage Account

![Create Storage Account on Azure](../../azure_web_interface_images/Azure_Create_Storage_Account.png)

Figure 12. Azure Create Storage Account Details

![Details of Storage Account on Azure](../../azure_web_interface_images/Azure_Create_A_Storage_Account_details.png)

Figure 13. Azure Review Storate Account Details
![Review Details of Storage Account on Azure](../../azure_web_interface_images/Azure_Create_A_Storage_Account_Review+create.png)

## Click Go to Resoure after the deployment is complete.
![Deployment Complete Click on Go to Resource](../../azure_web_interface_images/Azure_Deployment_Complete.png)

Click on Copy next to the Public IP address to copy it.

![CycleCloudMarketPlace Scheduler Node](../../azure_web_interface_images/Azure_CycleCloud_Virtual_Machine.png)

## Connect to Cyclecloud Web Interface

In your web browser, create a new tab, and enter the IP address that you copied from the step above.

`https://-IP-ADDRESS/welcome`

1. Enter a Site Name - a unique name for the CycleCloud.

CycleCloudCMAQ

2. Read and click that you agree to the CycleCloud Software License Agreement

![CycleCloudMarketPlace Scheduler Node](../../azure_web_interface_images/Azure_CycleCloud_Step2.png)

3. Create your CycleCloud Administrator Account. Use the same username that you used for the scheduler node. 

Figure 14. Web Interface to CycleCloud - connect using the ip address for the Scheduler Node above http://-IP-ADDRESS/welcome
![Web Interface to CycleCloud](../../azure_web_interface_images/Cyclecloud-ea_Virtual_Machine.png)

Figure 15. Azure CycleCloud Web Login
![Azure CycleCloud Web Login](../../azure_web_interface_images/Azure_CycleCloud_Web_Login.png)

Figure 16. Azure CycleCloud Add Subscription
![Azure CycleCloud Add Subscription](../../azure_web_interface_images/Azure_CycleCloud_Add_Subscription.png)

Figure 17. Azure CycleCloud Add Subscription and Validate Credentials
![Azure CycleCloud Add Subscription and Validate Credentials](../../azure_web_interface_images/Azure_CycleCloud_Add_Subscription_Validate_Credentials.png)

Figure 18. 
Azure CycleCloud HPC Queue Select Machine
![Azure CycleCloud HPC Queue Select Machine](../../azure_web_interface_images/Azure_CycleCloud_Select_A_Machine_Type_HC44rs.png)

Figure 19. 
Azure CycleCloud HPC VM Type Confirmed
![Azure CycleCloud HPC VM Type Confirmed](../../azure_web_interface_images/Azure_CycleCloud_HPC_VM_TYPE_HC44rs.png)

Figure 20.
Azure CycleCloud Network Attached Storage
![Azure CycleCloud Network Attached Storage](../../azure_web_interface_images/Azure_CycleCloud_Network_Attached_Storage.png)

Figure 21.
Azure CycleCloud Select OS and Uncheck Name as HostName
![Azure CycleCloud Select OS](../../azure_web_interface_images/Azure_CycleCloud_Advanced_Settings_Choose_OS.png)

Login to Azure Cycle Cloud and verify that the following command works.

'srun -t 1:30:00  -n --pty /bin/bash'

## Instructions to upgrade the number of processors available to the Cycle Cloud Cluster

Edit the HPC config in the cyclecloud web interface to set the CPUs to 480 
Run the following on the scheduler node the changes should get picked up:

`cd /opt/cycle/slurm`

`sudo ./cyclecloud_slurm.sh scale`
