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
chmod 0600 /etc/sssd/sssd.conf

# Disable users knowing about other users
chmod o-r /var/run/utmp # Used by who(1)
chmod o-r /var/log/wtmp # Used by last(1)
chmod o-r /var/log/lastlog # Used by lastlog(8)
chmod o-r /home # prevent listing of all home dirs.

# Install grub to all devices (overkill, but safe)
grub-install /dev/sda

# Update initramfs to include repartioning logic
update-initramfs -u

reboot
