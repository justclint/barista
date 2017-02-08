#!/usr/bin/env bash

#
# Symfony 2
#

# Check/Install Symfony Installer.
cmd_exists symfony
if [ ! "$?" = 1 ];
then
  install_symfony
fi

# Drop any existing tables.
db_drop

# Create new Symfony project.
cd $projroot && symfony new web latest

# Create Symfony parameters.yml for Expresso PHP.
echo_style 2 "Creating parameters.yml for Symfony."
cat > $docroot/app/config/parameters.yml << EOF
# This file is auto-generated during the composer install
parameters:
    database_host: $db_host
    database_port: $db_port
    database_name: $db_name
    database_user: $db_user
    database_password: $db_pw
    mailer_transport: smtp
    mailer_host: $db_host
    mailer_user: example@example.com
    mailer_password: example
    secret: ThisIsSymfonyRunningOnExpressoPHPWithBarista
EOF

# Configuring .htaccess.
cp $baristaroot/apps/$env/.htaccess.docroot $docroot/.htaccess

# Clear cache.
cd $docroot && php bin/console cache:clear
