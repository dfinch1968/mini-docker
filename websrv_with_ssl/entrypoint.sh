#!/bin/bash
set -e

PV_ROOT=${PV_ROOT:-/pv}
SSL_DIR=${SSL_DIR:-/pv/ssl}
WWW_DIR=${WWW_DIR:-/pv/xxwww}
LOG_DIR=${APACHE_LOG_DIR:-/pv/logs}
CA_KEY=${SSL_DIR}/ca.key.pem
CA_CERT=${SSL_DIR}/ca.crt
SERVER_KEY=${SSL_DIR}/server.key
SERVER_CSR=${SSL_DIR}/server.csr
SERVER_CERT=${SSL_DIR}/server.crt

# Ensure directories exist
mkdir -p "${SSL_DIR}" "${WWW_DIR}" "${LOG_DIR}"
chown -R www-data:www-data "${WWW_DIR}" "${LOG_DIR}" "${SSL_DIR}"
chmod 700 "${SSL_DIR}" || true

# Generate CA and server cert if missing
if [ ! -f "${CA_CERT}" ] || [ ! -f "${CA_KEY}" ]; then
  echo "Generating private CA (4096-bit RSA)..."
  openssl genrsa -out "${CA_KEY}" 4096
  openssl req -x509 -new -nodes -key "${CA_KEY}" -sha256 -days 3650 \
    -subj "/C=US/ST=Florida/L=Lehigh/O=PrivateCA/OU=Dev/CN=local-ca" \
    -out "${CA_CERT}"
  chmod 600 "${CA_KEY}"
fi

if [ ! -f "${SERVER_CERT}" ] || [ ! -f "${SERVER_KEY}" ]; then
  echo "Generating server key and CSR (4096-bit RSA)..."
  openssl genrsa -out "${SERVER_KEY}" 4096
  openssl req -new -key "${SERVER_KEY}" \
    -subj "/C=US/ST=Florida/L=Lehigh/O=LocalServer/OU=Dev/CN=localhost" \
    -out "${SERVER_CSR}"

  echo "Signing server certificate with CA..."
  openssl x509 -req -in "${SERVER_CSR}" -CA "${CA_CERT}" -CAkey "${CA_KEY}" \
    -CAcreateserial -out "${SERVER_CERT}" -days 3650 -sha256

  chmod 600 "${SERVER_KEY}"
fi

# Ensure Apache ServerName is set (update global config if needed)
APACHE_CONF="/etc/apache2/apache2.conf"
if ! grep -q "^ServerName" "${APACHE_CONF}"; then
  echo "ServerName localhost" >> "${APACHE_CONF}"
fi

# Print network tools output for debugging (ping and netstat)
echo "=== ping 127.0.0.1 (one packet) ==="
ping -c 1 127.0.0.1 || true

echo "=== netstat -tulpen (listening sockets) ==="
netstat -tulpen || true

# Ensure log files exist and are writable
touch "${LOG_DIR}/error.log" "${LOG_DIR}/access.log" "${LOG_DIR}/error-ssl.log" "${LOG_DIR}/access-ssl.log"
chown -R www-data:www-data "${LOG_DIR}"

# Start apache in foreground (CMD provides apache2ctl -D FOREGROUND)
exec "$@"