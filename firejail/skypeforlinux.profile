# skypeforlinux profile
noblacklist ${HOME}/.config/skypeforlinux
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
netfilter
noroot
seccomp
protocol unix,inet,inet6,netlink
