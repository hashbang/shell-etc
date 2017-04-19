#!/bin/sh -e
USER="${PAM_USER}"
UID=$(id -u "$USER")
XDG_RUNTIME_DIR="/run/user/${UID}"
NGINX_SOCK_DIR="/run/http"

for proto in http https; do
    SOCKET_LINK="${NGINX_SOCK_DIR}/${USER}-${proto}.sock"
    [ -L "${SOCKET_LINK}" ] || \
	ln -s "${XDG_RUNTIME_DIR}/${proto}.sock" "${SOCKET_LINK}"
done
