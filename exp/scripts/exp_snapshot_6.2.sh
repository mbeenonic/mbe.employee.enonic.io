#!/bin/bash

ADMIN_USER=$1
ADMIN_PASSWORD=$2

function _error {
	echo -e "[ERROR] $1\n"
}

function _info {
	echo "[INFO] $1"
}

if [ -z "$XP_INSTALL" ]; then
    _error '$XP_INSTALL not set'
    exit 1
fi

if [ ! -f ${XP_INSTALL}/toolbox/toolbox.sh ]; then
    _error "$XP_INSTALL/toolbox/toolbox.sh does not exist"
    _info $(ls -la $XP_INSTALL)
    exit 1
fi

_info "$XP_INSTALL/toolbox/toolbox.sh -a ${ADMIN_USER}:${ADMIN_PASSWORD} -r cms-repo"
$XP_INSTALL/toolbox/toolbox.sh -a ${ADMIN_USER}:${ADMIN_PASSWORD} -r cms-repo

_info "$XP_INSTALL/toolbox/toolbox.sh -a ${ADMIN_USER}:${ADMIN_PASSWORD} -r system-repo"
$XP_INSTALL/toolbox/toolbox.sh -a ${ADMIN_USER}:${ADMIN_PASSWORD} -r system-repo
