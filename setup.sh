#!/bin/bash

# Make apt-get be fully non-interactive
export DEBIAN_FRONTEND=noninteractive

# Full system update/upgrade according to shell-etc settings
apt-get update
apt-get install -y -q --force-yes apt-transport-https
wget https://raw.githubusercontent.com/hashbang/shell-etc/master/apt/sources.list -O /etc/apt/sources.list
wget https://raw.githubusercontent.com/hashbang/shell-etc/master/apt/preferences -O /etc/apt/preferences
wget https://raw.githubusercontent.com/hashbang/shell-etc/master/packages.txt -O /etc/packages.txt
apt-get update
apt-get dist-upgrade -o Dpkg::Options::="--force-confnew" -y -q --force-yes
aptitude install -y -q $(cat /etc/packages.txt | awk '{print $1}')
apt-get install -y -q -t unstable selinux-policy-default

# Remove any packages (and configs) on local system not listed in packages.txt
apt-get remove -y -q $(diff <(dpkg --get-selections) <(cat /etc/packages.txt) | egrep "^<" | awk '{ print $2 }')
aptitude purge -y -q ~c

# Enable SELinux
selinux-activate

# Point etckeeper at shell-etc repo and sync all configs
cd /etc
rm -rf .git
git init
git remote add origin https://github.com/hashbang/shell-etc.git
git fetch --all
git reset --hard origin/master
git clean -f

# Disable who(1), last(1) and lastlog(8) for normal users
chmod o-r /var/run/utmp
chmod o-r /var/log/wtmp
chmod o-r /var/log/lastlog

# Install grub to all devices (overkill, but safe)
for drive in $(lsblk -io KNAME | tail -n +2); do grub-install /dev/$drive; done

reboot
