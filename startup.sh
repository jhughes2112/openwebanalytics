#!/bin/sh

echo "Got here"

set -e

# copy the OWA install folder to the html folder if missing.  Helps with new setups.
if [ -e /var/www/html/owa.php ]; then
	echo "[ INFO ] OWA already exists"
else
	echo "[ INFO ] OWA is missing.  Copying into web folder."
	cp -R /var/www/owa/* /var/www/html/
fi

/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf