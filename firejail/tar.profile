# tar profile
quiet
ignore noroot
include /etc/firejail/default.profile

tracelog
net none
shell none

# support compressed archives
private-bin sh,tar,gtar,compress,gzip,lzma,xz,bzip2,lbzip2,lzip,lzop
private-dev
private-etc passwd,group,localtime
hostname tar
nosound
