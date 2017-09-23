#!/bin/sh -e

PAM_UID=$(getent passwd "${PAM_USER}" | cut -d: -f3)

if [ "${PAM_UID}" -ge 1000 ]; then
    /bin/systemctl set-property "user-${PAM_UID}.slice" \
                   CPUQuota=50% MemoryLimit=512M BlockIOWeight=10
fi
