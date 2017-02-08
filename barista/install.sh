#!/usr/bin/env bash

# Indcludes.
. barista/include.sh

# Include container vars.
include_container_vars

# Validate user's install option.
validate_install_options $1

echo_style 1 "Starting setup for ${env}"

#
# Processes before applicaion install.
#

# Clear docroot.
if [ -d "$docroot" ];
then
    echo_style 2 "Clearing docroot..."
    ( chmod -R u+rwx $docroot)
    ( rm -rf web && mkdir web )
fi

# Install application.
. $baristaroot/apps/$env/install.sh

#
# Processes after application install.
#

# Create phpinfo file.
cat > $docroot/phpinfo.php << EOF
<?php phpinfo(); ?>
EOF

#
# Finish.
#
echo_style 1 "You've successfully setup ${env}."
echo_style 2 "You can now visit your site at $site_url"
