#!/bin/bash

set -euo pipefail

sudo apt install nfs-kernel-server
sudo mkdir -p /mnt/vagrant-kubernetes
sudo mkdir -p /mnt/vagrant-kubernetes/data
sudo chown nobody:nogroup /mnt/vagrant-kubernetes
sudo chmod 777 /mnt/vagrant-kubernetes

# /etc/exports 
sudo sh -c "echo '/mnt/vagrant-kubernetes 192.168.199.0/24(rw,sync,no_subtree_check,insecure,no_root_squash)' >> /etc/exports"
sudo exportfs -a
sudo systemctl restart nfs-kernel-server    
sudo exportfs -v