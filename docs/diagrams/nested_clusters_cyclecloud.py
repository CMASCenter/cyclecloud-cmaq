from diagrams import Cluster, Diagram
from diagrams.aws.compute import EC2, EC2SpotInstance
from diagrams.aws.database import Redshift
from diagrams.aws.integration import SQS
from diagrams.aws.storage import S3, EBS, FSx
from diagrams.aws.devtools import CLI
from diagrams.azure.compute import Disks
from diagrams.azure.storage import BlobStorage
from diagrams.azure.storage import StorageSyncServices

with Diagram("Microsoft Azure Cycle Cloud", show=False):
    source = CLI("Azure")

    with Cluster("Cycle Cloud"):

        queue = SQS("SLURM")
        

        with Cluster("Scheduler Node"):
            head = [EC2("D4ds v5 (4 vcpus)")]

        with Cluster("HBv3 - 120CPU/compute node; Scalable based SLURM request"):
            workers = [EC2("HBv3-120"),
                       EC2("HBv3-120"),
                        EC2("HBv3-120")]
        with Cluster("Shared"):
             sched = [
                     EC2("Scheduler Node"), 
                     Disks("Shared - 1.0TB")]
        with Cluster("Data - Azure Files, Serverless File Shares"):
             volume1 = [
                     Disks("data-1.0TB")]
        with Cluster("Lustre"):
             volume2 = [ 
                     Disks("lustre-64TB")]
        mnt = StorageSyncServices("Mount Point")

    store = BlobStorage("Blob Storage")

    source >> head >> queue >> workers
    workers >> mnt 
    mnt >> sched  >> store
    mnt >> volume1 >> store
    mnt >> volume2 >> store
