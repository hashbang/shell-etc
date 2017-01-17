# mutt email client profile
read-only ~/

# In case GnuPG is called
read-write  ~/.gnupg

# Allow write access to mailboxes
read-write ~/Mail
read-write ~/sent
read-write ~/postponed

noblacklist ~/.muttrc
noblacklist ~/.mutt
noblacklist ~/.mutt/muttrc
noblacklist ~/.mailcap
noblacklist ~/.gnupg
noblacklist ~/.mail
noblacklist ~/.Mail
noblacklist ~/mail
noblacklist ~/Mail
noblacklist ~/sent
noblacklist ~/postponed
noblacklist ~/.cache/mutt
noblacklist ~/.w3m
noblacklist ~/.elinks
noblacklist ~/.vim
noblacklist ~/.vimrc
noblacklist ~/.viminfo
noblacklist ~/.emacs
noblacklist ~/.emacs.d
noblacklist ~/.signature
noblacklist ~/.bogofilter
noblacklist ~/.msmtprc

# Allow executing /usr/sbin/sendmail
noblacklist /usr/sbin

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-devel.inc

caps.drop all
netfilter
nogroups
nonewprivs
noroot
nosound
no3d
protocol unix,inet,inet6
seccomp
shell none

blacklist /tmp/.X11-unix

private-dev
