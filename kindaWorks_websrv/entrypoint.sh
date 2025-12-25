#!/bin/bash
set -e

# Default server name (can be overridden by env var SERVER_NAME)
SERVER_NAME="${SERVER_NAME:-example.local}"
DOC_ROOT="/var/www/html"
LOG_DIR="${DOC_ROOT}/logs"
SSL_KEY="/etc/ssl/private/server.key"
SSL_CRT="/etc/ssl/private/server.crt"

# Ensure doc root exists (PV should be mounted here)
mkdir -p "${DOC_ROOT}"
mkdir -p "${LOG_DIR}"
chown -R www-data:www-data "${DOC_ROOT}"
chmod -R 755 "${DOC_ROOT}"

# Ensure SSL directory exists
mkdir -p /etc/ssl/private
chmod 700 /etc/ssl/private

# Generate 4096-bit self-signed cert if not present
if [ ! -f "${SSL_KEY}" ] || [ ! -f "${SSL_CRT}" ]; then
  echo "Generating 4096-bit self-signed certificate for ${SERVER_NAME}..."
  openssl req -x509 -nodes -days 3650 \
    -newkey rsa:4096 \
    -keyout "${SSL_KEY}" \
    -out "${SSL_CRT}" \
    -subj "/C=US/ST=Florida/L=Lehigh/O=devOps/OU=ops/CN=${SERVER_NAME}"
  chmod 600 "${SSL_KEY}"
fi

# Replace ServerName in configs (simple sed)
sed -i "s/ServerName .*/ServerName ${SERVER_NAME}/g" /etc/apache2/sites-available/000-default.conf || true
sed -i "s/ServerName .*/ServerName ${SERVER_NAME}/g" /etc/apache2/sites-available/default-ssl.conf || true

# Enable SSL site and default site (default-ssl.conf is already present)
a2ensite default-ssl.conf || true
a2enmod ssl || true

# Ensure logs exist and are writable
touch "${LOG_DIR}/access.log" "${LOG_DIR}/error.log" "${LOG_DIR}/ssl_access.log" "${LOG_DIR}/ssl_error.log" || true
chown -R www-data:www-data "${LOG_DIR}"
chmod 644 "${LOG_DIR}"/* || true

# Print quick diagnostics (available inside container logs)
echo "=== Container startup info ==="
echo "ServerName: ${SERVER_NAME}"
echo "DocumentRoot: ${DOC_ROOT}"
echo "Logs: ${LOG_DIR}"
echo "SSL cert: ${SSL_CRT}"
echo "SSL key: ${SSL_KEY}"
echo "Available utilities: ping, netstat"
echo "=============================="

# If the user passed a command, run it; otherwise start apache in foreground
if [ "$#" -gt 0 ]; then
  exec "$@"
else
  exec apache2ctl -D FOREGROUND
fi