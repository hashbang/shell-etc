###
# pre-clone
###

# get mail file
mail=$(cat msg.welcome)

# Prepare GnuPG homedir
export GNUPGHOME=$(mktemp -d --tmpdir gpg.XXXXXX)
trap "rm -rf -- '${GNUPGHOME}'" EXIT

cat > "${GNUPGHOME}/gpg.conf" <<EOF
# Never, ever, ever do this in your personal gpg.conf
# However, this is sane when you know you use an empty GNUPGHOME
keyring /etc/gnupg/hashbang-admins.gpg
trust-model always
EOF

###
# cloning
###

# remove all the stuff (hence why cat earlier) and clone repository, set up folders
git init
git clean -f
git remote add origin https://github.com/hashbang/dotfiles
git fetch
git reset --hard origin/master

local err=0
git verify-commit HEAD || err=$?
if [ $err -ne 0 ]; then
    cat >&2 <<EOF
CRITICAL: Failed to verify signature on
          https://github.com/hashbang/dotfiles
EOF
    rm -rf ~/.* ~/*
    return
fi

# Setup submodules
git submodule update --init --recursive

###
# write to mail file section
###

# grab date
date=$(date | awk '{print $1",", $3, $2, $6, $4, $5}')

# since this is the .bashrc we can use $(whoami) for user
user=$(whoami)

# write mail
mkdir -p ~/Mail/{cur,new,tmp}
echo "$mail" | sed "s/{date}/$date/g" | sed "s/{username}/$user/g" > Mail/new/msg.welcome

source .bash_profile
source .bashrc
