# Introduction to running AI workflows on the Wilson HPC cluster


## What is the Wilson cluster?


## Why use the WC for AI?


## What GPU resources are available?


## Accessing the Wilson cluster


## The Slurm batch system

You can find the name of your default account with the command
```
sacctmgr list user name=$USER
```
Many users are members of multiple accounts with different quality of service (QOS) levels.
```
sacctmgr list user WithAssoc Format=User,Account,QOS,DefaultQOS name=$USER
```

## Why containers are recommneded for AI


## Simple container
