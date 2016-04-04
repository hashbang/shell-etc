#!/bin/bash

# Make apt-get be fully non-interactive
export DEBIAN_FRONTEND=noninteractive

# Turn on logging to disk
mkdir -p /var/log/journal
systemd-tmpfiles --create --prefix /var/log/journal
pkill -USR1 systemd-journal # use 'journalctl --flush' once available

# Full system update/upgrade according to shell-etc settings
apt update
apt install -y -q --force-yes apt-transport-https

wget https://raw.githubusercontent.com/hashbang/shell-etc/master/apt/sources.list -O /etc/apt/sources.list
wget https://raw.githubusercontent.com/hashbang/shell-etc/master/apt/preferences -O /etc/apt/preferences
wget https://raw.githubusercontent.com/hashbang/shell-etc/master/packages.txt -O /etc/packages.txt

apt update
apt-cache dumpavail | dpkg --update-avail
dpkg --clear-selections
dpkg --set-selections < /etc/packages.txt
apt-get dselect-upgrade -q -y
apt upgrade
aptitude purge -y -q ~c


# Point etckeeper at shell-etc repo and sync all configs
cd /etc
rm -rf .git
git init
git remote add origin https://github.com/hashbang/shell-etc.git
git fetch --all
git reset --hard origin/master
git clean -d -f
etckeeper init # Apply the correct file permissions

# Disable users knowing about other users
chmod o-r /var/run/utmp # Used by who(1)
chmod o-r /var/log/wtmp # Used by last(1)
chmod o-r /var/log/lastlog # Used by lastlog(8)
chmod o-r /home # prevent listing of all home dirs.

reboot
