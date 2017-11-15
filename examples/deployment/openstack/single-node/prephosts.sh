#!/bin/bash

if [ -z "$1" ]; then
  echo "Please provide key file to insert"
  exit 1 
fi

scp $1 butler:
ssh butler "echo Host butler-* > .ssh/config"
ssh butler "echo IdentityFile /home/centos/`basename $1` >> .ssh/config"
ssh butler "chmod go-rwx .ssh/config"

ssh -t butler "echo `terraform output butler` butler | sudo tee -a /etc/hosts"

