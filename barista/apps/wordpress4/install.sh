#!/usr/bin/env bash

#
# Wordpress 4
#

# Check if wp-cli is not installed
cmd_exists wp
if [ ! "$?" = 1 ];
then
  install_wp_cli
fi

# Download WordPress.
echo_style 2 "Downloading Wordpress."
cd $docroot && wp core download --allow-root

# Setup wp-config.
echo_style 2 "Setting up wp-config."
cd $docroot && wp core config --allow-root --dbhost=$db_host --dbname=$db_name --dbuser=$db_user --dbpass=$db_pw

# Clearing database.
echo_style 2 "Clearing database."
cd $docroot && wp db reset --allow-root --yes

# Install Wordrpess.
echo_style 2 "Installing WordPress."
cd $docroot && wp core install --allow-root --url=$site_url --title="Expresso PHP - Wordpress 4" --admin_user=admin --admin_password=password --admin_email=info@example.com --skip-email

# Clear cache.
echo_style 2 "Clearing cache."
cd $docroot && wp cache flush --allow-root
