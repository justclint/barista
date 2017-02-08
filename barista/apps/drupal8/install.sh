#!/usr/bin/env bash

#
# Drupal 8
#

# Check/Install Composer.
cmd_exists composer
if [ ! "$?" = 1 ];
then
  install_composer
fi

# Check/Install Drush.
cmd_exists drush
if [ ! "$?" = 1 ];
then
  install_drush
fi

# Check/Install Drupal Console.
cmd_exists drupal
if [ ! "$?" = 1 ];
then
  install_drupal_console
fi

drupalroot=$docroot"/web"

# Install Drupal 8.
echo_style 2 "Installing Drupal 8."
cd $docroot && drupal init -n
cd $docroot && drupal site:new --placeholder="directory:"$docroot -n
cd $docroot && drush sql-drop --db-url='mysql://'$db_user':'$db_pw'@'$db_host'/'$db_name -y
cd $docroot && drupal site:install standard \
  --langcode="en" --db-type="mysql" --db-host=$db_host \
  --db-name=$db_name --db-user=$db_user --db-pass=$db_pw \
  --db-port=$db_port --site-name="Expresso PHP - Drupal 8" --site-mail="admin@example.com" \
  --account-name="admin" --account-mail="admin@example.com" --account-pass="password" \
  --force --no-interaction

# Configuring .htaccess.
echo_style 2 "Configuring .htaccess."
cp $baristaroot/apps/$env/.htaccess.docroot $docroot/.htaccess
sed -i 's|# RewriteBase /drupal|RewriteBase /web|g' $docroot/web/.htaccess

# Clear cache.
echo_style 2 "Claering cache..."
cd $drupalroot && drupal cache:rebuild all

# Create ULI.
echo_style 2 "Your Drupal ULI is: "
cd $drupalroot && drush uli
