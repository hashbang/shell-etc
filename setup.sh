#!/bin/bash

apt-get update
apt-get install -y -q --force-yes apt-transport-https
wget https://raw.githubusercontent.com/hashbang/shell-etc/master/apt/sources.list -O /etc/apt/sources.list
wget https://raw.githubusercontent.com/hashbang/shell-etc/master/apt/preferences -O /etc/apt/preferences
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get upgrade -y -q --force-yes
apt-get dist-upgrade -y -q --force-yes

cd /etc
git init
git remote add origin https://github.com/hashbang/shell-etc.git
git fetch --all
git reset --hard origin/master

wget https://raw.githubusercontent.com/hashbang/shell-etc/master/packages.txt -O /tmp/packages.txt
aptitude install -y -q $(cat /tmp/packages.txt | awk '{print $1}')

apt-get install -y -q -t unstable selinux-policy-default
selinux-activate

for drive in $(lsblk -io KNAME | tail -n +2); do grub-install /dev/$drive; done

reboot
