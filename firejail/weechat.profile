# Weechat IRC profile
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc

whitelist ${HOME}/.dotfiles/weechat
whitelist ${HOME}/.weechat

caps.drop all
netfilter
nonewprivs
noroot
protocol unix,inet,inet6
seccomp

# no private-bin support for various reasons:
# Plugins loaded: alias, aspell, charset, exec, fifo, guile, irc,
# logger, lua, perl, python, relay, ruby, script, tcl, trigger, xferloading plugins
