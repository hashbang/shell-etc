# Firejail profile for mutt

# In case GnuPG is called
noblacklist ~/.gnupg
mkdir ~/.gnupg
whitelist ~/.gnupg

# Allow access to mailboxes
whitelist ~/Mail
whitelist ~/sent
whitelist ~/postponed

# Allow access to mutt and msmtp config
whitelist ~/.muttrc
whitelist ~/.mutt/
whitelist ~/.msmtprc

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
