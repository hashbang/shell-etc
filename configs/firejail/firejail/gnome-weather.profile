# gnome-weather profile

# when gjs apps are started via gnome-shell, firejail is not applied because systemd will start them

noblacklist ~/.cache/libgweather

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
nogroups
nonewprivs
noroot
nosound
protocol unix,inet,inet6
seccomp
netfilter
shell none
tracelog

# private-bin gjs gnome-weather
private-tmp
private-dev
# private-etc fonts
