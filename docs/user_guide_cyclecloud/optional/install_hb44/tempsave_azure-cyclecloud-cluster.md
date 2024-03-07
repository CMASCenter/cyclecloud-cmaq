# Create Cyclecloud CMAQ Cluster

Documentation for Azure
<a href="https://docs.microsoft.com/en-us/azure/cyclecloud/?view=cyclecloud-8">CycleCloud Documentation</a>

## Configure the Cycle Cloud Cluster using the Azure Portal

Log into the [Azure Portal](https://ms.portal.azure.com/)

In the search bar, enter "Marketplace", Click on Marketplace Icon.

In the Marketplace search bar, enter "CycleCloud".

Click on the heart in the Azure CycleCloud box to add this as a favorite resource.

Use the Create pulldown menu to select `Azure CycleCloud 8.2` 

## Customize Scheduler node for CycleCloud

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




Create a virtual Machine - 
Note: this virtual machine will be used to create the Cycle Cloud Cluster from it's Web located at: UI https://IP-address/home

![Azure Create a Virtual Machine Console](../../azure_web_interface_images/Create_Virtual_Machine.png)

Select a VM Size of D4s_v3

Selects Disks for the Azure Virtual Machine
![Select Disks for the Azure Virutal Machine](../../azure_web_interface_images/Create_VM_Select_DIsks.png)

Selects Network Interface for the Azure Virtual Machine
![Select Network Interface for the Azure Virutal Machine](../../azure_web_interface_images/Create_VM_Select_Network_Interface.png)

Create Virtual Machine Management Identity
![Select Network Interface for the Azure Virutal Machine](../../azure_web_interface_images/Create_VM_Management_Identity.png)


Create a Virtual Machine
![Create the Virtual Machine](../../azure_web_interface_images/Create_VM.png)

Add Contributor Role to Virtual Machine
Click on the Identity Menu on the left side of the newly created virtual machine.
Make sure you select the System Assigned Tab at the top of the window.
Click on the button `Azure Role Assignments`

Click on the + Add Role Assignment
![Add Contributor Role to Virtual Machine](../../azure_web_interface_images/VM_Add_Role_Assignment_Contributor.png)

Add Role Assignment - Management Identity
![Add Contributor Role to Virtual Machine](../../azure_web_interface_images/VM_Add_Role_Assignment_Members_Managed_Identity.png)

Add Role Assignment
![Add Role Assignment](../../azure_web_interface_images/VM_Add_Role_Assignment.png)

Add Reader Role to Virtual Machine
![Add Reader Role to Virtual Machine](../../azure_web_interface_images/VM_Add_Role_Assignment_Reader.png)

Review Reader Role on Virtual Machine
![Review Reader Role to Virtual Machine](../../azure_web_interface_images/VM_Add_Role_Assignment_Reader_Review.png)

Azure Create Storage Account
![Create Storage Account on Azure](../../azure_web_interface_images/Azure_Create_Storage_Account.png)

Azure Create Storage Account Details
![Details of Storage Account on Azure](../../azure_web_interface_images/Azure_Create_A_Storage_Account_details.png)

Azure Review Storate Account Details
![Review Details of Storage Account on Azure](../../azure_web_interface_images/Azure_Create_A_Storage_Account_Review+create.png)

Web Interface to CycleCloud - connect using the ip address for the virtual machine above http://-IP-ADDRESS/welcome
![Web Interface to CycleCloud](../../azure_web_interface_images/Cyclecloud-ea_Virtual_Machine.png)

Azure CycleCloud Web Login
![Azure CycleCloud Web Login](../../azure_web_interface_images/Azure_CycleCloud_Web_Login.png)

Azure CycleCloud Add Subscription
![Azure CycleCloud Add Subscription](../../azure_web_interface_images/Azure_CycleCloud_Add_Subscription.png)

Azure CycleCloud Add Subscription and Validate Credentials
![Azure CycleCloud Add Subscription and Validate Credentials](../../azure_web_interface_images/Azure_CycleCloud_Add_Subscription_Validate_Credentials.png)

Azure CycleCloud HPC Queue Select Machine
![Azure CycleCloud HPC Queue Select Machine](../../azure_web_interface_images/Azure_CycleCloud_Select_A_Machine_Type_HC44rs.png)

Azure CycleCloud HPC VM Type Confirmed
![Azure CycleCloud HPC VM Type Confirmed](../../azure_web_interface_images/Azure_CycleCloud_HPC_VM_TYPE_HC44rs.png)

Azure CycleCloud Network Attached Storage
![Azure CycleCloud Network Attached Storage](../../azure_web_interface_images/Azure_CycleCloud_Network_Attached_Storage.png)

Azure CycleCloud Select OS and Uncheck Name as HostName
![Azure CycleCloud Select OS](../../azure_web_interface_images/Azure_CycleCloud_Advanced_Settings_Choose_OS.png)

Login to Azure Cycle Cloud and verify that the following command works.

'srun -t 1:30:00  -n --pty /bin/bash'

## Instructions to upgrade the number of processors available to the Cycle Cloud Cluster

Edit the HPC config in the cyclecloud web interface to set the CPUs to 480 
Run the following on the scheduler node the changes should get picked up:

`cd /opt/cycle/slurm`

`sudo ./cyclecloud_slurm.sh scale`
