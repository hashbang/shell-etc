#! /bin/sh
### BEGIN INIT INFO
# Provides:		kexec-load
# Required-Start:	$local_fs $remote_fs kexec
# Required-Stop:	$local_fs $remote_fs kexec
# Should-Stop:		autofs
# Default-Start:	2 3 4 5
# Default-Stop:		6
# Short-Description: Load kernel image with kexec
# Description:
### END INIT INFO

PATH=/sbin:/bin:/usr/sbin:/usr/bin
NOKEXECFILE=/tmp/no-kexec-reboot

. /lib/lsb/init-functions

test -r /etc/default/kexec && . /etc/default/kexec

process_grub_entry() {
	initrd_image=
	while read command args; do
		if [ "$command" = "linux" ]; then
			echo "$args" | while read kernel append; do
			echo KERNEL_IMAGE=\"${prefix}${kernel}\"
			echo APPEND=\"${append}\"
			done
		elif [ "$command" = "initrd" ]; then
			initrd_image=${prefix}${args}
		fi
	done
	echo INITRD=\"$initrd_image\"
}

get_grub_kernel() {
	test -f /boot/grub/grub.cfg || return
	local prefix
	mountpoint -q /boot && prefix=/boot || prefix=
	data=$(cat /boot/grub/grub.cfg)

	default=$(echo "$data" | awk '/^set default/ {print $2}' | cut -d'"' -f2)
	if [ "$default" = '${saved_entry}' ]; then 
		default=$(sed -ne 's/^saved_entry=//p' /boot/grub/grubenv)
	fi
	if [ -z "$default" ]; then
		default=0
	fi
	start_offset=$((default + 1))
	end_offset=$((default + 2))

	# grub entries start with "menuentry" commands.  Get the line 
	# numbers that surround the first entry
	offsets=$(echo "$data" | grep -n '^[[:space:]]*menuentry[[:space:]]' | cut -d: -f1)
	begin=$(echo "$offsets" | tail -n+$start_offset | head -n1)
	end=$(echo "$offsets" | tail -n+$end_offset | head -n1)

	# If this is the last entry, we need to read to the end of the file
	# or to the end of boot entry section
	if [ -z "$end" ]; then
		numlines=$(echo "$data" | tail --lines=+$begin | grep -n "^### END" | head -1 | cut -d: -f1)
		end=$((begin + numlines - 1))
	fi

	length=$((end - begin))
	entry=$(echo "$data" | tail -n+$begin | head -n$length)
	eval $(echo "$entry" | process_grub_entry)
}

do_stop () {
	test "$LOAD_KEXEC" = "true" || exit 0
	test -x /sbin/kexec || exit 0
	test "x`cat /sys/kernel/kexec_loaded`y" = "x1y" && exit 0

	if [ -f $NOKEXECFILE ]
	then
		/bin/rm -f $NOKEXECFILE
		exit 0
	fi

	test "$USE_GRUB_CONFIG" = "true" && get_grub_kernel

	REAL_APPEND="$APPEND"

	test -z "$REAL_APPEND" && REAL_APPEND="`cat /proc/cmdline`"
	log_action_begin_msg "Loading new kernel image into memory"
	if [ -z "$INITRD" ]
	then
		/sbin/kexec -l "$KERNEL_IMAGE" --append="$REAL_APPEND"
	else
		/sbin/kexec -l "$KERNEL_IMAGE" --initrd="$INITRD" --append="$REAL_APPEND"
	fi
	log_action_end_msg $?
}

case "$1" in
  start)
	# No-op
	;;
  restart|reload|force-reload)
	echo "Error: argument '$1' not supported" >&2
	exit 3
	;;
  stop)
	# If running systemd, we want kexec reboot only if current
	# command is reboot
	if [ -d /run/systemd/system ]; then
		systemctl list-jobs systemd-reboot.service | grep -q systemd-reboot.service
		if [ $? -ne 0 ]; then
			exit 0
		fi
	fi
	do_stop
	;;
  *)
	echo "Usage: $0 start|stop" >&2
	exit 3
	;;
esac
exit 0
