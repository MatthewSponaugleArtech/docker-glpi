#!/bin/bash
echo "############################################################"
echo "GLPI Web bootstrap script starting..."
echo "############################################################"
echo "."
#VARIABLES and stuff
#REPO="https://github.com/glpi-project/glpi.git"
TAG="10.0.12"
DL="https://github.com/glpi-project/glpi/releases/download/${TAG}/glpi-${TAG}.tgz"
#disable history subsitution
set +H
cd /root/

#download glpi
wget -O glpi.tgz ${DL}
#extract glpi
tar -xzf glpi.tgz -C /var/www/ 
#delete tar
rm glpi.tgz

echo "Configuring apache"
#Delete default site
rm /etc/apache2/sites-enabled/*.conf
#Enable Rewrite
a2enmod rewrite
#configure site
echo "<VirtualHost *:80>" >> /etc/apache2/sites-available/glpi.conf
#echo "    ServerName ${host}.${domain}.${tld}" >> /etc/apache2/sites-available/glpi.conf
echo "    DocumentRoot /var/www/glpi/public" >> /etc/apache2/sites-available/glpi.conf
echo "    <Directory /var/www/glpi/public>" >> /etc/apache2/sites-available/glpi.conf
echo "        Require all granted" >> /etc/apache2/sites-available/glpi.conf
echo "        RewriteEngine On" >> /etc/apache2/sites-available/glpi.conf
echo "        # Redirect all requests to GLPI router, unless file exists." >> /etc/apache2/sites-available/glpi.conf
echo "        RewriteCond %%{REQUEST_FILENAME} !-f" >> /etc/apache2/sites-available/glpi.conf
echo "        RewriteRule ^(.*)$ index.php [QSA,L]" >> /etc/apache2/sites-available/glpi.conf
echo "    </Directory>" >> /etc/apache2/sites-available/glpi.conf
echo "</VirtualHost>" >> /etc/apache2/sites-available/glpi.conf
#symlink site file
ln -s /etc/apache2/sites-available/glpi.conf /etc/apache2/sites-enabled
#set timezone
if [[ -z "${TIMEZONE}" ]]; then echo "TIMEZONE is unset"; 
else 
echo "date.timezone = \"$TIMEZONE\"" > /etc/php/8.2/apache2/conf.d/timezone.ini;
echo "date.timezone = \"$TIMEZONE\"" > /etc/php/8.2/cli/conf.d/timezone.ini;
fi
#Enable session.cookie_httponly
sed -i 's,session.cookie_httponly =,session.cookie_httponly = on,g' /etc/php/8.2/apache2/php.ini
#own the webroot
chown www-data:www-data /var/www/glpi -R
#Kill apache
pkill -9 apache

echo "#######################################################"
echo "GLPI Web bootstrap script done."
echo "#######################################################"

#run it in the foreground
/usr/sbin/apache2ctl -D FOREGROUND