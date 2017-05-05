FROM php:5.6-apache

ENV YOURLS_VERSION 1.7.2
ENV YOURLS_PACKAGE https://github.com/YOURLS/YOURLS/archive/${YOURLS_VERSION}.tar.gz

RUN docker-php-ext-install pdo_mysql mysqli mbstring                       && \
    a2enmod rewrite ssl

RUN mkdir -p /opt/yourls                                                   && \
    curl -sSL ${YOURLS_PACKAGE} -o /tmp/yourls.tar.gz                      && \
    tar xf /tmp/yourls.tar.gz --strip-components=1 --directory=/opt/yourls

RUN sed -i -e '/ServerTokens/s/^.*$/ServerTokens Prod/g'                      \
           -e '/ServerSignature/s/^.*$/ServerSignature Off/g'                 \
        /etc/apache2/conf-available/security.conf

RUN apt-get update                                                         && \
    apt-get install --no-install-recommends -y git-core                    && \
    apt-get clean

ADD conf/ /

WORKDIR /opt/yourls
