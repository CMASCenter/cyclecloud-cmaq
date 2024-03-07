# Modify Cyclecloud CMAQ Cluster


## If you make changes to the nodes you must run the following commands

```
cd /opt/cycle/slurm
sudo ./cyclecloud_slurm.sh remove_nodes
sudo ./cyclecloud_slurm.sh scale
```

The above commands will remove the hpc nodes from the cluster and then rescale the cluster to use the new nodes that were specified when you edited the cluster.

This is required if you change the identity of the hpc VM. 
An example: if you change Standard_HB120-64rs_v3, a EPYC virtual machine containing 64 pes, to Standard_HB120rs_v3, an EPYC virtual machine containing 120 pes.

