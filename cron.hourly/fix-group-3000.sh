#!/bin/sh

mkdir -p -m 0700 /var/log/fix-group-3000
umask 0077
cd /home
for user in *; do
    uid="$(id -u "$user")"
    if [ "$uid" -ne 3000 ]; then
        find "/home/$user" -group 3000 -print -exec chgrp --no-dereference "$user" '{}' ';' && \
            echo "User $user had broken files"
    fi
done | gzip >> /var/log/fix-group-3000/"$(date '+%Y%m%d-%H%M')".gz
