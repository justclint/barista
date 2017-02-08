#!/usr/bin/env bash

#
# Drupal 7
#

# Check/Install Drush.
cmd_exists drush
if [ ! "$?" = 1 ];
then
  install_drush
fi

# Download Drupal 7.
echo_style 2 "Downloading Drupal 7."
drush dl drupal-7.x -d --destination=$projroot --drupal-project-rename="web" -y

# Drop all tables from database.
cd $docroot && drush sql-drop --db-url='mysql://'$db_user':'$db_pw'@'$db_host'/'$db_name -y

# Install Drupal 7
echo_style 2 "Installing Drupal 7."
cd $docroot && drush site-install standard \
  --db-url='mysql://'$db_user':'$db_pw'@'$db_host'/'$db_name \
  --site-name="Expresso PHP - Drupal 7" \
  --account-name=admin --account-pass=password \
  --account-mail=email@email.com -y

# Clear cache.
cd $docroot && drush cc all

# Create ULI.
echo_style 2 "Your Drupal ULI:"
cd $docroot && drush uli
