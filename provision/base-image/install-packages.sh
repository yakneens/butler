#!/bin/bash

sudo yum install epel-release -y
sudo yum install https://repo.saltstack.com/yum/redhat/salt-repo-latest-2.el7.noarch.rpm -y
sudo yum -y update
sudo yum install yum-plugin-priorities -y

sudo yum install unzip tcpdump netstat wget tmux -y
sudo yum install postfix vixie-cron crontabs man mlocate logrotate logwatch wget which -y
sudo yum install bind-utils -y
sudo yum install zlib-devel -y

sudo yum install kernel-devel -y
sudo yum install cmake -y
sudo yum install gcc gcc-c++ -y

sudo yum install git -y

sudo yum install python-devel -y
sudo yum install python-pip -y

sudo yum install dnsmasq -y

sudo yum install salt-minion -y

sudo pip uninstall tornado
sudo pip install tornado==4.2.1
sudo yum install java -y

#sudo  yum install collectd -y

#Update local policy to allow collectd access to the log file. 
#Need to place collectd_log_allow.te into /tmp on the host before running
#sudo checkmodule -M -m -o /tmp/collectd_log_allow.mod /tmp/collectd_log_allow.te
#sudo semodule_package -m /tmp/collectd_log_allow.mod -o /tmp/collectd_log_allow.pp
#sudo semodule -i /tmp/collectd_log_allow.pp
