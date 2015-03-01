#!/bin/bash

apt-get update
apt-get install apt-transport-https
wget https://raw.githubusercontent.com/hashbang/shell-etc/master/apt/sources.list -O /etc/apt/sources.list
wget https://raw.githubusercontent.com/hashbang/shell-etc/master/apt/preferences -O /etc/apt/preferences
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get upgrade -y -q --force-yes
apt-get dist-upgrade -y -q --force-yes

wget https://raw.githubusercontent.com/hashbang/shell-etc/master/packages.txt -O /tmp/packages.txt
aptitude install $(cat /tmp/packages.txt | awk '{print $1}')
#apt-get install -t unstable selinux-policy-default

cd /etc
git init
git remote add origin https://github.com/hashbang/shell-etc.git
git fetch --all
git reset --hard origin/master

#selinux-activate
#reboot
