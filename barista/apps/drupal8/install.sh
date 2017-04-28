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

# Install Drupal 8.
echo_style 2 "Installing Drupal 8."
cd $projroot && drush dl drupal-8 --drupal-project-rename=web -y
cd $webroot && drush sql-drop --db-url='mysql://'$db_user':'$db_pw'@'$db_host'/'$db_name -y
cd $webroot && drush si standard \
  --db-url='mysql://'$db_user':'$db_pw'@'$db_host'/'$db_name -y \
  --site-name=ExpressoPHP --locale=en \
  --account-pass=admin --account-mail=admin@example.com \

# Install Drupal Console.
cd $webroot && composer require drupal/console:~1.0

# Clear cache.
echo_style 2 "Claering cache..."
cd $webroot && drush cr all

# Create ULI.
echo_style 2 "Your Drupal ULI is: "
cd $webroot && drush uli
