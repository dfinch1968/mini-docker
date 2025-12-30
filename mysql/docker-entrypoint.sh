#!/usr/bin/env bash
set -e

MYSQL_DATADIR=${MYSQL_DATADIR:-/var/lib/mysql}
MYSQL_LOGDIR=${MYSQL_LOGDIR:-/var/log/mysql}

# Ensure directories exist and permissions are correct
mkdir -p "${MYSQL_DATADIR}" "${MYSQL_LOGDIR}"
chown -R mysql:mysql "${MYSQL_DATADIR}" "${MYSQL_LOGDIR}"

# Initialize database if empty
if [ ! -d "${MYSQL_DATADIR}/mysql" ]; then
  echo "Initializing MariaDB data directory..."
  mysql_install_db --user=mysql --datadir="${MYSQL_DATADIR}" --rpm
fi

# Start cron (for logrotate)
echo "Starting cron service..."
crond

# Start MariaDB in foreground
echo "Starting MariaDB..."
exec mysqld --datadir="${MYSQL_DATADIR}" --user=mysql