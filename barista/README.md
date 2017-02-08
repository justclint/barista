# Barisata for Expresso PHP

Express and simple application installer for PHP development.

### Apache + PHP

What's included:

  - Expresso PHP
  -- https://github.com/expresso-php/expresso-php
  -- Currently only supports the Apache branch.
  -- Nginx is currently in development.

  - Barista Installer
  -- Drupal 7
  -- Drupal 8
  -- Magento 2 ( Currently only with PHP 5 )
  ---- Requires keys: http://devdocs.magento.com/guides/v2.0/install-gde/prereq/connect-auth.html
  -- Symfony 2
  -- Symfony 3
  -- Wordpress 4

### PHP 7 or PHP 5?
You can switch between the latest release of PHP 7 or the latest of PHP 5, by
changing the first line of the file "docker/php/Dockerfile".
```
FROM php:5-apache
or
FROM php:7-apache
```

### Get started
Run docker compose & initialze barista.
```
$ docker-compose up -d && barista/init.sh
```
Install your application.
Options:
- drupal7
- drupal8
- magento2
- symfony2
- symfony3
- wordpress4

Method 1 - Install from host.
```
$ docker-compose run --rm php_apache barista/install.sh drupal7
```

Method 2 - Install from container.
Log into container.
```
$ docker-compose exec php_apache /bin/bash
```

From your project root /var/www
```
$ barista/install.sh drupal7
```

All your application files will be installed into /var/www/web.
