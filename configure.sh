#!/bin/bash


echo "###############################################################################"
echo "### Enonic XP configurator"
INSTANCE_HOSTNAME=$1

if [[ "x$1" = "x" ]]
	then
	echo "hostname argument is missing, aborting."
	exit 1
fi

APACHE2_VHOST_TEMPLATE=apache2/sites/vhost.example.conf.template
EXP_VHOST_FILE=exp/config/com.enonic.xp.web.vhost.cfg


echo "###############################################################################"
echo "Creating apache2 config for $INSTANCE_HOSTNAME"

cp $APACHE2_VHOST_TEMPLATE apache2/sites/$INSTANCE_HOSTNAME.conf
sed -i -e "s/SITE_HOSTNAME_ESCAPED/$(echo $INSTANCE_HOSTNAME | sed 's/\./\\\\./g')/g" apache2/sites/$INSTANCE_HOSTNAME.conf
sed -i -e "s/SITE_HOSTNAME/$INSTANCE_HOSTNAME/g" apache2/sites/$INSTANCE_HOSTNAME.conf


echo "Adding $INSTANCE_HOSTNAME to Enonic XP vhosts"

sed -i -e "s/SITE_HOSTNAME/$INSTANCE_HOSTNAME/g" $EXP_VHOST_FILE

#rm apache2/sites/$INSTANCE_HOSTNAME.conf.tmp
