#!/bin/bash

if [ -z "$1" ]; then
  echo "Please provide key file to insert"
  exit 1 
fi

scp $1 salt-master:
ssh salt-master "echo Host butler-* > .ssh/config"
ssh salt-master "echo IdentityFile /home/centos/`basename $1` >> .ssh/config"
ssh salt-master "chmod go-rwx .ssh/config"

ssh -t salt-master "echo `terraform output db-server` butler-db-server | sudo tee -a /etc/hosts"
ssh -t salt-master "echo `terraform output job-queue` butler-job-queue | sudo tee -a /etc/hosts"
ssh -t salt-master "echo `terraform output tracker` butler-tracker | sudo tee -a /etc/hosts"
ssh -t salt-master "echo `terraform output worker-0` butler-worker-0 | sudo tee -a /etc/hosts"
ssh -t salt-master "echo `terraform output worker-1` butler-worker-1 | sudo tee -a /etc/hosts"
