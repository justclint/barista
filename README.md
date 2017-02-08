# Expresso PHP

Express and simple docker setup for all your PHP development.

### Apache + PHP

What's included:

  - Apache
  - PHP
  - Mariadb
  - PhpMyAdmin

Check the other branches of this repo for some more options.

### Official containers only
All of this is based on officials containers, so you won't download any
specific containers to use this project.

### PHP 7 or PHP 5?
You can switch between the latest release of PHP 7 or the latest of PHP 5, by
changing the first line of the file "docker/php/Dockerfile".
```
FROM php:5-apache
```

### Get started
All your Drupal files should be placed into the folder "web".

Run docker compose.
```
$ docker-compose up -d
```

Place your PHP files in the folder called web.

That's it!

### Drush (command line tool for Drupal)

Run drush
```
$  docker-compose run --rm php drush help
```

### Database credentials
This is for development !!

* User: phpexpresso
* Password: phpexpresso
* Database: phpexpresso

### MySQL and PhpMyAdmin credentials
The port of PhpMyAdmin is 8181, access PhpMyAdmin by going to http://localhost:8181.
* Username: root
* Password: root
