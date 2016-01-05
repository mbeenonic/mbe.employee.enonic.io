#!/bin/bash

##########
# CONFIG #
##########

ADMIN_USER=$1
ADMIN_PASSWORD=$2
SNAPSHOT_LOCATION=${XP_INSTALL}/home/data/snapshot
BLOBS_LOCATION=${XP_INSTALL}/home/XXX
BACKUP_FILE=/tmp/backup.tar.gz
BACKUP_DIR=/tmp/backup

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

_info "$XP_INSTALL/toolbox/toolbox.sh snapshot -a ${ADMIN_USER}:${ADMIN_PASSWORD} -r cms-repo"
$XP_INSTALL/toolbox/toolbox.sh snapshot -a ${ADMIN_USER}:${ADMIN_PASSWORD} -r cms-repo

_info "$XP_INSTALL/toolbox/toolbox.sh snapshot -a ${ADMIN_USER}:${ADMIN_PASSWORD} -r system-repo"
$XP_INSTALL/toolbox/toolbox.sh snapshot -a ${ADMIN_USER}:${ADMIN_PASSWORD} -r system-repo

_info $(ls -la ${XP_INSTALL}/home/data/snapshot)

#if [ -f $BACKUP_FILE ]; then
#    _info "Found old version of $BACKUP_FILE - removing"
#    rm $BACKUP_FILE
#fi
#tar cpfz $BACKUP_FILE $SNAPSHOT_LOCATION &> /dev/null

if [ -d $BACKUP_DIR ]; then
    _info "Found old version of $BACKUP_DIR - removing"
    rm -Rf $BACKUP_DIR
fi

_info "Creating backup directory - $BACKUP_DIR"
mkdir /tmp/backup

_info "Copy Elasticsearch indices snapshots: $SNAPSHOT_LOCATION -> $BACKUP_DIR"
cp -pR $SNAPSHOT_LOCATION $BACKUP_DIR

_info "Copy blobs: $BLOBS_LOCATION -> $BACKUP_DIR"
# + copy blobs

#if [ -f $BACKUP_FILE ]; then
#    _info "$BACKUP_FILE generated successfully"
#fi

if [ -f $BACKUP_DIR ]; then
    _info "$BACKUP_DIR generated successfully"
fi
