# Firejail profile for mutt

# Only allow R/O access to the home directory
read-only ~/

# In case GnuPG is called
noblacklist ~/.gnupg
read-write  ~/.gnupg

# Permit access to the config files
noblacklist ~/.mutt
noblacklist ~/.muttrc
noblacklist ~/.msmtprc

# Allow write access to mailboxes
read-write ~/Mail
read-write ~/sent
read-write ~/postponed

# Allow executing /usr/sbin/sendmail
noblacklist /usr/sbin

# Generic sandboxing
caps.drop all
seccomp
protocol unix,inet,inet6
netfilter
tracelog
nonewprivs
noroot

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
