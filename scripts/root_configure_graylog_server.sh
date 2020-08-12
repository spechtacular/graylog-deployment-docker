#!/bin/bash

if [ "$(whoami)" != "root" ]; then
        echo "Script must be run as user: root"
        exit -1
fi

# local users required to run elasticsearch, mongodb, and graylog
# graylog user
addgroup --gid 1100 graylog
useradd -M -g 1100 -u 1100 graylog
usermod -L graylog

# mongodb user, administrator group
useradd -M -u 999 -g 1000 mongodb
usermod -L mongodb

mkdir -p ../data/db
mkdir -p ../usr/share/elasticsearch/data/
mkdir -p ../usr/share/graylog/data
chown administrator:administrator ../usr
chown administrator:administrator ../usr/share
chown -R administrator:administrator ../usr/share/elasticsearch
chown -R graylog:graylog ../usr/share/graylog
chown -R mongodb:administrator ../data

# load the crontabs used to backup mongodb and manage backups
crontab ./crontabs/root

# install packages required for samba
apt -y install samba
apt -y install samba-common python-glade2 system-config-samba smbldap-tools libnss-ldap
apt -y autoremove

mkdir -p /mnt/shared
chown -R administrator:administrator /mnt/shared


# configuration of samba used in /etc/fstab
fstab_samba_config="//10.81.1.237/backup /mnt/shared cifs   auto,rw,user,noperm,username=administrator,password=Welcome1,workgroup=Workgroup,_netdev,file_mode=0644,dir_mode=0755,uid=1000,gid=1000,sec=ntlm 0 0"

samba_configured=$(grep -c cifs /etc/fstab)

if [ $samba_configured -gt 0 ]; then
   echo "samba is configured"
else
   echo "samba is not configured"
   echo $fstab_samba_config >> /etc/fstab
fi

# elasticsearch config change
sysctl -w vm.max_map_count=262144

# reboot for changes to take effect
reboot
