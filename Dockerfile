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

#Copie et execution du script pour l'installation et l'initialisation de GLPI
COPY init-glpi.sh /opt/
RUN chmod +x /opt/init-glpi.sh
ENTRYPOINT ["/opt/init-glpi.sh"]

#Exposition des ports
EXPOSE 80 443
