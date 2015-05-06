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

###
# write to mail file section
###
# grab date
date=$(date | awk '{print $1",", $3, $2, $6, $4, $5}')

# since this is the .bashrc we can use $(whoami) for user
user=$(whoami)

# write mail
echo "$mail"
echo "$mail" | sed "s/{date}/$date/" | sed "s/{username}/$user/" #> Mail/new/msg.welcome
