#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y -q --force-yes apt-transport-https

wget https://raw.githubusercontent.com/hashbang/shell-etc/master/apt/sources.list -O /etc/apt/sources.list
wget https://raw.githubusercontent.com/hashbang/shell-etc/master/apt/preferences -O /etc/apt/preferences
wget https://raw.githubusercontent.com/hashbang/shell-etc/master/packages.txt -O /etc/packages.txt

apt-get update
apt-get dist-upgrade -o Dpkg::Options::="--force-confnew" -y -q --force-yes
aptitude install -y -q $(cat /etc/packages.txt | awk '{print $1}')
apt-get install -y -q -t unstable selinux-policy-default

selinux-activate

# currently makes Atlantic.net debian boxees unbootable
# needs research
#cd /etc
#git remote add origin https://github.com/hashbang/shell-etc.git
#git fetch --all
#git reset --hard origin/master

for drive in $(lsblk -io KNAME | tail -n +2); do grub-install /dev/$drive; done

reboot

