#!/bin/bash

##########
# CONFIG #
##########

ADMIN_USER=$1
ADMIN_PASSWORD=$2
SNAPSHOT_LOCATION=${XP_INSTALL}/home/snapshots
BACKUP_FILE=/tmp/backup.tar.gz

#############
# FUNCTIONS #
#############

function _error {
	echo -e "[ERROR] $1\n"
}

function _info {
	echo "$1"
}

########
# MAIN #
########

if [ -z "$XP_INSTALL" ]; then
    _error '$XP_INSTALL not set'
    exit 1
fi

if [ ! -f ${XP_INSTALL}/toolbox/toolbox.sh ]; then
    _error "$XP_INSTALL/toolbox/toolbox.sh does not exist"
    _info $(ls -la $XP_INSTALL)
    exit 1
fi

_info "$XP_INSTALL/toolbox/toolbox.sh snapshot -a ${ADMIN_USER}:${ADMIN_PASSWORD}"
$XP_INSTALL/toolbox/toolbox.sh snapshot -a ${ADMIN_USER}:${ADMIN_PASSWORD}

_info $(ls -la ${XP_INSTALL}/home/snapshots)

if [ -f $BACKUP_FILE ]; then
    _info "Found old version of $BACKUP_FILE - removing"
    rm $BACKUP_FILE
fi

tar cpfz $BACKUP_FILE $SNAPSHOT_LOCATION &> /dev/null

if [ -f $BACKUP_FILE ]; then
    _info "$BACKUP_FILE generated successfully"
    _info $(ls -la /tmp)
fi
