#On choisit une debian
FROM debian:12

LABEL org.opencontainers.image.authors="matthew.sponaugle@artech.com"


#Ne pas poser de question à l'installation
ENV DEBIAN_FRONTEND noninteractive

#Installation d'apache et de php8.1 avec extension
RUN apt update \
&& apt install --yes --no-install-recommends ca-certificates \
&& apt update \
&& apt install --yes --no-install-recommends \
apache2 \
git \
php8.2 \
php8.2-mysql \
php8.2-ldap \
php8.2-xmlrpc \
php8.2-imap \
php8.2-curl \
php8.2-gd \
php8.2-mbstring \
php8.2-xml \
php-cas \
php8.2-intl \
php8.2-zip \
php8.2-bz2 \
php8.2-redis \
cron \
jq \
libldap-2.5-0 \
libldap-common \
libsasl2-2 \
libsasl2-modules \
libsasl2-modules-db \
curl \
wget

RUN cd /root/ \
&& curl -L -s -o glpi.tgz https://github.com/glpi-project/glpi/releases/download/10.0.12/glpi-10.0.12.tgz \
&& tar -xzf glpi.tgz -C /var/www/ \
&& rm glpi.tgz \
&& rm /etc/apache2/sites-enabled/*.conf \
&& a2enmod rewrite

COPY glpi_apache.conf /etc/apache2/sites-available/glpi.conf

RUN ln -s /etc/apache2/sites-available/glpi.conf /etc/apache2/sites-enabled \
&& sed -i 's,session.cookie_httponly =,session.cookie_httponly = on,g' /etc/php/8.2/apache2/php.ini \
&& chown www-data:www-data /var/www/glpi -R

COPY runapache.sh /opt/runapache.sh
RUN chmod +x /opt/runapache.sh

ENTRYPOINT [ "/opt/runapache.sh" ]

#Exposition des ports
EXPOSE 80 443
