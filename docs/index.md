# Introduction to running AI workflows on the Wilson HPC cluster


## What is the Wilson cluster?


## Why use the WC for AI?


## What GPU resources are available?


## Accessing the Wilson cluster


## The Slurm batch system

Slurm is commonly used batch system on HPC clusters. It is open source, highly scalable, and 
it can schehedule parallel jobs taking advantage of the cluster topology for best performance.

The commonly used slurm commands include
| command  | description |
|--------------------------------------------------|-------------|
|[squeue](https://slurm.schedmd.com/squeue.html)   | reports the state of jobs |
|[sbatch](https://slurm.schedmd.com/sbatch.html)   | submit a job script for later execution |
|[scancel](https://slurm.schedmd.com/scancel.html) | cancel a pending or running job |
|[salloc](https://slurm.schedmd.com/salloc.html)   | allocate resources and spawn a shell which is then used to execute srun commands |
|[srun](https://slurm.schedmd.com/srun.html)       | submit a job for execution or initiate job steps in real time |

See the [downloadable](https://slurm.schedmd.com/pdfs/summary.pdf) PDF cheatsheet for a summary of the commands.

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
My default slurm account is called wc_test.

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

## Why containers are recommneded for AI


## Simple container
