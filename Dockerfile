FROM php:8-apache

# External arguments
ARG LIVESURVEY_CHECKSUM
ARG LIVESURVEY_VERSION

# Internal arguments
ARG PORT=80
ARG USER=www-data

# Environment variables
ENV LIMESURVEY_VERSION=$LIVESURVEY_VERSION

EXPOSE $PORT

# Exit when any command fails and print commands as they are executed
RUN set -ex;

# Install OS dependencies
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive \
  apt-get install --no-install-recommends -y \
  curl \
  libc-client-dev \
  libfreetype6-dev \
  libjpeg-dev \
  libkrb5-dev \
  libldap2-dev \
  libonig-dev \
  libpng-dev \
  libpq-dev \
  libsodium-dev \
  libtidy-dev \
  libzip-dev \
  netcat \
  # sendmail \
  zlib1g-dev
RUN apt-get -y autoclean && apt-get -y autoremove && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN ln -fs /usr/lib/x86_64-linux-gnu/libldap.so /usr/lib/
RUN docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl
RUN docker-php-ext-install -j5 \
  exif \
  gd \
  imap \
  ldap \
  mbstring \
  pdo \
  pdo_mysql \
  pdo_pgsql \
  pgsql \
  sodium \
  tidy \
  zip

# Setup Apache
RUN a2enmod headers rewrite remoteip; \
  {\
    echo RemoteIPHeader X-Real-IP ;\
    echo RemoteIPTrustedProxy 10.0.0.0/8 ;\
    echo RemoteIPTrustedProxy 172.16.0.0/12 ;\
    echo RemoteIPTrustedProxy 192.168.0.0/16 ;\
  } > /etc/apache2/conf-available/remoteip.conf;
RUN a2enconf remoteip

# Use default Apache production configuration
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Download, unzip and chmod LimeSurvey from official GitHub repository
RUN curl \
  -sSL "https://github.com/LimeSurvey/LimeSurvey/archive/${LIVESURVEY_VERSION}.tar.gz" \
  --output /tmp/limesurvey.tar.gz
RUN echo "${LIVESURVEY_CHECKSUM} /tmp/limesurvey.tar.gz" | sha256sum -c -
RUN tar xzvf "/tmp/limesurvey.tar.gz" --strip-components=1 -C .
RUN rm -f "/tmp/limesurvey.tar.gz"
RUN chown -R "$USER:$USER" . /etc/apache2

COPY ./meta/config.php /var/www/html/application/config
COPY ./meta/entrypoint.sh entrypoint.sh

COPY ./meta/vhosts-access-log.conf /etc/apache2/conf-enabled/other-vhosts-access-log.conf

USER $USER

ENTRYPOINT ["/var/www/html/entrypoint.sh"]

CMD ["apache2-foreground"]
