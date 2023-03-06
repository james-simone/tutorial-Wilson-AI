# Introduction to AI workflows on the Wilson HPC cluster

## https://james-simone.github.io/tutorial-Wilson-AI/

![QR code](QR_Code_1678138121.png)

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

All GPU worker nodes are in the `gpu_gce` partition except the IBM Power9 worker which in the `gpu_gce_ppc` partition.
The WC has a variery of GPU worker nodes with different generations of NVIDIA GPUs. The "Slurm spec." in the table below is how
how you tell slurm the GPU type you want. If you do not specifiy a type, you job will run with first available GPU of
any type. 


| Nodes | GPU type | CUDA cores | device mem. [GB] | Slurm spec. | GPUs/Node | Cores/Node  |  Mem/Node [GB] |
|------:|:---------|-----------:|-----------------:|:------------|----------:|------------:|---------------:|
|  1    | [A100](https://www.nvidia.com/en-us/data-center/a100/) | 6912       |  80              | a100        |  4        |   64        |  512          |
|  4    | [V100](https://www.nvidia.com/en-us/data-center/v100/) | 5120       |  32              | v100        |  2        |   40        |   188          |
|  1    | [P100](https://www.nvidia.com/en-us/data-center/tesla-p100/) | 3584       |  16              | p100        |  8        |   16        |   768          |
|  1    | [P100](https://www.nvidia.com/en-us/data-center/tesla-p100/) | 3584       |  16              | p100nvlink  |  2        |   28        |  1000          |
|  1 IBM   | [V100](https://www.nvidia.com/en-us/data-center/v100/) | 5120       |  32             |v100nvlinkppc64 | 4     |   32(128t)  |  1000          |

A GPU job can request more than one GPU to enable parallel use GPUs by your code.
Slurm, however, will not permit mixing different slurm specifications within a job, e.g., a slurm job cannot request
eight V100 plus eight P100 devices. GPU workers are generally shared by by jobs requesting fewer than the maximum number of GPUs in a node.
GPUs a never shared among different jobs, each job has exclusive use of the GPUs slurm assigns to it.

Slurm manages GPUs as generic resource via the `--gres` flag to the commands `sbatch`, `salloc`, or `srun`. For example,
| slurm                |  description           |
|:--------------------|:-----------------------|
| `--gres=gpu:1`      | one GPU of any type per node   |
| `--gres=gpu:p100:1` | one P100 GPU per node          |
| `--gres=gpu:v100:2` | two V100 GPUs per node -- the max on the Intel V100 workers |
| `--gres=gpu:v100:2 --nodes=2` | four V100 GPUs total on two worker nodes |

### Caveat concerning job submission

**Please note that slurm jobs will NOT run from your home directory on the Wilson cluster!**

Your Wilson home directory is your lab-wide  "nashome" directory. The `/nashome` filesystem is mounted with Kerberos authentication, and
unfortunately, Kerberos is not currently compatible with slurm.
Start batch jobs from your area under either `/work1` or `/wclustre`.

### Interactive job

Interactive batch jobs are started using the `srun` command. For example, with the default slurm account and QOS, the command below
requests a single P100 GPU for one hour of wall time
```
srun --unbuffered --pty --partition=gpu_gce --gres=gpu:p100:1 --nodes=1 --ntasks-per-node=1 --cpus-per-task=2 --time=00:10:00 /bin/bash
```
The request specifies one CPU task per node, each task is allocated four CPU cores to allow threads to execution on distinct cores.

This batch job will potentially sharing a worker with other jobs since the default is non-exclusive scheduling for GPU workers, and
the request does not ask for all available node resources.
Once a suitable node is avialable, a bash shell will start on the worker. You can then type interactive commands that run on the
GPU worker. For example, the command [nvidia-smi](https://developer.nvidia.com/nvidia-system-management-interface)
will show this job is assigned one GPU
```
$ nvidia-smi
Mon Mar  6 11:55:23 2023
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 515.48.07    Driver Version: 515.48.07    CUDA Version: 11.7     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Tesla P100-PCIE...  On   | 00000000:07:00.0 Off |                    0 |
| N/A   29C    P0    25W / 250W |      0MiB / 16384MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
```


### Batch scripts

The batch script is [here](https://github.com/james-simone/tutorial-Wilson-AI/blob/main/simple_batch.sh)
```
#! /bin/bash

#SBATCH --job-name=simple
#SBATCH --mail-type=NONE
#SBATCH --output=job_%x_%A.out
#SBATCH --partition=gpu_gce
#SBATCH --nodes=1
#SBATCH --gres=gpu:p100:1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=2
#SBATCH --time=00:05:00

nvidia-smi
```

## Why containers are recommended for AI


## Simple container
