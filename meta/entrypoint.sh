#!/bin/sh

# Wait for MariaDB port to be open
echo "Info: Waiting for database connection..."
while ! nc -z db 3306; do sleep 1; done;

if [ "${PHP_ENV}" != "production" ] && [ -f application/config/config.php ]; then
  echo "Info: Generating a phpinfo file for non-production environment (PHP_ENV=${PHP_ENV})"
  echo "<?php phpinfo();" > ./phpinfo.php
fi

# Disable exiting when any command fails
set +e

{
  # Update database structure to the last LimeSurvey version
  echo "Info: Updating database..."
  php application/commands/console.php updatedb
} || {
  # Or install if the update failed
  echo "Info: Installing database..."
  php application/commands/console.php install \
    "${LIMESURVEY_ADMIN_USERNAME}" "${LIMESURVEY_ADMIN_PASSWORD}" "${LIMESURVEY_ADMIN_NAME}" "${LIMESURVEY_ADMIN_EMAIL}"
}

exec "$@"
