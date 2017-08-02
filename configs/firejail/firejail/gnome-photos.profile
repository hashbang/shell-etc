# gnome-photos profile

# when gjs apps are started via gnome-shell, firejail is not applied because systemd will start them

noblacklist ~/.local/share/gnome-photos

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
nogroups
nonewprivs
noroot
nosound
protocol unix
seccomp
netfilter
shell none
tracelog

# private-bin gjs gnome-photos
private-tmp
private-dev
# private-etc fonts
