#!/usr/bin/env bash

# Indclude sources.
. barista/include.sh

# Parse docker-compose.yml for system variables.
eval $(parse_yaml docker-compose.yml)

project=${PWD##*/}

if [ ! -d "docker/nginx" ];
  then
    container_php_name=${project//[-._]/}"_php_apache_1"
  else
    container_php_name=${project//[-._]/}"$project_nginx_1"
fi

container_php_get_port="$(docker port $container_php_name)"
container_php_port="$(cut -d ":" -f 2 <<< $container_php_get_port)"

cat > barista/vars.ini << EOF
projroot="/var/www"
docroot="/var/www/web"
baristaroot="/var/www/barista"
db_host="$(docker ps -aqf 'name=expressophp_db_1')"
db_port="3306"
db_name="$services_db_environment_MYSQL_DATABASE"
db_user="$services_db_environment_MYSQL_USER"
db_pw="$services_db_environment_MYSQL_PASSWORD"
container_php_port="$container_php_port"
site_url="localhost:$container_php_port"
EOF
