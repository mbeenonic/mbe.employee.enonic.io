#!/bin/bash

ADMIN_USER=$2
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

if [ -f $XP_INSTALL/toolbox/toolbox.sh ]; then
    _error '$XP_INSTALL/toolbox/toolbox.sh does not exist'
fi

_info "Creating new snapshot for XP version $XP_VERSION"
if [ "$XP_VERSION" == '6.3' ]; then
    /bin/bash $XP_INSTALL/toolbox/toolbox.sh -a ${ADMIN_USER}:${ADMIN_USER}
elif [ "$XP_VERSION" == '6.2' ]; then
    /bin/bash $XP_INSTALL/toolbox/toolbox.sh -a ${ADMIN_USER}:${ADMIN_USER} -r cms-repo
    /bin/bash $XP_INSTALL/toolbox/toolbox.sh -a ${ADMIN_USER}:${ADMIN_USER} -r system-repo
fi