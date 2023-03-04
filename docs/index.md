# Introduction to running AI workflows on the Wilson HPC cluster


## What is the Wilson cluster?


## Why use the WC for AI?


## What GPU resources are available?


## Accessing the Wilson cluster


## The Slurm batch system

Slurm is a common batch system on HPC clusters. It is open source, highly scalable, and 
it can schehedule parallel jobs taking advantage of the cluster topology for best performance.

The commonly used slurm commands include
| command                                          | description |
|--------------------------------------------------|-------------|
|[squeue](https://slurm.schedmd.com/squeue.html)   | reports the state of jobs |
|[sbatch](https://slurm.schedmd.com/sbatch.html)   | submit a job script for later execution |
|[scancel](https://slurm.schedmd.com/scancel.html) | cancel a pending or running job |
|[salloc](https://slurm.schedmd.com/salloc.html)   | allocate resources and spawn a shell which is then used to execute srun commands |
|[srun](https://slurm.schedmd.com/srun.html)       | submit a job for execution or initiate job steps in real time |

See the [downloadable](https://slurm.schedmd.com/pdfs/summary.pdf) PDF cheatsheet for a summary of the commands. SchedMD has a
[quick start guide](https://slurm.schedmd.com/quickstart.html) for slurm users.
See [slurm](https://computing.fnal.gov/wilsoncluster/slurm-job-scheduler/) for the WC slurm configuration and
[job dispatch](https://computing.fnal.gov/wilsoncluster/job-dispatch-explained/) to understand how jobs are pioritized and run.

### Details about your accounts

You can find the name of your default account with the command
```
sacctmgr list user name=$USER
```
```
      User   Def Acct     Admin
---------- ---------- ---------
    simone    wc_test      None
```
My default slurm account is called `wc_test`.

Many users are members of multiple accounts with different quality of service (QOS) levels.
```
sacctmgr list user WithAssoc Format=User,Account,QOS,DefaultQOS name=$USER
```
```
      User    Account                  QOS   Def QOS
---------- ---------- -------------------- ---------
    simone   scd_devs     opp,regular,test       opp
    simone lqcd_bench     opp,regular,test       opp
    simone  spack4hpc     opp,regular,test       opp
    simone   deep_lgt     opp,regular,test       opp
    simone      axial     opp,regular,test       opp
    simone    wc_test     opp,regular,test       opp
```
The QOS level determines the limitations on jobs
| QOS  | description | priority | max wall | other |
|------|-------------|---------:|---------:|:------|
| opp  | opportunistic |  0     | 8:00:00  | maxSubmit=50 |
| regular | Normal QoS (default) | 25 | 24:00:00  |   |
| test    | quick tests  | 75 | 4:00:00 | maxRun=1; maxSubmit=3 |
| admin   | admin testing | 100 |  |  |

### Slurm partitions

A partition in slurm is a way to categorize worker nodes by their unique features. On the Wilson cluster we distinguish workers meant for CPU computing from GPU-acclerated workers. There is a separate partition for the one IBM Power9 "Summit-like" worker since the Power9 architechture is not
binary compatible with the common AMD/Intel x86_64 architecture. There is also a test partition to set aside CPU workers for rapid testing.
Slurm allows setting job limits by partition.
| partition   | description  | avail Nodes | max Nodes  |  max Wall  |  default wall  | exclusive use |
|-------------|--------------|------------:|-----------:|-----------:|---------------:|:-------------:|
| cpu_gce     | CPU workers (16-core) | 90 | 50 | 24:00:00  |  8:00:00  |  Y |
| cpu_gce_test | CPU workers (16-core) | 10 | 5 | 4:00:00  | 1:00:00 | Y |
| gpu_gce      | various GPU workers | 11 | depends on GPU | 24:00:00 | 8:00:00 | N |
| gpu_gce_ppc | IBM Power9 4x V100 | 1 | 1 | 24:00:00 | 8:00:00 | N |

### How to specify the number and type of GPU in a batch job

### Examples of slurm jobs

#### Interactive job

#### Batch scripts

## Why containers are recommended for AI


## Simple container
