#!/bin/bash

ADMIN_USER=$2
ADMIN_PASSWORD=$3

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

if [ -f ${XP_INSTALL}/toolbox/toolbox.sh ]; then
    _error "$XP_INSTALL/toolbox/toolbox.sh does not exist"
    exit 1
fi

out=$(ls -la $XP_INSTALL)
_info "$out"

$XP_INSTALL/toolbox/toolbox.sh -a ${ADMIN_USER}:${ADMIN_USER} -r cms-repo
$XP_INSTALL/toolbox/toolbox.sh -a ${ADMIN_USER}:${ADMIN_USER} -r system-repo
