###
# check if the dotfiles must be recreated
###

# Check both ~/.dotfiles and ~/.bash_profile as we
# don't want to run if the user has “old style” dotfiles.
if [ -d ~/.dotfiles ] || [ -f ~/.bash_profile ]; then
    return
fi

###
# pre-clone
###

# Prepare GnuPG homedir
export GNUPGHOME=$(mktemp -d --tmpdir gpg.XXXXXX)
trap "rm -rf -- '${GNUPGHOME}'; unset GNUPGHOME" EXIT

cat > "${GNUPGHOME}/gpg.conf" <<EOF
# Never, ever, ever do this in your personal gpg.conf
# However, this is sane when you know you use an empty GNUPGHOME
keyring /var/lib/hashbang/admins.gpg
trust-model always
EOF

###
# cloning
###

if ! git clone --recursive https://github.com/hashbang/dotfiles ~/.dotfiles; then
    cat >&2 <<EOF
CRITICAL: Failed to clone your dotfiles from
          https://github.com/hashbang/dotfiles
EOF
    rm -rf ~/.dotfiles
    return
fi

if ! git -C ~/.dotfiles verify-commit HEAD; then
    echo "CRITICAL: Failed to verify signature on dotfiles" >&2
    rm -rf ~/.dotfiles
    return
fi

rm -rf -- "${GNUPGHOME}"
unset GNUPGHOME
trap - EXIT

###
# stowing
###

cd ~/.dotfiles
stow bash git gnupg hashbang ssh tmux weechat zsh
cd

###
# Make sure a proper maildir is in place
###

mkdir -p ~/Mail/{cur,new,tmp}

###
# Edit the welcome message
###

sed -i "s/{date}/$(date '+%a, %-d %b %Y %T %Z')/g" Mail/new/msg.welcome
sed -i "s/{username}/$(whoami)/g"                  Mail/new/msg.welcome
