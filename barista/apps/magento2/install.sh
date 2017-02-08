#!/usr/bin/env bash

#
# Magento 2
#

# Check/Install Composer.
cmd_exists composer
if [ ! "$?" = 1 ];
then
  install_composer
fi

# Check/Install Magerun.
cmd_exists magerun
if [ ! "$?" = 1 ];
then
  install_magerun
fi

# Create Composer project.
echo_style 2 "Creating new Composer project for Magento 2."
composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition $docroot
cd $docroot && find . -type d -exec chmod 700 {} \; && find . -type f -exec chmod 600 {} \;

# Install Magento.
echo_style 2 "Installing Magento 2."
cd $docroot && php bin/magento setup:install --cleanup-database \
  --base-url="http://"$site_url \
  --db-host=$db_host \
  --db-name=$db_name \
  --db-user=$db_user \
  --db-password=$db_pw \
  --admin-firstname="admin" \
  --admin-lastname="admin" \
  --admin-email="user@example.com" \
  --admin-user="admin" \
  --admin-password="admin123" \
  --language="en_US" \d
  --currency="USD" \
  --timezone="America/Chicago" \
  --use-rewrites="1" \
  --backend-frontname="admin"

# Clear cache.
cd $docroot && php bin/magento cache:flush
