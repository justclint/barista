# Add message styling.
echo_style() {
  case "$1" in
  1)
  echo "$(tput setaf 7) $(tput setab 1) $2 $(tput sgr 0)"
  ;;
  2)
  echo "$(tput setaf 6) $2 $(tput sgr 0)"
  ;;
  esac
}

# Drop all Expresso PHP database tables.
db_drop() {
  mysqldump -u $db_user -p$db_pw -h $db_host --add-drop-table --no-data $db_name | grep ^DROP | mysql -u $db_user -p$db_pw -h $db_host $db_name
}

validate_install_options() {
  if [ -z "$1" ];
  then
    echo "You must supply an install option."
    echo "Current options are:"
    echo "- drupal7"
    echo "- drupal8"
    echo "- magento2"
    echo "- symfony2"
    echo "- symfony3"
    echo "- wordpress4"
    exit 1
  else
    case "$1" in
    drupal7)
    ;;
    drupal8)
    ;;
    magento2)
    ;;
    symfony2)
    ;;
    symfony3)
    ;;
    wordpress4)
    ;;
    *)
    echo_style 2 "The option you supplied is not valid."
    echo_style 2 "Current options are:"
    echo "- drupal7"
    echo "- drupal8"
    echo "- magento2"
    echo "- symfony2"
    echo "- symfony3"
    echo "- wordpress4"
    exit 1
    ;;
    esac
  fi

  env=$1
  shift
}

# Include container vars.
include_container_vars() {
  if [ ! -e "barista/vars.ini" ]
  then
    echo_style 2 "The barista/var.ini file is missing."
    echo_style 2 "From your host in the project directory run $ baritsa/init.sh"
    echo_style 2 "Then try installing your application again."
    exit 1
  else
    . barista/vars.ini
  fi
}

# Parse yaml for bash.
parse_yaml() {
   local prefix=$2
   local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
   sed -ne "s|^\($s\):|\1|" \
        -e "s|^\($s\)\($w\)$s:$s[\"']\(.*\)[\"']$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
   awk -F$fs '{
      indent = length($1)/2;
      vname[indent] = $2;
      for (i in vname) {if (i > indent) {delete vname[i]}}
      if (length($3) > 0) {
         vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
         printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, $2, $3);
      }
   }'
}

# Check if command exists so we can intsall if it doesn't.
cmd_exists() {
  if command -v $1 &>/dev/null
  then
    return 1
  else
    return 0
  fi
}

# Install Composer.
install_composer() {
  echo "Installing composer."
  php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
  php composer-setup.php
  php -r "unlink('composer-setup.php');"
  mv composer.phar /usr/local/bin/composer
  composer
}

# Install Drupal Console.
install_drupal_console() {
  echo "Installing Drupal Console."
  curl https://drupalconsole.com/installer -L -o drupal.phar
  mv drupal.phar /usr/local/bin/drupal
  chmod +x /usr/local/bin/drupal
  drupal
}

# Install Drush.
install_drush() {
  echo "Installing drush."
  php -r "readfile('https://s3.amazonaws.com/files.drush.org/drush.phar');" > drush
  php drush core-status
  chmod +x drush
  mv drush /usr/local/bin
  drush
}

# Install Magerun.
install_magerun() {
  echo "Installing n98-magerun2."
  wget https://files.magerun.net/n98-magerun2.phar
  chmod +x ./n98-magerun2.phar
  mv n98-magerun2.phar /usr/local/bin/magerun
  magerun
}

# Install Symfony Installer.
install_symfony() {
  echo "Installing the Symfony insatller."
  curl -LsS https://symfony.com/installer -o /usr/local/bin/symfony
  chmod a+x /usr/local/bin/symfony
  symfony
}

# Install wp-cli.
install_wp_cli() {
  echo "Installing wp-cli..."
  curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
  chmod +x wp-cli.phar
  mv wp-cli.phar /usr/local/bin/wp
  wp --allow-root
}
