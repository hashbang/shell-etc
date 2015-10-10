###
# pre-clone
###

# get mail file
mail=$(cat msg.welcome)

###
# cloning
###

# remove all the stuff (hence why cat earlier) and clone repository, set up folders
git init
git clean -f
git remote add origin https://github.com/hashbang/dotfiles
git fetch
git reset --hard origin/master

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
echo "$mail" | sed "s/{date}/$date/g" | sed "s/{username}/$user/g" > Mail/new/msg.welcome

source .bash_profile
source .bashrc
