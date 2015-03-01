# shell-etc #

<http://github.com/hashbang/shell-etc>

## About ##

This is the '/etc' directory of the #! shell servers.
Git management is handled via [etckeeper](http://etckeeper.branchable.com/)

You can "Fork" and "Pull Request" any changes you would like to see on our
servers.

This can also be used to set up new #! shell servers to add to our pool.

## Requirements ##

  * Debian Jessie (8.0)

## Usage / Installation ##

1. Install all packages

    ```bash
    wget https://raw.githubusercontent.com/hashbang/shell-etc/master/packages.txt /tmp/packages.txt
    dpkg --set-selections < /tmp/packages.txt
    apt-get dselect-upgrade
    ```

2. Sync '/etc' directory.

    ```bash
    ```

3.  Enable SELinux


    ```bash
    ```

## Notes ##

  Use at your own risk. You may be eaten by a grue.

  Questions/Comments?

  Talk to us via:

  [Email](mailto://team@hashbang.sh) |
  [IRC](irc://irc.hashbang.sh/+6697) |
  [Github](http://github.com/hashbang/)
