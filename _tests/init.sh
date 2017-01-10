#!/bin/sh -e
# This script applies the etckeeper metadata to the current index.

if ! [ -d .git ]; then
    echo "$0 must be called from the root of shell-etc" >&2
    exit 1
fi

# Ignore ownership changes
chgrp() :
chown() :

# Define “maybe”
maybe() {
    $@ || true;
}

# Source the etckeeper metadata
. ./.etckeeper
