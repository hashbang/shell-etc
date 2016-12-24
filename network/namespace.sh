#!/bin/sh -e
# WARNING: The environment is under the control of the user, to some extend.
#          Read the pam_exec(8) manpage before editing this script.

# root has no network namespace
if [ "$PAM_USER" == root ]; then
    exit 0
fi

# System users have no network namespace
# UID ranges defined by the Debian policy manual:
#  https://www.debian.org/doc/debian-policy/ch-opersys.html#s9.2.2
UID=$(getent passwd "$PAM_USER" | cut -d: -f3)
if [ $UID -lt 1000 ] || [ $UID -ge 60000 -a $UID -lt 65536 ]; then
    exit 0
fi

# Check the logger manpage for valid priority levels
function log() {
    logger --id=$$ --priority auth."$1" "$2"
}

function die() {
    log crit "$@"
    exit 1
}

# Construct the user's IPv6, as {server_prefix}::{uid}
function get_user_ipv6() {
    HEX_UID=$(echo "obase=16; ${UID}" | bc)
    IPV6_SUFFIX=$(echo "$HEX_UID" | rev | fold -w4 | paste -sd: | rev)
    return "${IPV6_PREFIX}::${IPV6_SUFFIX}"
}

# Execute some command in the user's netns
function in_ns() {
    return ip netns exec "user-${PAM_USER}" $@
}

# SYNOPSIS: This script constructs and configures a user namespace
#           for the user currently logging in.
#
# The namespace contains the following interfaces:
# - lo, the loopback interface
# - veth, a virtual Ethernet interface which is tied to a bridge.
#   veth is configured with a dynamic, RFC1918 IPv4 address,
#     and with a static IPv6 address.
#
# Moreover, veth's peer is userbr-${PAM_USER},
#  and is attached to the br0 bridge
#  (configurable as USER_BR in /etc/default/user_netns)

USER_BR="br-users"
if [ -f "/etc/default/user_netns" ]; then
    source /etc/default/user_netns
fi

if [ -z "${IPV6_PREFIX}" ]; then
    die "No IPv6 prefix defined in configuration"
fi

# If the user's netns exists, nothing to do
if [ -f "/var/run/netns/user-${PAM_USER}" ]; then
    log info "User ${PAM_USER} already has a netns"
    exit 0
fi


# Prepare the user's netns
trap 'ip netns delete "user-${PAM_USER}"' QUIT

if ! ip netns add "user-${PAM_USER}"; then
    die "Failed to create netns for ${PAM_USER}"
fi

if ! in_ns ip link set dev lo up; then
    die "Failed to create a loopback interface for ${PAM_USER}"
fi

# TODO: check that deleting the namespace causes the veth pair to be deleted
if ! ip link add "userbr-${PAM_USER}" type veth peer name "userbr-${PAM_USER}-peer"; then
    die "Failed to create a veth pair for ${PAM_USER}"
fi

if ! ip link set "userbr-${PAM_USER}-peer" netns "user-${PAM_USER}"; then
    ip link delete dev "userbr-${PAM_USER}"
    die "Failed to add the veth peer to netns for ${PAM_USER}"
fi

# Renaming the interface should happen before any configuration occurs
if ! in_ns ip link set dev "userbr-${PAM_USER}-peer" name "veth"; then
    die "Failed to rename interface for ${PAM_USER}"
fi

if ! ip link set "userbr-${PAM_USER}" master "$USER_BR"; then
    die "Failed to add the veth for ${PAM_USER} to the bridge"
fi

if ! in_ns dhclient "veth"; then
    die "Failed to configure IPv4 for ${PAM_USER}"
fi

if ! in_ns ip addr add dev "veth" "get_user_ip()/64"; then
    die "Failed to configure IPv6 for ${PAM_USER}"
fi

# We reached the end without error: no cleanup on exit
trap - QUIT
exit 0
