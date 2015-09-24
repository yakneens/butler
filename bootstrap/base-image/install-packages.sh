#!/bin/bash

sudo yum install epel-release -y
wget https://repo.saltstack.com/yum/rhel7/SALTSTACK-GPG-KEY.pub
rpm --import SALTSTACK-GPG-KEY.pub
rm -f SALTSTACK-GPG-KEY.pub
printf "[saltstack-repo]\nname=SaltStack repo for RHEL/CentOS $releasever\nbaseurl=https://repo.saltstack.com/yum/rhel$releasever\nenabled=1\ngpgcheck=1\ngpgkey=https://repo.saltstack.com/yum/rhel$releasever/SALTSTACK-GPG-KEY.pub\n" | tee /etc/yum.repos.d/saltstack.repo

sudo yum -y update
sudo yum install yum-plugin-priorities -y

sudo yum install unzip tcpdump netstat wget tmux -y
sudo yum install postfix vixie-cron crontabs man mlocate logrotate logwatch wget which -y

sudo yum install zlib-devel -y

sudo yum install kernel-devel -y
sudo yum install cmake -y
sudo yum install gcc gcc-c++ -y

sudo yum install git -y

sudo yum install python-devel -y
sudo yum install python-pip -y

sudo yum install dnsmasq -y

sudo yum install salt-minion -y

sudo  yum install collectd -y
