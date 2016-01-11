#!/bin/bash

##########
# CONFIG #
##########

ADMIN_USER=$1
ADMIN_PASSWORD=$2

SNAPSHOT_LOCATION=${XP_ROOT}/home/snapshots
BLOBS_LOCATION=${XP_ROOT}/home/repo/blob
#BACKUP_FILE=/tmp/backup.tar.gz
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

if [ -z "$XP_ROOT" ]; then
    _error '$XP_ROOT not set'
    exit 1
fi

if [ ! -f ${XP_ROOT}/toolbox/toolbox.sh ]; then
    _error "$XP_ROOT/toolbox/toolbox.sh does not exist"
    _info $(ls -la $XP_ROOT)
    exit 1
fi

_info "Running $XP_ROOT/toolbox/toolbox.sh snapshot -a ${ADMIN_USER}:${ADMIN_PASSWORD}"
$XP_ROOT/toolbox/toolbox.sh snapshot -a ${ADMIN_USER}:${ADMIN_PASSWORD}


#if [ -f $BACKUP_FILE ]; then
#    _info "Found old version of $BACKUP_FILE - removing"
#    rm $BACKUP_FILE
#fi

if [ ! -d $BACKUP_DIR ]; then
    _info "$BACKUP_DIR does not exist - creating"
    mkdir $BACKUP_DIR
fi

#tar cpfz $BACKUP_FILE $SNAPSHOT_LOCATION $BLOBS_LOCATION &> /dev/null

_info "Copying $SNAPSHOT_LOCATION to $BACKUP_DIR"
cp -pR $SNAPSHOT_LOCATION $BACKUP_DIR &> /dev/null

_info "Copying $BLOBS_LOCATION to $BACKUP_DIR"
cp -pR $BLOBS_LOCATION $BACKUP_DIR &> /dev/null

#if [ -f $BACKUP_FILE ]; then
#    _info "$BACKUP_FILE generated successfully"
#fi
