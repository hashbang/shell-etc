#!/bin/sh -e
USER="${PAM_USER}"
UID=$(id -u "$USER")
XDG_RUNTIME_DIR="/run/user/${UID}"
NGINX_SOCK_DIR="/run/http"

# Only proceed for human users: UID ranges 1000-60000 and 655536-4294967294
([ "$UID" -ge 1000 ] && [ "$UID" -lt 60000 ])          || \
    ([ "$UID" -ge 65536 ] && [ "$UID" -lt 4294967294 ]) || \
    exit 0

for proto in http https; do
    SOCKET_LINK="${NGINX_SOCK_DIR}/${USER}-${proto}.sock"
    [ -L "${SOCKET_LINK}" ] || \
	ln -s "${XDG_RUNTIME_DIR}/${proto}.sock" "${SOCKET_LINK}"
done
