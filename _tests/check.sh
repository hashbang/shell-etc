#!/bin/sh -e

# Apply the etckeeper state
_tests/init.sh

# Update the etckeeper state
# (LANG=C is required as locale influences sorting order)
LANG=C etckeeper pre-commit -d .

# Check that only ownership changed
if git diff --cached | grep -E '^[+-][^+-]' | \
	grep -q -Ev '^[+-]maybe (chgrp|chown)' ; then
    git diff --cached
    exit 1
fi
