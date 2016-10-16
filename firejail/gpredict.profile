# Firejail profile for gpredict.
noblacklist ~/.config/Gpredict
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

# Whitelist
mkdir ~/.config/Gpredict
whitelist ~/.config/Gpredict

caps.drop all
netfilter
nonewprivs
nogroups
noroot
nosound
protocol unix,inet,inet6
seccomp
shell none
tracelog

private-bin gpredict
private-dev
private-tmp
