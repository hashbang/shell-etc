# shell-etc #

<http://github.com/hashbang/shell-etc>

## About ##

This is the '/etc' directory of the #! shell servers.
Git management is handled via [etckeeper](http://etckeeper.branchable.com/)

You can "Fork" and "Pull Request" any changes you would like to see on our
servers.

This can also be used to set up new #! shell servers to add to our pool.

## Requirements ##

  * Debian 7+

## Installation ##

1. Adjust partitions to match fstab.sample

    1. Ensure /home is own partition with nosuid and usrquota enabled
    2. Make /proc hide process ids of other users with hidepid=2

    Refer to: [fstab.sample](https://raw.githubusercontent.com/hashbang/shell-etc/master/fstab.sample)

2. Run setup script

    ```bash
    wget https://raw.githubusercontent.com/hashbang/shell-etc/master/setup.sh
    chown +x setup.sh
    ./setup.sh
    ```

## Notes ##

  Use at your own risk. You may be eaten by a grue.

  Questions/Comments?

  Talk to us via:

  [Email](mailto://team@hashbang.sh) |
  [IRC](irc://irc.hashbang.sh/+6697) |
  [Github](http://github.com/hashbang/)
