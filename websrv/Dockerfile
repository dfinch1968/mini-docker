# Use Debian slim for predictable package names
FROM debian:stable-slim

ENV APACHE_RUN_USER=www-data \
    APACHE_RUN_GROUP=www-data \
    APACHE_LOG_DIR=/pv/logs \
    PV_ROOT=/pv \
    WWW_DIR=/pv/xxwww \
    SSL_DIR=/pv/ssl

# Install apache2, openssl, ping, netstat (net-tools)
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      apache2 \
      openssl \
      iputils-ping \
      net-tools \
      ca-certificates && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Create PV directories (will be persisted by host mount)
RUN mkdir -p ${WWW_DIR} ${APACHE_LOG_DIR} ${SSL_DIR} && \
    chown -R www-data:www-data ${WWW_DIR} ${APACHE_LOG_DIR} ${SSL_DIR}

# Copy Apache site configuration and entrypoint
COPY apache-site.conf /etc/apache2/sites-available/000-default.conf
COPY apache-ssl.conf /etc/apache2/sites-available/default-ssl.conf
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Enable required modules and default SSL site
RUN a2enmod ssl headers rewrite && \
    a2enmod autoindex && \
    a2ensite default-ssl.conf || true

# Expose HTTP and HTTPS
EXPOSE 80 443

# Use entrypoint to generate CA/certs and start apache
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["apache2ctl", "-D", "FOREGROUND"]