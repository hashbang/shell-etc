#!/bin/sh -ex

pwd
git status

# Apply the etckeeper state
_tests/init.sh

# Update the etckeeper state
# (LANG=C is required as the locale influences sorting order)
LANG=C etckeeper pre-commit -d .

git diff HEAD
git status

# Check that only ownership changed
if git diff HEAD | grep -E '^[+-][^+-]' | \
	grep -q -Ev '^[+-]maybe (chgrp|chown)' ; then
    git diff --word-diff HEAD
    exit 1
fi
