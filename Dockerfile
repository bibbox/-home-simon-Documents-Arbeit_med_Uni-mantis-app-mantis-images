# mantisDB container
# 
# VERSION 1.0
#

FROM php:7.2-apache
MAINTAINER Heimo Müller <heimo.mueller@mac.com>

ENV MANTIS_VERSION=2.25.0
ENV MANTIS_MD5=a3e4b5c4f91b5d04c37122650cb1189d
ENV MANTIS_URL=https://sourceforge.net/projects/mantisbt/files/mantis-stable/${MANTIS_VERSION}/mantisbt-${MANTIS_VERSION}.tar.gz
ENV MANTIS_FILE=mantisbt.tar.gz
ENV MANTIS_TIMEZONE Europe/Vienna

RUN a2enmod rewrite

RUN set -xe \
    && apt-get update \
    && apt-get install -y libpng-dev libjpeg-dev libpq-dev libxml2-dev \
    && docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
    && docker-php-ext-install gd mbstring mysql mysqli pgsql soap \
    && rm -rf /var/lib/apt/lists/*

RUN set -xe \
    && curl --insecure -fSL ${MANTIS_URL} -o ${MANTIS_FILE} \
    && echo "${MANTIS_SHA1}  ${MANTIS_FILE}" | sha1sum -c \
    && tar -xz --strip-components=1 -f ${MANTIS_FILE} \
    && rm ${MANTIS_FILE} \
    && chown -R www-data:www-data .

RUN set -xe \
    && ln -sf /usr/share/zoneinfo/${MANTIS_TIMEZONE} /etc/localtime \
    && echo 'date.timezone = "${MANTIS_TIMEZONE}"' > /usr/local/etc/php/php.ini

