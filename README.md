# shell-etc #

<http://github.com/hashbang/shell-etc>

## About ##

This is the '/etc' directory of the #! shell servers.
Git management is handled via [etckeeper](http://etckeeper.branchable.com/)

New servers added to the pool will also have this configuration to give users an equal experience.

## Contribution ##

You can "Fork" and "Pull Request" any changes you would like to see on our
servers.

If you would like to have particular package installed in #! shell servers, add it to packages.txt and send a pull request.
While we accept most pull requests, packages that require X11 as dependency will not be merged.

## Requirements ##

  * Debian 7+

## Installation ##

1. Adjust partitions to match fstab.sample

    To do this on a VPS (Super hacky but works):
    
    1. Go to the "Virtual Console" feature in your provider.
    2. Reboot to Grub bootloader screen
    3. Hit <Enter> on first boot option
    4. Add ```break=premount``` to the end of the kernel line
    5. <Ctrl-X> to boot
    6. Copy rootfs files into ram
      ```
      mkdir /mnt
      modprobe ext4
      mount /dev/sda1 /mnt
      cp -R /mnt/* /
      umount /dev/sda1
      ```
    7. Shrink rootfs and creeate /home partition
      ```
      e2fsck -f /dev/sda1
      resize2fs /dev/sda1 20G
      echo "d
      1
      n
      p
      1

      +20G
      w
      n
      p
      2


      " | fdisk /dev/sda1
      ```
    8. Reboot

    9. Adjust fstab to match: [fstab.sample](https://raw.githubusercontent.com/hashbang/shell-etc/master/fstab.sample)

    10. Reboot

2. Run setup script

    ```bash
    ssh $INSTANCE_IP
    wget https://raw.githubusercontent.com/hashbang/shell-etc/master/setup.sh
    bash setup.sh
    ```

## Notes ##

  Use at your own risk. You may be eaten by a grue.

  Questions/Comments?

  Talk to us via:

  [Email](mailto://team@hashbang.sh) |
  [IRC](ircs://irc.hashbang.sh:6697/#!) |
  [Github](http://github.com/hashbang/)
