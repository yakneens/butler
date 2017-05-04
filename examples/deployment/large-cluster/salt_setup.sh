#!/bin/bash

echo "got $1 as master ip, $2 as id and $3 as roles"

sudo yum install epel-release -y
#sudo yum -y update
sudo yum install wget yum-plugin-priorities -y
sudo yum install -y https://repo.saltstack.com/yum/redhat/salt-repo-latest-1.el7.noarch.rpm
sudo yum clean expire-cache
sudo yum install salt-minion -y
sudo service salt-minion stop
echo "master: $1" | sudo tee  -a /etc/salt/minion
echo "id: $2" | sudo tee -a /etc/salt/minion
echo "roles: [$3]" | sudo tee -a /etc/salt/grains
sudo hostname $2
sudo service salt-minion start
