#!/bin/sh -e
# WARNING: The environment is under the control of the user, to some extend.
#          Read the pam_exec(8) manpage before editing this script.

# root has no network namespace
if [ "$PAM_USER" == root ]; then
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

USER_BR="br0"
if [ -f "/etc/default/user_netns" ]; then
    source /etc/default/user_netns
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

if ! ip netns exec "user-${PAM_USER}" \
     ip link set dev lo up; then
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
if ! ip netns exec "user-${PAM_USER}" \
     ip link set dev "userbr-${PAM_USER}-peer" name "veth"; then
    die "Failed to rename interface for ${PAM_USER}"
fi

if ! ip link set "userbr-${PAM_USER}" master "$USER_BR"; then
    die "Failed to add the veth for ${PAM_USER} to the bridge"
fi

if ! ip netns exec "user-${PAM_USER}" \
     ip link set dev "userbr-${PAM_USER}" name "veth"; then
    die "Failed to rename interface for ${PAM_USER}"
fi

if ! ip netns exec "user-${PAM_USER}" \
     dhclient "veth"; then
    die "Failed to configure IPv4 for ${PAM_USER}"
fi

# TODO: Construct the user's IPv6 from userdb info
if ! ip netns exec "user-${PAM_USER}" \
     ip addr add dev "veth" get_user_ip()/64; then
    die "Failed to configure IPv6 for ${PAM_USER}"
fi

# TODO: Construct the server's own IPv6 from userdb info
if ! ip netns exec "user-${PAM_USER}" \
     ip route add dev "veth" default via get_server_ipv6(); then
    die "Failed to configure IPv6 for ${PAM_USER}"
fi

# We reached the end without error: no cleanup on exit
trap - QUIT
exit 0
