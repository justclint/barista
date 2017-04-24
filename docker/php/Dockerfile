FROM php:7-apache

# RUN apt-get update --fix-missing -qq \
#   && apt-get upgrade -f -y \
RUN apt-get update -qq && apt-get install mysql-client nano openssl wget -yq

RUN a2enmod rewrite

ADD vhost.conf /etc/apache2/sites-available/000-default.conf

RUN a2ensite 000-default

# Install the PHP extensions we need.
RUN apt-get update && apt-get install -y libcurl4-openssl-dev libicu-dev libmcrypt-dev libpng12-dev libjpeg-dev libpq-dev libxml2-dev libxslt-dev

# Installs for specific PHP versions.
RUN PHP_MAJOR_VERSION=$( echo "${PHP_VERSION}" | cut -f1 -d "." ) && \
  if [ ${PHP_MAJOR_VERSION} = "5" ]; \
    then \
      apt-get update && apt-get install php5-intl imagemagick php5-imagick  -yq; \
    elif [ ${PHP_MAJOR_VERSION} = "7" ]; \
    then \
      apt-get update && apt-get install pkg-config libmagickwand-dev -yq; \
  fi

# Configure PHP extensions.
RUN rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
    && docker-php-ext-install gd json hash iconv intl mbstring mcrypt mysqli opcache pcntl pdo pdo_mysql pdo_pgsql simplexml soap xml xsl zip

# Set recommended PHP.ini settings.
# See https://secure.php.net/manual/en/opcache.installation.php
RUN { \
        echo 'opcache.memory_consumption=128'; \
        echo 'opcache.interned_strings_buffer=8'; \
        echo 'opcache.max_accelerated_files=4000'; \
        echo 'opcache.revalidate_freq=0'; \
        echo 'opcache.fast_shutdown=1'; \
        echo 'opcache.enable_cli=1'; \
        echo 'memory_limit = -1'; \
        echo 'max_execution_time = -1'; \
        echo 'date.timezone = America/Los_Angeles'; \
        echo 'log_errors = On'; \
        echo 'error_reporting = E_ALL'; \
        echo 'error_log = /var/www/logs/error.log'; \
    } > /usr/local/etc/php/conf.d/opcache-recommended.ini

WORKDIR /var/www
